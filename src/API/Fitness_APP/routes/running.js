var express = require('express');
var connection = require('./../helpers/mysql');
var router = express.Router();

router.post('/registerRun', function (req, res) {
    /* Insert new user into DB */
    connection.query(`INSERT INTO users.running (distance, startTime, timeSecound, route_lat, route_long, route_time) 
        VALUES ("${req.body.Distance}", 
                "${req.body.Starttime}", 
                "${req.body.Duration}", 
                "${req.body.Lat}", 
                "${req.body.Long}", 
                "${req.body.locationTime}")`, function (err) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        }
        res.json({
            message: "Run registered"
        });
    });

})

module.exports = router;