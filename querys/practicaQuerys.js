import pool from '../database.js';

// Recuperar todas las practicas
export async function getPracticas() {
    try {
        const [results] = await pool.query(`
            SELECT 
                p.id_practica,
                u.name as docente,
                p.nombre,
                p.descripcion,
                p.fecha_creacion,
                p.fecha_modificacion,
                CASE WHEN pa.id_pa IS NOT NULL THEN true ELSE false 
                END as esta_asignada,
                g.nombre as grupo,
                g.semestre,
                pa.status
            FROM practicas p
            LEFT JOIN users u ON p.fk_profesor_users_practica = u.id_user
            LEFT JOIN practicas_asignadas pa ON p.id_practica = pa.fk_practicas_pa
            LEFT JOIN grupo g ON pa.fk_grupo_pa = g.id_grupo
        `);
        
        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

// Crear una practica
export async function crearPractica(nombre, descripcion, creadorId) {
    const [creador] = await pool.query(
      `SELECT id_user FROM users WHERE id_user = ? AND rol IN ('profesor', 'administrador')`,
      [creadorId]
    );
  
    if (creador.length === 0) {
      throw new Error('El usuario no es un profesor o administrador');
    }
    
    const [result] = await pool.query(
      `INSERT INTO practicas 
        (nombre, descripcion, fk_profesor_users_practica) 
       VALUES (?, ?, ?)`,
      [nombre, descripcion, creadorId]
    );
    
    // Comprobar la practica creada
    const [newPractice] = await pool.query(`
      SELECT 
        p.id_practica, 
        p.nombre, 
        p.descripcion, 
        p.fecha_creacion, 
        p.fecha_modificacion,
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