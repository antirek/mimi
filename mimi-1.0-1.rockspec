package = "mimi"
version = "1.0-1"
build = {
    type = "builtin";

    modules = {
       mimi["router"] = "router.lua";
    }
}
source = {
    url = "git://github.com/antirek/mimi",
    tag = "v1.0",
}
dependencies = {
    -- "lua ~> 5.1"
}