import express from 'express';
import {getUser, getUsers} from './database.js';
import cors from 'cors';

const corsOptions = {
    methods: ['GET'], 
    credentials: true, 
    
}

const app = express();
app.use(express.json());
app.use(cors(corsOptions));

app.get('/user/:id', async (req, res) => {
    const user = await getUser(req.params.id);
    
    // Si el usuario no existe, envía una respuesta 404
    if (!user) {
        return res.status(404).json({ message: 'Usuario no encontrado :(' });
    }

    res.status(200).json(user);
})

app.get('/users', async (req, res) => {
    const users = await getUsers();
    res.status(200).json(users);
})
app.listen(3000, '0.0.0.0', () => console.log('Server running on port 3000'));
