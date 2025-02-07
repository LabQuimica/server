import pool from '../database.js';

export async function getDocentes() {
    try {
        const [results] = await pool.query(`
            SELECT id_user, name, email
            FROM users 
            WHERE rol = 'profesor';
        `);
        
        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
        throw error;
    }
}