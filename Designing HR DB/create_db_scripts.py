import pandas as pd
from datetime import datetime


raw_data = pd.read_csv('data/hr-dataset.csv')


def add_time_stamp(data: pd.DataFrame) -> pd.DataFrame:
    data['created_at'] = datetime.now()
    data['updated_at'] = datetime.now()
    data['deleted_at'] = None
    
    return data


def get_education_levels(data: pd.DataFrame) -> pd.DataFrame:
    education_levels = pd.DataFrame(
        data['EDUCATION LEVEL'].drop_duplicates().rename(
            'name'
        ).reset_index(
            drop=True
        ),
    )
    
    education_levels = add_time_stamp(education_levels)
    
    education_levels.index += 1
    education_levels.index.name = 'id'
    
    return education_levels.reset_index()


def make_employees(data: pd.DataFrame, education_levels) -> pd.DataFrame:
    employees = data[
        [
            'EMP_ID',
            'EMP_NM',
            'EMAIL',
            'HIRE_DT',
            'EDUCATION LEVEL'
        ]
    ].merge(
        education_levels[['id', 'name']],
        left_on='EDUCATION LEVEL',
        right_on='name'
    ).drop(
        columns=[
            'name',
            'EDUCATION LEVEL'
        ]
    ).rename(
        columns={
            'EMP_ID': 'id',
            'EMP_NM': 'name',
            'EMAIL': 'email',
            'HIRE_DT': 'hire_date',
            'id': 'education_level_id'
        }
    ).drop_duplicates(
        subset=[
            'id'
        ],
        keep='first'
    )
    
    return add_time_stamp(employees)
    
    
def make_salaries(data: pd.DataFrame) -> pd.DataFrame:
    salaries = data[
        [
            'EMP_ID',
            'SALARY',
            'START_DT',
            'END_DT'
        ]
    ].sort_values(
        [
            'EMP_ID',
            'START_DT'
        ]
    ).rename(
        columns={
            'EMP_ID': 'employee_id',
            'SALARY': 'amount',
            'START_DT': 'created_at',
            'END_DT': 'deleted_at'
        }
    ).reset_index(
        drop=True
    )
    
    salaries.index += 1
    salaries.index.name = 'id'
    
    salaries['created_at'] = pd.to_datetime(salaries['created_at'])
    salaries['deleted_at'] = pd.to_datetime(salaries['deleted_at'])
    salaries['updated_at'] = salaries['deleted_at'].combine_first(salaries['created_at'])
    
    return salaries.reset_index()
    


def make_job_titles(data: pd.DataFrame) -> pd.DataFrame:
    titles = data[
        [
            'JOB_TITLE'
        ]
    ].drop_duplicates().reset_index(
        drop=True
    ).reset_index().rename(
        columns={
            'JOB_TITLE': 'name',
            'index': 'id'
        }
    ).eval(
        "id = id + 1"
    )
    
    return add_time_stamp(titles)
    

def make_locations(data: pd.DataFrame) -> pd.DataFrame:
    locations = data[
        [
            'LOCATION',
            'ADDRESS',
            'CITY',
            'STATE'
        ]
    ].drop_duplicates().reset_index(
        drop=True
    ).reset_index().rename(
        columns={
            'LOCATION': 'name',
            'ADDRESS': 'address',
            'CITY': 'city',
            'STATE': 'state',
            'index': 'id'
        }
    ).eval(
        "id = id + 1"
    )
    
    return add_time_stamp(locations)
    
    
def make_departments(data: pd.DataFrame) -> pd.DataFrame:
    departments = data[
        [
            'DEPARTMENT'
        ]
    ].drop_duplicates().reset_index(
        drop=True
    ).reset_index().rename(
        columns={
            'DEPARTMENT': 'name',
            'index': 'id'
        }
    ).eval(
        "id = id + 1"
    )
    
    return add_time_stamp(departments)
    
    
def make_managers(data: pd.DataFrame, employees: pd.DataFrame, departments: pd.DataFrame) -> pd.DataFrame:
    managers = data[
        [
            'DEPARTMENT',
            'MANAGER'
        ]
    ].drop_duplicates().merge(
        employees[
            [
                'name',
                'id'
            ]
        ],
        left_on='MANAGER',
        right_on='name'
    ).rename(
        columns={
            'id': 'employee_id'
        }
    ).drop(
        columns=[
            'name'
        ]
    ).query(
        "(employee_id != 'E17054') or (DEPARTMENT == 'HQ')"
    )
    
    managers = managers.drop_duplicates().merge(
        departments[
            [
                'id',
                'name'
            ]
        ],
        left_on='DEPARTMENT',
        right_on='name',
        how='left'
    ).reset_index().rename(
        columns={
            'id': 'department_id',
            'index': 'id'
        }
    ).eval(
        "id = id + 1"
    )[
        [
            'id',
            'employee_id',
            'department_id'
        ]
    ]
    
    return add_time_stamp(managers)
    

def make_job_description(
    data: pd.DataFrame,
    departments: pd.DataFrame,
    titles: pd.DataFrame,
    locations: pd.DataFrame
):
    job_descriptions = data[
        [
            'EMP_ID',
            'START_DT',
            'END_DT',
            'DEPARTMENT',
            'LOCATION',
            'MANAGER',
            'JOB_TITLE'
        ]
    ].drop_duplicates().merge(
        departments[
            [
                'id',
                'name'
            ]
        ],
        left_on='DEPARTMENT',
        right_on='name'
    ).merge(
        titles[
            [
                'id',
                'name'
            ]
        ],
        left_on='JOB_TITLE',
        right_on='name'
    ).merge(
        locations[
            [
                'id',
                'name'
            ]
        ],
        left_on='LOCATION',
        right_on='name'
    ).reset_index().rename(
        columns={
            'EMP_ID': 'employee_id',
            'START_DT': 'created_at',
            'END_DT': 'deleted_at',
            'id_x': 'department_id',
            'id_y': 'title_id',
            'id': 'location_id',
            'index': 'id'
        }
    ).eval(
        "id = id + 1"
    )
    
    job_descriptions['created_at'] = pd.to_datetime(job_descriptions['created_at'])
    job_descriptions['deleted_at'] = pd.to_datetime(job_descriptions['deleted_at'])
    job_descriptions['updated_at'] = job_descriptions['deleted_at'].combine_first(job_descriptions['created_at'])   
    
    return job_descriptions[
        [
            'id',
            'employee_id',
            'department_id',
            'title_id',
            'location_id',
            'created_at',
            'updated_at',
            'deleted_at'
        ]
    ]
    
    

def to_excel(raw_data: pd.DataFrame):
    education_levels = get_education_levels(raw_data)
    employees = make_employees(raw_data, education_levels)    
    salaries = make_salaries(raw_data)
    job_titles = make_job_titles(raw_data)    
    locations = make_locations(raw_data)    
    departments = make_departments(raw_data)
    managers = make_managers(raw_data, employees, departments)
    job_descriptions = make_job_description(raw_data, departments, job_titles, locations)
    
    with pd.ExcelWriter('data/excel-db.xlsx') as writer:
        for name, item in {
            'education_levels': education_levels,
            'job_titles': job_titles,
            'locations': locations,
            'departments': departments,
            'employees': employees,
            'salaries': salaries,
            'managers': managers,
            'job_descriptions': job_descriptions
        }.items():
            item.to_excel(
                writer,
                sheet_name=name,
                index=False
            )

def to_crud_sql(
    name: str,
    data: pd.DataFrame,
    defaults: dict = {
        'id': 'NOT NULL',
        'created_at': 'DEFAULT NOW()',
        'updated_at': 'DEFAULT NOW()',
        'deleted_at': 'DEFAULT NULL'
    },
    foreign_keys: dict = {
        'education_level_id': 'education_levels',
        'employee_id': 'employees',
        'department_id': 'departments',
        'title_id': 'job_titles',
        'location_id': 'locations'
    }
) -> str:
    dtypes = data.dtypes.astype('str').replace(
        {
            'object': 'VARCHAR(50)',
            'int64': 'INT',
            'datetime64[ns]': 'TIMESTAMP',
            'float64': 'DOUBLE'
        }
    )
    
    if 'deleted_at' in dtypes.index:
        dtypes['deleted_at'] = 'TIMESTAMP'
    
    if 'hire_date' in dtypes.index:
        dtypes['hire_date'] = 'DATE'
        
    for col, value in defaults.items():
        if col in dtypes.index:
            dtypes[col] += f' {value}'
    
    column_declaration = ",\n    ".join(
        [f"{col} {item}" for col, item in dtypes.iteritems()]
    )
    
    foreign_keys = ",\n".join(
        [
            f"    FOREIGN KEY ({field})\n        REFERENCES {table} (id)"
            for field, table in foreign_keys.items() 
            if field in dtypes.index
        ]
    )
    
    query = f"""
CREATE TABLE IF NOT EXISTS {name} (
    {column_declaration},
    PRIMARY KEY (id)"""
    if foreign_keys:
        query += f',\n{foreign_keys}\n'
        
    return query + ');'


def to_insert_sql(name: str, data: pd.DataFrame):
    columns = ", ".join(data.columns)
    values = ("'" + data.fillna('NULL').astype(str).values + "'").tolist()
    values = ",\n    ".join(
        ["(" + ", ".join(val) + ")" for val in values]
    )
    
    return f"""
INSERT INTO {name} ({columns})
VALUES
    {values};
    """.replace(
        "'NULL'",
        'NULL'
    )
    


def to_table_sql(
    name: str, 
    data: pd.DataFrame, 
    crud_kwargs: dict = {}
):
    crud = to_crud_sql(
        name,
        data,
        **crud_kwargs
    )
    
    insert = to_insert_sql(name, data)
    
    return crud, insert
    
    
    
def to_sql(data: dict):
    cruds = []
    inserts = []
    
    for key, item in data.items():
        crud, insert = to_table_sql(key, item)

        cruds.append(crud)
        inserts.append(insert)
    
    with open("documents/cruds.sql", "w") as file:
        file.write(
            "\n\n".join(cruds)
        )
        
    with open("documents/inserts.sql", "w") as file:
        file.write(
            "\n\n".join(inserts)
        )
        

if __name__ == '__main__':
    """
    raw_data = pd.read_csv('data/hr-dataset.csv')
    to_excel(raw_data)
    """
    
    to_sql(
        pd.read_excel("data/excel-db.xlsx", sheet_name=None)
    )
