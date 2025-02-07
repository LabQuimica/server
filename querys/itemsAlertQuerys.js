// Aqui van los querys para los INVENTARIOS

import pool from '../database.js';
import {infoItems} from '../models/itemsAlertQuieries.js';

export async function getItemsAlert() {      // Obtener los usuarios
    try {
        const [rows] = await pool.query(infoItems);
        return rows;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

