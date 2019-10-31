import { testFunc } from 'common/dist/src';
const mysql = require('mysql2/promise');

const setTimeoutPromise = async (len: number) => {
  return new Promise((resolve => {
    setTimeout(resolve, len)
  }))
};

export const handler = async () => {

  // create the connection to database
  const connection = await mysql.createConnection({
    host: 'db',
    user: 'root',
    password: 'root',
    database: 'test'
  });

  const [rows, fields] = await connection.execute('SHOW DATABASES;');

  console.log(rows.map((row: any) => row['Database']).join(','));
  console.log('test1');
  testFunc();
};