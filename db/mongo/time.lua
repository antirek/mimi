
local inspect = require('inspect');
local mongo = require('mongo');

local dbRequest = function (dbconn, dbname)
    
    local findTimeweekById = function (id, vpbxId)
        app.noop("timeweek id: "..tostring(id));

        local cursor = dbconn:query(dbname..".timeweek", {
            _id = mongo.ObjectId(id),
            vpbxId = tostring(vpbxId)
        });

        local time = cursor:next();
        return time or nil;
    end;

    local findTimedayById = function (id, vpbxId)
        app.noop("timeday id: "..tostring(id));

        local cursor = dbconn:query(dbname..".timeday", {
            _id = mongo.ObjectId(id),
            vpbxId = tostring(vpbxId)
        });

        local time = cursor:next();
        return time or nil;
    end;

    return {
        ["type"] = 'time';
        ["findTimeweekById"] = findTimeweekById;
        ["findTimedayById"] = findTimedayById;
    };
end;

return dbRequest;