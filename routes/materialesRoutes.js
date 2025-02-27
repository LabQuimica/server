import express from 'express';
import { getKits, getLiquidos, getSensores, getSolidos } from '../querys/materialesQuerys.js';

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

materialesRouter.get('/getLiquidos', async (req, res) => {
    try {
        const liquidos = await getLiquidos();
        res.json(liquidos);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

materialesRouter.get('/getSolidos', async (req, res) => {
    try {
        const solidos = await getSolidos();
        res.json(solidos);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

export default materialesRouter;