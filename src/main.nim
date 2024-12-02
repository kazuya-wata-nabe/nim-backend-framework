import std/json
import std/streams
import std/strutils
import std/sequtils


func toMarkdownTable(items: openArray[string]): string =
  result.add "|"
  result.add items.join("|")
  result.add "|"

proc main(input: string, output: string = "") =
  let
    s = newFileStream(input)
    node = parseJson(s)
    file = if output == "": stdout else: open(output, fmWrite)
  defer:
    s.close()
    file.close()


  let content = node["画面仕様"]
  if content.kind != JsonNodeKind.JArray:
    echo "error"
    return

  file.writeLine("# SAMPLE")
  file.writeLine("## 画面仕様")

  file.writeLine toMarkdownTable(["No", "項目", "I/O"])
  file.writeLine toMarkdownTable(["---"].cycle(3))
  for lines in content:
    let values = model.parse(lines)
    file.write toMarkdownTable(values)
    file.writeLine ""



when isMainModule:
  let filename = "schema/index.json"
  main(filename)
