/// Apply the syn-style to a notion without any label or link
#let _styled-intro(notion, body) = (
  context {
    if notion not in notions.get().at(0) {
      panic("Notion " + notion + " not found: " + repr(
        notions.get().at(0).keys(),
      ))
    }
    let meta = notions.get().at(1).at(notions.get().at(0).at(notion))
    let styled-text = get-styled-text(meta, "intro-style")
    get-notion-display(meta, "intro-style", notion, body)
  }
)

/// Apply the given notion label to the body without any style or link
#let _labeled-intro(notion, body) = (
  context {
    if notion not in notions.get().at(0) {
      panic("Notion " + notion + " not found: " + repr(
        notions.get().at(0).keys(),
      ))
    }
    let meta = notions.get().at(1).at(notions.get().at(0).at(notion))
    if meta.url != none {
      panic("Notion " + notion + " has a URL: " + meta.url + ", so it cannot be labeled")
    }
    if meta.introduced == true {
      panic("Notion " + notion + " has already been introduced, so it cannot be labeled")
    }
    notions.update(old => {
      old.at(1).at(old.at(0).at(notion)).introduced = true
      return old
    })
    if meta.anchored == true {
      body // don't add a label if the notion is anchored, because the label will be on the anchor point instead of the notion itself
    } else {
      [
        #intro-marker(notion)
        #body
        #notion-label(meta)
      ]
    }
  }
)

#let str-intro(notion, body) = {
  _labeled-intro(notion, _styled-intro(notion, body))
}