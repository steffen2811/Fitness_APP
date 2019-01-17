var express = require('express');
var connection = require('./../helpers/mysql');
var checks = require('../middlewares/checks');
var router = express.Router();

/**
 * @api {post} /sports/running/registerRun/ Save run
 * @apiVersion 1.0.0
 * @apiName registerRun
 * @apiGroup Running
 * 
 * @apiParam (Request body) {Double} Distance .
 * @apiParam (Request body) {Int} Starttime Secound since 1970
 * @apiParam (Request body) {Double} Duration .
 * @apiParam (Request body) {Array[]} Lat Array of all latitude coordinated e.g. 22.23, 22.24
 * @apiParam (Request body) {Array[]} Long Array of all longitude coordinated e.g. 22.23, 22.24
 * @apiParam (Request body) {Array[]} locationTime Secound since 1970 for each coordinat-set e.g. 555555, 555556
 * @apiParam (Request body) {Array[]} [perticipatingUsers] Users perticipated in run
 * @apiParam (Request body) {Int} [perticipatingUsers.id_users] id of user
 * 
 * @apiSuccess {String} message Run registered
 *
 * @apiError (Error 400) message Param is missing. Check docs.
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.post('/registerRun', function (req, res) {
    if (checks.checkUndefinedOrNull([req.body.distance, req.body.startTime, req.body.duration, req.body.lat, req.body.long, req.body.locationTime])) {
        return res.status(400).json({
            message: "Param is missing. Check docs"
        });
    }

    //Add current user to perticipating users
    if (checks.checkUndefinedOrNull([req.body.perticipatingUsers])) {
        req.body.perticipatingUsers = [req.session.user.id_users]
    } else {
        req.body.perticipatingUsers.push(req.session.user.id_users)
    }

    /* Insert new user into DB */
    connection.query(`INSERT INTO users.running (distance, startTime, duration, routeLat, routeLong, routeTime) 
        VALUES ("${req.body.distance}", 
                "${req.body.startTime}", 
                "${req.body.duration}", 
                "${req.body.lat}", 
                "${req.body.long}", 
                "${req.body.locationTime}")`, function (err, result) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        }
        /* generate query to insert all perticipating users. */
        var query = `INSERT INTO users.user_activity (id_users, id_running) VALUES `;
        for(var i = 0; i < req.body.perticipatingUsers.length; i++)
        {
            query += `("${req.body.perticipatingUsers[i]}", "${result.insertId}")`
            if (i + 1 != req.body.perticipatingUsers.length)
            {
                query += `, `
            }
        }

        connection.query(query, function (err) {
            if (err) {
                return res.status(500).json({
                    error: err
                });
            }
            res.json({
                message: "Run registered"
            });
        });
    });
})

/**
 * @api {get} /sports/running/getRuns/ Get user runs
 * @apiVersion 1.0.0
 * @apiName getRuns
 * @apiGroup Running
 * 
 * @apiSuccess {Array[]} Runs Array of elements in run (see registerRun)
 * @apiSuccess {Double} Runs.Distance .
 * @apiSuccess {Int} Runs.Starttime Secound since 1970
 * @apiSuccess {Double} Runs.Duration .
 * @apiSuccess {Array} Runs.Lat Array of all latitude coordinated e.g. 22.23, 22.24
 * @apiSuccess {Array} Runs.Long Array of all longitude coordinated e.g. 22.23, 22.24
 * @apiSuccess {Array} Runs.locationTime Secound since 1970 for each coordinat-set e.g. 555555, 555556
 *
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 404) message No runs registered for user
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get('/getRuns', function (req, res) {
    connection.query(`select run.distance, run.duration, run.startTime, run.routeLat, run.routeLong, run.routeTime
        from users.running run
        inner join users.user_activity activity
        where activity.id_users = ${req.session.user.id_users} and activity.id_running = run.id_running`, function (err, row) {

        if (err) {
            return res.status(500).json({
                error: err
            });
        } else if (row.length == 0) {
            return res.status(404).json({
                message: "No runs registered for user"
            });
        } else {
            res.json(row);
        }
    })
})

module.exports = router;