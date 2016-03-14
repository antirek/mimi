local inspect = require('inspect');

local ivr = function ()
    
    local route = function (router, object)

        local dbIVR = router.getStore("ivr");
        local dbSound = router.getStore("sound");
        
        assert(dbIVR.findIVRById, 'no required method in db object')
        assert(object.id, "no object.id in "..inspect(object));
        
        app.noop('object'..inspect(object));
        app.noop('ivr menu vpbxId:' .. router.getVar("vpbxId"));

        local menu = dbIVR.findIVRById(object.id, router.getVar('vpbxId'));

        if (menu and menu.soundId) then

            assert(menu.soundId, 'no menu.soundId in '..inspect(menu));
            local sound = dbSound.findSoundById(menu.soundId, router.getVar('vpbxId'));

            app.noop('menu: '..inspect(menu));
            app.noop('sound: '..inspect(sound));

            if (sound) then
                app.noop('sound: '..inspect(sound));
                app.answer();

                local opts = {
                    filename = '/var/share/sounds/1/'..menu.soundId;
                    maxdigits = menu.maxdigits or 1;
                    options = nil;
                    attempts = menu.attempts or 1;
                    timeout = menu.timeout or 3;
                };


                app.read('CHOICE', opts.filename, opts.maxdigits, opts.options, opts.attempts, opts.timeout);

                local choice = channel['CHOICE']:get();
                app.noop('choice: ' .. choice);

                if (choice and choice ~= '') then
                    local i = 1;
                    while menu.choices[i] do
                        --app.noop(menu.choices[i].key)
                        if (menu.choices[i].key == choice) then 
                            break
                        end;
                        i = i + 1
                    end;

                    app.noop('action i: '..i);
                    app.noop('action: '..inspect(menu.choices[i]));
                    local r = menu.choices[i];

                    router:route({type = r.objectType, id = r.objectId});
                else 
                    app.noop('no input');
                    router:route(object);
                end;

            else 
                app.noop('no sound with id: '..menu.soundId);
            end;

        else 
            app.noop('no menu with id: '..object.id);
        end;
    end;

    return {
        ["name"] = "IVR route";  
        ["type"] = 'ivr';
        ["route"] = route;
    };
end;

return ivr;