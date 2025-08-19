// This function gets your whole document as its `body` and formats
#let data-report(
  // The Report title.
  title: "Report title",

  // Report Date:
  date: none,

  // Report author(s) - can be string or array of strings
  author: "Cooper Richason",
  
  // Author info(s) - can be string or array of strings
  author_info: none,

  // The edition, displayed at the top.
  edition: none,
  
  // Version number
  version: none,
  
  // Document status (Draft, Review, Confidential, etc.) - creates a watermark for non-final versions
  status: none,

  // Color theme selection
  theme: "forest",

  // Table of Contents settings (passed from Quarto YAML)
  toc: false,
  toc-depth: 2,

  // A hero image at the start of the newsletter. If given, should be a
  // dictionary with two keys: A `path` to an image file and a `caption`
  // that is displayed to the right of the image.
  hero-image: none,

  // Details about the publication, displayed at the end of the document.
  publication-info: none,

  // The Report's content.
  body
) = {
  // Color theme function
  let get-theme-colors(theme) = {
    if theme == "forest" {
      (
        primary: rgb("214040"),      // Dark red-brown
        light: rgb("ddf0f0"),        // Light blue-green  
        background: rgb("edf2f2")    // Light gray
      )
    } else if theme == "ocean" {
      (
        primary: rgb("1e3a5f"),      // Dark blue
        light: rgb("e6f3ff"),        // Very light blue
        background: rgb("f0f8ff")    // Light blue
      )
    } else if theme == "sunset" {
      (
        primary: rgb("d2691e"),      // Dark orange
        light: rgb("fff8dc"),        // Cornsilk
        background: rgb("ffefd5")    // Papaya whip
      )
    } else if theme == "monochrome" {
      (
        primary: rgb("2c2c2c"),      // Dark gray
        light: rgb("f5f5f5"),        // Light gray
        background: rgb("eeeeee")    // Medium light gray
      )
    } else {
      // Default to forest if unknown theme
      (
        primary: rgb("214040"),      
        light: rgb("ddf0f0"),        
        background: rgb("edf2f2")    
      )
    }
  }
  
  // Get colors for selected theme
  let colors = get-theme-colors(theme)
  // Set document metadata.
  set document(title: title, author: author)

  // Configure pages:
  set page(
    // Enhanced Header with title abbreviation and page info
    header: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        // Running header for pages 2+
        let header-content = grid(
          columns: (1fr, auto),
          align: (left, right),
          text(font: "Avenir", 9pt, weight: 400, fill: colors.primary, 
               if title.len() > 50 { title.slice(0, 47) + "..." } else { title }),
          text(font: "Avenir", 9pt, weight: 400, fill: colors.primary, {
            let header-info = ()
            if edition != none { header-info = header-info + (edition,) }
            if version != none { header-info = header-info + ("v" + version,) }
            if date != none { header-info = header-info + (date,) }
            if header-info.len() > 0 { header-info.join(" • ") } else { "" }
          })
        )
        v(-5pt)
        header-content
        v(3pt)
        line(length: 100%, stroke: 0.5pt + colors.primary)
      }
    },

    // Enhanced Footer with consistent publication info and page numbers
    footer: context {
      let page-num = counter(page).get().first()
      if page-num <= 1 {
        // Logo on first page
        image("assets/logo-icon-typography-horizontal-white.png", width: 30%)
      } else {
        // Page numbers and publication info on other pages
        grid(
          columns: (1fr, auto, 1fr),
          align: (left, center, right),
          text(font: "Avenir", 8pt, fill: colors.primary, 
               if publication-info != none { publication-info } else { "" }),
          text(font: "Avenir", 9pt, weight: 500, fill: colors.primary, 
               str(page-num)),
          text(font: "Avenir", 8pt, fill: colors.primary, 
               if date != none { date } else { "" })
        )
      }
    },

    // Rest of Page Setup
    paper: "us-letter",
    margin: (left: 1in, right: 1in),
    
    // Different backgrounds for first page vs other pages
    background: context {
      let page-num = counter(page).get().first()
      
      // Base background color
      let bg-color = if page-num <= 1 { colors.primary } else { rgb("FFFFFF") }
      place(right + top, rect(fill: bg-color, height: 100%, width: 100%))
      
      // Add diagonal watermark for non-final document versions (skip first page)
      if status != none and page-num > 1 {
        place(
          center + horizon,
          rotate(
            -35deg,
            text(
              font: "Fields Variable",
              size: 72pt,
              weight: "bold",
              fill: rgb(0, 0, 0, 8%), // Very light transparency
              upper(status)
            )
          )
        )
      }
    }
  )

  // Set body font.
  set text(12pt, font: "Avenir", weight: 300, fill: rgb("1e1e1e"))

  // Configure headings.
  show heading: set text(font: "Avenir")
  show heading.where(level: 1): set text(1.4em, weight: 400, font: "Fields Variable", fill: colors.primary)
  show heading.where(level: 1): set par(leading: 10pt)
  show heading.where(level: 1): set block(below: 20pt)

  // Level 2 headings now start a new page
  show heading.where(level: 2): it => {
    // pagebreak()
    block(below: 15pt)[
      #set text(font: "Avenir", 1.2em, weight: 400)
      #set par(leading: 10pt)
      #it
    ]
  }

  show heading.where(level: 3): set text(1.1em, weight: 400)
  show heading.where(level: 3): set par(leading: 10pt)
  show heading.where(level: 3): set block(below: 10pt)

  show heading.where(level: 4): set text(1em, weight: 600)
  show heading.where(level: 4): set par(leading: 10pt)
  show heading.where(level: 4): set block(below: 10pt)

  // Custom outline entry styling
  show outline.entry: it => {
    // Style based on heading level
    let level = it.level
    let spacing = if level == 1 { v(8pt, weak: true) } else if level == 2 { v(4pt, weak: true) } else { v(2pt, weak: true) }
    let indent = (level - 1) * 1em
    let font-weight = if level == 1 { 600 } else if level == 2 { 500 } else { 400 }
    let font-size = if level == 1 { 11pt } else if level == 2 { 10pt } else { 9pt }
    let text-color = if level == 1 { colors.primary } else { rgb("1e1e1e") }
    
    spacing
    h(indent)
    set text(font: "Avenir", size: font-size, weight: font-weight, fill: text-color)
    it
  }

  // Links should be underlined.
  show link: underline

  // Configure figures with improved styling.
  show figure: it => block({
    set align(center)
    v(12pt, weak: false)
    // Create a styled container for the figure
    rect(
      fill: colors.background,           // Theme background color
      radius: 8pt,                   // Rounded corners
      {
        // The actual figure content (image, table, etc.)
        it.body
        
        // Caption below the content if it exists
        if it.has("caption") {
          v(6pt)
          set text(font: "Avenir", size: 10pt, style: "italic", fill: colors.primary)
          set align(center)
          it.caption
        }
      }
    )

    v(12pt, weak: false)
  })

  // Hero image.
  if hero-image != none {
    layout(size => {
      // Measure the image and text to find out the correct line width.
      // The line should always fill the remaining space next to the image.
      let img = image(hero-image.path, width: 14cm)
      let text-content = text(size: 16pt, fill: colors.light, font: "Fields Variable", hero-image.caption)
      let img-size = measure(img)
      let text-width = measure(text-content).width + 12pt
      let line-length = img-size.height - text-width

      grid(
        columns: (6fr, 1fr),
        column-gutter: 16pt,
        rows: img-size.height,
        img,
        grid(
          rows: (text-width, 1fr),
          move(dx: 11pt, rotate(
            90deg,
            origin: top + left,
            box(width: text-width, text-content)
          )),
          line(angle: 90deg, length: line-length, stroke: 3pt + colors.light),
        ),
      )
    })
    
    v(20pt, weak: false)
  }
  else {
    // Push content down to 1/3 of the page
  v(1.2in)
  }

  // Title.
  text(font: "Fields Variable", 42pt, weight: "bold", fill: colors.light, title)
  v(15pt, weak: false)

  // Enhanced Date and Edition Display
  {
    // Create publication metadata line for cover page (edition and date only)
    let pub-metadata = ()
    
    if edition != none {
      pub-metadata = pub-metadata + (edition,)
    }
    
    if date != none {
      pub-metadata = pub-metadata + (date,)
    }
    
    if pub-metadata.len() > 0 {
      // Display the publication metadata
      text(
        font: "Fields Variable", 
        16pt, 
        weight: 400, 
        fill: colors.light, 
        style: "italic",
        pub-metadata.join(" • ")
      )
      v(20pt, weak: false)
    }
  }

  // Author section
  {
    // Convert to arrays if they're strings
    let authors = if type(author) == array { author } else { (author,) }
    let author_infos = if author_info != none {
      if type(author_info) == array { author_info } else { (author_info,) }
    } else { () }
    
    v(15pt, weak: false)
    
    // Create individual rows for each author
    let max_length = calc.max(authors.len(), author_infos.len())
    
    for i in range(max_length) {
      let current_author = if i < authors.len() { authors.at(i) } else { "" }
      let current_info = if i < author_infos.len() { author_infos.at(i) } else { "" }
      
      // Create a table row for better control
      table(
        columns: (1fr, 1fr),
        stroke: none,
        inset: 0pt,
        
        // Author name (left side)
        text(font: "Fields Variable", 12pt, weight: "bold", style: "italic", colors.light, current_author),
        
        // Author info (right side, right-aligned)
        align(right, text(font: "Fields Variable", 10pt, weight: 200, style: "italic", colors.light, current_info))
      )

    }
  }

  v(30pt, weak: false)

  // Page break to start content on page 2
  pagebreak()

  // Table of Contents (if enabled via Quarto YAML)
  if toc {
    // Generate the outline/TOC
    outline(
      depth: toc-depth,
      indent: auto
    )
    
    v(30pt, weak: false)
    pagebreak()
  }

  // The main content (publication-info removed from here)
  {
    set par(justify: true)
    body
    v(1fr)
  }
}

// A stylized block with a quote and its author.
#let blockquote(body) = box(inset: (x: 0.4em, y: 12pt), width: 100%, {
  set text(font: "Avenir")
  grid(
    columns: (1em, auto, 1em),
    column-gutter: 12pt,
    rows: (1em, auto),
    row-gutter: 8pt,
    text(5em)["],
    line(start: (0pt, 0.45em), length: 100%),
    none, none,
    text(1.4em, align(center, body)),
    none, none
  )
})