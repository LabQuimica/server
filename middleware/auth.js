import express from 'express';
import jwt from 'jsonwebtoken';

const router = express.Router();

router.get('/verify-token', (req, res) => {
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

export default router;
