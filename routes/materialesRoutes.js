import express from 'express';
import { getKits, getSensores, getReactivosLiquidos, getReactivosSolidos, getMateriales, getEquipos, getItems, createMaterialQuery, updateMaterialQuery, deleteMaterialQuery, } from '../querys/materialesQuerys.js';

const materialesRouter = express.Router();

materialesRouter.get('/', (req, res) => {
    res.send('GET request to the homepage');
});

materialesRouter.get('/getKits', async (req, res) => {
    try {
        const kits = await getKits();
        res.json(kits);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

materialesRouter.get('/getSensores', async (req, res) => {
    try {
        const sensores = await getSensores();
        res.json(sensores);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

materialesRouter.get('/getReactivosLiquidos', async (req, res) => {
    try {
        const reactivosLiquidos = await getReactivosLiquidos();
        res.json(reactivosLiquidos);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

materialesRouter.get('/getReactivosSolidos', async (req, res) => {
    try {
        const reactivosSolidos = await getReactivosSolidos();
        res.json(reactivosSolidos);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

materialesRouter.get('/getMateriales', async (req, res) => {
    try {
        const materiales = await getMateriales();
        res.json(materiales);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

materialesRouter.get('/getEquipos', async (req, res) => {
    try {
        const materiales = await getEquipos();
        res.json(materiales);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

materialesRouter.get('/getItems', async (req, res) => {
    try {
        const items = await getItems();
        res.json(items);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

// Crear material
materialesRouter.post('/createMaterial', async (req, res, next) => {
  try {
    let {
      num_serie,
      nombre,
      tipo,
      ubicacion,
      cantidad,
      observacion,
      especial,
      fk_marca_item,
      status,
    } = req.body;

    // defaults
    num_serie = num_serie?.trim() || 'NA';
    fk_marca_item = Number(fk_marca_item) || 1;
    status = status != null ? status : 1;

    const result = await createMaterialQuery(
      num_serie,
      nombre,
      tipo,
      ubicacion,
      cantidad,
      observacion,
      status,
      especial,
      fk_marca_item
    );
    res.json(result);
  } catch (err) {
    next(err);
  }
});

// Actualizar material
materialesRouter.put('/updateMaterial', async (req, res, next) => {
  try {
    let {
      id_item,
      num_serie,
      nombre,
      tipo,
      ubicacion,
      cantidad,
      observacion,
      especial,
      fk_marca_item,
      status,
    } = req.body;

    num_serie = num_serie?.trim() || 'NA';
    fk_marca_item = Number(fk_marca_item) || 1;
    status = status != null ? status : 1;

    const result = await updateMaterialQuery(
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
    );
    res.json({ affectedRows: result.affectedRows });
  } catch (err) {
    next(err);
  }
});

// Eliminar material
materialesRouter.delete('/deleteMaterial', async (req, res, next) => {
  try {
    const { id_item } = req.body;
    const result = await deleteMaterialQuery(id_item);
    res.json({ affectedRows: result.affectedRows });
  } catch (error) {
    next(error);
  }
});

export default materialesRouter;