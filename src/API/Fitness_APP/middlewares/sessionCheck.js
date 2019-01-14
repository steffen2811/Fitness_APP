/* Function - Check if user is authenticated */
function sessionChecker(req, res, next) {
    //If user has a session (logged in)
    if (typeof req.session.user !== "undefined") {
        //If user attemp to create or login, return user data.
        if (req.path.match(/^.*login$/) || req.path.match(/^.*create$/)) {
            res.json(req.session.user);
            return;
        }
        // else, continue to requested function
        else {
            next();
        }
        //If user has no session
    } else {
        //If user attemp to create or login, continue
        if (req.path.match(/^.*login$/) || req.path.match(/^.*create$/)) {
            next();
        }
        // else, access denied 
        else {
            res.status(403).json({
                message: "Access denied"
            });
        }
    }
};

module.exports = sessionChecker;