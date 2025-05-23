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
    `fecha_asignada` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status` ENUM('pendiente', 'progreso', 'completada', 'cancelada') NOT NULL DEFAULT 'pendiente',
    `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_practicas_pa`) REFERENCES `practicas`(`id_practica`),
    FOREIGN KEY (`fk_grupo_pa`) REFERENCES `grupo`(`id_grupo`)
) ENGINE=InnoDB;

CREATE TABLE `vale_alumno`(
    `id_vale` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_pa_vale` INT NOT NULL,
    `fk_alumno_users_vale` INT NOT NULL COMMENT 'Usuario a quien es responsable',
    `status` ENUM('pendiente', 'progreso', 'completada', 'cancelada', 'incompleto') NOT NULL,
    `observaciones` VARCHAR(255),
    `fecha_solicitada` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_pa_vale`) REFERENCES `practicas_asignadas`(`id_pa`),
    FOREIGN KEY (`fk_alumno_users_vale`) REFERENCES `users`(`id_user`)
) ENGINE=InnoDB;


 -- Contrasena de los usuarios: 123456
INSERT INTO users (name, email, password, codigo) VALUES
 ('Jhon', 'dev@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Jane', 'dev1@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Hannibal', 'dev2@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Lecter', 'dev3@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Eric', 'dev4@dev.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
  ('Alice', 'user1@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Bob', 'user2@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Charlie', 'user3@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Diana', 'user4@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Eve', 'user5@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Frank', 'user6@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Grace', 'user7@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Henry', 'user8@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Ivy', 'user9@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Jack', 'user10@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Karen', 'user11@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Louis', 'user12@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Martha', 'user13@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Nathan', 'user14@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Olivia', 'user15@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Peter', 'user16@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Quincy', 'user17@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Rachel', 'user18@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Sam', 'user19@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168'),
 ('Tina', 'user20@example.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi', '2022710168');

INSERT INTO users (name, email, password, rol) VALUES
 ('Quincy', 'prof1@prof.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','profesor'),
 ('Rachel', 'prof2@prof.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','profesor'),
 ('Sam', 'prof3@prof.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','profesor'),
 ('Tina', 'prof4@prof.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','profesor');

INSERT INTO users (name, email, password, rol) VALUES
 ('Quincy', 'admin@admin.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','administrador'),
 ('Rachel', 'admin1@admin.com', '$2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi','administrador');

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
(1, 3),
(1, 7),
(1, 10),
(2, 6),
(2, 8),
(2, 12),
(3, 2),
(3, 5),
(3, 9),
(3, 14),
(4, 1),
(4, 4),
(4, 11),
(4, 15),
(5, 2),
(5, 6),
(5, 13),
(5, 18),
(6, 3),
(6, 7),
(6, 10),
(6, 16),
(7, 1),
(7, 5),
(7, 9),
(7, 12),
(8, 2),
(8, 6),
(8, 14),
(8, 17),
(9, 3),
(9, 8),
(9, 11),
(9, 19),
(10, 4),
(10, 7),
(10, 13),
(10, 20),
(11, 1),
(11, 9),
(11, 15),
(11, 21),
(12, 2),
(12, 6),
(12, 12),
(12, 18),
(13, 3),
(13, 5),
(13, 10),
(13, 16),
(14, 4),
(14, 7),
(14, 14),
(14, 22),
(15, 1),
(15, 9),
(15, 13),
(15, 19),
(16, 2),
(16, 6),
(16, 11),
(16, 23),
(17, 3),
(17, 8),
(17, 15),
(17, 20),
(18, 4),
(18, 7),
(18, 12),
(18, 18),
(19, 1),
(19, 9),
(19, 14),
(19, 24),
(20, 2),
(20, 5),
(20, 10),
(20, 21),
(21, 3),
(21, 7),
(21, 13),
(21, 19),
(22, 4),
(22, 6),
(22, 12),
(22, 25),
(23, 1),
(23, 8),
(23, 15),
(23, 22),
(24, 2),
(24, 9),
(24, 11),
(24, 17),
(25, 3),
(25, 5),
(25, 10),
(25, 16),
(26, 4),
(26, 7),
(26, 14),
(26, 23),
(27, 1),
(27, 6),
(27, 13),
(27, 18),
(28, 2),
(28, 9),
(28, 12),
(28, 24),
(29, 3),
(29, 7),
(29, 11),
(29, 19),
(30, 4),
(30, 8),
(30, 14),
(30, 25),
(31, 1),
(31, 5),
(31, 10),
(31, 21),
(32, 2),
(32, 6),
(32, 15),
(32, 17),
(33, 3),
(33, 9),
(33, 13),
(33, 22),
(34, 4),
(34, 7),
(34, 12),
(34, 18),
(35, 1),
(35, 8),
(35, 14),
(35, 24),
(36, 2),
(36, 5),
(36, 11),
(36, 19),
(37, 3),
(37, 9),
(37, 15),
(37, 25),
(38, 4),
(38, 6),
(38, 10),
(38, 20),
(39, 1),
(39, 7),
(39, 13),
(39, 17),
(40, 2),
(40, 8),
(40, 12),
(40, 23),
(41, 3),
(41, 5),
(41, 14),
(41, 18),
(42, 4),
(42, 9),
(42, 11),
(42, 24),
(43, 1),
(43, 6),
(43, 10),
(43, 22),
(44, 2),
(44, 7),
(44, 15),
(44, 21),
(45, 3),
(45, 8),
(45, 12),
(45, 19),
(46, 4),
(46, 5),
(46, 13),
(46, 25),
(47, 1),
(47, 9),
(47, 14),
(47, 17),
(48, 2),
(48, 6),
(48, 11),
(48, 23),
(49, 3),
(49, 7),
(49, 10),
(49, 18),
(50, 4),
(50, 8),
(50, 15),
(50, 24),
(51, 1),
(51, 5),
(51, 12),
(51, 20),
(52, 2),
(52, 9),
(52, 13),
(52, 22),
(53, 3),
(53, 6),
(53, 14),
(53, 19),
(54, 4),
(54, 7),
(54, 11),
(54, 25),
(55, 1),
(55, 8),
(55, 10),
(55, 17),
(56, 2),
(56, 5),
(56, 15),
(56, 23),
(57, 3),
(57, 9),
(57, 12),
(57, 18),
(58, 4),
(58, 6),
(58, 13),
(58, 24),
(59, 1),
(59, 7),
(59, 11),
(59, 20),
(60, 2),
(60, 8),
(60, 14),
(60, 22),
(61, 3),
(61, 5),
(61, 10),
(61, 19);


INSERT INTO `items` (`fk_marca_item`, `num_serie`, `nombre`, `tipo`, `ubicacion`, `cantidad`, `observacion`, `especial`) VALUES
(1, '123456', 'Kit de Biología', 'kits', 'Aula 1', 50.00, 'Kit de biología básico', 'https:'),
(1, '123457', 'Kit de Física', 'kits', 'Aula 2', 100.00, 'Kit de física básico', 'https://'),
(1, '123458', 'Kit de Química', 'kits', 'Aula 3', 150.00, 'Kit de química básico', 'https://www.google.com'),
(1, '123459', 'Sensor de Temperatura', 'sensores', 'Laboratorio 1', 30.00, 'Sensor de temperatura para medir en grados Celsius', 'https://www.google.com'),
(2, '123460', 'Sensor de Luz', 'sensores', 'Laboratorio 2', 60.00, 'Sensor de luz para medir en lux', 'https://www.google.com'),
(2, '123461', 'Sensor de Sonido', 'sensores', 'Laboratorio 3', 90.00, 'Sensor de sonido para medir en decibeles', 'Frasco ámbar'),
(2, '123462', 'Ácido Clorhídrico', 'liquidos', 'Almacén 1', 20.00, 'Acido clorhídrico', 'https://www.google.com'),
(3, '123463', 'Sulfato de Cobre', 'solidos', 'Almacén 2', 40.00, 'Sulfato de cobre', 'Bote de plástico'),
(3, '123464', 'Sulfato de Magnesio', 'solidos', 'Almacén 3', 60.00, 'Sulfato de magnesio', 'Bote de plástico'),
(3, '123465', 'Sulfato de Zinc', 'solidos', 'Almacén 4', 60.00, 'Sulfato de zinc', 'Bote de plástico'),
(4, '123466', 'Sulfato de Hierro', 'solidos', 'Almacén 5', 60.00, 'Sulfato de hierro', 'Bote de plástico'),
(4, '123467', 'Sulfato de Plata', 'solidos', 'Almacén 6', 60.00, 'Sulfato de plata', 'Bote de plástico'),
(4, '123468', 'Sulfato de Aluminio', 'solidos', 'Almacén 7', 60.00, 'Sulfato de aluminio', 'Bote de plástico');

INSERT INTO `items` (`fk_marca_item`, `num_serie`, `nombre`, `tipo`, `ubicacion`, `cantidad`, `observacion`, `especial`) VALUES
(1, '123469', 'Kit de Robótica', 'kits', 'Aula 4', 20.00, 'Kit de robótica básico', 'https://www.ejemplo.com/robotica'),
(1, '123470', 'Kit de Electrónica', 'kits', 'Aula 5', 25.00, 'Kit de electrónica avanzada', 'https://www.ejemplo.com/electronica'),
(1, '123471', 'Kit de Programación', 'kits', 'Aula 6', 30.00, 'Kit de programación para principiantes', 'https://www.ejemplo.com/programacion'),
(2, '123472', 'Sensor de Humedad', 'sensores', 'Laboratorio 4', 40.00, 'Sensor de humedad para medir en porcentaje', 'https://www.ejemplo.com/humedad'),
(2, '123473', 'Sensor de Presión', 'sensores', 'Laboratorio 5', 50.00, 'Sensor de presión para medir en pascales', 'https://www.ejemplo.com/presion'),
(2, '123474', 'Sensor de Movimiento', 'sensores', 'Laboratorio 6', 35.00, 'Sensor de movimiento PIR', 'https://www.ejemplo.com/movimiento'),
(3, '123475', 'Ácido Nítrico', 'liquidos', 'Almacén 8', 15.00, 'Ácido nítrico concentrado', 'Frasco ámbar con tapa hermética'),
(3, '123476', 'Hidróxido de Sodio', 'liquidos', 'Almacén 9', 25.00, 'Hidróxido de sodio líquido', 'Botella plástica resistente'),
(3, '123477', 'Agua Destilada', 'liquidos', 'Almacén 10', 100.00, 'Agua destilada purificada', 'Garrafón de 5 litros'),
(4, '123478', 'Cloruro de Sodio', 'solidos', 'Almacén 11', 80.00, 'Cloruro de sodio (sal común)', 'Bolsa de plástico sellada'),
(4, '123479', 'Carbonato de Calcio', 'solidos', 'Almacén 12', 70.00, 'Carbonato de calcio en polvo', 'Bote de vidrio'),
(4, '123480', 'Óxido de Hierro', 'solidos', 'Almacén 13', 65.00, 'Óxido de hierro (herrumbre)', 'Contenedor metálico'),
(4, '123481', 'Pipetas de Vidrio', 'materiales', 'Laboratorio 7', 100.00, 'Pipetas de vidrio de 10 ml', 'Caja de 10 unidades'),
(4, '123482', 'Matraces Erlenmeyer', 'materiales', 'Laboratorio 8', 50.00, 'Matraces de 250 ml', 'Caja de 5 unidades'),
(4, '123483', 'Balanza Digital', 'materiales', 'Laboratorio 9', 10.00, 'Balanza digital de precisión', 'Incluye baterías');

INSERT INTO `practicas` (`fk_profesor_users_practica`, `nombre`, `descripcion`, `num_equipos`) VALUES
(26, 'Práctica de Matemáticas', 'Resolver problemas de álgebra y geometría.', 5),
(26, 'Práctica de Física', 'Experimentos relacionados con las leyes de Newton.', 4),
(26, 'Práctica de Química', 'Realizar reacciones químicas básicas.', 5),
(26, 'Reacciones Ácido-Base', 'Identificar y medir el pH de diferentes soluciones ácidas y básicas.', 5),
(26, 'Preparación de Soluciones', 'Preparar soluciones de diferentes concentraciones molares.', 4),
(26, 'Electrólisis del Agua', 'Descomponer agua en hidrógeno y oxígeno mediante electrólisis.', 6),
(26, 'Cristalización de Sales', 'Obtener cristales de sulfato de cobre mediante evaporación controlada.', 5),
(26, 'Titulación Ácido-Base', 'Determinar la concentración de una solución desconocida mediante titulación.', 4),
(27, 'Reacciones de Precipitación', 'Observar la formación de precipitados en reacciones químicas.', 5),
(27, 'Propiedades Coligativas', 'Estudiar el efecto de solutos no volátiles en el punto de ebullición.', 6),
(27, 'Síntesis de Jabón', 'Producir jabón mediante la saponificación de grasas.', 5),
(27, 'Análisis Cualitativo de Cationes', 'Identificar cationes metálicos mediante pruebas específicas.', 4),
(27, 'Reacciones Redox', 'Estudiar procesos de oxidación y reducción en soluciones.', 5),
(28, 'Extracción de Pigmentos Vegetales', 'Extraer clorofila y otros pigmentos de hojas verdes.', 6),
(28, 'Densidad de Líquidos', 'Medir la densidad de líquidos utilizando un picnómetro.', 5),
(28, 'Reacciones Exotérmicas', 'Observar reacciones que liberan calor, como la disolución de hidróxido de sodio.', 4),
(28, 'Separación por Cromatografía', 'Separar mezclas de colorantes mediante cromatografía en papel.', 5),
(28, 'Prueba de Almidón', 'Detectar almidón en alimentos utilizando solución de yodo.', 6),
(29, 'Combustión de Hidrocarburos', 'Analizar los productos de la combustión completa e incompleta.', 5),
(29, 'Neutralización de Ácidos', 'Neutralizar ácidos fuertes con bases fuertes.', 4),
(29, 'Propiedades del Carbono', 'Estudiar las propiedades químicas del carbono en compuestos orgánicos.', 5),
(29, 'Síntesis de Ésteres', 'Producir ésteres mediante reacciones de esterificación.', 6),
(29, 'Reacciones de Descomposición', 'Descomponer compuestos inestables mediante calor o catalizadores.', 5),
(26, 'Prueba de Proteínas', 'Detectar proteínas en muestras mediante la prueba de Biuret.', 4),
(26, 'Ley de Boyle-Mariotte', 'Verificar la relación entre presión y volumen en gases.', 5),
(26, 'Reacciones de Halogenación', 'Observar la sustitución de hidrógeno por halógenos en hidrocarburos.', 6),
(26, 'Purificación del Agua', 'Filtrar y purificar agua contaminada mediante métodos químicos.', 5),
(26, 'Reacciones de Polimerización', 'Estudiar la formación de polímeros simples.', 4),
(27, 'Propiedades del Amoniaco', 'Estudiar las propiedades físicas y químicas del amoniaco.', 5),
(27, 'Reacciones de Esterificación', 'Producir ésteres a partir de ácidos carboxílicos y alcoholes.', 6),
(27, 'Prueba de Glucosa', 'Detectar glucosa en muestras mediante la prueba de Benedict.', 4),
(27, 'Reacciones de Sustitución', 'Observar la sustitución nucleofílica en compuestos orgánicos.', 5),
(27, 'Detección de Metales Pesados', 'Identificar metales pesados en muestras de agua.', 6),
(28, 'Reacciones de Condensación', 'Estudiar la formación de moléculas más grandes a partir de pequeñas.', 5),
(28, 'Propiedades del Etanol', 'Analizar las propiedades físicas y químicas del etanol.', 4),
(28, 'Reacciones de Adición', 'Observar la adición de halógenos a alquenos.', 5),
(28, 'Síntesis de Ácidos Carboxílicos', 'Producir ácidos carboxílicos mediante oxidación de alcoholes.', 6),
(28, 'Prueba de Aldehídos', 'Detectar aldehídos en muestras mediante la prueba de Tollens.', 5),
(29, 'Reacciones de Eliminación', 'Observar la eliminación de agua en alcoholes para formar alquenos.', 4),
(29, 'Propiedades del Metano', 'Estudiar las propiedades físicas y químicas del metano.', 5),
(29, 'Reacciones de Hidrólisis', 'Estudiar la ruptura de enlaces mediante agua.', 6),
(29, 'Síntesis de Amidas', 'Producir amidas a partir de ácidos carboxílicos y aminas.', 5),
(29, 'Reacciones de Oxidación', 'Observar la oxidación de alcoholes primarios y secundarios.', 4);


INSERT INTO `practicas_materiales` (`fk_practicas_pm`, `fk_items_pm`, `cantidad`, `contable`) VALUES
(1, 1, 5.00, TRUE),
(1, 2, 10.00, TRUE),
(1, 3, 15.00, FALSE),
(1, 4, 5.00, TRUE),
(1, 5, 10.00, TRUE),
(1, 6, 15.00, FALSE),
(1, 20, 5.00, TRUE),
(1, 21, 10.00, TRUE),
(1, 26, 15.00, FALSE),
(1, 27, 5.00, TRUE),
(1, 28, 10.00, TRUE),
(1, 24, 15.00, FALSE),
(1, 10, 5.00, TRUE),
(1, 11, 10.00, TRUE),
(1, 12, 15.00, FALSE),
(1, 13, 15.00, FALSE),
(1, 15, 15.00, FALSE),
(1, 16, 15.00, FALSE),
(1, 7, 15.00, FALSE),
(1, 8, 15.00, FALSE),
(1, 9, 15.00, FALSE),

(2, 4, 3.00, TRUE),
(2, 5, 6.00, FALSE),
(2, 6, 9.00, TRUE),
(3, 7, 2.00, FALSE),
(3, 8, 4.00, FALSE),
(3, 9, 6.00, TRUE),
(3, 10, 6.00, FALSE),
(3, 11, 6.00, TRUE),
(3, 12, 6.00, TRUE),
(3, 13, 6.00, FALSE),

-- Práctica 4
(4, 14, 1.00, FALSE),
(4, 15, 2.00, TRUE),
(4, 16, 3.00, TRUE),
-- Práctica 5
(5, 17, 4.00, TRUE),
(5, 18, 5.00, TRUE),
(5, 19, 6.00, FALSE),
-- Práctica 6
(6, 20, 7.00, TRUE),
(6, 21, 8.00, TRUE),
(6, 22, 9.00, FALSE),
-- Práctica 7
(7, 23, 10.00, TRUE),
(7, 24, 11.00, TRUE),
(7, 25, 12.00, TRUE),
(7, 26, 13.00, TRUE),
-- Práctica 8
(8, 27, 14.00, TRUE),
(8, 28, 15.00, TRUE),
(8, 1, 16.00, FALSE),
-- Práctica 9
(9, 2, 17.00, TRUE),
(9, 3, 18.00, TRUE),
(9, 4, 19.00, TRUE),
(9, 5, 20.00, TRUE),
-- Práctica 10
(10, 6, 21.00, TRUE),
(10, 7, 22.00, TRUE),
(10, 8, 23.00, FALSE),
-- Continuación hasta la práctica 43
(11, 9, 5.00, TRUE),
(11, 10, 10.00, TRUE),
(11, 11, 15.00, FALSE),
(12, 12, 3.00, TRUE),
(12, 13, 6.00, TRUE),
(12, 14, 9.00, FALSE),
(13, 15, 2.00, TRUE),
(13, 16, 4.00, TRUE),
(13, 17, 6.00, TRUE),
(13, 18, 6.00, TRUE),
(13, 19, 6.00, TRUE),
(13, 20, 6.00, TRUE),
(13, 21, 6.00, FALSE),
(14, 22, 1.00, FALSE),
(14, 23, 2.00, TRUE),
(14, 24, 3.00, TRUE),
(15, 25, 4.00, TRUE),
(15, 26, 5.00, TRUE),
(15, 27, 6.00, FALSE),
(16, 28, 7.00, TRUE),
(16, 1, 8.00, TRUE),
(16, 2, 9.00, FALSE),
(17, 3, 10.00, TRUE),
(17, 4, 11.00, TRUE),
(17, 5, 12.00, TRUE),
(17, 6, 13.00, TRUE),
(18, 7, 14.00, TRUE),
(18, 8, 15.00, TRUE),
(18, 9, 16.00, FALSE),
(19, 10, 17.00, TRUE),
(19, 11, 18.00, TRUE),
(19, 12, 19.00, TRUE),
(19, 13, 20.00, TRUE),
(20, 14, 21.00, TRUE),
(20, 15, 22.00, TRUE),
(20, 16, 23.00, FALSE),
(21, 17, 5.00, TRUE),
(21, 18, 10.00, TRUE),
(21, 19, 15.00, FALSE),
(22, 20, 3.00, TRUE),
(22, 21, 6.00, TRUE),
(22, 22, 9.00, FALSE),
(23, 23, 2.00, TRUE),
(23, 24, 4.00, TRUE),
(23, 25, 6.00, TRUE),
(23, 26, 6.00, TRUE),
(23, 27, 6.00, TRUE),
(23, 28, 6.00, TRUE),
(24, 5, 7.00, TRUE),
(24, 12, 3.00, FALSE),
(24, 18, 9.00, TRUE),
(25, 2, 5.00, TRUE),
(25, 22, 8.00, FALSE),
(25, 7, 4.00, TRUE),
(26, 15, 6.00, TRUE),
(26, 9, 2.00, FALSE),
(26, 28, 10.00, TRUE),
(27, 1, 3.00, TRUE),
(27, 14, 7.00, FALSE),
(27, 21, 5.00, TRUE),
(28, 8, 4.00, FALSE),
(28, 25, 6.00, TRUE),
(28, 3, 9.00, TRUE),
(29, 19, 5.00, TRUE),
(29, 6, 7.00, FALSE),
(29, 10, 2.00, TRUE),
(30, 17, 8.00, TRUE),
(30, 11, 6.00, FALSE),
(30, 4, 3.00, TRUE),
(31, 20, 5.00, TRUE),
(31, 13, 7.00, FALSE),
(31, 26, 4.00, TRUE),
(32, 27, 6.00, FALSE),
(32, 16, 8.00, TRUE),
(32, 23, 2.00, TRUE),
(33, 9, 5.00, TRUE),
(33, 12, 4.00, FALSE),
(33, 18, 7.00, TRUE),
(34, 1, 3.00, TRUE),
(34, 22, 9.00, FALSE),
(34, 5, 6.00, TRUE),
(35, 14, 7.00, TRUE),
(35, 8, 5.00, FALSE),
(35, 24, 2.00, TRUE),
(36, 11, 6.00, TRUE),
(36, 3, 8.00, FALSE),
(36, 19, 4.00, TRUE),
(37, 10, 5.00, TRUE),
(37, 16, 7.00, FALSE),
(37, 27, 3.00, TRUE),
(38, 6, 8.00, TRUE),
(38, 21, 4.00, FALSE),
(38, 2, 7.00, TRUE),
(39, 13, 6.00, TRUE),
(39, 25, 5.00, FALSE),
(39, 9, 3.00, TRUE),
(40, 28, 7.00, FALSE),
(40, 4, 6.00, TRUE),
(40, 17, 8.00, TRUE),
(41, 23, 5.00, TRUE),
(41, 12, 4.00, FALSE),
(41, 20, 7.00, TRUE),
(42, 7, 3.00, TRUE),
(42, 1, 9.00, FALSE),
(42, 18, 6.00, TRUE),
(43, 14, 5.00, TRUE),
(43, 10, 8.00, FALSE),
(43, 26, 4.00, TRUE);


INSERT INTO `practicas_asignadas` (`fk_practicas_pa`, `fk_grupo_pa`, `fecha_inicio`, `fecha_fin`, `status`) VALUES
-- Asignaciones para el grupo 1
(1, 1, '2025-01-27 08:00:00', '2025-01-27 10:00:00', 'pendiente'),
(2, 1, '2025-02-01 09:00:00', '2025-02-01 11:00:00', 'progreso'),
(3, 1, '2025-02-05 10:00:00', '2025-02-05 12:00:00', 'completada'),
(4, 1, '2025-02-10 11:00:00', '2025-02-10 13:00:00', 'cancelada'),
(5, 1, '2025-02-15 12:00:00', '2025-02-15 14:00:00', 'pendiente'),

-- Asignaciones para el grupo 2
(6, 2, '2025-01-28 08:00:00', '2025-01-28 10:00:00', 'progreso'),
(7, 2, '2025-02-02 09:00:00', '2025-02-02 11:00:00', 'completada'),
(8, 2, '2025-02-06 10:00:00', '2025-02-06 12:00:00', 'cancelada'),
(9, 2, '2025-02-11 11:00:00', '2025-02-11 13:00:00', 'pendiente'),
(10, 2, '2025-02-16 12:00:00', '2025-02-16 14:00:00', 'progreso'),

-- Asignaciones para el grupo 3
(11, 3, '2025-01-29 08:00:00', '2025-01-29 10:00:00', 'completada'),
(12, 3, '2025-02-03 09:00:00', '2025-02-03 11:00:00', 'cancelada'),
(13, 3, '2025-02-07 10:00:00', '2025-02-07 12:00:00', 'pendiente'),
(14, 3, '2025-02-12 11:00:00', '2025-02-12 13:00:00', 'progreso'),
(15, 3, '2025-02-17 12:00:00', '2025-02-17 14:00:00', 'completada'),

-- Asignaciones para el grupo 4
(16, 4, '2025-01-30 08:00:00', '2025-01-30 10:00:00', 'cancelada'),
(17, 4, '2025-02-04 09:00:00', '2025-02-04 11:00:00', 'pendiente'),
(18, 4, '2025-02-08 10:00:00', '2025-02-08 12:00:00', 'progreso'),
(19, 4, '2025-02-13 11:00:00', '2025-02-13 13:00:00', 'completada'),
(20, 4, '2025-02-18 12:00:00', '2025-02-18 14:00:00', 'cancelada'),

-- Asignaciones para el grupo 5
(21, 5, '2025-01-31 08:00:00', '2025-01-31 10:00:00', 'pendiente'),
(22, 5, '2025-02-05 09:00:00', '2025-02-05 11:00:00', 'progreso'),
(23, 5, '2025-02-09 10:00:00', '2025-02-09 12:00:00', 'completada'),
(24, 5, '2025-02-14 11:00:00', '2025-02-14 13:00:00', 'cancelada'),
(25, 5, '2025-02-19 12:00:00', '2025-02-19 14:00:00', 'pendiente'),

-- Asignaciones para el grupo 6
(26, 6, '2025-02-01 08:00:00', '2025-02-01 10:00:00', 'progreso'),
(27, 6, '2025-02-06 09:00:00', '2025-02-06 11:00:00', 'completada'),
(28, 6, '2025-02-10 10:00:00', '2025-02-10 12:00:00', 'cancelada'),
(29, 6, '2025-02-15 11:00:00', '2025-02-15 13:00:00', 'pendiente'),
(30, 6, '2025-02-20 12:00:00', '2025-02-20 14:00:00', 'progreso'),

-- Asignaciones para el grupo 7
(31, 7, '2025-02-02 08:00:00', '2025-02-02 10:00:00', 'completada'),
(32, 7, '2025-02-07 09:00:00', '2025-02-07 11:00:00', 'cancelada'),
(33, 7, '2025-02-11 10:00:00', '2025-02-11 12:00:00', 'pendiente'),
(34, 7, '2025-02-16 11:00:00', '2025-02-16 13:00:00', 'progreso'),
(35, 7, '2025-02-21 12:00:00', '2025-02-21 14:00:00', 'completada'),

-- Asignaciones para el grupo 8
(36, 8, '2025-02-03 08:00:00', '2025-02-03 10:00:00', 'cancelada'),
(37, 8, '2025-02-08 09:00:00', '2025-02-08 11:00:00', 'pendiente'),
(38, 8, '2025-02-12 10:00:00', '2025-02-12 12:00:00', 'progreso'),
(39, 8, '2025-02-17 11:00:00', '2025-02-17 13:00:00', 'completada'),
(40, 8, '2025-02-22 12:00:00', '2025-02-22 14:00:00', 'cancelada'),

-- Asignaciones para el grupo 9
(41, 9, '2025-02-04 08:00:00', '2025-02-04 10:00:00', 'pendiente'),
(42, 9, '2025-02-09 09:00:00', '2025-02-09 11:00:00', 'progreso'),
(43, 9, '2025-02-13 10:00:00', '2025-02-13 12:00:00', 'completada'),
(1, 9, '2025-02-18 11:00:00', '2025-02-18 13:00:00', 'cancelada'),
(2, 9, '2025-02-23 12:00:00', '2025-02-23 14:00:00', 'pendiente'),

-- Asignaciones para el grupo 10
(3, 10, '2025-02-05 08:00:00', '2025-02-05 10:00:00', 'progreso'),
(4, 10, '2025-02-10 09:00:00', '2025-02-10 11:00:00', 'completada'),
(5, 10, '2025-02-14 10:00:00', '2025-02-14 12:00:00', 'cancelada'),
(6, 10, '2025-02-19 11:00:00', '2025-02-19 13:00:00', 'pendiente'),
(7, 10, '2025-02-24 12:00:00', '2025-02-24 14:00:00', 'progreso');


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
(4, 25, 'cancelada', 'Cancelado por falta de material'),
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
(4, 24, 'cancelada', 'Anulación realizada por error administrativo'),
(1, 5, 'incompleto', 'Falta documentación del alumno'),
(2, 4, 'incompleto', 'Error en los datos proporcionados'),
(3, 3, 'incompleto', 'No se completó el proceso de validación'),
(4, 2, 'incompleto', 'Material no disponible en el almacén'),
(1, 1, 'incompleto', 'Pendiente de revisión por el profesor'),
(2, 9, 'incompleto', 'Datos insuficientes para procesar'),
(3, 8, 'incompleto', 'Requiere corrección en la solicitud'),
(4, 7, 'incompleto', 'No cumple con los requisitos necesarios');