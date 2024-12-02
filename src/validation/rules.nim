import std/strformat

type ValidationRule* = ref object

template required*() {.pragma.}
func required*(field: string): bool =
  field.len > 0
func required*(field: int): bool =
  field > 0
func required*(_: type ValidationRule, field: string): string =
  &"{field} is required"


template lessThan*(v: int) {.pragma.}
func lessThan*(field: int, v: int): bool =
  field < v
func lessThan*(_: type ValidationRule, field: string, v: int): string =
  &"{field} must be less than {v}"

template between*(a, b: int) {.pragma.}
func between*(field: int, a, b: int): bool =
  field > a and field < b
func between*(_: type ValidationRule, field: string, a, b: int): string =
  &"{field} must be between {a} and {b}"
