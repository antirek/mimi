
local inspect = require('inspect');

local dbRequest = function (dbconn, dbname)

    local collection = 'route';
    
    local getIncomingRoute = function (extension)

        local cursor = dbconn:query(dbname..'.'..collection, {
            extension = extension,
            context = 'incoming'
        });
    
        local route = cursor:next();
        return route or nil;
    end;

    local getInternalRoute = function (extension, vpbxId)
    
        local cursor = dbconn:query(dbname..'.'..collection, {
            extension = extension,
            context = 'internal',
            vpbxId = tostring(vpbxId)
        });
    
        local route = cursor:next();
        return route or nil;
    end;

    return {
        ["type"] = 'core';
        ["getIncomingRoute"] = getIncomingRoute;
        ["getInternalRoute"] = getInternalRoute;
    };
end;

return dbRequest;