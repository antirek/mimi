
local inspect = require('inspect');

local queue = function ()

    local route = function (router, object)
        local db = router.getStore("queue");
        local queue = db.findQueueById(object.id, router.getVar('vpbxId'));
        
        if (queue) then
            app.noop('queue: '..queue.name);
            app.queue(queue.name);
        else 
            app.noop('no queue');
            app.hangup();
        end;
    end;

    return {
        ["name"] = "Queue route";  
        ["type"] = 'queue';
        ["route"] = route;
    };
end;

return queue;