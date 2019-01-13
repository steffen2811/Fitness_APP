/* TODO: Auto generate API documentation tool? */
/* TODO: Error messages in static file */

var express = require('express');
var bcrypt = require('bcrypt-nodejs');
var validator = require("email-validator");
var connection = require('./../helpers/mysql');
var userModel = require("./../models/user")
var router = express.Router();

/* POST - Create user */
router.post('/create', function (req, res, next) {
    var user = new userModel();
    //Fill all information from body
    Object.keys(user).forEach(function (key) {
        user[key] = req.body[key]
    });

    /* Get data from authorization header */
    getAuthData(req.headers.authorization, function (err, email, password) {
        if (err) {
            res.status(500).json({
                error: err
            });
            return;
        }
        user.email = email;

        /* validate email */
        if (!validator.validate(user.email)) {
            res.status(400).json({
                message: "Wrong email format"
            });
            return;
        }

        /* Hash password using bcrypt */
        hashPassword(password, user, function (err) {
            if (err) {
                res.status(500).json({
                    error: err
                });
                return;
            }

            createUser(user, function (err) {
                if (err) {
                    res.status(500).json({
                        error: err
                    });
                } else {
                    req.session.user = user;
                    req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
                    res.json(user)
                }
            });
        });
    });
});

/* GET - login */
router.get('/login', function (req, res, err) {
    getAuthData(req.headers.authorization, function (err, email, password) {
        if (err) {
            res.status(500).json({
                error: err
            });
            return;
        }
        //validate email
        if (!validator.validate(email)) {
            res.status(400).json({
                message: "Wrong email format"
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

/* GET - logout */
router.get('/logout', function (req, res) {
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

/* GET - getUserInfo */
router.get('/getUserInfo', function (req, res) {
    var email = req.query.user;

    //validate email
    if (!validator.validate(email)) {
        res.status(400).json({
            message: "Wrong email format"
        });
        return;
    } else {
        connection.query(`SELECT users.email, users.name, users.age, users.mobile, users.primarySports, users.profileImgPath, users.timeSpendPerWeek, users.sportLevel FROM users.users WHERE email="${email}"`, function (err, row) {
            if (err) {
                res.status(500).json({
                    error: err
                });
                return;
            } else {
                if (row["length"] == 1) {
                    res.json(row["0"]);
                } else {
                    res.status(404).json({
                        message: "User not found"
                    });
                }
            }
        });
    }
});

router.get('/getCurrentUser', function (req, res) {
    res.json(req.session.user)
});

/* PUT - changePassword */
router.put('/changePassword', function (req, res) {
    /* Get data from authorization header */
    getAuthData(req.headers.authorization, function (err, email, password) {
        if (err) {
            res.status(500).json({
                error: err
            });
            return;
        }
    });
});

/* Function - Hash password when a new user is created */
function hashPassword(password, user, callback) {
    /* Generate 10 round salt for the new user */
    bcrypt.genSalt(10, function (err, salt) {
        if (err) {
            return callback(err);
        }
        /* Hash the password */
        bcrypt.hash(password, salt, null, function (err, hash) {
            if (err) {
                return callback(err);
            }
            user.password = hash;
            return callback(null);
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

/* Function - Get authorization data from object */
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

function createUser(user, callback) {
    /* Check if user already exist */
    connection.query(`SELECT users.email FROM users.users WHERE email="${user.email}"`, function (err, row) {
        var error;
        
        if (err) {
            callback(err);
            error = true;
        }

        if (row["length"] >= 1) {
            callback("User already exist");
            error = true;
        }

        var error;
        Object.keys(user).some(function (key) {
            if (typeof user[key] === "undefined") {
                callback(key + " in user is undefined");
                error = true;
                /* break loop */
                return true;
            }
        });

        if(error)
        {
            /* return for this function */
            return;
        }

        /* Insert new user into DB */
        connection.query(`INSERT INTO users.users (email, password, name, age, mobile, primarySports, profileImgPath, timeSpendPerWeek, sportLevel, locationLong, locationLat) 
                    VALUES ("${user.email}", 
                            "${user.password}", 
                            "${user.name}", 
                            "${user.age}", 
                            "${user.mobile}", 
                            "${user.primarySports}", 
                            "${user.profileImgPath}", 
                            "${user.timeSpendPerWeek}", 
                            "${user.sportLevel}", 
                            "${user.locationLong}", 
                            "${user.locationLat}")`, function (err) {
            if (err) {
                callback(err);
                return;
            }
            callback(null);
        });
    });
}

module.exports = {
    router,
    createUser
}

// App ID: 663291517402375
// App Secret: 14d2fa999a3769a15c695b65becc0d38