import pool from "../database.js";

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
    console.error("Error al ejecutar la consulta para kits:", error);
    throw error;
  }
}

// Recuperar los materiales de tipo reactivos
export async function getReactivosQuery() {
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
            WHERE i.tipo IN ('reactivos-liquidos', 'reactivos-solidos')  
        `);

    return results;
  } catch (error) {
    console.error("Error al ejecutar la consulta para kits:", error);
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
    console.error("Error al ejecutar la consulta para sensores:", error);
    throw error;
  }
}

// Recuperar los reactivos líquidos
export async function getReactivosLiquidos() {
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
            WHERE i.tipo = 'reactivos-liquidos'
        `);

    return results;
  } catch (error) {
    console.error(
      "Error al ejecutar la consulta para reactivos líquidos:",
      error
    );
    throw error;
  }
}

// Recuperar los reactivos sólidos
export async function getReactivosSolidos() {
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
            WHERE i.tipo = 'reactivos-solidos'
        `);

    return results;
  } catch (error) {
    console.error(
      "Error al ejecutar la consulta para reactivos sólidos:",
      error
    );
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
    console.error("Error al ejecutar la consulta para materiales:", error);
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
    console.error("Error al ejecutar la consulta para equipos:", error);
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
    console.error("Error al ejecutar la consulta para items", error);
    throw error;
  }
}

// Crear un nuevo material
export async function createMaterialQuery(
  num_serie,
  nombre,
  tipo,
  ubicacion,
  cantidad,
  observacion,
  status,
  especial,
  fk_marca_item
) {
  try {
    const [result] = await pool.query(
      `
        INSERT INTO items (
          num_serie, nombre, tipo, ubicacion,
          cantidad, observacion, status, especial,
          fk_marca_item
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        num_serie,
        nombre,
        tipo,
        ubicacion,
        cantidad,
        observacion,
        status,
        especial,
        fk_marca_item,
      ]
    );

    return result;
  } catch (error) {
    console.error("Error al crear el material:", error);
    throw error;
  }
}

// Actualizar un material existente
export async function updateMaterialQuery(
  id_item,
  num_serie,
  nombre,
  tipo,
  ubicacion,
  cantidad,
  observacion,
  status,
  especial,
  fk_marca_item
) {
  try {
    const [result] = await pool.query(
      `
            UPDATE items
            SET num_serie = ?, nombre = ?, tipo = ?, ubicacion = ?, cantidad = ?, observacion = ?, status = ?, especial = ?, fk_marca_item = ?
            WHERE id_item = ?
        `,
      [
        num_serie,
        nombre,
        tipo,
        ubicacion,
        cantidad,
        observacion,
        status,
        especial,
        fk_marca_item,
        id_item,
      ]
    );

    return result;
  } catch (error) {
    console.error("Error al actualizar el material:", error);
    throw error;
  }
}

// Eliminar un material
export async function deleteMaterialQuery(id_item) {
  const conn = await pool.getConnection();
  try {
    // Elimina primero las referencias en practicas_materiales
    await conn.query("DELETE FROM practicas_materiales WHERE fk_items_pm = ?", [
      id_item,
    ]);
    // Ahora elimina el material y retorna el resultado
    const [result] = await conn.query("DELETE FROM items WHERE id_item = ?", [
      id_item,
    ]);
    return result; // <--- Esto es importante
  } finally {
    conn.release();
  }
}
