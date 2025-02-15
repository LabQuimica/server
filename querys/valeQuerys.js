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
        }
        return { status: 200, data: { message: 'Vales actualizados correctamente' } };
    } catch (error) {
        console.error('Error al actualizar vales:', error);
        return { status: 500, data: { error: 'Error interno del servidor' } };
    }
}

export async function getValeStatus(estado) {
    try {
        const [rows] = await pool.query(`
            SELECT
                va.id_vale,
                u.name AS alumno,
                g.nombre,
                g.semestre,
                va.status AS estado_vale,
                va.observaciones AS observaciones_vale,
                va.fecha_solicitada,
                va.fecha_modificacion,
                u2.name AS profesor,
                pa.status AS estado_practica
            FROM
                vale_alumno va
            JOIN
                practicas_asignadas pa on va.fk_pa_vale = pa.id_pa
            JOIN
                grupo g on pa.fk_grupo_pa = g.id_grupo
            JOIN
                users u on va.fk_alumno_users_vale = u.id_user
            JOIN
                practicas p on pa.fk_practicas_pa = p.id_practica
            JOIN
                users u2 on p.fk_profesor_users_practica = u2.id_user
            WHERE
                va.status = ?;`, [estado]
        );
        return rows;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}