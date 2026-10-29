// ============================================================
// สไลด์นำเสนอโครงงานวิชา INT-303 Software Engineering
// ระบบจัดการสินค้า (Simple Entry System)
// สไตล์: Swiss Editorial Minimalist (สี่เหลี่ยมขอบโค้ง โปร่งสบายตา)
// ปราศจาก Emoji - ใช้ Numbered Cards, Circle Process และ Rounded Boxes
// คอมไพล์: typst compile --font-path . slides.typ slides.pdf
// ============================================================

#set document(title: "Simple Entry System - Swiss Editorial Presentation")

// ------------------------------------------------------------
// 1. Color Palette: Muted Earthy & Slate Palette
// ------------------------------------------------------------
#let c-navy          = rgb("#1F3864")   // Deep Swiss Navy (สีหลักประจำระบบ)
#let c-navy-light    = rgb("#EAF0F6")
#let c-navy-border   = rgb("#C4D6E8")

#let c-steel         = rgb("#41658A")   // Muted Steel Blue
#let c-steel-light   = rgb("#EFF5F9")
#let c-steel-border  = rgb("#C4D8E6")

#let c-sage          = rgb("#4E7A5D")   // Earthy Sage Green (รับเข้า, ความสำเร็จ)
#let c-sage-light    = rgb("#EDF5F0")
#let c-sage-border   = rgb("#B7D5C2")

#let c-terracotta    = rgb("#B35F32")   // Terracotta Ochre (จ่ายออก, จุดเตือน)
#let c-terracotta-light = rgb("#FAF2ED")
#let c-terracotta-border = rgb("#E8C7B2")

#let c-slate         = rgb("#5E6D82")   // Neutral Slate Gray
#let c-slate-light   = rgb("#F1F5F9")
#let c-slate-border  = rgb("#CBD5E1")

#let c-bg            = rgb("#F6F8FA")   // Off-White Minimalist Background
#let c-card          = rgb("#FFFFFF")   // Pure White Card
#let c-text          = rgb("#19212C")   // High-contrast Charcoal Text
#let c-muted         = rgb("#5E6D82")   // Secondary Muted Text
#let c-border        = rgb("#E1E6EB")   // Subtle Card Border

// ------------------------------------------------------------
// 2. Global Document Settings (16:9 Presentation)
// ------------------------------------------------------------
#set page(
  paper: "presentation-16-9",
  fill: c-bg,
  margin: (x: 1.8cm, top: 1.1cm, bottom: 1.1cm),
  header: none,
  footer: context {
    let p = counter(page).get().first()
    if p > 1 [
      #line(length: 100%, stroke: 0.5pt + c-border)
      #v(0.15em)
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
            #if p < 10 [0#p / 11] else [#p / 11]
          ]
        ]
      )
    ]
  }
)

#set text(font: ("TH Sarabun New",), size: 16pt, fill: c-text, lang: "th", region: "TH")
#set par(leading: 0.58em, spacing: 0.65em)

// ------------------------------------------------------------
// 3. UI Component Helper Macros (สี่เหลี่ยมขอบโค้ง ไม่มีแถบสันหนา)
// ------------------------------------------------------------

// ป้ายกำกับ (Pill Badge)
#let badge(label, fill: c-navy-light, text-color: c-navy, stroke: none) = box(
  fill: fill,
  stroke: stroke,
  inset: (x: 8pt, y: 3pt),
  radius: 10pt,
  baseline: 0%,
  text(size: 11.5pt, weight: "bold", fill: text-color, label)
)

// ไอคอนเทคโนโลยีแบบกรอบเรียบ (Tech Icon Pill)
#let icon-pill(path, height: 12.5pt) = box(
  fill: c-bg,
  stroke: 0.5pt + c-border,
  radius: 4pt,
  inset: (x: 4.5pt, y: 2.5pt),
  image(path, height: height)
)

// กล่องข้อความสี่เหลี่ยมขอบโค้ง (Rounded Box สไตล์ Minimalist ตามภาพตัวอย่าง)
#let rounded-box(
  title: none,
  subtitle: none,
  num: none,
  tag: none,
  accent-color: c-navy,
  fill: c-card,
  stroke: 0.6pt + c-border,
  radius: 8pt,
  inset: 14pt,
  body
) = block(
  width: 100%,
  fill: fill,
  stroke: stroke,
  radius: radius,
  inset: inset,
  [
    #if title != none or num != none [
      #grid(
        columns: (if num != none { auto } else { 0pt }, 1fr, if tag != none { auto } else { 0pt }),
        gutter: if num != none { 10pt } else { 0pt },
        align: (left + horizon, left + horizon, right + horizon),
        [
          #if num != none [
            #text(size: 28pt, weight: "bold", fill: accent-color.lighten(35%))[#num]
          ]
        ],
        [
          #if title != none [
            #text(size: 16.5pt, weight: "bold", fill: accent-color)[#title]
          ]
          #if subtitle != none [
            #v(-0.35em)
            #text(size: 12.5pt, fill: c-muted)[#subtitle]
          ]
        ],
        [
          #if tag != none [
            #if type(tag) == str [
              #badge(tag, fill: c-slate-light, text-color: c-muted, stroke: 0.5pt + c-border)
            ] else [
              #tag
            ]
          ]
        ]
      )
      #v(0.3em)
      #line(length: 100%, stroke: 0.5pt + c-border)
      #v(0.4em)
    ]
    #body
  ]
)

// หัวสไลด์แบบ Swiss Style (Slide Header)
#let slide-header(category, title, subtitle: none, speaker: none) = [
  #grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [
      #text(size: 11pt, weight: "bold", fill: c-steel, tracking: 1.5pt)[#upper(category)]
      #v(-0.35em)
      #text(size: 23pt, weight: "bold", fill: c-navy)[#title]
      #if subtitle != none [
        #v(-0.4em)
        #text(size: 13.5pt, fill: c-muted)[#subtitle]
      ]
    ],
    [
      #if speaker != none [
        #box(
          fill: c-card,
          stroke: 0.8pt + c-steel,
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
  #line(length: 100%, stroke: 0.8pt + c-navy)
  #v(0.5em)
]

// ============================================================
// SLIDE 1: COVER SLIDE (Asymmetric Split - Swiss Editorial)
// ============================================================
#page(fill: c-card, margin: 0cm, footer: none)[
  #grid(
    columns: (1.05fr, 1.45fr),
    [
      // แถบสีเข้มด้านซ้าย (Left Navy Anchor)
      #rect(
        fill: c-navy,
        width: 100%,
        height: 100%,
        inset: (x: 2cm, y: 2cm),
        [
          #text(size: 11pt, weight: "bold", fill: rgb("#9BB4D0"), tracking: 2pt)[
            INT-303 SOFTWARE ENGINEERING
          ]
          #v(0.8cm)
          #text(size: 38pt, weight: "bold", fill: white)[
            Simple\ Entry\ System
          ]
          #v(0.35cm)
          #line(length: 44pt, stroke: 2.5pt + c-sage)
          #v(0.35cm)
          #text(size: 14.5pt, fill: rgb("#D1E0EE"))[
            ระบบจัดการสินค้าคงคลังขนาดเล็ก\ ตามหลักวิศวกรรมซอฟต์แวร์
          ]
          #v(0.8cm)
          #box(fill: rgb("#2D4975"), inset: (x: 10pt, y: 5pt), radius: 4pt)[
            #text(size: 11pt, fill: rgb("#EAF0F6"))[Lean Architecture • RBAC • Simple Deduction]
          ]
        ]
      )
    ],
    [
      // เนื้อหาด้านขวา (Right Grid: โลโก้และรายชื่อสมาชิกตามบทบาทใหม่)
      #pad(x: 1.8cm, y: 1.5cm)[
        #grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          [
            #text(size: 11.5pt, weight: "bold", fill: c-muted, tracking: 1.2pt)[
              THAI-NICHI INSTITUTE OF TECHNOLOGY
            ]\
            #text(size: 10.5pt, fill: c-muted)[FACULTY OF INFORMATION TECHNOLOGY]
          ],
          [
            #image("Tni_logo_2.jpg", width: 1.8cm)
          ]
        )
        
        #v(0.5cm)
        #text(size: 12pt, weight: "bold", fill: c-steel, tracking: 1.5pt)[PROJECT DEVELOPMENT TEAM (กลุ่มที่ 2)]
        #v(0.3em)

        #grid(
          columns: (1fr, 1fr),
          gutter: 10pt,
          [
            #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 9pt, radius: 6pt, width: 100%)[
              #text(size: 10.5pt, weight: "bold", fill: c-navy)[MAIN DEVELOPER]\
              #v(0.2em)
              #text(size: 13.5pt, weight: "bold")[นายกิตติภณ เรื่องวีระชัยกุล]\
              #text(size: 11.5pt, fill: c-muted)[2413110483 (หัวหน้านักพัฒนา)]
            ]
          ],
          [
            #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 9pt, radius: 6pt, width: 100%)[
              #text(size: 10.5pt, weight: "bold", fill: c-navy)[DEVELOPER]\
              #v(0.2em)
              #text(size: 13.5pt, weight: "bold")[นายชิษณุพงศ์ เผือกพ่วง]\
              #text(size: 11.5pt, fill: c-muted)[2413110913 (นักพัฒนาระบบ)]
            ]
          ]
        )
        #v(0.25cm)
        #grid(
          columns: (1fr, 1fr),
          gutter: 10pt,
          [
            #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 9pt, radius: 6pt, width: 100%)[
              #text(size: 10.5pt, weight: "bold", fill: c-navy)[PROJECT COORDINATOR]\
              #v(0.2em)
              #text(size: 13.5pt, weight: "bold")[นายชยิน น้ำจันทร์]\
              #text(size: 11.5pt, fill: c-muted)[2413110731 (ผู้ประสานงานโครงการ)]
            ]
          ],
          [
            #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 9pt, radius: 6pt, width: 100%)[
              #text(size: 10.5pt, weight: "bold", fill: c-navy)[QUALITY ASSURANCE & TESTER]\
              #v(0.2em)
              #text(size: 13.5pt, weight: "bold")[นายรัฐพงษ์ เกิดมงคล]\
              #text(size: 11.5pt, fill: c-muted)[2413110236 (ผู้ทดสอบระบบ)]
            ]
          ]
        )
        #v(0.25cm)
        #grid(
          columns: (1fr, 1fr),
          gutter: 10pt,
          [
            #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 9pt, radius: 6pt, width: 100%)[
              #text(size: 10.5pt, weight: "bold", fill: c-navy)[SOFTWARE DOCUMENTATION]\
              #v(0.2em)
              #text(size: 13.5pt, weight: "bold")[นายพันธ์ธวัช ชัยศรี]\
              #text(size: 11.5pt, fill: c-muted)[2413111044 (ผู้จัดทำเอกสารโครงการ)]
            ]
          ],
          [
            #box(fill: c-bg, stroke: 0.5pt + c-border, inset: 9pt, radius: 6pt, width: 100%)[
              #text(size: 10.5pt, weight: "bold", fill: c-navy)[PROJECT SUPPORT]\
              #v(0.2em)
              #text(size: 13.5pt, weight: "bold")[นายวีรภัทร อนุโรจน์]\
              #text(size: 11.5pt, fill: c-muted)[2413110962 (ฝ่ายสนับสนุนโครงการ)]
            ]
          ]
        )
      ]
    ]
  )
]

// ============================================================
// SLIDE 2: PROBLEM & SOLUTION (สี่เหลี่ยมขอบโค้ง ตามภาพตัวอย่าง)
// ============================================================
#slide-header(
  "CONTEXT & RE-ENGINEERING",
  "ปัญหาคลังสินค้าเดิม และแนวคิดระบบใหม่ (Problem & Solution)",
  subtitle: "เปลี่ยนผ่านจากการจดกระดาษ สู่ระบบดิจิทัลที่เน้นความคล่องตัวและแม่นยำ",
  speaker: "SPEAKER 01"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  [
    #rounded-box(
      num: "01",
      title: "Traditional Bottlenecks",
      subtitle: "ปัญหาความล่าช้าและข้อผิดพลาดเดิม",
      accent-color: c-terracotta,
      inset: 15pt
    )[
      #v(0.2em)
      - *Manual Paperwork:* บันทึกลงกระดาษ ยอดสต็อกคลาดเคลื่อน บันทึกตกหล่น
      #v(0.3em)
      - *Stockout Blindspot:* ขาดเกณฑ์เตือนล่วงหน้า ทำให้สินค้าขาดสต็อกกะทันหัน
      #v(0.3em)
      - *Approval Overhead:* มีขั้นตอนรออนุมัติหลายขั้น สร้างคอขวดให้การทำงาน
      #v(0.3em)
      - *Stationary Bound:* จำกัดการทำงานบนคอมพิวเตอร์ตั้งโต๊ะเท่านั้น
    ]
  ],
  [
    #rounded-box(
      num: "02",
      title: "Simple Entry System",
      subtitle: "กลไกความคล่องตัวและแม่นยำ",
      accent-color: c-sage,
      inset: 15pt
    )[
      #v(0.2em)
      - *Simple Deduction:* ตัดยอดสต็อกทันทีเมื่อทำรายการ รวดเร็ว ไร้คอขวด
      #v(0.3em)
      - *Automated Threshold Alert:* ระบบตรวจจับสถานะ แจ้งเตือน Low Stock ทันที
      #v(0.3em)
      - *Mobile-First Staff UI:* พนักงานคลังหยิบสมาร์ทโฟนไปตัดสต็อกหน้าชั้นวาง
      #v(0.3em)
      - *Traceable Logs:* ออก Ref-ID บันทึกวันเวลาและผู้ทำรายการเพื่อการตรวจสอบ
    ]
  ]
)

#v(0.5em)
#align(center)[
  #badge("ขอบเขตโครงการ (Project Scope): มุ่งเน้นกระบวนการบันทึกข้อมูลหลักและการแบ่งสิทธิ์ ไม่รวมระบบ Approval ที่ซับซ้อน", fill: c-slate-light, text-color: c-navy, stroke: 0.5pt + c-border)
]

#pagebreak()

// ============================================================
// SLIDE 3: CONNECTED CIRCLES PROCESS FLOW (Agile Scrum)
// ============================================================
#slide-header(
  "PROCESS MODEL",
  "กระบวนการพัฒนาซอฟต์แวร์ (Agile Scrum 5 Sprints)",
  subtitle: "การส่งมอบงานทีละส่วนแบบวนซ้ำ (Iterative Delivery) เป็นรอบ Sprint ละ 2 สัปดาห์",
  speaker: "SPEAKER 02"
)

#v(0.1cm)
#rounded-box(title: "Sprint Delivery Roadmap (กำหนดการพัฒนา 5 Sprints)", tag: "ITERATIVE CYCLE", accent-color: c-steel, inset: 10pt)[
  #v(0.05cm)
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr, auto, 1fr),
    align: (center + horizon, center + horizon),
    [
      #circle(radius: 15pt, fill: c-steel, [
        #align(center + horizon)[#text(size: 11pt, weight: "bold", fill: white)[00]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-navy)[Sprint 0]\
      #text(size: 11.5pt, fill: c-muted)[Setup & Schema\ ออกแบบฐานข้อมูล]
    ],
    [#text(size: 13pt, fill: c-border)[#sym.arrow.r]],
    [
      #circle(radius: 15pt, fill: c-steel, [
        #align(center + horizon)[#text(size: 11pt, weight: "bold", fill: white)[01]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-navy)[Sprint 1]\
      #text(size: 11.5pt, fill: c-muted)[Auth & Master\ จัดการข้อมูลหลัก]
    ],
    [#text(size: 13pt, fill: c-border)[#sym.arrow.r]],
    [
      #circle(radius: 15pt, fill: c-steel, [
        #align(center + horizon)[#text(size: 11pt, weight: "bold", fill: white)[02]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-navy)[Sprint 2]\
      #text(size: 11.5pt, fill: c-muted)[Deduction Engine\ รับเข้า-จ่ายออก]
    ],
    [#text(size: 13pt, fill: c-border)[#sym.arrow.r]],
    [
      #circle(radius: 15pt, fill: c-steel, [
        #align(center + horizon)[#text(size: 11pt, weight: "bold", fill: white)[03]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-navy)[Sprint 3]\
      #text(size: 11.5pt, fill: c-muted)[Threshold Alert\ แจ้งเตือนและรายงาน]
    ],
    [#text(size: 13pt, fill: c-border)[#sym.arrow.r]],
    [
      #circle(radius: 15pt, fill: c-sage, [
        #align(center + horizon)[#text(size: 11pt, weight: "bold", fill: white)[04]]
      ])
      #v(0.2em)
      #text(size: 13pt, weight: "bold", fill: c-sage)[Sprint 4]\
      #text(size: 11.5pt, fill: c-muted)[Test & Release\ ทดสอบรวมและส่งมอบ]
    ]
  )
]

#v(0.2cm)
#grid(
  columns: (1fr, 1fr),
  gutter: 16pt,
  [
    #rounded-box(title: "Stakeholder Collaboration (การทำงานร่วมกับผู้ใช้)", tag: "STAKEHOLDERS", accent-color: c-navy, inset: 11pt)[
      - *Development Team (กลุ่มที่ 2):* วิเคราะห์ ออกแบบ พัฒนา และทดสอบระบบ
      #v(0.2em)
      - *User Representative (กลุ่มที่ 9):* ร่วมประชุมสัมภาษณ์ความต้องการ และตรวจรับงานในรอบ Sprint Review เพื่อปรับปรุงระบบอย่างต่อเนื่อง
    ]
  ],
  [
    #rounded-box(title: "Quality Gates (เกณฑ์ควบคุมคุณภาพงาน)", tag: "QUALITY GATES", accent-color: c-navy, inset: 11pt)[
      - *Definition of Ready (DoR - เกณฑ์พร้อมเริ่ม):* ความต้องการมีเงื่อนไขการตรวจรับ (Acceptance Criteria) ชัดเจน และไม่มีประเด็นค้างคา
      #v(0.2em)
      - *Definition of Done (DoD - เกณฑ์งานเสร็จสมบูรณ์):* ผ่านการทดสอบ 100%, ผ่าน Code Review, และตรวจสอบสิทธิ์ความปลอดภัยฝั่งเซิร์ฟเวอร์
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 4: REQUIREMENTS ENGINEERING (นำรหัส UR ออกจากหัวข้อ)
// ============================================================
#slide-header(
  "REQUIREMENTS ANALYSIS",
  "ข้อกำหนดความต้องการของผู้ใช้งาน (User Requirements)",
  subtitle: "สรุปผลการสัมภาษณ์และจัดกลุ่มความต้องการ 18 ข้อ ตามมาตรฐาน IEEE Std 830",
  speaker: "SPEAKER 02"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  [
    #rounded-box(title: "Master Data Management (การจัดการข้อมูลหลัก)", tag: "4 ข้อ", accent-color: c-navy, inset: 11pt)[
      - Admin มีสิทธิ์เพิ่มและแก้ไขข้อมูลสินค้าหลักของระบบแต่เพียงผู้เดียว
      #v(0.2em)
      - จัดการบัญชีผู้ใช้งาน (เพิ่มพนักงาน, เปิดใช้งาน หรือระงับบัญชี Staff)
      #v(0.2em)
      - เรียกดูข้อมูลสรุปภาพรวมแดชบอร์ด และเข้าถึงรายงานเชิงบริหาร
    ]
    #v(0.3cm)
    #rounded-box(title: "Stock Operation (การปฏิบัติงานด้านสต็อก)", tag: "4 ข้อ", accent-color: c-steel, inset: 11pt)[
      - Staff บันทึกการรับเข้าสินค้า (Stock-In) และจ่ายออกสินค้า (Stock-Out)
      #v(0.2em)
      - *ข้อจำกัดเด็ดขาด:* ห้าม Staff แก้ไขข้อมูลสินค้า และไม่อนุญาตให้เข้าถึงรายงานเชิงบริหาร
    ]
  ],
  [
    #rounded-box(title: "Inventory Core (การจัดการสต็อกสินค้า)", tag: "5 ข้อ", accent-color: c-sage, inset: 11pt)[
      - จัดเก็บข้อมูลพื้นฐาน 4 รายการ ได้แก่ รหัสสินค้า, ชื่อสินค้า, หมวดหมู่, และสต็อกคงเหลือ
      #v(0.2em)
      - ใช้กลไก Simple Deduction ตัดยอดตรงจากสต็อกคงเหลือทันทีเมื่อทำรายการ
      #v(0.2em)
      - ไม่มีขั้นตอนการรออนุมัติ (No Approval Flow) และไม่มีกลไกล็อคข้อมูลที่ซับซ้อน
    ]
    #v(0.3cm)
    #grid(
      columns: (1.15fr, 1fr),
      gutter: 10pt,
      [
        #rounded-box(title: "Threshold & Alerts (การแจ้งเตือน)", tag: "3 ข้อ", accent-color: c-terracotta, inset: 10pt)[
          - ตั้งค่าเกณฑ์ขั้นต่ำ (Threshold)
          - แจ้งเตือน Low Stock บนหน้า Web
        ]
      ],
      [
        #rounded-box(title: "Usability (ความสะดวกในการใช้งาน)", tag: "2 ข้อ", accent-color: c-slate, inset: 10pt)[
          - เน้นการทำงานเชิงระบบที่เรียบง่าย
          - รองรับการใช้งานหลายเบราว์เซอร์
        ]
      ]
    )
  ]
)

#pagebreak()

// ============================================================
// SLIDE 5: SYSTEM ARCHITECTURE & DATA MODEL (ตัด data/*.json ออก)
// ============================================================
#slide-header(
  "ARCHITECTURE & DATA DESIGN",
  "สถาปัตยกรรมระบบ 4 ชั้น และโครงสร้างข้อมูล (Layered Architecture)",
  subtitle: "การแบ่งแยกหน้าที่ของระบบ (Separation of Concerns) ให้ดูแลง่ายและปลอดภัย",
  speaker: "SPEAKER 03"
)

#grid(
  columns: (1.12fr, 1fr),
  gutter: 14pt,
  [
    #rounded-box(title: "4-Tier Layered Architecture (สถาปัตยกรรม 4 ชั้น)", tag: "SYSTEM STRUCTURE", accent-color: c-navy, inset: 9pt)[
      #box(fill: c-navy-light, inset: (x: 8pt, y: 3.5pt), radius: 4pt, width: 100%, stroke: 0.5pt + c-navy-border)[
        #text(size: 12.5pt, weight: "bold", fill: c-navy)[L-01 Presentation Layer (ชั้นแสดงผล):]\
        #text(size: 11.5pt, fill: c-text)[Desktop Admin Dashboard (บนคอม) & Mobile Staff UI (บนมือถือ)]
      ]
      #align(center)[#text(size: 7pt, fill: c-muted)[↓]]
      #box(fill: c-steel-light, inset: (x: 8pt, y: 3.5pt), radius: 4pt, width: 100%, stroke: 0.5pt + c-steel-border)[
        #text(size: 12.5pt, weight: "bold", fill: c-steel)[L-02 Access Control Layer (ชั้นควบคุมสิทธิ์):]\
        #text(size: 11.5pt, fill: c-text)[Page Guard (ดักการพิมพ์ URL) & API Guard (ตรวจ Token และสิทธิ์)]
      ]
      #align(center)[#text(size: 7pt, fill: c-muted)[↓]]
      #box(fill: c-sage-light, inset: (x: 8pt, y: 3.5pt), radius: 4pt, width: 100%, stroke: 0.5pt + c-sage-border)[
        #text(size: 12.5pt, weight: "bold", fill: c-sage)[L-03 Business Logic Layer (ชั้นตรรกะประมวลผล):]\
        #text(size: 11.5pt, fill: c-text)[Stock Engine (ตัดยอดสต็อก), Threshold Alerts (คำนวณการแจ้งเตือน)]
      ]
      #align(center)[#text(size: 7pt, fill: c-muted)[↓]]
      #box(fill: c-slate-light, inset: (x: 8pt, y: 3.5pt), radius: 4pt, width: 100%, stroke: 0.5pt + c-slate-border)[
        #text(size: 12.5pt, weight: "bold", fill: c-slate)[L-04 Data Layer (ชั้นจัดเก็บข้อมูล):]\
        #text(size: 11.5pt, fill: c-text)[Master Data Store (ข้อมูลหลัก) & Transaction Log Store (ประวัติรายการ)]
      ]
    ]
  ],
  [
    #rounded-box(title: "Data Storage Architecture (การออกแบบที่เก็บข้อมูล)", tag: "STORAGE DESIGN", accent-color: c-steel, inset: 10pt)[
      #text(weight: "bold", fill: c-navy)[Master Data Store (คลังข้อมูลหลัก)]\
      #text(size: 12pt, fill: c-muted)[• Users: ข้อมูลพนักงาน, รหัสผ่าน, สิทธิ์ (Admin/Staff), สถานะ]\
      #text(size: 12pt, fill: c-muted)[• Products: รหัสสินค้า (SKU), ชื่อ, หมวดหมู่, สต็อก, Threshold]\
      #text(size: 12pt, fill: c-muted)[• Settings: ชื่อองค์กร, เกณฑ์แจ้งเตือนรวมของระบบ]
      
      #v(0.3em)
      #text(weight: "bold", fill: c-steel)[Transaction Log Store (คลังประวัติธุรกรรม)]\
      #text(size: 12pt, fill: c-muted)[• ประวัติธุรกรรม: รหัสอ้างอิง Ref-ID (`TXN-xxxx`), ประเภท (รับ/จ่าย), รหัสสินค้า, จำนวน, ผู้ทำรายการ, วันเวลา]
      
      #v(0.4em)
      #badge("AUDIT TRAIL: บันทึกข้อมูลแบบต่อท้าย ไม่เขียนทับ เพื่อตรวจสอบย้อนหลังได้ 100%", fill: c-sage-light, text-color: c-sage, stroke: 0.5pt + c-sage-border)
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 6: ROLE-BASED ACCESS CONTROL (ตัด Two-Tier ออก - กว้างขวางสบายตา)
// ============================================================
#slide-header(
  "SECURITY & ACCESS MATRIX",
  "ระบบควบคุมสิทธิ์ตามบทบาท (Role-Based Access Control)",
  subtitle: "การแบ่งแยกสิทธิ์การทำงานระหว่างผู้ดูแลระบบและพนักงานคลังสินค้าอย่างเด็ดขาด",
  speaker: "SPEAKER 03"
)

#v(0.2cm)
#grid(
  columns: (1fr, 1fr),
  gutter: 22pt,
  [
    #rounded-box(title: "Admin Role (ผู้ดูแลระบบ — จอคอมพิวเตอร์)", tag: "ADMINISTRATOR", accent-color: c-navy, inset: 18pt)[
      #v(0.2em)
      - *บริหารจัดการ Master Data:* มีสิทธิ์เพิ่ม แก้ไข และจัดหมวดหมู่สินค้าในคลังแต่เพียงผู้เดียว
      #v(0.4em)
      - *จัดการบัญชีผู้ใช้งาน (User Management):* เพิ่มพนักงานใหม่ เปิดใช้งาน หรือระงับบัญชี Staff
      #v(0.4em)
      - *กำหนดเกณฑ์แจ้งเตือน (Threshold Quantity):* ตั้งค่าระดับสินค้าขั้นต่ำที่ต้องแจ้งเตือน
      #v(0.4em)
      - *สรุปสถิติและรายงาน:* ดูแดชบอร์ดภาพรวม เรียกดูประวัติย้อนหลัง และส่งออกข้อมูลเป็น CSV
      #v(0.4em)
      - *สำรองข้อมูลระบบ:* ดาวน์โหลดไฟล์สำรองข้อมูลของระบบ (System Database Backup)
    ]
  ],
  [
    #rounded-box(title: "Staff Role (พนักงานคลังสินค้า — จอมือถือ)", tag: "WAREHOUSE STAFF", accent-color: c-steel, inset: 18pt)[
      #v(0.2em)
      - *บันทึกการรับเข้าสินค้า (Stock-In):* สแกนบาร์โค้ดและเพิ่มจำนวนสินค้าเข้าคลัง
      #v(0.4em)
      - *บันทึกการจ่ายออกสินค้า (Stock-Out):* ทำรายการเบิกจ่ายสินค้าหน้าชั้นวางได้อย่างรวดเร็ว
      #v(0.4em)
      - *ตรวจสอบสต็อกหน้างาน (Check Stock):* ค้นหาสินค้าและดูยอดคงเหลือ ณ ปัจจุบัน
      #v(0.4em)
      - *ดูสลิปยืนยันของตนเอง:* เรียกดูใบสำคัญรับ-จ่ายพัสดุพร้อมรหัสอ้างอิง Ref-ID
      #v(0.4em)
      - *Enforced Block:* ถูกปิดกั้นสิทธิ์ไม่ให้แก้ไขข้อมูลสินค้า และไม่สามารถดูรายงานเชิงบริหาร
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 7: STOCK OPERATION & LOW STOCK ALERT
// ============================================================
#slide-header(
  "CORE MECHANICS",
  "กลไกการตัดสต็อกและการแจ้งเตือน (Core Mechanics)",
  subtitle: "การตัดยอดแบบ Simple Deduction ไร้ขั้นตอนอนุมัติ พร้อมการคำนวณสถานะอัตโนมัติ",
  speaker: "SPEAKER 04"
)

#grid(
  columns: (1.1fr, 1fr),
  gutter: 18pt,
  [
    #rounded-box(title: "Simple Deduction Workflow (โฟลว์การตัดสต็อก)", tag: "FAST EXECUTION", accent-color: c-sage, inset: 13pt)[
      #v(0.1cm)
      #grid(
        columns: (auto, 1fr),
        gutter: 8pt,
        align: (left + top, left + top),
        [#text(weight: "bold", fill: c-sage)[01]],
        [*Stock-In Flow (รับเข้า):* ระบุ SKU #sym.arrow.r ใส่จำนวน N #sym.arrow.r สต็อก +N ทันที #sym.arrow.r บันทึก Log พร้อมสร้าง Ref-ID #sym.arrow.r แสดงสลิป],
        [#text(weight: "bold", fill: c-sage)[02]],
        [*Stock-Out Flow (จ่ายออก):* ระบุ SKU #sym.arrow.r ใส่จำนวน M #sym.arrow.r *ตรวจสต็อกคงเหลือ* #sym.arrow.r สต็อก -M ทันที #sym.arrow.r ตรวจเกณฑ์ Threshold],
        [#text(weight: "bold", fill: c-terracotta)[03]],
        [*Zero-Negative Rule (กันยอดติดลบ):* หากยอดเบิกมากกว่าคงเหลือ ระบบจะล็อกปุ่มบันทึกและขึ้นเตือนสีแดงทันที (ห้ามยอดติดลบเด็ดขาด)]
      )
    ]
  ],
  [
    #rounded-box(title: "Threshold & Notification Logic (ตรรกะแจ้งเตือนอัตโนมัติ)", tag: "AUTO CALCULATION", accent-color: c-terracotta, inset: 13pt)[
      การคำนวณสถานะสต็อกแบบอัตโนมัติทุกครั้งที่มีการจ่ายออก:
      #v(0.25em)
      #box(fill: c-terracotta-light, stroke: 0.5pt + c-terracotta-border, inset: 9pt, radius: 6pt, width: 100%)[
        *Stock = 0 ชิ้น:* #badge("Out of Stock", fill: rgb("#FEE2E2"), text-color: rgb("#991B1B")) (สินค้าหมดสต็อก)
      ]
      #v(0.25em)
      #box(fill: c-terracotta-light, stroke: 0.5pt + c-terracotta-border, inset: 9pt, radius: 6pt, width: 100%)[
        *Stock <= Threshold:* #badge("Low Stock", fill: c-terracotta-light, text-color: c-terracotta) (สินค้าใกล้หมด — ส่งแจ้งเตือน)
      ]
      #v(0.25em)
      #box(fill: c-sage-light, stroke: 0.5pt + c-sage-border, inset: 9pt, radius: 6pt, width: 100%)[
        *Stock > Threshold:* #badge("In Stock", fill: c-sage-light, text-color: c-sage) (สต็อกพร้อมจ่าย — ปริมาณปกติ)
      ]
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 8: QUALITY ASSURANCE & TRACEABILITY MATRIX (ย้ายมา Slide 8)
// ============================================================
#slide-header(
  "VERIFICATION & VALIDATION",
  "การประกันคุณภาพและผลการทดสอบ (Quality Assurance)",
  subtitle: "การทดสอบฟังก์ชันและความปลอดภัย พร้อมตารางตรวจสอบย้อนกลับ (Traceability Matrix)",
  speaker: "SPEAKER 05"
)

#grid(
  columns: (1fr, 1.6fr),
  gutter: 18pt,
  [
    #rounded-box(title: "Execution Summary (สรุปผลการทดสอบ)", tag: "TEST RESULTS", accent-color: c-sage, inset: 14pt)[
      #align(center)[
        #text(size: 44pt, weight: "bold", fill: c-sage)[100%]\
        #text(size: 15.5pt, weight: "bold", fill: c-navy)[ผ่านครบ 10 จาก 10 Test Cases]
      ]
      #v(0.4em)
      - *Functional Testing:* เพิ่มสินค้า, รับเข้า, จ่ายออก, แจ้งเตือน Low Stock (ผ่าน)
      #v(0.2em)
      - *Security Testing:* ป้องกัน Staff แก้ไขข้อมูล, ป้องกันการเข้าถึงรายงาน (ผ่าน)
      #v(0.2em)
      - *Compatibility:* รองรับ Chrome, Edge, Firefox และ Safari (ผ่าน)
    ]
  ],
  [
    #rounded-box(title: "Traceability Matrix (ตารางตรวจสอบย้อนกลับ)", tag: "TRACEABILITY", accent-color: c-navy, inset: 11pt)[
      #table(
        columns: (1fr, 0.9fr, 1.3fr, 0.8fr),
        stroke: 0.5pt + c-border,
        inset: 5.5pt,
        fill: (x, y) => if y == 0 { c-navy } else if calc.odd(y) { c-bg } else { white },
        [#text(fill: white, weight: "bold")[UR ID]],
        [#text(fill: white, weight: "bold")[PBI]],
        [#text(fill: white, weight: "bold")[Test Case ID]],
        [#text(fill: white, weight: "bold")[Status]],
        [UR-ADM-01], [PBI-03], [TC-ADM-01 (เพิ่มสินค้า)], [#badge("PASS", fill: c-sage-light, text-color: c-sage)],
        [UR-ADM-02], [PBI-02], [TC-ADM-02 (สิทธิ์ Staff)], [#badge("PASS", fill: c-sage-light, text-color: c-sage)],
        [UR-STF-01], [PBI-04], [TC-STF-01 (รับเข้า)], [#badge("PASS", fill: c-sage-light, text-color: c-sage)],
        [UR-STF-02], [PBI-05], [TC-STF-02 (Simple Deduction)], [#badge("PASS", fill: c-sage-light, text-color: c-sage)],
        [UR-STF-03, 04], [PBI-01], [TC-SEC-01, 02 (ความปลอดภัย)], [#badge("PASS", fill: c-sage-light, text-color: c-sage)],
        [UR-NTF-01, 02], [PBI-07, 08], [TC-NTF-01, 02 (Threshold Alert)], [#badge("PASS", fill: c-sage-light, text-color: c-sage)],
      )
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 9: TECHNOLOGY STACK & DEVELOPMENT TOOLS
// ============================================================
#slide-header(
  "DEVELOPMENT ECOSYSTEM",
  "เทคโนโลยีและเครื่องมือพัฒนา (Technology Stack & Tools)",
  subtitle: "โครงสร้างเทคโนโลยีแบบ Lean Architecture และการประยุกต์ใช้ AI ในกระบวนการพัฒนา",
  speaker: "SPEAKER 06"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  [
    #rounded-box(
      title: "Frontend & Client UI",
      tag: grid(
        columns: (auto, auto, auto, auto),
        gutter: 4pt,
        align: horizon,
        icon-pill("icons/html5.svg"),
        icon-pill("icons/css3.svg"),
        icon-pill("icons/javascript.svg"),
        icon-pill("icons/bootstrap.svg")
      ),
      accent-color: c-navy,
      inset: 8.5pt
    )[
      #text(size: 12pt)[
        - *HTML5 & Vanilla JS (ES6+):* โค้ด Native น้ำหนักเบา ไม่พึ่งพา Heavy Framework โหลดเร็ว
        #v(0.2em)
        - *Bootstrap 5 & Custom CSS:* ระบบ Responsive UI ปรับขนาดตามหน้าจออัตโนมัติ
        #v(0.2em)
        - *Dual-View Interface:* หน้าจอ Desktop สำหรับ Admin และ Mobile-First สำหรับ Staff
      ]
    ]
    #v(0.18cm)
    #rounded-box(
      title: "Network & Protocols",
      tag: badge("REST API / LAN", fill: c-sage-light, text-color: c-sage, stroke: 0.5pt + c-sage-border),
      accent-color: c-sage,
      inset: 8.5pt
    )[
      #text(size: 12pt)[
        - *RESTful API Architecture:* สื่อสารแบบ Request-Response ผ่าน JSON Payload รวดเร็ว ไร้คอขวด
        #v(0.2em)
        - *Cross-Device LAN Access:* เชื่อมต่อคอมและมือถือผ่านวง Wi-Fi เดียวกัน ตัดสต็อกหน้าชั้นวางได้จริง
        #v(0.2em)
        - *Stateless Verification:* ตรวจสอบสิทธิ์ด้วย Token ทุกครั้งที่มีการเรียกใช้ API ฝั่งเซิร์ฟเวอร์
      ]
    ]
  ],
  [
    #rounded-box(
      title: "Backend & Data Store",
      tag: grid(
        columns: (auto, auto, auto),
        gutter: 4pt,
        align: horizon,
        icon-pill("icons/nodejs.svg"),
        icon-pill("icons/express.svg"),
        icon-pill("icons/json.svg")
      ),
      accent-color: c-steel,
      inset: 8.5pt
    )[
      #text(size: 12pt)[
        - *Node.js (v20+):* JavaScript Runtime สำหรับเซิร์ฟเวอร์ ประมวลผล Asynchronous I/O คล่องตัว
        #v(0.2em)
        - *Express.js (v5.3):* Web Framework จัดการ Routing, Session Cookie และ Guard Middlewares
        #v(0.2em)
        - *Flat-file JSON Storage:* บันทึกข้อมูลลงไฟล์ JSON โดยตรงแบบ Zero-Config ไม่ต้องติดตั้ง DB แยก
      ]
    ]
    #v(0.18cm)
    #rounded-box(
      title: "AI Assistance & Tooling",
      tag: grid(
        columns: (auto, auto),
        gutter: 5pt,
        align: horizon,
        icon-pill("icons/gemini.svg"),
        icon-pill("icons/antigravity.svg")
      ),
      accent-color: c-terracotta,
      inset: 8.5pt
    )[
      #text(size: 12pt)[
        - *Gemini & Antigravity:* AI Pair Programmer ช่วยออกแบบ Architecture, Refactor โค้ด และ QA
        #v(0.2em)
        - *Typst Typesetting System:* จัดทำเอกสารข้อกำหนดเชิงเทคนิคและสไลด์นำเสนอคุณภาพสูง
        #v(0.2em)
        - *Version Control:* จัดการและส่งมอบซอร์สโค้ดผ่าน Git และ Visual Studio Code
      ]
    ]
  ]
)

#v(0.35em)
#align(center)[
  #badge("LEAN PRINCIPLE: ระบบติดตั้งง่าย ไร้ความซับซ้อนของฐานข้อมูลภายนอก พร้อมใช้งานข้ามอุปกรณ์บนเครือข่าย LAN ทันที", fill: c-navy-light, text-color: c-navy, stroke: 0.5pt + c-navy-border)
]

#pagebreak()

// ============================================================
// SLIDE 10: INTERACTIVE LIVE DEMONSTRATION
// ============================================================
#slide-header(
  "SYSTEM DEMONSTRATION",
  "การสาธิตการทำงานจริง (Interactive Live Demo)",
  subtitle: "จำลองการทำงานประสานกันระหว่างจอคอมพิวเตอร์ (Admin) และโทรศัพท์มือถือ (Staff)",
  speaker: "SPEAKER 06"
)

#rounded-box(title: "Demonstration Roadmap (ลำดับขั้นตอนการสาธิตระบบ: 2–3 นาที)", tag: "LIVE SCENARIOS", accent-color: c-navy, inset: 13pt)[
  #v(0.1cm)
  #grid(
    columns: (1fr, 1fr),
    gutter: 16pt,
    [
      #box(fill: c-navy-light, stroke: 0.5pt + c-navy-border, inset: 10pt, radius: 6pt, width: 100%)[
        #text(weight: "bold", fill: c-navy)[Scenario 01: Admin Dashboard (จอคอมพิวเตอร์)]\
        #v(0.2em)
        - เข้าสู่ระบบด้วยบัญชี Admin บนคอมพิวเตอร์\
        - ตรวจสอบยอดสต็อกภาพรวม และการแจ้งเตือน Low Stock\
        - ชี้ให้เห็นระดับสต็อกของสินค้าตัวอย่างก่อนเริ่มทำรายการ
      ]
      #v(0.4cm)
      #box(fill: c-steel-light, stroke: 0.5pt + c-steel-border, inset: 10pt, radius: 6pt, width: 100%)[
        #text(weight: "bold", fill: c-steel)[Scenario 02: Mobile Stock-Out (โทรศัพท์มือถือ)]\
        #v(0.2em)
        - Staff เข้าสู่ระบบบนโทรศัพท์มือถือ\
        - กดปุ่มสแกนจำลองเพื่อดึงรหัสสินค้า #sym.arrow.r ระบุจำนวนตัดจ่าย\
        - ทำรายการสำเร็จ #sym.arrow.r แสดงใบสำคัญรับ-จ่ายพัสดุ (Ref-ID)
      ]
    ],
    [
      #box(fill: c-sage-light, stroke: 0.5pt + c-sage-border, inset: 10pt, radius: 6pt, width: 100%)[
        #text(weight: "bold", fill: c-sage)[Scenario 03: Data Synchronization (การซิงค์ข้อมูล)]\
        #v(0.2em)
        - รีเฟรชหน้าจอ Admin ยอดคงเหลือลดลงทันที\
        - ป้ายสถานะปรับเป็น Low Stock หรือ Out of Stock อัตโนมัติ\
        - มี Transaction ใหม่ปรากฏในตาราง Recent Activity
      ]
      #v(0.4cm)
      #box(fill: c-terracotta-light, stroke: 0.5pt + c-terracotta-border, inset: 10pt, radius: 6pt, width: 100%)[
        #text(weight: "bold", fill: c-terracotta)[Scenario 04: Security & Boundary Validation]\
        #v(0.2em)
        - Staff ทดสอบพิมพ์ URL `/admin` #sym.arrow.r ระบบดีดกลับหน้าเดิม\
        - ทดสอบเบิกสินค้าเกินยอดคงเหลือ #sym.arrow.r ระบบบล็อกการบันทึก
      ]
    ]
  )
]

#v(0.6em)
#align(center)[
  #badge("NEXT: PROJECT RETROSPECTIVE & FUTURE ROADMAP (ช่วงสรุปผลการประเมินและแผนงานในอนาคต)", fill: c-navy-light, text-color: c-navy, stroke: 0.6pt + c-navy-border)
]

#pagebreak()

// ============================================================
// SLIDE 11: RETROSPECTIVE & FUTURE ROADMAP (สไลด์บทเรียนและแผนงาน - หน้าสุดท้าย)
// ============================================================
#slide-header(
  "PROJECT EVALUATION",
  "บทเรียนจากการพัฒนาและแผนงานอนาคต (Roadmap)",
  subtitle: "การประเมินตนเองตามแนวทาง Agile และแนวทางการต่อยอดสู่ระดับ Production",
  speaker: "SPEAKER 05"
)

#grid(
  columns: (1fr, 1fr, 1.05fr),
  gutter: 14pt,
  [
    #rounded-box(title: "What Went Well (จุดแข็งที่ทำได้ดี)", tag: "STRENGTHS", accent-color: c-sage, inset: 12pt)[
      #v(0.2em)
      - สถาปัตยกรรม 4 ชั้น แยกหน้าที่ชัดเจน ดูแลง่าย
      #v(0.3em)
      - ระบบ RBAC ป้องกันสิทธิ์ทั้งฝั่งหน้าเว็บและ API รัดกุม
      #v(0.3em)
      - Simple Deduction ตัดยอดรวดเร็ว คล่องตัวหน้างาน
      #v(0.3em)
      - มีสลิปและรหัส Ref-ID ตรวจสอบย้อนหลังได้จริง
    ]
  ],
  [
    #rounded-box(title: "Lessons Learned (บทเรียนที่พบ)", tag: "CHALLENGES", accent-color: c-terracotta, inset: 12pt)[
      #v(0.2em)
      - Flat-file JSON มีข้อจำกัดเรื่อง Concurrency หากใช้งานพร้อมกัน
      #v(0.3em)
      - ช่องค้นหาสินค้าควรมีระบบ Autocomplete ช่วยค้นหาเร็วขึ้น
      #v(0.3em)
      - แดชบอร์ดต้องกด Refresh เพื่อดึงข้อมูลใหม่
    ]
  ],
  [
    #rounded-box(title: "Future Roadmap (แผนงานต่อยอด)", tag: "PRODUCTION", accent-color: c-navy, inset: 12pt)[
      #v(0.2em)
      - *Database:* ย้ายสู่ Database จริง (*PostgreSQL*) รองรับ ACID
      #v(0.3em)
      - *Real-time:* ติดตั้ง *WebSocket* ดันยอดสต็อกบนจอ Admin ทันที
      #v(0.3em)
      - *Hardware:* เชื่อมต่อกล้องสแกนบาร์โค้ดจริง
    ]
  ]
)

#v(0.8em)
#align(center)[
  #badge("THANK YOU FOR YOUR ATTENTION • QUESTIONS & ANSWERS (ขอขอบคุณทุกท่าน — เข้าสู่ช่วงถาม-ตอบ)", fill: c-navy-light, text-color: c-navy, stroke: 0.6pt + c-navy-border)
]
