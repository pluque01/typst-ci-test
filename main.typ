#import "template.typ": *

// use styling for spellcheck only in the spellchecker
// keep the correct styling in pdf or preview
// should be called after the template
#show: lt(overwrite: false)

// // use styling for spellcheck in pdf or preview
// // should be called after the template
// #show: lt(overwrite: true)

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Servidores Web Seguros",
  subtitle: "Tecnologías Web - 2024/2025",
  authors: (
    "Pablo Luque Salguero",
  ),
  city: "Granada",
)

#include "Chapters/1. Introduccion.typ"
#pagebreak()
#include "Chapters/2. Instalacion Apache.typ"
#pagebreak()
#include "Chapters/3.1. Configuracion Apache.typ"
#include "Chapters/3.2. HTTPS.typ"
#pagebreak()
#include "Chapters/4. Configuracion PHP.typ"

//#include "Chapters/Z. Template.typ"


#pagebreak()
#bibliography("references.bib")
