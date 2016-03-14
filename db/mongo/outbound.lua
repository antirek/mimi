
local inspect = require('inspect');

local dbRequest = function (dbconn, dbname)

	local collection = 'trunk';

    local getOutgoingTrunks = function ()
    	local cursor = dbconn:query(dbname..'.'..collection, {
            category = 'default'
        });

        local trunk = cursor:next();
        return trunk or nil;
    end;
    
    return {
    	['type'] = 'outbound';
        ["getOutgoingTrunks"] = getOutgoingTrunks;
    }
end;

return dbRequest;