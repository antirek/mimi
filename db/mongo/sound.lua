
local inspect = require('inspect');
local mongo = require('mongo');

local dbRequest = function (dbconn, dbname)

    local collection = 'sound';
    
    local findSoundById = function (id, vpbxId)
        --app.noop('id for find in sound: '..id..' vpbxId: '..vpbxId);
        
        local cursor = dbconn:query(dbname..'.'..collection, {
            _id = mongo.ObjectId(id),
            vpbxId = tostring(vpbxId)
        });
        
        local sound = cursor:next();
        
        return sound or nil;
    end;

    return {
        ["type"] = 'sound';
        ["findSoundById"] = findSoundById;
    };
end;

return dbRequest;