import pool from "../database.js";

export async function getGrupos(){
    try {
        const [results] = await pool.query(`
            SELECT * FROM grupo;
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

export async function getGruposPractica(id_practica){
    try {
        const [results] = await pool.query(`
            SELECT 
                grupo.id_grupo,
                grupo.nombre,
                grupo.semestre
            FROM 
                practicas_asignadas
            INNER JOIN 
                grupo ON practicas_asignadas.fk_grupo_pa = grupo.id_grupo
            WHERE 
                practicas_asignadas.fk_practicas_pa = ?;
        `,[id_practica]
        );

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

export async function getGrupoCode(id_grupo){
    try {
        const [results] = await pool.query(`
            SELECT codigo
            FROM grupo
            WHERE id_grupo = ?;
        `,[id_grupo]
    );
        return results[0];
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}

export async function addGrupoCode(id_grupo, codigo) {
    try {
      const [results] = await pool.query(`
        UPDATE grupo
        SET codigo = ?
        WHERE id_grupo = ?;
      `, [codigo, id_grupo]);
  
      return results;
    } catch (error) {
      console.error('Error al ejecutar la consulta:', error);
      throw error;
    }
}  

export async function getGruposByUsuario(id_usuario) {
    try {
        const [rolResult] = await pool.query(`
            SELECT rol 
            FROM users 
            WHERE id_user = ?;
        `, [id_usuario]);

        if (rolResult.length === 0) {
            throw new Error('Usuario no encontrado');
        }

        const rol = rolResult[0].rol;

        if (rol === "alumno") {
            const [results] = await pool.query(`
                SELECT 
                    g.id_grupo,
                    g.nombre,
                    g.semestre,
                    g.codigo
                FROM 
                    grupo g
                JOIN 
                    grupo_alumnos ga ON g.id_grupo = ga.fk_grupo_ga
                WHERE 
                    ga.fk_alumno_users_ga = ?;
            `, [id_usuario]);

            return results;
        } else if (rol === "profesor") {
            const [results] = await pool.query(`
                SELECT 
                    g.id_grupo,
                    g.nombre,
                    g.semestre,
                    g.codigo
                FROM 
                    grupo g;
            `);

            return results;
        } else {
            throw new Error('Rol no reconocido');
        }
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}