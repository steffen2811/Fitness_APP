/* TODO: Auto generate API documentation tool? */
/* TODO: Error messages in static file */

var express = require('express');
var bcrypt = require('bcrypt-nodejs');
var mysql = require('mysql');
var router = express.Router();

/* connection to DB */
var connection = mysql.createConnection({
    host: process.env.MYSQL_SERVER_ADR,
    user: 'root',
    password: 'Password1',
    database: 'users',
    insecureAuth: true
});

connection.connect()

/* POST - Create user */
router.post('/create', sessionChecker, function (req, res, next) {
    /* TODO: check if email is valid */
    var timeSpendPerWeek = req.body["timeSpendPerWeek"]

    /* Get data from authorization header */
    getAuthData(req.headers.authorization, function (err, email, password) {
        if (err) {
            res.status(500).json({
                error: err
            });
            return;
        }

        /* Check if user already exist */
        connection.query(`SELECT users.email FROM users.users WHERE email="${email}"`, function (err, row) {
            if (err) {
                res.status(500).json({
                    error: err
                });
                return;
            }

            if (row["length"] >= 1) {
                res.status(409).json({
                    message: "User already exist"
                });
                return;
            }

            /* Hash password using bcrypt */
            hashPassword(password, function (err, passHash) {
                if (err) {
                    res.status(500).json({
                        error: err
                    });
                    return;
                }

                /* Insert new user into DB */
                connection.query(`INSERT INTO users.users (email, password, timeSpendPerWeek) 
                VALUES ("${email}", "${passHash}", "${timeSpendPerWeek}")`, function (err) {
                    if (err) {
                        res.status(500).json({
                            error: err
                        });
                        return;
                    }

                    /* Get all data of user */
                    connection.query(`SELECT * FROM users.users WHERE email="${email}"`, function (err, row) {
                        if (err) {
                            res.status(500).json({
                                error: err
                            });
                            return;
                        }
                        req.session.user = row[0];
                        req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
                        res.json(req.session.user);
                    });
                });
            });
        });
    });
});

/* POST - login */
router.get('/login', sessionChecker, function (req, res, err) {

    getAuthData(req.headers.authorization, function (err, email, password) {
        if (err) {
            res.status(500).json({
                error: err
            });
            return;
        }
        /* Get rows from DB where the email is requested */
        connection.query(`SELECT * FROM users.users WHERE email="${email}"`, function (err, row) {
            if (err) {
                res.status(500).json({
                    error: err
                });
                return;
            } else {
                /* Check a row is found (User found in DB) */
                if (row["length"] == 1) {
                    var CurrentRow = row["0"];
                    /* Compare hash from DB with received plain password */
                    comparePassword(password, CurrentRow["password"], function (err, match) {
                        if (err) {
                            res.status(500).json({
                                error: err
                            });
                            return;
                        }
                        /* email and password match */
                        if (match) {
                            req.session.user = CurrentRow;
                            req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
                            res.json(req.session.user);
                        }
                        /* Incorrect password */
                        else {
                            res.status(401).json({
                                message: "Incorrect password"
                            });
                        }
                    });
                }
                /* User not found */
                else {
                    res.status(401).json({
                        message: "User not found"
                    });
                }
            }
        });
    });
});

router.get('/logout', sessionChecker, function (req, res) {
    req.session.destroy(function (err) {
        if (err) {
            res.status(500).json({
                error: err
            });
        } else {
            res.clearCookie('connect.sid')
            res.json({
                message: "Logout success"
            });
        }
    });
});

/* Function - Check if user is authenticated */
function sessionChecker(req, res, next) {
    //If user has a session (logged in)
    if (typeof req.session.user !== "undefined") {
        //If user attemp to create or login, return user data.
        if (req.path == "/create" || req.path == "/login") {
            res.json(req.session.user);
            return;
        }
        // else, continue to requested function
        else {
            next();
        }
        //If user has no session
    } else {
        //If user attemp to create or login, continue
        if (req.path == "/create" || req.path == "/login") {
            next();
        }
        // else, access denied 
        else {
            res.status(403).json({
                message: "Access denied"
            });
        }
    }
};

/* Function - Hash password when a new user is created */
function hashPassword(password, callback) {
    /* Generate 10 round salt for the new user */
    bcrypt.genSalt(10, function (err, salt) {
        if (err) {
            return callback(err);
        }
        /* Hash the password */
        bcrypt.hash(password, salt, null, function (err, hash) {
            return callback(err, hash);
        });
    });
};

/* Function - Compare plain password and hashed password */
function comparePassword(plainPass, hashword, callback) {
    /* Check if the passwords match */
    bcrypt.compare(plainPass, hashword, function (err, isPasswordMatch) {
        if (err) {
            callback(err);
        } else {
            callback(null, isPasswordMatch)
        }
    });
};

function getAuthData(authorizationData, callback) {
    if (typeof authorizationData === "undefined") {
        callback("No authorization data received");

    } else {
        token = authorizationData.split(/\s+/).pop() || '', // and the encoded auth token
            auth = new Buffer.from(token, 'base64').toString(), // convert from base64
            parts = auth.split(/:/), // split on colon
            callback(null, parts[0], parts[1])
    }
}

module.exports = router;