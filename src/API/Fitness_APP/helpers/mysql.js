var mysql        = require('mysql');
var connection   = mysql.createConnection({
    host: process.env.MYSQL_SERVER_ADR,
    user: 'root',
    password: process.env.MYSQL_ROOT_PASSWORD,
    database: 'users',
    insecureAuth: true
});

module.exports = connection;
