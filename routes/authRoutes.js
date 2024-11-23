import express from 'express';
import { getUserById, postRegister, postLogin} from '../querys/auth.js';
const authRouter = express.Router();

authRouter.post('/register', async (req, res) => {
    const { email, password, name } = req.body;
    console.log(email, password, name);
    if (!email || !password || !name) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        const newUser = await postRegister(email, password, name);
        res.status(201).json({ message: 'User registered successfully', user: newUser });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

authRouter.post('/login', async (req, res) => {
    const { email, password } = req.body;
    console.log(email, password);
    if (!email || !password ) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        const token = await postLogin(email, password);
        console.log(token);
        res.status(201).json({ message: 'Login successfully', token: token });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

authRouter.get('/:id', async (req, res) => {
    const user = await getUserById(req.params.id);
    if (!user) {
        return res.status(404).json({ message: 'Usuario no encontrado :(' });
    }
    res.status(200).json(user);
})


export default authRouter;