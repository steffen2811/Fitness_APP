var base64Img = require('base64-img');

// Upload picture from base64 string
function fileUpload(mode) {
    return function (req, res, next) {
        // Check if base64 string exist
        if (typeof req.body.profilePicture !== "undefined") {
            if (!req.body.profilePicture.match(/^data.*$/)) {
                req.body.profilePicture = "data:image/png;base64," + req.body.profilePicture
            }
            //Copy image to picture folder
            base64Img.img(req.body.profilePicture, process.env.BASE_PATH + '/profilePictures', req.body.email, function (err) {
                if (err) {
                    return res.status(500).json({
                        error: err
                    });
                }
                //Set url to picture in user profile
                req.body.profileImgPath = process.env.PROFILE_PICTURE_PATH + req.body.email;
                next();
            });
        } else {
            //If no profile picture is set and user has to be created, set standart profile picture
            //If update profile, do nothing if no picture is received
            if (mode == "create") {
                req.body.profileImgPath = process.env.PROFILE_PICTURE_PATH + "standartProfilePicture.jpg";
                next();
            } else if (mode == "update") {
                next();
            }
        }
    }
}

module.exports = fileUpload;