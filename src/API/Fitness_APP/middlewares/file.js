function fileUpload(req, res, next) {
    if (typeof req.files === "undefined") {
        if (typeof req.files["profilePicture"] !== "undefined") {
            var fileRef = req.files["profilePicture"];
            var filePath = process.env.PROFILE_PICTURE_PATH + ".jpg"

            // Use the mv() method to place the file somewhere on your server
            fileRef.mv(filePath, function (err) {
                if (err) {
                    return res.status(500).json({
                        error: err
                    });
                }
                req.body.profileImgPath = filePath;
                next();
            });
        }
    } else {
        req.body.profileImgPath = process.env.PROFILE_PICTURE_PATH + "standartProfilePicture.jpg";
        next();
    }
};

module.exports = fileUpload;