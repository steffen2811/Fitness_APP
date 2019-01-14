/* TODO: Auto generate API documentation tool? */
/* TODO: Error messages in static file */

var express = require('express');
var passport = require('passport');
var connection = require('./../helpers/mysql');
var userModel = require("./../models/user")
var fileUpload = require("./../middlewares/file")
var checks = require('../middlewares/checks');
var auth = require('./../middlewares/auth');
var router = express.Router();

/* POST - Create user */
router.post('/create', auth.getAuthData, checks.checkIfUserExist, fileUpload,
    checks.checkBodyCreateUser, auth.hashPassword,
    function (req, res, next) {
        var user = new userModel();

        //Fill all information from body
        Object.keys(user).forEach(function (key) {
            user[key] = req.body[key]
        });

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

/* GET - login */
router.get('/login', auth.getAuthData, passport.authenticate('basic', {
    session: false
}), function (req, res) {
    req.session.user = req.user;
    req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
    res.json(req.user)
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

    auth.checkEmail(email, function (err) {
        if (err) {
            return res.status(400).json({
                error: err
            });
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
    })
});

router.get('/getCurrentUser', function (req, res) {
    res.json(req.session.user)
});

/* PUT - changePassword */
router.put('/changePassword', function (req, res) {

});

function createUser(user, callback) {
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
}

module.exports = {
    router,
    createUser
}

// App ID: 663291517402375
// App Secret: 14d2fa999a3769a15c695b65becc0d38