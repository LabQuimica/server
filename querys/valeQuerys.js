import pool from '../database.js';
import {allVales} from '../models/valeQueries.js';

export async function getVales() {
    try {
        const [rows] = await pool.query(allVales);
        return rows;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}