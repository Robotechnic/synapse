#let notions = state(
  "notions", 
  ((:), ())
)


#let notion(url: none, style: none, ..synonyms) = {
  if synonyms.named().len() > 0 {
    panic("Too many named arguments for notion: " + str(synonyms.named()))
  }
  notions.update(old => {
    old.at(1).push((
      repr: synonyms.pos().at(0),
      url: url,
      style: style
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


#let str-intro(notion) = context {
  if notion not in notions.get().at(0) {
    // TODO: manage undefined notions correctly
    panic("Notion " + notion + " not found: " + repr(notions.get()))
  }

  let meta = notions.get().at(1).at(notions.get().at(0).at(notion))
  
  [
    #text(weight: "light", fill: red, notion)
    #label(meta.repr)
  ]
}

#let str-sy(notion) = context {
  if notion not in notions.get().at(0) {
    return text(weight: "bold", notion)
  }

  let meta = notions.get().at(1).at(notions.get().at(0).at(notion))
  if meta.url != none {
    return link(meta.url, text(weight: "bold", notion))
  } else {
    return link(label(meta.repr), text(weight: "bold", notion))
  }
}

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
