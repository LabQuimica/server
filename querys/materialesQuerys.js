import pool from '../database.js';

// Recuperar los materiales de tipo kits
export async function getKits() {
    try {
        const [results] = await pool.query(`
            SELECT 
                i.id_item,
                i.num_serie,
                i.nombre,
                i.tipo,
                i.ubicacion,
                i.cantidad,
                i.observacion,
                i.status,
                i.especial,
                i.fecha_modificacion,
                m.nombre AS marca,
                GROUP_CONCAT(DISTINCT k_items.nombre ORDER BY k_items.nombre SEPARATOR ', ') AS contenido_kit
            FROM items i
            LEFT JOIN marcas m ON i.fk_marca_item = m.id_marca
            LEFT JOIN kits k ON i.id_item = k.fk_kit
            LEFT JOIN items k_items ON k.fk_items_kits = k_items.id_item
            WHERE i.tipo = 'kits'
            GROUP BY i.id_item
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta para kits:', error);
        throw error;
    }
}

// Recuperar los materiales de tipo sensores
export async function getSensores() {
    try {
        const [results] = await pool.query(`
            SELECT 
                i.id_item,
                i.num_serie,
                i.nombre,
                i.tipo,
                i.ubicacion,
                i.cantidad,
                i.observacion,
                i.status,
                i.especial,
                i.fecha_modificacion,
                m.nombre AS marca
            FROM items i
            LEFT JOIN marcas m ON i.fk_marca_item = m.id_marca
            WHERE i.tipo = 'sensores'
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta para sensores:', error);
        throw error;
    }
}

// Recuperar los materiales de tipo líquidos
export async function getLiquidos() {
    try {
        const [results] = await pool.query(`
            SELECT 
                i.id_item,
                i.num_serie,
                i.nombre,
                i.tipo,
                i.ubicacion,
                i.cantidad,
                i.observacion,
                i.status,
                i.especial,
                i.fecha_modificacion,
                m.nombre AS marca
            FROM items i
            LEFT JOIN marcas m ON i.fk_marca_item = m.id_marca
            WHERE i.tipo = 'liquidos'
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta para líquidos:', error);
        throw error;
    }
}

// Recuperar los materiales de tipo sólidos
export async function getSolidos() {
    try {
        const [results] = await pool.query(`
            SELECT 
                i.id_item,
                i.num_serie,
                i.nombre,
                i.tipo,
                i.ubicacion,
                i.cantidad,
                i.observacion,
                i.status,
                i.especial,
                i.fecha_modificacion,
                m.nombre AS marca
            FROM items i
            LEFT JOIN marcas m ON i.fk_marca_item = m.id_marca
            WHERE i.tipo = 'solidos'
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta para sólidos:', error);
        throw error;
    }
}