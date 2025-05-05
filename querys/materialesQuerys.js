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

// Recuperar los materiales de tipo reactivos
export async function getReactivos() {
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
            WHERE i.tipo IN ('reactivos-líquidos', 'reactivos-sólidos')
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta para reactivos:', error);
        throw error;
    }
}

// Recuperar los materiales de tipo materiales
export async function getMateriales() {
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
            WHERE i.tipo = 'materiales'
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta para materiales:', error);
        throw error;
    }
}

// Recuperar los materiales de tipo equipos
export async function getEquipos() {
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
            WHERE i.tipo = 'equipos'
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta para equipos:', error);
        throw error;
    }
}

// Recuperar todos los items
export async function getItems() {
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
        `);

        return results;
    } catch (error) {
        console.error('Error al ejecutar la consulta para items', error);
        throw error;
    }
}