-- mysql -u root -p

CREATE DATABASE IF NOT EXISTS laboratorio;
USE laboratorio;

CREATE TABLE users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,        -- Identificador único
    name VARCHAR(100) NOT NULL,            -- Nombre del usuario
    email VARCHAR(150) UNIQUE NOT NULL,     -- Correo electrónico único
    password VARCHAR(255) NOT NULL,        -- Contraseña (almacenada en forma hasheada)
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Fecha de creación
    rol ENUM('administrador','profesor', 'alumno') DEFAULT 'alumno', -- Rol del usuario
    active BOOLEAN DEFAULT TRUE              -- Si el usuario está activo
) ENGINE=InnoDB;

CREATE TABLE ubicacion (
    id_ubicacion VARCHAR(255) NOT NULL,      -- Identificador único de la ubicación
    Mueble VARCHAR(255) NOT NULL,            -- Nombre del mueble
    Numero VARCHAR(255) DEFAULT 'NA',        -- Número asociado (por defecto 'NA')
    Estado VARCHAR(255) DEFAULT 'NA',        -- Estado (por defecto 'NA')
    Estante SMALLINT DEFAULT 0,              -- Número de estante (por defecto 0)
    Nivel SMALLINT DEFAULT 0,                -- Nivel del estante (por defecto 0)
    PRIMARY KEY (id_ubicacion)               -- Llave primaria
) ENGINE=InnoDB;


CREATE TABLE kits (
    id_kits SMALLINT AUTO_INCREMENT,          -- Identificador único de los kits
    num_serie VARCHAR(255) DEFAULT 'NULL',    -- Número de serie
    nombre VARCHAR(255) DEFAULT 'NULL',       -- Nombre del kit
    marca VARCHAR(255) DEFAULT 'NULL',        -- Marca del kit
    fk_ubicacion VARCHAR(255) DEFAULT 'NULL', -- Clave foránea de ubicación
    observaciones VARCHAR(255) DEFAULT 'NULL',-- Observaciones del kit
    link VARCHAR(255) DEFAULT 'NULL',         -- Enlace asociado al kit
    caja VARCHAR(255) NOT NULL DEFAULT 'NULL',-- Caja del kit (obligatorio)
    cantidad_kits SMALLINT,                   -- Cantidad de kits
    contenido VARCHAR(255) NOT NULL DEFAULT 'NULL', -- Contenido del kit (obligatorio)
    cantidad INT NOT NULL,                    -- Cantidad total de elementos
    PRIMARY KEY (id_kits),                    -- Llave primaria
    FOREIGN KEY (fk_ubicacion) REFERENCES ubicacion (id_ubicacion) -- Clave foránea
) ENGINE=InnoDB;

CREATE TABLE manuales (
    id_manual SMALLINT AUTO_INCREMENT,        -- Identificador único de los manuales
    codigo VARCHAR(255),                      -- Código del manual
    manual VARCHAR(255),                      -- Nombre del manual
    topico VARCHAR(255),                      -- Tópico del manual
    cantidad INT,                             -- Cantidad de manuales
    fk_ubicacion VARCHAR(255) NOT NULL,       -- Clave foránea de ubicación
    referencia VARCHAR(255),                  -- Referencia del manual
    presentacion VARCHAR(255),                -- Presentación del manual
    idioma VARCHAR(255),                      -- Idioma del manual
    observaciones VARCHAR(255),               -- Observaciones del manual
    PRIMARY KEY (id_manual),                  -- Llave primaria
    FOREIGN KEY (fk_ubicacion) REFERENCES ubicacion (id_ubicacion) -- Clave foránea
) ENGINE=InnoDB;

CREATE TABLE materiales (
    id_material INT AUTO_INCREMENT,            -- Identificador único del material
    num_serie VARCHAR(255) DEFAULT 'NA',       -- Número de serie (por defecto 'NA')
    nombre VARCHAR(255) NOT NULL,              -- Nombre del material (obligatorio)
    marca VARCHAR(255) DEFAULT 'Generico' NOT NULL, -- Marca del material (obligatoria)
    fk_ubicacion VARCHAR(255) NOT NULL,        -- Clave foránea de ubicación
    PRIMARY KEY (id_material),                 -- Llave primaria
    FOREIGN KEY (fk_ubicacion) REFERENCES ubicacion (id_ubicacion) -- Clave foránea
) ENGINE=InnoDB;

CREATE TABLE reactivos_liquidos (
    id_reactivos INT AUTO_INCREMENT,           -- Identificador único del reactivo líquido
    num_cas VARCHAR(255) NOT NULL,             -- Número CAS (obligatorio)
    nombre VARCHAR(255) NOT NULL,              -- Nombre del reactivo (obligatorio)
    formula VARCHAR(255) NOT NULL,             -- Fórmula química (obligatoria)
    marca VARCHAR(255) DEFAULT 'Generico' NOT NULL, -- Marca del reactivo
    cantidad INT,                              -- Cantidad del reactivo
    fk_ubicacion VARCHAR(255) NOT NULL,        -- Clave foránea de ubicación
    contenedor VARCHAR(255) NOT NULL,          -- Tipo de contenedor (obligatorio)
    observaciones VARCHAR(255),                -- Observaciones del reactivo
    PRIMARY KEY (id_reactivos),                -- Llave primaria
    FOREIGN KEY (fk_ubicacion) REFERENCES ubicacion (id_ubicacion) -- Clave foránea
) ENGINE=InnoDB;

CREATE TABLE reactivos_solidos (
    id_reactivos INT AUTO_INCREMENT,           -- Identificador único del reactivo sólido
    num_cas VARCHAR(255) DEFAULT 'NA',         -- Número CAS (por defecto 'NA')
    nombre VARCHAR(255) NOT NULL,              -- Nombre del reactivo (obligatorio)
    formula VARCHAR(255) DEFAULT 'NA',         -- Fórmula química (por defecto 'NA')
    marca VARCHAR(255) DEFAULT 'Generico' NOT NULL, -- Marca del reactivo
    cantidad INT,                              -- Cantidad del reactivo
    fk_ubicacion VARCHAR(255) NOT NULL,        -- Clave foránea de ubicación
    contenedor VARCHAR(255) NOT NULL,          -- Tipo de contenedor (obligatorio)
    observaciones VARCHAR(255),                -- Observaciones del reactivo
    PRIMARY KEY (id_reactivos),                -- Llave primaria
    FOREIGN KEY (fk_ubicacion) REFERENCES ubicacion (id_ubicacion) -- Clave foránea
) ENGINE=InnoDB;

CREATE TABLE sensores (
    id_sensores CHAR(36) NOT NULL,             -- Identificador único del sensor (UUID como cadena de 36 caracteres)
    num_serie VARCHAR(255) NOT NULL,           -- Número de serie (obligatorio)
    nombre VARCHAR(255) NOT NULL,              -- Nombre del sensor (obligatorio)
    encargado VARCHAR(255),                    -- Nombre del encargado
    fk_ubicacion VARCHAR(255) NOT NULL,        -- Clave foránea de ubicación
    observaciones VARCHAR(255),                -- Observaciones del sensor
    link VARCHAR(255),                         -- Enlace asociado al sensor
    cantidad SMALLINT,                         -- Cantidad de sensores
    kit SMALLINT NOT NULL,                     -- Número de kit (obligatorio)
    PRIMARY KEY (id_sensores),                 -- Llave primaria
    FOREIGN KEY (fk_ubicacion) REFERENCES ubicacion (id_ubicacion) -- Clave foránea
) ENGINE=InnoDB;

--- insert data into table users

-- INSERT INTO users (name, email, password, rol, active) VALUES
-- ('Juan Pérez', 'juan.perez@example.com', 'hashed_password_juan', 'administrador', TRUE),
-- ('Ana López', 'ana.lopez@example.com', 'hashed_password_ana', 'profesor', TRUE),
-- ('Carlos Ramírez', 'carlos.ramirez@example.com', 'hashed_password_carlos', 'alumno', TRUE),
-- ('María Fernández', 'maria.fernandez@example.com', 'hashed_password_maria', 'profesor', FALSE),
-- ('Luis García', 'luis.garcia@example.com', 'hashed_password_luis', 'alumno', TRUE);



