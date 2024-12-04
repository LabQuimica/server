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
    id_sensores INT AUTO_INCREMENT,            -- Identificador único del sensor 
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

INSERT INTO ubicacion (Mueble, Numero, Estado, Estante, Nivel, id_ubicacion) VALUES
('Estante', NULL, 'Abierto', 1, 1, 'EA11'),
('Estante', NULL, 'Abierto', 1, 2, 'EA12'),
('Estante', NULL, 'Abierto', 1, 3, 'EA13'),
('Gabinete', '7', NULL, NULL, NULL, 'G7'),
('Gabinete', '10', NULL, NULL, NULL, 'G10'),
('Mesa móvil', NULL, NULL, 1, 1, 'MM11'),
('Mesa móvil', NULL, NULL, 1, 2, 'MM12'),
('Mesa móvil', NULL, NULL, 1, 3, 'MM13'),
('Regadera', NULL, NULL, NULL, NULL, 'DR'),
('Rack', '1', NULL, NULL, NULL, 'RA1'),
('Rack', '2', NULL, NULL, NULL, 'RA2');

INSERT INTO reactivos_solidos (id_reactivos, num_cas, nombre, formula, marca, cantidad, fk_ubicacion, contenedor, observaciones) VALUES
(3, '121212', 'Azúcar', 'H12OSD', 'Genérico', 5, 'EA13', 'Transparente', NULL),
(5, '3543', 'Azúcar', 'A', 'Genérica', 5, 'EA11', 'Frasco de vidrio', NULL),
(4, '1111', 'Cambio', 'O', 'Genérica', 3, 'EA12', 'Blanco de plástico', NULL),
(7, '11111', 'Robin', 'Z', 'Genérica', 3, 'EA11', 'Metálico', NULL),
(8, '551551', 'xxxx', 'FeO', 'AAAAA', 2, 'MM11', 'AAA', NULL),
(9, '123456', 'Hola', 'O', 'Genérica', 5, 'MM13', 'Rojo', 'jhvhccj');


INSERT INTO reactivos_liquidos (id_reactivos, num_cas, nombre, formula, marca, cantidad, fk_ubicacion, contenedor, observaciones) VALUES
(5, 'VDA11', 'Ácido cítrico monohidrato', 'C6H8O7*H2O', 'Genérico', 1, 'MM13', 'Bote de plástico', NULL),
(6, 'PP289', 'Ácido Clorhídrico', 'HCl', 'Genérico', 1, 'G7', 'Frasco ámbar', NULL),
(7, '1239-12', 'Ácido sulfúrico 0.5M', 'H2SO4', 'Genérico', 1, 'MM11', 'Vidrio', NULL),
(8, '7647-14-5', 'Cloruro de sodio', 'NaCl', 'Genérico', 1, 'EA13', 'Bote de plástico', NULL),
(9, '56-81-5', 'Glicerina', 'C3H8O3', 'Genérico', 1, 'EA12', 'Frasco ámbar', NULL),
(13, '542654', 'Azufre', 'O', 'Genérico', 3, 'EA11', 'Rojo', 'kewjndfs'),
(14, '3543', 'Mike Modificado', 'MASZ', 'Zacatelco', 21, 'EA11', '3', 'kfjsndsf'),
(2, 'HHCX', 'Vale', 'HU7', 'Genérico', 3, 'MM13', 'Plástico', NULL);


INSERT INTO materiales (id_material, num_serie, nombre, marca, fk_ubicacion) VALUES
(16, NULL, 'Medidor de temperatura, humedad y presión', 'Genérico', 'G10'),
(17, NULL, 'Embudo de separación de 100 ml', 'Genérico', 'EA12'),
(18, 'NA', 'Mechero', 'Fisher Scientific', 'G7'),
(19, 'NA', 'Azufre', 'Dedutel', 'EA13'),
(2, '12345', 'h', 'Genérico', 'EA11'),
(3, '12345', 'Azufre', 'Genérica', 'EA11'),
(4, '51651', 'Azúcar', 'AAAAA', 'MM13'),
(20, 'NA', 'Cronómetro d=13 cm', 'NFF', 'EA11'),
(21, 'NA', 'Embudos', 'DGTF', 'EA12'),
(22, 'NA', 'Soportes universales y pinzas', 'UFJ', 'EA11'),
(23, 'NA', 'Matraz aforado 1000 ml, con tapa', 'MNA', 'EA13'),
(1, '8340250463', 'Báscula traveler', 'Corning', 'EA11');

INSERT INTO manuales (id_manual, codigo, manual, topico, cantidad, fk_ubicacion, referencia, presentacion, idioma, observaciones) VALUES
(9, 'MQO1', 'TESS advanced chemistry manual', 'Organic Chemistry', 5, 'EA11' ,'01837-02', 'Carpeta original', 'Inglés', 'Falta MQO1-5'),
(2, 'MQI2', 'TESS advanced chemistry manual', 'Inorganic Chemistry Part 2', 4, 'EA12' ,'01836-02', 'Carpeta original', 'Inglés', 'Buscar'),
(3, 'MEQ', 'TESS advanced chemistry manual', 'Electrochemical Measurement Set', 5, 'EA13' ,'01194-02', 'Carpeta original', 'Inglés', 'Prestado'),
(4, 'MQA', 'TESS advanced chemistry manual', 'Food Chemistry', 4, 'G10' ,'01839-02', 'Carpeta original', 'Inglés', 'Buscra'),
(5, 'MQO', 'TESS advanced chemistry manual', 'Organic Chemistry', 2, 'G7' ,'01837-01', 'Carpeta original', 'Inglés', 'Buscar'),
(6, 'MQP', 'TESS advanced chemistry manual', 'Chemistry of Polymers', 9, 'G10' ,'01838-02', '5 Engargolados-copias y 4 engargolados-original', 'Inglés', 'Falta MQP-6, Engargolado original (Lo tiene Abraham)');

INSERT INTO kits (id_kits, num_serie, nombre, marca, fk_ubicacion, observaciones, link, caja, cantidad_kits, contenido, cantidad) VALUES
(2, 'Prueba', 'Prueba', 'Prueba', 'EA13', 'Prueba', 'Prueba', 'Prueba', 12, 'Prueba', 1),
(3, '12345', 'Electrolisis', 'Voltech', 'EA12', 'hOLAAA', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3, 2, 'Cables, metal', 2),
(1, '25300-88', 'Conjuntos de Química General', 'Dedutel', 'EA11', 'Incluye (Caja 1 y 2) Se tiene un total de 10 cajas', 'https://www.phywe.com/experiments-sets/student-experiment-sets-tess/student-set-organic-chemistry-tess-advanced-chemistry_2318_3249/', 1, 5, 'Botella de lavado, 250 mL, plástico', 1),
(7, NULL, 'Kit de Cristalización', 'MilliporeSigma', 'G7', 'Incluye (Caja 1 y 2) Se tiene un total de 10 cajas', 'https://www.phywe.com/experiments-sets/student-experiment-sets-tess/student-set-organic-chemistry-tess-advanced-chemistry_2318_3249/', 1, 3, 'Tapón de goma 26/32, 2 orificios, 7 mm', 1),
(8, NULL, 'Kit de Reacciones Químicas', 'Avantor', 'RA2', 'Incluye (Caja 1 y 2) Se tiene un total de 10 cajas', 'Sigma-Aldrich: www.sigmaaldrich.com', 1, 1, 'Tapones de goma, d=22/17 mm, sin orificio', 5);

INSERT INTO sensores (num_serie, nombre, encargado, fk_ubicacion, observaciones, link, cantidad, kit) VALUES
('SN001', 'Sensor de Temperatura', 'Juan Pérez', 'EA11', 'Sensor calibrado en octubre', 'https://example.com/sensor-temp', 10, 1),
('SN002', 'Sensor de Humedad', 'María López', 'G10', 'Precisión ±0.5%', 'https://example.com/sensor-hum', 5, 1),
('SN003', 'Sensor de Presión', 'Carlos Ruiz', 'G7', 'Incluye manual de instalación', 'https://example.com/sensor-pres', 3, 2),
('SN004', 'Sensor de Luz', 'Ana García', 'EA12', 'Requiere limpieza mensual', 'https://example.com/sensor-luz', 2, 2),
('SN005', 'Sensor de Movimiento', 'Pedro Martínez', 'RA2', 'Versión 2024 actualizada', 'https://example.com/sensor-mov', 7, 3),
('SN006', 'Sensor de Gas', NULL, 'EA13', 'En pruebas de calibración', NULL, 4, 3),
('SN007', 'Sensor de Vibración', 'Laura Hernández', 'EA11', 'Sensor resistente a impactos', 'https://example.com/sensor-vib', 6, 4),
('SN008', 'Sensor de Flujo', 'Luis Torres', 'G7', 'Apto para líquidos corrosivos', NULL, 2, 4);
