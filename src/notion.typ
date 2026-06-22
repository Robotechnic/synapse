#let _notions = state(
  "notions",
  ((:), ()),
)

#let _notion-wrapper-arg-name = "notion-wrapper-fun"

#let _new-notion(repr, url, style) = (
  repr: repr,
  url: url,
  style: style,
  introduced: false,
  anchored: false,
)