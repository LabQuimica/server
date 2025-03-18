import express from 'express';
import pool from '../database.js';
import { addUserQuery, deleteUserAndCascadeQuery, getUserById, softDeleteUserQuery, getUsersById} from '../querys/userQuerys.js';


const userRouter = express.Router();

// Endpoint para agregar un usuario
userRouter.post('/addUser', async (req, res, next) => {
    const { name, email, password, rol, codigo } = req.body;
    
    // Validar campos requeridos (puedes incluir también validaciones adicionales)
    if (!name || !email || !password || !rol || !codigo) {
      return res.status(400).json({ error: 'Faltan campos requeridos' });
    }
  
    try {
      const result = await addUserQuery(name, email, password, rol, codigo);
      const user = await getUserById(result.insertId);
      res.status(201).json({ message: 'Usuario agregado correctamente', user });
    } catch (error) {
      next(error);
    }
  });

// Endpoint para eliminación física (hard delete)
userRouter.delete('/deleteUser/:id', async (req, res, next) => {
  const userId = req.params.id;
  try {
    await deleteUserAndCascadeQuery(userId);
    res.status(200).json({ message: 'Usuario eliminado correctamente' });
  } catch (error) {
    next(error);
  }
});

// Endpoint para eliminación suave (soft delete)
userRouter.patch('/softDeleteUser/:id', async (req, res, next) => {
  const userId = req.params.id;
  try {
    await softDeleteUserQuery(userId);
    res.status(200).json({ message: 'Usuario marcado como inactivo' });
  } catch (error) {
    next(error);
  }
});

// Endpoint para actualizar un usuario
userRouter.patch('/updateUser/:id', async (req, res, next) => {
  const userId = req.params.id;
  const updatedData = req.body;
  try {
    const [result] = await pool.query(
      "UPDATE users SET ? WHERE id_user = ?",
      [updatedData, userId]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }
    const user = await getUserById(userId);
    res.json(user);
  } catch (error) {
    next(error);
  }
});


userRouter.get('/', (req, res) => {
    res.send('GET request to the homepage');
});

userRouter.get('/getUsers', async (req, res) => {   // Obtener los usuarios
  try {
      const users = await getUsersById();
      res.json(users);
  } catch (error) {
      console.log("Error en /getUsers:", error);
      res.status(500).json({ error: error.message });
  }
});

export default userRouter;