if (process.env.APP_MODE == "PRODUCTION") {
    process.env.MYSQL_SERVER_ADR = 'db';
    process.env.REDIS_SERVER_ADR = 'redis';
} else {
    process.env.MYSQL_SERVER_ADR = '127.0.0.1';
    process.env.MYSQL_ROOT_PASSWORD = 'Password1';
    process.env.REDIS_SERVER_ADR = '127.0.0.1';
    process.env.REDIS_PASSWORD = 'Password1';
}

/* use express, path, cookie-parser and morgan */
var express = require('express');
var path = require('path');
var redis = require("redis");
var session = require('express-session');
var redisStore = require('connect-redis')(session);
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var passport = require('passport');
var client = redis.createClient('redis://' + process.env.REDIS_SERVER_ADR + ':6379');

/* use index and users from routes */
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var facebookRouter = require('./routes/facebook');

/* Set app as express */
var app = express();

app.use(session({
    secret: 'E6A9f7JaTyxJpZrNzKTuRnQUqgzXnfsa',
    // create new redis store.
    store: new redisStore({
        host: process.env.REDIS_SERVER_ADR,
        pass: "Password1",
        port: 6379,
        client: client
    }),
    saveUninitialized: false,
    resave: false
}));
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({
    extended: false
}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(passport.initialize());
app.use(passport.session());

app.use('/', indexRouter);
app.use('/users', usersRouter.router);
app.use('/users/facebook', facebookRouter);

module.exports = app;