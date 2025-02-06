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
