
local inspect = require('inspect');
local mongo = require('mongo');

local dbRequest = function (dbconn, dbname)

    local collection = 'queue';
    
    local findQueueById = function (id, vpbxId)
        --app.noop('id for find in queue: '..tostring(id));
        
        local cursor = dbconn:query(dbname..'.'..collection, {
            _id = mongo.ObjectId(id),
            vpbxId = tostring(vpbxId)
        });
        local queue = cursor:next();        
        return queue or nil;
    end;

    return {
        ["type"] = 'queue';
        ["findQueueById"] = findQueueById;
    };
end;

return dbRequest;