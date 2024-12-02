import norm/model
import ../../db/db
import ../../domain/user/model

type User = ref object of Model
  name*: string
  email*: string

proc fetchUserList*(db: Db): seq[Row] =
  let rows = db.selectAll("users")
  rows
