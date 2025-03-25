import express from 'express';
import { getDocentes, getPracticasAsignadasDocente, getPracticasCreadasDocente } from '../querys/docentesQuerys.js';

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

docenteRouter.get('/getPracticasCreadasDocente/:id_docente', async (req, res) => {
    const { id_docente } = req.params;

    try {
        const practicas = await getPracticasCreadasDocente(id_docente);
        res.json(practicas);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

docenteRouter.get('/getPracticasAsignadasDocente/:id_docente', async (req, res) => {
    const { id_docente } = req.params;

    try {
        const practicas = await getPracticasAsignadasDocente(id_docente);
        res.json(practicas);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

export default docenteRouter;