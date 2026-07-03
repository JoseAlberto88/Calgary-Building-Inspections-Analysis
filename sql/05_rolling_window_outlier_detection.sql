/*
Script B6. SQL query used to generate three-year rolling windows and identify outliers across Residential and Commercial sectors
*/

WITH RECURSIVE YearWindows AS (
 -- Anchor member: Start with the first 3-year window
SELECT 2000 AS start_year, 2002 AS end_year 
UNION ALL 
-- Recursive member: Increment by 1 year until reaching the final window ending in 2025 
SELECT start_year + 1, end_year + 1 
FROM YearWindows 
WHERE end_year < 2025 
),
FilteredPermits AS ( 
SELECT 
CASE WHEN job_type_id = 3 THEN 'Commercial'
WHEN job_type_id = 2 THEN 'Residential'
ELSE 'Other' 
END AS project_category, YEAR(issue_date) AS issue_year, DATEDIFF(permit_close_date, issue_date) AS duration_days
FROM permit 
WHERE issue_date >= '2000-01-01' 
AND issue_date <= '2025-12-31' 
AND permit_close_date IS NOT NULL 
AND YEAR(permit_close_date) < 2262 
), 
ValidGroups AS 
(
SELECT * FROM FilteredPermits WHERE project_category != 'Other' 
), 
WindowedPermits AS ( 
-- Allocates permits to their respective rolling windows
SELECT w.start_year, w.end_year,
CONCAT(w.start_year, '-', w.end_year) AS time_window, p.project_category, p.duration_days,
ROW_NUMBER() OVER (PARTITION BY w.start_year, p.project_category 
ORDER BY p.duration_days ASC) AS row_num,
COUNT(*) OVER (PARTITION BY w.start_year, p.project_category) AS total_rows 
FROM YearWindows w 
JOIN ValidGroups p ON p.issue_year BETWEEN w.start_year AND w.end_year ),
 WindowedQuartiles AS 
( 
-- Calculates Q1 and Q3 using exact linear interpolation per window and category 
SELECT time_window, start_year, end_year, project_category,
MAX(CASE WHEN row_num = FLOOR(1 + 0.25 * (total_rows - 1)) THEN duration_days END) * (1 - ((1 + 0.25 * (total_rows - 1)) - FLOOR(1 + 0.25 * (total_rows - 1))))
+ MAX(CASE WHEN row_num = CEIL(1 + 0.25 * (total_rows - 1)) THEN duration_days END) * ((1 + 0.25 * (total_rows - 1)) - FLOOR(1 + 0.25 * (total_rows - 1))) AS q1,
MAX(CASE WHEN row_num = FLOOR(1 + 0.75 * (total_rows - 1)) THEN duration_days END) * (1 - ((1 + 0.75 * (total_rows - 1)) - FLOOR(1 + 0.75 * (total_rows - 1)))) +
MAX(CASE WHEN row_num = CEIL(1 + 0.75 * (total_rows - 1)) THEN duration_days END) * ((1 + 0.75 * (total_rows - 1)) - FLOOR(1 + 0.75 * (total_rows - 1))) AS q3
FROM 
    WindowedPermits
GROUP BY 
    time_window, start_year, end_year, project_category
 
),
WindowedThresholds AS (
-- Establishes outer fences for outliers 
SELECT time_window, start_year, 
end_year, project_category, (q1 - 1.5 * (q3 - q1)) AS lower_bound, 
(q3 + 1.5 * (q3 - q1)) AS upper_bound FROM WindowedQuartiles )
 -- Final Output: Displays rolling years, category, and outlier distribution metrics 



SELECT 
t.time_window AS Years,
t.project_category AS Project_Category,
COUNT(CASE WHEN wp.duration_days < t.lower_bound OR wp.duration_days > t.upper_bound THEN 1 END) AS Outlier_Count, COUNT(*) AS Total_Records, ROUND( COUNT(CASE WHEN wp.duration_days < t.lower_bound OR wp.duration_days > t.upper_bound THEN 1 END) * 100.0 / COUNT(*), 2 ) 
AS Outlier_Percentage 
FROM WindowedPermits wp JOIN WindowedThresholds t 
ON wp.time_window = t.time_window 
AND wp.project_category = t.project_category 
GROUP BY t.start_year, t.end_year, t.time_window, t.project_category, t.lower_bound, t.upper_bound 
ORDER BY t.start_year ASC, 
t.project_category DESC;
