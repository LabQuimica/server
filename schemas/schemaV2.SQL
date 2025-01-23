-- mysql -u root -p
-- $2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi

-- drop schema laboratorio;

CREATE DATABASE IF NOT EXISTS laboratorio;
USE laboratorio;

CREATE TABLE `users`(
    `id_user` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `rol` ENUM('administrador', 'profesor', 'alumno') NOT NULL DEFAULT 'alumno',
    `active` BOOLEAN NOT NULL DEFAULT '1'
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
    `fk_users_ga` INT NOT NULL,
    FOREIGN KEY (`fk_grupo_ga`) REFERENCES `grupo`(`id_grupo`),
    FOREIGN KEY (`fk_users_ga`) REFERENCES `users`(`id_user`)
) ENGINE=InnoDB;

CREATE TABLE `items`(
    `id_item` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_marca_item` TINYINT NOT NULL,
    `num_serie` VARCHAR(100) NOT NULL,
    `nombre` VARCHAR(255) NOT NULL,
    `tipo` ENUM('kit', 'sensor', 'material', 'liquido', 'solido') NOT NULL,
    `ubicacion` VARCHAR(255),
    `cantidad` DECIMAL(8, 2) NOT NULL,
    `observacion` VARCHAR(255),
    FOREIGN KEY (`fk_marca_item`) REFERENCES `marcas`(`id_marca`)
) ENGINE=InnoDB;

CREATE TABLE `reactivos`(
    `id_reactivo` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_reactivo` INT NOT NULL,
    `fk_contenedores_reactivo` TINYINT NOT NULL,
    FOREIGN KEY (`fk_items_reactivo`) REFERENCES `items`(`id_item`),
    FOREIGN KEY (`fk_contenedores_reactivo`) REFERENCES `contenedores`(`id_contenedor`)
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
    `fk_reactivos_liquidos` INT NOT NULL,
    FOREIGN KEY (`fk_reactivos_liquidos`) REFERENCES `reactivos`(`id_reactivo`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `solidos`(
    `id_solido` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_reactivos_solidos` INT NOT NULL,
    FOREIGN KEY (`fk_reactivos_solidos`) REFERENCES `reactivos`(`id_reactivo`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `practicas`(
    `id_practica` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_users_practica` INT NOT NULL,
    `nombre` VARCHAR(255) NOT NULL,
    `descripcion` TEXT,
    `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `fecha_modificacion` TIMESTAMP NOT NULL,
    FOREIGN KEY (`fk_users_practica`) REFERENCES `users`(`id_user`)
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
    `fk_users_pa` INT NOT NULL COMMENT 'profesor que la asigno',
    `fecha_asignada` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `fecha_entrega` TIMESTAMP NOT NULL,
    FOREIGN KEY (`fk_practicas_pa`) REFERENCES `practicas`(`id_practica`),
    FOREIGN KEY (`fk_grupo_pa`) REFERENCES `grupo`(`id_grupo`),
    FOREIGN KEY (`fk_users_pa`) REFERENCES `users`(`id_user`)
) ENGINE=InnoDB;

CREATE TABLE `vale_alumno`(
    `id_vale` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_pa_vale` INT NOT NULL,
    `fk_users_vale` INT NOT NULL COMMENT 'Usuario a quien es responsable',
    `status` ENUM('pendiente', 'progreso', 'completada', 'cancelada') NOT NULL,
    `observaciones` VARCHAR(255),
    `fecha_solicitada` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`fk_pa_vale`) REFERENCES `practicas_asignadas`(`id_pa`),
    FOREIGN KEY (`fk_users_vale`) REFERENCES `users`(`id_user`)
) ENGINE=InnoDB;

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









