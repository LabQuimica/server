import express from 'express';
import { getUser, getUsers } from '../querys/auth.js';

const authRouter = express.Router();

authRouter.get('/:id', async (req, res) => {
    const user = await getUser(req.params.id);
    if (!user) {
        return res.status(404).json({ message: 'Usuario no encontrado :(' });
    }
    res.status(200).json(user);
})

authRouter.get('/', async (req, res) => {
    const user = await getUsers();
    if (!user) {
        return res.status(404).json({ message: 'Usuario no encontrado :(' });
    }
    res.status(200).json(user);
})

export default authRouter;