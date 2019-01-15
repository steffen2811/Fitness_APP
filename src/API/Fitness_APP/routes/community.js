var express = require('express');
var connection = require('./../helpers/mysql');
var router = express.Router();

router.get('/getSuggestedMatches', function (req, res) {
    connection.query(`select currentUser.id_users, currentUser.name, currentUser.gender, currentUser.age, currentUser.primarySports, currentUser.profileImgPath, currentUser.timeSpendPerWeek, currentUser.sportLevel
        from users.users currentUser
        join users.users_relations relations
        on currentUser.id_users = relations.id_users_2
        where relations.id_users_1 = ${req.session.user.id_users} and relations.RelationsAcceptedUser1 = 0
        union 
        select currentUser.id_users, currentUser.name, currentUser.gender, currentUser.age, currentUser.primarySports, currentUser.profileImgPath, currentUser.timeSpendPerWeek, currentUser.sportLevel
        from users.users currentUser
        join users.users_relations relations
        on currentUser.id_users = relations.id_users_1
        where relations.id_users_2 = ${req.session.user.id_users} and relations.RelationsAcceptedUser2 = 0`, function (err, row) {

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

router.get('/searchForUsers', function (req, res) {
    var search = req.query.search;
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

router.post('/sendRequest', function (req, res) {
    var userToInvite = req.query.userToInvite;
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
module.exports = router;