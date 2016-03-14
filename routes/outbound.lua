local inspect = require('inspect');

local outbound = function ()
    local route = function (router, object)
        local dbPeer = router.getStore('peer');
        local dbOutbound = router.getStore('outbound');

        local vpbxId = dbPeer.getVpbxId(object.peername);
        local outgoingNumber = dbPeer.getOutgoingNumber(object.peername);

        if (outgoingNumber) then
            app.set('CALLERID(num)='..outgoingNumber);
            app.noop('internal vpbxId: '..inspect(vpbxId)..' outgoingNumber: '..outgoingNumber);

            local outTrunk = dbOutbound.getOutgoingTrunks({
                peername = object.peername;
                vpbxId = vpbxId
            });

            if (outTrunk) then
                app.dial('SIP/'..object.id..'@'..outTrunk.name);
            else 
                app.noop('no out trunk');
            end;
        else
            app.noop('no outgoing number');
        end;
        
        app.hangup();
    end;

    return {
        ["type"] = 'outbound';
        ["name"] = "outbound routes";
        ["route"] = route;
    };
end;

return outbound;