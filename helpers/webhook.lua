local inspect = require('inspect');
local http = require("socket.http");

local webhook = function (router)
    
    local request = function (url)
        b, c, h = http.request(url);
        app.noop('webhook: '..inspect(b));
        app.noop(inspect(c));
        app.noop(inspect(h));
    end;

    return {
        ['type'] = 'webhook';

        ['request'] = request;
    }
end;


return webhook;