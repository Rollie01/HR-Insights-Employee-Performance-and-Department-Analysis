# HR Insights: Employee Performance and Department Analysis
Overview
This project simulates real-life HR analytics for a fictional company by querying and analyzing employee data. The purpose is to derive actionable insights into employee salaries, tenure, department structures, and management performance. The project demonstrates proficiency in SQL concepts, such as SELECT, JOIN, WHERE, GROUP BY, HAVING, subqueries, and aggregations.

**Table of Contents**
1. Project Objectives
2. Dataset Information
3. SQL Queries
      - Employee and Salary Insights
      - Department Analysis
      - Management and Promotions
      - Advanced Insights
      - Deliverables
      - Real-Life Applications
   
**Project Objectives**
Retrieve and analyze employee data to assist HR managers in decision-making.
Use advanced SQL queries to extract insights from complex relational data.
Simulate HR reporting tasks, including salary, tenure, and performance analysis.

**Dataset Information**
The analysis is based on a fictional company's database consisting of the following key tables:
      - employees: Details of all employees.
      - salaries: Employee salary information.
      - titles: Job titles of employees.
      - departments: Details of all departments.
      - dept_emp: Mapping of employees to departments.
      - dept_manager: Information about department managers.

**SQL Queries**
---------------------------------------------------------------------------------------
-- 1. Employee and Salary Insights
---------------------------------------------------------------------------------------
-- Query 1.1: Current Job Titles and Salaries
SELECT employees.emp_no, first_name, last_name, titles.title, salaries.salary
FROM employees
JOIN titles ON employees.emp_no = titles.emp_no
JOIN salaries ON employees.emp_no = salaries.emp_no;

-- Query 1.2: Top 5 Highest-Paid Employees
SELECT employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
ORDER BY salary DESC
LIMIT 5;

-- Query 1.3: Employees Above Average Salary
SELECT employees.first_name, employees.last_name, Salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salary > (SELECT AVG(salary) FROM salaries);

-- Query 1.4: Salary History for a Specific Employee
SELECT employees.emp_no, employees.first_name, employees.last_name, salaries.salary AS Sal_history
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.emp_no = 10001;

---------------------------------------------------------------------------------------
-- 2. Department Analysis
---------------------------------------------------------------------------------------
-- Query 2.1: Number of Employees per Department
SELECT departments.dept_name, COUNT(dept_emp.emp_no) AS No_of_Employees
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
GROUP BY dept_name;

-- Query 2.2: Total Salary per Department
SELECT dept_name, SUM(salary) AS Total_Salary
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
JOIN salaries ON dept_emp.emp_no = salaries.emp_no
GROUP BY dept_name
ORDER BY Total_Salary DESC;

-- Query 2.3: Longest-Serving Employee per Department
SELECT d.dept_name, e.emp_no, e.first_name, e.last_name, de.from_date, de.to_date,
       DATEDIFF(IFNULL(de.to_date, CURRENT_DATE), de.from_date) AS tenure_days
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN employees e ON de.emp_no = e.emp_no
WHERE DATEDIFF(IFNULL(de.to_date, CURRENT_DATE), de.from_date) = (
       SELECT MAX(DATEDIFF(IFNULL(de2.to_date, CURRENT_DATE), de2.from_date))
       FROM dept_emp de2
       WHERE de2.dept_no = d.dept_no
);

-- Query 2.4: Departments with Average Salary > 60,000
SELECT departments.dept_name, AVG(salary) AS avg_salary_Over_60k
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
JOIN salaries ON dept_emp.emp_no = salaries.emp_no
GROUP BY departments.dept_name
HAVING avg_salary_Over_60k > 60000;


---------------------------------------------------------------------------------------
-- 3. Management and Promotions
---------------------------------------------------------------------------------------
-- Query 3.1: Managers and Departments
SELECT dm.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS Full_name, d.dept_name, hire_date
FROM dept_manager dm
JOIN employees e ON dm.emp_no = e.emp_no
JOIN departments d ON dm.dept_no = d.dept_no;

-- Query 3.2: Employees with Multiple Titles
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS Full_name, COUNT(DISTINCT t.title) AS Title_greater_than_1
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
GROUP BY e.emp_no
HAVING Title_greater_than_1 > 1;

---------------------------------------------------------------------------------------
-- Query 4. Advanced Insights
---------------------------------------------------------------------------------------
-- Query 4.1: Employee Tenure Report
SELECT e.emp_no, e.first_name, e.last_name, 
       ROUND(DATEDIFF(IFNULL(de.to_date, CURRENT_DATE), de.from_date)/365.25, 2) AS tenure_years
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
ORDER BY tenure_years DESC;

-- Query 4.2: Employees vs. Managers' Salaries
SELECT employees.emp_no, CONCAT(first_name, ' ', last_name) AS names_of_employees, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.salary > (SELECT MAX(salary) 
                         FROM salaries 
                         WHERE emp_no IN (SELECT emp_no FROM dept_manager))
ORDER BY salaries.salary DESC;
