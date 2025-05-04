import pool from "../database.js";
import bycrypt from "bcrypt";
import jwt from "jsonwebtoken";

export async function postRegister(email, password, name, rol = "alumno") {
  // Verificar si el usuario ya existe
  const [existingUser] = await pool.query(
    "SELECT email FROM users WHERE email =  ?",
    [email]
  );
  if (existingUser.length > 0) {
    throw new Error("User already exists");
  }

  // Insertar el nuevo usuario en la base de datos
  const hashedPassword = await bycrypt.hash(password, 10);
  const [result] = await pool.query(
    "INSERT INTO users (email, password, name, rol) VALUES (?, ?, ?, ?)",
    [email, hashedPassword, name, rol]
  );
  const user = await getUserById(result.insertId);
  return { user };
}

export async function postRegisterMovil(
  email,
  password,
  name,
  codigo,
  img,
  rol = "alumno"
) {
  // Verificar si el usuario ya existe
  const [existingUser] = await pool.query(
    "SELECT email FROM users WHERE email =  ?",
    [email]
  );
  if (existingUser.length > 0) {
    throw new Error("User already exists");
  }

  // Insertar el nuevo usuario en la base de datos
  const hashedPassword = await bycrypt.hash(password, 10);
  const [result] = await pool.query(
    "INSERT INTO users (email, password, name, rol, codigo, img) VALUES (?, ?, ?, ?, ?, ?)",
    [email, hashedPassword, name, rol, codigo, img]
  );
  if (result.affectedRows === 0) {
    throw new Error("Error creating user");
  } else {
    const { token, user } = await postLogin(email, password);
    return { token, user };
  }
}

export async function postLogin(email, password) {
  // Verificar si el usuario ya existe
  const [existingUser] = await pool.query(
    "SELECT * FROM users WHERE email = ?",
    [email]
  );
  if (existingUser.length === 0) {
    throw new Error("User does not exist :(");
  }

  const isMatch = await bycrypt.compare(password, existingUser[0].password);
  if (!isMatch) {
    throw new Error("Contraseña incorrecta");
  }

  const token = jwt.sign(
    { id: existingUser[0].id_user },
    process.env.JWT_SECRET,
    {
      expiresIn: "3h",
    }
  );

  const user = {
    id_user: existingUser[0].id_user,
    name: existingUser[0].name,
    email: existingUser[0].email,
    date: existingUser[0].date,
    rol: existingUser[0].rol,
    active: existingUser[0].active,
    codigo: existingUser[0].codigo,
    img: existingUser[0].img,
  };

  return { token, user };
}
export async function getUserById(id) {
  const [rows] = await pool.query(
    "SELECT id_user,email, name,date, rol FROM users WHERE id_user =  ?",
    [id]
  );
  return rows[0];
}
