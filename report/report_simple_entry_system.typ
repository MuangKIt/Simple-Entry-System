// ============================================================
// รายงานการพัฒนาซอฟต์แวร์ตามหลักวิศวกรรมซอฟต์แวร์
// ระบบจัดการสินค้า (Simple Entry System)
// คอมไพล์: typst compile report_simple_entry_system.typ
// ต้องติดตั้งฟอนต์ TH Sarabun New (Thai Sarabun New) ในเครื่อง
// ============================================================

#let thai-font = ("TH Sarabun New",)
#let navy = rgb("#1F3864")

#set document(title: "รายงานการพัฒนาซอฟต์แวร์ ระบบจัดการสินค้า (Simple Entry System)")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2.5cm),
  numbering: "1",
  number-align: center,
)
#set text(font: thai-font, size: 16pt, lang: "th", region: "TH")
#set par(leading: 0.75em, spacing: 1em, first-line-indent: 0pt)
#set heading(numbering: "1.1")
#set list(indent: 1em)
#set enum(indent: 1em)

#show heading.where(level: 1): it => {
  v(0.6em)
  text(size: 22pt, weight: "bold", fill: navy, it)
  v(0.3em)
}
#show heading.where(level: 2): it => {
  v(0.4em)
  text(size: 18pt, weight: "bold", fill: navy, it)
  v(0.15em)
}
#show heading.where(level: 3): it => {
  v(0.3em)
  text(size: 16pt, weight: "bold", it)
}

#show figure.where(kind: table): set figure(supplement: [ตาราง])
#show figure.where(kind: image): set figure(supplement: [รูปที่])
#show figure.where(kind: table): set figure.caption(position: top)
#show figure: set block(breakable: true)
#show figure.caption: set text(size: 15pt)

// ---------- ตัวช่วยจัดรูปแบบ ----------
#show table.cell.where(y: 0): set text(fill: white, weight: "bold")
#set table(
  stroke: 0.5pt + luma(150),
  inset: 6pt,
  fill: (x, y) => if y == 0 { navy } else if calc.odd(y) { luma(243) } else { white },
)

#let box-step(body) = box(
  stroke: 0.8pt + navy, inset: 6pt, radius: 3pt, fill: rgb("#E8EEF8"), body,
)
#let arrow = h(4pt) + sym.arrow.r + h(4pt)
#let note(body) = block(
  width: 100%, inset: 10pt, radius: 3pt, fill: rgb("#FFF8E1"),
  stroke: (left: 3pt + rgb("#F9A825")), body,
)

// ============================================================
// หน้าปก
// ============================================================
#page(numbering: none)[
  #align(center)[
    #image("Tni_logo_2.jpg", width: 30%)                     
    #v(0.8cm)
    #text(size: 24pt, weight: "bold")[ระบบจัดการสินค้า (Simple Entry System)]
    
    
    #text(size: 18pt)[จัดทำโดย]
#v(0.5cm)

#align(center)[
  #grid(
    columns: (auto, auto),
    gutter: 0.8em,             
    align: (left, left),       
    [นายชยิน น้ำจันทร์], [2413110731],
    [นายรัฐพงษ์ เกิดมงคล], [2413110236],
    [นายกิตติภณ เรืองวิริยะชัยกุล], [2413110483],
    [นายชิษณุพงศ์ เผือกพ่วง], [2413110913],
    [นายพันธ์ธวัช ชัยศรี ],[2413111044],
    [นายวีรภัทร อนุโรจน์],[2413110962]
  )                          
]
    #v(2cm)
    #v(0.5cm)
    #text(size: 18pt)[เสนอ\ อ.ดร.สะพรั่งสิทธิ์ มฤทุสาธร \ รายงานนี้เป็นส่วนนึงของรายวิชา INT-303 Software Engineering \ หลักสูตรวิทยาศาสตรบัณฑิต สาขาวิชาเทคโนโลยีสารสนเทศ ปีการศึกษา 2569 \ สถาบันเทคโนโลยีไทย-ญี่ปุ่น]
  ]
]
//=============================================================
// คำนำ
//=============================================================
#page(numbering: none)[#align(center)[
    #text(size: 18pt, weight: "bold")[คำนำ]
  ]
  #v(1em)

  // ตั้งค่าการย่อหน้าและความสูงของบรรทัด
  #set par(justify: true, leading: 0.8em, first-line-indent: 2.5em)

  รายงานฉบับนี้จัดทำขึ้นเพื่อบันทึกกระบวนการพัฒนาระบบจัดการสินค้า (Simple Entry System) ซึ่งเป็น Web Application สำหรับบริหารจัดการสินค้าคงคลัง โดยดำเนินงานตามหลักวิศวกรรมซอฟต์แวร์และใช้แนวทางการพัฒนาแบบ Agile Scrum เป็นส่วนหนึ่งของรายวิชา INT-303 Software Engineering

  เนื้อหาในรายงานครอบคลุมแนวทางการพัฒนา โครงสร้างทีมและรูปแบบการประชุม ขั้นตอนการทำงานในแต่ละ Sprint การวางแผนโครงการและความต้องการ การออกแบบระบบ การพัฒนา และการทดสอบ นอกจากนี้ยังสรุปปัญหาที่พบ วิธีการจัดการ พัฒนาการของโครงการ และบทเรียนที่ได้รับ พร้อมรวบรวมแหล่งอ้างอิง แม่แบบเอกสาร เครื่องมือ และองค์ความรู้ที่ใช้ตลอดการดำเนินงาน

  ผู้จัดทำขอขอบคุณสมาชิกกลุ่ม 9 ในฐานะตัวแทนผู้ใช้งาน ที่ให้ข้อมูลความต้องการ ร่วมทบทวนเอกสาร และให้ข้อเสนอแนะอันเป็นประโยชน์ รวมถึงสมาชิกกลุ่ม 2 ที่ร่วมกันดำเนินงานจนโครงการสำเร็จลุล่วง ขอขอบคุณอาจารย์ผู้สอนที่ให้คำแนะนำและแนวทางตลอดการทำงาน

  หวังเป็นอย่างยิ่งว่ารายงานฉบับนี้จะเป็นประโยชน์ต่อผู้ที่สนใจศึกษากระบวนการพัฒนาซอฟต์แวร์ และเป็นแนวทางในการพัฒนาระบบลักษณะใกล้เคียงกันต่อไป หากมีข้อบกพร่องประการใด ผู้จัดทำขอน้อมรับไว้และพร้อมนำไปปรับปรุงแก้ไขในโอกาสต่อไป]

// ============================================================
// สารบัญ
// ============================================================
#page(numbering: "i")[
  #outline(title: [สารบัญ], depth: 2, indent: 1.5em)
  #v(1em)
  #outline(title: [สารบัญตาราง], target: figure.where(kind: table))
]
#counter(page).update(1)

// ============================================================
= บทนำ
// ============================================================

== ความเป็นมาและวัตถุประสงค์

ระบบจัดการสินค้า (Simple Entry System) เป็นระบบ Web Application แบบ Standalone ที่พัฒนาขึ้นเพื่อทดแทนกระบวนการบันทึกข้อมูลสินค้าคงคลังแบบเดิมภายในโรงงาน/คลังสินค้า โดยเน้นการทำงานเชิงกระบวนการ (System-oriented) ความรวดเร็วในการบันทึกข้อมูล และความง่ายในการใช้งาน มากกว่าความสวยงามของหน้าจอ

รายงานฉบับนี้จัดทำขึ้นเพื่อ

+ สรุปกระบวนการพัฒนาซอฟต์แวร์ตามหลักวิศวกรรมซอฟต์แวร์ ตั้งแต่การเก็บความต้องการ การออกแบบโครงสร้าง การพัฒนา การทดสอบ จนถึงการส่งมอบ
+ บันทึกการประชุมและผลลัพธ์ที่ได้จากการประชุม Requirement Engineering
+ อธิบายโครงสร้างระบบและกระบวนการทำงานของระบบ
+ กำหนดกรอบการทำงานแบบ Sprint (Agile Scrum) พร้อมแผน Sprint และเกณฑ์การตรวจรับงาน
+ สรุปผลการทดสอบและข้อเสนอแนะสำหรับรอบถัดไป

== ขอบเขตของระบบ

ระบบรองรับการทำงานหลัก 3 ส่วน ได้แก่ (1) การบริหารจัดการข้อมูลหลัก (Master Data) และผู้ใช้งานโดย Admin (2) การรับเข้า–จ่ายออกสินค้า (Stock-In / Stock-Out) โดย Staff และ (3) การแจ้งเตือนเมื่อสินค้าใกล้หมด (Low Stock Notification)

*สิ่งที่อยู่นอกขอบเขตในระยะนี้ (Out-of-Scope)*

- การทดสอบ UI/UX ด้านความสวยงามของหน้าจอ
- ขั้นตอนอนุมัติรายการ (Approval Flow) และระบบล็อคข้อมูลที่ซับซ้อน (Data Locking)
- การเชื่อมต่อกับระบบภายนอก (Integration)
- ความต้องการเชิงระบบ (System Requirements) ซึ่งจะจัดทำในเอกสารฉบับถัดไป

== คำศัพท์และคำย่อ

#figure(
  table(
    columns: (auto, 1fr),
    table.header([คำศัพท์], [คำจำกัดความ]),
    [UR], [User Requirement: ความต้องการของผู้ใช้งาน],
    [Admin], [ผู้ดูแลระบบ/เจ้าของโรงงาน/ผู้ดูแลคลังสินค้า มีสิทธิ์สูงสุดในการควบคุมข้อมูลหลัก],
    [Staff], [พนักงานคลังสินค้า มีหน้าที่บันทึกรับเข้าและจ่ายออกสินค้าเท่านั้น],
    [SKU], [Stock Keeping Unit: หน่วยสินค้าคงคลังที่ระบุด้วยรหัสสินค้า],
    [Simple Deduction], [การตัดยอดสต็อกแบบตรงไปตรงมาจากยอดคงเหลือของ SKU โดยไม่มีขั้นตอนอนุมัติ],
    [Low Stock Notification], [การแจ้งเตือนเมื่อจำนวนคงเหลือต่ำกว่าค่าขั้นต่ำ (Threshold)],
    [RBAC], [Role-Based Access Control: การควบคุมสิทธิ์ตามบทบาทผู้ใช้งาน],
    [PBI], [Product Backlog Item: รายการงานใน Product Backlog],
    [DoR / DoD], [Definition of Ready / Definition of Done],
  ),
  caption: [คำศัพท์และคำย่อที่ใช้ในรายงาน],
)

// ============================================================
= กระบวนการพัฒนาซอฟต์แวร์
// ============================================================

== การเลือกรูปแบบกระบวนการ (Process Model)

ทีมพัฒนาเลือกใช้ *Agile Scrum* เป็นกรอบการทำงานหลัก โดยใช้การเก็บความต้องการเชิงปริมาณแบบ Requirement Engineering ในช่วงต้นเป็นฐาน (Baseline) แล้วพัฒนาแบบวนซ้ำเป็น Sprint ละ 2 สัปดาห์ เหตุผลในการเลือกมีดังนี้

#figure(
  table(
    columns: (auto, 1fr),
    table.header([ปัจจัย], [เหตุผลที่สนับสนุน Agile Scrum]),
    [ความต้องการยังมีประเด็นเปิด], [เอกสาร SRS ฉบับร่างครั้งที่ 1 มี Open Issues 3 ข้อ (สิทธิ์ตั้งค่า Threshold, Authentication/Authorization, ช่องทางแจ้งเตือน) จึงต้องการกระบวนการที่รองรับการเปลี่ยนแปลง],
    [ขนาดระบบเล็ก], [มี 4 กลุ่มฟังก์ชันหลัก ทีมขนาดเล็กสามารถส่งมอบเป็นส่วนย่อย (Increment) ได้เร็ว],
    [ผู้ใช้เข้าถึงได้ง่าย], [ตัวแทนผู้ใช้ (กลุ่ม 9) สามารถให้ข้อมูลย้อนกลับในทุก Sprint Review],
    [เน้นความเรียบง่าย], [ข้อจำกัดของระบบ (No Approval Flow, ไม่มี Data Locking ซับซ้อน) ทำให้ลดความเสี่ยงด้านสถาปัตยกรรม],
    [ต้องตรวจสอบย้อนกลับได้], [ใช้รหัส UR เป็นตัวเชื่อม Backlog → โค้ด → Test Case (Traceability)],
  ),
  caption: [เหตุผลในการเลือก Agile Scrum],
)

== ภาพรวมวงจรชีวิตการพัฒนา (SDLC Overview)

#align(center)[
  #box-step[1. เก็บความต้องการ\ (RE Meeting)] #arrow
  #box-step[2. วิเคราะห์และจัดทำ SRS] #arrow
  #box-step[3. ออกแบบระบบ] #arrow
  #box-step[4. พัฒนาเป็น Sprint] #arrow
  #box-step[5. ทดสอบ (Test Plan/Execution)] #arrow
  #box-step[6. ส่งมอบและบำรุงรักษา]
]

#v(0.5em)
#figure(
  table(
    columns: (auto, 1fr, 1fr),
    table.header([ระยะ], [กิจกรรมหลัก], [ผลงานที่ส่งมอบ (Work Product)]),
    [เก็บความต้องการ], [สัมภาษณ์ผู้เกี่ยวข้อง ประชุม Requirement Engineering กลุ่ม 2 และกลุ่ม 9], [บันทึกการสัมภาษณ์, รายงานการประชุม],
    [วิเคราะห์และกำหนด], [จัดกลุ่มความต้องการ ให้รหัส กำหนดความสำคัญ ระบุแหล่งที่มา], [SRS ฉบับร่างครั้งที่ 1 (User Requirements)],
    [ออกแบบ], [ออกแบบสถาปัตยกรรม โมเดลข้อมูล สิทธิ์ผู้ใช้ และ Flow การทำงาน], [เอกสารออกแบบ, ER Diagram, Flow Diagram],
    [พัฒนา], [เขียนโปรแกรมตาม Sprint Backlog, Code Review, Unit Test], [Increment ที่ใช้งานได้ทุก Sprint],
    [ทดสอบ], [จัดทำ Test Plan และบันทึกผล Test Execution], [Test Plan & Test Execution Document],
  ),
  caption: [กิจกรรมและผลงานที่ส่งมอบในแต่ละระยะของ SDLC],
)

// ============================================================
= โครงสร้างทีมและบทบาท
// ============================================================

== ผู้เกี่ยวข้อง (Stakeholders)

#figure(
  table(
    columns: (auto, auto, 1fr, auto),
    table.header([กลุ่ม], [บทบาท], [ชื่อ], [รหัส]),
    [กลุ่ม 2], [Coordinator], [นายชยิน น้ำจันทร์], [2413110731],
    [กลุ่ม 2], [Dev], [นายชิษณุพงศ์ เผือกพ่วง], [2413110913],
    [กลุ่ม 2], [Dev], [นายกิตติภณ เรืองวีระชัยกุล],[2413110483],
    [กลุ่ม 9], [User], [นายอังศวีร์ พงษ์เกษมพรกุล], [2413170024],
    [กลุ่ม 9], [User], [นายกมลทรรศน์ ประดิษฐ์พฤกษ์], [2413110277],
  ),
  caption: [รายชื่อผู้เกี่ยวข้องของ SRS],
)

== การกำหนดบทบาทตามกรอบ Scrum

#figure(
  table(
    columns: (auto, auto, 1fr),
    table.header([บทบาท Scrum], [ผู้รับผิดชอบ (เสนอ)], [ความรับผิดชอบ]),
    [Product Owner], [ตัวแทนสมาชิกของทีม 2], [ยืนยันความต้องการ จัดลำดับความสำคัญของ Product Backlog ตัดสินใจรับ/ไม่รับงานใน Sprint Review],
    [Scrum Master / Coordinator], [นายชยิน น้ำจันทร์], [อำนวยการประชุม Scrum Events กำจัดอุปสรรค ประสานงานระหว่างกลุ่ม รักษากระบวนการ],
    [Development Team], [นายกิตติภณ เรืองวีระชัยกุล \ นายชิษณุพงศ์ เผือกพ่วง], [วิเคราะห์ ออกแบบ พัฒนา ทดสอบ และส่งมอบ Increment ตาม Sprint Goal],
  ),
  caption: [การกำหนดบทบาทตามกรอบ Scrum (ข้อเสนอ)],
)



== โครงสร้างการสื่อสาร

- *ภายในทีมพัฒนา:* Daily Scrum และช่องทางแชตของทีม
- *ทีมพัฒนา ↔ ผู้ใช้:* Sprint Review และการประชุมทบทวนความต้องการ


// ============================================================
= การประชุมตามหลัก Requirement Engineering
// ============================================================

== เทคนิคการเก็บความต้องการ

ทีมใช้เทคนิค *การสัมภาษณ์ผู้เกี่ยวข้อง (Stakeholder Interview)* เป็นหลัก โดยจัดประชุมระหว่างกลุ่ม 2 (ทีมพัฒนา) และกลุ่ม 9 (ผู้ใช้) ผลการสัมภาษณ์ถูกนำมาจัดทำเป็น SRS ตามโครงสร้าง IEEE 830-1998 และ ISO/IEC/IEEE 29148:2018

== กระบวนการประชุม Requirement Engineering

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    table.header([ขั้นตอน], [กิจกรรม], [ผลลัพธ์]),
    [1. เตรียมการ], [กำหนดวาระ รายชื่อผู้เข้าร่วม และคำถามสัมภาษณ์], [วาระการประชุม],
    [2. ดำเนินการสัมภาษณ์], [สอบถามเรื่องบทบาทผู้ใช้ งานของ Admin/Staff กลไกตัดสต็อก และการแจ้งเตือน], [บันทึกการสัมภาษณ์ (หัวข้อ 2.1 – 3.3)],
    [3. วิเคราะห์], [จัดกลุ่ม ให้รหัส UR กำหนดความสำคัญ (สูง/กลาง/ต่ำ) ระบุแหล่งที่มา], [ตาราง User Requirements],
    [4. ตรวจสอบ], [ตรวจความขัดแย้งและความไม่ครบถ้วน], [รายการ Open Issues],
    [5. ยืนยัน], [ให้ผู้เกี่ยวข้องทบทวนและลงความเห็นรับรอง], [SRS ที่ผ่านการยืนยัน (Baseline)],
  ),
  caption: [ขั้นตอนการประชุม Requirement Engineering],
)

== ผลลัพธ์จากการประชุม

=== สรุปความต้องการของผู้ใช้ (User Requirements)

#figure(
  table(
    columns: (auto, 1fr, auto),
    table.header([กลุ่ม], [ความต้องการสำคัญ], [จำนวน UR]),
    [ADM: Master Data], [เพิ่มสินค้า จัดการผู้ใช้และสิทธิ์ Staff เรียกดูข้อมูลรวม ควบคุม Master Data แต่เพียงผู้เดียว], [4 (UR-ADM-01 – 04)],
    [STF: Stock Operation], [บันทึก Stock-In/Stock-Out ห้าม Staff แก้ไขสินค้า ห้าม Staff ดูรายงานเชิงบริหาร], [4 (UR-STF-01 – 04)],
    [STK: Stock Management], [เก็บข้อมูลสินค้า 4 รายการ รหัสแบบ Non-significant ตัดสต็อกแบบ Simple Deduction ไม่มี Approval/Locking ซับซ้อน], [5 (UR-STK-01 – 05)],
    [NTF: Low Stock], [แจ้งเตือนเมื่อสินค้าใกล้หมด ตั้งค่า Threshold แจ้งไปยัง Admin], [3 (UR-NTF-01 – 03)],
    [GEN: General], [เน้น System-oriented ฟังก์ชันเรียบง่าย], [2 (UR-GEN-01 – 02)],
  ),
  caption: [สรุปกลุ่มความต้องการ รวม 18 รายการ],
)

=== กลุ่มความต้องการ: การบริหารจัดการโดย Admin (Master Data Management)
#figure(
 table(
  columns: (auto, 3fr, auto, ),
  stroke: 0.5pt + gray,
  inset: 7pt,
  align: (left, left, left, left),
  [*ID*], [*ความต้องการ*], [*ความสำคัญ*],
  [UR-ADM-01], [ในฐานะ Admin ผู้ใช้งานต้องสามารถเพิ่มแจ้งขายสินค้าเข้าสู่ระบบได้], [สูง],
  [UR-ADM-02], [ในฐานะ Admin ผู้ใช้งานต้องสามารถจัดการผู้ใช้งาน (User Management) ได้ ครอบคลุมการเพิ่ม แก้ไข และกำหนดสิทธิ์ให้กับผู้ใช้งานที่เป็น Staff],[สูง],
  [UR-ADM-03], [ในฐานะ Admin ผู้ใช้งานต้องสามารถเรียกดูรายการรวบรวมข้อมูลทั้งหมดของระบบได้],[กลาง],
  [UR-ADM-04], [ในฐานะ Admin ผู้ใช้งานต้องสามารถควบคุมข้อมูลหลัก (Master Data) ของระบบได้ทั้งหมดแต่เพียงผู้เดียว], [สูง],
),caption: [ตาราง UR-ADM],
)
=== กลุ่มความต้องการ: การปฏิบัติงานของ Staff (Stock Operation)
#figure(
  table(
  columns: (auto, 3fr, auto,),
  stroke: 0.5pt + gray,
  inset: 7pt,
  align: (left, left, left, left),
  [*ID*], [*ความต้องการ*],  [*ความสำคัญ*],
  [UR-STF-01], [ในฐานะ Staff ผู้ใช้งานต้องสามารถบันทึกการรับเข้าสินค้า (Stock-In) เข้าสู่ระบบได้], [สูง],
  [UR-STF-02], [ในฐานะ Staff ผู้ใช้งานต้องสามารถบันทึกการจ่ายออกสินค้า (Stock-Out) จากระบบได้],  [สูง],
  [UR-STF-03], [ระบบต้องไม่อนุญาตให้ Staff แก้ไขข้อมูลสินค้า (เช่น รหัสสินค้า ชื่อสินค้า หมวดหมู่) ไม่ว่ากรณีใด],  [สูง],
  [UR-STF-04], [ระบบต้องไม่อนุญาตให้ Staff เรียกดูรายงานเชิงบริหาร (Management Report)], [สูง],
),caption: [ตาราง UR-STF],)

=== กลุ่มความต้องการ: การจัดการสต็อกสินค้า (Stock Management)
#figure(
 table(
  columns: (auto, 3fr, auto,),
  stroke: 0.5pt + gray,
  inset: 7pt,
  align: (left, left, left, left),
  [*ID*], [*ความต้องการ*], [*ความสำคัญ*],
  [UR-STK-01], [ระบบต้องจัดเก็บข้อมูลพื้นฐานของสินค้าอย่างน้อย 4 รายการ ได้แก่ รหัสสินค้า ชื่อสินค้า หมวดหมู่ และจำนวนคงเหลือ],  [สูง],
  [UR-STK-02], [ระบบต้องรองรับการกำหนดรหัสสินค้าในรูปแบบที่ไม่มีความหมายพิเศษเฉพาะเจาะจง (เช่น รหัส 3 ตัวอักษร)],[ต่ำ],
  [UR-STK-03], [ระบบต้องตัดยอดสต็อกสินค้าด้วยกลไกแบบตรงไปตรงมา (Simple Deduction) จากผลรวมคงเหลือของ SKU โดยทันทีเมื่อมีการทำรายการ], [สูง],
  [UR-STK-04], [ระบบต้องไม่มีขั้นตอนการอนุมัติ (Approval Flow) ก่อนการตัดสต็อกสินค้า เพื่อให้การทำงานเป็นไปอย่างรวดเร็ว], [กลาง],
  [UR-STK-05], [ระบบต้องไม่มีกลไกการล็อคข้อมูล (Locking Mechanism) ที่ซับซ้อนระหว่างการทำรายการสต็อก], [กลาง],
),caption: [ตาราง UR-STK],)

=== กลุ่มความต้องการ: การแจ้งเตือนสินค้าใกล้หมด (Low Stock Notification)
#figure(
  table(
  columns: (auto, 3fr, auto,),
  stroke: 0.5pt + gray,
  inset: 7pt,
  align: (left, left, left, left),
  [*ID*], [*ความต้องการ*], [*ความสำคัญ*],
  [UR-NTF-01], [ระบบต้องสามารถแจ้งเตือนเมื่อสินค้าใกล้หมด เพื่อป้องกันปัญหาการขาดแคลนสินค้า],  [สูง],
  [UR-NTF-02], [ผู้ใช้งาน (Admin หรือผู้ที่ได้รับสิทธิ์) ต้องสามารถตั้งค่าจำนวนขั้นต่ำ (Threshold Quantity) ของสินค้าแต่ละรายการที่จะกระตุ้นให้เกิดการแจ้งเตือนได้],  [สูง],
  [UR-NTF-03], [ระบบต้องส่งการแจ้งเตือนไปยัง Admin เมื่อจำนวนสินค้าคงเหลือต่ำกว่าค่าขั้นต่ำที่ตั้งไว้], [สูง],
),caption: [ตาราง UR-NTF],)

=== กลุ่มความต้องการ: ลักษณะการใช้งานโดยรวม (General Usability)
#figure(
  table(
  columns: (auto, 3fr, auto,),
  stroke: 0.5pt + gray,
  inset: 7pt,
  align: (left, left, left, left),
  [*ID*], [*ความต้องการ*],  [*ความสำคัญ*],
  [UR-GEN-01], [ระบบต้องเน้นการทำงานเชิงระบบและการประมวลผลข้อมูลเป็นหลัก มากกว่าความสวยงามของหน้าจอผู้ใช้งาน],[กลาง],
  [UR-GEN-02], [ระบบต้องมีฟังก์ชันที่เรียบง่ายและใช้งานสะดวก เพื่อให้ผู้ใช้งานสามารถทำงานได้อย่างรวดเร็ว], [กลาง],
),caption: [ตาราง UR-NTF],)



=== ข้อจำกัดและสมมติฐานที่ตกลงร่วมกัน

- ระบบต้องใช้ Simple Deduction เท่านั้น ไม่มีขั้นตอนอนุมัติ และไม่มีระบบล็อคข้อมูลซับซ้อน
- Staff ต้องไม่สามารถแก้ไขข้อมูลสินค้าและไม่สามารถดูรายงานเชิงบริหารได้ในทุกกรณี
- รหัสสินค้าเป็น Non-significant Code เช่น รหัส 3 ตัวอักษร (สินค้าแอปเปิ้ลใช้รหัส APP)

=== ประเด็นที่ต้องยืนยันในรอบถัดไป (Open Issues)

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    table.header([ลำดับ], [ประเด็น], [ผลกระทบ / แนวทางที่เสนอ]),
    [OI-01], [UR-NTF-02 ระบุว่า "Admin / ผู้ใช้" ตั้งค่า Threshold ได้ ต้องชี้แจงว่ารวม Staff หรือไม่], [อาจขัดกับ UR-STF-03 \ แนวทางเริ่มต้น: ให้เฉพาะ Admin ตั้งค่า (สอดคล้องกับ TC-NTF-01)],
    [OI-02], [ยังไม่ระบุกระบวนการ Authentication และ Authorization อย่างละเอียด], [กระทบ Sprint 1 \ ต้องสัมภาษณ์เพิ่ม],
    [OI-03], [ยังไม่ระบุรูปแบบและช่องทางแจ้งเตือน (อีเมล, ภายในระบบ, SMS)], [กระทบ Sprint 3 \ เสนอเริ่มจากแจ้งเตือนบนหน้า Web],
  ),
  caption: [Open Issues จาก SRS ],
)



== ตารางการประชุมตลอดโครงการ

#figure(
  table(
    columns: (auto, auto, 1fr, 1fr),
    table.header([การประชุม], [ความถี่], [ผู้เข้าร่วม], [วัตถุประสงค์ / ผลลัพธ์]),
    [RE Meeting], [ตามระยะเก็บความต้องการ], [กลุ่ม 2 และกลุ่ม 9], [เก็บและยืนยันความต้องการ \ ผลลัพธ์: SRS],
    [Sprint Planning], [ต้น Sprint], [PO, SM, Dev], [กำหนด Sprint Goal และเลือก PBI \ ผลลัพธ์: Sprint Backlog],
    [Daily Scrum], [ทุกวัน (15 นาที)], [Dev, SM], [แจ้งความคืบหน้าและอุปสรรค],
    [Backlog Refinement], [กลาง Sprint], [PO, Dev], [ปรับรายละเอียด ประเมินคะแนน PBI ถัดไป],
    [Sprint Review], [ท้าย Sprint], [ทุกฝ่าย], [สาธิต Increment รับข้อเสนอแนะ],
    [Sprint Retrospective], [หลัง Review], [SM, Dev], [ปรับปรุงกระบวนการทำงาน],
  ),
  caption: [ตารางการประชุมตลอดโครงการ],
)

// ============================================================
= โครงสร้างระบบ (System Structure)
// ============================================================

#note[
  *หมายเหตุ:* SRS ฉบับร่างครั้งที่ 1 ยังไม่รวมข้อกำหนดเชิงระบบและสถาปัตยกรรม หัวข้อนี้เป็นข้อเสนอการออกแบบเบื้องต้น (Proposed Design) ที่สอดคล้องกับ User Requirements เพื่อใช้เป็นฐานในการวางแผน Sprint
]

== สถาปัตยกรรมแบบหลายชั้น (Layered Architecture)

#figure(
  block(width: 100%)[
    #set align(center)
    #box-step[ผู้ใช้งาน: Admin / Staff (Web Browser: Chrome, Edge, Firefox, Safari)]
    #v(2pt) ↓ #v(2pt)
    #box-step[*ชั้นนำเสนอ (Presentation Layer)* \ หน้าเข้าสู่ระบบ, หน้าจัดการสินค้า, Stock-In/Out, Dashboard, การแจ้งเตือน]
    #v(2pt) ↓ #v(2pt)
    #box-step[*ชั้นควบคุมสิทธิ์ (Access Control)* \ ตรวจ Session และ Role ทุก Request (รวมการพิมพ์ URL ตรง)]
    #v(2pt) ↓ #v(2pt)
    #box-step[*ชั้นตรรกะธุรกิจ (Business Logic)* \ Product, User, Stock Transaction, Notification Service]
    #v(2pt) ↓ #v(2pt)
    #box-step[*ชั้นข้อมูล (Data Layer)* \ Users, Products, Stock Transactions, Notifications]
  ],
  caption: [สถาปัตยกรรมระบบเบื้องต้น],
  kind: image,
)

== โมดูลของระบบและการจับคู่กับความต้องการ

#figure(
  table(
    columns: (auto, 1fr, auto),
    table.header([โมดูล], [หน้าที่], [UR ที่เกี่ยวข้อง]),
    [Authentication & RBAC], [เข้าสู่ระบบ แบ่งสิทธิ์ Admin/Staff ปฏิเสธการเข้าถึงที่ไม่ได้รับอนุญาต], [UR-ADM-04, UR-STF-03, UR-STF-04],
    [User Management], [เพิ่ม แก้ไข กำหนดสิทธิ์บัญชี Staff], [UR-ADM-02],
    [Product Master], [เพิ่ม/แก้ไขข้อมูลสินค้า (รหัส ชื่อ หมวดหมู่ จำนวนคงเหลือ)], [UR-ADM-01, UR-STK-01, UR-STK-02],
    [Stock Operation], [บันทึก Stock-In และ Stock-Out แบบ Simple Deduction], [UR-STF-01, UR-STF-02, UR-STK-03 – 05],
    [Notification], [ตั้งค่า Threshold ตรวจและแสดงแจ้งเตือน Low Stock ให้ Admin], [UR-NTF-01 – 03],
    [Dashboard & Report], [แสดงข้อมูลรวม สต็อกคงเหลือ รายงานเชิงบริหาร (เฉพาะ Admin)], [UR-ADM-03],
  ),
  caption: [โมดูลระบบและการจับคู่กับ User Requirements],
)

== โมเดลข้อมูลเบื้องต้น

#figure(
  table(
    columns: (auto, 1fr),
    table.header([ตาราง (Entity)], [ฟิลด์หลัก]),
    [Users], [user_id (PK), username, password_hash, role (ADMIN/STAFF), status],
    [Products], [product_code (PK, 3 ตัวอักษร), product_name, category, quantity, threshold],
    [Stock_Transactions], [txn_id (PK), product_code (FK), txn_type (IN/OUT), qty, user_id (FK), txn_datetime],
    [Notifications], [notif_id (PK), product_code (FK), message, created_at, is_read],
  ),
  caption: [โครงสร้างข้อมูลเบื้องต้น],
)

== สิทธิ์การใช้งาน (Access Matrix)

#figure(
  table(
    columns: (1fr, auto, auto),
    align: (left, center, center),
    table.header([ฟังก์ชัน], [Admin], [Staff]),
    [เพิ่ม/แก้ไขข้อมูลสินค้า], [✓], [✗],
    [จัดการผู้ใช้งานและสิทธิ์], [✓], [✗],
    [บันทึก Stock-In / Stock-Out], [✓ (ถ้าอนุญาต)], [✓],
    [ตั้งค่า Threshold], [✓], [✗ (รอยืนยัน OI-01)],
    [ดูรายงานเชิงบริหาร / Dashboard], [✓], [✗],
    [รับการแจ้งเตือน Low Stock], [✓], [✗],
  ),
  caption: [ตารางสิทธิ์การใช้งานตามบทบาท (RBAC)],
)

// ============================================================
= กระบวนการทำงานของระบบ (System Workflow)
// ============================================================

== กระบวนการบันทึกรับเข้า (Stock-In)

#align(center)[
  #box-step[Staff ล็อกอิน] #arrow #box-step[เลือกสินค้า] #arrow
  #box-step[ระบุจำนวน N] #arrow #box-step[กดบันทึก] #arrow
  #box-step[ยอดคงเหลือ + N ทันที] #arrow #box-step[บันทึก Transaction]
]

== กระบวนการจ่ายออก (Stock-Out / Simple Deduction)

#align(center)[
  #box-step[Staff ล็อกอิน] #arrow #box-step[เลือกสินค้า] #arrow
  #box-step[ระบุจำนวน M] #arrow #box-step[ตรวจสอบความถูกต้อง] #arrow
  #box-step[ยอดคงเหลือ − M ทันที] #arrow #box-step[ตรวจ Threshold]
]

*กฎทางธุรกิจ (Business Rules)*

+ ตัดสต็อกทันทีเมื่อกดบันทึก ไม่มีขั้นตอนรออนุมัติ (UR-STK-04)
+ ไม่ใช้กลไกล็อคข้อมูลที่ซับซ้อน (UR-STK-05) แนะนำให้ใช้การอัปเดตแบบอะตอมมิก (เช่น `UPDATE ... WHERE quantity >= M`) เพื่อป้องกันยอดผิดพลาดเมื่อมีการใช้งานพร้อมกัน โดยไม่ต้องมีระบบล็อคซับซ้อน
+ จำนวนที่บันทึกต้องเป็นจำนวนเต็มบวก
+ *ประเด็นที่ควรยืนยัน:* กรณีจ่ายออกเกินยอดคงเหลือ SRS ยังไม่ระบุว่าให้ปฏิเสธหรืออนุญาตให้ติดลบ ข้อเสนอคือปฏิเสธรายการและแสดงข้อความแจ้งผู้ใช้

== กระบวนการแจ้งเตือนสินค้าใกล้หมด

+ Admin ตั้งค่า Threshold ของสินค้าแต่ละรายการ (UR-NTF-02)
+ เมื่อมี Stock-Out ระบบเปรียบเทียบยอดคงเหลือใหม่กับ Threshold
+ หากยอดคงเหลือ < Threshold ระบบสร้างการแจ้งเตือน
+ Admin เห็นการแจ้งเตือนบนหน้า Web (UR-NTF-01, UR-NTF-03) และสามารถทำเครื่องหมายว่าอ่านแล้ว

== กระบวนการจัดการผู้ใช้และการควบคุมสิทธิ์

+ Admin เข้าเมนูจัดการผู้ใช้งาน เพิ่มบัญชี Staff และกำหนดสิทธิ์
+ Staff ใช้บัญชีที่ได้รับเข้าสู่ระบบ
+ ทุก Request ถูกตรวจสิทธิ์ที่ฝั่งเซิร์ฟเวอร์ หากเป็นหน้าแก้ไขสินค้าหรือรายงานเชิงบริหาร ระบบปฏิเสธ (Access Denied) ไม่ว่าจะเข้าผ่านเมนูหรือพิมพ์ URL ตรง

// ============================================================
= ขั้นตอนการทำงานแบบ Sprint (Agile Scrum)
// ============================================================

== กรอบการทำงาน Scrum

#figure(
  table(
    columns: (auto, auto, 1fr),
    table.header([องค์ประกอบ], [ประเภท], [รายละเอียดในโครงการนี้]),
    [Product Backlog], [Artifact], [รายการงานจาก User Requirements 18 รายการ จัดลำดับตามความสำคัญ (สูง/กลาง/ต่ำ)],
    [Sprint Backlog], [Artifact], [PBI ที่เลือกใน Sprint Planning พร้อมงานย่อย (Task)],
    [Increment], [Artifact], [ซอฟต์แวร์ที่ผ่าน Definition of Done และใช้งานได้จริงทุก Sprint],
    [Sprint], [Event], [ระยะเวลา 2 สัปดาห์ (Time-box)],
    [Sprint Planning], [Event], [ไม่เกิน 2 ชั่วโมง: กำหนด Sprint Goal และเลือกงาน],
    [Daily Scrum], [Event], [15 นาที: ทำอะไรไปแล้ว จะทำอะไร มีอุปสรรคอะไร],
    [Sprint Review], [Event], [ไม่เกิน 1 ชั่วโมง: สาธิตงานและรับข้อเสนอแนะจากผู้ใช้],
    [Sprint Retrospective], [Event], [ไม่เกิน 45 นาที: ทบทวนกระบวนการและกำหนดสิ่งที่จะปรับปรุง],
  ),
  caption: [องค์ประกอบของ Scrum ที่ใช้ในโครงการ],
)

== ขั้นตอนการทำงานในแต่ละ Sprint

#align(center)[
  #box-step[Product Backlog] #arrow
  #box-step[Sprint Planning] #arrow
  #box-step[Sprint Backlog] #arrow
  #box-step[Sprint 2 สัปดาห์ \ (Daily Scrum)] #arrow
  #box-step[Increment] #arrow
  #box-step[Sprint Review] #arrow
  #box-step[Retrospective]
]

#v(0.5em)
+ *Backlog Refinement:* PO และทีมพัฒนาปรับรายละเอียด PBI เขียน Acceptance Criteria และประเมินขนาดงาน (Story Point) ให้ผ่านเกณฑ์ Definition of Ready
+ *Sprint Planning:* ทีมกำหนด Sprint Goal เลือก PBI ตามความสามารถของทีม (Velocity) และแตกเป็น Task
+ *Development:* พัฒนาตาม Task โดยใช้ Branch แยกต่อ PBI เขียน Unit Test และส่ง Pull Request เพื่อ Code Review
+ *Daily Scrum:* ติดตามความคืบหน้าผ่านกระดาน Kanban (To Do → In Progress → In Review → Done)
+ *Testing:* ทดสอบตาม Test Case ของ PBI นั้น และบันทึกผลใน Test Execution Log
+ *Sprint Review:* สาธิต Increment ให้ผู้ใช้ รับหรือไม่รับงานตาม Acceptance Criteria
+ *Retrospective:* สรุปสิ่งที่ทำได้ดี สิ่งที่ต้องปรับปรุง และ Action Item สำหรับ Sprint ถัดไป

== Definition of Ready และ Definition of Done

#figure(
  table(
    columns: (1fr, 1fr),
    table.header([Definition of Ready (พร้อมเริ่มงาน)], [Definition of Done (งานเสร็จสมบูรณ์)]),
    [
      - มีรหัส UR อ้างอิงและแหล่งที่มา
      - มี Acceptance Criteria ชัดเจน
      - ผ่านการประเมินขนาดงานแล้ว
      - ไม่มี Open Issue ที่กระทบโดยตรง
    ],
    [
      - โค้ดผ่าน Code Review
      - ผ่าน Test Case ที่เกี่ยวข้องทั้งหมด
      - ตรวจสิทธิ์ที่ฝั่งเซิร์ฟเวอร์ (หากเกี่ยวข้อง)
      - ทำงานได้บน Chrome, Edge, Firefox และ Safari
      - PO ตรวจรับใน Sprint Review
    ],
  ),
  caption: [เกณฑ์ DoR และ DoD],
)

== Product Backlog

#figure(
  table(
    columns: (auto, 1fr, auto, auto, auto),
    table.header([PBI], [รายการงาน], [UR], [ความสำคัญ], [SP]),
    [PBI-01], [เข้าสู่ระบบและควบคุมสิทธิ์ตามบทบาท (RBAC)], [ADM-04, STF-03, STF-04], [สูง], [8],
    [PBI-02], [จัดการบัญชี Staff และกำหนดสิทธิ์], [ADM-02], [สูง], [5],
    [PBI-03], [เพิ่มข้อมูลสินค้า (รหัส 3 ตัวอักษร ชื่อ หมวดหมู่ จำนวน)], [ADM-01, STK-01, STK-02], [สูง], [5],
    [PBI-04], [บันทึกรับเข้าสินค้า (Stock-In)], [STF-01], [สูง], [3],
    [PBI-05], [บันทึกจ่ายออกสินค้า (Simple Deduction)], [STF-02, STK-03], [สูง], [5],
    [PBI-06], [ไม่มี Approval Flow และ Locking ซับซ้อน], [STK-04, STK-05], [กลาง], [2],
    [PBI-07], [ตั้งค่า Threshold], [NTF-02], [สูง], [3],
    [PBI-08], [แจ้งเตือน Low Stock ให้ Admin บนหน้า Web], [NTF-01, NTF-03], [สูง], [5],
    [PBI-09], [Dashboard และรายงานเชิงบริหาร], [ADM-03], [กลาง], [5],
    [PBI-10], [รองรับหลาย Browser และความเรียบง่ายของฟังก์ชัน], [GEN-01, GEN-02], [กลาง], [3],
  ),
  caption: [Product Backlog (SP = Story Point ที่ประเมินเบื้องต้น)],
)

== แผน Sprint

กำหนด Sprint ละ 2 สัปดาห์ รวม 5 Sprint (รวม Sprint 0) ค่า Story Point เป็นการประเมินเบื้องต้นและต้องปรับตาม Velocity จริงของทีม

#figure(
  table(
    columns: (auto, 1fr, 1fr, auto),
    table.header([Sprint], [Sprint Goal], [PBI / งานหลัก], [SP]),
    [Sprint 0], [เตรียมความพร้อมของโครงการ], [ตั้งค่า Repository, สภาพแวดล้อมพัฒนา, ออกแบบฐานข้อมูล, สรุป Open Issues OI-02], [-],
    [Sprint 1], [ระบบเข้าสู่ระบบและข้อมูลหลักใช้งานได้], [PBI-01, PBI-02, PBI-03], [18],
    [Sprint 2], [Staff บันทึกรับเข้า-จ่ายออกได้ถูกต้อง], [PBI-04, PBI-05, PBI-06], [10],
    [Sprint 3], [Admin ได้รับแจ้งเตือนและดูรายงาน], [PBI-07, PBI-08, PBI-09], [13],
    [Sprint 4], [ทดสอบรวม ปรับปรุง และส่งมอบ], [PBI-10, Regression Test, UAT, คู่มือผู้ใช้, Release], [3 + ซ่อมบั๊ก],
  ),
  caption: [แผน Sprint โดยสังเขป],
)

== ตัวอย่างการแตก Task และ Acceptance Criteria

*PBI-05: บันทึกจ่ายออกสินค้า (UR-STF-02, UR-STK-03)*

*User Story:* ในฐานะ Staff ฉันต้องการบันทึกการจ่ายสินค้าออกจำนวน M ชิ้น เพื่อให้ยอดคงเหลือถูกตัดทันที

*Acceptance Criteria (Given–When–Then)*

+ *Given* สินค้า APP มียอดคงเหลือ 100 ชิ้น *When* Staff บันทึกจ่ายออก 10 ชิ้น *Then* ยอดคงเหลือเป็น 90 ชิ้นทันที โดยไม่มีขั้นตอนอนุมัติ
+ *Given* ยอดคงเหลือหลังตัดต่ำกว่า Threshold *When* บันทึกสำเร็จ *Then* ระบบสร้างการแจ้งเตือนถึง Admin
+ *Given* ผู้ใช้เป็น Staff *When* พยายามเข้าหน้าแก้ไขสินค้า *Then* ระบบปฏิเสธการเข้าถึง

*งานย่อย (Tasks)*

#figure(
  table(
    columns: (auto, 1fr, auto),
    table.header([Task], [รายละเอียด], [ผู้รับผิดชอบ]),
    [T1], [ออกแบบหน้าจอและ Endpoint สำหรับ Stock-Out], [Dev],
    [T2], [เขียน Logic ตัดยอดแบบอะตอมมิกและบันทึก Transaction], [Dev],
    [T3], [เขียน Unit Test และตรวจกรณีจำนวนไม่ถูกต้อง], [Dev],
    [T4], [ทดสอบตาม TC-STF-02 และ TC-NTF-02], [Dev / Coordinator],
    [T5], [สาธิตและตรวจรับใน Sprint Review], [Product Owner],
  ),
  caption: [ตัวอย่าง Sprint Backlog Task ของ PBI-05],
)

== การติดตามและวัดผล

- *Sprint Board (Kanban):* ติดตามสถานะ Task รายวัน
- *Burndown Chart:* เปรียบเทียบงานที่เหลือกับเวลาที่เหลือใน Sprint
- *Velocity:* ผลรวม Story Point ที่ทำเสร็จต่อ Sprint ใช้วางแผน Sprint ถัดไป
- *ตัวชี้วัดคุณภาพ:* จำนวน Test Case ที่ผ่านต่อทั้งหมด และจำนวนข้อบกพร่องที่ค้างอยู่

// ============================================================
= การประกันคุณภาพและการจัดการการเปลี่ยนแปลง
// ============================================================

== การจัดการ Configuration

- ใช้ Git เป็นระบบควบคุมเวอร์ชัน แยก Branch ต่อ PBI (เช่น `feature/pbi-05-stock-out`) และรวมเข้า `main` ผ่าน Pull Request
- ตั้งชื่อ Commit โดยอ้างอิงรหัส UR/PBI เพื่อรักษา Traceability
- เก็บเอกสาร (SRS, Test Plan, บันทึกการประชุม) ใน Repository เดียวกัน

== การจัดการการเปลี่ยนแปลงความต้องการ

+ ผู้ขอเปลี่ยนแปลงแจ้ง Product Owner พร้อมเหตุผล
+ ทีมพัฒนาวิเคราะห์ผลกระทบต่อ UR, Test Case และ Sprint ปัจจุบัน
+ PO ตัดสินใจ: เพิ่มเข้า Product Backlog หรือปฏิเสธ
+ ปรับปรุง SRS และ Traceability Matrix เมื่อได้รับอนุมัติ

== การบริหารความเสี่ยง

#figure(
  table(
    columns: (auto, 1fr, auto, 1fr),
    table.header([รหัส], [ความเสี่ยง], [ระดับ], [แนวทางลดความเสี่ยง]),
    [R-01], [ข้อกำหนดสิทธิ์ Threshold ขัดแย้งกับข้อห้ามของ Staff (OI-01)], [สูง], [ยืนยันกับผู้ใช้ก่อน Sprint 3 ใช้ค่าเริ่มต้นเป็น Admin เท่านั้น],
    [R-02], [ยังไม่กำหนดกระบวนการ Authentication ชัดเจน (OI-02)], [สูง], [สัมภาษณ์เพิ่มใน Sprint 0],
    [R-03], [จ่ายออกเกินยอดคงเหลือแล้วสต็อกติดลบ], [กลาง], [ตรวจเงื่อนไขในคำสั่งอัปเดตแบบอะตอมมิก],
    [R-04], [ช่องว่างด้านสิทธิ์: Staff พิมพ์ URL เข้าหน้าต้องห้าม], [สูง], [ตรวจสิทธิ์ที่ฝั่งเซิร์ฟเวอร์ทุกครั้ง และมี Test Case (TC-SEC-01, 02)],
    [R-05], [ความแตกต่างระหว่าง Browser], [ต่ำ], [ทดสอบ 4 Browser ใน Definition of Done (TC-WEB-01)],
    [R-06], [การใช้งานพร้อมกันทำให้ยอดสต็อกคลาดเคลื่อน], [กลาง], [ใช้ Atomic Update และบันทึก Transaction เพื่อตรวจสอบย้อนหลัง],
  ),
  caption: [ทะเบียนความเสี่ยง],
)

// ============================================================
= แผนการทดสอบและผลการทดสอบ
// ============================================================

== กลยุทธ์การทดสอบ

การทดสอบเน้น *Functional Testing* ความถูกต้องของการตัดสต็อกแบบ Simple Deduction และการควบคุมสิทธิ์ตามบทบาท (RBAC) อ้างอิงเอกสารแผนการทดสอบและการบันทึกผลการทดสอบ (Test Plan & Test Execution Document) ของโครงการ โดยทุก Test Case อ้างอิงรหัส UR เพื่อตรวจสอบย้อนกลับได้

== สรุปผลการทดสอบ

#figure(
  table(
    columns: (auto, auto, 1fr, auto),
    table.header([Test ID], [UR ID], [วัตถุประสงค์], [ผล]),
    [TC-ADM-01], [UR-ADM-01], [เพิ่มข้อมูลสินค้าใหม่], [ผ่าน],
    [TC-ADM-02], [UR-ADM-02], [จัดการบัญชีและสิทธิ์ Staff], [ผ่าน],
    [TC-ADM-03], [UR-ADM-03], [เรียกดูข้อมูลรวมและรายงานบริหาร], [ผ่าน],
    [TC-STF-01], [UR-STF-01], [บันทึกรับเข้าสินค้า (Stock-In)], [ผ่าน],
    [TC-STF-02], [UR-STF-02, UR-STK-03], [บันทึกจ่ายออกแบบทันที (Simple Deduction)], [ผ่าน],
    [TC-SEC-01], [UR-STF-03], [ห้าม Staff แก้ไขข้อมูลสินค้า], [ผ่าน],
    [TC-SEC-02], [UR-STF-04], [ห้าม Staff เข้าถึงรายงานบริหาร], [ผ่าน],
    [TC-NTF-01], [UR-NTF-02], [ตั้งค่า Threshold], [ผ่าน],
    [TC-NTF-02], [UR-NTF-01, UR-NTF-03], [แสดงแจ้งเตือน Low Stock บนหน้า Web], [ผ่าน],
    [TC-WEB-01], [UR-GEN-01, UR-GEN-02], [ทดสอบบน Chrome, Edge, Firefox, Safari], [ผ่าน],
  ),
  caption: [สรุปผล Test Execution (ผ่าน 10 จาก 10 รายการ)],
)

== การวิเคราะห์ผลการทดสอบ

*ข้อสังเกตจากผลการทดสอบ*

+ Test Case ทั้ง 10 รายการ *ผ่านทั้งหมด* (อัตราผ่าน 100%)
+ TC-STF-02 มีหมายเหตุว่า "การพิมพ์รหัสสินค้าหายากไปนิด" ซึ่งเป็นปัญหาด้านความสะดวกในการใช้งาน (Usability) แม้ผลการทดสอบจะผ่าน ควรบันทึกเป็น PBI ปรับปรุง เช่น เพิ่มช่องค้นหา/ตัวเลือกสินค้าแบบ Dropdown หรือ Autocomplete เพื่อให้สอดคล้องกับ UR-GEN-02 (ฟังก์ชันเรียบง่ายและใช้งานสะดวก)
+ TC-NTF-01 ผ่านโดยให้ Admin เป็นผู้ตั้งค่า Threshold ซึ่งสอดคล้องกับแนวทางเริ่มต้นของ OI-01 แต่ยังต้องรอคำยืนยันจากผู้ใช้ว่า Staff มีสิทธิ์ตั้งค่าหรือไม่


== Traceability Matrix (UR → PBI → Test Case)

#figure(
  table(
    columns: (auto, auto, auto),
    table.header([UR], [PBI], [Test Case]),
    [UR-ADM-01], [PBI-03], [TC-ADM-01],
    [UR-ADM-02], [PBI-02], [TC-ADM-02],
    [UR-ADM-03], [PBI-09], [TC-ADM-03],
    [UR-ADM-04], [PBI-01], [ยังไม่มี],
    [UR-STF-01], [PBI-04], [TC-STF-01],
    [UR-STF-02], [PBI-05], [TC-STF-02],
    [UR-STF-03], [PBI-01], [TC-SEC-01],
    [UR-STF-04], [PBI-01], [TC-SEC-02],
    [UR-STK-01, 02], [PBI-03], [ยังไม่มี],
    [UR-STK-03], [PBI-05], [TC-STF-02],
    [UR-STK-04, 05], [PBI-06], [ยังไม่มี],
    [UR-NTF-01, 03], [PBI-08], [TC-NTF-02],
    [UR-NTF-02], [PBI-07], [TC-NTF-01],
    [UR-GEN-01, 02], [PBI-10], [TC-WEB-01],
  ),
  caption: [Traceability Matrix],
)

// ============================================================
= สรุปและข้อเสนอแนะ
// ============================================================

== สรุป

โครงการระบบจัดการสินค้า (Simple Entry System) ดำเนินงานตามหลักวิศวกรรมซอฟต์แวร์ โดยเริ่มจากการประชุมเก็บความต้องการและจัดทำ SRS ฉบับร่างที่มี User Requirements 18 รายการ ออกแบบโครงสร้างระบบแบบหลายชั้นพร้อมการควบคุมสิทธิ์ตามบทบาท และกำหนดกระบวนการพัฒนาแบบ Agile Scrum ที่แบ่งการส่งมอบเป็น Sprint ละ 2 สัปดาห์ ผลการทดสอบตาม Test Plan ผ่านครบทั้ง 10 รายการ แสดงว่าฟังก์ชันหลักทำงานสอดคล้องกับความต้องการที่ระบุ

== ข้อเสนอแนะสำหรับรอบถัดไป

+ *ปิด Open Issues* ทั้ง 3 ข้อ (OI-01 ถึง OI-03) โดยเฉพาะสิทธิ์การตั้งค่า Threshold และกระบวนการ Authentication
+ *จัดทำ System Requirements* เป็นเอกสารฉบับถัดไปตาม ISO/IEC/IEEE 29148 โดยใช้ SRS นี้เป็น Baseline
+ *เพิ่ม Test Case* ตามช่องว่างความครอบคลุม รวมถึง Negative Test, Boundary Test และ Concurrency Test
+ *ปรับปรุง Usability* การค้นหา/เลือกรหัสสินค้าในหน้า Stock-Out ตามข้อสังเกตของ TC-STF-02
+ *กำหนดกฎการจ่ายออกเกินยอดคงเหลือ* และรูปแบบการแจ้งเตือน (เริ่มจากบนหน้า Web) ให้ชัดเจน
+ *ดำเนิน Sprint Retrospective* ทุก Sprint เพื่อปรับปรุงกระบวนการอย่างต่อเนื่อง

// ============================================================
= เอกสารอ้างอิง
// ============================================================

+ ข้อกำหนดความต้องการซอฟต์แวร์ (Software Requirements Specification) ระบบจัดการสินค้า (Simple Entry System) ฉบับร่างครั้งที่ 1
+ แผนการทดสอบและการบันทึกผลการทดสอบ (Test Plan & Test Execution Document) ระบบจัดการสินค้า (Simple Entry System)
+ IEEE Std 830-1998, _IEEE Recommended Practice for Software Requirements Specifications_
+ ISO/IEC/IEEE 29148:2018, _Systems and software engineering — Life cycle processes — Requirements engineering_
+ Schwaber, K. and Sutherland, J., _The Scrum Guide_

// ============================================================
// ภาคผนวก
// ============================================================
#set heading(numbering: none)
#pagebreak()



= ภาคผนวก ก: แบบฟอร์ม Sprint Retrospective

#table(
  columns: (1fr, 1fr, 1fr),
  stroke: 0.5pt + luma(150),
  fill: none,
  inset: 8pt,
  align: center,
  [*สิ่งที่ทำได้ดี*], [*สิ่งที่ควรปรับปรุง*], [*Action Item (ผู้รับผิดชอบ)*],
  [\ \ \ \ ], [\ \ \ \ ], [\ \ \ \ ],
)
