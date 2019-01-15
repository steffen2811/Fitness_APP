var express = require('express');
var connection = require('./../helpers/mysql');
var router = express.Router();

router.get('/getSuggestedMatches', function (req, res) {
    connection.query(`select currentUser.name, currentUser.gender, currentUser.age, currentUser.primarySports, currentUser.profileImgPath, currentUser.timeSpendPerWeek, currentUser.sportLevel
        from users.users currentUser
        join users.users_relations relations
        on currentUser.id_users = relations.id_users_2
        where relations.id_users_1 = 2 and relations.RelationsAcceptedUser1 = 0
        union 
        select currentUser.name, currentUser.gender, currentUser.age, currentUser.primarySports, currentUser.profileImgPath, currentUser.timeSpendPerWeek, currentUser.sportLevel
        from users.users currentUser
        join users.users_relations relations
        on currentUser.id_users = relations.id_users_1
        where relations.id_users_2 = 2 and relations.RelationsAcceptedUser2 = 0`, function (err, row) {

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