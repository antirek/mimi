
local sayunixtime = function ()

    local route = function (router, object)
        app.set("CHANNEL(language)=en");
        app.sayunixtime("", "","kMdbY");
        app.hangup();
    end;

    return {
        ["name"] = "Say unixtime";
        ["type"] = 'sayunixtime';
        ["route"] = route;
    };
end;

return sayunixtime;