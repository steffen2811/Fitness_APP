var express = require('express');
var connection = require('./../helpers/mysql');
var checks = require('../middlewares/checks');
var router = express.Router();

/**
 * @api {get} /users/community/getSuggestedMatches/ Get suggested matches
 * @apiVersion 1.0.0
 * @apiName getSuggestedMatches
 * @apiGroup Community
 * 
 * @apiSuccess {Array[]} Match List of matches.
 * @apiSuccess {Int} Match.id_users Id of user.
 * @apiSuccess {String} Match.name Name of user.
 * @apiSuccess {String} Match.gender Gender of user.
 * @apiSuccess {Int} Match.age Age of user.
 * @apiSuccess {String} Match.primarySports Primary Sports of user.
 * @apiSuccess {String} Match.profileImgPath Url to profile picture of user.
 * @apiSuccess {Int} Match.timeSpendPerWeek Time spend per week.
 * @apiSuccess {Int} Match.sportLevel Sport level of user.
 *
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 404) message No suggested matches for you :(
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get('/getSuggestedMatches', function (req, res) {
    connection.query(`select currentUser.id_users, currentUser.name, currentUser.gender, currentUser.age, currentUser.primarySports, currentUser.profileImgPath, currentUser.timeSpendPerWeek, currentUser.sportLevel
        from users.users currentUser
        join users.users_suggested_matches relations
        on currentUser.id_users = relations.id_users_2
        where relations.id_users_1 = ${req.session.user.id_users}
        union 
        select currentUser.id_users, currentUser.name, currentUser.gender, currentUser.age, currentUser.primarySports, currentUser.profileImgPath, currentUser.timeSpendPerWeek, currentUser.sportLevel
        from users.users currentUser
        join users.users_suggested_matches relations
        on currentUser.id_users = relations.id_users_1
        where relations.id_users_2 = ${req.session.user.id_users}`, function (err, row) {

        if (err) {
            return res.status(500).json({
                error: err
            });
        } else if (row.length == 0) {
            return res.status(404).json({
                message: "No suggested matches for you :("
            });
        } else {
            res.json(row);
        }
    })
})

/**
 * @api {get} /users/community/searchForUsers/ Search for user
 * @apiVersion 1.0.0
 * @apiName searchForUsers
 * @apiGroup Community
 * @apiDescription Search for user name or email. 
 * Uses regex to search. Search from start of name and email
 * 
 * @apiParam (Param) {String} search String to search for.
 * 
 * @apiSuccess {Array[]} Match List of found users.
 * @apiSuccess {Int} Match.id_users Id of user.
 * @apiSuccess {String} Match.name Name of user.
 * @apiSuccess {String} Match.gender Gender of user.
 * @apiSuccess {Int} Match.age Age of user.
 * @apiSuccess {String} Match.primarySports Primary Sports of user.
 * @apiSuccess {String} Match.profileImgPath Url to profile picture of user.
 * @apiSuccess {Int} Match.timeSpendPerWeek Time spend per week.
 * @apiSuccess {Int} Match.sportLevel Sport level of user.
 *
 * @apiError (Error 400) message search param is missing
 * @apiError (Error 403) accessDenied Access denied (No session)
 * @apiError (Error 404) message No users found
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get('/searchForUsers', function (req, res) {
    var search = req.query.search;
    if (checks.checkUndefinedOrNull([search]))
    {
        return res.status(400).json({
            message: "search param is missing"
        });
    }
    connection.query(`SELECT users.id_users, users.name, users.gender, users.age, users.primarySports, users.profileImgPath, users.timeSpendPerWeek, users.sportLevel 
    FROM users.users
    WHERE users.email REGEXP '^${search}'
    UNION
    SELECT users.id_users, users.name, users.gender, users.age, users.primarySports, users.profileImgPath, users.timeSpendPerWeek, users.sportLevel 
    FROM users.users 
    WHERE users.name REGEXP '^${search}'`, function (err, row) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        } else if (row.length == 0) {
            return res.status(404).json({
                message: "No users found"
            });
        } else {
            res.json(row);
        }
    })
})

/**
 * @api {post} /users/community/sendRequest/ Send friend request
 * @apiVersion 1.0.0
 * @apiName sendRequest
 * @apiGroup Community
 * @apiDescription It is not possible to:
 * Send a request to yourself.
 * Send a request to a user of a pending request.
 * Send a request that already exist. 
 * 
 * @apiParam (Param) {Int} userToInvite User ID of user to send the request to.
 * 
 * @apiSuccess {String} message Request sent
 *
 * @apiError (Error 400) message userToInvite param is missing
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.post('/sendRequest', function (req, res) {
    var userToInvite = req.query.userToInvite;
    if (checks.checkUndefinedOrNull([userToInvite]))
    {
        return res.status(400).json({
            message: "userToInvite param is missing"
        });
    }
    connection.query(`INSERT INTO users.friend_relationship (requestByUser, relatedUser) VALUES (${req.session.user.id_users}, ${userToInvite});`, function (err) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        } 
        res.json({
            message: "Request sent"
        });
    })
})

/**
 * @api {get} /users/community/getPendingRequest/ Get pending request
 * @apiVersion 1.0.0
 * @apiName getPendingRequest
 * @apiGroup Community
 * 
 * @apiSuccess {Array[]} Request List of Requests
 * @apiSuccess {Int} Request.id_users Id of user.
 * @apiSuccess {String} Request.name Name of user.
 * @apiSuccess {String} Request.gender Gender of user.
 * @apiSuccess {Int} Request.age Age of user.
 * @apiSuccess {String} Request.primarySports Primary Sports of user.
 * @apiSuccess {String} Request.profileImgPath Url to profile picture of user.
 * @apiSuccess {Int} Request.timeSpendPerWeek Time spend per week.
 * @apiSuccess {Int} Request.sportLevel Sport level of user.
 *
 * @apiError (Error 403) accessDenied Access denied (No session)
 * @apiError (Error 404) message No requests found.
 * @apiError (Error 500) unspecifiedError Please report
 */
router.get('/getPendingRequest', function (req, res) {
    connection.query(`SELECT users.id_users, users.name, users.gender, users.age, users.primarySports, users.profileImgPath, users.timeSpendPerWeek, users.sportLevel 
    FROM users.users
    JOIN users.friend_relationship fr
    ON users.id_users = fr.requestByUser
    where fr.relatedUser = ${req.session.user.id_users}`, function (err, row) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        } else if (row.length == 0) {
            return res.status(404).json({
                message: "No requests found"
            });
        } else {
            res.json(row);
        }
    })
})

/**
 * @api {put} /users/community/responseRequest/ Send response to friend request
 * @apiVersion 1.0.0
 * @apiName responseRequest
 * @apiGroup Community
 * 
 * @apiParam (Param) {Int} responseToUserid User ID of friend request
 * @apiParam (Param) {Int} requestAnswer request answer. 1 = accept, 2 = deny
 * 
 * @apiSuccess {String} message Response sent
 *
 * @apiError (Error 304) message Request wasn´t updated because it does not exist
 * @apiError (Error 400) message responseToUserid param is missing
 * @apiError (Error 403) AccessDenied Access denied (No session)
 * @apiError (Error 500) unspecifiedError Please report
 */
router.put('/responseRequest', function (req, res) {
    var responseToUserid = req.query.responseToUserid;
    var requestAnswer = req.query.requestAnswer;
    if (checks.checkUndefinedOrNull([responseToUserid, requestAnswer]))
    {
        return res.status(400).json({
            message: "param is missing. Check doc."
        });
    }
    connection.query(`UPDATE users.friend_relationship
    SET status = ${requestAnswer}
    WHERE requestByUser = ${responseToUserid} and relatedUser = ${req.session.user.id_users}`, function (err, response) {
        if (err) {
            return res.status(500).json({
                error: err
            });
        } else if (response.affectedRows == 0) {
            return res.status(304).json({
                message: "Request wasn´t updated because it does not exist"
            });
        }
        res.json({
            message: "Response sent"
        });
    })
})

module.exports = router;