import express from 'express';
import { asignarPractica, crearPractica, deleteMaterialPractica, deletePractica, getPracticaById, getPracticasAsignadas, getPracticasByAlumno, getPracticasCreadas, getPracticasInhabilitadas, inhabilitarPractica, inhabilitarPracticaByGroup, inhabilitarPracticasGroup, updatePractica, updateStatusPractica } from '../querys/practicaQuerys.js';

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

practicaRouter.get('/getPractica/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const practica = await getPracticaById(id);

        if (!practica) {
            return res.status(404).json({ error: "Práctica no encontrada" });
        }

        res.json(practica);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

practicaRouter.post('/crearPractica', async (req, res) => {
    const { nombre, descripcion, num_equipos, creadorId, materiales } = req.body;
    
    if (!nombre || !descripcion || !creadorId || !num_equipos) {
        return res.status(400).json({ error: 'Nombre, descripcion, número de equipos y id de Profesor requeridos' });
    }
  
    try {
        const newPractica = await crearPractica(nombre, descripcion, num_equipos, creadorId, materiales);
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

practicaRouter.post('/asignarPractica', async (req, res) => {
    const { practica, grupo, fecha_inicio, fecha_fin } = req.body;
    
    if (!practica || !grupo || !fecha_inicio || !fecha_fin) {
        return res.status(400).json({ error: 'Todos los campos requeridos' });
    }
  
    try {
        const asignedPractica = await asignarPractica(practica, grupo, fecha_inicio, fecha_fin);
        res.status(201).json({ 
            message: 'Practica asignada correctamente', 
            practica: asignedPractica
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
});

practicaRouter.put('/updatePractica/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await updatePractica(id, req.body);
        res.json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

practicaRouter.delete('/deletePracticaMaterial/:practicaId/:materialId', async (req, res) => {
    const { practicaId, materialId } = req.params;
    try {
        const deleteMaterial = await deleteMaterialPractica(practicaId, materialId);
        res.status(201).json({ 
            message: 'Material de práctica eliminado correctamente', 
            practica: deleteMaterialPractica
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
});

practicaRouter.post("/updateSatusPractica", async (req, res) => {
  const data = req.body;
  try {
    const responses = [];
    for (const change of data) {
      if (change.newStatus) {
        const response = await updateStatusPractica(
            change.id_practica,
            change.newStatus
          );
        responses.push(response);
      }
    }

    res.status(200).json({
      message: "Practicas actualizados correctamente",
      responses,
    });
  } catch (error) {
    console.error("Error al actualizar la practica", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
});

// Recuperar practicas inhabilitadas
practicaRouter.get('/getPracticasInhabilitadas', async (req, res) => {
    try {
        const practicas = await getPracticasInhabilitadas();
        
        res.json(practicas);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

// Inhabilitar una práctica para un grupo específico
practicaRouter.post('/inhabilitarPracticaByGroup', async (req, res) => {
    const { practicaId, groupId } = req.body;
  
    if (!practicaId || !groupId) {
      return res.status(400).json({ error: 'Se requieren el ID de practica y el ID del grupo' });
    }
  
    try {
      await inhabilitarPracticaByGroup(practicaId, groupId);
      res.status(200).json({ message: 'Práctica inhabilitada para el grupo especificado.' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error al inhabilitar la práctica para el grupo.' });
    }
});
  
// Inhabilitar una práctica para todos los grupos
practicaRouter.post('/inhabilitarPractica', async (req, res) => {
    const { practicaId } = req.body;
  
    if (!practicaId) {
      return res.status(400).json({ error: 'Se requiere el ID de practica' });
    }
  
    try {
      await inhabilitarPractica(practicaId);
      res.status(200).json({ message: 'Práctica inhabilitada para todos los grupos.' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error al inhabilitar la práctica.' });
    }
});
  
// Inhabilitar todas las prácticas de un grupo (por ejemplo, cuando termina el semestre)
practicaRouter.post('/inhabilitarPracticasGrupo', async (req, res) => {
    const { groupId } = req.body;
  
    if (!groupId ) {
      return res.status(400).json({ error: 'Se requiere el ID del grupo' });
    }
  
    try {
      await inhabilitarPracticasGroup(groupId);
      res.status(200).json({ message: 'Todas las prácticas del grupo han sido inhabilitadas.' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error al inhabilitar las prácticas del grupo.' });
    }
});

// Recuperar practicas por usuario alumno (para movil)
practicaRouter.get('/getPracticasByAlumno/:alumno', async (req, res) => {
    try {
        const { alumno } = req.params;
        const practicas = await getPracticasByAlumno(alumno);
        res.json(practicas);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

export default practicaRouter;