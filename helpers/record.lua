
local record = function (router, config)

    local isEnabled = function ()
        local record = router.getVar('record');
        
        if (record) then
            return record['enabled'];
        else 
            return false;
        end;
    end;

    local enableRecord = function ()
        local date = os.date("*t");
        local basePath = config.recordspath;
        
        local uniqueid = channel.UNIQUEID:get();
        local fname = string.format("%s_%s-%s-%s_%s:%s:%s", uniqueid, 
            date.year, date.month, date.day, date.hour, date.min, date.sec);
        local WAV = "/wav/";
        local MP3 = string.format("/mp3/%s-%s-%s/", date.year, date.month, date.day);

        local recordCommand = "/usr/bin/nice -n 19 mkdir -p %s && /usr/bin/lame -b 16 --silent %s%s.wav %s%s.mp3";
        local options = string.format(recordCommand, basePath..MP3, basePath..WAV, fname, basePath..MP3, fname);

        app.mixmonitor(string.format("%s%s.wav,b,%s", basePath..WAV, fname, options));
        local filename = string.format("%s%s.mp3", MP3, fname);
        channel["CDR(record)"]:set(filename);

        router.setVar('record', {enabled = true; filename = filename});
    end;

    local clear = function ()
        router.removeVar('record');
        channel["CDR(record)"]:set("");
    end;

    local enable = function ()
        if (isEnabled()) then
            app.noop('record is enabled already');
        else 
            enableRecord();
        end;
    end;

    return {
        ["type"] = 'record';
        
        ["enable"] = enable;
        ["isEnabled"] = isEnabled;
        ["clear"] = clear;
    };
end;

return record;