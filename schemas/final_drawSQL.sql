-- mysql -u root -p
-- $2b$10$ryAHsRcpWxv34G3utMtRLev4UaVjUDuEeYbybkwt8MXB8tr0vWeMi
CREATE DATABASE IF NOT EXISTS laboratorio;
USE laboratorio;

CREATE TABLE `practicas_asignadas`(
    `id_pa` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_practicas_pa` INT NOT NULL,
    `fk_grupo_pa` TINYINT NOT NULL COMMENT 'grupo a quien le asigno la practica',
    `fk_users_pa` INT NOT NULL COMMENT 'profesor que la asigno',
    `fecha_asignada` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `fecha_entrega` TIMESTAMP NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `users`(
    `id_user` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `rol` ENUM(
        'administrador',
        'profesor',
        'alumno'
    ) NOT NULL DEFAULT 'alumno',
    `active` BOOLEAN NOT NULL DEFAULT '1'
) ENGINE=InnoDB;
CREATE TABLE `grupo`(
    `id_grupo` TINYINT AUTO_INCREMENT PRIMARY KEY,
    `grupo` VARCHAR(100) NOT NULL,
    `semestre` TINYINT NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `grupo_alumnos`(
    `id_ga` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_grupo_ga` TINYINT NOT NULL,
    `fk_users_ga` INT NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `items`(
    `id_item` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_marca_item` TINYINT NOT NULL,
    `num_serie` VARCHAR(100) NOT NULL,
    `nombre` VARCHAR(255) NOT NULL,
    `tipo` ENUM(
        'kit',
        'sensor',
        'material',
        'liquido',
        'solido'
    ) NOT NULL,
    `ubicacion` VARCHAR(255),
    `cantidad` DECIMAL(8, 2) NOT NULL,
    `observacion` VARCHAR(255)
) ENGINE=InnoDB;
CREATE TABLE `marca`(
    `id_marca` TINYINT AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `kits`(
    `id_kit` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_kits` INT NOT NULL,
    `caja` VARCHAR(25),
    `contenido` VARCHAR(255),
    `cantidad_kits` TINYINT,
    `link` VARCHAR(255)
) ENGINE=InnoDB;
CREATE TABLE `sensores`(
    `id_sensor` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_sensores` INT NOT NULL,
    `link` VARCHAR(255)
) ENGINE=InnoDB;
CREATE TABLE `materiales`(
    `id_material` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_materiales` INT NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `contenedores`(
    `id_contenedor` TINYINT AUTO_INCREMENT PRIMARY KEY,
    `descripcion` VARCHAR(255) 
) ENGINE=InnoDB;
CREATE TABLE `liquidos`(
    `id_liquidos` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_reactivos_liquidos` INT NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `solidos`(
    `id_solido` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_reactivos_solidos` INT NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `practicas`(
    `id_practica` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_users_practica` INT NOT NULL,
    `nombre` VARCHAR(255) NOT NULL,
    `descripcion` TEXT,
    `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `fecha_modificacion` TIMESTAMP NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `practicas_materiales`(
    `id_pm` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_practicas_pm` INT NOT NULL,
    `fk_items_pm` INT NOT NULL,
    `cantidad` DECIMAL(8, 2) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `reactivos`(
    `id_reactivo` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_items_reactivo` INT NOT NULL,
    `fk_contenedores_reactivo` INT NOT NULL
) ENGINE=InnoDB;
CREATE TABLE `vale_alumno`(
    `id_vale` INT AUTO_INCREMENT PRIMARY KEY,
    `fk_pa_vale` INT NOT NULL,
    `fk_users_vale` INT NOT NULL COMMENT 'Usuario a quien es responsable',
    `status` ENUM(
        'pendiente',
        'progreso',
        'completada',
        'cancelada'
    ) NOT NULL,
    `observaciones` VARCHAR(255),
    `fecha_solicitada` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
ALTER TABLE
    `solidos` ADD CONSTRAINT `solidos_fk_reactivos_solidos_foreign` FOREIGN KEY(`fk_reactivos_solidos`) REFERENCES `reactivos`(`id_reactivo`);
ALTER TABLE
    `practicas_asignadas` ADD CONSTRAINT `practicas_asignadas_fk_grupo_pa_foreign` FOREIGN KEY(`fk_grupo_pa`) REFERENCES `grupo`(`id_grupo`);
ALTER TABLE
    `grupo_alumnos` ADD CONSTRAINT `grupo_alumnos_fk_users_ga_foreign` FOREIGN KEY(`fk_users_ga`) REFERENCES `users`(`id_user`);
ALTER TABLE
    `vale_alumno` ADD CONSTRAINT `vale_alumno_fk_users_vale_foreign` FOREIGN KEY(`fk_users_vale`) REFERENCES `users`(`id_user`);
ALTER TABLE
    `reactivos` ADD CONSTRAINT `reactivos_fk_contenedores_reactivo_foreign` FOREIGN KEY(`fk_contenedores_reactivo`) REFERENCES `contenedores`(`id_contenedor`);
ALTER TABLE
    `vale_alumno` ADD CONSTRAINT `vale_alumno_fk_pa_vale_foreign` FOREIGN KEY(`fk_pa_vale`) REFERENCES `practicas_asignadas`(`id_pa`);
ALTER TABLE
    `practicas_asignadas` ADD CONSTRAINT `practicas_asignadas_fk_practicas_pa_foreign` FOREIGN KEY(`fk_practicas_pa`) REFERENCES `practicas`(`id_practica`);
ALTER TABLE
    `kits` ADD CONSTRAINT `kits_fk_items_kits_foreign` FOREIGN KEY(`fk_items_kits`) REFERENCES `items`(`id_item`);
ALTER TABLE
    `grupo_alumnos` ADD CONSTRAINT `grupo_alumnos_fk_grupo_ga_foreign` FOREIGN KEY(`fk_grupo_ga`) REFERENCES `grupo`(`id_grupo`);
ALTER TABLE
    `practicas_materiales` ADD CONSTRAINT `practicas_materiales_fk_items_pm_foreign` FOREIGN KEY(`fk_items_pm`) REFERENCES `items`(`id_item`);
ALTER TABLE
    `practicas_asignadas` ADD CONSTRAINT `practicas_asignadas_fk_users_pa_foreign` FOREIGN KEY(`fk_users_pa`) REFERENCES `users`(`id_user`);
ALTER TABLE
    `reactivos` ADD CONSTRAINT `reactivos_fk_items_reactivo_foreign` FOREIGN KEY(`fk_items_reactivo`) REFERENCES `items`(`id_item`);
ALTER TABLE
    `practicas_materiales` ADD CONSTRAINT `practicas_materiales_fk_practicas_pm_foreign` FOREIGN KEY(`fk_practicas_pm`) REFERENCES `practicas`(`id_practica`);
ALTER TABLE
    `items` ADD CONSTRAINT `items_fk_marca_item_foreign` FOREIGN KEY(`fk_marca_item`) REFERENCES `marca`(`id_marca`);
ALTER TABLE
    `materiales` ADD CONSTRAINT `materiales_fk_items_materiales_foreign` FOREIGN KEY(`fk_items_materiales`) REFERENCES `items`(`id_item`);
ALTER TABLE
    `practicas` ADD CONSTRAINT `practicas_fk_users_practica_foreign` FOREIGN KEY(`fk_users_practica`) REFERENCES `users`(`id_user`);
ALTER TABLE
    `sensores` ADD CONSTRAINT `sensores_fk_items_sensores_foreign` FOREIGN KEY(`fk_items_sensores`) REFERENCES `items`(`id_item`);
ALTER TABLE
    `liquidos` ADD CONSTRAINT `liquidos_fk_reactivos_liquidos_foreign` FOREIGN KEY(`fk_reactivos_liquidos`) REFERENCES `reactivos`(`id_reactivo`);