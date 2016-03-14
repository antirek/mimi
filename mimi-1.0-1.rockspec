package = "mimi"
version = "1.0-1"
build = {
    type = "builtin";

    modules = {
       ["mimi.router"] = "router.lua";

       --routes
       ["mimi.routes.core"] = "routes/core.lua";
       ["mimi.routes.peer"] = "routes/peer.lua";
       ["mimi.routes.ivr"]  = "routes/ivr.lua";
       ["mimi.routes.peergroup"] = "routes/peergroup.lua";
       ["mimi.routes.queue"] = "routes/queue.lua";
       ["mimi.routes.queueservice"] = "routes/queueservice.lua";
       ["mimi.routes.services"] = "routes/services.lua";
       ["mimi.routes.time"] = "routes/time.lua";
       ["mimi.routes.outbound"] = "routes/outbound.lua";

       --db
       ["mimi.db.MongoDBConnection"] = "db/MongoDBConnection.lua";

       --mongo stores
       ["mimi.db.mongo.core"] = "db/mongo/core.lua";
       ["mimi.db.mongo.peer"] = "db/mongo/peer.lua";
       ["mimi.db.mongo.ivr"]  = "db/mongo/ivr.lua";
       ["mimi.db.mongo.peergroup"] = "db/mongo/peergroup.lua";
       ["mimi.db.mongo.queue"] = "db/mongo/queue.lua";
       ["mimi.db.mongo.queueservice"] = "db/mongo/queueservice.lua";
       ["mimi.db.mongo.time"] = "db/mongo/time.lua";
       ["mimi.db.mongo.outbound"] = "db/mongo/outbound.lua";

       --helpers
       ["mimi.helpers.base"] = "helpers/base.lua";
       ["mimi.helpers.record"] = "helpers/record.lua";
       ["mimi.helpers.webhook"] = "helpers/webhook.lua";
    }
}
source = {
    url = "git://github.com/antirek/mimi",
    tag = "v1.0",
}
dependencies = {
    -- "lua ~> 5.1"
}