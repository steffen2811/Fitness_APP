var passwordValidator = require('password-validator');
var connection = require('../helpers/mysql');
var userModel = require("./../models/user")

/* Standart password requirements */
var schema = new passwordValidator();
if (process.env.NODE_ENV == "production") {
    schema
        .is().min(8) // Minimum length 8
        .is().max(100) // Maximum length 100
        .has().uppercase() // Must have uppercase letters
        .has().lowercase() // Must have lowercase letters
        .has().digits() // Must have digits
        .has().not().spaces() // Should not have spaces
}

/* Function - Check if user is authenticated */
function sessionChecker(req, res, next) {
    //If user has a session (logged in)
    if (typeof req.session.user !== "undefined") {
        //If user attemp to create or login, return user data.
        if (req.path.match(/^.*login$/) || req.path.match(/^.*create$/)) {
            return res.json(req.session.user);
        }
        // else, continue to requested function
        else {
            next();
        }
        //If user has no session
    } else {
        //If user attemp to create or login, continue
        if (req.path.match(/^.*login$/) || req.path.match(/^.*create$/)) {
            next();
        }
        // else, access denied 
        else {
            return res.status(403).json({
                message: "Access denied"
            });
        }
    }
};

function checkIfUserExist(req, res, next) {
    /* Check if user already exist */
    connection.query(`SELECT users.email FROM users.users WHERE email="${req.body.email}"`, function (err, row) {
        if (err) {
            return res.status(403).json({
                error: err
            });
        } else if (row["length"] >= 1) {
            return res.status(403).json({
                error: "User already exist"
            });
        } else {
            next();
        }
    });
}

function checkBodyCreateUser(req, res, next) {
    //Fill all information from body
    var user = new userModel();
    var error;
    var failureKey;

    Object.keys(user).some(function (key) {
        if (checkUndefinedOrNull([req.body[key]])) {
            /* If key is missing, set variables and break loop */
            failureKey = key;
            error = true;
            return true;
        } else {
            user[key] = req.body[key]
        }
    });

    if (error) {
        /* return for this function */
        return res.status(403).json({
            error: failureKey + " is missing from body"
        });
    }

    req.body.user = user;
    next();
}

function checkPassword(req, res, next) {
    if (checkUndefinedOrNull([req.body.password])) {
        return res.status(400).json({
            message: "Param is missing. Check doc"
        });
    }
    var brokenPasswordRules = schema.validate(req.body.password, {
        list: true
    })

    if (brokenPasswordRules.length != 0) {
        return res.status(400).json({
            error: "Password is not strong enough",
            listOfBrokenRules: brokenPasswordRules
        });
    }
    next();

}

function checkUndefinedOrNull(variables) {
    for (i = 0; i < variables.length; i++) {
        if (typeof variables[i] === "undefined" || variables[i] === null) {
            return true;
        }
    }
    return;
}



module.exports = {
    sessionChecker,
    checkIfUserExist,
    checkBodyCreateUser,
    checkUndefinedOrNull,
    checkPassword
};