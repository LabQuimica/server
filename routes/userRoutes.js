// Aqui van las rutas del servidor para los USUARIOS
import express from 'express';
import { getUsers } from '../querys/userQuerys.js';

const userRouter = express.Router();

userRouter.get('/', (req, res) => {
    res.send('GET request to the homepage');
});

userRouter.get('/getUsers', async (req, res) => {   // Obtener los usuarios
    try {
        const users = await getUsers();
        res.json(users);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

/* userRouter.post('/updateUsers', async (req, res) => {
    const data = req.body;
    try {
        const response = await updateUsers(data);
        res.status(response.status).json(response.data);
    } catch (error) {
        console.error('Error en /updateUsers:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
}); */

export default userRouter;