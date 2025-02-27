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