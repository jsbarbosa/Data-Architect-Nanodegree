SELECT
    departments.name AS department,
    COUNT(*) AS employees
FROM
    employees
        JOIN
    job_descriptions ON employees.id = job_descriptions.employee_id
        AND job_descriptions.deleted_at IS NULL
        JOIN
    departments ON departments.id = job_descriptions.department_id
GROUP BY departments.name;
