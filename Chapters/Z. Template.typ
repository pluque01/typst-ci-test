#import "../template.typ": ugr-color

= This is a section
== This is a subsection
=== This is a subsubsection
This section contains some templates that can be used to create a uniform style within the document. It also shows of the overall formatting of the template, created using the predefined styles from the `settings.tex` file.

== General formatting
Firstly, the document uses the font New Computer Modern and commonly uses the color #text(fill: ugr-color, "Ugr-red") (the color of the UGR logo) in its formatting. It is also using the UGR logo and report title as the header and the page number as the footer. The template uses custom section, subsection and subsubsection formatting.

The hyperref package is responsible for highlighting and formatting references like figures and tables. For
example @table:style1 or @figure:ugr-logo. It also works for citations @texbook. 

Lists are also changed globally, for a maximum of 3 levels:
- Item 1
- Item 2
  - subitem 1
    - subsubitem 1
    - subsubitem 2
- Item 3
Similarly numbered lists are also changed document wide:
+ Item 1
+ Item 2
  +  subitem 1
    + subsubitem 1
    + subsubitem 2
+ Item 3


== Tables and figures 
The following table, @table:style1, shows an example of a table in this document. More information about tables can be found on #link("https://typst.app/docs/guides/table-guide/").

#figure(
  caption: [Una tabla],
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    table.header(
      [], [*Volume*], [*Parameters*],
    ),
    "Cilindro",
    $ pi h (D^2 - d^2) / 4 $,
    [
      $h$: height \
      $D$: outer radius \
      $d$: inner radius
    ],
    "Tetraedro",
    $ sqrt(2) / 12 a^3 $,
    [$a$: edge length]
  )
) <table:style1>
#figure(
  caption: [UGR Logo],
  image("../Figures/UGR-MARCA-01-color.svg", width: 50%)
) <figure:ugr-logo>

== Code formatting
With Typst, is quite easy to create code blocks. This is an example:
```python
num = float(input("Enter a number: "))
if num > 0:
   print("Positive number")
elif num == 0:
   print("Zero")
else:
   print("Negative number")
```

Inline code is also an option, ```c int myvariable = 1 ```. 