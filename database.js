import mysql from "mysql2"
import dotenv from "dotenv"
dotenv.config()

// console.log('Host:', process.env.DB_HOST);
// console.log('Usuario:', process.env.DB_USER);
// console.log('Base de datos:', process.env.DB_NAME);

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME
}).promise()

export default pool