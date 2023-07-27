from std/uri import decodeUrl
from std/dom import window
from std/random import randomize

import pkg/docid
include pkg/karax/prelude

randomize()

var
  generatedCpf = genCpf()
  generatedCnpj = genCnpj()
var
  cpfIsValid = false
  cnpjIsValid = false

proc createDom(data: RouterData): VNode =
  let hashVal =
    if data.hashPart.len > 1:
      decodeUrl(($data.hashPart)[1..^1])
    else:
      ""
  if hashVal.len > 0:
    cpfIsValid = validCpf hashVal
  result = buildHtml(main):
    article:
      h1: text "CPF"
      section:
        span(name = "Generation"):
          input(class = "input", value = generatedCpf, readonly = "true")
          button(class = "button"):
            text "New"
            proc onClick(ev: Event; n: VNode) =
              generatedCpf = genCpf()

      section:
        span(name = "Validation"):
          input(class = "input", placeholder = "CPF", value = hashVal):
            proc onInput(ev: Event; n: VNode) =
              cpfIsValid = validCpf $n.value
              window.location.hash = n.value
              redraw()
          tdiv(class = "validator " & (if cpfIsValid: "valid" else: "invalid")):
            text if cpfIsValid: "Valid" else: "Invalid"
    article:
      h1: text "CNPJ"
      section:
        span(name = "Generation"):
          input(class = "input", value = generatedCnpj, readonly = "true")
          button(class = "button"):
            text "New"
            proc onClick(ev: Event; n: VNode) =
              generatedCnpj = genCnpj()

      section:
        span(name = "Validation"):
          input(class = "input", placeholder = "CNPJ", value = hashVal):
            proc onInput(ev: Event; n: VNode) =
              cnpjIsValid = validCnpj $n.value
              window.location.hash = n.value
              redraw()
          tdiv(class = "validator " & (if cnpjIsValid: "valid" else: "invalid")):
            text if cnpjIsValid: "Valid" else: "Invalid"
   
setRenderer createDom
