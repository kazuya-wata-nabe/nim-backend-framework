import std/asynchttpserver
import std/asyncdispatch
import std/macros

import src/handler
import src/router

import src/controller/user/[create, fetch, update]

template userRoute*(req: untyped) =
  GROUP req, "/users":
    LIST:
      let users = fetchUsers()
      await req.json(Http200, users)
    CREATE:
      let (status, user) = createUser(req.body)
      await req.json(status, user)
    READ:
      let (status, user) = updateUser(req.body)
      await req.json(Http200, id)
    UPDATE:
      await req.json(Http200, id)
    DELETE:
      await req.json(Http200, id)
