if (process.env.NODE_ENV == "production") {
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

var usersRouter = require('./routes/users');
var facebookRouter = require('./routes/facebook');
var communityRouter = require('./routes/community');
var sportsRouter = require('./routes/sports');
var runningRouter = require('./routes/running');
var fitnessRouter = require('./routes/fitness');
var sessionChecker = require('./middlewares/sessionCheck');

/* Set app as express */
var app = express();

app.use(session({
    secret: 'E6A9f7JaTyxJpZrNzKTuRnQUqgzXnfsa',
    // create new redis store.
    store: new redisStore({
        host: process.env.REDIS_SERVER_ADR,
        pass: process.env.REDIS_PASSWORD,
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
app.use(sessionChecker);

app.use('/users', usersRouter.router);
app.use('/users/facebook', facebookRouter);
app.use('/users/community', communityRouter);
app.use('/sports', sportsRouter);
app.use('/sports/running', runningRouter);
app.use('/sports/fitness', fitnessRouter);

module.exports = app;