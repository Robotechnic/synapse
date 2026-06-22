#import "@preview/mantys:1.0.2": *
#import "../lib.typ" as synapse

#show: mantys(
  ..toml("../typst.toml"),
  examples-scope: (
    scope: (
      synapse: synapse,
    ),
    imports: (
      synapse: "*",
    ),
  ),
)

#tidy-module(
  "synapse",
  read("../lib.typ"),
  sort-functions: none,
  legacy-parser: true,
)
