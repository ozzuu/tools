from std/json import pretty
from std/jsonutils import toJson
from std/uri import decodeUrl
from std/strformat import fmt
from std/dom import window
from pkg/bibleTools import parseBibleVerse, BibleVerse, initBibleVerse,
                            inOzzuuBible, identifyBibleBook, en, pt,
                            ALEnglish, ALPortuguese, UnknownBook
include pkg/karax/prelude

var parsedVerse: BibleVerse
proc createDom(data: RouterData): VNode =
  let hashVal =
    if data.hashPart.len > 1:
      cstring decodeUrl(($data.hashPart)[1..^1])
    else:
      ""
  if hashVal.len > 0:
    parsedVerse = parseBibleVerse($hashVal)
  result = buildHtml(main):
    h1: text "Parse verse"
    section:
      span(name = "Verse text"):
        input(class = "input", placeholder = "Gen 1:1", value = hashVal):
          proc oninput(ev: Event; n: VNode) =
            parsedVerse = parseBibleVerse($n.value)
            window.location.hash = n.value
    section:
      if parsedVerse == initBibleVerse() or parsedVerse.book.book == UnknownBook:
        if hashVal.len > 0:
          h2: text "Invalid verse"
      else:
        h2: text "Output"
        pre(class = "output", readonly = "true", name = "Ozzuu Bible URL"):
          let url = parsedVerse.inOzzuuBible
          a(href = url, target = "_blank", rel = "noopener noreferrer"):
            text url
        pre(class = "output", readonly = "true", name = "Detected Language"):
          text ($parsedVerse.book.lang)[2..^1]
        pre(class = "output", readonly = "true", name = "Parsed verse"):
          ul:
            ol:
              bold: text "Clean: "
              text bibleTools.`$`(parsedVerse)
          ul:
            small: text "With hebrew transliteration"
            ul:
              small: text "English"
              ol:
                bold: text "Short: "
                text bibleTools.`$`(
                  parsedVerse,
                  hebrewTransliteration = true,
                  shortBook = true,
                  forceLang = ALEnglish
                )
              ol:
                bold: text "Full: "
                text bibleTools.`$`(
                  parsedVerse,
                  hebrewTransliteration = true,
                  shortBook = false,
                  forceLang = ALEnglish
                )
            ul:
              small: text "Portuguese"
              ol:
                bold: text "Short: "
                text bibleTools.`$`(
                  parsedVerse,
                  hebrewTransliteration = true,
                  shortBook = true,
                  forceLang = ALPortuguese
                )
              ol:
                bold: text "Full: "
                text bibleTools.`$`(
                  parsedVerse,
                  hebrewTransliteration = true,
                  shortBook = false,
                  forceLang = ALPortuguese
                )
        pre(class = "output", readonly = "true", name = "Book name"):
          let book = parsedVerse.book.book
          ul:
            ol:
              bold: text "Enum: "
              text $book
            ol:
              bold: text "English: "
              text book.en
            ol:
              bold: text "Portuguese: "
              text book.pt
        pre(class = "output", readonly = "true", name = "Parsed JSON"):
          text pretty toJson parsedVerse

setRenderer createDom
