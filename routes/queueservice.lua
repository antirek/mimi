
local inspect = require('inspect');

local queue = function ()
    
    local routes = {
        ["1"] = {
            route = function (router, object)
                app.read('OPERATORPIN', 'beep', 2);

                local pin = channel['OPERATORPIN']:get();
                app.noop('pin: '..pin);

                local peername = channel.CHANNEL("peername"):get();

                if (peername) then
                    app.addqueuemember('300', 'SIP/'..peername);
                end;
            end;
        };

        ["0"] = {
            route = function (router, object)
                app.noop('in removequeuemember:' .. inspect(object));
                local peername = channel.CHANNEL("peername"):get();
                
                if (peername) then
                    app.removequeuemember('300', 'SIP/'..peername);
                end;
            end;
        };
    };

    function route (router, object)
        app.read('CHOICE', 'beep', 1);
        local choice = channel['CHOICE']:get();
        app.noop('choice: '..choice);

        if (routes[choice]) then
            routes[choice].route(router, object);
        else 
            app.noop('no route for choice: '..choice);
            app.hangup();
        end;
    end;

    return {
        ["name"] = "Queue service route";  
        ["type"] = 'queueservice';
        ["route"] = route;
    };
end;

return queue;