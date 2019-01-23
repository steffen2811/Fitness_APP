var connection = require('./mysql');

function createUser(user, callback) {
    /* Insert new user into DB */
    connection.query(`INSERT INTO users.users (email, password, name, gender, age, mobile, primarySports, profileImgPath, timeSpendPerWeek, sportLevel, locationLong, locationLat) 
                    VALUES ("${user.email}", 
                            "${user.password}", 
                            "${user.name}", 
                            "${user.gender}", 
                            "${user.age}", 
                            "${user.mobile}", 
                            "${user.primarySports}", 
                            "${user.profileImgPath}", 
                            "${user.timeSpendPerWeek}", 
                            "${user.sportLevel}", 
                            "${user.locationLong}", 
                            "${user.locationLat}")`, function (err, result) {
        if (err) {
            callback(err);
            return;
        }
        callback(null, result.insertId);
    });
}

module.exports = createUser;