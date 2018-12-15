/* TODO: Auto generate API documentation tool? */
/* TODO: Error messages in static file */

var express = require('express');
var bcrypt = require('bcrypt-nodejs');
var mysql = require('mysql')

var router = express.Router();

/* connection to DB */
var connection = mysql.createConnection({
    host     : 'db',
    user     : 'root',
    password : 'Password1',
    database : 'users',
    insecureAuth : true
  });

connection.connect()

/* POST - Create user */
router.post('/create', function(req, res, next) {
    /* TODO: check if email is valid and if it already exist */
    var timeSpendPerWeek = req.body["timeSpendPerWeek"]

    /* Hash password using bcrypt */
    hashPassword(req.body["password"], function(err, passHash)
    {
        if(err)
        {
            res.status(500).json({  error: err });
            return;
        }
        
        /* Insert new user into DB */
        connection.query(`INSERT INTO users.users (email, password, timeSpendPerWeek) 
        VALUES ("${req.body["email"]}", "${passHash}", "${timeSpendPerWeek}")`, function (err) {
            if(err)
            {
                res.status(500).json({ error: err });
                return;
            }
            
            res.json({ message: "User created"});
        })
    })
});

/* POST - login */
router.post('/login', function(req, res, err)
{
    /* Get rows from DB where the email is requested */
    connection.query(`SELECT * FROM users.users WHERE email="${req.body["email"]}"`, function (err, row){
        if(err)
        {
            res.status(500).json({ error: err });
            return;
        }
        else
        {
            /* Check a row is found (User found in DB) */
            if(row["length"] == 1)
            {
                /* Compare hash from DB with received plain password */
                comparePassword(req.body["password"], row["0"]["password"], function(err, match)
                {
                    if(err)
                    {
                        res.status(500).json({ error: err });
                        return;
                    }
                    /* email and password match */
                    if(match)
                    {
                        res.json({ message: "Login successful"});
                        //res.json(ReturnUser(row["0"]));
                    }
                    /* Incorrect password */
                    else
                    {
                        res.json({ message: "Incorrect password"});
                    }
                });
            }
            /* User not found */
            else
            {
                res.json({ message: "User not found"});
            }
        }
    });
});


router.post('/CurrentUser', function(req, res, err)
{  
    connection.query(`SELECT * FROM users.users WHERE email="${req.body["email"]}"`, function (err, row){
        if(err)
        {
            res.status(500).json({ error: err });
            return;
        }
        else
        {
            /* Check a row is found (User found in DB) */
            if(row["length"] == 1)
            {
                delete row["0"]["password"];
                res.json(ReturnUser(row["0"]));
                
            }
            /* User not found */
            else
            {
                res.json({ message: "User not found"});
            }
        }
    });
});

function ReturnUser(id ,email, timeSpendPerWeek) {
    // Define desired object
    var obj = {
        id: id,
        Email:  email,
        TimeSpend: timeSpendPerWeek
    };
    // Return it
    return obj;
  }

/* Function - Hash password when a new user is created */
function hashPassword(password, callback) {
    /* Generate 10 round salt for the new user */
    bcrypt.genSalt(10, function(err, salt) {
        if (err) 
        {
            return callback(err);
        }
        /* Hash the password */
        bcrypt.hash(password, salt, null, function(err, hash) {
            return callback(err, hash);
        });
   });
 };

 /* Function - Compare plain password and hashed password */
 function comparePassword(plainPass, hashword, callback) {
    /* Check if the passwords match */
    bcrypt.compare(plainPass, hashword, function(err, isPasswordMatch) {   
        if (err)
        {
            callback(err);
        }
        else
        {
            callback(null, isPasswordMatch)
        }
    });
 };

module.exports = router;
