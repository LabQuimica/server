import express from 'express';
import { getGrupos } from '../querys/gruposQuerys.js';

const gruposRouter = express.Router();

gruposRouter.get('/', (req, res) => {
    res.send('GET request to the homepage');
});

gruposRouter.get('/getGrupos', async (req, res) => {
    try {
        const grupos = await getGrupos();
        res.json(grupos);
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error.message });
    }
});

export default gruposRouter;