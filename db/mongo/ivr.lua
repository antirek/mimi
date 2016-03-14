local inspect = require('inspect');
local mongo = require('mongo');

local dbRequest = function (dbconn, dbname)

    local collection = 'ivr';

    local findIVRById = function (id, vpbxId)
        local cursor = dbconn:query(dbname..'.'..collection, {
            _id = mongo.ObjectId(id),
            vpbxId = tostring(vpbxId)
        });

        local menu = cursor:next();
        return menu or nil;
    end;

    return {
        ["type"] = 'ivr';
        ["findIVRById"] = findIVRById;
    };
end;

return dbRequest;