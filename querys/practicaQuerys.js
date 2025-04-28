import pool from '../database.js';

// Recuperar todas las practicas creadas
export async function getPracticasCreadas() {
    try {
        const [results] = await pool.query(`
            SELECT 
                p.id_practica,
                u.name as docente,
                u.email as docentemail,
                u.rol as docenterol,
                u.img as docenteavatar,
                p.nombre,
                p.descripcion,
                DATE_FORMAT(p.fecha_creacion, '%d/%m/%Y %H:%i') AS fecha_creacion,
                DATE_FORMAT(p.fecha_modificacion, '%d/%m/%Y %H:%i') AS fecha_modificacion,
                CASE WHEN pa.id_pa IS NOT NULL THEN true ELSE false 
                END as esta_asignada,
                g.nombre as grupo,
                g.semestre,
                pa.status
            FROM practicas p
            LEFT JOIN users u ON p.fk_profesor_users_practica = u.id_user
            LEFT JOIN practicas_asignadas pa ON p.id_practica = pa.fk_practicas_pa
            LEFT JOIN grupo g ON pa.fk_grupo_pa = g.id_grupo
            WHERE pa.status != 'inhabilitada';
        `);
        
        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

// Recuperar todas las practicas asignadas
export async function getPracticasAsignadas() {
    try {
        const [results] = await pool.query(`
          SELECT 
            p.id_practica,
            u.name AS docente,
            p.nombre AS nombre,
            p.descripcion AS descripcion,
            DATE_FORMAT(p.fecha_creacion, '%d/%m/%Y %H:%i') AS fecha_creacion,
            DATE_FORMAT(p.fecha_modificacion, '%d/%m/%Y %H:%i') AS fecha_modificacion,
            g.nombre AS grupo,
            g.semestre,
            pa.status
          FROM practicas_asignadas pa
          JOIN practicas p ON pa.fk_practicas_pa = p.id_practica
          JOIN users u ON p.fk_profesor_users_practica = u.id_user
          JOIN grupo g ON pa.fk_grupo_pa = g.id_grupo
          WHERE pa.status != 'inhabilitada';
        `);
        
        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

// Recuperar practica por su ID
export async function getPracticaById(id_practica) {
  try {
      const [results] = await pool.query(
          `
          SELECT 
              p.id_practica,
              p.nombre,
              p.descripcion,
              DATE_FORMAT(p.fecha_creacion, '%d/%m/%Y %H:%i') AS fecha_creacion,
              DATE_FORMAT(p.fecha_modificacion, '%d/%m/%Y %H:%i') AS fecha_modificacion,
              COALESCE(
                  JSON_ARRAYAGG(
                      JSON_OBJECT(
                          'id_item', i.id_item,
                          'nombre', i.nombre,
                          'cantidad', pm.cantidad
                      )
                  ), 
                  JSON_ARRAY()
              ) AS materiales
          FROM practicas p
          LEFT JOIN practicas_materiales pm ON p.id_practica = pm.fk_practicas_pm
          LEFT JOIN items i ON pm.fk_items_pm = i.id_item
          WHERE p.id_practica = ?
          GROUP BY p.id_practica
          `,
          [id_practica]
      );

      return results.length > 0 ? results[0] : null;
  } catch (error) {
      console.error('Error al ejecutar la consulta:', error);
      throw error;
  }
}

// Crear una practica
export async function crearPractica(nombre, descripcion, num_equipos, creadorId, materiales) {
    const [creador] = await pool.query(
      `SELECT id_user FROM users WHERE id_user = ? AND rol IN ('profesor', 'administrador')`,
      [creadorId]
    );
  
    if (creador.length === 0) {
      throw new Error('El usuario no es un profesor o administrador');
    }
    
    const [result] = await pool.query(
      `INSERT INTO practicas 
        (nombre, descripcion, num_equipos,fk_profesor_users_practica) 
       VALUES (?, ?, ?, ?)`,
      [nombre, descripcion, num_equipos, creadorId]
    );

    const practicaId = result.insertId;

    // Agregar materiales de practica
    if (materiales && materiales.length > 0) {
      const valores = materiales.map(({ itemId, cantidad }) => 
          [practicaId, itemId, cantidad]
      );

      await pool.query(
          `INSERT INTO practicas_materiales (fk_practicas_pm, fk_items_pm, cantidad) VALUES ?`,
          [valores]
      );
  }
    
    // Comprobar la practica creada
    const [newPractice] = await pool.query(`
      SELECT 
        p.id_practica, 
        p.nombre, 
        p.descripcion, 
        p.fecha_creacion, 
        p.fecha_modificacion,
        p.num_equipos,
        u.name AS profesor_nombre,
        u.email AS profesor_email
      FROM practicas p
      JOIN users u ON p.fk_profesor_users_practica = u.id_user
      WHERE p.id_practica = ?
    `, [result.insertId]);
  
    return newPractice[0];
}

// Eliminar practica
export async function deletePractica(practiceId, profesorId) {
    const [user] = await pool.query(`
      SELECT id_user FROM users WHERE id_user = ? AND rol IN ('profesor', 'administrador')`,
      [profesorId]
    );
    if (user.length === 0) {
      throw new Error('No autorizado para eliminar prácticas');
    }
  
    const connection = await pool.getConnection();
    try {
      await connection.beginTransaction();
  
      // 1. Primero eliminar los vales de alumnos relacionados
      await connection.query(
        `DELETE va FROM vale_alumno va
         INNER JOIN practicas_asignadas pa ON va.fk_pa_vale = pa.id_pa
         WHERE pa.fk_practicas_pa = ?`,
        [practiceId]
      );
  
      // 2. Eliminar las prácticas asignadas
      await connection.query(
        'DELETE FROM practicas_asignadas WHERE fk_practicas_pa = ?',
        [practiceId]
      );
  
      // 3. Eliminar los materiales de la práctica
      await connection.query(
        'DELETE FROM practicas_materiales WHERE fk_practicas_pm = ?',
        [practiceId]
      );
  
      // 4. Finalmente eliminar la práctica
      const [result] = await connection.query(
        'DELETE FROM practicas WHERE id_practica = ?',
        [practiceId]
      );
  
      if (result.affectedRows === 0) {
        throw new Error('Práctica no encontrada');
      }
  
      await connection.commit();
      return { message: 'Práctica y registros relacionados eliminados exitosamente' };
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
}

export async function asignarPractica(practica, grupo, fecha_inicio, fehca_fin) {
  const [results] = await pool.query(`
    INSERT INTO practicas_asignadas (fk_practicas_pa, fk_grupo_pa, fecha_inicio, fecha_fin)
    VALUES (?, ?, ?, ?);
    `,
    [practica, grupo, fecha_inicio, fehca_fin]
  );

  return results[0];
}

export async function updatePractica(id_practica, data) {
  try {
      const { nombre, descripcion, materiales } = data;
      const connection = await pool.getConnection();
      
      await connection.beginTransaction();
      if (nombre || descripcion) {
          await connection.query(
              `UPDATE practicas 
               SET nombre = COALESCE(?, nombre), 
                   descripcion = COALESCE(?, descripcion) 
               WHERE id_practica = ?`,
              [nombre, descripcion, id_practica]
          );
      }

      if (materiales && Array.isArray(materiales)) {
          for (const material of materiales) {
              const { id_item, cantidad } = material;
              if (id_item && cantidad !== undefined) {

                  const [rows] = await connection.query(
                    `SELECT * FROM practicas_materiales WHERE fk_practicas_pm = ? AND fk_items_pm = ?`,
                    [id_practica, id_item]
                  );

                  if (rows.length > 0) {
                    await connection.query(
                      `UPDATE practicas_materiales 
                       SET cantidad = ? 
                       WHERE fk_practicas_pm = ? AND fk_items_pm = ?`,
                      [cantidad, id_practica, id_item]
                    );
                  } else {
                    await connection.query(
                      `INSERT INTO practicas_materiales (fk_practicas_pm, fk_items_pm, cantidad) VALUES 
                      (?, ?, ?)`,
                      [id_practica, id_item, cantidad]
                    );
                  }
              }
          }
      }

      await connection.commit();
      connection.release();

      return { success: true, message: "Práctica actualizada correctamente" };
  } catch (error) {
      console.error("Error al actualizar la práctica:", error);
      if (connection) await connection.rollback();
      throw error;
  }
}

export async function deleteMaterialPractica(id_practica, id_material) {
  const [practica] = await pool.query(`SELECT * FROM practicas WHERE id_practica = ?`, [id_practica]);

  if (practica.lenght != 0){
    const [relacion] = await pool.query(
      `SELECT * FROM practicas_materiales WHERE fk_practicas_pm = ? AND fk_items_pm = ?`, 
      [id_practica, id_material]
    );

    if (relacion.length != 0) {
      const [results] = await pool.query(
        `DELETE FROM practicas_materiales
        WHERE fk_practicas_pm = ? AND fk_items_pm = ?;`,
        [id_practica, id_material]
      );

      return results[0];
    }
  }
}

export async function updateStatusPractica(
  id_practica,
  newStatus
) {
  await pool.query(
    "UPDATE practicas_asignadas SET status = ? WHERE fk_practicas_pa = ?",
    [newStatus, id_practica]
  );
  return {
    status: 200,
    data: {
      message: `Practica ${id_practica} actualizada con nuevo estado`,
    },
  };
}

// Recuperar todas las practicas inhabilitadas
export async function getPracticasInhabilitadas() {
  try {
      const [results] = await pool.query(`
        SELECT 
          p.id_practica,
          u.name AS docente,
          p.nombre AS nombre,
          p.descripcion AS descripcion,
          DATE_FORMAT(p.fecha_creacion, '%d/%m/%Y %H:%i') AS fecha_creacion,
          DATE_FORMAT(p.fecha_modificacion, '%d/%m/%Y %H:%i') AS fecha_modificacion,
          g.nombre AS grupo,
          g.semestre,
          pa.status
        FROM practicas_asignadas pa
        JOIN practicas p ON pa.fk_practicas_pa = p.id_practica
        JOIN users u ON p.fk_profesor_users_practica = u.id_user
        JOIN grupo g ON pa.fk_grupo_pa = g.id_grupo
        WHERE pa.status = 'inhabilitada';
      `);
      
      return results;
  } catch (error) {
      console.error('Error al ejecutar la consulta:', error);
      throw error;
  }
}

// Inhabilitar para un grupo en especifico
export async function inhabilitarPracticaByGroup(id_practica, id_grupo){
  await pool.query(
    `UPDATE practicas_asignadas
     SET status = 'inhabilitada'
     WHERE fk_practicas_pa = ?
     AND fk_grupo_pa = ?;
    `, [id_practica, id_grupo]
  )
}

// Inhabilitar para todos los grupos
export async function inhabilitarPractica(id_practica){
  await pool.query(
    `UPDATE practicas_asignadas
     SET status = 'inhabilitada'
     WHERE fk_practicas_pa = ?;
    `, [id_practica]
  )
}

// Inhabilitar todas las practicas de un grupo (normalmente cuando acaba el semestre)
export async function inhabilitarPracticasGroup(id_grupo){
  await pool.query(
    `UPDATE practicas_asignadas
     SET status = 'inhabilitada'
     WHERE fk_grupo_pa = ?;
    `, [id_grupo]
  )
}