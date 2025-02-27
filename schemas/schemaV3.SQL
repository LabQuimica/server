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
    `codigo` VARCHAR(30),
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
    `num_equipos` TINYINT NOT NULL,
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
    `fecha_inicio` TIMESTAMP NOT NULL,
    `fecha_fin` TIMESTAMP NOT NULL,
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

INSERT INTO users (name, email, password, rol) VALUES
 ('Quincy', 'prof1@prof.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','profesor'),
 ('Rachel', 'prof2@prof.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','profesor'),
 ('Sam', 'prof3@prof.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','profesor'),
 ('Tina', 'prof4@prof.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','profesor');

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
(1, '123456', 'Kit de Biología', 'kits', 'Aula 1', 5.00, 'Kit de biología básico', 'https:'),
(1, '123457', 'Kit de Física', 'kits', 'Aula 2', 10.00, 'Kit de física básico', 'https://'),
(1, '123458', 'Kit de Química', 'kits', 'Aula 3', 15.00, 'Kit de química básico', 'https://www.google.com'),
(1, '123459', 'Sensor de Temperatura', 'sensores', 'Laboratorio 1', 3.00, 'Sensor de temperatura para medir en grados Celsius', 'https://www.google.com'),
(2, '123460', 'Sensor de Luz', 'sensores', 'Laboratorio 2', 6.00, 'Sensor de luz para medir en lux', 'https://www.google.com'),
(2, '123461', 'Sensor de Sonido', 'sensores', 'Laboratorio 3', 9.00, 'Sensor de sonido para medir en decibeles', 'Frasco ámbar'),
(2, '123462', 'Ácido Clorhídrico', 'liquidos', 'Almacén 1', 2.00, 'Acido clorhídrico', 'https://www.google.com'),
(3, '123463', 'Sulfato de Cobre', 'solidos', 'Almacén 2', 4.00, 'Sulfato de cobre', 'Bote de plástico'),
(3, '123464', 'Sulfato de Magnesio', 'solidos', 'Almacén 3', 6.00, 'Sulfato de magnesio', 'Bote de plástico'),
(3, '123465', 'Sulfato de Zinc', 'solidos', 'Almacén 4', 6.00, 'Sulfato de zinc', 'Bote de plástico'),
(4, '123466', 'Sulfato de Hierro', 'solidos', 'Almacén 5', 6.00, 'Sulfato de hierro', 'Bote de plástico'),
(4, '123467', 'Sulfato de Plata', 'solidos', 'Almacén 6', 6.00, 'Sulfato de plata', 'Bote de plástico'),
(4, '123468', 'Sulfato de Aluminio', 'solidos', 'Almacén 7', 6.00, 'Sulfato de aluminio', 'Bote de plástico');


INSERT INTO `practicas` (`fk_profesor_users_practica`, `nombre`, `descripcion` , `num_equipos`) VALUES
(5, 'Práctica de Matemáticas', 'Resolver problemas de álgebra y geometría.', 5),
(5, 'Práctica de Física', 'Experimentos relacionados con las leyes de Newton.', 4),
(5, 'Práctica de Química', 'Realizar reacciones químicas básicas.', 5);

INSERT INTO `practicas_materiales` (`fk_practicas_pm`, `fk_items_pm`, `cantidad`) VALUES
(1, 1, 5.00),
(1, 2, 10.00),
(1, 3, 15.00),
(2, 4, 3.00),
(2, 5, 6.00),
(2, 6, 9.00),
(3, 7, 2.00),
(3, 8, 4.00),
(3, 9, 6.00),
(3, 10, 6.00),
(3, 11, 6.00),
(3, 12, 6.00),
(3, 13, 6.00);

INSERT INTO `practicas_asignadas` (`fk_practicas_pa`, `fk_grupo_pa`, `fecha_entrega`, `status`) VALUES
(1, 1, '2025-01-27', 'pendiente'),
(2, 2, '2025-01-28', 'progreso'),
(3, 1, '2025-01-29', 'completada'),
(3, 2, '2025-01-30', 'cancelada');


INSERT INTO `vale_alumno` (`fk_pa_vale`, `fk_alumno_users_vale`, `status`, `observaciones`) VALUES
(1, 6, 'pendiente', 'Pendiente de aprobación'),
(2, 7, 'progreso', 'En proceso de revisión'),
(3, 8, 'completada', 'Material entregado'),
(4, 9, 'cancelada', 'Solicitud cancelada por el alumno'),
(1, 10, 'pendiente', 'Pendiente por asignación'),
(2, 11, 'progreso', 'Revisión en curso'),
(3, 12, 'completada', 'Material entregado correctamente'),
(4, 13, 'cancelada', 'Cancelado por falta de pago'),
(1, 14, 'pendiente', 'A la espera de confirmación'),
(2, 15, 'progreso', 'Revisando detalles del material'),
(3, 16, 'completada', 'Entrega completada con éxito'),
(4, 17, 'cancelada', 'Cancelada por falta de información'),
(1, 18, 'pendiente', 'Esperando disponibilidad del material'),
(2, 19, 'progreso', 'En análisis por el departamento'),
(3, 20, 'completada', 'Recibido por el alumno'),
(4, 21, 'cancelada', 'Cancelado por solicitud del alumno'),
(1, 22, 'pendiente', 'Revisión inicial pendiente'),
(2, 23, 'progreso', 'En revisión detallada'),
(3, 24, 'completada', 'Material recibido'),
(4, 25, 'cancelada', 'Cancelado por falta de material');

INSERT INTO `vale_alumno` (`fk_pa_vale`, `fk_alumno_users_vale`, `status`, `observaciones`) VALUES
(1, 1, 'pendiente', 'Pendiente de revisión adicional'),
(2, 3, 'progreso', 'Se requiere validación extra'),
(3, 2, 'completada', 'Entregado y confirmado'),
(4, 4, 'cancelada', 'Cancelado por duplicidad'),
(1, 6, 'pendiente', 'Material no disponible aún'),
(2, 7, 'progreso', 'Revisión secundaria en curso'),
(3, 8, 'completada', 'Entrega efectuada correctamente'),
(4, 9, 'cancelada', 'Cancelación solicitada por el usuario'),
(1, 10, 'pendiente', 'Faltan documentos para completar'),
(2, 11, 'progreso', 'Avanzando en la revisión'),
(3, 12, 'completada', 'Material recibido exitosamente'),
(4, 13, 'cancelada', 'Anulado por error en solicitud'),
(1, 14, 'pendiente', 'Esperando confirmación del departamento'),
(2, 15, 'progreso', 'Revisión avanzada en curso'),
(3, 16, 'completada', 'Entrega cerrada con éxito'),
(4, 17, 'cancelada', 'Cancelado por duplicación de solicitud'),
(1, 18, 'pendiente', 'Validación de material en espera'),
(2, 19, 'progreso', 'Actualización pendiente por el usuario'),
(3, 20, 'completada', 'Finalizado y material recibido'),
(4, 21, 'cancelada', 'Cancelación aprobada por administración'),
(1, 1, 'pendiente', 'Revisión inicial retrasada'),
(2, 3, 'progreso', 'En revisión nuevamente'),
(3, 6, 'completada', 'Entrega adicional completada'),
(4, 9, 'cancelada', 'Cancelado debido a inactividad'),
(1, 12, 'pendiente', 'Pendiente de evaluación'),
(2, 15, 'progreso', 'Avanzando en el proceso'),
(3, 20, 'completada', 'Cerrado con éxito'),
(4, 24, 'cancelada', 'Anulación realizada por error administrativo');

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