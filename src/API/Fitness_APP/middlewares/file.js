function fileUpload(path, fileKey) {
    return function (req, res, next) {
        if (typeof req.files === "undefined") {
            return res.status(400).json({
                error: 'No files were uploaded.'
            });
        }

        if (typeof req.files[fileKey] === "undefined") {
            return res.status(400).json({
                error: 'No files with key ' + fileKey + ' were uploaded'
            });
        }
        var fileRef = req.files[fileKey];
        var filePath = path + req.body.email + ".jpg"


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
};

module.exports = fileUpload;