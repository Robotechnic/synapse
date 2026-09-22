// #import "synapse/lib.typ": *
import "./lib.typ": *

#synapse-config(mode: "electronic")

// 1. Forward reference — MUST link.
#notion("forward")
\#syn before \#intro: must link - #syn("forward").
#intro("forward")

// 2. Backward reference — MUST link.
#notion("backward")
#intro("backward")
\#syn after \#intro: must link; fixed - #syn("backward").

// 3. Missing introduction — MUST NOT link.
// In composition mode it should be orange.
#notion("missing")
\#syn without \#notion: must not link but be orange - #syn("missing")

// 4. Synonym before introduction — MUST link.
#notion("canonical", "alternative")
\#syn before \#intro with alternative notion: must link - #syn("alternative")
#intro("canonical")
