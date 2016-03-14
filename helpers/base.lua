local inspect = require('inspect');

local base = function (router)
    
    -- return S103 from string like 'SIP/S103-000012'

    local channel2peer = function (channel)
        local one = channel:match("([^-]+)-([^-]+)");
        local two, three = one:match("([^/]+)/([^/]+)");
        return three;
    end;

    return {
        ['type'] = 'base';

        ['channel2peer'] = channel2peer;
    }
end;


return base;