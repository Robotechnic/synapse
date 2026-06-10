#let notions = state(
  "notions", 
  ((:), ())
)

#let config = state(
  "config",
  (
    mode:"composition",
    intro-style: text.with(style: "italic", fill: rgb("#bd4702")),
    sy-style: text.with(weight: "bold", fill: rgb("#3b91d8"))
  )
)

/// Change the synapse configuration.
///
/// - mode ("paper", "electronic", "composition"): Change the synapse mode, which affects how notions are displayed. "paper" mode is optimized for print and will display notions in default document text colors (the color related styles will be ignored), "electronic" mode is optimized for screens and will display notions in color, and "composition" mode display everything like "electronic" mode but also highlight notions with a light red background if they are not introduced yet and display anchors with red markers. The default mode is "composition".
/// - intro-style (function): A text function with any style arguments you want. This style will be applied to notions when they are introduced with the intro() function. The default intro-style is italic with a reddish fill color. Note that in "paper" mode, the fill and stroke styles will be ignored and set to none
/// - sy-style (function): A text function with any style arguments you want. This style will be applied to notions when they are used as synonyms with the sy() function. The default sy-style is bold with a blueish fill color. Note that in "paper" mode, the fill and stroke styles will be ignored and set to none
/// -> none
#let synapse-config(mode: "composition", intro-style: none, sy-style: none) = context {
  config.update(old => {
    let intro-style = if intro-style != none { intro-style } else { old.intro-style }
    let sy-style = if sy-style != none { sy-style } else { old.sy-style }
    return (mode: mode, intro-style: intro-style, sy-style: sy-style)
  })
}


/// This function defines a notion, which is a concept that can be introduced and used as a synonym in the document. Each notion must have at least one synonym, which is the first positional argument. The notion can also have an optional URL and style. The URL makes the notion a link to an external resource, and the style allows you to customize how the notion is displayed when used as a synonym. 
///
/// - url (str, none): If provided, the notion will be a link to the provided URL. The default is none, which means the notion should have an internal definition in the document. If url is provided, the notion will not be able to be introduced with the intro() function.
/// - style (function, none): A text function with any style arguments you want. The default is none, which means the notion will have the global default text style. 
/// - synonyms: Any number of positional arguments can be provided as synonyms for the notion. Each synonym must be unique and cannot be used as a synonym for another notion.
/// -> none
#let notion(url: none, style: none, ..synonyms) = {
  if synonyms.named().len() > 0 {
    panic("Too many named arguments for notion: " + str(synonyms.named()))
  }
  if synonyms.pos().len() == 0 {
    panic("At least one synonym must be provided for a notion")
  }
  notions.update(old => {
    old.at(1).push((
      repr: synonyms.pos().at(0),
      url: url,
      style: style,
      defined: true
    ))
    for synonym in synonyms.pos() {
      if synonym in old.at(0) {
        panic("Synonym already exists: " + synonym)
      }
      old.at(0).insert(synonym, old.at(1).len() - 1)
    }
    return old
  })
}


#let get-styled-text(meta) = {
  let styled-text = if meta != none and meta.style != none {
    meta.style
  } else {
    config.get().intro-style
  }
  if config.get().mode == "paper" {
    return styled-text.with(fill: text.fill, stroke: none)
  } else {
    return styled-text
  }
}

#let str-intro(notion) = context {
  if notion not in notions.get().at(0) {
    // TODO: manage undefined notions correctly
    panic("Notion " + notion + " not found: " + repr(notions.get()))
  }

  let meta = notions.get().at(1).at(notions.get().at(0).at(notion))
  if meta.url != none {
    panic("Notion " + notion + " has a URL: " + meta.url + ", so it cannot be introduced")
  }

  let styled-text = get-styled-text(meta)

  [
    #styled-text(notion)
    #label(meta.repr)
  ]
}

#let str-sy(notion) = context {
  if notion not in notions.get().at(0) {
    let styled-text = get-styled-text(none)
    if config.get().mode == "composition" {
      return highlight(styled-text(notion), fill: rgb("#ff7171"))
    } else {
      return styled-text(notion)
    }
  }

  let meta = notions.get().at(1).at(notions.get().at(0).at(notion))
  let styled-text = get-styled-text(meta)

  if meta.url != none {
    link(meta.url, styled-text(notion))
  } else {
    link(label(meta.repr), styled-text(notion))
  }
}

/// This function is used to introduce a notion for the first time in the document. It takes a notion as an argument, which can be either a string or a content. If the notion is a string, it will be introduced as is. The introduced notion will be displayed with the intro-style defined in the synapse configuration.
///
/// - notion (str, content): The text notion to introduce. The notion can be either a string or a content. If the notion is a string, it will be introduced as is. If the notion is a content, it must be a text content with the notion wrapped in pairs of double quotes (e.g. ""notion"").
/// -> content
#let intro(notion) = {
  if type(notion) == str {
    return str-intro(notion)
  } else if type(notion) == content {
    if notion.func() == text {
      notion = notion.text
      return str-intro(notion.slice(2, -2))
    } else {
      panic("Unsupported content type for intro: " + notion.type)
    }
  } else {
    panic("Unsupported type for intro: " + type(notion))
  }
}

/// This function is used to use a notion as a synonym in the document. It takes a notion as an argument. If the notion has been introduced before with the intro() function, it will link to the introduced notion. If the notion is not defined, it will be displayed with a highlight and a reddish fill to indicate that it is an undefined notion if in compose mode.
///
/// - notion (str, content): The text notion to use as a synonym. The notion can be either a string or a content. If the notion is a string, it will be used as is. If the notion is a content, it must be a text content with the notion wrapped in double quotes (e.g. "notion").
/// -> content
#let sy(notion) = {
  if type(notion) == str {
    return str-sy(notion)
  } else if type(notion) == content {
    if notion.func() == text {
      notion = notion.text
      return str-sy(notion.slice(1, -1))
    } else {
      panic("Unsupported content type for sy: " + notion.type)
    }
  } else {
    panic("Unsupported type for sy: " + type(notion))
  }
}


/// Show rule to replace "<notion>" with sy(notion) and ""<notion>"" with intro(notion)
#let quote-rule(el) = {
  show regex("\"\"[^\"]+\"\""): it => intro(it)
  show regex("\"[^\"]+\""): it => sy(it)
  el
}
