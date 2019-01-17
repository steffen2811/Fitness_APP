define({ "api": [
  {
    "type": "get",
    "url": "/users/community/getFriends/",
    "title": "Get list of friends",
    "version": "1.0.0",
    "name": "getFriends",
    "group": "Community",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Array[]",
            "optional": false,
            "field": "Request",
            "description": "<p>List of Requests</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Request.id_users",
            "description": "<p>Id of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Request.name",
            "description": "<p>Name of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Request.gender",
            "description": "<p>Gender of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Request.age",
            "description": "<p>Age of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Request.primarySports",
            "description": "<p>Primary Sports of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Request.profileImgPath",
            "description": "<p>Url to profile picture of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Request.timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Request.sportLevel",
            "description": "<p>Sport level of user.</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 404": [
          {
            "group": "Error 404",
            "optional": false,
            "field": "message",
            "description": "<p>No friends found</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/community.js",
    "groupTitle": "Community"
  },
  {
    "type": "get",
    "url": "/users/community/getPendingRequest/",
    "title": "Get pending request",
    "version": "1.0.0",
    "name": "getPendingRequest",
    "group": "Community",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Array[]",
            "optional": false,
            "field": "Request",
            "description": "<p>List of Requests</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Request.id_users",
            "description": "<p>Id of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Request.name",
            "description": "<p>Name of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Request.gender",
            "description": "<p>Gender of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Request.age",
            "description": "<p>Age of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Request.primarySports",
            "description": "<p>Primary Sports of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Request.profileImgPath",
            "description": "<p>Url to profile picture of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Request.timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Request.sportLevel",
            "description": "<p>Sport level of user.</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "accessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 404": [
          {
            "group": "Error 404",
            "optional": false,
            "field": "message",
            "description": "<p>No requests found.</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/community.js",
    "groupTitle": "Community"
  },
  {
    "type": "get",
    "url": "/users/community/getSuggestedMatches/",
    "title": "Get suggested matches",
    "version": "1.0.0",
    "name": "getSuggestedMatches",
    "group": "Community",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Array[]",
            "optional": false,
            "field": "Match",
            "description": "<p>List of matches.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Match.id_users",
            "description": "<p>Id of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Match.name",
            "description": "<p>Name of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Match.gender",
            "description": "<p>Gender of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Match.age",
            "description": "<p>Age of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Match.primarySports",
            "description": "<p>Primary Sports of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Match.profileImgPath",
            "description": "<p>Url to profile picture of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Match.timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Match.sportLevel",
            "description": "<p>Sport level of user.</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 404": [
          {
            "group": "Error 404",
            "optional": false,
            "field": "message",
            "description": "<p>No suggested matches for you :(</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/community.js",
    "groupTitle": "Community"
  },
  {
    "type": "put",
    "url": "/users/community/responseRequestAccept/",
    "title": "Send accept to friend request",
    "version": "1.0.0",
    "name": "responseRequestAccept",
    "group": "Community",
    "parameter": {
      "fields": {
        "Param": [
          {
            "group": "Param",
            "type": "Int",
            "optional": false,
            "field": "responseToUserid",
            "description": "<p>User ID of friend request</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Response sent. User added to friendlist</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "message",
            "description": "<p>responseToUserid param is missing</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 406": [
          {
            "group": "Error 406",
            "optional": false,
            "field": "message",
            "description": "<p>Request wasn´t updated because it does not exist</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/community.js",
    "groupTitle": "Community"
  },
  {
    "type": "delete",
    "url": "/users/community/responseRequestDeny/",
    "title": "Send deny to friend request",
    "version": "1.0.0",
    "name": "responseRequestDeny",
    "group": "Community",
    "parameter": {
      "fields": {
        "Param": [
          {
            "group": "Param",
            "type": "Int",
            "optional": false,
            "field": "responseToUserid",
            "description": "<p>User ID of friend request</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Response sent and request removed.</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "message",
            "description": "<p>responseToUserid param is missing</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 406": [
          {
            "group": "Error 406",
            "optional": false,
            "field": "message",
            "description": "<p>Request wasn´t updated because it does not exist</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/community.js",
    "groupTitle": "Community"
  },
  {
    "type": "get",
    "url": "/users/community/searchForUsers/",
    "title": "Search for user",
    "version": "1.0.0",
    "name": "searchForUsers",
    "group": "Community",
    "description": "<p>Search for user name. Uses regex to search. Search from start of name</p>",
    "parameter": {
      "fields": {
        "Param": [
          {
            "group": "Param",
            "type": "String",
            "optional": false,
            "field": "search",
            "description": "<p>String to search for.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Array[]",
            "optional": false,
            "field": "Match",
            "description": "<p>List of found users.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Match.id_users",
            "description": "<p>Id of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Match.name",
            "description": "<p>Name of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Match.gender",
            "description": "<p>Gender of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Match.age",
            "description": "<p>Age of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Match.primarySports",
            "description": "<p>Primary Sports of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "Match.profileImgPath",
            "description": "<p>Url to profile picture of user.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Match.timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Match.sportLevel",
            "description": "<p>Sport level of user.</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "message",
            "description": "<p>search param is missing</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "accessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 404": [
          {
            "group": "Error 404",
            "optional": false,
            "field": "message",
            "description": "<p>No users found</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/community.js",
    "groupTitle": "Community"
  },
  {
    "type": "post",
    "url": "/users/community/sendRequest/",
    "title": "Send friend request",
    "version": "1.0.0",
    "name": "sendRequest",
    "group": "Community",
    "description": "<p>If the requested user is a suggested match, the match will not show as suggested match again</p>",
    "parameter": {
      "fields": {
        "Param": [
          {
            "group": "Param",
            "type": "Int",
            "optional": false,
            "field": "userToInvite",
            "description": "<p>User ID of user to send the request to.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Request sent</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "message",
            "description": "<p>userToInvite param is missing</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "AlreadySentByRequestedUser",
            "description": "<p>Requested user has already sent an invite</p>"
          },
          {
            "group": "Error 500",
            "optional": false,
            "field": "AlreadyExist",
            "description": "<p>Request already exist</p>"
          },
          {
            "group": "Error 500",
            "optional": false,
            "field": "AlreadyFriend",
            "description": "<p>Users already friends</p>"
          },
          {
            "group": "Error 500",
            "optional": false,
            "field": "SentToYouself",
            "description": "<p>same user as requester and related</p>"
          },
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/community.js",
    "groupTitle": "Community"
  },
  {
    "type": "post",
    "url": "/users/facebook/create",
    "title": "Create user with Facebook",
    "version": "1.0.0",
    "name": "Facebook_create",
    "group": "Facebook",
    "description": "<p>Suggested matches will be found in DB</p>",
    "parameter": {
      "fields": {
        "Request body": [
          {
            "group": "Request body",
            "type": "String",
            "allowedValues": [
              "\"male\"",
              "\"female\""
            ],
            "optional": false,
            "field": "gender",
            "description": "<p>Gender</p>"
          },
          {
            "group": "Request body",
            "type": "Number",
            "optional": false,
            "field": "age",
            "description": "<p>Age</p>"
          },
          {
            "group": "Request body",
            "type": "Number",
            "optional": false,
            "field": "mobile",
            "description": "<p>Mobile number</p>"
          },
          {
            "group": "Request body",
            "type": "String",
            "allowedValues": [
              "\"Run\"",
              "\"Fitness\""
            ],
            "optional": false,
            "field": "primarySports",
            "description": "<p>Primary sport</p>"
          },
          {
            "group": "Request body",
            "type": "Number",
            "optional": false,
            "field": "timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Request body",
            "type": "Number",
            "size": "1-10",
            "optional": false,
            "field": "sportLevel",
            "description": "<p>Sport level. 1 is beginner, 10 is very experienced.</p>"
          },
          {
            "group": "Request body",
            "type": "Float",
            "optional": false,
            "field": "locationLong",
            "description": "<p>Longitude (north/south)</p>"
          },
          {
            "group": "Request body",
            "type": "Float",
            "optional": false,
            "field": "locationLat",
            "description": "<p>Latitude (west/east)</p>"
          }
        ],
        "Authorization - Bearer Token": [
          {
            "group": "Authorization - Bearer Token",
            "type": "Token",
            "optional": false,
            "field": "FBUserToken",
            "description": "<p>Facebook user token</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>Username (email)</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>Always null when facebook login is used</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>Full name</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "gender",
            "description": "<p>Gender</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "age",
            "description": "<p>Age</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "mobile",
            "description": "<p>Mobile number</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "primarySports",
            "description": "<p>Primary sport</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "profileImgPath",
            "description": "<p>Path to profile picture</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "sportLevel",
            "description": "<p>Sport level. 1 is beginner, 10 is very experienced.</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLong",
            "description": "<p>Longitude (north/south)</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLat",
            "description": "<p>Latitude (west/east)</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "id_users",
            "description": "<p>user ID</p>"
          },
          {
            "group": "Success 200",
            "type": "Cookie",
            "optional": false,
            "field": "Session",
            "description": "<p>Session cookie</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "Auth",
            "description": "<p>Auth failed</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "UserExist",
            "description": "<p>User already exist.</p>"
          },
          {
            "group": "Error 403",
            "optional": false,
            "field": "MissingData",
            "description": "<p><code>DATA</code> is missing from body.</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/facebook.js",
    "groupTitle": "Facebook"
  },
  {
    "type": "get",
    "url": "/users/facebook/login",
    "title": "Login user with Facebook",
    "version": "1.0.0",
    "name": "Facebook_login",
    "group": "Facebook",
    "parameter": {
      "fields": {
        "Authorization - Bearer Token": [
          {
            "group": "Authorization - Bearer Token",
            "type": "Token",
            "optional": false,
            "field": "FBUserToken",
            "description": "<p>Facebook user token</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "id_users",
            "description": "<p>user ID</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>Username (email)</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>Always null when facebook login is used</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>Full name</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "gender",
            "description": "<p>Gender</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "age",
            "description": "<p>Age</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "mobile",
            "description": "<p>Mobile number</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "primarySports",
            "description": "<p>Primary sport</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "profileImgPath",
            "description": "<p>Path to profile picture</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "sportLevel",
            "description": "<p>Sport level. 1 is beginner, 10 is very experienced.</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLong",
            "description": "<p>Longitude (north/south)</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLat",
            "description": "<p>Latitude (west/east)</p>"
          },
          {
            "group": "Success 200",
            "type": "Cookie",
            "optional": false,
            "field": "Session",
            "description": "<p>Session cookie</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "Auth",
            "description": "<p>Auth failed</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "UserNotFound",
            "description": "<p>User not found in db</p>"
          },
          {
            "group": "Error 403",
            "optional": false,
            "field": "MissingData",
            "description": "<p><code>DATA</code> is missing from body.</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/facebook.js",
    "groupTitle": "Facebook"
  },
  {
    "type": "get",
    "url": "/sports/running/getRuns/",
    "title": "Get user runs",
    "version": "1.0.0",
    "name": "getRuns",
    "group": "Running",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Array[]",
            "optional": false,
            "field": "Runs",
            "description": "<p>Array of elements in run (see registerRun)</p>"
          },
          {
            "group": "Success 200",
            "type": "Double",
            "optional": false,
            "field": "Runs.Distance",
            "description": "<p>.</p>"
          },
          {
            "group": "Success 200",
            "type": "Int",
            "optional": false,
            "field": "Runs.Starttime",
            "description": "<p>Secound since 1970</p>"
          },
          {
            "group": "Success 200",
            "type": "Double",
            "optional": false,
            "field": "Runs.Duration",
            "description": "<p>.</p>"
          },
          {
            "group": "Success 200",
            "type": "Array",
            "optional": false,
            "field": "Runs.Lat",
            "description": "<p>Array of all latitude coordinated e.g. 22.23, 22.24</p>"
          },
          {
            "group": "Success 200",
            "type": "Array",
            "optional": false,
            "field": "Runs.Long",
            "description": "<p>Array of all longitude coordinated e.g. 22.23, 22.24</p>"
          },
          {
            "group": "Success 200",
            "type": "Array",
            "optional": false,
            "field": "Runs.locationTime",
            "description": "<p>Secound since 1970 for each coordinat-set e.g. 555555, 555556</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 404": [
          {
            "group": "Error 404",
            "optional": false,
            "field": "message",
            "description": "<p>No runs registered for user</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/running.js",
    "groupTitle": "Running"
  },
  {
    "type": "post",
    "url": "/sports/running/registerRun/",
    "title": "Save run",
    "version": "1.0.0",
    "name": "registerRun",
    "group": "Running",
    "parameter": {
      "fields": {
        "Request body": [
          {
            "group": "Request body",
            "type": "Double",
            "optional": false,
            "field": "Distance",
            "description": "<p>.</p>"
          },
          {
            "group": "Request body",
            "type": "Int",
            "optional": false,
            "field": "Starttime",
            "description": "<p>Secound since 1970</p>"
          },
          {
            "group": "Request body",
            "type": "Double",
            "optional": false,
            "field": "Duration",
            "description": "<p>.</p>"
          },
          {
            "group": "Request body",
            "type": "Array[]",
            "optional": false,
            "field": "Lat",
            "description": "<p>Array of all latitude coordinated e.g. 22.23, 22.24</p>"
          },
          {
            "group": "Request body",
            "type": "Array[]",
            "optional": false,
            "field": "Long",
            "description": "<p>Array of all longitude coordinated e.g. 22.23, 22.24</p>"
          },
          {
            "group": "Request body",
            "type": "Array[]",
            "optional": false,
            "field": "locationTime",
            "description": "<p>Secound since 1970 for each coordinat-set e.g. 555555, 555556</p>"
          },
          {
            "group": "Request body",
            "type": "Array[]",
            "optional": true,
            "field": "perticipatingUsers",
            "description": "<p>Users perticipated in run</p>"
          },
          {
            "group": "Request body",
            "type": "Int",
            "optional": true,
            "field": "perticipatingUsers.id_users",
            "description": "<p>id of user</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Run registered</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "message",
            "description": "<p>Param is missing. Check docs.</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/running.js",
    "groupTitle": "Running"
  },
  {
    "type": "put",
    "url": "/users/changePassword/",
    "title": "Change user password",
    "version": "1.0.0",
    "name": "changePassword",
    "group": "Users",
    "parameter": {
      "fields": {
        "Request body": [
          {
            "group": "Request body",
            "type": "String",
            "optional": false,
            "field": "oldPassword",
            "description": "<p>.</p>"
          },
          {
            "group": "Request body",
            "type": "String",
            "optional": false,
            "field": "newPassword",
            "description": "<p>.</p>"
          },
          {
            "group": "Request body",
            "type": "String",
            "optional": false,
            "field": "reTypeNewPassword",
            "description": "<p>.</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "Message",
            "description": "<p>param is missing. Check doc</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 404": [
          {
            "group": "Error 404",
            "optional": false,
            "field": "UserNotFound",
            "description": "<p>User not found</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/users.js",
    "groupTitle": "Users"
  },
  {
    "type": "post",
    "url": "/users/create",
    "title": "Create user",
    "version": "1.0.0",
    "name": "create",
    "group": "Users",
    "description": "<p>Suggested matches will be found in DB</p>",
    "parameter": {
      "fields": {
        "Request body": [
          {
            "group": "Request body",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>Full name</p>"
          },
          {
            "group": "Request body",
            "type": "String",
            "allowedValues": [
              "\"male\"",
              "\"female\""
            ],
            "optional": false,
            "field": "gender",
            "description": "<p>Gender</p>"
          },
          {
            "group": "Request body",
            "type": "Number",
            "optional": false,
            "field": "age",
            "description": "<p>Age</p>"
          },
          {
            "group": "Request body",
            "type": "Number",
            "optional": false,
            "field": "mobile",
            "description": "<p>Mobile number</p>"
          },
          {
            "group": "Request body",
            "type": "String",
            "allowedValues": [
              "\"Run\"",
              "\"Fitness\""
            ],
            "optional": false,
            "field": "primarySports",
            "description": "<p>Primary sport</p>"
          },
          {
            "group": "Request body",
            "type": "Number",
            "optional": false,
            "field": "timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Request body",
            "type": "Number",
            "size": "1-10",
            "optional": false,
            "field": "sportLevel",
            "description": "<p>Sport level. 1 is beginner, 10 is very experienced.</p>"
          },
          {
            "group": "Request body",
            "type": "Float",
            "optional": false,
            "field": "locationLong",
            "description": "<p>Longitude (north/south)</p>"
          },
          {
            "group": "Request body",
            "type": "Float",
            "optional": false,
            "field": "locationLat",
            "description": "<p>Latitude (west/east)</p>"
          },
          {
            "group": "Request body",
            "type": "String",
            "optional": true,
            "field": "profilePicture",
            "description": "<p>Profile picture as Base64 string.</p>"
          }
        ],
        "Authorization - Basic authentication": [
          {
            "group": "Authorization - Basic authentication",
            "type": "Email",
            "optional": false,
            "field": "Username",
            "description": "<p>Username</p>"
          },
          {
            "group": "Authorization - Basic authentication",
            "type": "Password",
            "optional": false,
            "field": "Password",
            "description": "<p>Password</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>Username (email)</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>Encrypted password</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>Full name</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "gender",
            "description": "<p>Gender</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "age",
            "description": "<p>Age</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "mobile",
            "description": "<p>Mobile number</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "primarySports",
            "description": "<p>Primary sport</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "profileImgPath",
            "description": "<p>Path to profile picture</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "sportLevel",
            "description": "<p>Sport level. 1 is beginner, 10 is very experienced.</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLong",
            "description": "<p>Longitude (north/south)</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLat",
            "description": "<p>Latitude (west/east)</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "id_users",
            "description": "<p>user ID</p>"
          },
          {
            "group": "Success 200",
            "type": "Cookie",
            "optional": false,
            "field": "Session",
            "description": "<p>Session cookie</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "Email",
            "description": "<p>Wrong email format.</p>"
          }
        ],
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "UserExist",
            "description": "<p>User already exist.</p>"
          },
          {
            "group": "Error 403",
            "optional": false,
            "field": "MissingData",
            "description": "<p><code>DATA</code> is missing from body.</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/users.js",
    "groupTitle": "Users"
  },
  {
    "type": "get",
    "url": "/users/getCurrentUser/",
    "title": "Get current user (based on session/cookie)",
    "version": "1.0.0",
    "name": "getCurrentUser",
    "group": "Users",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>Username (email)</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>Encrypted password</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>Full name</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "gender",
            "description": "<p>Gender</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "age",
            "description": "<p>Age</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "mobile",
            "description": "<p>Mobile number</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "primarySports",
            "description": "<p>Primary sport</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "profileImgPath",
            "description": "<p>Path to profile picture</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "sportLevel",
            "description": "<p>Sport level. 1 is beginner, 10 is very experienced.</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLong",
            "description": "<p>Longitude (north/south)</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLat",
            "description": "<p>Latitude (west/east)</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "id_users",
            "description": "<p>user ID</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/users.js",
    "groupTitle": "Users"
  },
  {
    "type": "get",
    "url": "/users/login/",
    "title": "User login",
    "version": "1.0.0",
    "name": "login",
    "group": "Users",
    "parameter": {
      "fields": {
        "Authorization - Basic authentication": [
          {
            "group": "Authorization - Basic authentication",
            "type": "Email",
            "optional": false,
            "field": "Username",
            "description": "<p>Username</p>"
          },
          {
            "group": "Authorization - Basic authentication",
            "type": "Password",
            "optional": false,
            "field": "Password",
            "description": "<p>Password</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>Username (email)</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>Encrypted password</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>Full name</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "gender",
            "description": "<p>Gender</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "age",
            "description": "<p>Age</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "mobile",
            "description": "<p>Mobile number</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "primarySports",
            "description": "<p>Primary sport</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "profileImgPath",
            "description": "<p>Path to profile picture</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "timeSpendPerWeek",
            "description": "<p>Time spend per week.</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "sportLevel",
            "description": "<p>Sport level. 1 is beginner, 10 is very experienced.</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLong",
            "description": "<p>Longitude (north/south)</p>"
          },
          {
            "group": "Success 200",
            "type": "Float",
            "optional": false,
            "field": "locationLat",
            "description": "<p>Latitude (west/east)</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "optional": false,
            "field": "id_users",
            "description": "<p>user ID</p>"
          },
          {
            "group": "Success 200",
            "type": "Cookie",
            "optional": false,
            "field": "Session",
            "description": "<p>Session cookie</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 400": [
          {
            "group": "Error 400",
            "optional": false,
            "field": "Email",
            "description": "<p>Wrong email format.</p>"
          }
        ],
        "Error 401": [
          {
            "group": "Error 401",
            "optional": false,
            "field": "Unauthorized",
            "description": "<p>No password revieved</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "Password",
            "description": "<p>Incorrect password.</p>"
          },
          {
            "group": "Error 500",
            "optional": false,
            "field": "UserNotFound",
            "description": "<p>User not found</p>"
          },
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/users.js",
    "groupTitle": "Users"
  },
  {
    "type": "get",
    "url": "/users/logout/",
    "title": "User logout",
    "version": "1.0.0",
    "name": "logout",
    "group": "Users",
    "description": "<p>Session will be destoyed</p>",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Logout success</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 403": [
          {
            "group": "Error 403",
            "optional": false,
            "field": "AccessDenied",
            "description": "<p>Access denied (No session)</p>"
          }
        ],
        "Error 500": [
          {
            "group": "Error 500",
            "optional": false,
            "field": "unspecifiedError",
            "description": "<p>Please report</p>"
          }
        ]
      }
    },
    "filename": "routes/users.js",
    "groupTitle": "Users"
  }
] });
