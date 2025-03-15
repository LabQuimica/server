import express from 'express';
import cors from 'cors';
import authRouter from './routes/authRoutes.js';
import valeRouter from "./routes/valeRoutes.js"
import errorHandler from './middleware/errorHandler.js';
import dotenv from "dotenv";

dotenv.config();
const port = process.env.PORT || 1234;

import userRouter from './routes/userRoutes.js';
import alertRouter from './routes/itemsAlertRoutes.js';
  
import practicaRouter from './routes/practicaRoutes.js';
import docenteRouter from './routes/docentesRoutes.js';
import materialesRouter from './routes/materialesRoutes.js';
import gruposRouter from './routes/gruposRoutes.js';

import manualRoutes from './routes/manualesRoutes.js';

const corsOptions = {
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true,   
    allowedHeaders: ['Content-Type', 'Authorization'],
  };

const app = express();
app.use(express.json());
app.use(cors(corsOptions));

// Rutas 
app.use('/auth', authRouter);
app.use('/vales', valeRouter);

app.use('/users', userRouter);
app.use('/alerts', alertRouter);

app.use('/practicas', practicaRouter);
app.use('/docentes', docenteRouter);
app.use('/materiales', materialesRouter);
app.use('/grupos', gruposRouter);

app.use("/manuales", manualRoutes); 

// Manejo de errores global
app.use(errorHandler);

app.listen(port, '0.0.0.0', () => console.log(`Server running on port ${port}`));

