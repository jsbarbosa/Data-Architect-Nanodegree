SELECT
    employees.id,
    employees.name,
    job_titles.name AS job_title,
    departments.name as department
FROM
    employees
        JOIN
    job_descriptions ON employees.id = job_descriptions.employee_id
        AND job_descriptions.deleted_at IS NULL
        JOIN
    job_titles ON job_titles.id = job_descriptions.title_id
        JOIN
    departments ON departments.id = job_descriptions.department_id
ORDER BY employees.id;
