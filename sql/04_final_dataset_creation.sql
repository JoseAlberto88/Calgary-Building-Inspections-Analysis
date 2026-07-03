/* 4.2.4 Final dataset creation */
SELECT A.permit_id, A.job_type_id,
CASE WHEN B.job_type_desc = 'Residential Improvement Project' THEN 'Residential'
WHEN B.job_type_desc = 'Commercial / Multi Family Project' THEN 'Commercial' END AS job_type_description,
A.permit_status_id,
C.status_name,
A.issue_date,
A.permit_close_date,
DATEDIFF(A.permit_close_date, A.issue_date) AS permit_duration_days
FROM permit AS A
LEFT JOIN dim_job_type AS B ON A.job_type_id = B.job_type_id
LEFT JOIN dim_permit_status AS C ON A.permit_status_id = C.permit_status_id
WHERE A.issue_date IS NOT NULL 
AND A.permit_close_date IS NOT NULL
AND A.permit_status_id = 1
AND YEAR(issue_date) BETWEEN 2022 AND 2024 
AND A.job_type_id IN (2,3)
LIMIT 10;
