
local inspect = require('inspect');
local mongo = require('mongo');

local dbRequest = function (dbconn, dbname)

    local collection = 'peer';

    local getVpbxId = function (peername)
        local cursor = dbconn:query(dbname..'.'..collection, {
            peername = peername
        });
        local user = cursor:next();
        return (user and user.vpbxId) and user.vpbxId or nil;
    end; 

    local getOutgoingNumber = function (peername)
        local cursor = dbconn:query(dbname..'.'..collection, {
            peername = peername
        });
        local user = cursor:next();
        return (user and user.outgoingNumber) and user.outgoingNumber or nil;
    end;

    local findPeerById = function (id, vpbxId)
        app.noop('id for find: '..tostring(id));

        local cursor = dbconn:query(dbname..'.'..collection, {
            _id = mongo.ObjectId(id),
            vpbxId = tostring(vpbxId)
        });
        local user = cursor:next();
        return user or nil;
    end;

    local findPeerByPeername = function (peername, vpbxId)
        app.noop('peername for find: '..peername);

        local cursor = dbconn:query(dbname..'.'..collection, {
            peername = peername,
            vpbxId = tostring(vpbxId)
        });
        local user = cursor:next();
        return user or nil;
    end;

    local checkRecord = function (peer, vpbxId)
        local user;
        
        if (peer.id) then
            user = findPeerById(peer.id, vpbxId);
        elseif (peer.peername) then
            user = findPeerByPeername(peer.peername, vpbxId);
        end;

        return (user and user.record) and user.record or nil;
    end;

    return {
        ["type"] = 'peer';

        ["getVpbxId"] = getVpbxId;

        ["checkRecord"] = checkRecord;
        ["findPeerById"] = findPeerById;
        ["findPeerByPeername"] = findPeerByPeername;

        ["getOutgoingNumber"] = getOutgoingNumber;
    };
end;

return dbRequest;