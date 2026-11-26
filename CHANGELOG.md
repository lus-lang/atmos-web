# Changelog

## 1.0.0

**Release date:** 2026-11-22

Version 1.0.0 is the first release of `web`.

- Added the `web` package.
  - `web.app`: Creates an application that routes the requests of `network.serve` to handlers.
  - `web.raise`: Raises an error object that the application answers with its status and a JSON body.
  - `web.ishttperror`: Returns `true` for an error object that `web.raise` raised.
  - `web.decode_query`: Decodes a query string into a table.
  - `scope:route`: Adds a route for one method, a list of methods, or every method, with optional schemas and hooks.
  - `scope:hook`: Adds a hook to a scope and the scopes registered from it.
  - `scope:register`: Registers a plugin in a child scope or, for a shared plugin, in the scope itself.
  - `scope:decorate`: Adds a named value that handlers read as `req.app.NAME`.
  - `scope:decorate_reply`: Adds a method to the reply object of every handler.
  - `scope:not_found`: Sets the handler for requests that match no route.
  - `scope:handler`: Returns the request handler of the application for `network.serve`.
  - `scope:listen`: Serves the application with `network.serve`.
  - `scope:inject`: Answers a request in memory, without a socket.
