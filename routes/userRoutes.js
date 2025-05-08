import express from "express";
import pool from "../database.js";
import {
  addUserQuery,
  deleteUserAndCascadeQuery,
  getUserById,
  softDeleteUserQuery,
  getUsersById,
  putUserAvatar,
} from "../querys/userQuerys.js";

const userRouter = express.Router();

// Endpoint para agregar un usuario
userRouter.post("/addUser", async (req, res, next) => {
  const { name, email, password, rol, codigo } = req.body;

  // Validar campos requeridos (puedes incluir también validaciones adicionales)
  if (!name || !email || !password || !rol || !codigo) {
    return res.status(400).json({ error: "Faltan campos requeridos" });
  }

  try {
    const result = await addUserQuery(name, email, password, rol, codigo);
    const user = await getUserById(result.insertId);
    res.status(201).json({ message: "Usuario agregado correctamente", user });
  } catch (error) {
    next(error);
  }
});

// Endpoint para eliminación física (hard delete)
userRouter.delete("/deleteUser/:id", async (req, res, next) => {
  const userId = req.params.id;
  try {
    await deleteUserAndCascadeQuery(userId);
    res.status(200).json({ message: "Usuario eliminado correctamente" });
  } catch (error) {
    next(error);
  }
});

// Endpoint para eliminación suave (soft delete)
userRouter.patch("/softDeleteUser/:id", async (req, res, next) => {
  const userId = req.params.id;
  try {
    await softDeleteUserQuery(userId);
    res.status(200).json({ message: "Usuario marcado como inactivo" });
  } catch (error) {
    next(error);
  }
});

// Endpoint para actualizar un usuario
userRouter.patch("/updateUser/:id", async (req, res, next) => {
  const userId = req.params.id;

  // Extraemos id_user para que no acabe en el SET
  // y sólo tomamos los campos permitidos
  const { id_user, ...body } = req.body;
  const updateFields = {};

  // Campos que dejamos actualizar
  ["name", "email", "rol", "codigo", "active"].forEach((key) => {
    if (body[key] !== undefined) {
      updateFields[key] = body[key];
    }
  });

  try {
    const [result] = await pool.query(
      "UPDATE users SET ? WHERE id_user = ?",
      [updateFields, userId]
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


userRouter.get("/", (req, res) => {
  res.send("GET request to the homepage");
});

userRouter.get("/getUsers", async (req, res) => {
  // Obtener los usuarios
  try {
    const users = await getUsersById();
    res.json(users);
  } catch (error) {
    console.log("Error en /getUsers:", error);
    res.status(500).json({ error: error.message });
  }
});

userRouter.put("/updateUserAvatar", async (req, res) => {
  const { id, avatar } = req.query;

  try {
    const result = await putUserAvatar(id, avatar);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }
    res.json({ img: avatar });
  } catch (error) {
    console.error("Error al actualizar el avatar:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
});

export default userRouter;
