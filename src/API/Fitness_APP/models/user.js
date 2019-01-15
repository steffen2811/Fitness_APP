class User {
    constructor(email, password, name, gender, age, mobile, primarySports, profileImgPath, timeSpendPerWeek, sportLevel, locationLong, locationLat) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.gender = gender;
        this.age = age;
        this.mobile = mobile;
        this.primarySports = primarySports;
        this.profileImgPath = profileImgPath;
        this.timeSpendPerWeek = timeSpendPerWeek;
        this.sportLevel = sportLevel;
        this.locationLong = locationLong;
        this.locationLat = locationLat;
    }
}

module.exports = User;