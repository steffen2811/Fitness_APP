var express = require('express');
var connection = require('./../helpers/mysql');
var checks = require('../middlewares/checks');
var router = express.Router();

/**
 * @api {post} /sports/fitness/createFitnessPlan/ Create fitness plan
 * @apiVersion 1.0.0
 * @apiName createFitnessPlan
 * @apiGroup Fitness
 * 
 * @apiParam (Request body) {String} FitnessPlanName Name of plan
 * @apiParam (Request body) {Array[]} [FitnessPlanExecises] Execises in plan
 * @apiParam (Request body) {Int} [FitnessPlanExecises.id_fitness_exercises] Id of execise.
 * 
 * @apiSuccess {String} message Fitness plan created
 *
 * @apiError (Error 400) message Param is missing. Check docs.
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.post("/createFitnessPlan", function (req, res) {
    if (checks.checkUndefinedOrNull([req.body.FitnessPlanName, req.body.FitnessPlanExecises])) {
        return res.status(400).json({
            message: "Param is missing. Check doc."
        });
    }
    /* Insert new user into DB */
    connection.query(`INSERT INTO users.fitness_plan (FitnessPlanName) 
        VALUES ("${req.body.FitnessPlanName}")`, async function (err, result) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        }

        /* generate query to insert all perticipating users. */
        var query = `INSERT INTO users.fitness_exercises_in_plan (id_fitness_exercises, id_fitness_plan) VALUES `;
        for (var i = 0; i < req.body.FitnessPlanExecises.length; i++) {
            query += `("${req.body.FitnessPlanExecises[i]}", "${result.insertId}")`
            if (i + 1 != req.body.FitnessPlanExecises.length) {
                query += `, `
            }
        }

        try {
            var response = await connection.query(query)
        } catch (err) {
            return res.status(500).json({
                error: err
            });
        }

        connection.query(`INSERT INTO users.user_activity (id_users, id_fitness_plan) 
            VALUES ("${req.session.user.id_users}", "${result.insertId}")`, function (err) {
            if (err) {
                return res.status(500).json({
                    error: err
                });
            } else {
                res.json({
                    message: "Fitness plan created"
                });
            }
        });
    })
})

/**
 * @api {get} /sports/fitness/getAllExecises Get all execises
 * @apiVersion 1.0.0
 * @apiName getAllExecises
 * @apiGroup Fitness
 * 
 * @apiSuccess {Array[]} Execises List of Execises.
 * @apiSuccess {Int} Execises.id_fitness_execises Id of execise.
 * @apiSuccess {String} Execises.execiseName Name of execise.
 * @apiSuccess {String} Execises.repeats Repeats.
 * @apiSuccess {Int} Execises.sets Sets.
 * @apiSuccess {String} Execises.howToVideo Link to youtube.
 *
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get("/getAllExecises", function (req, res) {
    connection.query("SELECT * FROM users.fitness_exercises", function (err, row) {
        if (err) {
            res.status(500).json({
                error: err
            })
        } else {
            res.json(row)
        }
    })
})

/**
 * @api {get} /sports/fitness/getFitnessPlans/ Get user fitness plans
 * @apiVersion 1.0.0
 * @apiName getFitnessPlans
 * @apiGroup Fitness
 * 
 * @apiSuccess {Array[]} Plans Array of fitness plans
 * @apiSuccess {Double} Plans.id_fitness_plan Id of plan
 * @apiSuccess {Int} Plans.FitnessPlanName Name of plan
 *
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 404) message No fitness plans for user
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get("/getFitnessPlans", function (req, res) {
    connection.query(`select fp.id_fitness_plan, fp.FitnessPlanName
    from users.fitness_plan fp
    inner join users.user_activity activity
    where activity.id_users = ${req.session.user.id_users} and activity.id_fitness_plan = fp.id_fitness_plan`, function (err, row) {

        if (err) {
            return res.status(500).json({
                error: err
            });
        } else if (row.length == 0) {
            return res.status(404).json({
                message: "No fitness plans for user"
            });
        } else {
            res.json(row);
        }
    })
})

/**
 * @api {get} /sports/fitness/getExecisesInPlan/ Get execises in fitness plan
 * @apiVersion 1.0.0
 * @apiName getExecisesInPlan
 * @apiGroup Fitness
 * 
 * @apiParam (Param) {Int} fitnessPlanId Id of fitness plan to receive data from
 * 
 * @apiSuccess {Array[]} Execises List of Execises.
 * @apiSuccess {String} Execises.execiseName Name of execise.
 * @apiSuccess {String} Execises.repeats Repeats.
 * @apiSuccess {Int} Execises.sets Sets.
 * @apiSuccess {String} Execises.howToVideo Link to youtube.
 *
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get("/getExecisesInPlan", function (req, res) {
    if (checks.checkUndefinedOrNull([req.query.fitnessPlanId])) {
        return res.status(400).json({
            message: "Param is missing. Check doc."
        });
    }
    connection.query(`Select fitness_exercises.execiseName, fitness_exercises.repeats, fitness_exercises.sets, fitness_exercises.howToVideo From users.fitness_exercises
    Join users.fitness_exercises_in_plan
    on fitness_exercises.id_fitness_exercises = fitness_exercises_in_plan.id_fitness_exercises
    where fitness_exercises_in_plan.id_fitness_plan = ${req.query.fitnessPlanId}`, function (err, row) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        } else {
            res.json(row);
        }
    })
})

/**
 * @api {post} /sports/fitness/shareFitnessPlan/ Share fitness plan
 * @apiVersion 1.0.0
 * @apiName shareFitnessPlan
 * @apiGroup Fitness
 * 
 * @apiParam (Request body) {Int} fitnessPlanId Id of fitnessplan to share.
 * @apiParam (Request body) {Array[]} shareWithUsers Users perticipated in run
 * @apiParam (Request body) {Int} shareWithUsers.id_users id of user
 * 
 * @apiSuccess {String} Message Name of execise.
 * 
 * @apiError (Error 400) ParamMissing Param is missing. Check doc.
 * @apiError (Error 400) NoUser No user in shareWithUsers
 * @apiError (Error 400) AccessDenied User does not have access to this fitness plan
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.post("/shareFitnessPlan", async function (req, res) {
    if (checks.checkUndefinedOrNull([req.body.fitnessPlanId, req.body.shareWithUsers])) {
        return res.status(400).json({
            message: "Param is missing. Check doc."
        });
    }

    if (req.body.shareWithUsers.length == 0) {
        return res.status(400).json({
            message: "No user in shareWithUsers."
        });
    }

    try {
        var result = await connection.query(`select * from users.user_activity 
        where user_activity.id_users = ${req.session.user.id_users} and user_activity.id_fitness_plan = ${req.body.fitnessPlanId}`)
    } catch (err) {
        return res.status(500).json({
            error: err
        });
    }

    if (result.length == 0) {
        return res.status(400).json({
            message: "User does not have access to this fitness plan"
        });
    }

    /* generate query to insert all perticipating users. */
    var query = `INSERT INTO users.user_activity (id_users, id_fitness_plan) VALUES `;
    for (var i = 0; i < req.body.shareWithUsers.length; i++) {
        query += `("${req.body.shareWithUsers[i]}", "${req.body.fitnessPlanId}")`
        if (i + 1 != req.body.shareWithUsers.length) {
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
            message: "Shared with users"
        });
    });
})

/**
 * @api {delete} /sports/fitness/deleteFitnessPlan/ Delete fitness plan (Used by test)
 * @apiVersion 1.0.0
 * @apiName deleteFitnessPlan
 * @apiGroup Fitness
 * 
 * @apiParam (Param) {Int} fitnessPlanId Id of fitness plan to delete
 * 
 * @apiSuccess {String} message Fitness plan successfully deleted.
 *
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.delete("/deleteFitnessPlan", function (req, res) {
    if (checks.checkUndefinedOrNull([req.query.fitnessPlanId])) {
        return res.status(400).json({
            message: "Param is missing. Check doc."
        });
    }
    connection.query(`DELETE FROM users.fitness_plan
        WHERE id_fitness_plan = ${req.query.fitnessPlanId}`, function (err, row) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        } else {
            return res.json({
                message: "Fitness plan successfully deleted."
            });
        }
    })
})

module.exports = router;