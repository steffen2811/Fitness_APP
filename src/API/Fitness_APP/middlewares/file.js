var base64Img = require('base64-img');

function fileUpload(req, res, next) {
    if (typeof req.body.profilePicture !== "undefined") {
        if (!req.body.profilePicture.match(/^data.*$/)) {
            req.body.profilePicture = "data:image/png;base64," + req.body.profilePicture
        }
        base64Img.img(req.body.profilePicture, process.env.PROFILE_PICTURE_PATH, req.body.email, function (err, filepath) {
            if (err) {
                return res.status(500).json({
                    error: err
                });
            }
            req.body.profileImgPath = filepath.replace(/\\/g, '/');
            next();
        });
    } else {
        req.body.profileImgPath = process.env.PROFILE_PICTURE_PATH + "standartProfilePicture.jpg";
        next();
    }
};

module.exports = fileUpload;