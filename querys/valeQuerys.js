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
                DATE_FORMAT(va.fecha_solicitada, '%d/%m/%Y %H:%i') AS fecha_solicitada,
                u2.name AS profesor,
                p.nombre AS nombre_practica
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

function transformarResultados(rows) {
    if (!rows || rows.length === 0) return null;
  
    // Extraer la información común del vale
    const primeraFila = rows[0];
    const vale = {
      id_vale: primeraFila.id_vale,
      nombre_alumno: primeraFila.nombre_alumno,
      email_alumno: primeraFila.email_alumno,
      estado_vale: primeraFila.estado_vale,
      observaciones_vale: primeraFila.observaciones_vale,
      fecha_solicitadaVale: primeraFila.fecha_solicitadaVale,
      fecha_asignadaPA: primeraFila.fecha_asignadaPA,
      fecha_entregaPA: primeraFila.fecha_entregaPA,
      practica: {
        id_practica: primeraFila.id_practica,
        nombre_practica: primeraFila.nombre_practica,
        nombre_profesor: primeraFila.nombre_profesor,
        materiales: [],
      },
    };
  
    // Agrupar los materiales relacionados
    rows.forEach((fila) => {
      vale.practica.materiales.push({
        cantidad_material: fila.cantidad_material,
        nombre_item: fila.nombre_item,
        tipo_item: fila.tipo_item,
        cantidad_disponible: fila.cantidad_disponible,
        observacion_item: fila.observacion_item,
      });
    });
  
    return vale;
  }
  
export async function queryValeAlumnoDetails(id_vale){
    try {
        const [rows] = await pool.query(`
            SELECT
                va.id_vale,
                us.name AS nombre_alumno,
                us.email AS email_alumno,
                va.status AS estado_vale,
                va.observaciones AS observaciones_vale,
                DATE_FORMAT(va.fecha_solicitada, '%d/%m/%Y %H:%i') AS fecha_solicitadaVale,
                DATE_FORMAT(pa.fecha_asignada, '%d/%m/%Y %H:%i') AS fecha_asignadaPA,
                DATE_FORMAT(pa.fecha_entrega, '%d/%m/%Y %H:%i') AS fecha_entregaPA,
                p.id_practica AS id_practica,
                p.nombre AS nombre_practica,
                u.name AS nombre_profesor,
                pm.cantidad AS cantidad_material,
                i.nombre AS nombre_item,
                i.tipo AS tipo_item,
                i.cantidad AS cantidad_disponible,
                i.observacion AS observacion_item
            FROM
                vale_alumno va
            JOIN
                users us ON va.fk_alumno_users_vale = us.id_user
            JOIN
                practicas_asignadas pa ON va.fk_pa_vale = pa.id_pa
            JOIN
                practicas p ON pa.fk_practicas_pa = p.id_practica
            JOIN
                users u ON p.fk_profesor_users_practica = u.id_user
            JOIN
                practicas_materiales pm ON p.id_practica = pm.fk_practicas_pm
            JOIN
                items i ON pm.fk_items_pm = i.id_item
            WHERE
                va.id_vale = ?;`, [id_vale]
        );
        return transformarResultados(rows);
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}