var express = require('express');
var passport = require('./../middlewares/passportjs');
var createUser = require("./users")
var userModel = require("./../models/user")
var router = express.Router();

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

router.post('/create',
    passport.authenticate('facebook-token', {
        session: false
    }),
    function (req, res) {
        if(req.user.exist === true)
        {
            res.status(409).json({
                message: "User already exist"
            });
            return;
        }
        var user = new userModel();
        //Fill all information from body
        Object.keys(user).forEach(function(key) {
            user[key] = req.body[key]
        });
        user.email = req.user._json["email"]
        user.password = "null" //Password is not used when using Facebook
        user.name = req.user._json["name"]

        createUser.createUser(user, function (err) {
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
    }, 
    (error, req, res, next) => {
        if(error) {
            res.status(400).json({success: false, message: 'Auth failed', error})
        }
    }
);

passport.serializeUser(function (user, done) {
    done(null, user);
});

passport.deserializeUser(function (user, done) {
    done(null, user);
});

module.exports = router;