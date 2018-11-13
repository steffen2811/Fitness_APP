var express = require('express');
var bcrypt = require('bcrypt-nodejs');
var mysql = require('mysql')

var router = express.Router();

var connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : 'Password1',
    database : 'users'
  });

  connection.connect()

/* GET users listing. */
router.get('/', function(req, res, next) {
    hashPassword("Password", function(error, hash)
    {
        console.log(hash);
        comparePassword("Password123", hash, function(error, match)
        {
            console.log(match);
            res.send(match)
        });
    });
});

/* GET users listing. */
router.post('/Create', function(req, res, next) {
    
    var password = hashPassword(req.body["password"], function(err, hash)
    {
        if(err)
            res.status(404).end()
        
        password = hash
    })

    

    connection.query('INSERT INTO users (email, password) VALUES ("ib", "pass")', function (err, rows, fields) {
        if(err)
            res.send("Error")

        res.send("User created")
    })
});

function hashPassword(password, callback) {
    bcrypt.genSalt(10, function(err, salt) {
        if (err) 
            return callback(err);
        bcrypt.hash(password, salt, null, function(err, hash) {
            return callback(err, hash);
        });
   });
 };

 function comparePassword(plainPass, hashword, callback) {
    bcrypt.compare(plainPass, hashword, function(err, isPasswordMatch) {   
        return err == null ?
            callback(null, isPasswordMatch) :
            callback(err);
    });
 };

module.exports = router;
