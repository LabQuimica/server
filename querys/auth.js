import pool from '../database.js'
import bycrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export async function postRegister(email, password, name){
  // Verificar si el usuario ya existe
  const [existingUser] = await  pool.query("SELECT email FROM users WHERE email =  ?", [email]);
  if (existingUser.length > 0) {
      throw new Error('User already exists');
  }

  // Insertar el nuevo usuario en la base de datos
  const hashedPassword = await bycrypt.hash(password, 10);
  const [result] = await pool.query(
      "INSERT INTO users (email, password, name) VALUES (?, ?, ?)",
      [email, hashedPassword, name]
  );
  const user = await getUserById(result.insertId);
  return { user };
}

export async function postLogin(email, password){
    // Verificar si el usuario ya existe
    const [existingUser] = await pool.query("SELECT * FROM users WHERE email = ?", [email]);
    if (existingUser.length === 0) {
        throw new Error('User does not exist');
    }

    const isMatch = await bycrypt.compare(password, existingUser[0].password);
    if (!isMatch) {
        throw new Error('Contraseña incorrecta');
    }

    const token = jwt.sign({ id: existingUser[0].id_user }, process.env.JWT_SECRET, {
        expiresIn: '3h'
    });

    return { token };
  }
  

export async function getUserById(id){
    const [rows] = await pool.query("SELECT id_user,email, name,date, rol FROM users WHERE id_user =  ?", [id])
    return rows[0]
}

