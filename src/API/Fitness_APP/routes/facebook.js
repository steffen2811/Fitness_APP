var express = require('express');
var passport = require('passport');
var FacebookTokenStrategy = require('passport-facebook-token');
var connection = require('./../helpers/mysql');
var users = require("./users")
var router = express.Router();

passport.use(new FacebookTokenStrategy({
    clientID: "663291517402375",
    clientSecret: "14d2fa999a3769a15c695b65becc0d38"
}, function (accessToken, refreshToken, profile, done) {
    /* Check if user already exist */
    connection.query(`SELECT * FROM users.users WHERE email="${profile.emails[0].value}"`, function (err, row) {
        if (err) {
            return done(err);
        }
        if (row["length"] == 1) {
            return done(err, row)
        } else {
            return done(err, profile)
        }
    });
}));

router.get('/login',
    users.sessionChecker,
    passport.authenticate('facebook-token', {
        session: false
    }),
    function (req, res) {
        if (req.user[0]) {
            req.session.user = req.user[0];
            req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 7; // 1 week
            res.json(req.session.user);
        } else {
            res.status(401).json({
                message: "User not found in db"
            });
        }
    },
);

router.post('/create',
    users.sessionChecker,
    passport.authenticate('facebook-token', {
        session: false
    }),
    function (req, res) {
        var user = new users.User();
        user.email = req.user[0].email
        user.password = "null" //Password is not used when using Facebook
        user.name = req.user[0].name
        user.age = req.body["age"]
        user.mobile = req.body["mobile"]
        user.primarySports = req.body["primarySports"]
        user.profileImgPath = req.body["profileImgPath"]
        user.timeSpendPerWeek = req.body["timeSpendPerWeek"]
        user.sportLevel = req.body["sportLevel"]
        user.locationLong = req.body["locationLong"]
        user.locationLat = req.body["locationLat"]

        users.createUser(user, function (err) {
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
    }
);

passport.serializeUser(function (user, done) {
    done(null, user);
});

passport.deserializeUser(function (user, done) {
    done(null, user);
});

module.exports = router;