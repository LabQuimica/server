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

CREATE TABLE `contenedores`(
    `id_contenedor` TINYINT AUTO_INCREMENT PRIMARY KEY,
    `descripcion` VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE `grupo`(
    `id_grupo` TINYINT AUTO_INCREMENT PRIMARY KEY,
    `grupo` VARCHAR(100) NOT NULL,
    `semestre` TINYINT NOT NULL
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
    FOREIGN KEY (`fk_marca_item`) REFERENCES `marcas`(`id_marca`)
) ENGINE=InnoDB;

CREATE TABLE `materiales`(
    `id_material` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_materiales` INT NOT NULL,
    FOREIGN KEY (`fk_items_materiales`) REFERENCES `items`(`id_item`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `kits`(
    `id_kit` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_kits` INT NOT NULL,
    `caja` VARCHAR(25),
    `contenido` VARCHAR(255),
    `cantidad_kits` TINYINT,
    `link` VARCHAR(255),
    FOREIGN KEY (`fk_items_kits`) REFERENCES `items`(`id_item`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `sensores`(
    `id_sensor` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_sensores` INT NOT NULL,
    `link` VARCHAR(255),
    FOREIGN KEY (`fk_items_sensores`) REFERENCES `items`(`id_item`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `liquidos`(
    `id_liquidos` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_liquidos` INT NOT NULL,
    `fk_contenedores_liquidos` TINYINT NOT NULL,
    FOREIGN KEY (`fk_items_liquidos`) REFERENCES `items`(`id_item`),
    FOREIGN KEY (`fk_contenedores_liquidos`) REFERENCES `contenedores`(`id_contenedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `solidos`(
    `id_solido` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_solidos` INT NOT NULL,
    `fk_contenedores_solidos` TINYINT NOT NULL,
    FOREIGN KEY (`fk_items_solidos`) REFERENCES `items`(`id_item`),
    FOREIGN KEY (`fk_contenedores_solidos`) REFERENCES `contenedores`(`id_contenedor`)
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
    FOREIGN KEY (`fk_practicas_pm`) REFERENCES `practicas`(`id_practica`),
    FOREIGN KEY (`fk_items_pm`) REFERENCES `items`(`id_item`)
) ENGINE=InnoDB;

CREATE TABLE `practicas_asignadas`(
    `id_pa` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_practicas_pa` INT NOT NULL,
    `fk_grupo_pa` TINYINT NOT NULL COMMENT 'grupo a quien le asigno la practica',
    `fk_profesor_users_pa` INT NOT NULL COMMENT 'profesor que la asigno',
    `fecha_asignada` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `fecha_entrega` TIMESTAMP NOT NULL,
    `status` ENUM('pendiente', 'progreso', 'completada', 'cancelada') NOT NULL DEFAULT 'pendiente',
    `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_practicas_pa`) REFERENCES `practicas`(`id_practica`),
    FOREIGN KEY (`fk_grupo_pa`) REFERENCES `grupo`(`id_grupo`),
    FOREIGN KEY (`fk_profesor_users_pa`) REFERENCES `users`(`id_user`)
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

INSERT INTO users (name, email, password) VALUES
 ('Jhon', 'dev@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Jane', 'dev1@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Hannibal', 'dev2@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Lecter', 'dev3@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi'),
 ('Profesor', 'dev4@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi');

INSERT INTO marcas (nombre) VALUES
('Generica'),
('Dedutel'),
('Reasol'),
('PHYWE');

INSERT INTO contenedores (descripcion) VALUES
('Frasco ambar'),
('Bote de plástico'),
('Botella de plástico'),
('Contenedor de vidrio');

INSERT INTO grupo (grupo, semestre) VALUES
-- Semestre 1
('biologia celular', 1),
('biotecnologia y sociedad', 1),
('calculo diferencial e integral', 1),
('comunic. y sist. de informacion (taller)', 1),
('fisica de la energia', 1),
('fisica del movimiento', 1),
('ingles i', 1),
('planeacion', 1),
('programacion (taller)', 1),
('quimica general', 1),
-- Semestre 2
('algebra vectorial', 2),
('estadistica', 2),
('ingles ii', 2),
('lab. tec. microbiologicas', 2),
('quimica organica', 2),
('relaciones laborales', 2),
('termodinamica i', 2),
-- Semestre 3
('aplicaciones matematicas (taller)', 3),
('balance de materia y energia', 3),
('ecuaciones diferenciales', 3),
('etica (taller)', 3),
('fisiologia celular', 3),
('ingles iii', 3),
('lab. de bioingenieria', 3),
('lab. de biorreactores', 3),
('metodos cuantitativos', 3),
('termodinamica ii', 3),
-- Semestre 4
('electromecanica de procesos', 4),
('fenomenos de transporte', 4),
('dinamica y control de bioprocesos', 4),
('ingenieria enzimatica', 4),
('lab. biotecnologia molecular', 4),
('lab. de bioseparaciones', 4),
('metodos numericos (taller)', 4),
-- Semestre 5
('administracion de la produccion', 5),
('biotecnologia de la resp.inmune', 5),
('lab. de bioconversiones', 5),
('mecanica de fluidos y solidos', 5),
('procs. de transf.de calor', 5),
('proteccion ambiental', 5),
('sistemas de calidad', 5),
('tec.de recombinacion genetica', 5),
-- Semestre 6
('administracion de proyectos', 6),
('bioseparaciones fluido-fluido', 6),
('bioseparaciones mecanicas', 6),
('bioseparaciones solido-fluido', 6),
('ingenieria de biorreactores', 6),
('ingenieria celular', 6),
('topicos selectos de biotecnologia i', 6),
('topicos selectos de biotecnologia ii', 6),
('topicos selectos de diseño i', 6),
('topicos selectos de diseño ii', 6),
-- Semestre 7
('diseño de procesos de separacion (taller)', 7),
('electiva i', 7),
('electiva ii', 7),
('electiva iii', 7),
('sintesis y analisis de bioprocesos', 7),
('tec.de la prod.de biomoleculas', 7),
-- Semestre 8
('diseño de plantas (taller)', 8),
('estancia de titulacion', 8),
('formulacion y evaluacion de proyectos', 8);

-- Inserción de Kits
INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (1, 'KIT001', 'Kit de Herramientas', 'kits', 'Almacén A', 10.00, 'Kit completo');
INSERT INTO kits (fk_items_kits, caja, contenido, cantidad_kits, link)
VALUES (LAST_INSERT_ID(), 'Caja 1', 'Herramientas varias', 5, 'http://ejemplo.com/kit1');

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (2, 'KIT002', 'Kit de Electricidad', 'kits', 'Almacén B', 15.00, 'Kit básico');
INSERT INTO kits (fk_items_kits, caja, contenido, cantidad_kits, link)
VALUES (LAST_INSERT_ID(), 'Caja 2', 'Cables y conectores', 10, 'http://ejemplo.com/kit2');

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (3, 'KIT003', 'Kit de Laboratorio', 'kits', 'Almacén C', 20.00, 'Kit avanzado');
INSERT INTO kits (fk_items_kits, caja, contenido, cantidad_kits, link)
VALUES (LAST_INSERT_ID(), 'Caja 3', 'Instrumentos de medición', 8, 'http://ejemplo.com/kit3');

-- Inserción de Sensores
INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (1, 'SEN001', 'Sensor de Temperatura', 'sensores', 'Laboratorio', 5.00, 'Sensor digital');
INSERT INTO sensores (fk_items_sensores, link)
VALUES (LAST_INSERT_ID(), 'http://ejemplo.com/sensor1');

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (2, 'SEN002', 'Sensor de Humedad', 'sensores', 'Invernadero', 3.00, 'Sensor analógico');
INSERT INTO sensores (fk_items_sensores, link)
VALUES (LAST_INSERT_ID(), 'http://ejemplo.com/sensor2');

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (3, 'SEN003', 'Sensor de Presión', 'sensores', 'Taller', 7.00, 'Sensor de alta precisión');
INSERT INTO sensores (fk_items_sensores, link)
VALUES (LAST_INSERT_ID(), 'http://ejemplo.com/sensor3');

-- Inserción de Materiales
INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (1, 'MAT001', 'Tornillos', 'materiales', 'Almacén D', 100.00, 'Tornillos de acero');
INSERT INTO materiales (fk_items_materiales)
VALUES (LAST_INSERT_ID());

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (2, 'MAT002', 'Tuercas', 'materiales', 'Almacén E', 200.00, 'Tuercas de acero');
INSERT INTO materiales (fk_items_materiales)
VALUES (LAST_INSERT_ID());

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (3, 'MAT003', 'Arandelas', 'materiales', 'Almacén F', 150.00, 'Arandelas de acero');
INSERT INTO materiales (fk_items_materiales)
VALUES (LAST_INSERT_ID());

-- Inserción de Líquidos
INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (1, 'LIQ001', 'Agua Destilada', 'liquidos', 'Laboratorio', 5.00, 'Para experimentos');
INSERT INTO liquidos (fk_items_liquidos, fk_contenedores_liquidos)
VALUES (LAST_INSERT_ID(), 1);

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (2, 'LIQ002', 'Etanol', 'liquidos', 'Laboratorio', 10.00, 'Para limpieza');
INSERT INTO liquidos (fk_items_liquidos, fk_contenedores_liquidos)
VALUES (LAST_INSERT_ID(), 2);

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (3, 'LIQ003', 'Aceite de Silicona', 'liquidos', 'Taller', 2.00, 'Para lubricación');
INSERT INTO liquidos (fk_items_liquidos, fk_contenedores_liquidos)
VALUES (LAST_INSERT_ID(), 3);

-- Inserción de Sólidos
INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (1, 'SOL001', 'Hierro', 'solidos', 'Almacén G', 50.00, 'Para construcción');
INSERT INTO solidos (fk_items_solidos, fk_contenedores_solidos)
VALUES (LAST_INSERT_ID(), 1);

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (2, 'SOL002', 'Cobre', 'solidos', 'Almacén H', 30.00, 'Para cableado');
INSERT INTO solidos (fk_items_solidos, fk_contenedores_solidos)
VALUES (LAST_INSERT_ID(), 2);

INSERT INTO items (fk_marca_item, num_serie, nombre, tipo, ubicacion, cantidad, observacion)
VALUES (3, 'SOL003', 'Aluminio', 'solidos', 'Almacén I', 40.00, 'Para estructuras');
INSERT INTO solidos (fk_items_solidos, fk_contenedores_solidos)
VALUES (LAST_INSERT_ID(), 3);

INSERT INTO grupo_alumnos (fk_grupo_ga, fk_alumno_users_ga) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(1, 5),
(2, 5);

INSERT INTO `practicas` (`fk_profesor_users_practica`, `nombre`, `descripcion`) VALUES
(5, 'Práctica de Matemáticas', 'Resolver problemas de álgebra y geometría.'),
(5, 'Práctica de Física', 'Experimentos relacionados con las leyes de Newton.'),
(5, 'Práctica de Química', 'Realizar reacciones químicas básicas.');

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

INSERT INTO `practicas_asignadas` (`fk_practicas_pa`, `fk_grupo_pa`, `fk_profesor_users_pa`, `fecha_entrega`) VALUES
(1, 1, 5, '2025-01-27'),
(2, 2, 5, '2025-01-28'),
(3, 1, 5, '2025-01-29'),
(3, 2, 5, '2025-01-30');

INSERT INTO `vale_alumno` (`fk_pa_vale`, `fk_alumno_users_vale`, `status`, `observaciones`) VALUES
(1, 1, 'pendiente', 'Falta material'),
(2, 3, 'progreso', 'En revisión'),
(3, 2, 'completada', 'Entregada'),
(4, 4, 'cancelada', 'No se realizó');

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