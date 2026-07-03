USE calgary_inspections;

/* 1.3.1 Most common construction project types */
SELECT j.job_type_desc AS Job_Type_Description,
       COUNT(*) AS Frequency
FROM permit p
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
GROUP BY j.job_type_desc
ORDER BY Frequency DESC;

/* 1.3.2 Average inspections per project type */
SELECT j.job_type_desc AS Job_Type_Description,
       AVG(i_count) AS Average_Inspections
FROM (
    SELECT permit_id, COUNT(*) AS i_count
    FROM inspection
    GROUP BY permit_id
) AS x
JOIN permit p ON x.permit_id = p.permit_id
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
GROUP BY j.job_type_desc;

/* 1.3.3 Most common inspection outcomes */
SELECT d.outcome_desc AS Inspection_Outcome,
       COUNT(*) AS Frequency
FROM inspection i
JOIN dim_outcome d ON i.outcome_id = d.outcome_id
GROUP BY d.outcome_desc
ORDER BY Frequency DESC
LIMIT 10;

/* 1.3.4 Deficiencies by project type */
SELECT j.job_type_desc AS Job_Type_Description,
       COUNT(*) AS Deficiency_Count
FROM inspection_deficiency id
JOIN inspection i ON id.inspection_id = i.inspection_id
JOIN permit p ON i.permit_id = p.permit_id
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
GROUP BY j.job_type_desc
ORDER BY Deficiency_Count DESC;

/* 1.3.5 Distribution of inspections per permit */
SELECT i_count AS Inspections_Per_Permit,
       COUNT(*) AS Frequency
FROM (
    SELECT permit_id, COUNT(*) AS i_count
    FROM inspection
    GROUP BY permit_id
) x
GROUP BY i_count
ORDER BY i_count
LIMIT 10;

/* 1.3.6 Summary statistics for permit duration */
SELECT 
    ROUND(MIN(DATEDIFF(permit_close_date, issue_date)), 2) AS Minimum,
    ROUND(AVG(DATEDIFF(permit_close_date, issue_date)), 2) AS Average,
    ROUND(MAX(DATEDIFF(permit_close_date, issue_date)), 2) AS Maximum,
    ROUND(STDDEV(DATEDIFF(permit_close_date, issue_date)), 2) AS Std_Deviation
FROM permit
WHERE permit_close_date IS NOT NULL;

/* 1.3.7 Inspection outcomes by job type */
SELECT j.job_type_desc AS Job_Type_Description,
       d.outcome_desc AS Inspection_Outcome,
       COUNT(*) AS Frequency
FROM inspection i
JOIN permit p ON i.permit_id = p.permit_id
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
JOIN dim_outcome d ON i.outcome_id = d.outcome_id
GROUP BY j.job_type_desc, d.outcome_desc
ORDER BY j.job_type_desc, Frequency DESC;

/* 1.3.8 Missing close dates by project type */
SELECT j.job_type_desc AS Job_Type_Description,
       COUNT(*) AS Missing_Close_Dates
FROM permit p
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
WHERE p.permit_close_date IS NULL
GROUP BY j.job_type_desc;
