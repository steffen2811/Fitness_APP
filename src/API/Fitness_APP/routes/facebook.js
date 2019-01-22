var express = require('express');
var passport = require('./../middlewares/passportjs');
var createUser = require("./users").createUser
var userModel = require("./../models/user")
var checks = require('../middlewares/checks');
var router = express.Router();

/**
 * @api {get} /users/facebook/login Login user with Facebook
 * @apiVersion 1.0.0
 * @apiName Facebook login
 * @apiGroup Facebook
 * 
 * @apiParam (Authorization - Bearer Token) {Token} FBUserToken Facebook user token
 * 
 * @apiSuccess {Number} id_users user ID
 * @apiSuccess {String} email Username (email)
 * @apiSuccess {String} password Always null when facebook login is used
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
 * @apiSuccess {Cookie} Session Session cookie
 *
 * @apiError (Error 400) Auth Auth failed
 * @apiError (Error 403) UserNotFound User not found in db
 * @apiError (Error 403) MissingData <code>DATA</code> is missing from body.
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get('/login',
    passport.authenticate('facebook-token', {
        session: false
    }),
    function (req, res) {
        if(req.user.exist === false) {
            res.status(401).json({
                message: "User not found in db"
            });
        }
        else {
            req.session.user = req.user[0];
            req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
            res.json(req.session.user);
        }
    },
    (error, req, res, next) => {
        if(error) {
            res.status(400).json({success: false, message: 'Auth failed', error})
        }
    }
);

/**
 * @api {post} /users/facebook/create Create user with Facebook
 * @apiVersion 1.0.0
 * @apiName Facebook create
 * @apiGroup Facebook
 * @apiDescription Suggested matches will be found in DB
 * 
 * @apiParam (Request body) {String="male","female"} gender Gender
 * @apiParam (Request body) {Number} age Age
 * @apiParam (Request body) {Number} mobile Mobile number
 * @apiParam (Request body) {String="Run","Fitness"} primarySports Primary sport
 * @apiParam (Request body) {Number} timeSpendPerWeek Time spend per week.
 * @apiParam (Request body) {Number{1-10}} sportLevel Sport level. 1 is beginner, 10 is very experienced.
 * @apiParam (Request body) {Float} locationLong Longitude (north/south)
 * @apiParam (Request body) {Float} locationLat Latitude (west/east)
 * 
 * @apiParam (Authorization - Bearer Token) {Token} FBUserToken Facebook user token
 * 
 * @apiSuccess {String} email Username (email)
 * @apiSuccess {String} password Always null when facebook login is used
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
 * @apiError (Error 400) Auth Auth failed
 * @apiError (Error 403) UserExist User already exist.
 * @apiError (Error 403) MissingData <code>DATA</code> is missing from body.
 * @apiError (Error 500) unspecifiedError Please report
 */
router.post('/create',
    passport.authenticate('facebook-token', {
        session: false
    }),
    function (req, res, next) {
        if(req.user.exist === true)
        {
            res.status(403).json({
                message: "User already exist"
            });
            return;
        }
        req.body.email = req.user._json["email"]
        req.body.password = "null" //Password is not used when using Facebook
        req.body.name = req.user._json["name"]
        req.body.profileImgPath = req.user.photos[0].value.replace("large", "normal");;
        next();
    }, checks.checkBodyCreateUser,
    function (req, res) {
        var user = new userModel();
        //Fill all information from body
        Object.keys(user).forEach(function(key) {
            user[key] = req.body[key]
        });
        createUser(user, function (err, userid) {
            if (err) {
                res.status(500).json({
                    error: err
                });
                return;
            }
            req.session.user = user;
            req.session.user.id_users = userid;
            req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
            res.json(user)
        });
    }, 
    (error, req, res, next) => {
        if(error) {
            res.status(400).json({success: false, message: 'Auth failed', error})
        }
    }
);

module.exports = router;