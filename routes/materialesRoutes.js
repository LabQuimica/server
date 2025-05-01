import express from 'express';
import { getKits, getSensores, getReactivos, getMateriales, getEquipos, getItems, createMaterialQuery, updateMaterialQuery, deleteMaterialQuery, } from '../querys/materialesQuerys.js';

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

materialesRouter.get('/getReactivos', async (req, res) => {
    try {
        const reactivos = await getReactivos();
        res.json(reactivos);
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

materialesRouter.post('/createMaterial', async (req, res, next) => {
    try {
      // Desestructura con valores por defecto
      const {
        num_serie = '',        // no permitimos NULL
        nombre,
        tipo,
        ubicacion = null,
        cantidad,
        observacion = null,
        especial = ''
      } = req.body;
      // force a boolean 0/1
      const status = req.body.status != null ? req.body.status : 1;
  
      const result = await createMaterialQuery(
        num_serie,
        nombre,
        tipo,
        ubicacion,
        cantidad,
        observacion,
        status,
        especial
      );
      res.json(result);
    } catch (error) {
      next(error);
    }
  });

  materialesRouter.put('/updateMaterial', async (req, res) => {
    const {
      id_item,
      num_serie,
      nombre,
      tipo,
      ubicacion,
      cantidad,
      observacion,
      status,
      especial,
      fk_marca_item, // si es necesario
    } = req.body;
  
    try {
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
    } catch (error) {
      console.error('Error al actualizar el material:', error);
      res.status(500).json({ error: 'Error al actualizar el material' });
    }
  });
  
  // DELETE
  materialesRouter.delete('/deleteMaterial', async (req, res) => {
    const { id_item } = req.body;
  
    try {
      const result = await deleteMaterialQuery(id_item);
      res.json({ affectedRows: result.affectedRows });
    } catch (error) {
      console.error('Error al eliminar el material:', error);
      res.status(500).json({ error: 'Error al eliminar el material' });
    }
  });

export default materialesRouter;