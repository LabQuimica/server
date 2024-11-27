import pool from './database.js';

const testConnection = async () => {
  try {
    const [rows] = await pool.query('SHOW TABLES;');
    console.log('Conexión exitosa. Tablas en la base de datos:', rows);
  } catch (err) {
    console.error('Error al conectar a la base de datos:', err);
  } finally {
    process.exit();
  }
};

testConnection();