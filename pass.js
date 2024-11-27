import bcrypt from 'bcrypt';

const hashPassword = async () => {
  const hashed = await bcrypt.hash('admin123', 10); // Cambia 'admin123' por la contraseña deseada
  console.log('Hashed password:', hashed);
};

hashPassword();