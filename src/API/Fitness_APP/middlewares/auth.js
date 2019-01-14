var validator = require("email-validator");
var bcrypt = require('bcrypt-nodejs');

/* Middleware function - Get authorization data from object */
function getAuthData(req, res, next) {
    if (typeof req.headers.authorization === "undefined") {
        return res.status(500).json({
            error: "No authorization data received"
        });

    } else {
        token = req.headers.authorization.split(/\s+/).pop() || '' // and the encoded auth token
        auth = new Buffer.from(token, 'base64').toString() // convert from base64
        parts = auth.split(/:/) // split on colon. parts[0] = email, parts[1] = password
        req.body.email = parts[0];
        req.body.password = parts[1];

        /* validate email */
        checkEmail(req.body.email, function (err) {
            if (err) {
                return res.status(400).json({
                    error: err
                });
            }
        });
        next();
    }
}

/* Middleware function - Hash password when a new user is created */
function hashPassword(req, res, next) {
    /* Generate 10 round salt for the new user */
    bcrypt.genSalt(10, function (err, salt) {
        if (err) {
            return res.status(500).json({
                message: err
            });
        }
        /* Hash the password */
        bcrypt.hash(req.body.password, salt, null, function (err, hash) {
            if (err) {
                return res.status(500).json({
                    message: err
                });
            }
            req.body.password = hash;
            next();
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

function checkEmail(email, callback) {
    /* validate email */
    if (!validator.validate(email)) {
        callback("Wrong email format")
    } else {
        callback(null)
    }
};

module.exports = {
    getAuthData,
    hashPassword,
    comparePassword,
    checkEmail
};