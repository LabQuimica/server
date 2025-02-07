import express from 'express';
import cors from 'cors';
import authRouter from './routes/authRoutes.js';
import valeRouter from "./routes/valeRoutes.js"
import errorHandler from './middleware/errorHandler.js';
import dotenv from "dotenv";

dotenv.config();
const port = process.env.PORT || 1234;

const corsOptions = {
    methods: ['GET','POST', 'PUT', 'DELETE'], 
    credentials: true,   
}

const app = express();
app.use(express.json());
app.use(cors(corsOptions));

// Rutas 
app.use('/auth', authRouter);
app.use('/vales', valeRouter);

// Manejo de errores global
app.use(errorHandler);

app.listen(port, '0.0.0.0', () => console.log(`Server running on port ${port}`));
