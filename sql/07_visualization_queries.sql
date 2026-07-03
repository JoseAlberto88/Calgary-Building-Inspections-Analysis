/* 6.1.1 Average inspections per permit */
SELECT 
    p.permit_id,
    jt.job_type_desc AS project_category,
    COUNT(i.inspection_id) AS inspection_count
FROM permit p
LEFT JOIN inspection i ON p.permit_id = i.permit_id
LEFT JOIN dim_job_type jt ON p.job_type_id = jt.job_type_id
GROUP BY p.permit_id, jt.job_type_desc;

/* 6.1.2 Most common deficiencies */
SELECT 
    jt.job_type_desc AS project_category,
    d.deficiency_text,
    COUNT(*) AS deficiency_count
FROM deficiency d
LEFT JOIN inspection_deficiency idf ON d.deficiency_id = idf.deficiency_id
LEFT JOIN inspection i ON idf.inspection_id = i.inspection_id
LEFT JOIN permit p ON i.permit_id = p.permit_id
LEFT JOIN dim_job_type jt ON p.job_type_id = jt.job_type_id
GROUP BY jt.job_type_desc, d.deficiency_text
ORDER BY deficiency_count DESC;

/* 6.1.3 Duration by inspection type */
SELECT 
    it.inspection_type_desc,
    AVG(DATEDIFF(p.permit_close_date, p.issue_date)) AS avg_duration
FROM permit p
LEFT JOIN inspection i ON p.permit_id = i.permit_id
LEFT JOIN dim_inspection_type it ON i.inspection_type_id = it.inspection_type_id
GROUP BY it.inspection_type_desc
ORDER BY avg_duration DESC;

/* Unified table for contractor/location analysis */
CREATE TABLE unified_permit_inspection_clean AS
SELECT
    p.permit_id,
    p.job_type_id,
    jt.job_type_desc,
    p.issue_date,
    p.permit_close_date,
    p.permit_status_id,
    p.location_id,
    l.address_line,
    i.inspection_id,
    DATEDIFF(p.permit_close_date, p.issue_date) AS duration_days
FROM permit p
LEFT JOIN inspection i ON p.permit_id = i.permit_id
LEFT JOIN dim_job_type jt ON p.job_type_id = jt.job_type_id
LEFT JOIN location l ON p.location_id = l.location_id
WHERE 
    p.permit_close_date IS NOT NULL
    AND p.issue_date IS NOT NULL
    AND p.permit_close_date <> '9999-12-31'
    AND p.permit_close_date > p.issue_date
    AND DATEDIFF(p.permit_close_date, p.issue_date) < 5000;
