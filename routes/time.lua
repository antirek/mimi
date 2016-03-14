local inspect = require('inspect');

local timeweek = function ()

    local weekday = {[1]='sun',[2]='mon',[3]='tue',[4]='wed',[5]='thu',[6]='fri',[7]='sun'};

    local route = function (router, object)

        local db = router.getStore('time');
        assert(db.findTimeweekById, 'no db.findTimeweekById');

        assert(object.id, 'no object.id');

        local today = os.date("*t");
        app.noop('day: '..weekday[today["wday"]]);

        local timeweek = db.findTimeweekById(object.id, router.getVar('vpbxId'));

        if (timeweek) then
            assert(timeweek[weekday[today["wday"]]], 'no day index');
            app.noop('timeweek:'..inspect(timeweek[weekday[today["wday"]]]));

            local r = timeweek[weekday[today["wday"]]];
            router:route({type = r.objectType, id = r.objectId});
        else 
            app.noop('no timeweek');
            app.hangup();
        end;
    end;

    return {
        ["name"] = 'Time week route';
        ["type"] = 'timeweek';
        ["route"] = route;
    };
end;

local timeday = function ()

    local route = function (router, object)
        local db = router.getStore('time');
        assert(db.findTimedayById, 'no db.findTimedayById');
        assert(object.id, 'no object.id');

        local now = os.date("*t");
        app.noop('time: '..now["hour"]..':'..now["min"]..':'..now["sec"]);
        local timeday = db.findTimedayById(object.id, router.getVar('vpbxId'));
        
        if (timeday) then
            assert(timeday.periods, 'no periods in timeday');

            local find, key;
            for i = 1, #timeday.periods do

                local bhour, bmin = timeday.periods[i]['begin']:match("([^:]+):([^:]+)");
                local ehour, emin = timeday.periods[i]['end']:match("([^:]+):([^:]+)");

                local bt = os.date("*t");
                local et = os.date("*t");

                bt["hour"] = tonumber(bhour);  bt["min"] = tonumber(bmin); bt["sec"] = 0;
                et["hour"] = tonumber(ehour);  et["min"] = tonumber(emin); et["sec"] = 59;
                
                if ( ( os.time(bt) < os.time(now) ) and ( os.time(et) > os.time(now) ) ) then
                    find = true; key = i;
                    break;
                end;
            end;

            if (find and timeday.periods[key]) then
                local r = timeday.periods[key];
                router:route({type = r.objectType, id = r.objectId})
            else
                app.noop('no route');
            end;
        else 
            app.noop('no timeday');
            app.hangup();
        end;
    end;

    return {
        ["name"] = 'Time day route';
        ["type"] = 'timeday';
        ["route"] = route;
    };
end;

return {
    ["timeweek"] = timeweek;
    ["timeday"] = timeday;
};