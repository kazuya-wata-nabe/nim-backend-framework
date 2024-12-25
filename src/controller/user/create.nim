import std/json
import std/options
import std/strutils

import src/domain/user/model
import src/controller/shared

type UnValidatedForm = ref object
  name: Option[string]
  email: Option[string]

type ValidForm = ref object
  name: string
  email: string


func validate(form: UnValidatedForm): tuple[valid: Option[ValidForm],
    invalid: Option[InValidForm]] =
  var errors = newSeqOfCap[string](10)
  if form.name.isEmptyOrWhitespace:
    errors.add "name: required"

  if errors.len > 0:
    newInValidForm(ValidForm, errors)
  else:
    newValidForm(ValidForm(name: name))


proc convertBodyToJson(body: string): JsonNode =
  try:
    parseJson body
  except:
    %* {}


proc createUser*(body: string): tuple[status: int, value: JsonNode] =
  let form = to(convertBodyToJson body, UnValidatedForm).validate
  if form.valid.isSome:
    let user = newUser(name = form.valid.get.name)
    (201, %* user)
  elif form.invalid.isSome:
    (400, %* form.invalid.getErrors())
  else:
    (500, %* "system error")



when isMainModule:
  doAssert convertBodyToJson("""{"hoge": 1}""") == ( %* {"hoge": 1})
  doAssert convertBodyToJson("""{hoge: 1}""") == ( %* {})

  block:
    let form = validate( %* {"hoge": 1})
    doAssert form.invalid.isSome == true
    doAssert form.invalid.getErrors == "name: required"
    doAssert form.valid.isNone == true

  block:
    let (status, value) = createUser("{\"name\": \"hoge\"}")
    doAssert status == 201
    doAssert value["name"].getStr() == "hoge"
