var passport = require('passport');
var FacebookTokenStrategy = require('passport-facebook-token');
var connection = require('./../helpers/mysql');

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