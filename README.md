[![Dynamic TOML Badge](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2FRobotechnic%2Fsynapse%2Fmain%2Ftypst.toml&query=%24.package.version&logo=typst&label=package&color=239DAD)](https://github.com/Robotechnic/synapse/tree/main)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/Robotechnic/synapse/main/LICENSE)

# synapse

Synapse is a typst package offering an easy way to have every reference of a concept linked to its introduction throughout a document. This is heavily inspired by the [knowledge](https://ctan.org/pkg/knowledge) package for LaTeX, but with a typst-like API.

## Usage

This package relies on the concept of `notion`. A notion is a concept that can be introduced and referenced anywhere in the document. The reference will then all link to the introduction of the notion.
To define a notion, you can use the `notion` function:

```typst
#notion("synapse")
```

This will define a notion called "synapse". A notion can have synonyms, which are alternative names for the same notion. To define synonyms for a notion, simply add them as additional arguments to the `notion` function:

```typst
#notion("synapse", "synapses", "Synapse", "Synapses")
```

This will define the notion "synapse" with the synonyms "synapses", "Synapse", and "Synapses". Now, whenever you reference any of these terms in your document, they will all link to the introduction of the notion.

To introduce a notion, you can use the `intro` function:

```typst
In the nervous system, a #intro("synapse") is a structure that allows a neuron to exchange (receive or send) signals with another cell in its immediate vicinity
```

Now, to reference the notion in the document (anywhere before or after the introduction), you can simply use the function `syn` followed by the name of the notion:

```typst
#syn("Synapses") are essential for the transmission of neuronal impulses from one neuron to the next, playing a key role in enabling rapid and direct communication by creating circuits. In addition, a #syn("synapse") serves as a junction where both the transmission and processing of information occur, making it a vital means of communication between neurons.
```

This will create a reference to the notion "synapse" and link it to its introduction.

### External links

The `notion` function also allows you to define an external link for a notion. To do this, simply add the `url` argument to the `notion` function:

```typst
#notion("synapse", url: "https://en.wikipedia.org/wiki/Synapse")
```

If an url is provided, you can't use the `intro` function to introduce the notion, this will cause an error.

### Quick reference with quotes

Writing the function calls every time can be a bit tedious. For this reason, the package also provides a show rule to automatically replace the name of the notion between quotes with the reference to the notion:

```typst
#show: quote-rule
"Synapses" are essential for the transmission of neuronal impulses from one neuron to the next, playing a key role in enabling rapid and direct communication by creating circuits. In addition, a "synapse" serves as a junction where both the transmission and processing of information occur, making it a vital means of communication between neurons.
```

This also works with introductions with double pair of quotes:

```typst
#show: quote-rule
In the nervous system, a ""synapse"" is a structure that allows a neuron to exchange...
```

### Introduction link placement

By default, the link to the introduction of a notion is placed on the intro call. But you can change this by using the `intro-ap` function. This can be useful if you want to place the link on a different part of the text, like for example at the beginning of the sentence:

```typst
#intro-ap("synapse") In the nervous system, a #intro("synapse") is ...
```

Now, the link to the introduction of the notion "synapse" will be placed at the beginning of the sentence instead of on the intro call. The introduction link has to be before the intro call, otherwise it will cause an error.

### Representation of the notion

`intro` and `syn` functions can also take an additional positional argument that will be used to represent the notion in the text. By default, the first potitional argument is what is used to represent the notion, but you can change this by providing a different argument. For example:

```typst

#notion("pi", "Pi")

#intro("pi", $pi$) is approximately equal to 3.14159...

```

This is quite useful for mathematical notions, where you often want to use a specific symbol to represent the notion. In this example, the notion "pi" is represented by the symbol $pi$ in the text. And you can easily do this:

```typst
#let pi = syn("pi", $pi$)

$
    sin(pi) &= 0 \
    cos(pi) &= -1 \
    tan(pi) &= 0 \
$
```

In this example, all the `pi` in the math expression will be linked to the introduction of the notion "pi" and will be represented by the typst symbol $pi$.

### Math functions

It is also possible to have math expression linked to a notion. To do this, you can use the `syn-wrapper` function. This function takes a function as parameter that should accept at least one argument, which will be used to create the link to the notion. For example, if you want to create an `abs` function where only the `||` are linked to the notion, you can do it like this:

```typst
#notion("abs")

#let abs = syn-wrapper("abs", (wraper, value) => {
 $wraper(|)value#wraper($|$)$
})

#intro(abs, $x$) is a function that returns the absolute value of $x$.\
For instance, $abs(-5)$ will return $5$ while $abs(42)$ will return the exact same value of $42$.
```

Here the notion is introduced with `intro` like usual, but because `abs` takes one argument, the argument is passed to the `intro` function. Then any call to `abs` will behave like usual but with the `||` linked to the introduction of the notion "abs". Note that the notion can still be used as text like normal so `#syn("abs")` will still work and link to the introduction of the notion "abs". `intro-ap` will also behave like normal.

### Styling

Synapse supports styling of the links and the introduction of the notions. To style the links, there are two ways to do it. The first one is to use the `style` argument of `intro` and `syn` functions. The second one is to use the `synapse-config` function to set a global style for all the links and introductions of the notions with the arguments `intro-style` and `syn-style`. The `style` argument of the `intro` and `syn` functions will override the global style set by `synapse-config`. Those arguments takes a text function as value that will be used to style the links.

```typst
#synapse-config(
  intro-style: text.with(fill: orange, weight: "bold", size: 20pt),
  syn-style: text.with(fill: blue, weight: "bold", size: 10pt)
)

#notion("synapse")

#intro("synapse", style: text.with(fill: red)) is a structure ... 
```

### Rendering mode

Synapse have three rendering modes: "composition", "electronic" and "paper". The rendering mode can be set with the `synapse-config` function and the `mode` argument. The default rendering mode is "composition". This is the mode used to build your document. It displays everything like normal but on top of that, it highlight the notions with no introductions, the notions that haven't been defined with the `notion` function. It also display a red marking with a label to show where the anchors of the notions are. The "electronic" mode is the mode that display everything like normal but without the red markings and highlights. The "paper" mode is the mode that displays everything in black and white, all the styling is kept except the colors.

```typst
#synapse-config(mode: "electronic")
```

This will set the rendering mode to "electronic". You can change the rendering mode at any point in the document, but it is recommended to set it at the beginning of the document.
