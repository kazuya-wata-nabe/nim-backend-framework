import std/json
import std/strutils
import std/options

import src/controller/shared
import src/validation/[validator, rules]

type UnValidateForm = ref object
  name{.required.}: Option[string]
  age{.required.}: Option[int]

type ValidateForm = ref object
  name: string
  age: string

type ValidForm = ref object

generateValidator(UnValidateForm)

func validate(node: JsonNode): ValidateForm =
  let form = to(node, UnValidateForm)
  let errors = form.validate()


proc updateUser*(body: string): tuple[status: int, value: string] =
  (204, "ok")
  # let form = validate(convertBodyToJson body)
  # if form.valid.isSome:
  #   (204, "ok")
  # elif form.invalid.isSome:
  #   (400, getErrors(form.invalid))
  # else:
  #   (500, "system error")
