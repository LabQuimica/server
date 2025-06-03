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
    boleta: primeraFila.boleta,
    estado_vale: primeraFila.estado_vale,
    observaciones_vale: primeraFila.observaciones_vale,
    fecha_solicitadaVale: primeraFila.fecha_solicitadaVale,
    fecha_inicio: primeraFila.fecha_inicio,
    fecha_fin: primeraFila.fecha_fin,
    practica: {
      id_practica: primeraFila.id_practica,
      nombre_practica: primeraFila.nombre_practica,
      nombre_semestre: primeraFila.nombre_semestre,
      semestre: primeraFila.semestre,
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
      caracteristica: fila.especial,
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
            us.codigo AS boleta,
            va.status AS estado_vale,
            va.observaciones AS observaciones_vale,
            DATE_FORMAT(va.fecha_solicitada, '%d/%m/%Y %H:%i') AS fecha_solicitadaVale,
            DATE_FORMAT(pa.fecha_inicio, '%d/%m/%Y %H:%i') AS fecha_inicio,
            DATE_FORMAT(pa.fecha_fin, '%d/%m/%Y %H:%i') AS fecha_fin,
            p.id_practica AS id_practica,
            p.nombre AS nombre_practica,
            g.nombre AS nombre_semestre,
            g.semestre,
            u.name AS nombre_profesor,
            pm.cantidad AS cantidad_material,
            i.nombre AS nombre_item,
            i.tipo AS tipo_item,
            i.cantidad AS cantidad_disponible,
            i.observacion AS observacion_item,
            i.especial
        FROM
            vale_alumno va
        JOIN
            users us ON va.fk_alumno_users_vale = us.id_user
        JOIN
            practicas_asignadas pa ON va.fk_pa_vale = pa.id_pa
        JOIN
            grupo g ON pa.fk_grupo_pa = g.id_grupo
        JOIN
            practicas p ON pa.fk_practicas_pa = p.id_practica
        JOIN
            users u ON p.fk_profesor_users_practica = u.id_user
        JOIN
            practicas_materiales pm ON p.id_practica = pm.fk_practicas_pm
        JOIN
            items i ON pm.fk_items_pm = i.id_item
        WHERE
            va.id_vale = ?;
          `,
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
                DATE_FORMAT(pa.fecha_inicio, '%d/%m/%Y %H:%i') AS fecha_asignada,
                DATE_FORMAT(pa.fecha_fin, '%d/%m/%Y %H:%i') AS fecha_entrega,
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
          u.name AS nombre_usuario,
          u.email,
          p.nombre AS nombre_practica,
          p.id_practica as id_practica,
          pa.id_pa AS id_practica_asignada,
          pa.status AS status_practica,
          DATE_FORMAT(pa.fecha_inicio, '%d/%m/%Y %H:%i') AS fecha_asignada,
          DATE_FORMAT(pa.fecha_fin, '%d/%m/%Y %H:%i') AS fecha_entrega,
          g.nombre AS nombre_grupo,
          g.semestre AS semestre_grupo,
          i.id_item,
          i.num_serie,
          i.observacion,
          i.especial,
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
      JOIN
          users u ON p.fk_profesor_users_practica = u.id_user
      WHERE
              pa.id_pa = ?;`,
      [id_practica_asignada]
    );

    if (rows.length === 0) return null;

    const practica = {
      nombre_usuario: rows[0].nombre_usuario,
      email: rows[0].email,
      nombre_practica: rows[0].nombre_practica,
      id_practica: rows[0].id_practica,
      id_practica_asignada: rows[0].id_practica_asignada,
      status_practica: rows[0].status_practica,
      fecha_asignada: rows[0].fecha_asignada,
      fecha_entrega: rows[0].fecha_entrega,
      nombre_grupo: rows[0].nombre_grupo,
      semestre_grupo: rows[0].semestre_grupo,
      items: rows.map((row) => ({
        id_item: row.id_item,
        nombre_item: row.nombre_item,
        num_serie: row.num_serie,
        observacion: row.observacion,
        especial: row.especial,
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

function agruparValesConMateriales(rows) {
  if (!rows || rows.length === 0) {
    return [];
  }
  const valesMap = new Map();

  rows.forEach((row) => {
    const valeId = row.id_vale;
    let valeEntry = valesMap.get(valeId);

    if (!valeEntry) {
      valeEntry = {
        id_vale: row.id_vale,
        nombre_alumno: row.nombre_alumno,
        email_alumno: row.email_alumno,
        boleta: row.boleta,
        estado_vale: row.estado_vale,
        observaciones_vale: row.observaciones_vale,
        fecha_solicitadaVale: row.fecha_solicitadaVale,
        fecha_inicio: row.fecha_inicio,
        fecha_fin: row.fecha_fin,
        practica: {
          id_practica: row.id_practica,
          nombre_practica: row.nombre_practica,
          nombre_semestre: row.nombre_semestre,
          semestre: row.semestre,
          nombre_profesor: row.nombre_profesor,
          materiales: [],
        },
      };
      valesMap.set(valeId, valeEntry);
    }

    // Creamos el objeto material con la información de la fila actual.
    const material = {
      nombre_item: row.nombre_item,
      tipo_item: row.tipo_item,
      cantidad_solicitada: row.cantidad_material,
      cantidad_disponible_inventario: row.cantidad_disponible,
      observacion_item: row.observacion_item,
      especial: row.especial,
    };

    // Agregamos el material a la lista de materiales de la práctica del vale correspondiente.
    if (row.nombre_item) {
      valeEntry.practica.materiales.push(material);
    }
  });

  return Array.from(valesMap.values());
}

export async function queryGetAllValesAlumno(fk_alumno_users_vale) {
  try {
    const [rows] = await pool.query(
      `
          SELECT
            va.id_vale,
            us.name AS nombre_alumno,
            us.email AS email_alumno,
            us.codigo AS boleta,
            va.status AS estado_vale,
            va.observaciones AS observaciones_vale,
            DATE_FORMAT(va.fecha_solicitada, '%d/%m/%Y %H:%i') AS fecha_solicitadaVale,
            DATE_FORMAT(pa.fecha_inicio, '%d/%m/%Y %H:%i') AS fecha_inicio,
            DATE_FORMAT(pa.fecha_fin, '%d/%m/%Y %H:%i') AS fecha_fin,
            p.id_practica AS id_practica,
            p.nombre AS nombre_practica,
            g.nombre AS nombre_semestre,
            g.semestre,
            u.name AS nombre_profesor,
            pm.cantidad AS cantidad_material,
            i.nombre AS nombre_item,
            i.tipo AS tipo_item,
            i.cantidad AS cantidad_disponible,
            i.observacion AS observacion_item,
            i.especial
        FROM
            vale_alumno va
        JOIN
            users us ON va.fk_alumno_users_vale = us.id_user
        JOIN
            practicas_asignadas pa ON va.fk_pa_vale = pa.id_pa
        JOIN
            grupo g ON pa.fk_grupo_pa = g.id_grupo
        JOIN
            practicas p ON pa.fk_practicas_pa = p.id_practica
        JOIN
            users u ON p.fk_profesor_users_practica = u.id_user
        JOIN
            practicas_materiales pm ON p.id_practica = pm.fk_practicas_pm
        JOIN
            items i ON pm.fk_items_pm = i.id_item
        WHERE
            va.fk_alumno_users_vale = ? AND va.status IN ('pendiente', 'progreso')
        ORDER BY
            va.fecha_solicitada DESC, va.id_vale DESC;
          `,
      [fk_alumno_users_vale]
    );
    return agruparValesConMateriales(rows);
  } catch (error) {
    console.error("Error al ejecutar la consulta:", error);
    throw error;
  }
}
function agruparValesConMaterialesProfesor(rows) {
  if (!rows || rows.length === 0) {
    return [];
  }
  const valesMap = new Map();

  rows.forEach((row) => {
    const valeId = row.id_vale;
    let valeEntry = valesMap.get(valeId);

    if (!valeEntry) {
      valeEntry = {
        id_practica_asignada: row.id_practica_asignada,
        status_practica: row.status_practica,
        fecha_inicio: row.fecha_asignada,
        fecha_fin: row.fecha_entrega,
        nombre_grupo: row.nombre_grupo,
        semestre_grupo: row.semestre_grupo,
        id_practica: row.id_practica,
        nombre_practica: row.nombre_practica,
        materiales: [],
      };
      valesMap.set(valeId, valeEntry);
    }

    // Creamos el objeto material con la información de la fila actual.
    const material = {
      nombre_item: row.nombre_item,
      tipo_item: row.tipo_item,
      ubicacion: row.ubicacion,
      cantidad_unitaria: row.cantidad_unitaria,
      observacion: row.observacion,
      especial: row.especial,
      cantidad_total_necesaria: row.cantidad_total_necesaria,
    };

    // Agregamos el material a la lista de materiales del vale correspondiente.
    if (row.nombre_item) {
      valeEntry.materiales.push(material); // CAMBIO AQUÍ: era valeEntry.practica.materiales
    }
  });

  return Array.from(valesMap.values());
}

export async function queryGetAllValesProfesor(id_users_vale) {
  try {
    const [rows] = await pool.query(
      `
        SELECT
          pa.id_pa as id_vale,
          p.id_practica as id_practica,
          p.nombre AS nombre_practica,
          pa.id_pa AS id_practica_asignada,
          pa.status AS status_practica,
          DATE_FORMAT(pa.fecha_inicio, '%d/%m/%Y %H:%i') AS fecha_asignada,
          DATE_FORMAT(pa.fecha_fin, '%d/%m/%Y %H:%i') AS fecha_entrega,
          g.nombre AS nombre_grupo,
          g.semestre AS semestre_grupo,
          i.nombre AS nombre_item,
          i.tipo AS tipo_item,
          i.ubicacion,
          i.observacion,
          i.especial,
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
        JOIN
          users u ON p.fk_profesor_users_practica = u.id_user
        WHERE
              p.fk_profesor_users_practica = ? AND pa.status IN ('pendiente', 'progreso')
        ORDER BY
            pa.fecha_asignada DESC, p.id_practica DESC;
          `,
      [id_users_vale]
    );
    return agruparValesConMaterialesProfesor(rows);
  } catch (error) {
    console.error("Error al ejecutar la consulta:", error);
    throw error;
  }
}
