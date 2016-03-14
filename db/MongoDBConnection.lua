local mongo = require('mongo');
local inspect = require('inspect');

local dbConn = function (config)
    local db, err = mongo.Connection.New({
    		auto_reconnect = config.auto_reconnect or true;
    	});
    
    if (err) then
    	db = nil; 
    else
    	local ok, err = db:connect(config.host);
    end;

    return db;
end;

return dbConn;