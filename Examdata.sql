CREATE OR REPLACE VIEW pstg.examdata
(
  student_id,
  tax_id,
  credential_id,
  date,
  statusid,
  exam,
  languageid,
  testsite,
  sitename,
  roles,
  wellbeing,
  safety,
  handwashingskill,
  randomskill1,
  randomskill2,
  randomskill3,
  commoncarepracticesskills,
  examtype
)
AS 
 SELECT o.student_id, o.tax_id, o.credential_id, o.date, s.statusid, t.exam, l.languageid, o.testsite, o.sitename, st.stateid AS roles, st1.stateid AS wellbeing, st1.stateid AS safety, sk4.skillid AS handwashingskill, sk.skillid AS randomskill1, sk1.skillid AS randomskill2, sk2.skillid AS randomskill3, sk3.skillid AS commoncarepracticesskills, t.examtype
   FROM acquisition.df_exam o
   LEFT JOIN pstg.examstatus s ON o.status::text = s.status::text
   LEFT JOIN pstg.exams t ON o.title::text = t.title::text
   LEFT JOIN pstg.testlanguage l ON o.testlanguage::text = l.testlanguage::text
   LEFT JOIN pstg.state st ON o.roles::text = st.state::text
   LEFT JOIN pstg.state st1 ON o.wellbeing::text = st1.state::text
   LEFT JOIN pstg.state st2 ON o.safety::text = st2.state::text
   LEFT JOIN pstg.skill sk ON o.randomskill1::text = sk.skill::text
   LEFT JOIN pstg.skill sk1 ON o.randomskill2::text = sk1.skill::text
   LEFT JOIN pstg.skill sk2 ON o.randomskill3::text = sk2.skill::text
   LEFT JOIN pstg.skill sk3 ON o.commoncarepracticesskills::text = sk3.skill::text
   LEFT JOIN pstg.skill sk4 ON o.handwashingskill::text = sk4.skill::text
  WHERE o.date IS NOT NULL AND o.student_id IS NOT NULL;
