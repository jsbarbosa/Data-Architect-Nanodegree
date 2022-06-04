CREATE DATABASE HR_DB;


CREATE TABLE IF NOT EXISTS education_levels (
    id INT NOT NULL,
    name VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id));


CREATE TABLE IF NOT EXISTS job_titles (
    id INT NOT NULL,
    name VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id));


CREATE TABLE IF NOT EXISTS locations (
    id INT NOT NULL,
    name VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id));


CREATE TABLE IF NOT EXISTS departments (
    id INT NOT NULL,
    name VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id));


CREATE TABLE IF NOT EXISTS employees (
    id VARCHAR(50) NOT NULL,
    name VARCHAR(50),
    email VARCHAR(50),
    hire_date DATE,
    education_level_id INT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (education_level_id)
        REFERENCES education_levels (id)
);


CREATE TABLE IF NOT EXISTS salaries (
    id INT NOT NULL,
    employee_id VARCHAR(50),
    amount INT,
    created_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id),
    FOREIGN KEY (employee_id)
        REFERENCES employees (id)
);


CREATE TABLE IF NOT EXISTS managers (
    id INT NOT NULL,
    employee_id VARCHAR(50),
    department_id INT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (employee_id)
        REFERENCES employees (id),
    FOREIGN KEY (department_id)
        REFERENCES departments (id)
);


CREATE TABLE IF NOT EXISTS job_descriptions (
    id INT NOT NULL,
    employee_id VARCHAR(50),
    department_id INT,
    title_id INT,
    location_id INT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (employee_id)
        REFERENCES employees (id),
    FOREIGN KEY (department_id)
        REFERENCES departments (id),
    FOREIGN KEY (title_id)
        REFERENCES job_titles (id),
    FOREIGN KEY (location_id)
        REFERENCES locations (id)
);
