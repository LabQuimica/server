import express from 'express';
import { crearPractica, deletePractica, getPracticasAsignadas, getPracticasCreadas } from '../querys/practicaQuerys.js';

const practicaRouter = express.Router();

practicaRouter.get('/', (req, res) => {
    res.send('GET request to the homepage');
});

practicaRouter.get('/getPracticasCreadas', async (req, res) => {
    try {
        const practicas = await getPracticasCreadas();
        
        res.json(practicas);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

practicaRouter.get('/getPracticasAsignadas', async (req, res) => {
    try {
        const practicas = await getPracticasAsignadas();
        
        res.json(practicas);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

practicaRouter.post('/crearPractica', async (req, res) => {
    const { nombre, descripcion, num_equipos, creadorId } = req.body;
    
    if (!nombre || !descripcion || !creadorId || !num_equipos) {
        return res.status(400).json({ error: 'Nombre, descripcion, número de equipos y id de Profesor requeridos' });
    }
  
    try {
        const newPractica = await crearPractica(nombre, descripcion, num_equipos, creadorId);
        res.status(201).json({ 
            message: 'Practica creada correctamente', 
            practica: newPractica
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
});

practicaRouter.delete('/deletePractica/:id', async (req, res) => {
    const practiceId = req.params.id;
    const profesorId = req.body.profesorId;
  
    if (!practiceId || !profesorId) {
        return res.status(400).json({ error: 'Missing required fields' });
    }
  
    try {
        const result = await deletePractica(practiceId, profesorId);
        res.status(200).json(result);
    } catch (error) {
        console.error(error);
        if (error.message === 'No autorizado para eliminar prácticas') {
            return res.status(403).json({ error: error.message });
        }
        if (error.message === 'Práctica no encontrada') {
            return res.status(404).json({ error: error.message });
        }
        res.status(500).json({ error: 'Error interno del servidor' });
    }
  });

export default practicaRouter;