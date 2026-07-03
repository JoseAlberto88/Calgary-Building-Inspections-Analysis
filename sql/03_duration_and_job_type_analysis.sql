/* 4.2.1 Duration calculation */
SELECT 
    issue_date, 
    permit_close_date, 
    DATEDIFF(permit_close_date, issue_date) AS Duration_Days
FROM permit
LIMIT 10;

/* 4.2.2 Job type join */
SELECT 
    A.issue_date, 
    A.permit_close_date,
    DATEDIFF(A.permit_close_date, A.issue_date) AS Duration_Days,
    CASE 
        WHEN B.job_type_desc = 'Residential Improvement Project' THEN 'Residential'
        WHEN B.job_type_desc = 'Commercial / Multi Family Project' THEN 'Commercial'
    END AS Job_Type_Description
FROM permit A
JOIN dim_job_type B 
    ON A.job_type_id = B.job_type_id
LIMIT 10;

/* 4.2.3 Filtering valid permits */
SELECT 
    CASE 
        WHEN B.job_type_desc = 'Residential Improvement Project' THEN 'Residential'
        WHEN B.job_type_desc = 'Commercial / Multi Family Project' THEN 'Commercial'
    END AS Job_Type_Description, 
    COUNT(*) AS Number_of_Permits_by_Job_Type
FROM permit A
INNER JOIN dim_job_type B 
    ON A.job_type_id = B.job_type_id
WHERE YEAR(issue_date) BETWEEN 2022 AND 2024
  AND issue_date IS NOT NULL 
  AND permit_close_date IS NOT NULL
  AND A.permit_status_id = 1
  AND B.job_type_id IN (2,3)
GROUP BY B.job_type_desc;
