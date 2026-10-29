// ============================================================
// สไลด์นำเสนอโครงงานวิชา INT-303 Software Engineering
// ระบบจัดการสินค้า (Simple Entry System)
// ดีไซน์: Modern Minimalist & Editorial Muted Palette
// ปราศจาก Emoji - ใช้ Numbered Cards, Accent Bars และ Pill Badges
// คอมไพล์: typst compile --font-path . slides.typ slides.pdf
// ============================================================

#set document(title: "Simple Entry System - Modern Minimalist Presentation")

// ------------------------------------------------------------
// 1. Color Palette: Muted Earthy & Slate Tones
// ------------------------------------------------------------
#let c-dark-bg       = rgb("#1A2332")   // Dark Charcoal Navy (สำหรับ Cover Slide)
#let c-dark-surface  = rgb("#243144")   // Surface สำหรับ Dark Cover
#let c-dark-border   = rgb("#384860")

#let c-navy          = rgb("#243F5A")   // Deep Slate Navy (หัวข้อหลัก, Identity)
#let c-navy-light    = rgb("#EAF0F6")
#let c-navy-border   = rgb("#CBDCEB")

#let c-steel         = rgb("#4A6D8C")   // Muted Steel Blue
#let c-steel-light   = rgb("#EFF5F9")
#let c-steel-border  = rgb("#C8DCE8")

#let c-sage          = rgb("#547F61")   // Earthy Sage Green (Stock-In, Success, 100%)
#let c-sage-light    = rgb("#EDF4F0")
#let c-sage-border   = rgb("#B9D6C3")

#let c-terracotta    = rgb("#BC6C3B")   // Terracotta Ochre (Stock-Out, Warning, Low Stock)
#let c-terracotta-light = rgb("#FBF1EA")
#let c-terracotta-border = rgb("#E8C5AF")

#let c-slate         = rgb("#64748B")   // Neutral Slate Gray
#let c-slate-light   = rgb("#F1F5F9")
#let c-slate-border  = rgb("#CBD5E1")

#let c-bg            = rgb("#F8FAFC")   // Off-White Minimalist Background
#let c-card          = rgb("#FFFFFF")   // Pure White Card
#let c-text          = rgb("#1E293B")   // High-contrast Charcoal Body Text
#let c-muted         = rgb("#64748B")   // Muted Secondary Text
#let c-border        = rgb("#E2E8F0")   // Subtle Card Border

// ------------------------------------------------------------
// 2. Global Document Settings
// ------------------------------------------------------------
#set page(
  paper: "presentation-16-9",
  fill: c-bg,
  margin: (x: 2cm, top: 1.4cm, bottom: 1.5cm),
  header: none,
  footer: context {
    let p = counter(page).get().first()
    if p > 1 [
      #line(length: 100%, stroke: 0.5pt + c-border)
      #v(0.2em)
      #grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        [
          #text(size: 11pt, fill: c-muted)[
            *INT-303 Software Engineering* | ระบบจัดการสินค้า (Simple Entry System) | กลุ่มที่ 2
          ]
        ],
        [
          #text(size: 11pt, weight: "bold", fill: c-navy)[
            #str(p) / 10
          ]
        ]
      )
    ]
  }
)

#set text(font: ("TH Sarabun New",), size: 15.5pt, fill: c-text, lang: "th", region: "TH")
#set par(leading: 0.6em, spacing: 0.7em)

// ------------------------------------------------------------
// 3. UI Component Macros (No Emojis, Pure Graphic Design)
// ------------------------------------------------------------

// Pill Badge ขนาดเล็ก สไตล์ Minimalist
#let badge(label, fill: c-navy-light, text-color: c-navy, stroke: none) = box(
  fill: fill,
  stroke: stroke,
  inset: (x: 8pt, y: 3pt),
  radius: 10pt,
  baseline: 0%,
  text(size: 11pt, weight: "bold", fill: text-color, label)
)

// การ์ดเนื้อหาพร้อม Accent Bar ด้านบน (ดึงสไตล์มาจาก Presentation ตัวอย่าง)
#let accent-card(
  title: none,
  tag: none,
  top-accent: c-navy,
  fill: c-card,
  stroke: 0.6pt + c-border,
  radius: 6pt,
  inset: 12pt,
  body
) = block(
  width: 100%,
  fill: fill,
  stroke: stroke,
  radius: radius,
  clip: true,
  [
    #if top-accent != none [
      #rect(width: 100%, height: 3.5pt, fill: top-accent)
    ]
    #pad(x: inset, top: if top-accent != none { inset - 4pt } else { inset }, bottom: inset)[
      #if tag != none or title != none [
        #grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          [
            #if title != none [
              #text(size: 15.5pt, weight: "bold", fill: c-navy, title)
            ]
          ],
          [
            #if tag != none [
              #badge(tag, fill: c-slate-light, text-color: c-muted, stroke: 0.5pt + c-border)
            ]
          ]
        )
        #v(0.4em)
      ]
      #body
    ]
  ]
)

// สเต็ปแนวนอน (Process Step Block)
#let process-block(num, title, desc, color: c-steel, active: false) = box(
  width: 100%,
  fill: if active { c-steel-light } else { c-card },
  stroke: 0.6pt + if active { c-steel-border } else { c-border },
  radius: 6pt,
  inset: 10pt,
  [
    #grid(
      columns: (auto, 1fr),
      gutter: 8pt,
      align: (center + horizon, left + horizon),
      [
        #box(
          fill: color,
          width: 22pt,
          height: 22pt,
          radius: 11pt,
          align(center + horizon)[
            #text(size: 11pt, weight: "bold", fill: white)[#num]
          ]
        )
      ],
      [
        #text(size: 13pt, weight: "bold", fill: color)[#title]
      ]
    )
    #v(0.3em)
    #text(size: 12.5pt, fill: c-muted)[#desc]
  ]
)

// ส่วนหัวของสไลด์ (Slide Header)
#let slide-header(category, title, subtitle: none, speaker: none) = [
  #grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [
      #text(size: 11pt, weight: "bold", fill: c-steel, tracking: 1.5pt)[#upper(category)]
      #v(-0.3em)
      #text(size: 22pt, weight: "bold", fill: c-navy)[#title]
      #if subtitle != none [
        #v(-0.4em)
        #text(size: 13.5pt, fill: c-muted)[#subtitle]
      ]
    ],
    [
      #if speaker != none [
        #box(
          fill: c-card,
          stroke: 0.6pt + c-border,
          inset: (x: 10pt, y: 5pt),
          radius: 4pt,
          [
            #text(size: 11.5pt, weight: "bold", fill: c-navy)[#speaker]
          ]
        )
      ]
    ]
  )
  #v(0.2em)
  #line(length: 100%, stroke: 0.5pt + c-border)
  #v(0.5em)
]



// ============================================================

#slide-header("ARCH", "Title", subtitle: "sub", speaker: "SPK")
#accent-card(title: "4-Tier Layered Architecture", tag: "SYSTEM STRUCTURE", top-accent: c-navy, inset: 10pt)[
      #box(fill: c-navy-light, inset: 5pt, radius: 4pt, width: 100%, stroke: 0.5pt + c-navy-border)[
        #text(size: 12.5pt, weight: "bold", fill: c-navy)[01. Presentation Layer]\
        #text(size: 11.5pt, fill: c-text)[Desktop Admin Dashboard & Mobile Staff Web UI]
      ]
      #v(0.5pt) #align(center)[#text(size: 9pt, fill: c-muted)[↓]] #v(0.5pt)
      #box(fill: c-steel-light, inset: 5pt, radius: 4pt, width: 100%, stroke: 0.5pt + c-steel-border)[
        #text(size: 12.5pt, weight: "bold", fill: c-steel)[02. Access Control Layer]\
        #text(size: 11.5pt, fill: c-text)[Page Guard (URL Redirect) & API Guard (Role Verification)]
      ]
      #v(0.5pt) #align(center)[#text(size: 9pt, fill: c-muted)[↓]] #v(0.5pt)
      #box(fill: c-sage-light, inset: 5pt, radius: 4pt, width: 100%, stroke: 0.5pt + c-sage-border)[
        #text(size: 12.5pt, weight: "bold", fill: c-sage)[03. Business Logic Layer]\
        #text(size: 11.5pt, fill: c-text)[Stock Engine, Deduction Service, Threshold Calculator]
      ]
      #v(0.5pt) #align(center)[#text(size: 9pt, fill: c-muted)[↓]] #v(0.5pt)
      #box(fill: c-slate-light, inset: 5pt, radius: 4pt, width: 100%, stroke: 0.5pt + c-slate-border)[
        #text(size: 12.5pt, weight: "bold", fill: c-slate)[04. Data Layer]\
        #text(size: 11.5pt, fill: c-text)[Master Store (`master.json`) & Transaction Store]
      ]
    ]
  ],
  [
    