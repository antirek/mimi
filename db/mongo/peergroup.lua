
local inspect = require('inspect');
local mongo = require('mongo');

local dbRequest = function (dbconn, dbname)

    local collection = 'peergroup';
    
    local findPeergroupById = function (id, vpbxId)
        app.noop('lolo:'..inspect(id)..' '..inspect(vpbxId));
        local cursor = dbconn:query(dbname..'.'..collection, {
            _id = mongo.ObjectId(id),
            vpbxId = tostring(vpbxId)
        });
        local group = cursor:next();        
        return group or nil;
    end;

    return {
        ["type"] = 'peergroup';
        ["findPeergroupById"] = findPeergroupById;
    };
end;

return dbRequest;