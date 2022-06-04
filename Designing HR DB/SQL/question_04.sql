-- UNCOMMENT FOR HARD DELETE

/*
DELETE FROM job_titles
WHERE
    id = 11;
*/

UPDATE job_titles
SET 
    deleted_at = NOW()
WHERE
    id = 11;

SELECT
    *
FROM
    job_titles;
