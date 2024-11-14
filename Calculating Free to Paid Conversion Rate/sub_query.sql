-- @block
-- Select columns to retrieve information on students' engagement
SELECT 
    e.student_id,
    date_registered,
    first_date_watched,
    first_date_purchased,
    -- Calculate the difference in days between registration date and the first watch date
    DATEDIFF(first_date_watched, date_registered) AS date_diff_reg_watch,
    -- Calculate the difference in days between the first watch date and the first purchase date
    DATEDIFF(first_date_purchased, first_date_watched) AS date_diff_watch_purch

FROM
    student_info i
    RIGHT JOIN
    (SELECT student_id, MIN(date_watched) AS first_date_watched -- Earliest date the student watched content
    FROM student_engagement GROUP BY student_id) e 
    ON i.student_id = e.student_id
    LEFT JOIN
    (SELECT student_id, MIN(date_purchased) AS first_date_purchased -- Earliest date the student made a purchase
    FROM student_purchases GROUP BY student_id) p
    ON e.student_id = p.student_id

-- Filter out records where:
-- 1. A purchase was never made OR 
-- 2. Content was watched on or before the first purchase
WHERE first_date_watched <= first_date_purchased OR first_date_purchased IS NULL