/* use express, path, cookie-parser and morgan */
var express = require('express');
var path = require('path');
var redis   = require("redis");
var session = require('express-session');
var redisStore = require('connect-redis')(session);
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var client  = redis.createClient();

/* use index and users from routes */
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

/* Set app as express */
var app = express();

app.use(session({
    secret: 'E6A9f7JaTyxJpZrNzKTuRnQUqgzXnfsa',
    // create new redis store.
    store: new redisStore({ host: 'localhost', port: 6379, client: client,ttl :  260}),
    saveUninitialized: false,
    resave: false
}));
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

module.exports = app;
