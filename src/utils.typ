#let _notion-label(meta) = (label(meta.repr))

#let _intro-marker(repr) = {
  let mode = config.get().mode
  if mode == "composition" {
    box(
      place(
        highlight(
          text(
            repr,
            size: .7em,
          ),
          fill: rgb("#ff7171"),
          extent: .5pt,
          radius: .1em,
        ) + line(angle: -90deg, length: 1.5em, stroke: rgb("#ff7171")),
        dy: -1.5em,
        dx: -.5pt,
        clearance: 0pt,
      ),
      width: 0pt,
    )
    h(0pt, weak: true)
  }
}

#let _get-styled-text(meta, style) = {
  let styled-text = if meta != none and meta.style != none {
    meta.style
  } else {
    config.get().at(style)
  }
  if config.get().mode == "paper" {
    return styled-text.with(fill: text.fill, stroke: none)
  } else {
    return styled-text
  }
}

#let _get-notion-display(meta, style, notion, body) = {
  let notion-string = if body != none {
    body
  } else if "%" in notion {
    notion.split("%").at(0)
  } else {
    notion
  }
  _get-styled-text(meta, style)(notion-string)
}