/*
The accompanying SQL file contains all queries used throughout the data preparation and exploratory 
analysis stages of this project. These queries were applied to extract, clean, transform, and understand 
the Calgary Building Inspections dataset prior to statistical modeling. Although the file is not 
organized as a formal script, inline comments are included to clarify the purpose of each query and to 
indicate how specific steps contributed to the analytical workflow. The SQL code reflects the actual 
sequence of operations performed during the study and serves as a transparent record of the data‑handling 
process.
*/



USE calgary_inspections;

/*
1.3.1 Question 1: Which types of construction projects are most common in Calgary?
Understanding the distribution of job types provides insight into where the city allocates most of its permitting and inspection resources.
*/

SELECT j.job_type_desc AS Job_Type_Description,
       COUNT(*) AS Frequency
FROM permit p
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
GROUP BY j.job_type_desc
ORDER BY Frequency DESC;

/*
1.3.2 Question 2: Do some project types require more inspections than others?
Inspection frequency serves as an indicator of project complexity and potential delays.
*/

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

/*
1.3.3 Question 3: What are the most common inspection outcomes?
Inspection outcomes influence project timelines and highlight areas where compliance 
*/

SELECT d.outcome_desc AS Inspection_Outcome,
       COUNT(*) AS Frequency
FROM inspection i
JOIN dim_outcome d ON i.outcome_id = d.outcome_id
GROUP BY d.outcome_desc
ORDER BY Frequency DESC
LIMIT 10;

/*
1.3.4 Question 4: Are deficiencies more common in certain types of projects?
Deficiencies require rework and additional inspections, contributing to longer processing times.
*/

SELECT j.job_type_desc AS Job_Type_Description,
       COUNT(*) AS Deficiency_Count
FROM inspection_deficiency id
JOIN inspection i ON id.inspection_id = i.inspection_id
JOIN permit p ON i.permit_id = p.permit_id
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
GROUP BY j.job_type_desc
ORDER BY Deficiency_Count DESC;

# QUESTION 5
/*
1.3.5 Question 5: What is the distribution of inspections per permit?
Examining the distribution of inspection counts helps identify variability and potential outliers.
*/

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

# QUESTION 6 
/*
1.3.6 Question 6: What are the summary statistics for permit duration?
Summary statistics provide an early indication of how long permits typically remain open.
*/

SELECT 
    ROUND(MIN(DATEDIFF(permit_close_date, issue_date)), 2) AS Minimum,
    ROUND(AVG(DATEDIFF(permit_close_date, issue_date)), 2) AS Average,
    ROUND(MAX(DATEDIFF(permit_close_date, issue_date)), 2) AS Maximum,
    ROUND(STDDEV(DATEDIFF(permit_close_date, issue_date)), 2) AS Std_Deviation
FROM permit
WHERE permit_close_date IS NOT NULL;

# QUESTION 7
/*
1.3.7 Question 7: Do inspection outcomes differ by job type?
Cross tabulating outcomes by job type reveals whether certain project categories experience more compliance challenges. 
*/

SELECT j.job_type_desc AS Job_Type_Description,
       d.outcome_desc AS Inspection_Outcome,
       COUNT(*) AS Frequency
FROM inspection i
JOIN permit p ON i.permit_id = p.permit_id
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
JOIN dim_outcome d ON i.outcome_id = d.outcome_id
GROUP BY j.job_type_desc, d.outcome_desc
ORDER BY j.job_type_desc, Frequency DESC;


# QUESTION 8 
/*
1.3.8 Question 8: Are missing close dates more common in certain project types?
Missing close dates affect the ability to calculate permit duration and may indicate incomplete or ongoing projects.
*/

SELECT j.job_type_desc AS Job_Type_Description,
       COUNT(*) AS Missing_Close_Dates
FROM permit p
JOIN dim_job_type j ON p.job_type_id = j.job_type_id
WHERE p.permit_close_date IS NULL
GROUP BY j.job_type_desc;



/*
4.1.1 Row Counts Across All Tables
Purpose: To obtain an overview of the size of each table in the calgary_inspections database and confirm the expected relational structure.
*/

SELECT 'contractor' AS 'Table', COUNT(DISTINCT contractor_id) AS 'Row Counts' FROM contractor UNION ALL
SELECT 'deficiency' AS 'Table', COUNT(DISTINCT deficiency_id) AS 'Row Counts' FROM deficiency UNION ALL
SELECT 'dim_checklist' AS 'Table', COUNT(DISTINCT checklist_id) AS 'Row Counts' FROM dim_checklist UNION ALL
SELECT 'dim_discipline' AS 'Table', COUNT(DISTINCT discipline_id) AS 'Row Counts' FROM dim_discipline UNION ALL
SELECT 'dim_inspection_type' AS 'Table', COUNT(DISTINCT inspection_type_id) AS 'Row Counts' FROM dim_inspection_type UNION ALL
SELECT 'dim_job_type' AS 'Table', COUNT(DISTINCT job_type_id) AS 'Row Counts' FROM dim_job_type UNION ALL
SELECT 'dim_outcome' AS 'Table', COUNT(DISTINCT outcome_id) AS 'Row Counts' FROM dim_outcome UNION ALL
SELECT 'dim_permit_status' AS 'Table', COUNT(DISTINCT permit_status_id) AS 'Row Counts' FROM dim_permit_status UNION ALL
SELECT 'inspection' AS 'Table', COUNT(DISTINCT inspection_id) AS 'Row Counts' FROM inspection UNION ALL
SELECT 'inspection_deficiency' AS 'Table', COUNT(DISTINCT inspection_deficiency_id) AS 'Row Counts' FROM inspection_deficiency UNION ALL
SELECT 'location' AS 'Table', COUNT(DISTINCT location_id) AS 'Row Counts' FROM location UNION ALL
SELECT 'permit' AS 'Table', COUNT(DISTINCT permit_id) AS 'Row Counts' FROM permit UNION ALL
SELECT 'permit_holder' AS 'Table', COUNT(DISTINCT permit_holder_id) AS 'Row Counts' FROM permit_holder;
/*
4.1.2 DISTINCT Queries
Purpose: 
To identify categorical variables and verify the number of unique values within key dimension tables. This step helps confirm category consistency and ensures that fields such as job type, inspection type, and outcome are suitable for grouping in later analysis.
*/

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

SELECT job_type_id, job_type_desc
FROM dim_job_type
ORDER BY job_type_id DESC;

/*
4.1.3 Table Structure Documentation
Purpose: To document the schema design, identify primary and foreign keys, and understand how tables relate to each other. Examining table structures ensures that joins between permits, inspections, deficiencies, and dimension tables are performed correctly during dataset construction.
*/


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

/*
4.1.4 Missing Value Identification
Purpose: To evaluate data completeness before constructing the analytical dataset. Identifying missing values ensures that variables such as permit duration, job type, and inspection outcomes are based on complete and reliable records.
*/

SELECT 'contractor' as 'Table',SUM(CASE WHEN contractor_id IS NULL THEN 1 ELSE 0 END) AS contractor_id, SUM(CASE WHEN contractor_name IS NULL THEN 1 ELSE 0 END) AS contractor_name FROM contractor;
SELECT 'deficiency' as 'Table', SUM(CASE WHEN deficiency_id IS NULL THEN 1 ELSE 0 END) AS deficiency_id, SUM(CASE WHEN deficiency_text IS NULL THEN 1 ELSE 0 END) AS deficiency_text FROM deficiency;
SELECT 'dim_checklist' as 'Table', SUM(CASE WHEN checklist_id IS NULL THEN 1 ELSE 0 END) AS checklist_id, SUM(CASE WHEN checklist_name IS NULL THEN 1 ELSE 0 END) AS checklist_name FROM dim_checklist;
SELECT 'dim_discipline' as 'Table', SUM(CASE WHEN discipline_id IS NULL THEN 1 ELSE 0 END) AS discipline_id, SUM(CASE WHEN discipline_desc IS NULL THEN 1 ELSE 0 END) AS discipline_desc FROM dim_discipline;
SELECT 'dim_inspection_type' as 'Table', SUM(CASE WHEN inspection_type_id IS NULL THEN 1 ELSE 0 END) AS inspection_type_id,SUM(CASE WHEN inspection_type_desc IS NULL THEN 1 ELSE 0 END) AS inspection_type_desc FROM dim_inspection_type;
SELECT 'dim_job_type' as 'Table', SUM(CASE WHEN job_type_id IS NULL THEN 1 ELSE 0 END) AS job_type_id, SUM(CASE WHEN job_type_desc IS NULL THEN 1 ELSE 0 END) AS job_type_desc FROM dim_job_type;
SELECT 'dim_outcome' as 'Table', SUM(CASE WHEN outcome_id IS NULL THEN 1 ELSE 0 END) AS outcome_id, SUM(CASE WHEN outcome_desc IS NULL THEN 1 ELSE 0 END) AS outcome_desc FROM dim_outcome;
SELECT 'dim_permit_status' as 'Table', SUM(CASE WHEN permit_status_id IS NULL THEN 1 ELSE 0 END) AS permit_status_id, SUM(CASE WHEN status_name IS NULL THEN 1 ELSE 0 END) AS status_name FROM dim_permit_status;
SELECT 'inspection' as 'Table',SUM(CASE WHEN inspection_id IS NULL THEN 1 ELSE 0 END) AS inspection_id,SUM(CASE WHEN permit_id IS NULL THEN 1 ELSE 0 END) AS permit_id,SUM(CASE WHEN process_id IS NULL THEN 1 ELSE 0 END) AS process_id,SUM(CASE WHEN inspection_type_id IS NULL THEN 1 ELSE 0 END) AS inspection_type_id,SUM(CASE WHEN outcome_id IS NULL THEN 1 ELSE 0 END) AS outcome_id,SUM(CASE WHEN inspection_completed_date IS NULL THEN 1 ELSE 0 END) AS inspection_completed_date,SUM(CASE WHEN permit_deficiencies_flag IS NULL THEN 1 ELSE 0 END) AS permit_deficiencies_flag FROM inspection;
SELECT 'inspection_deficiency' as 'Table',SUM(CASE WHEN inspection_deficiency_id IS NULL THEN 1 ELSE 0 END) AS inspection_deficiency_id,SUM(CASE WHEN inspection_id IS NULL THEN 1 ELSE 0 END) AS inspection_id,SUM(CASE WHEN deficiency_id IS NULL THEN 1 ELSE 0 END) AS deficiency_id,SUM(CASE WHEN discipline_id IS NULL THEN 1 ELSE 0 END) AS discipline_id,SUM(CASE WHEN checklist_id IS NULL THEN 1 ELSE 0 END) AS checklist_id,SUM(CASE WHEN deficiency_resolved IS NULL THEN 1 ELSE 0 END) AS deficiency_resolved,SUM(CASE WHEN resolved_date IS NULL THEN 1 ELSE 0 END) AS resolved_date FROM inspection_deficiency;
SELECT 'location' as 'Table',SUM(CASE WHEN location_id IS NULL THEN 1 ELSE 0 END) AS location_id,SUM(CASE WHEN address_line IS NULL THEN 1 ELSE 0 END) AS address_line,SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS longitude,SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) AS latitude,SUM(CASE WHEN point_wkt IS NULL THEN 1 ELSE 0 END) AS point_wkt FROM location;
SELECT 'permit' as 'Table',SUM(CASE WHEN permit_id IS NULL THEN 1 ELSE 0 END) AS permit_id,SUM(CASE WHEN external_file_num IS NULL THEN 1 ELSE 0 END) AS external_file_num,SUM(CASE WHEN job_type_id IS NULL THEN 1 ELSE 0 END) AS job_type_id,SUM(CASE WHEN location_id IS NULL THEN 1 ELSE 0 END) AS location_id,SUM(CASE WHEN permit_status_id IS NULL THEN 1 ELSE 0 END) AS permit_status_id,SUM(CASE WHEN contractor_id IS NULL THEN 1 ELSE 0 END) AS contractor_id,SUM(CASE WHEN permit_holder_id IS NULL THEN 1 ELSE 0 END) AS permit_holder_id,SUM(CASE WHEN issue_date IS NULL THEN 1 ELSE 0 END) AS issue_date,SUM(CASE WHEN permit_close_date IS NULL THEN 1 ELSE 0 END) AS permit_close_date FROM permit;
SELECT 'permit_holder' as 'Table',SUM(CASE WHEN permit_holder_id IS NULL THEN 1 ELSE 0 END) AS permit_holder_id,SUM(CASE WHEN holder_name IS NULL THEN 1 ELSE 0 END) AS holder_name FROM permit_holder;

/*
4.2.1 Duration Calculation
Purpose: To calculate the processing duration of each permit by measuring the number of days between the permit issue date and the permit close date. This variable is essential for comparing processing times between residential and commercial permits and forms the core metric used in the statistical analysis.
*/

SELECT 
    issue_date, 
    permit_close_date, 
    DATEDIFF(permit_close_date, issue_date) AS Duration_Days
FROM permit
LIMIT 10;

/*
4.2.2 Job Type Join
Purpose: To enrich the permit dataset by integrating job type classifications. This join allows detailed job type descriptions to be grouped into broader analytical categories, Residential and Commercial, which are required for comparing permit processing durations across project types.
*/

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

/*
4.2.3 Filtering Valid Permits
Purpose: To retain only valid permit records that meet the analytical criteria required for comparing processing durations. 
This filtering step ensures that the dataset includes only complete, relevant, and closed permits within the selected study 
period (2022–2024), and that job types are restricted to the two categories used in the research question: Residential and Commercial.
*/

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

/*
4.2.4 Final Dataset Creation
Purpose: The final analytical dataset was constructed by integrating permit information, 
job type classifications, permit status, and calculated permit duration. This step combines all prior extraction,
 transformation, and filtering procedures into a single query 
*/

SELECT A.permit_id, A.job_type_id,
CASE WHEN B.job_type_desc = 'Residential Improvement Project' THEN 'Residential'
WHEN B.job_type_desc = 'Commercial / Multi Family Project' THEN 'Commercial' END AS 'job_type_description',
A.permit_status_id,
C.status_name,
A.issue_date,
A.permit_close_date,
DATEDIFF(A.permit_close_date, A.issue_date) AS permit_duration_days
FROM permit AS A
LEFT JOIN dim_job_type AS B ON A.job_type_id = B.job_type_id
LEFT JOIN dim_permit_status AS C ON A.permit_status_id = C.permit_status_id
WHERE A.issue_date IS NOT NULL AND A.permit_close_date IS NOT NULL
AND A.permit_status_id = 1
AND YEAR (issue_date) BETWEEN 2022 AND 2024 AND A.job_type_id IN (2,3)
LIMIT 10;

/*
4.2.5 Inspection Counts
Purpose: The purpose of this query is to quantify the total number of inspections recorded in the database. 
Establishing the overall inspection volume provides important context for understanding operational workload and supports later 
analyses involving inspection frequency, outcomes, and deficiency patterns.
*/

-- Total number of inspections
SELECT COUNT(*) AS total_inspections 
FROM inspection;

/*
4.2.6 Total Inspections Grouped by Year
Purpose: The purpose of this query is to summarize inspection activity over time by calculating the total number of inspections 
completed each year. Grouping inspections by year provides insight into workload trends and supports later analyses involving inspection 
frequency, operational patterns, and potential seasonal or annual variations.
*/

SELECT 
    YEAR(inspection_completed_date) AS year, 
    COUNT(*) AS inspections_per_year
FROM inspection
GROUP BY YEAR(inspection_completed_date)
ORDER BY year;

/*
4.2.7 Common Inspection Types
Purpose: The purpose of this query is to identify the most frequently performed inspection types by joining the inspection 
fact table with the inspection type dimension table. This allows raw inspection type IDs to be replaced with readable descriptions and 
enables ranking inspection types by frequency to understand operational workload patterns.
*/


SELECT 
    deficiency_text,
    COUNT(deficiency_id) AS occurrence_count
FROM calgary_inspections.deficiency
GROUP BY deficiency_text
ORDER BY occurrence_count DESC
LIMIT 10;

/*
4.2.8 Deficiency Patterns
Purpose: The purpose of this query is to identify the most common deficiencies recorded during inspections. Grouping deficiencies by 
their descriptive text highlights recurring compliance issues and helps reveal which construction or safety requirements are most 
frequently violated. This information supports later analysis of inspection outcomes, contractor performance, and systemic problem areas.
*/

SELECT 
    it.inspection_type_desc,
    COUNT(d.deficiency_id) AS total_deficiencies
FROM calgary_inspections.inspection i
LEFT JOIN calgary_inspections.inspection_deficiency idf
    ON i.inspection_id = idf.inspection_id
LEFT JOIN calgary_inspections.deficiency d
    ON idf.deficiency_id = d.deficiency_id
JOIN calgary_inspections.dim_inspection_type it
    ON i.inspection_type_id = it.inspection_type_id
GROUP BY it.inspection_type_desc
ORDER BY total_deficiencies DESC;





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






/*
Script B7. SQL for Mean, Median, Standard Deviation, and Range (2022–2024 Window) 
*/

WITH FilteredPermits AS (
    SELECT
        CASE
            WHEN job_type_id = 3 THEN 'Commercial'
            WHEN job_type_id = 2 THEN 'Residential'
            ELSE 'Other'
        END AS project_category,
        DATEDIFF(permit_close_date, issue_date) AS duration_days
    FROM permit
    WHERE issue_date >= '2022-01-01'
      AND issue_date <= '2024-12-31'
      AND permit_close_date IS NOT NULL
),

ValidGroups AS (
    -- Excludes job_type_id 1 and 4 automatically
    SELECT *
    FROM FilteredPermits
    WHERE project_category != 'Other'
),

NumberedPermits AS (
    SELECT
        project_category,
        duration_days,
        ROW_NUMBER() OVER (
            PARTITION BY project_category
            ORDER BY duration_days ASC
        ) AS row_num,
        COUNT(*) OVER (
            PARTITION BY project_category
        ) AS total_rows
    FROM ValidGroups
)

SELECT
    project_category,
    COUNT(*) AS `count`,
    ROUND(AVG(duration_days), 6) AS `mean`,

    -- Median using linear interpolation
    ROUND(
        MAX(
            CASE WHEN row_num = FLOOR(1 + 0.5 * (total_rows - 1))
                 THEN duration_days END
        ) * (1 - ((1 + 0.5 * (total_rows - 1))
            - FLOOR(1 + 0.5 * (total_rows - 1))))
        +
        MAX(
            CASE WHEN row_num = CEIL(1 + 0.5 * (total_rows - 1))
                 THEN duration_days END
        ) * ((1 + 0.5 * (total_rows - 1))
            - FLOOR(1 + 0.5 * (total_rows - 1))),
        1
    ) AS `median`,

    ROUND(STDDEV_SAMP(duration_days), 6) AS `std`,
    MIN(duration_days) AS `min`,
    MAX(duration_days) AS `max`

FROM NumberedPermits
GROUP BY project_category;


/*
6.1.1 Average Number of Inspections per Permit (Bar Chart)
Purpose: Shows how many inspections are typically required to close a permit.
*/

SELECT 
    p.permit_id,
    jt.job_type_desc AS project_category,
    COUNT(i.inspection_id) AS inspection_count
FROM permit p
LEFT JOIN inspection i 
    ON p.permit_id = i.permit_id
LEFT JOIN dim_job_type jt
    ON p.job_type_id = jt.job_type_id
GROUP BY 
    p.permit_id,
    jt.job_type_desc;


/*
6.1.2 Most Common Deficiencies by Category (Horizontal Bar Chart)
Purpose: Identifies the most frequent deficiencies for residential and commercial permits.
*/


SELECT 
    jt.job_type_desc AS project_category,
    d.deficiency_text,
    COUNT(*) AS deficiency_count
FROM deficiency d
LEFT JOIN inspection_deficiency idf
    ON d.deficiency_id = idf.deficiency_id
LEFT JOIN inspection i
    ON idf.inspection_id = i.inspection_id
LEFT JOIN permit p
    ON i.permit_id = p.permit_id
LEFT JOIN dim_job_type jt
    ON p.job_type_id = jt.job_type_id
GROUP BY 
    jt.job_type_desc,
    d.deficiency_text
ORDER BY 
    deficiency_count DESC;

/*
6.1.3 Average Permit Duration by Inspection Type (Heatmap or Bar Chart)
Purpose: Shows which inspection types contribute most to long permit durations.
*/

SELECT 
    it.inspection_type_desc,
    AVG(DATEDIFF(p.permit_close_date, p.issue_date)) AS avg_duration
FROM permit p
LEFT JOIN inspection i
    ON p.permit_id = i.permit_id
LEFT JOIN dim_inspection_type it
    ON i.inspection_type_id = it.inspection_type_id
GROUP BY 
    it.inspection_type_desc
ORDER BY 
    avg_duration DESC;
    
    
    /*
    6.1.4 Permit Duration by Contractor (Boxplot or Bar Chart)
Purpose: Compares average permit duration across contractors.
*/


/*
This table was created in order to capture all the key variables needed for visualization. Althoung, it is not a clean table, it'll
help us to analysis patterns and inconsistencies. For those reasons, putting the table qith the actual records give us real information
about the business and the way they were working with the dataset. 
*/


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
    -- Compute duration only for valid dates
    DATEDIFF(p.permit_close_date, p.issue_date) AS duration_days
FROM permit p
LEFT JOIN inspection i
    ON p.permit_id = i.permit_id
LEFT JOIN dim_job_type jt
    ON p.job_type_id = jt.job_type_id
LEFT JOIN location l
    ON p.location_id = l.location_id
WHERE 
    p.permit_close_date IS NOT NULL
    AND p.issue_date IS NOT NULL
    AND p.permit_close_date <> '9999-12-31'
    AND p.permit_close_date > p.issue_date
    AND DATEDIFF(p.permit_close_date, p.issue_date) < 5000;

