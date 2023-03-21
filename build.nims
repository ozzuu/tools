#!/usr/bin/env -S nim --hints:off
from std/os import walkDirRec, commandLineParams
from std/strformat import fmt

let
  params = commandLineParams()
  release = if "release" in params: "-d:release " else: ""

for f in walkDirRec ".":
  if f[^4..^1] == ".nim":
    echo fmt"Building '{f}'"
    exec fmt"nim js {release}{f}"
