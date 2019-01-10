/* TODO: Auto generate API documentation tool? */
/* TODO: Error messages in static file */

var express = require('express');
var bcrypt = require('bcrypt-nodejs');
var validator = require("email-validator");
var connection = require('./../helpers/mysql');
var router = express.Router();

/* POST - Create user */
router.post('/create', sessionChecker, function (req, res, next) {
    var user = new User()
    user.name = req.body["name"];
    user.age = req.body["age"]
    user.mobile = req.body["mobile"]
    user.primarySports = req.body["primarySports"]
    user.profileImgPath = req.body["profileImgPath"]
    user.timeSpendPerWeek = req.body["timeSpendPerWeek"]
    user.sportLevel = req.body["sportLevel"]
    user.locationLong = req.body["locationLong"]
    user.locationLat = req.body["locationLat"]

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
                    return;
                }
                req.session.user = user;
                req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
                res.json(user)
            });
        });
    });
});

/* GET - login */
router.get('/login', sessionChecker, function (req, res, err) {
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

/* GET - getUserInfo */
router.get('/getUserInfo', sessionChecker, function (req, res) {
    var email = req.query.user;

    //validate email
    if (!validator.validate(email)) {
        res.status(400).json({
            message: "Wrong email format"
        });
        return;
    } else {
        connection.query(`SELECT users.email, users.full_name, users.age, users.mobile, users.primary_sports, users.profile_img_path, users.time_spend_per_week, users.sport_level FROM users.users WHERE email="${email}"`, function (err, row) {
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
router.put('/changePassword', sessionChecker, function (req, res) {
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
        if (err) {
            callback(err);
            return;
        }

        if (row["length"] >= 1) {
            callback("User already exist");
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

class User {
    constructor(email, password, name, age, mobile, sports, profileImgPath, timeSpendPerWeek, sportLevel, locationLong, locationLat) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.age = age;
        this.mobile = mobile;
        this.sports = sports;
        this.profileImgPath = profileImgPath;
        this.timeSpendPerWeek = timeSpendPerWeek;
        this.sportLevel = sportLevel;
        this.locationLong = locationLong;
        this.locationLat = locationLat;
    }
}

module.exports = {
    router,
    User,
    createUser,
    sessionChecker
}

// App ID: 663291517402375
// App Secret: 14d2fa999a3769a15c695b65becc0d38