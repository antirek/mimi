local inspect = require('inspect');

local group = function ()

    local route = function (router, object)
    
        local peergroupid = object['id'];
        local dbPeergroup = router.getStore('peergroup');

        local peergroup = dbPeergroup.findPeergroupById(peergroupid, router.getVar('vpbxId'));
        local dialstr = '';

        app.set('__VPBXID='..router.getVar('vpbxId'));

        if (peergroup.elements) then
            local i, append;

            for i = 1, #peergroup.elements do
                append = (i == 1) and '' or '&';
                dialstr = dialstr .. append .. 'Local/'..peergroupid..'.'..i..'@peergroupitem';
            end;
            
            app.noop('dial:'..inspect(dialstr));
            app.dial(dialstr);
        end;

    end;

    return {
        ["name"] = "Peer group route";
        ["type"] = 'peergroup';
        ["route"] = route;
    };
end;

local groupitem = function ()

    local route = function (router, object)

        local peergroupid, itemid = object["id"]:match("([^.]+).([^.]+)");
        local vpbxId = channel["VPBXID"]:get();

        local dbGroup = router.getStore('peergroup');
        local peergroup = dbGroup.findPeergroupById(peergroupid, vpbxId);

        local item = peergroup['elements'][tonumber(itemid)];

        if (item) then 
            app.noop('item'..inspect(item));
            app.wait(item.wait);
            app.dial(item.objectId, item.duration);
        end;
    
    end;

    return {
        ["name"] = "Peer group item route";
        ["type"] = 'peergroupitem';
        ["route"] = route;
    };
end;

return {
    group = group;
    groupitem = groupitem;
}