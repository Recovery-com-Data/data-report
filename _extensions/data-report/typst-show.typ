// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//
// This is an example 'typst-show.typ' file (based on the default template
// that ships with Quarto). It calls the typst function named 'rp-report' which
// is defined in the 'typst-template.typ' file.
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-template.typ' entirely. You can find
// documentation on creating typst templates here and some examples here:
// - https://typst.app/docs/tutorial/making-a-template/
// - https://github.com/typst/templates
#show: data-report.with(
$if(title)$
 title: "$title$",
$endif$
$if(published-date)$
 date: "$published-date$",
$endif$
$if(author)$
$if(author.name)$
 author: ($for(author)$"$author.name$"$sep$, $endfor$),
 author_info: ($for(author)$"$if(author.info)$author.info$endif$"$sep$, $endfor$),
$else$
$if(by-author)$
 author: ($for(by-author)$"$by-author.name.literal$"$sep$, $endfor$),
$else$
 author: ($for(author)$"$author$"$sep$, $endfor$),
$endif$
$if(author-info)$
 author_info: ($for(author-info)$"$author-info$"$sep$, $endfor$),
$endif$
$endif$
$endif$
$if(edition)$
 edition: [$edition$],
$endif$
$if(version)$
 version: "$version$",
$endif$
$if(status)$
 status: "$status$",
$endif$
$if(report-theme)$
 theme: "$report-theme$",
$endif$
$if(toc)$
 toc: $toc$,
$endif$
$if(toc-depth)$
 toc-depth: $toc-depth$,
$endif$
$if(hero-image)$
 hero-image: (
 path: "$hero-image.path$",
 caption: [$hero-image.caption$]
 ),
$endif$
$if(dedication)$
 dedication: [$dedication$],
$endif$
$if(publication-info)$
 publication-info: [$publication-info$],
$endif$
)