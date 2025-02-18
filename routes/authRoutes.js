import express from 'express';
import jwt from 'jsonwebtoken'; 
import { getUserById, postRegister, postLogin } from '../querys/auth.js';

const authRouter = express.Router();

authRouter.post('/register', async (req, res) => {
    const { email, password, name, rol} = req.body;
    console.log(email, password, name, rol);
    if (!email || !password || !name) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        const newUser = await postRegister(email, password, name, rol);
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
        const { token, user } = await postLogin(email, password);

        res.cookie('token', token, {
            httpOnly: true, // la cookie no será accesible desde JavaScript
            secure: process.env.NODE_ENV === 'production', // true si se está en producción con HTTPS
            maxAge: 3 * 60 * 60 * 1000, // 3 horas
        });

        res.status(201).json({ message: 'Login successfully', token: token, user: user });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});

authRouter.get('/verifytoken', (req, res) => {

  const token = req.header('Authorization')?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access denied. No token provided.' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    res.json({ user: decoded }); // Devuelve los datos del usuario contenidos en el token
  } catch (error) {
    res.status(400).json({ error: 'Invalid token.' });
  }
});

authRouter.get("/me", async (req, res) => {
    const authHeader = req.headers.authorization;
    console.log("Authorization header:", authHeader);
    
    if (!authHeader) {
      return res.status(401).json({ error: "No token provided" });
    }
  
    const token = authHeader.split(" ")[1];
    try {
      // Verifica el token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      console.log("Decoded token:", decoded);
      // Si en el login generaste el token con { id: ... } usa decoded.id
      const user = await getUserById(decoded.id);
      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }
      res.json({ user });
    } catch (error) {
      console.error("Error verifying token:", error);
      return res.status(401).json({ error: "Invalid token" });
    }
  });

export default authRouter;
