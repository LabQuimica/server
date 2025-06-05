import express from 'express';
import { addGrupoCode, getGrupoCode, getGrupos, getGruposByUsuario, getGruposPractica } from '../querys/gruposQuerys.js';

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

gruposRouter.get('/getGruposPractica/:practicaId', async (req, res) => {
    const { practicaId } = req.params;

    try {
        const grupos = await getGruposPractica(practicaId);
        res.json(grupos);
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error.message });
    }
});

gruposRouter.get('/getGrupoCode/:grupoId', async (req, res) => {
    const { grupoId } = req.params;
    try {
        const code = await getGrupoCode(grupoId);
        res.json(code);
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error.message });
    }
});

gruposRouter.post('/addGrupoCode', async (req, res) => {
    const { grupoId, codigo } = req.body;
    
    try {
      const result = await addGrupoCode(grupoId, codigo);
      res.json({ message: 'Código agregado exitosamente.'});
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: error.message });
    }
});  

gruposRouter.get('/getGruposByUsuario/:usuarioId', async (req, res) => {
    const { usuarioId } = req.params;

    try {
        const grupos = await getGruposByUsuario(usuarioId);
        res.json(grupos);
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error.message });
    }
});

export default gruposRouter;