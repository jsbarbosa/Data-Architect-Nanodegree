UPDATE job_titles
SET 
    name = 'Web Developer',
    updated_at = NOW()
WHERE
    id = 11;
    
SELECT
    *
FROM
    job_titles;
