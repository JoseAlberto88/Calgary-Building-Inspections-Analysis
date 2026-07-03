/* 4.1.1 Row counts across all tables */
SELECT 'contractor', COUNT(*) FROM contractor UNION ALL
SELECT 'deficiency', COUNT(*) FROM deficiency UNION ALL
SELECT 'dim_checklist', COUNT(*) FROM dim_checklist UNION ALL
SELECT 'dim_discipline', COUNT(*) FROM dim_discipline UNION ALL
SELECT 'dim_inspection_type', COUNT(*) FROM dim_inspection_type UNION ALL
SELECT 'dim_job_type', COUNT(*) FROM dim_job_type UNION ALL
SELECT 'dim_outcome', COUNT(*) FROM dim_outcome UNION ALL
SELECT 'dim_permit_status', COUNT(*) FROM dim_permit_status UNION ALL
SELECT 'inspection', COUNT(*) FROM inspection UNION ALL
SELECT 'inspection_deficiency', COUNT(*) FROM inspection_deficiency UNION ALL
SELECT 'location', COUNT(*) FROM location UNION ALL
SELECT 'permit', COUNT(*) FROM permit UNION ALL
SELECT 'permit_holder', COUNT(*) FROM permit_holder;

/* 4.1.2 DISTINCT checks */
SELECT DISTINCT * FROM contractor;
SELECT DISTINCT * FROM deficiency;
SELECT DISTINCT * FROM dim_checklist;
SELECT DISTINCT * FROM dim_discipline;
SELECT DISTINCT * FROM dim_inspection_type;
SELECT DISTINCT * FROM dim_job_type;
SELECT DISTINCT * FROM dim_outcome;
SELECT DISTINCT * FROM dim_permit_status;
SELECT DISTINCT * FROM inspection;
SELECT DISTINCT * FROM inspection_deficiency;
SELECT DISTINCT * FROM location;
SELECT DISTINCT * FROM permit;
SELECT DISTINCT * FROM permit_holder;

/* 4.1.3 Table structure documentation */
DESCRIBE contractor;
DESCRIBE deficiency;
DESCRIBE dim_checklist;
DESCRIBE dim_discipline;
DESCRIBE dim_inspection_type;
DESCRIBE dim_job_type;
DESCRIBE dim_outcome;
DESCRIBE dim_permit_status;
DESCRIBE inspection;
DESCRIBE inspection_deficiency;
DESCRIBE location;
DESCRIBE permit;
DESCRIBE permit_holder;

/* 4.1.4 Missing value identification */
SELECT 'contractor', SUM(contractor_name IS NULL) FROM contractor;
SELECT 'deficiency', SUM(deficiency_text IS NULL) FROM deficiency;
SELECT 'dim_checklist', SUM(checklist_name IS NULL) FROM dim_checklist;
SELECT 'dim_discipline', SUM(discipline_desc IS NULL) FROM dim_discipline;
SELECT 'dim_inspection_type', SUM(inspection_type_desc IS NULL) FROM dim_inspection_type;
SELECT 'dim_job_type', SUM(job_type_desc IS NULL) FROM dim_job_type;
SELECT 'dim_outcome', SUM(outcome_desc IS NULL) FROM dim_outcome;
SELECT 'dim_permit_status', SUM(status_name IS NULL) FROM dim_permit_status;
SELECT 'inspection', SUM(inspection_completed_date IS NULL) FROM inspection;
SELECT 'inspection_deficiency', SUM(deficiency_resolved IS NULL) FROM inspection_deficiency;
SELECT 'location', SUM(address_line IS NULL) FROM location;
SELECT 'permit', SUM(permit_close_date IS NULL) FROM permit;
SELECT 'permit_holder', SUM(holder_name IS NULL) FROM permit_holder;
