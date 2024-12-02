import macros
import std/sysrand
import std/strutils
import std/sequtils


macro `|>`*(lhs, rhs: untyped): untyped =
  case rhs.kind:
  of nnkIdent:
    result = newCall(rhs, lhs)
  else:
    result = rhs
    result.insert(1, lhs)

type
  BranchPair[T] = object
    then, otherwise: T

func `!`*[T](a, b: T): BranchPair[T] {.inline.} = BranchPair[T](then: a, otherwise: b)

template `?`*[T](cond: bool; p: BranchPair[T]): T =
  (if cond: p.then else: p.otherwise)
