CREATE OR REPLACE VIEW pstg.examtestdetail
(
  student_id,
  exam_attempt,
  bt70completiondate,
  testtype,
  testdate,
  testresult,
  trainingrequirementid,
  testlanguage
)
AS 
 SELECT examstuff1.student_id__c AS student_id, examstuff1.trial_number AS exam_attempt, examstuff1.completed_on__c AS bt70completiondate, examstuff1.examtype AS testtype, examstuff1.testdate, examstuff1.status AS testresult, examstuff1.trainingrequirementid, examstuff1.testlanguage
   FROM ( SELECT a.trial_number, a.student_id__c, a.name, a.completed_on__c, a.trainingrequirementid, b.student_id, b.testdate, b.examtype, b.status, b.testlanguage, m.student, m.maxt, 
                CASE
                    WHEN m.maxt = 3 AND a.trial_number = 1 AND b.testdate >= a.completed_on__c AND b.testdate < (( SELECT examstuff.completed_on__c
                       FROM ( SELECT pg_catalog.row_number()
                              OVER( 
                              PARTITION BY sf_trainingrequirement.student_id__c
                              ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) AS trial_number, sf_trainingrequirement.student_id__c, sf_trainingrequirement.name, sf_trainingrequirement.completed_on__c, sf_trainingrequirement.trainingrequirementid
                               FROM acquisition.sf_trainingrequirement
                              WHERE sf_trainingrequirement.name::text = 'Basic Training 70 Hours'::text AND sf_trainingrequirement.earned_hours__c >= 70::numeric(8,2) AND sf_trainingrequirement.completed_on__c::character varying::text <> ''::text AND sf_trainingrequirement.student_id__c::text <> ''::text
                              ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) examstuff
                      WHERE examstuff.student_id__c::text = a.student_id__c::text AND examstuff.trial_number = 2)) THEN a.trial_number
                    WHEN m.maxt = 3 AND a.trial_number = 2 AND b.testdate >= a.completed_on__c AND b.testdate < (( SELECT examstuff.completed_on__c
                       FROM ( SELECT pg_catalog.row_number()
                              OVER( 
                              PARTITION BY sf_trainingrequirement.student_id__c
                              ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) AS trial_number, sf_trainingrequirement.student_id__c, sf_trainingrequirement.name, sf_trainingrequirement.completed_on__c, sf_trainingrequirement.trainingrequirementid
                               FROM acquisition.sf_trainingrequirement
                              WHERE sf_trainingrequirement.name::text = 'Basic Training 70 Hours'::text AND sf_trainingrequirement.earned_hours__c >= 70::numeric(8,2) AND sf_trainingrequirement.completed_on__c::character varying::text <> ''::text AND sf_trainingrequirement.student_id__c::text <> ''::text
                              ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) examstuff
                      WHERE examstuff.student_id__c::text = a.student_id__c::text AND examstuff.trial_number = 3)) THEN a.trial_number
                    WHEN m.maxt = 3 AND a.trial_number = 3 AND b.testdate >= a.completed_on__c THEN a.trial_number
                    WHEN m.maxt = 2 AND a.trial_number = 1 AND b.testdate >= a.completed_on__c AND b.testdate < (( SELECT examstuff.completed_on__c
                       FROM ( SELECT pg_catalog.row_number()
                              OVER( 
                              PARTITION BY sf_trainingrequirement.student_id__c
                              ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) AS trial_number, sf_trainingrequirement.student_id__c, sf_trainingrequirement.name, sf_trainingrequirement.completed_on__c, sf_trainingrequirement.trainingrequirementid
                               FROM acquisition.sf_trainingrequirement
                              WHERE sf_trainingrequirement.name::text = 'Basic Training 70 Hours'::text AND sf_trainingrequirement.earned_hours__c >= 70::numeric(8,2) AND sf_trainingrequirement.completed_on__c::character varying::text <> ''::text AND sf_trainingrequirement.student_id__c::text <> ''::text
                              ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) examstuff
                      WHERE examstuff.student_id__c::text = a.student_id__c::text AND examstuff.trial_number = 2)) THEN a.trial_number
                    WHEN m.maxt = 2 AND a.trial_number = 2 AND b.testdate >= a.completed_on__c THEN a.trial_number
                    WHEN m.maxt = 1 AND a.trial_number = 1 AND b.testdate >= a.completed_on__c AND b.testdate < a.completed_on__c THEN a.trial_number
                    WHEN m.maxt = 1 AND a.trial_number = 1 AND b.testdate >= a.completed_on__c THEN a.trial_number
                    WHEN b.examtype IS NULL THEN 0::bigint
                    ELSE NULL::bigint
                END AS dd
           FROM ( SELECT pg_catalog.row_number()
                  OVER( 
                  PARTITION BY sf_trainingrequirement.student_id__c
                  ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) AS trial_number, sf_trainingrequirement.student_id__c, sf_trainingrequirement.name, sf_trainingrequirement.completed_on__c, sf_trainingrequirement.trainingrequirementid
                   FROM acquisition.sf_trainingrequirement
                  WHERE sf_trainingrequirement.name::text = 'Basic Training 70 Hours'::text AND sf_trainingrequirement.earned_hours__c >= 70::numeric(8,2) AND sf_trainingrequirement.completed_on__c::character varying::text <> ''::text AND sf_trainingrequirement.student_id__c::text <> ''::text
                  ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) a
      LEFT JOIN ( SELECT o.student_id, to_date(o.date::text, 'YYYY-mm-dd'::text) AS testdate, t.examtype, s.status, o.testlanguage
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
  WHERE o.date IS NOT NULL AND o.student_id IS NOT NULL AND (t.examtype = 'Knowledge'::text OR t.examtype = 'Skill'::text) AND (s.status::text = 'Passed'::text OR s.status::text = 'Failed'::text)) b ON a.student_id__c::text = b.student_id::text
   LEFT JOIN ( SELECT DISTINCT examstuff.student_id__c AS student, "max"(examstuff.trial_number) AS maxt
              FROM ( SELECT pg_catalog.row_number()
                     OVER( 
                     PARTITION BY sf_trainingrequirement.student_id__c
                     ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) AS trial_number, sf_trainingrequirement.student_id__c, sf_trainingrequirement.name, sf_trainingrequirement.completed_on__c, sf_trainingrequirement.trainingrequirementid
                      FROM acquisition.sf_trainingrequirement
                     WHERE sf_trainingrequirement.name::text = 'Basic Training 70 Hours'::text AND sf_trainingrequirement.earned_hours__c >= 70::numeric(8,2) AND sf_trainingrequirement.completed_on__c::character varying::text <> ''::text AND sf_trainingrequirement.student_id__c::text <> ''::text
                     ORDER BY sf_trainingrequirement.student_id__c, sf_trainingrequirement.completed_on__c) examstuff
             GROUP BY examstuff.student_id__c) m ON a.student_id__c::text = m.student::text) examstuff1
  WHERE examstuff1.dd IS NOT NULL
  ORDER BY examstuff1.trial_number, examstuff1.testdate;