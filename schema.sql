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


--- insert data into table users

INSERT INTO users (name, email, password, rol, active) VALUES
('Juan Pérez', 'juan.perez@example.com', 'hashed_password_juan', 'administrador', TRUE),
('Ana López', 'ana.lopez@example.com', 'hashed_password_ana', 'profesor', TRUE),
('Carlos Ramírez', 'carlos.ramirez@example.com', 'hashed_password_carlos', 'alumno', TRUE),
('María Fernández', 'maria.fernandez@example.com', 'hashed_password_maria', 'profesor', FALSE),
('Luis García', 'luis.garcia@example.com', 'hashed_password_luis', 'alumno', TRUE);



