import express from 'express';
import cors from 'cors';
import authRouter from './routes/authRoutes.js';

const corsOptions = {
    methods: ['GET','POST', 'PUT', 'DELETE'], 
    credentials: true,   
}

const app = express();
app.use(express.json());
app.use(cors(corsOptions));

// Rutas 
app.use('/auth', authRouter);

app.listen(5000, '0.0.0.0', () => console.log('Server running on port 5000'));
