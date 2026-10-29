// ============================================================
// EXAMPLE 1: Swiss Editorial Minimalist
// จุดเด่น: เลย์เอาท์แบบอสมมาตร (Asymmetric Grid), เลขนำสายตาขนาดใหญ่ (Watermark Numbers),
// และกระบวนการแบบ Connected Circle Process (ถอดแบบมาจากภาพตัวอย่าง)
// ============================================================

#set document(title: "Style 1: Swiss Editorial Minimalist")

#let c-navy       = rgb("#1F3864")
#let c-steel      = rgb("#41658A")
#let c-sage       = rgb("#4E7A5D")
#let c-sage-light = rgb("#EDF5F0")
#let c-terracotta = rgb("#B35F32")
#let c-terracotta-light = rgb("#FAF2ED")
#let c-bg         = rgb("#F6F8FA")
#let c-card       = rgb("#FFFFFF")
#let c-text       = rgb("#19212C")
#let c-muted      = rgb("#5E6D82")
#let c-border     = rgb("#E1E6EB")

#set page(
  paper: "presentation-16-9",
  fill: c-bg,
  margin: (x: 2cm, top: 1.4cm, bottom: 1.4cm),
  header: none,
  footer: context {
    let p = counter(page).get().first()
    if p > 1 [
      #line(length: 100%, stroke: 0.5pt + c-border)
      #v(0.2em)
      #grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        text(size: 11pt, fill: c-muted)[*STYLE 01 : SWISS EDITORIAL* | Simple Entry System | INT-303 Software Engineering],
        text(size: 11pt, weight: "bold", fill: c-navy)[0#p / 04]
      )
    ]
  }
)

#set text(font: ("TH Sarabun New",), size: 15pt, fill: c-text, lang: "th", region: "TH")
#set par(leading: 0.55em, spacing: 0.65em)

#let slide-header(category, title, subtitle: none, speaker: none) = [
  #grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [
      #text(size: 11pt, weight: "bold", fill: c-steel, tracking: 2pt)[#upper(category)]
      #v(-0.35em)
      #text(size: 23pt, weight: "bold", fill: c-navy)[#title]
      #if subtitle != none [
        #v(-0.4em)
        #text(size: 13pt, fill: c-muted)[#subtitle]
      ]
    ],
    [
      #if speaker != none [
        #box(
          fill: c-card,
          stroke: 0.8pt + c-steel,
          inset: (x: 10pt, y: 5pt),
          radius: 3pt,
          text(size: 11pt, weight: "bold", fill: c-steel)[#speaker]
        )
      ]
    ]
  )
  #v(0.2em)
  #line(length: 100%, stroke: 0.8pt + c-navy)
  #v(0.5em)
]

// ------------------------------------------------------------
// SLIDE 1: ASYMMETRIC SPLIT COVER
// ------------------------------------------------------------
#page(fill: c-card, margin: 0cm, footer: none)[
  #grid(
    columns: (1.1fr, 1.4fr),
    [
      // แถบสีเข้มด้านซ้าย (Left Anchor)
      #rect(
        fill: c-navy,
        width: 100%,
        height: 100%,
        inset: (x: 2.2cm, y: 2.2cm),
        [
          #text(size: 11pt, weight: "bold", fill: rgb("#9BB4D0"), tracking: 2pt)[
            INT-303 SOFTWARE ENGINEERING
          ]
          #v(0.8cm)
          #text(size: 38pt, weight: "bold", fill: white)[
            Simple\ Entry\ System
          ]
          #v(0.4cm)
          #line(length: 40pt, stroke: 2pt + c-sage)
          #v(0.4cm)
          #text(size: 14pt, fill: rgb("#CBDCEB"))[
            ระบบบันทึกและจัดการคลังสินค้าขนาดเล็กตามหลักวิศวกรรมซอฟต์แวร์
          ]
        ]
      )
    ],
    [
      // เนื้อหาด้านขวา (Right Grid)
      #pad(x: 1.8cm, y: 2.2cm)[
        #grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          [
            #text(size: 12pt, weight: "bold", fill: c-muted, tracking: 1pt)[
              THAI-NICHI INSTITUTE OF TECHNOLOGY
            ]
          ],
          [
            #image("Tni_logo_2.jpg", width: 14%)
          ]
        )
        
        #v(1.4cm)
        #text(size: 12pt, weight: "bold", fill: c-steel, tracking: 1.5pt)[PROJECT DEVELOPMENT ROLES]
        #v(0.4em)

        #grid(
          columns: (1fr, 1fr),
          gutter: 14pt,
          [
            #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 10pt, radius: 4pt, width: 100%)[
              #text(size: 11pt, weight: "bold", fill: c-navy)[COORDINATION & RE]\
              #v(0.2em)
              #text(size: 13pt)[นายชยิน น้ำจันทร์ (731)]\
              #text(size: 13pt)[นายรัฐพงษ์ เกิดมงคล (236)]
            ]
          ],
          [
            #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 10pt, radius: 4pt, width: 100%)[
              #text(size: 11pt, weight: "bold", fill: c-navy)[ARCHITECTURE & DEV]\
              #v(0.2em)
              #text(size: 13pt)[นายกิตติภณ เรื่องวีระชัยกุล (483)]\
              #text(size: 13pt)[นายชิษณุพงศ์ เผือกพ่วง (913)]
            ]
          ]
        )
        #v(0.4cm)
        #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 10pt, radius: 4pt, width: 100%)[
          #text(size: 11pt, weight: "bold", fill: c-navy)[QA & SYSTEM DEMONSTRATION]\
          #v(0.2em)
          #grid(
            columns: (1fr, 1fr),
            [#text(size: 13pt)[นายพันธ์ธวัช ชัยศรี (044)]],
            [#text(size: 13pt)[นายวีรภัทร อนุโรจน์ (962)]]
          )
        ]
      ]
    ]
  )
]

// ------------------------------------------------------------
// SLIDE 2: WATERMARK NUMBERS PROBLEM & SOLUTION
// ------------------------------------------------------------
#slide-header(
  "CONTEXT & RE-ENGINEERING",
  "การวิเคราะห์ปัญหาและแนวทางแก้ไข (Problem & Solution)",
  subtitle: "เปรียบเทียบกระบวนการทำงานแบบเดิม กับการยกระดับสู่ระบบอัตโนมัติ",
  speaker: "SPEAKER 01"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 18pt,
  [
    #rect(fill: c-card, stroke: 0.5pt + c-border, inset: 14pt, radius: 6pt, width: 100%)[
      #grid(
        columns: (auto, 1fr),
        gutter: 10pt,
        align: (left + horizon, left + horizon),
        [
          #text(size: 32pt, weight: "bold", fill: c-terracotta.lighten(40%))[01]
        ],
        [
          #text(size: 16pt, weight: "bold", fill: c-terracotta)[Traditional Bottlenecks]\
          #text(size: 11.5pt, fill: c-muted)[ปัญหาความล่าช้าและข้อผิดพลาดเดิม]
        ]
      )
      #v(0.5em)
      #line(length: 100%, stroke: 0.5pt + c-border)
      #v(0.5em)
      - *Manual Paperwork:* บันทึกลงกระดาษ ยอดสต็อกคลาดเคลื่อน บันทึกตกหล่น
      - *Stockout Blindspot:* ขาดเกณฑ์แจ้งเตือน ทำให้สินค้าขาดสต็อกกะทันหัน
      - *Approval Overhead:* มีขั้นตอนรออนุมัติหลายขั้น สร้างคอขวดให้การทำงาน
      - *Stationary Bound:* จำกัดการทำงานบนคอมพิวเตอร์ตั้งโต๊ะเท่านั้น
    ]
  ],
  [
    #rect(fill: c-card, stroke: 0.5pt + c-border, inset: 14pt, radius: 6pt, width: 100%)[
      #grid(
        columns: (auto, 1fr),
        gutter: 10pt,
        align: (left + horizon, left + horizon),
        [
          #text(size: 32pt, weight: "bold", fill: c-sage.lighten(40%))[02]
        ],
        [
          #text(size: 16pt, weight: "bold", fill: c-sage)[Simple Entry System]\
          #text(size: 11.5pt, fill: c-muted)[กลไกความคล่องตัวและแม่นยำ]
        ]
      )
      #v(0.5em)
      #line(length: 100%, stroke: 0.5pt + c-border)
      #v(0.5em)
      - *Simple Deduction:* ตัดยอดสต็อกทันทีเมื่อทำรายการ รวดเร็ว ไร้คอขวด
      - *Automated Threshold Alert:* ระบบตรวจจับสถานะ แจ้งเตือน Low Stock ทันที
      - *Mobile-First Staff UI:* พนักงานคลังหยิบสมาร์ทโฟนไปตัดสต็อกหน้าชั้นวาง
      - *Traceable Logs:* ออก Ref-ID บันทึกวันเวลาและผู้ทำรายการเพื่อการตรวจสอบ
    ]
  ]
)

#pagebreak()

// ------------------------------------------------------------
// SLIDE 3: CONNECTED CIRCLES PROCESS FLOW (เหมือนในภาพ Slidesalad)
// ------------------------------------------------------------
#slide-header(
  "AGILE SCRUM LIFECYCLE",
  "กระบวนการพัฒนาซอฟต์แวร์ (Agile Scrum 5 Sprints)",
  subtitle: "การส่งมอบงานทีละส่วนแบบวนซ้ำ (Iterative Delivery) ร่วมกับตัวแทนผู้ใช้งาน",
  speaker: "SPEAKER 02"
)

#v(0.2cm)
// แถบ Process Infographic แบบวงกลมเชื่อมต่อกัน
#rect(fill: c-card, stroke: 0.5pt + c-border, inset: (x: 14pt, y: 16pt), radius: 6pt, width: 100%)[
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr, auto, 1fr),
    align: (center + horizon, center + horizon),
    [
      #circle(radius: 18pt, fill: c-steel, [
        #align(center + horizon)[#text(size: 12pt, weight: "bold", fill: white)[00]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-navy)[Sprint 0]\
      #text(size: 11.5pt, fill: c-muted)[Setup & Schema]
    ],
    [#text(size: 14pt, fill: c-border)[#sym.arrow.r]],
    [
      #circle(radius: 18pt, fill: c-steel, [
        #align(center + horizon)[#text(size: 12pt, weight: "bold", fill: white)[01]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-navy)[Sprint 1]\
      #text(size: 11.5pt, fill: c-muted)[Auth & Master]
    ],
    [#text(size: 14pt, fill: c-border)[#sym.arrow.r]],
    [
      #circle(radius: 18pt, fill: c-steel, [
        #align(center + horizon)[#text(size: 12pt, weight: "bold", fill: white)[02]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-navy)[Sprint 2]\
      #text(size: 11.5pt, fill: c-muted)[Deduction Engine]
    ],
    [#text(size: 14pt, fill: c-border)[#sym.arrow.r]],
    [
      #circle(radius: 18pt, fill: c-steel, [
        #align(center + horizon)[#text(size: 12pt, weight: "bold", fill: white)[03]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-navy)[Sprint 3]\
      #text(size: 11.5pt, fill: c-muted)[Threshold Alert]
    ],
    [#text(size: 14pt, fill: c-border)[#sym.arrow.r]],
    [
      #circle(radius: 18pt, fill: c-sage, [
        #align(center + horizon)[#text(size: 12pt, weight: "bold", fill: white)[04]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-sage)[Sprint 4]\
      #text(size: 11.5pt, fill: c-muted)[Test & Release]
    ]
  )
]

#v(0.3cm)
#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  [
    #rect(fill: c-card, stroke: 0.5pt + c-border, inset: 12pt, radius: 4pt, width: 100%)[
      #text(size: 13.5pt, weight: "bold", fill: c-navy)[Stakeholder Engagement (กลุ่ม 9)]\
      #v(0.2em)
      - สัมภาษณ์ความต้องการตามมาตรฐาน IEEE 830 จนได้ 18 URs
      - ร่วมตรวจรับ Increment ในทุก Sprint Review เพื่อปรับปรุง UX
    ]
  ],
  [
    #rect(fill: c-card, stroke: 0.5pt + c-border, inset: 12pt, radius: 4pt, width: 100%)[
      #text(size: 13.5pt, weight: "bold", fill: c-navy)[Quality Gates (DoR & DoD)]\
      #v(0.2em)
      - *DoR:* ความต้องการมี Acceptance Criteria ชัดเจน ไร้ Open Issue
      - *DoD:* ผ่าน Test Case 100%, Code Review, และทดสอบข้าม Browser
    ]
  ]
)

#pagebreak()

// ------------------------------------------------------------
// SLIDE 4: LAYERED ARCHITECTURE INFOGRAPHIC
// ------------------------------------------------------------
#slide-header(
  "SYSTEM ARCHITECTURE",
  "สถาปัตยกรรมระบบ 4 ชั้น (4-Tier Layered Stack)",
  subtitle: "การแบ่งแยกหน้าที่อย่างเป็นระเบียบ (Separation of Concerns)",
  speaker: "SPEAKER 03"
)

#grid(
  columns: (1.2fr, 1fr),
  gutter: 16pt,
  [
    #rect(fill: c-card, stroke: 0.5pt + c-border, inset: 12pt, radius: 6pt, width: 100%)[
      #text(size: 14pt, weight: "bold", fill: c-navy)[Architectural Tiers]\
      #v(0.4em)

      #grid(
        columns: (40pt, 1fr),
        gutter: 8pt,
        align: (center + horizon, left + horizon),
        [#box(fill: c-navy, inset: 5pt, radius: 3pt, width: 100%, align(center)[#text(size: 11pt, weight: "bold", fill: white)[L-01]])],
        [#box(fill: c-bg, inset: 7pt, radius: 3pt, width: 100%)[*Presentation:* Desktop Admin Dashboard & Mobile Staff UI]],
        
        [#box(fill: c-steel, inset: 5pt, radius: 3pt, width: 100%, align(center)[#text(size: 11pt, weight: "bold", fill: white)[L-02]])],
        [#box(fill: c-bg, inset: 7pt, radius: 3pt, width: 100%)[*Access Control:* Page Guard (Redirect) & API Guard (403)]],
        
        [#box(fill: c-sage, inset: 5pt, radius: 3pt, width: 100%, align(center)[#text(size: 11pt, weight: "bold", fill: white)[L-03]])],
        [#box(fill: c-bg, inset: 7pt, radius: 3pt, width: 100%)[*Business Logic:* Stock Deduction Engine & Threshold Alerts]],
        
        [#box(fill: c-muted, inset: 5pt, radius: 3pt, width: 100%, align(center)[#text(size: 11pt, weight: "bold", fill: white)[L-04]])],
        [#box(fill: c-bg, inset: 7pt, radius: 3pt, width: 100%)[*Data Store:* Master (`master.json`) & Transactions Log]]
      )
    ]
  ],
  [
    #rect(fill: c-card, stroke: 0.5pt + c-border, inset: 12pt, radius: 6pt, width: 100%)[
      #text(size: 14pt, weight: "bold", fill: c-navy)[Data Storage Architecture]\
      #v(0.4em)
      
      *Master Store (`master.json`)*\
      #text(size: 12pt, fill: c-muted)[
        • Users: empId, username, password, role, status\
        • Products: sku, name, category, stock, threshold\
        • Settings: orgName, globalThreshold
      ]
      
      #v(0.4em)
      *Transaction Store (`transactions.json`)*\
      #text(size: 12pt, fill: c-muted)[
        • Log: refId (`TXN-xxxx`), type, sku, qty, staff, timestamp
      ]
      
      #v(0.4em)
      #box(fill: c-sage-light, stroke: 0.5pt + c-sage, inset: 6pt, radius: 3pt, width: 100%)[
        #text(size: 11pt, weight: "bold", fill: c-sage)[AUDIT TRAIL: ข้อมูลประวัติไม่ถูกเขียนทับ ตรวจสอบย้อนหลังได้]
      ]
    ]
  ]
)
