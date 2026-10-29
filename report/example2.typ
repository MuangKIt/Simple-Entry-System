// ============================================================
// EXAMPLE 2: Bento-Box Modular Minimalist
// จุดเด่น: เลย์เอาท์แบบ Bento Grid จัดวางการ์ดขนาดต่างๆ กันอย่างลงตัว
// โทนสีอบอุ่นมินิมอล (Warm Sand, Clay & Olive Sage Palette)
// ============================================================

#set document(title: "Style 2: Bento-Box Modular Minimalist")

#let c-dark       = rgb("#1C2630")
#let c-clay       = rgb("#BC6434")
#let c-clay-light = rgb("#FBF3ED")
#let c-olive      = rgb("#567A62")
#let c-olive-light= rgb("#EEF5F0")
#let c-sand       = rgb("#EBE6DD")
#let c-sand-light = rgb("#F5F2EC")
#let c-bg         = rgb("#F9F8F5")   // Warm Alabaster
#let c-card       = rgb("#FFFFFF")
#let c-text       = rgb("#1D252C")
#let c-muted      = rgb("#6A7785")
#let c-border     = rgb("#E5E0D6")

#set page(
  paper: "presentation-16-9",
  fill: c-bg,
  margin: (x: 1.8cm, top: 1.3cm, bottom: 1.3cm),
  header: none,
  footer: context {
    let p = counter(page).get().first()
    if p > 1 [
      #line(length: 100%, stroke: 0.5pt + c-border)
      #v(0.2em)
      #grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        text(size: 11pt, fill: c-muted)[*STYLE 02 : BENTO-BOX MODULAR* | Simple Entry System | INT-303 Software Engineering],
        text(size: 11pt, weight: "bold", fill: c-dark)[0#p / 04]
      )
    ]
  }
)

#set text(font: ("TH Sarabun New",), size: 15pt, fill: c-text, lang: "th", region: "TH")
#set par(leading: 0.55em, spacing: 0.65em)

#let bento-box(fill: c-card, stroke: 0.6pt + c-border, radius: 8pt, inset: 12pt, body) = block(
  width: 100%,
  fill: fill,
  stroke: stroke,
  radius: radius,
  inset: inset,
  body
)

#let bento-header(category, title, subtitle: none, speaker: none) = [
  #grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [
      #text(size: 10.5pt, weight: "bold", fill: c-clay, tracking: 2pt)[#upper(category)]
      #v(-0.35em)
      #text(size: 22pt, weight: "bold", fill: c-dark)[#title]
      #if subtitle != none [
        #v(-0.4em)
        #text(size: 13pt, fill: c-muted)[#subtitle]
      ]
    ],
    [
      #if speaker != none [
        #box(
          fill: c-sand-light,
          stroke: 0.6pt + c-border,
          inset: (x: 10pt, y: 5pt),
          radius: 12pt,
          text(size: 11pt, weight: "bold", fill: c-dark)[#speaker]
        )
      ]
    ]
  )
  #v(0.4em)
]

// ------------------------------------------------------------
// SLIDE 1: BENTO-BOX COVER
// ------------------------------------------------------------
#page(fill: c-bg, margin: (x: 1.8cm, top: 1.4cm, bottom: 1.4cm), footer: none)[
  #grid(
    columns: (1.5fr, 1fr),
    gutter: 14pt,
    [
      // Hero Card ขนาดใหญ่
      #bento-box(fill: c-dark, inset: 20pt, radius: 10pt)[
        #text(size: 11pt, weight: "bold", fill: c-sand, tracking: 2pt)[
          INT-303 SOFTWARE ENGINEERING
        ]
        #v(0.6cm)
        #text(size: 36pt, weight: "bold", fill: white)[
          Simple Entry\ System
        ]
        #v(0.2cm)
        #text(size: 16pt, fill: rgb("#B5C4D4"))[
          ระบบจัดการสินค้าคงคลังขนาดเล็กตามหลักวิศวกรรมซอฟต์แวร์
        ]
        #v(0.6cm)
        #box(fill: rgb("#2D3B48"), inset: (x: 10pt, y: 5pt), radius: 4pt)[
          #text(size: 11.5pt, fill: c-sand)[Prototype Phase • Standalone Web App • Role-Based Control]
        ]
      ]
    ],
    [
      #grid(
        rows: (auto, 1fr),
        gutter: 14pt,
        [
          // โลโก้และสังกัด
          #bento-box(fill: c-card, inset: 12pt)[
            #grid(
              columns: (1fr, auto),
              align: (left + horizon, right + horizon),
              [
                #text(size: 11.5pt, weight: "bold", fill: c-dark)[THAI-NICHI]\
                #text(size: 10pt, fill: c-muted)[Faculty of IT]
              ],
              [#image("Tni_logo_2.jpg", width: 32pt)]
            )
          ]
        ],
        [
          // ทีมผู้พัฒนา
          #bento-box(fill: c-sand-light, stroke: 0.6pt + c-border, inset: 14pt)[
            #text(size: 11pt, weight: "bold", fill: c-clay, tracking: 1.5pt)[PROJECT TEAM]\
            #v(0.3em)
            #text(size: 12.5pt)[*Coordination:* ชยิน (731), รัฐพงษ์ (236)]\
            #text(size: 12.5pt)[*Development:* กิตติภณ (483), ชิษณุพงศ์ (913)]\
            #text(size: 12.5pt)[*Testing & Demo:* พันธ์ธวัช (044), วีรภัทร (962)]
          ]
        ]
      )
    ]
  )
]

// ------------------------------------------------------------
// SLIDE 2: BENTO REQUIREMENTS GRID (5 กล่องจัดสัดส่วน)
// ------------------------------------------------------------
#bento-header(
  "REQUIREMENTS SPECIFICATION",
  "การจัดกลุ่มความต้องการระบบ (18 User Requirements)",
  subtitle: "ผังโมดูลาร์แสดงขอบเขตและหน้าที่ตามโครงสร้างข้อตกลง SRS",
  speaker: "SPEAKER 02"
)

#grid(
  columns: (1.2fr, 1fr),
  gutter: 12pt,
  [
    #bento-box(fill: c-card)[
      #grid(
        columns: (1fr, auto),
        align: (left, right),
        [#text(size: 14pt, weight: "bold", fill: c-dark)[UR-ADM: Master Management]],
        [#box(fill: c-clay-light, inset: (x: 6pt, y: 2pt), radius: 3pt)[#text(size: 10pt, weight: "bold", fill: c-clay)[4 ITEMS]]]
      )
      #v(0.3em)
      - ควบคุมข้อมูลสินค้าหลัก (Master Data) แต่เพียงผู้เดียว
      - จัดการผู้ใช้งาน กำหนดสิทธิ์ และเปิด/ระงับบัญชี Staff
      - ดูรายงานเชิงบริหารและสถิติภาพรวมแดชบอร์ด
    ]
    #v(0.3cm)
    #bento-box(fill: c-sand-light)[
      #grid(
        columns: (1fr, auto),
        align: (left, right),
        [#text(size: 14pt, weight: "bold", fill: c-dark)[UR-STF: Stock Operations]],
        [#box(fill: c-sand, inset: (x: 6pt, y: 2pt), radius: 3pt)[#text(size: 10pt, weight: "bold", fill: c-dark)[4 ITEMS]]]
      )
      #v(0.3em)
      - บันทึกการรับเข้า (Stock-In) และจ่ายออก (Stock-Out)
      - *Enforced Constraint:* ห้ามแก้ไขสินค้า หรือดูรายงานบริหาร
    ]
  ],
  [
    #bento-box(fill: c-card)[
      #grid(
        columns: (1fr, auto),
        align: (left, right),
        [#text(size: 14pt, weight: "bold", fill: c-dark)[UR-STK: Inventory Core]],
        [#box(fill: c-olive-light, inset: (x: 6pt, y: 2pt), radius: 3pt)[#text(size: 10pt, weight: "bold", fill: c-olive)[5 ITEMS]]]
      )
      #v(0.3em)
      - เก็บข้อมูลพื้นฐาน 4 รายการ (รหัส, ชื่อ, หมวด, คงเหลือ)
      - ตัดสต็อกตรงทันที (Simple Deduction) ไร้คอขวด
    ]
    #v(0.3cm)
    #grid(
      columns: (1fr, 1fr),
      gutter: 8pt,
      [
        #bento-box(fill: c-olive-light, inset: 10pt)[
          #text(size: 12.5pt, weight: "bold", fill: c-olive)[UR-NTF (3 Items)]\
          #text(size: 11.5pt, fill: c-text)[ตรวจเกณฑ์ Threshold และส่งแจ้งเตือน Low Stock]
        ]
      ],
      [
        #bento-box(fill: c-clay-light, inset: 10pt)[
          #text(size: 12.5pt, weight: "bold", fill: c-clay)[UR-GEN (2 Items)]\
          #text(size: 11.5pt, fill: c-text)[เน้นความเรียบง่าย รองรับหลายเบราว์เซอร์]
        ]
      ]
    )
  ]
)

#pagebreak()

// ------------------------------------------------------------
// SLIDE 3: RBAC BENTO GRID
// ------------------------------------------------------------
#bento-header(
  "ACCESS CONTROL MATRIX",
  "ระบบควบคุมสิทธิ์ตามบทบาท (Role-Based Access Control)",
  subtitle: "การแยกพื้นที่การทำงานเพื่อความปลอดภัยของข้อมูลคลังสินค้า",
  speaker: "SPEAKER 03"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  [
    #bento-box(fill: c-card, inset: 14pt)[
      #box(fill: c-dark, inset: (x: 8pt, y: 3pt), radius: 3pt)[
        #text(size: 10.5pt, weight: "bold", fill: white)[ADMINISTRATION (DESKTOP)]
      ]
      #v(0.3em)
      #text(size: 15pt, weight: "bold", fill: c-dark)[ผู้ดูแลระบบ / หัวหน้าคลัง]\
      #v(0.3em)
      - สิทธิ์สมบูรณ์ในการเพิ่ม/แก้ไข/ลบ ข้อมูลสินค้า
      - เปิดและระงับการเข้าถึงของบัญชีพนักงาน
      - กำหนดค่า Threshold แจ้งเตือนสินค้าใกล้หมด
      - เรียกดูแดชบอร์ดสรุปยอดรวม และ Export CSV
    ]
  ],
  [
    #bento-box(fill: c-sand-light, inset: 14pt)[
      #box(fill: c-clay, inset: (x: 8pt, y: 3pt), radius: 3pt)[
        #text(size: 10.5pt, weight: "bold", fill: white)[STAFF OPERATIONS (MOBILE)]
      ]
      #v(0.3em)
      #text(size: 15pt, weight: "bold", fill: c-dark)[พนักงานคลังสินค้า]\
      #v(0.3em)
      - สแกนและบันทึกรับเข้าสินค้า (Stock In)
      - บันทึกจ่ายออกสินค้า (Stock Out)
      - ตรวจเช็คยอดสต็อกคงเหลือหน้างาน (Check Stock)
      - *Blocked:* ไม่อนุญาตให้แก้ไข Master Data ใดๆ
    ]
  ]
)

#v(0.3cm)
#bento-box(fill: c-olive-light, stroke: 0.5pt + c-olive, inset: 10pt)[
  #grid(
    columns: (auto, 1fr, 1fr),
    gutter: 12pt,
    align: (center + horizon, left + horizon, left + horizon),
    [
      #box(fill: c-olive, inset: 6pt, radius: 4pt)[
        #text(size: 11pt, weight: "bold", fill: white)[TWO-TIER GUARD]
      ]
    ],
    [
      *1. Page Auth Guard:* ดีดกลับหน้าเดิมทันทีเมื่อพยายามพิมพ์ URL ข้ามสิทธิ์
    ],
    [
      *2. API Auth Guard:* ปฏิเสธคำขอและคืนค่า `403 Forbidden` ที่ระดับเซิร์ฟเวอร์
    ]
  )
]

#pagebreak()

// ------------------------------------------------------------
// SLIDE 4: QA METRICS & TRACEABILITY BENTO
// ------------------------------------------------------------
#bento-header(
  "VERIFICATION & AUDIT",
  "ผลการทดสอบระบบและ Traceability Matrix",
  subtitle: "การยืนยันความถูกต้องของฟังก์ชันและการตรวจสอบย้อนกลับ",
  speaker: "SPEAKER 05"
)

#grid(
  columns: (1fr, 1.6fr),
  gutter: 14pt,
  [
    // Metric Card โดดเด่น
    #bento-box(fill: c-olive-light, stroke: 0.8pt + c-olive, inset: 16pt)[
      #text(size: 11pt, weight: "bold", fill: c-olive, tracking: 1.5pt)[TEST PASS RATE]\
      #text(size: 44pt, weight: "bold", fill: c-olive)[100%]\
      #text(size: 14pt, weight: "bold", fill: c-dark)[ผ่านครบ 10 / 10 Test Cases]\
      #v(0.4em)
      #text(size: 12pt, fill: c-muted)[
        • Functional Logic: Pass\
        • Security RBAC: Pass\
        • Multi-browser: Pass
      ]
    ]
  ],
  [
    #bento-box(fill: c-card, inset: 10pt)[
      #text(size: 13.5pt, weight: "bold", fill: c-dark)[Requirements Traceability Matrix]\
      #v(0.3em)
      #table(
        columns: (1fr, 0.9fr, 1.4fr, 0.7fr),
        stroke: 0.5pt + c-border,
        inset: 5pt,
        fill: (x, y) => if y == 0 { c-sand-light } else { white },
        [*UR ID*], [*PBI*], [*Test Case*], [*Result*],
        [UR-ADM-01..02], [PBI-02, 03], [TC-ADM-01, 02 (Master & Staff)], [#text(fill: c-olive, weight: "bold")[PASS]],
        [UR-STF-01..02], [PBI-04, 05], [TC-STF-01, 02 (Stock In/Out)], [#text(fill: c-olive, weight: "bold")[PASS]],
        [UR-STF-03..04], [PBI-01], [TC-SEC-01, 02 (Security RBAC)], [#text(fill: c-olive, weight: "bold")[PASS]],
        [UR-NTF-01..02], [PBI-07, 08], [TC-NTF-01, 02 (Low Stock Alert)], [#text(fill: c-olive, weight: "bold")[PASS]],
        [UR-GEN-01..02], [PBI-10], [TC-WEB-01 (Cross-browser)], [#text(fill: c-olive, weight: "bold")[PASS]]
      )
    ]
  ]
)
