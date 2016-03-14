
local inspect = require('inspect');

local internal = function ()
    local route = function (router, object)
        local dbCore = router.getStore('core');
        local dbPeer = router.getStore('peer');

        local vpbxId = dbPeer.getVpbxId(object.peername);
        
        router.setVar('vpbxId', vpbxId);
        router.setVar('uniqueid', channel.CDR('uniqueid'):get());
        router.setVar('linkedid', channel.CDR('linkedid'):get());

        local route = dbCore.getInternalRoute(object.extension, vpbxId);
        app.noop('internal vpbxId: '..inspect(vpbxId)..' route: '..inspect(route));
        
        router:route({type = route.objectType; id = route.objectId});
    end;

    return {
        ["type"] = 'internal';
        ["name"] = "core internal routes";
        ["route"] = route;
    };
end;

local incoming = function ()
    local route = function (router, object)
        local db = router.getStore('core');

        local route = db.getIncomingRoute(object.extension);
        local vpbxId = route.vpbxId;
        router.setVar('vpbxId', vpbxId);

        app.noop('internal vpbxId: '..inspect(vpbxId)..' route: '..inspect(route));
        router:route({type = route.objectType; id = route.objectId});
    end;

    return {
        ["type"] = 'incoming';
        ["name"] = "core incoming routes";
        ["route"] = route;
    };
end;

return {
    ["internal"] = internal;
    ["incoming"] = incoming;
};