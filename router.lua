
local inspect = require('inspect');

local Router = function (options)
    local opts = options or {};
    local routes = {};
    local vars = {};
    local history = {};
    local stores = {};
    local helpers = {};
    local routeCounter = 1

    local addRoute = function (route)
        assert(route, 'no route');
        assert(route.type, 'no route.type');
        assert(route.name, 'no route.name');
        assert(route.route, 'no route.route function')
        assert(type(route.route) == 'function', 'route.route is not function');
        
        routes[route.type] = route;
    end;

    local addHelper = function (helper)
        assert(helper, 'no helper');
        assert(helper.type, 'no helper type');

        helpers[helper.type] = helper;
    end;

    local getHelper = function (type)
        assert(type, 'no type');

        return helpers[type];
    end;

    local addStore = function (storeIn)
        assert(storeIn, 'no store');
        assert(storeIn.type, 'no store.type');

        stores[storeIn.type] = storeIn;
    end;

    local getStore = function (type)
        assert(type, 'no type');
        assert(stores[type], 'no store with type = '..type);

        return stores[type];
    end;

    local setVar = function (name, value)
        assert(name, 'no var name');
        assert(value, 'no var value');

        vars[name] = value;
    end;

    local getVar = function (name)
        assert(name, 'no var name');

        return vars[name];
    end;

    local removeVar = function (name)
        assert(name, 'no name');
        
        vars[name] = nil;
    end;

    local getHistory = function ()
        return history;
    end;

    local route = function (self, object)
        assert(object.type, 'no object.type in '..tostring(object));
        assert(routes[object.type], 'no route with type '..tostring(object.type));
        assert(routes[object.type].route, 'no route in '..tostring(routes[object.type]))
        assert(type(routes[object.type].route) == 'function', 'route is not function');

        table.insert(history, {
            object = object;
            --    datetime = os.date("*t");   -- уже распарсено в таблицу будет, удобно для обработки
            datetime = os.date();
        });

        routeCounter = routeCounter + 1;
        if (routeCounter < 50) then   -- limit for iteration route  -- уточнить величину
            routes[object.type].route(self, object);
        end;
    end;

    return {
        ["getHistory"] = getHistory;
        
        ["addRoute"] = addRoute;
        ["route"] = route;

        ["setVar"] = setVar;
        ["getVar"] = getVar;
        ["removeVar"] = removeVar;

        ["addStore"] = addStore;
        ["getStore"] = getStore;

        ["addHelper"] = addHelper;
        ["getHelper"] = getHelper;
    };
end;

return Router;