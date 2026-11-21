# web

Routes HTTP requests to handlers on top of `network.serve`, with plugins, hooks, schema validation, and in-memory requests for tests.

```lus nocheck
local web = require("https://atmosp.here/2.0/web.lus")

local app = web.app()
app:get("/hello/:name", function(req)
    return { hello = req.params.name }
end)

print(app:inject({ path = "/hello/lus" }).body)   --> {"hello":"lus"}
```

The package requires Lus 2.0. It declares the permissions network:server and network:tcp, which only `app:listen` uses. It calls no `pledge` of its own, so the program that loads it keeps control of its permissions.

The reference is in the doc comments of `web.lus`. Run `lus doc web.lus` to print it.
