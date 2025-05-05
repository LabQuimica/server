import pool from '../database.js';

export async function getDocentes() {
    try {
        const [results] = await pool.query(`
            SELECT id_user, name, email, img
            FROM users 
            WHERE rol = 'profesor';
        `);
        
        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

export async function getPracticasCreadasDocente(id_docente){
    try {
        const [results] = await pool.query(`
            SELECT 
                p.id_practica,
                u.name AS docente,
                p.nombre,
                p.descripcion,
                DATE_FORMAT(p.fecha_creacion, '%d/%m/%Y %H:%i') AS fecha_creacion,
                DATE_FORMAT(p.fecha_modificacion, '%d/%m/%Y %H:%i') AS fecha_modificacion,
                CASE WHEN COUNT(pa.id_pa) > 0 THEN true ELSE false END AS esta_asignada,
                GROUP_CONCAT(DISTINCT g.nombre SEPARATOR ', ') AS grupos,
                GROUP_CONCAT(DISTINCT g.semestre SEPARATOR ', ') AS semestres,
                GROUP_CONCAT(DISTINCT pa.status SEPARATOR ', ') AS estatuses
            FROM practicas p
            LEFT JOIN users u ON p.fk_profesor_users_practica = u.id_user
            LEFT JOIN practicas_asignadas pa ON p.id_practica = pa.fk_practicas_pa AND pa.status != 'inhabilitada'
            LEFT JOIN grupo g ON pa.fk_grupo_pa = g.id_grupo
            WHERE p.fk_profesor_users_practica = ?
            GROUP BY p.id_practica;
            `,
            [id_docente]
        );
        
        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

export async function getPracticasAsignadasDocente(id_docente) {
    try {
      const [results] = await pool.query(
        `
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
        WHERE p.fk_profesor_users_practica = ?
        AND pa.status != 'inhabilitada';
        `,
        [id_docente]
      );
  
      return results;
    } catch (error) {
      console.error("Error al ejecutar la consulta:", error);
      throw error;
    }
}

export async function getPracticasInhabilitadasDocente(id_docente) {
    try {
      const [results] = await pool.query(
        `
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
            WHERE p.fk_profesor_users_practica = ?
            AND pa.status = 'inhabilitada';
        `,
        [id_docente]
      );
  
      return results;
    } catch (error) {
      console.error("Error al ejecutar la consulta:", error);
      throw error;
    }
}

export async function getDocentePractica(id_practica) {
    try {
        const [results] = await pool.query(`
        SELECT u.name, u.email, u.rol, u.img
        FROM practicas p
        JOIN users u ON p.fk_profesor_users_practica = u.id_user
        WHERE p.id_practica = ?;
        `,
        [id_practica]);
        
        return results[0];
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}