import mysql from "mysql2";
import dotenv from "dotenv";

dotenv.config();

const dbConfig = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
};

const pool = mysql.createPool(dbConfig).promise();

// Verificar conexión a la base de datos
(async () => {
    try {
        const connection = await pool.getConnection();
        console.log("Conexión exitosa a la base de datos.");
        connection.release(); 
    } catch (error) {
        console.error("Error al conectar con la base de datos:", error.message);
        process.exit(1); 
    }
})();

export default pool;
