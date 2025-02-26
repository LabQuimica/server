import pool from "../database.js";
import { allVales } from "../models/valeQueries.js";

export async function getVales() {
  try {
    const [rows] = await pool.query(allVales);
    return rows;
  } catch (error) {
    console.error("Error al ejecutar la consulta:", error);
    throw error;
  }
}
export async function updateValeWithStatusAndComment(
  id_vale,
  newStatus,
  newObservation
) {
  await pool.query(
    "UPDATE vale_alumno SET status = ?, observaciones = ? WHERE id_vale = ?;",
    [newStatus, newObservation, id_vale]
  );
  return {
    status: 200,
    data: {
      message: `Vale ${id_vale} actualizado con nuevo estado y comentario`,
    },
  };
}

export async function updateValeWithStatus(id_vale, newStatus) {
  await pool.query("UPDATE vale_alumno SET status = ? WHERE id_vale = ?;", [
    newStatus,
    id_vale,
  ]);
  return {
    status: 200,
    data: { message: `Vale ${id_vale} actualizado con nuevo estado` },
  };
}

export async function updateValeWithComment(id_vale, newObservation) {
  await pool.query(
    "UPDATE vale_alumno SET observaciones = ? WHERE id_vale = ?;",
    [newObservation, id_vale]
  );
  return {
    status: 200,
    data: { message: `Vale ${id_vale} actualizado con nuevo comentario` },
  };
}

export async function updateVales(vales) {
  try {
    for (const vale of vales) {
      const { id_vale, newStatus } = vale;
      await pool.query("UPDATE vale_alumno SET status = ? WHERE id_vale = ?", [
        newStatus,
        id_vale,
      ]);
    }
    return {
      status: 200,
      data: { message: "Vales actualizados correctamente" },
    };
  } catch (error) {
    console.error("Error al actualizar vales:", error);
    return { status: 500, data: { error: "Error interno del servidor" } };
  }
}

export async function getValeStatus(estado) {
  try {
    const [rows] = await pool.query(
      `
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
                va.status = ?;`,
      [estado]
    );
    return rows;
  } catch (error) {
    console.error("Error al ejecutar la consulta:", error);
    throw error;
  }
}

function valeDetailsObject(rows) {
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

export async function queryValeAlumnoDetails(id_vale) {
  try {
    const [rows] = await pool.query(
      `
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
                va.id_vale = ?;`,
      [id_vale]
    );
    return valeDetailsObject(rows);
  } catch (error) {
    console.error("Error al ejecutar la consulta:", error);
    throw error;
  }
}

// Profesor
export async function getValeProfesorStatus(estado) {
  try {
    const [rows] = await pool.query(
      `
            SELECT
                pa.id_pa,
                u.name AS nombre_profesor,
                g.nombre AS nombre_materia,
                g.semestre,
                DATE_FORMAT(pa.fecha_asignada, '%d/%m/%Y %H:%i') AS fecha_asignada,
                DATE_FORMAT(pa.fecha_entrega, '%d/%m/%Y %H:%i') AS fecha_entrega,
                p.nombre AS nombre_practica,
                pa.status AS status_practica
            FROM
                practicas_asignadas pa
            JOIN
                practicas p ON pa.fk_practicas_pa = p.id_practica
            JOIN
                users u ON p.fk_profesor_users_practica = u.id_user
            JOIN
                grupo g ON pa.fk_grupo_pa = g.id_grupo
            WHERE
                pa.status = ?;`,
      [estado]
    );
    return rows;
  } catch (error) {
    console.error("Error al ejecutar la consulta:", error);
    throw error;
  }
}

export async function getValeProfesorDetails(id_practica_asignada) {
  try {
    const [rows] = await pool.query(
      `
          SELECT
              pa.id_pa AS id_practica_asignada,
              pa.status AS status_practica,
              DATE_FORMAT(pa.fecha_asignada, '%d/%m/%Y %H:%i') AS fecha_asignada,
              DATE_FORMAT(pa.fecha_entrega, '%d/%m/%Y %H:%i') AS fecha_entrega,
              g.nombre AS nombre_grupo,
              g.semestre AS semestre_grupo,
              i.id_item,
              i.nombre AS nombre_item,
              i.tipo AS tipo_item,
              i.cantidad AS cantidad_disponible,
              i.ubicacion,
              pm.cantidad AS cantidad_unitaria,
              pm.contable,
              CASE
                  WHEN pm.contable = TRUE THEN pm.cantidad * p.num_equipos
                  ELSE pm.cantidad
              END AS cantidad_total_necesaria
          FROM
              practicas_asignadas pa
          JOIN
              practicas p ON pa.fk_practicas_pa = p.id_practica
          JOIN
              practicas_materiales pm ON p.id_practica = pm.fk_practicas_pm
          JOIN
              items i ON pm.fk_items_pm = i.id_item
          JOIN
              grupo g ON pa.fk_grupo_pa = g.id_grupo
          WHERE
              pa.id_pa = ?;`,
      [id_practica_asignada]
    );

    if (rows.length === 0) return null;

    const practica = {
      id_practica_asignada: rows[0].id_practica_asignada,
      status_practica: rows[0].status_practica,
      fecha_asignada: rows[0].fecha_asignada,
      fecha_entrega: rows[0].fecha_entrega,
      nombre_grupo: rows[0].nombre_grupo,
      semestre_grupo: rows[0].semestre_grupo,
      items: rows.map((row) => ({
        id_item: row.id_item,
        nombre_item: row.nombre_item,
        tipo_item: row.tipo_item,
        cantidad_disponible: row.cantidad_disponible,
        ubicacion: row.ubicacion,
        cantidad_unitaria: row.cantidad_unitaria,
        contable: row.contable,
        cantidad_total_necesaria: row.cantidad_total_necesaria,
      })),
    };

    return practica;
  } catch (error) {
    console.error("Error al ejecutar la consulta:", error);
    throw error;
  }
}
