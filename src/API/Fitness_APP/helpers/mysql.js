var mysql        = require('mysql');
var connection   = mysql.createConnection({
    host: process.env.MYSQL_SERVER_ADR,
    user: 'root',
    password: 'Password1',
    database: 'users',
    insecureAuth: true
});

module.exports = connection;
