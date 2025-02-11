-- mysql -u root -p
-- $2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi

drop schema laboratorio;

CREATE DATABASE IF NOT EXISTS laboratorio;
USE laboratorio;

CREATE TABLE `users`(
    `id_user` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `rol` ENUM('administrador', 'profesor', 'alumno') NOT NULL DEFAULT 'alumno',
    `active` BOOLEAN NOT NULL DEFAULT '1',
    UNIQUE (`email`)
) ENGINE=InnoDB;

CREATE TABLE `marcas`(
    `id_marca` TINYINT AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE `grupo`(
    `id_grupo` TINYINT AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `semestre` VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `grupo_alumnos`(
    `id_ga` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_grupo_ga` TINYINT NOT NULL,
    `fk_alumno_users_ga` INT NOT NULL,
    FOREIGN KEY (`fk_grupo_ga`) REFERENCES `grupo`(`id_grupo`),
    FOREIGN KEY (`fk_alumno_users_ga`) REFERENCES `users`(`id_user`)
) ENGINE=InnoDB;

CREATE TABLE `items`(
    `id_item` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_marca_item` TINYINT NOT NULL,
    `num_serie` VARCHAR(100) NOT NULL,
    `nombre` VARCHAR(255) NOT NULL,
    `tipo` ENUM('kits', 'sensores', 'materiales', 'liquidos', 'solidos') NOT NULL,
    `ubicacion` VARCHAR(255),
    `cantidad` DECIMAL(8, 2) NOT NULL,
    `observacion` VARCHAR(255),
    `status` BOOLEAN NOT NULL DEFAULT '1',
    `especial` VARCHAR(300),
    `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_marca_item`) REFERENCES `marcas`(`id_marca`)
) ENGINE=InnoDB;

CREATE TABLE `kits`(
    `fk_kit` INT NOT NULL,
    `fk_items_kits` INT NOT NULL,
    `caja` VARCHAR(50),
    PRIMARY KEY (`fk_kit`, `fk_items_kits`),
    FOREIGN KEY (`fk_kit`) REFERENCES `items`(`id_item`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`fk_items_kits`) REFERENCES `items`(`id_item`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `practicas`(
    `id_practica` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_profesor_users_practica` INT NOT NULL,
    `nombre` VARCHAR(255) NOT NULL,
    `descripcion` TEXT,
    `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_profesor_users_practica`) REFERENCES `users`(`id_user`)
) ENGINE=InnoDB;

CREATE TABLE `practicas_materiales`(
    `id_pm` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_practicas_pm` INT NOT NULL,
    `fk_items_pm` INT NOT NULL,
    `cantidad` DECIMAL(8, 2) NOT NULL,
    `contable` BOOLEAN NOT NULL DEFAULT '1',
    FOREIGN KEY (`fk_practicas_pm`) REFERENCES `practicas`(`id_practica`),
    FOREIGN KEY (`fk_items_pm`) REFERENCES `items`(`id_item`)
) ENGINE=InnoDB;

CREATE TABLE `practicas_asignadas`(
    `id_pa` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_practicas_pa` INT NOT NULL,
    `fk_grupo_pa` TINYINT NOT NULL COMMENT 'grupo a quien le asigno la practica',
    `fecha_asignada` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `fecha_entrega` TIMESTAMP NOT NULL,
    `status` ENUM('pendiente', 'progreso', 'completada', 'cancelada') NOT NULL DEFAULT 'pendiente',
    `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_practicas_pa`) REFERENCES `practicas`(`id_practica`),
    FOREIGN KEY (`fk_grupo_pa`) REFERENCES `grupo`(`id_grupo`)
) ENGINE=InnoDB;

CREATE TABLE `vale_alumno`(
    `id_vale` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_pa_vale` INT NOT NULL,
    `fk_alumno_users_vale` INT NOT NULL COMMENT 'Usuario a quien es responsable',
    `status` ENUM('pendiente', 'progreso', 'completada', 'cancelada') NOT NULL,
    `observaciones` VARCHAR(255),
    `fecha_solicitada` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_pa_vale`) REFERENCES `practicas_asignadas`(`id_pa`),
    FOREIGN KEY (`fk_alumno_users_vale`) REFERENCES `users`(`id_user`)
) ENGINE=InnoDB;

CREATE TABLE `vale_profesor` (
    `id_vale_profesor` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_pa_vale_profesor` INT NOT NULL COMMENT 'Práctica asignada a la que pertenece',
    `fk_items_vale_profesor` INT NOT NULL COMMENT 'Material asociado',
    `cantidad_acumulada` DECIMAL(8, 2) NOT NULL DEFAULT 0 COMMENT 'Cantidad acumulada de este material',
    `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_pa_vale_profesor`) REFERENCES `practicas_asignadas`(`id_pa`),
    FOREIGN KEY (`fk_items_vale_profesor`) REFERENCES `items`(`id_item`)
) ENGINE=InnoDB;

DELIMITER $$

CREATE TRIGGER `after_vale_alumno_insert`
AFTER INSERT ON `vale_alumno`
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE item_id INT;
    DECLARE item_cantidad DECIMAL(8, 2);
    DECLARE item_contable BOOLEAN;

    -- Cursor para recorrer los materiales de la práctica asignada
    DECLARE cur CURSOR FOR
        SELECT pm.fk_items_pm, pm.cantidad, pm.contable
        FROM practicas_materiales pm
        WHERE pm.fk_practicas_pm = (
            SELECT pa.fk_practicas_pa
            FROM practicas_asignadas pa
            WHERE pa.id_pa = NEW.fk_pa_vale
        );

    -- Declarar un manejador para el final del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO item_id, item_cantidad, item_contable;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Solo acumular si el material es contable (contable = 1)
        IF item_contable THEN
            -- Verificar si ya existe un registro en vale_profesor para este material
            IF EXISTS (
                SELECT 1
                FROM vale_profesor
                WHERE fk_pa_vale_profesor = NEW.fk_pa_vale
                AND fk_items_vale_profesor = item_id
            ) THEN
                -- Actualizar la cantidad acumulada
                UPDATE vale_profesor
                SET cantidad_acumulada = cantidad_acumulada + item_cantidad
                WHERE fk_pa_vale_profesor = NEW.fk_pa_vale
                AND fk_items_vale_profesor = item_id;
            ELSE
                -- Insertar un nuevo registro en vale_profesor
                INSERT INTO vale_profesor (fk_pa_vale_profesor, fk_items_vale_profesor, cantidad_acumulada)
                VALUES (NEW.fk_pa_vale, item_id, item_cantidad);
            END IF;
        END IF;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

 -- Contrasena de los usuarios: 123456
INSERT INTO users (name, email, password) VALUES
 ('Jhon', 'dev@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Jane', 'dev1@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Hannibal', 'dev2@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Lecter', 'dev3@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Eric', 'dev4@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
  ('Alice', 'user1@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Bob', 'user2@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Charlie', 'user3@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Diana', 'user4@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Eve', 'user5@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Frank', 'user6@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Grace', 'user7@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Henry', 'user8@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Ivy', 'user9@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Jack', 'user10@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Karen', 'user11@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Louis', 'user12@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Martha', 'user13@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Nathan', 'user14@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Olivia', 'user15@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Peter', 'user16@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Quincy', 'user17@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Rachel', 'user18@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Sam', 'user19@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Tina', 'user20@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi');


INSERT INTO marcas (nombre) VALUES
('Generica'),
('Dedutel'),
('Reasol'),
('PHYWE');

INSERT INTO grupo (nombre, semestre) VALUES
-- Semestre 1
('biologia celular', '1BM1'),
('biotecnologia y sociedad', '1BM1'),
('calculo diferencial e integral', '1BM1'),
('comunic. y sist. de informacion (taller)', '1BM1'),
('fisica de la energia', '1BM1'),
('fisica del movimiento', '1BM1'),
('ingles i', '1BM1'),
('planeacion', '1BM1'),
('programacion (taller)', '1BM1'),
('quimica general', '1BM1'),
-- Semestre 2
('algebra vectorial', '2BV1'),
('estadistica', '2BV1'),
('ingles ii', '2BV1'),
('lab. tec. microbiologicas', '2BV1'),
('quimica organica', '2BV1'),
('relaciones laborales', '2BV1'),
('termodinamica i', '2BV1'),
-- Semestre 3
('aplicaciones matematicas (taller)', '3BM1'),
('balance de materia y energia', '3BM1'),
('ecuaciones diferenciales', '3BM1'),
('etica (taller)', '3BM1'),
('fisiologia celular', '3BM1'),
('ingles iii', '3BM1'),
('lab. de bioingenieria', '3BM1'),
('lab. de biorreactores', '3BM1'),
('metodos cuantitativos', '3BM1'),
('termodinamica ii', '3BM1'),
-- Semestre 4
('electromecanica de procesos', '4BV1'),
('fenomenos de transporte', '4BV1'),
('dinamica y control de bioprocesos', '4BV1'),
('ingenieria enzimatica', '4BV1'),
('lab. biotecnologia molecular', '4BV1'),
('lab. de bioseparaciones', '4BV1'),
('metodos numericos (taller)', '4BV1'),
-- Semestre 5
('administracion de la produccion', '5BM1'),
('biotecnologia de la resp.inmune',  '5BM1'),
('lab. de bioconversiones',  '5BM1'),
('mecanica de fluidos y solidos',  '5BM1'),
('procs. de transf.de calor',  '5BM1'),
('proteccion ambiental',  '5BM1'),
('sistemas de calidad',  '5BM1'),
('tec.de recombinacion genetica',  '5BM1'),
-- Semestre 6
('administracion de proyectos', '6BV1'),
('bioseparaciones fluido-fluido', '6BV1'),
('bioseparaciones mecanicas', '6BV1'),
('bioseparaciones solido-fluido', '6BV1'),
('ingenieria de biorreactores', '6BV1'),
('ingenieria celular', '6BV1'),
('topicos selectos de biotecnologia i', '6BV1'),
('topicos selectos de biotecnologia ii', '6BV1'),
('topicos selectos de diseño i', '6BV1'),
('topicos selectos de diseño ii', '6BV1'),
-- Semestre 7
('diseño de procesos de separacion (taller)', '7BM1'),
('electiva i', '7BM1'),
('electiva ii', '7BM1'),
('electiva iii', '7BM1'),
('sintesis y analisis de bioprocesos', '7BM1'),
('tec.de la prod.de biomoleculas', '7BM1'),
-- Semestre 8
('diseño de plantas (taller)', '8BV1'),
('estancia de titulacion', '8BV1'),
('formulacion y evaluacion de proyectos', '8BV1');

INSERT INTO grupo_alumnos (fk_grupo_ga, fk_alumno_users_ga) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(1, 5),
(2, 5);
INSERT INTO `items` (`fk_marca_item`, `num_serie`, `nombre`, `tipo`, `ubicacion`, `cantidad`, `observacion`, `especial`) VALUES
(1, '123456', 'Kit de Biología', 'kits', 'Aula 1', 100.00, 'Kit de biología básico', 'https:');


INSERT INTO `practicas` (`fk_profesor_users_practica`, `nombre`, `descripcion`) VALUES
(5, 'Práctica de Matemáticas', 'Resolver problemas de álgebra y geometría.');
-- (5, 'Práctica de Física', 'Experimentos relacionados con las leyes de Newton.'),
-- (5, 'Práctica de Química', 'Realizar reacciones químicas básicas.');

-- INSERT INTO `practicas_materiales` (`fk_practicas_pm`, `fk_items_pm`, `cantidad`) VALUES
-- (1, 1, 5.00),
-- (1, 2, 10.00),
-- (1, 3, 15.00),
-- (2, 4, 3.00),
-- (2, 5, 6.00),
-- (2, 6, 9.00),
-- (3, 7, 2.00),
-- (3, 8, 4.00),
-- (3, 9, 6.00),
-- (3, 10, 6.00),
-- (3, 11, 6.00),
-- (3, 12, 6.00),
-- (3, 13, 6.00);

-- INSERT INTO `practicas_asignadas` (`fk_practicas_pa`, `fk_grupo_pa`, `fecha_entrega`) VALUES
-- (1, 1, '2025-01-27');

-- INSERT INTO `vale_alumno` (`fk_pa_vale`, `fk_alumno_users_vale`, `status`, `observaciones`) VALUES
-- (1, 6, 'pendiente', 'Pendiente de aprobación');

-- INSERT INTO `vale_alumno` (`fk_pa_vale`, `fk_alumno_users_vale`, `status`, `observaciones`) VALUES
-- (1, 1, 'pendiente', 'Pendiente de revisión adicional');

-- #####################################
--          FUNCIONES DE PRUEBA
-- #####################################

-- VIsualización de la data de la table kits con join
-- SELECT
--     items.id_item,
--     items.fk_marca_item,
--     items.num_serie,
--     items.nombre,
--     items.tipo,
--     items.ubicacion,
--     items.cantidad,
--     items.observacion,
--     kits.id_kit,
--     kits.caja,
--     kits.contenido,
--     kits.cantidad_kits,
--     kits.link
-- FROM
--     items
-- JOIN
--     kits ON items.id_item = kits.fk_items_kits;

-- *****************************

-- Test de update automatico al modificar la tabla de practicas
-- UPDATE `practicas` SET `nombre` = 'Práctica de Matemáticas Avanzadas' WHERE `id_practica` = 1;
-- SELECT * FROM `practicas`;

-- *****************************

-- Test de vales de una practica
-- SELECT
--     va.id_vale,
--     va.status AS estado_vale,
--     va.observaciones AS observaciones_vale,
--     va.fecha_solicitada,
--     pa.id_pa,
--     pa.fecha_asignada,
--     pa.fecha_entrega,
--     p.id_practica,
--     p.nombre AS nombre_practica,
--     p.descripcion AS descripcion_practica,
--     p.fecha_creacion,
--     p.fecha_modificacion,
--     pm.id_pm,
--     pm.cantidad AS cantidad_material,
--     i.id_item,
--     i.nombre AS nombre_item,
--     i.tipo AS tipo_item,
--     i.ubicacion,
--     i.cantidad AS cantidad_disponible,
--     i.observacion AS observacion_item
-- FROM
--     vale_alumno va
-- JOIN
--     practicas_asignadas pa ON va.fk_pa_vale = pa.id_pa
-- JOIN
--     practicas p ON pa.fk_practicas_pa = p.id_practica
-- JOIN
--     practicas_materiales pm ON p.id_practica = pm.fk_practicas_pm
-- JOIN
--     items i ON pm.fk_items_pm = i.id_item
-- WHERE
--     va.id_vale = 4;