const mysql = require('mysql2/promise');

async function connectDatabase() {
  try {
    const connection = await mysql.createConnection({
      host: 'localhost',
      user: 'agri_user',
      password: 'AgriPass123',
      database: 'Smart_Agriculture_3'
    });

    console.log('Connected to Smart_Agriculture_3 database successfully');

    const [rows] = await connection.query("SHOW TABLES");
    console.log('Tables in database:', rows.map(r => Object.values(r)[0]));

    await connection.end();
  } catch (err) {
    console.error('❌ Error connecting to database:', err);
  }
}

connectDatabase();
