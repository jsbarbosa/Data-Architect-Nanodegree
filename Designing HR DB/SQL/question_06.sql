SELECT
    employees.name,
    job_titles.name AS job_title,
    departments.name AS department,
    DATE(job_descriptions.created_at) AS start_date,
    DATE(job_descriptions.deleted_at) AS end_date,
    manager.name as manager
FROM
    employees
        JOIN
    job_descriptions ON employees.id = job_descriptions.employee_id
        JOIN
    departments ON departments.id = job_descriptions.department_id
        JOIN
    job_titles ON job_titles.id = job_descriptions.title_id
        JOIN
    managers ON managers.department_id = departments.id
        JOIN
    employees AS manager ON managers.employee_id = manager.id 
WHERE
    employees.name = 'Toni Lembeck';
