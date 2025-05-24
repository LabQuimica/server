import pool from "../database.js";
import bcrypt from "bcrypt";
import { users } from "../models/userQueries.js";

// Función para obtener un usuario por su id
export async function getUserById(id) {
  try {
    const [rows] = await pool.query(
      "SELECT id_user, name, email, date, rol, active, codigo FROM users WHERE id_user = ?",
      [id]
    );
    if (rows.length === 0) {
      throw new Error("Usuario no encontrado");
    }
    return rows[0];
  } catch (error) {
    console.error("Error al obtener el usuario:", error);
    throw error;
  }
}

// Función para obtener todos los usuarios (si la necesitás)
export async function getUsersById() {
  try {
    const [rows] = await pool.query(users); // 'users' debería ser una cadena SQL, p.ej. "SELECT * FROM users"
    return rows;
  } catch (error) {
    console.error("Error al ejecutar la consulta:", error);
    throw error;
  }
}

// Función para agregar un usuario
export async function addUserQuery(name, email, password, rol, codigo) {
  const [existing] = await pool.query(
    "SELECT email FROM users WHERE email = ?",
    [email]
  );
  if (existing.length > 0) {
    throw new Error("El usuario ya existe");
  }
  const hashedPassword = await bcrypt.hash(password, 10);
  const [result] = await pool.query(
    "INSERT INTO users (name, email, password, rol, codigo) VALUES (?, ?, ?, ?, ?)",
    [name, email, hashedPassword, rol, codigo]
  );
  return result;
}

// Función para eliminar un usuario (hard delete con cascada)
export async function deleteUserAndCascadeQuery(id) {
  try {
    await pool.query("START TRANSACTION");
    await pool.query("DELETE FROM vale_alumno WHERE fk_alumno_users_vale = ?", [
      id,
    ]);
    await pool.query("DELETE FROM grupo_alumnos WHERE fk_alumno_users_ga = ?", [
      id,
    ]);
    const [result] = await pool.query("DELETE FROM users WHERE id_user = ?", [
      id,
    ]);
    await pool.query("COMMIT");
    return result;
  } catch (error) {
    await pool.query("ROLLBACK");
    throw error;
  }
}

export async function softDeleteUserQuery(id) {
  const [result] = await pool.query(
    "UPDATE users SET active = 0 WHERE id_user = ?",
    [id]
  );
  return result;
}

export async function putUserAvatar(id, avatar) {
  try {
    const [result] = await pool.query(
      "UPDATE users SET img = ? WHERE id_user = ?",
      [avatar, id]
    );
    return result;
  } catch (error) {
    console.error("Error al actualizar el avatar:", error);
    throw error;
  }
}