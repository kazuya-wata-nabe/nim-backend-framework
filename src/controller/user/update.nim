import std/json
import std/strutils
import std/options

import src/controller/shared

type ValidForm = ref object
  name: string


func validate(form: JsonNode): Form[ValidForm] =
  var errors = newSeqOfCap[string](10)
  let name = form.getStr(key = "name")
  if name.isEmptyOrWhitespace:
    errors.add "name: required"

  if errors.len > 0:
    newInValidForm(ValidForm, errors)
  else:
    newValidForm(ValidForm(name: name))


proc updateUser*(body: string): tuple[status: int, value: string] =
  let form = validate(convertBodyToJson body)
  if form.valid.isSome:
    (204, "ok")
  elif form.invalid.isSome:
    (400, getErrors(form.invalid))
  else:
    (500, "system error")


when isMainModule:
  doAssert convertBodyToJson("""{"hoge": 1}""") == ( %* {"hoge": 1})
  doAssert convertBodyToJson("""{hoge: 1}""") == ( %* {})

  block:
    let form = validate( %* {"hoge": 1})
    doAssert form.invalid.isSome == true
    doAssert form.invalid.getErrors == "name: required"
    doAssert form.valid.isNone == true
