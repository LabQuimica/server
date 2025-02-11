import express from 'express';
import { getDocentes } from '../querys/docentesQuerys.js';

const docenteRouter = express.Router();

docenteRouter.get('/', (req, res) => {
    res.send('GET request to the homepage');
});

docenteRouter.get('/getDocentes', async (req, res) => {
    try {
        const docentes = await getDocentes();
        res.json(docentes);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

export default docenteRouter;