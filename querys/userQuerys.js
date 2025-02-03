// Aqui van los querys para los USUARIOS

import pool from '../database.js';
import {users} from '../models/userQueries.js';

export async function getUsers() {      // Obtener los usuarios
    try {
        const [rows] = await pool.query(users);
        return rows;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

