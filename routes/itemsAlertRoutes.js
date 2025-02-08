// Aqui van las rutas del servidor para los USUARIOS

import express from 'express';
import { getItemsAlert } from '../querys/itemsAlertQuerys.js';

const alertRouter = express.Router();

alertRouter.get('/', (req, res) => {
    res.send('GET request to the homepage');
});

alertRouter.get('/getItemsAlert', async (req, res) => {   // Obtener los items
    try {
        const items = await getItemsAlert();
        res.json(items);
    } catch (error) {
        console.log("Error en /getItemsAlert:", error);
        res.status(500).json({ error: error.message });
    }
});

export default alertRouter;