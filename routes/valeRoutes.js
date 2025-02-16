import express from 'express';
import { getVales,getValeStatus,updateVales } from '../querys/valeQuerys.js';

const valeRouter = express.Router();

valeRouter.get('/', (req, res) => {
    res.send('GET request to the homepage');
});

valeRouter.get('/getVales', async (req, res) => {
    try {
        const vales = await getVales();
        res.json(vales);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

valeRouter.post('/updateVales', async (req, res) => {
    const data = req.body;
    try {
        const response = await updateVales(data);
        res.status(response.status).json(response.data);
    } catch (error) {
        console.error('Error en /updateVales:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

valeRouter.get('/getValesStatus', async (req, res) => {
    const estado = req.query.estado;
    try {
        const vales = await getValeStatus(estado);
        res.json(vales);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

export default valeRouter;