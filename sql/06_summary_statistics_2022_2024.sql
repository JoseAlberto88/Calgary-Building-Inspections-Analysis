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