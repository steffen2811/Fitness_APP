var express = require('express');
var connection = require('./../helpers/mysql');
var router = express.Router();

router.post('/registerRun', function (req, res) {
    /* Insert new user into DB */
    connection.query(`INSERT INTO users.running (distance, startTime, timeSecound, routeLat, routeLong, routeTime) 
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
        connection.query(`INSERT INTO users.user_activity (id_users, id_running)
            VALUES ("${req.session.user.id_users}",
                    "${result.insertId}")`, function (err) {
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

router.get('/getRuns', function (req, res) {
    connection.query(`select run.distance, run.distance, run.timeSecound, run.route_lat, run.route_long, run.route_time
        from users.running run
        inner join users.user_activity activity
        where activity.id_users = ${req.session.user.id_users} and activity.id_running = run.id_running`, function (err, row) {

        if (err) {
            return res.status(500).json({
                error: err
            });
        } else if (row.length == 0) {
            return res.json({
                message: "No runs registered for user"
            });
        } else {
            res.json(row);
        }
    })
})

module.exports = router;