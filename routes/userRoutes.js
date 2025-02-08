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
        console.log("Error en /getUsers:", error);
        res.status(500).json({ error: error.message });
    }
});

export default userRouter;