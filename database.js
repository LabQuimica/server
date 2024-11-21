import mysql from "mysql2"
import dotenv from "dotenv"
dotenv.config()

export const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME
}).promise()

export async function getUser(id){
    const [rows] = await pool.query("SELECT * FROM users WHERE id_user = ?", [id])
    return rows[0]
}

export async function getUsers(){
    const [rows] = await pool.query("SELECT * FROM users")
    return rows
}


