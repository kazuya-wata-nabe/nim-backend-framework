
discard """
  exitcode: 0
  output: "hoge"
"""

import std/unittest
include src/controller/user/update

let body = """{"name": 1}"""
let jsonNode = convertBodyToJson(body)

try:
  let form = to(jsonNode, UnValidateForm)
except:
  echo getCurrentExceptionMsg()


# echo (%* form)
# doAssert ==