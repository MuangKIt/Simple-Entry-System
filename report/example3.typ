// ============================================================
// EXAMPLE 3: Monolith Dark Technical Minimalist
// จุดเด่น: ธีมมืดทั้งชุด (Dark Mode Presentation), ดีไซน์สไตล์ Developer/Tech Stack,
// ตัวเลขนีออนพาสเทล (Cyan & Amber Accents) ปราศจาก Emoji
// ============================================================

#set document(title: "Style 3: Monolith Dark Technical Minimalist")

#let c-bg         = rgb("#0F172A")   // Deep Space Slate
#let c-card       = rgb("#1E293B")   // Elevated Card Surface
#let c-border     = rgb("#334155")   // Subtle Border
#let c-cyan       = rgb("#38BDF8")   // Tech Cyan Accent
#let c-cyan-glow  = rgb("#0C4A6E")
#let c-mint       = rgb("#2DD4BF")   // Success Mint Green
#let c-mint-glow  = rgb("#134E4A")
#let c-amber      = rgb("#F59E0B")   // Warning Amber Ochre
#let c-amber-glow = rgb("#78350F")
#let c-text       = rgb("#F8FAFC")   // Crisp White Text
#let c-muted      = rgb("#94A3B8")   // Muted Slate Text

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
        text(size: 11pt, fill: c-muted)[*STYLE 03 : MONOLITH DARK* | Simple Entry System | INT-303 Software Engineering],
        text(size: 11pt, weight: "bold", fill: c-cyan)[0#p / 04]
      )
    ]
  }
)

#set text(font: ("TH Sarabun New",), size: 15pt, fill: c-text, lang: "th", region: "TH")
#set par(leading: 0.55em, spacing: 0.65em)

#let tech-card(title: none, tag: none, accent: c-cyan, inset: 12pt, body) = block(
  width: 100%,
  fill: c-card,
  stroke: 0.6pt + c-border,
  radius: 6pt,
  clip: true,
  [
    #if accent != none [
      #rect(width: 100%, height: 2.5pt, fill: accent)
    ]
    #pad(x: inset, top: if accent != none { inset - 3pt } else { inset }, bottom: inset)[
      #if title != none or tag != none [
        #grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          [#if title != none [ #text(size: 15.5pt, weight: "bold", fill: c-text)[#title] ]],
          [#if tag != none [ #box(fill: c-bg, stroke: 0.5pt + c-border, inset: (x: 7pt, y: 3pt), radius: 3pt)[#text(size: 10pt, weight: "bold", fill: accent)[#tag]] ]]
        )
        #v(0.4em)
      ]
      #body
    ]
  ]
)

#let tech-header(category, title, subtitle: none, speaker: none) = [
  #grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [
      #text(size: 10.5pt, weight: "bold", fill: c-cyan, tracking: 2pt)[#upper(category)]
      #v(-0.35em)
      #text(size: 23pt, weight: "bold", fill: c-text)[#title]
      #if subtitle != none [
        #v(-0.4em)
        #text(size: 13pt, fill: c-muted)[#subtitle]
      ]
    ],
    [
      #if speaker != none [
        #box(
          fill: c-card,
          stroke: 0.6pt + c-cyan,
          inset: (x: 10pt, y: 5pt),
          radius: 3pt,
          text(size: 11pt, weight: "bold", fill: c-cyan)[#speaker]
        )
      ]
    ]
  )
  #v(0.2em)
  #line(length: 100%, stroke: 0.5pt + c-border)
  #v(0.5em)
]

// ------------------------------------------------------------
// SLIDE 1: TECH MONOLITH COVER
// ------------------------------------------------------------
#page(fill: c-bg, margin: (x: 2.2cm, top: 1.8cm, bottom: 1.8cm), footer: none)[
  #grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    [
      #text(size: 11.5pt, weight: "bold", fill: c-muted, tracking: 2pt)[
        TNI • FACULTY OF INFORMATION TECHNOLOGY
      ]
    ],
    [#image("Tni_logo_2.jpg", width: 11%)]
  )

  #v(1.2cm)
  #box(fill: c-card, stroke: 0.5pt + c-cyan, inset: (x: 8pt, y: 3pt), radius: 3pt)[
    #text(size: 11pt, weight: "bold", fill: c-cyan)[INT-303 SOFTWARE ENGINEERING]
  ]
  #v(0.3cm)

  #text(size: 38pt, weight: "bold", fill: c-text)[
    Simple Entry System
  ]
  #v(-0.2em)
  #text(size: 20pt, fill: c-muted)[
    ระบบบันทึกและจัดการคลังสินค้าแบบ Standalone ตามหลักวิศวกรรมซอฟต์แวร์
  ]

  #v(1cm)
  #line(length: 100%, stroke: 0.5pt + c-border)
  #v(0.4cm)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 14pt,
    [
      #text(size: 11pt, weight: "bold", fill: c-cyan)[COORDINATION & RE]\
      #v(0.2em)
      #text(size: 13pt)[ชยิน น้ำจันทร์ (731)]\
      #text(size: 13pt)[รัฐพงษ์ เกิดมงคล (236)]
    ],
    [
      #text(size: 11pt, weight: "bold", fill: c-mint)[ARCHITECTURE & DEV]\
      #v(0.2em)
      #text(size: 13pt)[กิตติภณ เรื่องวีระชัยกุล (483)]\
      #text(size: 13pt)[ชิษณุพงศ์ เผือกพ่วง (913)]
    ],
    [
      #text(size: 11pt, weight: "bold", fill: c-amber)[TESTING & DEMO]\
      #v(0.2em)
      #text(size: 13pt)[พันธ์ธวัช ชัยศรี (044)]\
      #text(size: 13pt)[วีรภัทร อนุโรจน์ (962)]
    ]
  )
]

// ------------------------------------------------------------
// SLIDE 2: CORE MECHANICS MONITOR (DARK HUD STYLE)
// ------------------------------------------------------------
#tech-header(
  "LOGIC ENGINE",
  "กลไกการตัดสต็อกและการคำนวณสถานะ (Core Engine)",
  subtitle: "Simple Deduction Mechanism ไร้คอขวด พร้อมระบบป้องกันสต็อกติดลบ",
  speaker: "SPEAKER 04"
)

#grid(
  columns: (1.1fr, 1fr),
  gutter: 16pt,
  [
    #tech-card(title: "Simple Deduction Workflow", tag: "DEDUCTION LOGIC", accent: c-mint)[
      #grid(
        columns: (auto, 1fr),
        gutter: 8pt,
        align: (left + top, left + top),
        [#box(fill: c-mint-glow, inset: 4pt, radius: 2pt)[#text(size: 11pt, weight: "bold", fill: c-mint)[01]]],
        [*Stock-In Flow:* ระบุ SKU #sym.arrow.r จำนวน N #sym.arrow.r สต็อก +N ทันที #sym.arrow.r Log Txn #sym.arrow.r ออกสลิป],
        
        [#box(fill: c-mint-glow, inset: 4pt, radius: 2pt)[#text(size: 11pt, weight: "bold", fill: c-mint)[02]]],
        [*Stock-Out Flow:* ระบุ SKU #sym.arrow.r จำนวน M #sym.arrow.r *ตรวจยอดคงเหลือ* #sym.arrow.r สต็อก -M #sym.arrow.r ตรวจ Threshold],
        
        [#box(fill: c-amber-glow, inset: 4pt, radius: 2pt)[#text(size: 11pt, weight: "bold", fill: c-amber)[03]]],
        [*Zero-Negative Rule:* ปฏิเสธรายการทันทีหากยอดเบิกมากกว่าคงเหลือ (ห้ามติดลบ)]
      )
    ]
  ],
  [
    #tech-card(title: "Real-time Threshold Calculation", tag: "STATUS MONITOR", accent: c-amber)[
      #box(fill: c-bg, stroke: 0.5pt + rgb("#7F1D1D"), inset: 8pt, radius: 4pt, width: 100%)[
        #grid(
          columns: (1fr, auto),
          [#text(weight: "bold")[Stock = 0 ชิ้น]],
          [#box(fill: rgb("#7F1D1D"), inset: (x: 6pt, y: 2pt), radius: 3pt)[#text(size: 10pt, weight: "bold", fill: white)[OUT OF STOCK]]]
        )
      ]
      #v(0.3em)
      #box(fill: c-bg, stroke: 0.5pt + c-amber, inset: 8pt, radius: 4pt, width: 100%)[
        #grid(
          columns: (1fr, auto),
          [#text(weight: "bold")[Stock <= Threshold]],
          [#box(fill: c-amber-glow, stroke: 0.5pt + c-amber, inset: (x: 6pt, y: 2pt), radius: 3pt)[#text(size: 10pt, weight: "bold", fill: c-amber)[LOW STOCK ALERT]]]
        )
      ]
      #v(0.3em)
      #box(fill: c-bg, stroke: 0.5pt + c-mint, inset: 8pt, radius: 4pt, width: 100%)[
        #grid(
          columns: (1fr, auto),
          [#text(weight: "bold")[Stock > Threshold]],
          [#box(fill: c-mint-glow, stroke: 0.5pt + c-mint, inset: (x: 6pt, y: 2pt), radius: 3pt)[#text(size: 10pt, weight: "bold", fill: c-mint)[IN STOCK (NORMAL)]]]
        )
      ]
    ]
  ]
)

#pagebreak()

// ------------------------------------------------------------
// SLIDE 3: INTERACTIVE DEMO MISSION BOARD (4 QUADRANTS)
// ------------------------------------------------------------
#tech-header(
  "RUNBOOK DEMONSTRATION",
  "การสาธิตระบบจริง (Interactive Live Demo)",
  subtitle: "การจำลองการทำงานประสานกันระหว่างคอมพิวเตอร์และโทรศัพท์มือถือ",
  speaker: "SPEAKER 06 (DEV)"
)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  [
    #tech-card(title: "Step 01: Admin Dashboard", tag: "DESKTOP", accent: c-cyan)[
      - ล็อกอินด้วยบัญชี Admin บนคอมพิวเตอร์\
      - ตรวจสอบยอดรวมสต็อก และป้ายเตือน Low Stock ก่อนเริ่ม
    ]
    #v(0.3cm)
    #tech-card(title: "Step 02: Mobile Stock-Out", tag: "SMARTPHONE", accent: c-mint)[
      - Staff ล็อกอินผ่านโทรศัพท์มือถือ\
      - กดปุ่ม Scan จำลองเพื่อดึง SKU #sym.arrow.r ระบุจำนวนจ่ายออก #sym.arrow.r ออกสลิป
    ]
  ],
  [
    #tech-card(title: "Step 03: Data Synchronization", tag: "SYNC AUDIT", accent: c-mint)[
      - รีเฟรชหน้าจอ Admin ยอดคงเหลือลดลงทันที\
      - บันทึก Transaction ใหม่ปรากฏบนตาราง Recent Activity
    ]
    #v(0.3cm)
    #tech-card(title: "Step 04: Security Defense Test", tag: "SECURITY", accent: c-amber)[
      - Staff แอบพิมพ์ URL ข้ามไป `/admin` #sym.arrow.r ระบบเตะกลับทันที\
      - ทดสอบจ่ายออกเกินจำนวนคงเหลือ #sym.arrow.r ระบบบล็อกการบันทึก
    ]
  ]
)

#pagebreak()

// ------------------------------------------------------------
// SLIDE 4: RETROSPECTIVE & ROADMAP (3 PILLARS)
// ------------------------------------------------------------
#tech-header(
  "PROJECT POST-MORTEM",
  "บทเรียนจากการพัฒนาและแผนงานอนาคต (Roadmap)",
  subtitle: "การประเมินผลตามแนวทาง Agile และการต่อยอดสู่ระดับ Production",
  speaker: "SPEAKER 05"
)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  [
    #tech-card(title: "What Went Well", tag: "STRENGTHS", accent: c-mint)[
      - สถาปัตยกรรม Layered ชัดเจน
      - ระบบ RBAC ป้องกันสิทธิ์รัดกุม
      - Simple Deduction ตัดยอดรวดเร็ว
      - มี Ref-ID ติดตามได้จริง
    ]
  ],
  [
    #tech-card(title: "Lessons Learned", tag: "CHALLENGES", accent: c-amber)[
      - Flat-file JSON มีข้อจำกัด Concurrency
      - ควรเพิ่ม Autocomplete ในช่องค้นหา
      - แดชบอร์ดต้องกด Refresh เพื่อซิงค์
    ]
  ],
  [
    #tech-card(title: "Production Roadmap", tag: "NEXT ITERATION", accent: c-cyan)[
      - *Database:* ย้ายสู่ PostgreSQL / MySQL
      - *Real-time:* ติดตั้ง WebSocket Push Alert
      - *Hardware:* เชื่อมต่อกล้องสแกนบาร์โค้ดจริง
    ]
  ]
)

#v(0.6em)
#align(center)[
  #box(fill: c-card, stroke: 0.5pt + c-cyan, inset: (x: 14pt, y: 6pt), radius: 4pt)[
    #text(size: 13pt, weight: "bold", fill: c-cyan)[Q&A SESSION • THANK YOU FOR YOUR TIME]
  ]
]
