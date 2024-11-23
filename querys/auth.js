import pool from '../database.js'

export async function getUser(id){
    const [rows] = await pool.query("SELECT * FROM users WHERE id_user = ?", [id])
    return rows[0]
}

export async function getUsers(){
    const [rows] = await pool.query("SELECT * FROM users")
    return rows
}
