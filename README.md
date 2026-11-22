# web

`web` routes HTTP requests to handlers for `network.serve`. It supports plugins, hooks, schema validation, and in-memory requests for tests.

The following example serves the posts of a blog by their slug and answers an unknown slug with status 404. The last line sends it a request in memory, as a test does.

```lus nocheck
local web = require("https://atmosp.here/2.0/web.lus")

local posts = { welcome = "Welcome to the blog" }

local app = web.app()
app:get("/posts/:slug", function(req)
    local title = posts[req.params.slug]
    if title == nil then
        web.raise(404, "no such post")
    end
    return { title = title }
end)

print(app:inject({ path = "/posts/welcome" }).body)   --> {"title":"Welcome to the blog"}
```

The package requires Lus 2.0 and declares the permissions `network:server` and `network:tcp`, which only `app:listen` uses. It never calls `pledge`, so the program that loads it keeps control of its permissions.

The reference is in the doc comments of `web.lus`, which `lus doc web.lus` prints.
