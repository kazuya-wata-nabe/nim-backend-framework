import std/json
import std/options

import src/controller/shared
import src/validation/[validator, rules]

type UnValidateForm = ref object
    name{.required.}: Option[string]
    age{.required.}: Option[int]

type ValidateForm = ref object
    name: string
    age: string

type ResultKind = enum
    kOk, kErr

type ValidationResult = ref object
    case kind: ResultKind
    of kOk:
        form: ValidateForm
    of kErr:
        errors: seq[string]


generateValidator(UnValidateForm)

func validate(node: JsonNode): ValidationResult =
    let value = to(node, UnValidateForm)
    let errors = value.validate()
    if errors.len > 0:
        ValidationResult(kind: kErr, errors: errors)
    else:
        let form = ValidateForm(name: value.name.get, age: $value.age.get)
        ValidationResult(kind: kOk, form: form)


proc createUser*(body: string): tuple[status: int, value: JsonNode] =
    let form = validate(convertBodyToJson body)
    if form.kind == kOk:
        (204, %* form.form)
    else:
        (400, %* form.errors)
