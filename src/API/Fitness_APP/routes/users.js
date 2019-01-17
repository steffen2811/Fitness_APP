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

/**
 * @api {post} /users/create Create user
 * @apiVersion 1.0.0
 * @apiName create
 * @apiGroup Users
 * @apiDescription Suggested matches will be found in DB
 * 
 * @apiParam (Request body) {String} name Full name
 * @apiParam (Request body) {String="male","female"} gender Gender
 * @apiParam (Request body) {Number} age Age
 * @apiParam (Request body) {Number} mobile Mobile number
 * @apiParam (Request body) {String="Run","Fitness"} primarySports Primary sport
 * @apiParam (Request body) {Number} timeSpendPerWeek Time spend per week.
 * @apiParam (Request body) {Number{1-10}} sportLevel Sport level. 1 is beginner, 10 is very experienced.
 * @apiParam (Request body) {Float} locationLong Longitude (north/south)
 * @apiParam (Request body) {Float} locationLat Latitude (west/east)
 * @apiParam (Request body) {String} [profilePicture] Profile picture as Base64 string.
 * 
 * @apiParam (Authorization - Basic authentication) {Email} Username Username
 * @apiParam (Authorization - Basic authentication) {Password} Password Password
 * 
 * @apiSuccess {String} email Username (email)
 * @apiSuccess {String} password Encrypted password
 * @apiSuccess {String} name Full name
 * @apiSuccess {String} gender Gender
 * @apiSuccess {Number} age Age
 * @apiSuccess {Number} mobile Mobile number
 * @apiSuccess {String} primarySports Primary sport
 * @apiSuccess {String} profileImgPath Path to profile picture
 * @apiSuccess {Number} timeSpendPerWeek Time spend per week.
 * @apiSuccess {Number} sportLevel Sport level. 1 is beginner, 10 is very experienced.
 * @apiSuccess {Float} locationLong Longitude (north/south)
 * @apiSuccess {Float} locationLat Latitude (west/east)
 * @apiSuccess {Number} id_users user ID
 * @apiSuccess {Cookie} Session Session cookie
 *
 * @apiError (Error 400) Email Wrong email format.
 * @apiError (Error 403) UserExist User already exist.
 * @apiError (Error 403) MissingData <code>DATA</code> is missing from body.
 * @apiError (Error 500) unspecifiedError Please report
 */
router.post('/create', auth.getAuthData, checks.checkIfUserExist, fileUpload,
    checks.checkBodyCreateUser, auth.hashPassword,
    function (req, res, next) {
        var user = new userModel();

        //Fill all information from body
        Object.keys(user).forEach(function (key) {
            user[key] = req.body[key]
        });

        createUser(user, function (err, userid) {
            if (err) {
                res.status(500).json({
                    error: err
                });
            } else {
                req.session.user = user;
                req.session.user.id_users = userid;
                req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
                res.json(user)
            }
        });
    });

/**
 * @api {get} /users/login/ User login
 * @apiVersion 1.0.0
 * @apiName login
 * @apiGroup Users
 * 
 * @apiParam (Authorization - Basic authentication) {Email} Username Username
 * @apiParam (Authorization - Basic authentication) {Password} Password Password
 * 
 * @apiSuccess {String} email Username (email)
 * @apiSuccess {String} password Encrypted password
 * @apiSuccess {String} name Full name
 * @apiSuccess {String} gender Gender
 * @apiSuccess {Number} age Age
 * @apiSuccess {Number} mobile Mobile number
 * @apiSuccess {String} primarySports Primary sport
 * @apiSuccess {String} profileImgPath Path to profile picture
 * @apiSuccess {Number} timeSpendPerWeek Time spend per week.
 * @apiSuccess {Number} sportLevel Sport level. 1 is beginner, 10 is very experienced.
 * @apiSuccess {Float} locationLong Longitude (north/south)
 * @apiSuccess {Float} locationLat Latitude (west/east)
 * @apiSuccess {Number} id_users user ID
 * @apiSuccess {Cookie} Session Session cookie
 * 
 * @apiError (Error 400) Email Wrong email format.
 * @apiError (Error 401) Unauthorized No password revieved
 * @apiError (Error 500) Password Incorrect password.
 * @apiError (Error 500) UserNotFound User not found
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get('/login', auth.getAuthData, passport.authenticate('basic', {
    session: false
}), function (req, res) {
    req.session.user = req.user;
    req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
    res.json(req.user)
});

/**
 * @api {get} /users/logout/ User logout
 * @apiVersion 1.0.0
 * @apiName logout
 * @apiGroup Users
 * @apiDescription Session will be destoyed
 * 
 * @apiSuccess {String} message Logout success
 * 
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
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

/**
 * @api {get} /users/getCurrentUser/ Get current user (based on session/cookie)
 * @apiVersion 1.0.0
 * @apiName getCurrentUser
 * @apiGroup Users
 * 
 * @apiSuccess {String} email Username (email)
 * @apiSuccess {String} password Encrypted password
 * @apiSuccess {String} name Full name
 * @apiSuccess {String} gender Gender
 * @apiSuccess {Number} age Age
 * @apiSuccess {Number} mobile Mobile number
 * @apiSuccess {String} primarySports Primary sport
 * @apiSuccess {String} profileImgPath Path to profile picture
 * @apiSuccess {Number} timeSpendPerWeek Time spend per week.
 * @apiSuccess {Number} sportLevel Sport level. 1 is beginner, 10 is very experienced.
 * @apiSuccess {Float} locationLong Longitude (north/south)
 * @apiSuccess {Float} locationLat Latitude (west/east)
 * @apiSuccess {Number} id_users user ID
 * 
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get('/getCurrentUser', function (req, res) {
    res.json(req.session.user)
});

/**
 * @api {put} /users/changePassword/ Change user password
 * @apiVersion 1.0.0
 * @apiName changePassword
 * @apiGroup Users
 * 
 * @apiParam (Request body) {String} oldPassword .
 * @apiParam (Request body) {String} newPassword .
 * @apiParam (Request body) {String} reTypeNewPassword .
 *
 * @apiError (Error 400) Message param is missing. Check doc
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 404) UserNotFound User not found
 * @apiError (Error 500) unspecifiedError Please report
 */
router.put('/changePassword', function (req, res) {
    /* Get encrypted password for user */
    var oldPassword = req.query.oldPassword;
    var newPassword = req.query.newPassword;
    var reTypeNewPassword = req.query.reTypeNewPassword

    if (checks.checkUndefinedOrNull([oldPassword, newPassword, reTypeNewPassword])) {
        return res.status(400).json({
            message: "param is missing. Check doc"
        });
    }
    connection.query(`SELECT * FROM users.users WHERE id_users="${req.session.user.id_users}"`, function (err, row) {
        if (err) {
            res.status(500).json({
                error: err
            });
        }
        /* Compare hash from DB with received plain password */
        auth.comparePassword(password, CurrentRow["password"], function (err, match) {
            if (err) {
                res.status(500).json({
                    error: err
                });
            } else if (match) {
                return done(null, CurrentRow);
            } else {
                res.status(403).json({
                    message: "Incorrect password"
                });
            }
        })
});

function createUser(user, callback) {
    /* Insert new user into DB */
    connection.query(`INSERT INTO users.users (email, password, name, gender, age, mobile, primarySports, profileImgPath, timeSpendPerWeek, sportLevel, locationLong, locationLat) 
                    VALUES ("${user.email}", 
                            "${user.password}", 
                            "${user.name}", 
                            "${user.gender}", 
                            "${user.age}", 
                            "${user.mobile}", 
                            "${user.primarySports}", 
                            "${user.profileImgPath}", 
                            "${user.timeSpendPerWeek}", 
                            "${user.sportLevel}", 
                            "${user.locationLong}", 
                            "${user.locationLat}")`, function (err, result) {
        if (err) {
            callback(err);
            return;
        }
        callback(null, result.insertId);
    });
}

module.exports = {
    router,
    createUser
}

// App ID: 663291517402375
// App Secret: 14d2fa999a3769a15c695b65becc0d38