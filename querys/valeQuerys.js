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
export async function updateVales(vales) {
    try {
        for (const vale of vales) {
            const { id_vale, newStatus } = vale;
            await pool.query(
                'UPDATE vale_alumno SET status = ? WHERE id_vale = ?',
                [newStatus, id_vale]
            );
            console.log(`Vale ${id_vale} actualizado a status: ${newStatus}`);
        }
        return { status: 200, data: { message: 'Vales actualizados correctamente' } };
    } catch (error) {
        console.error('Error al actualizar vales:', error);
        return { status: 500, data: { error: 'Error interno del servidor' } };
    }
}