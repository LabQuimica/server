import express from 'express';
import { getVales } from '../querys/valeQuerys.js';

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

export default valeRouter;