import express from "express";
import pool from "../database.js";

const inventoryRouter = express.Router();

// Tablas permitidas y sus respectivos campos
const tableSchema = {
  ubicacion: ["id_ubicacion", "Mueble", "Numero", "Estado", "Estante", "Nivel"],
  kits: ["num_serie", "nombre", "marca", "fk_ubicacion", "observaciones", "link", "caja", "cantidad_kits", "contenido", "cantidad"],
  materiales: ["num_serie", "nombre", "marca", "fk_ubicacion"],
  reactivos_liquidos: ["num_cas", "nombre", "formula", "marca", "cantidad", "fk_ubicacion", "contenedor", "observaciones"]
};

// Obtener registros de cualquier tabla
inventoryRouter.get("/:tableName", async (req, res) => {
  const { tableName } = req.params;

  if (!tableSchema[tableName]) {
    return res.status(400).json({ error: "Tabla no permitida" });
  }

  try {
    const [rows] = await pool.query(`SELECT * FROM ${tableName}`);
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener los datos" });
  }
});

// Insertar un nuevo registro en la tabla seleccionada
inventoryRouter.post("/:tableName", async (req, res) => {
  const { tableName } = req.params;
  const data = req.body;

  if (!tableSchema[tableName]) {
    return res.status(400).json({ error: "Tabla no permitida" });
  }

  // Validar que los datos tengan las claves correctas
  const fields = tableSchema[tableName];
  const values = fields.map(field => data[field]);

  try {
    const query = `INSERT INTO ${tableName} (${fields.join(", ")}) VALUES (${fields.map(() => "?").join(", ")})`;
    await pool.query(query, values);
    res.status(201).json({ message: `Registro agregado a ${tableName} correctamente.` });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al insertar el registro" });
  }
});

export default inventoryRouter;
