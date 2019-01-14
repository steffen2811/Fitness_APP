var passport = require('passport');
var FacebookTokenStrategy = require('passport-facebook-token');
var BasicStrategy = require('passport-http').BasicStrategy;
var connection = require('./../helpers/mysql');
var auth = require('./auth');

passport.use(new BasicStrategy(
    function (userid, password, done) {
        /* Get rows from DB where the email is requested */
        connection.query(`SELECT * FROM users.users WHERE email="${userid}"`, function (err, row) {
            if (err) {
                return done(err);
            } else {
                /* Check a row is found (User found in DB) */
                if (row["length"] == 1) {
                    var CurrentRow = row["0"];
                    /* Compare hash from DB with received plain password */
                    auth.comparePassword(password, CurrentRow["password"], function (err, match) {
                        if (err) {
                            return done(err);
                        } else if (match) {
                            return done(null, CurrentRow);
                        } else {
                            err = "Incorrect password";
                            return done(err);
                        }
                    })
                } else {
                    err = "User not found";
                    return done(err);
                }
            }
        })
    }
));

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
            row.exist = true;
            return done(err, row)
        } else {
            profile.exist = false;
            return done(err, profile)
        }
    });
}));

passport.serializeUser(function (user, done) {
    done(null, user);
});

passport.deserializeUser(function (user, done) {
    done(null, user);
});

module.exports = passport