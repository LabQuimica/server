import express from 'express';
import { getKits, getSensores, getReactivos, getMateriales, getEquipos } from '../querys/materialesQuerys.js';

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

export default materialesRouter;