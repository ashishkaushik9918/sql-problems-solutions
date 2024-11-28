-- create employee  table 

CREATE TABLE employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES department(id)
);

-- create department table

CREATE TABLE department (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);


-- insert data into employee and department table

-- employee

INSERT INTO employee (name, department_id, salary) VALUES 
('John', 1, 50000),
('Jane', 1, 60000),
('Alice', 2, 75000),
('Bob', 2, 85000),
('Eve', 3, 40000),
('Charlie', 3, 45000),
('Dave', 4, 55000),
('Mallory', 4, 70000);

-- department
INSERT INTO department (name) VALUES 
('HR'),
('Engineering'),
('Marketing'),
('Sales');


-- 1:Problem find every employee highest salary department wise 

-- 1st approach sub query



select e.name as employee_name,e.salary as salary,d.name as department_name  
 from employee e join department d on d.id = e.department_id 
 where e.salary in (
    select MAX(salary) 
    from employee e2 
    where e2.department_id = e.department_id
 )

--  2nd approach bt cte

WITH max_salaries AS (
    SELECT department_id, MAX(salary) as max_salary
    FROM employee
    GROUP BY department_id
)

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
FROM employee e
    JOIN max_salaries ms ON e.department_id = ms.department_id AND e.salary = ms.max_salary
    JOIN department d ON d.id = e.department_id;


-- 3th with rank

WITH ranked_salaries AS (
    SELECT *, RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) as rank
    FROM employee
)

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
FROM ranked_salaries e
    JOIN department d ON d.id = e.department_id
    WHERE rank = 1;
    
-- 4th with window function

SELECT name as employee_name, salary as salary, name as department_name
FROM (
    SELECT *, MAX(salary) OVER (PARTITION BY department_id) as max_salary
    FROM employee
    ) subquery
    WHERE salary = max_salary;

    -- 5th with join
    
SELECT e.name as employee_name, e.salary as salary, d.name as department_name
    FROM employee e
    JOIN (
        SELECT department_id, MAX(salary) as max_salary
        FROM employee
        GROUP BY department_id
        ) subquery ON e.department_id = subquery.department_id AND e.salary = subquery.max_salary
        JOIN department d ON d.id = e.department_id;
        
-- 6th with correlated subquery

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
FROM employee e
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employee e2
    WHERE e2.department_id = e.department_id

) subquery
    JOIN department d ON d.id = e.department_id;
    
-- 7th with exists

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
FROM employee e
    JOIN department d ON d.id = e.department_id
WHERE EXISTS (
    SELECT 1
    FROM employee e2
    WHERE e2.department_id = e.department_id AND e2.salary > e.salary
)

-- 8th with join and having

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
FROM employee e
    JOIN department d ON d.id = e.department_id
GROUP BY e.department_id, e.name, e.salary, d.name
    HAVING COUNT(*) = (
        SELECT COUNT(*)
        FROM employee e2
        WHERE e2.department_id = e.department_id
    )
    
-- 9th with window function

SELECT name as employee_name, salary as salary, name as department_name
FROM (
    SELECT *, COUNT(*) OVER (PARTITION BY department_id) as total_employees
    FROM employee
    ) subquery
    WHERE total_employees = (
        SELECT COUNT(*)
        FROM employee e2
        WHERE e2.department_id = subquery.department_id
    )
    JOIN department d ON d.id = subquery.department_id;
    
-- 10th with join and subquery

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
FROM employee e
    JOIN department d ON d.id = e.department_id
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employee e2
    WHERE e2.department_id = e.department_id
    LIMIT 1
)

-- 11th with join and subquery

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
    FROM employee e
    JOIN department d ON d.id = e.department_id
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employee e2
    WHERE e2.department_id = e.department_id
)
    AND e.department_id IN (
        SELECT department_id
        FROM employee
        GROUP BY department_id
        HAVING COUNT(*) > 5
    )
    
-- 12th with join and window function

SELECT name as employee_name, salary as salary, name as department_name
FROM (
    SELECT *, COUNT(*) OVER (PARTITION BY department_id) as total_employees
    FROM employee
    ) subquery
    WHERE total_employees > 5
    AND salary = (
        SELECT MAX(salary)
        FROM employee e2
        WHERE e2.department_id = subquery.department_id
    )
    JOIN department d ON d.id = subquery.department_id;
    
-- 13th with join and subquery

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
FROM employee e
    JOIN department d ON d.id = e.department_id
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employee e2
    WHERE e2.department_id = e.department_id
)
    AND e.department_id IN (
        SELECT department_id
        FROM employee
        GROUP BY department_id
        HAVING COUNT(*) > 5
    )
    AND d.name IN (
        SELECT name
        FROM department
        GROUP BY name
        HAVING COUNT(*) > 1
    )
    
-- 14th with join and window function

SELECT name as employee_name, salary as salary, name as department_name
FROM (
    SELECT *, COUNT(*) OVER (PARTITION BY department_id) as total_employees
    FROM employee
    ) subquery
    WHERE total_employees > 5
    AND salary = (
        SELECT MAX(salary)
        FROM employee e2
        WHERE e2.department_id = subquery.department_id
    )
    JOIN department d ON d.id = subquery.department_id
    AND d.name IN (
        SELECT name
        FROM department
        GROUP BY name
        HAVING COUNT(*) > 1
    )
    
-- 15th with join and subquery

SELECT e.name as employee_name, e.salary as salary, d.name as department_name
FROM employee e
    JOIN department d ON d.id = e.department_id
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employee e2
    WHERE e2.department_id = e.department_id
)
    AND e.department_id IN (
        SELECT department_id
        FROM employee
        GROUP BY department_id
        HAVING COUNT(*) > 5
    )
    AND d.name IN (
        SELECT name
        FROM department
        GROUP BY name
        HAVING COUNT(*) > 1
    )
    AND e.name LIKE 'A%'
    
-- 16th with join and window function

SELECT name as employee_name, salary as salary, name as department_name
FROM (
    SELECT *, COUNT(*) OVER (PARTITION BY department_id) as total_employees
    FROM employee
    ) subquery
    WHERE total_employees > 5
    AND salary = (
        SELECT MAX(salary)
        FROM employee e2
        WHERE e2.department_id = subquery.department_id
    )
    JOIN department d ON d.id = subquery.department_id
    AND d.name IN (
        SELECT name
        FROM department
        GROUP BY name
        HAVING COUNT(*) > 1
    )
    AND e.name LIKE 'A%'



    -- 2: Problem List all employees with their department names.

     SELECT 
    e.name AS employee_name, 
    d.name AS department_name
     FROM 
    employee e
     JOIN 
    department d ON e.department_id = d.id;

    -- 3: Problem Count the number of employees in each department.

    SELECT 
    d.name AS department_name, 
    COUNT(e.id) AS employee_count
   FROM 
    employee e
    JOIN 
    department d ON e.department_id = d.id
     GROUP BY 
    d.id, d.name;

    -- 4: Problem Find the total salary expense for each department.
    SELECT 
    d.name AS department_name, 
    SUM(e.salary) AS total_salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name;

    -- 5:Problem List employees who earn more than their department's average salary.

    SELECT 
    e.name AS employee_name, 
    d.name AS department_name, 
    e.salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
WHERE 
    e.salary > (
        SELECT 
            AVG(salary) 
        FROM 
            employee 
        WHERE 
            department_id = e.department_id
    );


-- 6:Problem Find the second highest salary in each department.

WITH RankedSalaries AS (
    SELECT 
        e.id AS employee_id,
        e.name AS employee_name,
        d.name AS department_name,
        e.salary,
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank
    FROM 
        employee e
    JOIN 
        department d ON e.department_id = d.id
)
SELECT 
    department_name,
    employee_name,
    salary
FROM 
    RankedSalaries
WHERE 
    rank = 2;


    -- 7:Problem List employees with the highest salary in the company (not department-specific).

    SELECT 
    e.name AS employee_name, 
    e.salary
FROM 
    employee e
WHERE 
    e.salary = (SELECT MAX(salary) FROM employee);


-- 8:Problem Find the highest salary and the department it belongs to.

SELECT 
    d.name AS department_name, 
    MAX(e.salary) AS highest_salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.name;
  

--   9:Problem Find employees who do not belong to any department.


SELECT 
    e.name AS employee_name 
FROM 
    employee e
WHERE 
    e.department_id IS NULL;


-- 10:Problem Find the average salary of each department.


SELECT 
    d.name AS department_name, 
    AVG(e.salary) AS average_salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name;


-- 11: Problem List departments where total salary expense exceeds $100,000.

SELECT 
    d.name AS department_name, 
    SUM(e.salary) AS total_salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name
HAVING 
    SUM(e.salary) > 100000;


-- 12:Problem Find the number of departments that have at least 2 employees.

SELECT 
    COUNT(*) AS department_count
FROM 
    (SELECT 
         department_id
     FROM 
         employee
     GROUP BY 
         department_id
     HAVING 
         COUNT(*) >= 2) AS departments_with_two_or_more_employees;


-- 13:Problem Find employees who have the same salary as someone in a different department.

SELECT 
    e1.name AS employee_name, 
    d1.name AS department_name, 
    e1.salary
FROM 
    employee e1
JOIN 
    department d1 ON e1.department_id = d1.id
WHERE 
    EXISTS (
        SELECT 
            1
        FROM 
            employee e2
        WHERE 
            e2.salary = e1.salary 
            AND e2.department_id <> e1.department_id
    );

--  14:Problem List departments that have no employees.


SELECT 
    d.name AS department_name
FROM 
    department d
LEFT JOIN 
    employee e ON d.id = e.department_id
WHERE 
    e.id IS NULL;


-- 15:Problem Which department has the highest average salary?

SELECT 
    d.name AS department_name, 
    AVG(e.salary) AS average_salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name
ORDER BY 
    average_salary DESC
LIMIT 1;


-- 16:Problem Identify the employee with the lowest salary in each department.

WITH RankedSalaries AS (
    SELECT 
        e.id AS employee_id,
        e.name AS employee_name,
        d.name AS department_name,
        e.salary,
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary ASC) AS rank
    FROM 
        employee e
    JOIN 
        department d ON e.department_id = d.id
)
SELECT 
    department_name,
    employee_name,
    salary
FROM 
    RankedSalaries
WHERE 
    rank = 1;


-- 17:Problem Find the difference between the highest and lowest salary in each department.

SELECT 
    d.name AS department_name, 
    MAX(e.salary) - MIN(e.salary) AS salary_difference
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name;



-- Manager-Employee Relationship

-- 18:Problem Query to Find Employees Earning More Than Their Manager


SELECT 
    e.name AS employee_name, 
    e.salary AS employee_salary, 
    m.name AS manager_name, 
    m.salary AS manager_salary
FROM 
    employee e
JOIN 
    employee m ON e.manager_id = m.id
WHERE 
    e.salary > m.salary;


    -- 19: Problem List all employees along with their managers' names.

    SELECT 
    e.name AS employee_name, 
    m.name AS manager_name
FROM 
    employee e
LEFT JOIN 
    employee m ON e.manager_id = m.id;



-- 20:Problem Find managers with no employees reporting to them.

SELECT 
    m.name AS manager_name
FROM 
    employee m
WHERE 
    m.id NOT IN (SELECT manager_id FROM employee WHERE manager_id IS NOT NULL);


-- 21:Problem Count the number of employees reporting to each manager.
SELECT 
    m.name AS manager_name, 
    COUNT(e.id) AS number_of_employees
FROM 
    employee e
JOIN 
    employee m ON e.manager_id = m.id
GROUP BY 
    m.id, m.name;


-- 22:Problem Find managers whose total team salary exceeds $200,000.

SELECT 
    m.name AS manager_name, 
    SUM(e.salary) AS team_salary
FROM 
    employee e
JOIN 
    employee m ON e.manager_id = m.id
GROUP BY 
    m.id, m.name
HAVING 
    SUM(e.salary) > 200000;


-- 23:Problem Find the top 3 highest-paid employees in the company.

SELECT 
    name, 
    salary
FROM 
    employee
ORDER BY 
    salary DESC
LIMIT 3;


-- 24:Problem List employees whose salary is below the company average.
SELECT 
    name, 
    salary
FROM 
    employee
WHERE 
    salary < (SELECT AVG(salary) FROM employee);


-- 25:Problem Find the average salary of employees reporting to each manager.
SELECT 
    m.name AS manager_name, 
    AVG(e.salary) AS average_salary
FROM 
    employee e
JOIN 
    employee m ON e.manager_id = m.id
GROUP BY 
    m.id, m.name;

-- 26:Problem List employees earning the median salary in their department.

WITH RankedSalaries AS (
    SELECT 
        e.id, 
        e.name, 
        e.salary, 
        e.department_id, 
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary) AS rank,
        COUNT(*) OVER (PARTITION BY e.department_id) AS total_employees
    FROM 
        employee e
)
SELECT 
    name, 
    salary
FROM 
    RankedSalaries
WHERE 
    rank = CEIL(total_employees / 2.0);

-- 27:Problem Find departments with more than 5 employees.

SELECT 
    d.name AS department_name, 
    COUNT(e.id) AS employee_count
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name
HAVING 
    COUNT(e.id) > 5;


-- 28: Problem List departments with no employees.

SELECT 
    d.name AS department_name
FROM 
    department d
LEFT JOIN 
    employee e ON d.id = e.department_id
WHERE 
    e.id IS NULL;


-- 29:Problem Find the highest and lowest salaries in each department.
SELECT 
    d.name AS department_name, 
    MAX(e.salary) AS highest_salary, 
    MIN(e.salary) AS lowest_salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name;

-- 30:Problem Find employees earning the second-highest salary company-wide.
SELECT 
    name, 
    salary
FROM 
    (SELECT 
         name, 
         salary, 
         RANK() OVER (ORDER BY salary DESC) AS rank
     FROM 
         employee) AS ranked
WHERE 
    rank = 2;

-- 31:Problem Find departments where the highest-paid employee earns more than $100,000.
SELECT 
    d.name AS department_name
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name
HAVING 
    MAX(e.salary) > 100000;


-- 32:Problem Rank employees within their department by salary and list the top 2 per department.

WITH RankedEmployees AS (
    SELECT 
        e.id, 
        e.name, 
        e.salary, 
        e.department_id, 
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank
    FROM 
        employee e
)
SELECT 
    e.id, 
    e.name, 
    e.salary, 
    e.department_id
FROM 
    RankedEmployees
WHERE 
    rank <= 2;


-- 33:Problem Identify employees who are paid more than the average salary in their department.

SELECT 
    e.name AS employee_name, 
    e.salary, 
    d.name AS department_name
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
WHERE 
    e.salary > (SELECT AVG(salary) FROM employee WHERE department_id = e.department_id);


-- 34:Problem Find managers whose team members are all earning below $50,000.

SELECT 
    m.name AS manager_name
FROM 
    employee m
WHERE 
    NOT EXISTS (
        SELECT 
            1
        FROM 
            employee e
        WHERE 
            e.manager_id = m.id 
            AND e.salary >= 50000
    );


-- 35:Problem Find the department with the highest difference between the highest and lowest salaries.
SELECT 
    d.name AS department_name, 
    MAX(e.salary) - MIN(e.salary) AS salary_difference
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.id, d.name
ORDER BY 
    salary_difference DESC
LIMIT 1;


-- 36:Problem Find employees who have had a salary increase (based on salary history).

SELECT 
    e.name AS employee_name, 
    e.salary AS current_salary,
    sh.salary AS previous_salary, 
    sh.change_date
FROM 
    employee e
JOIN 
    salary_history sh ON e.id = sh.employee_id
WHERE 
    sh.change_date > '2024-01-01' AND e.salary > sh.salary;


-- 37:Problem List departments with more than one employee earning the maximum salary in that department.
SELECT 
    d.name AS department_name,
    e.name AS employee_name,
    e.salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
WHERE 
    e.salary = (SELECT MAX(salary) FROM employee WHERE department_id = e.department_id)
GROUP BY 
    d.id, e.id
HAVING 
    COUNT(e.salary) > 1;


-- 38:Problem Identify employees whose salary is within 10% of the department's average salary.
SELECT 
    e.name AS employee_name, 
    e.salary, 
    d.name AS department_name
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
WHERE 
    ABS(e.salary - (SELECT AVG(salary) FROM employee WHERE department_id = e.department_id)) <= (0.1 * (SELECT AVG(salary) FROM employee WHERE department_id = e.department_id));


-- 39:Problem Find the department with the highest average salary for employees who have been with the company for more than 5 years.

SELECT 
    d.name AS department_name,
    AVG(e.salary) AS avg_salary
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
WHERE 
    e.hire_date < NOW() - INTERVAL 5 YEAR
GROUP BY 
    d.id
ORDER BY 
    avg_salary DESC
LIMIT 1;


-- 40:Problem Find employees who have more employees under their supervision than the company average
SELECT 
    m.name AS manager_name, 
    COUNT(e.id) AS team_size
FROM 
    employee e
JOIN 
    employee m ON e.manager_id = m.id
GROUP BY 
    m.id
HAVING 
    COUNT(e.id) > (SELECT AVG(employee_count) FROM (SELECT manager_id, COUNT(id) AS employee_count FROM employee GROUP BY manager_id) AS subquery);


-- 41:Problem List all employees and their direct and indirect managers (up to 3 levels).
WITH RECURSIVE ManagerHierarchy AS (
    SELECT 
        e.id AS employee_id, 
        e.name AS employee_name, 
        e.manager_id,
        1 AS level
    FROM 
        employee e
    WHERE 
        e.manager_id IS NOT NULL
    UNION ALL
    SELECT 
        e.id, 
        e.name, 
        e.manager_id, 
        mh.level + 1
    FROM 
        employee e
    JOIN 
        ManagerHierarchy mh ON e.manager_id = mh.employee_id
    WHERE 
        mh.level < 3
)
SELECT 
    employee_name, 
    level, 
    (SELECT name FROM employee WHERE id = manager_id) AS manager_name
FROM 
    ManagerHierarchy;


-- 42:Problem Find the highest paid employee in each management level.
WITH EmployeeLevel AS (
    SELECT 
        e.id,
        e.name,
        e.salary,
        e.manager_id,
        0 AS level
    FROM 
        employee e
    WHERE 
        e.manager_id IS NULL
    UNION ALL
    SELECT 
        e.id,
        e.name,
        e.salary,
        e.manager_id,
        el.level + 1
    FROM 
        employee e
    JOIN 
        EmployeeLevel el ON e.manager_id = el.id
)
SELECT 
    level,
    name AS employee_name,
    salary
FROM 
    EmployeeLevel
WHERE 
    (level, salary) IN (
        SELECT 
            level, 
            MAX(salary)
        FROM 
            EmployeeLevel
        GROUP BY 
            level
    );


-- 43:Problem Find employees who have worked for exactly 1 year.

SELECT 
    name, 
    DATEDIFF(CURDATE(), hire_date) AS days_worked
FROM 
    employee
WHERE 
    DATEDIFF(CURDATE(), hire_date) BETWEEN 365 AND 366;


-- 44: Problem Find the department with the highest employee turnover in the last 12 months.

SELECT 
    d.name AS department_name,
    COUNT(e.id) AS turnover_count
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
WHERE 
    e.termination_date BETWEEN NOW() - INTERVAL 12 MONTH AND NOW()
GROUP BY 
    d.id
ORDER BY 
    turnover_count DESC
LIMIT 1;


-- 45:Problem Calculate the length of service for each employee in years and months.
SELECT 
    name, 
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years,
    TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) % 12 AS months
FROM 
    employee;


-- 45:Problem Find the employee with the maximum salary increase over the last 12 months.

SELECT 
    e.name AS employee_name,
    MAX(sh.salary - sh.previous_salary) AS salary_increase
FROM 
    salary_history sh
JOIN 
    employee e ON sh.employee_id = e.id
WHERE 
    sh.change_date BETWEEN NOW() - INTERVAL 12 MONTH AND NOW()
GROUP BY 
    e.id
ORDER BY 
    salary_increase DESC
LIMIT 1;

-- 46:Problem Find employees whose salary is in the top 10% of their department.

WITH SalaryRank AS (
    SELECT 
        e.name, 
        e.salary, 
        e.department_id, 
        PERCENT_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS percentile
    FROM 
        employee e
)
SELECT 
    name, 
    salary, 
    department_id
FROM 
    SalaryRank
WHERE 
    percentile >= 0.9;


-- 47:Problem List employees who have worked under more than one manager.

SELECT 
    e.name AS employee_name
FROM 
    employee e
JOIN 
    (SELECT DISTINCT employee_id, manager_id FROM employee_history) eh
    ON e.id = eh.employee_id
GROUP BY 
    e.id
HAVING 
    COUNT(DISTINCT eh.manager_id) > 1;


-- 48:Problem Find the department with the most employees earning above the company average.

SELECT 
    d.name AS department_name, 
    COUNT(e.id) AS employee_count
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
WHERE 
    e.salary > (SELECT AVG(salary) FROM employee)
GROUP BY 
    d.id
ORDER BY 
    employee_count DESC
LIMIT 1;


-- 49:Problem Find all employees in a specific team and their managers (using recursive query).

WITH RECURSIVE EmployeeTeam AS (
    SELECT 
        e.id, 
        e.name, 
        e.manager_id, 
        1 AS level
    FROM 
        employee e
    WHERE 
        e.name = 'John Doe'  -- Starting point (team leader)
    UNION ALL
    SELECT 
        e.id, 
        e.name, 
        e.manager_id, 
        et.level + 1
    FROM 
        employee e
    JOIN 
        EmployeeTeam et ON e.manager_id = et.id
)
SELECT 
    id, name, manager_id, level
FROM 
    EmployeeTeam;
















