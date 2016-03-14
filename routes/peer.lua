local inspect = require('inspect');

local peer = function ()
    
    local route = function (router, object)
        
        --перенести в base helper? 
        local f = function ( _channel, _router)
            local _callerPeername, _source, _transferername;
  
            if _channel.CHANNEL("peername"):get() then
                _callerPeername = _channel.CHANNEL("peername"):get();
                _source = 'channel.CHANNEL("peername"):get()';
            elseif _channel["TRANSFERERNAME"]:get() then
                _transferername = _channel["TRANSFERERNAME"]:get();
                _callerPeername = _router.getHelper('base').channel2peer(_transferername);
                _source = 'channel["TRANSFERERNAME"]:get()';
            end;

            return _callerPeername, _source;
        end;
        

        local callerPeername, source = f(channel, router);

        local db = router.getStore("peer");

        app.noop('vpbxId: '..router.getVar('vpbxId'));
        app.noop('callerPeername: '..callerPeername..' source: '..source);

        local calleePeer = db.findPeerById(object.id, router.getVar('vpbxId'));
        app.noop('object'..inspect(object));
        app.noop('callee'..inspect(calleePeer));


        local callerPeer = db.findPeerByPeername(callerPeername, router.getVar('vpbxId'));


        -- check record - вынести в отдельную функцию?
        if (calleePeer and calleePeer.record and calleePeer.record == 'yes') then
            app.noop('required record calee');
            router.getHelper('record').enable();
        elseif (callerPeer and callerPeer.record and callerPeer.record == 'yes') then
            app.noop('required record caller');
            router.getHelper('record').enable();
        end;



        if (calleePeer and calleePeer.peername) then
            local timeout = calleePeer.timeout and tonumber(calleePeer.timeout) or 20;
            app.progress();


            --app.dial('SIP/'..peer.peername,timeout,'M(dial^start)');
            --app.retrydial('beep', 5, 5, 'SIP/'..calleePeer.peername, timeout);
            app.dial('SIP/'..calleePeer.peername, timeout, 'tT');

            local dialstatus = channel["DIALSTATUS"]:get();
            app.noop('dialstatus: '..dialstatus);
            app.set("CHANNEL(language)=ru");


            -- перенести в роутер?
            local playSorry = function ()
                app.playback("followme/sorry", "noanswer");
                router.getHelper('record').clear();
            end;

            if (calleePeer.fwd and calleePeer.fwd[dialstatus]) then
                local r = calleePeer.fwd[dialstatus];
                router:route({type = r.objectType, id = r.objectId});
            else 
                playSorry();
            end;
        else 
            app.hangup();
        end;       
    end;

    return {
        ["name"] = "Peer route";
        ["type"] = 'peer';
        ["route"] = route;
    };
end;

return peer;