--- SQL Project: Employee Management System Analysis;

--------------------------------------------------------------------------------------------------------------------------
-- 1. Employee and Salary Insights
--------------------------------------------------------------------------------------------------------------------------
-- Find all employees along with their current job titles and salaries
SELECT employees.emp_no, first_name, last_name, titles.title, salaries.salary
FROM employees
JOIN titles ON employees.emp_no = titles.emp_no
JOIN salaries ON employees.emp_no = salaries.emp_no;

-- Identify the top 5 highest-paid employees in the company.
SELECT employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
ORDER BY salary DESC
LIMIT 5; 

-- Find employees whose salaries are above the company-wide average salary.
SELECT employees.first_name, employees.last_name, Salary 
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salary > (
		SELECT AVG(salary) 
		FROM salaries);

-- Retrieve the salary history for a specific employee (e.g., employee with emp_no = 10001).
SELECT employees.emp_no, employees.first_name, employees.last_name, salaries.salary AS Sal_history
FROM employees
JOIN Salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.emp_no = 10001;


--------------------------------------------------------------------------------------------------------------------------
-- 2. Department Analysis
--------------------------------------------------------------------------------------------------------------------------
-- List all departments and the number of employees in each department.
SELECT departments.dept_name, COUNT(dept_emp.emp_no) AS No_of_Employees
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
GROUP BY dept_name;


SELECT COUNT(emp_no)
FROM employees;

-- Retrieve the total salary paid in each department.
SELECT dept_name, SUM(salary) AS Total_Salary
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
JOIN salaries ON dept_emp.emp_no = salaries.emp_no
GROUP BY dept_name
ORDER BY Total_Salary DESC;

-- Find the longest-serving employee in each department.
SELECT d.dept_name, e.emp_no, e.first_name, e.last_name, de.from_date, de.to_date, 
       DATEDIFF(IFNULL(de.to_date, CURRENT_DATE), de.from_date) AS tenure_days
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN employees e ON de.emp_no = e.emp_no
WHERE DATEDIFF(IFNULL(de.to_date, CURRENT_DATE), de.from_date) = (
    SELECT MAX(DATEDIFF(IFNULL(de2.to_date, CURRENT_DATE), de2.from_date))
    FROM dept_emp de2
    WHERE de2.dept_no = d.dept_no
)
ORDER BY d.dept_name
LIMIT 5;

-- Identify departments where the average salary is greater than 60,000.
SELECT departments.dept_name, AVG(salary) AS avg_salary_Over_60k
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
JOIN salaries ON dept_emp.emp_no = salaries.emp_no
GROUP BY departments.dept_name
HAVING avg_salary_Over_60k > 60000;


--------------------------------------------------------------------------------------------------------------------------
-- 3. Management and Promotions
--------------------------------------------------------------------------------------------------------------------------
-- List all managers and the departments they manage, along with their hire dates.
SELECT dm.emp_no, concat(e.first_name, ' ', e.last_name) AS Full_name, d.dept_name, hire_date
FROM dept_manager dm
JOIN employees e ON dm.emp_no = e.emp_no 
JOIN departments d ON dm.dept_no = d.dept_no;

-- Identify employees who have held more than one title during their tenure.
SELECT e.emp_no, concat(e.first_name, ' ', e.last_name) AS Full_name, COUNT(DISTINCT t.title) AS Title_greater_than_1
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
GROUP BY e.emp_no
HAVING Title_greater_than_1 > 1;

-- Find employees who work in the same department as a specific employee eg. employee with emp_no = 10001).
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.dept_no = (
    SELECT de2.dept_no
    FROM dept_emp de2
    WHERE de2.emp_no = 10001
);

--------------------------------------------------------------------------------------------------------------------------
-- 4. Advanced Insights
--------------------------------------------------------------------------------------------------------------------------
-- Generate a report showing each employee's tenure (in years) in the company.
SELECT e.emp_no, 
	   e.first_name, 
       e.last_name, de.to_date, 
       de.from_date, 
       IFNULL(de.to_date, CURRENT_DATE) AS to_date, 
       ROUND(DATEDIFF(IFNULL (de.to_date, CURRENT_DATE), de.from_date)/360.25,2) AS tenure_years
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
ORDER BY tenure_years DESC;

-- Find the percentage of employees in each department compared to the total number of employees.
SELECT dept_emp.dept_no, 
	   departments.dept_name, 
       count(emp_no) AS employee_count, 
       '300024' AS  total_employee_count, 
       ROUND(count(emp_no)/'300024'*100,2) AS Percentage_of_total
FROM dept_emp 
JOIN departments ON dept_emp.dept_no = departments.dept_no
GROUP BY departments.dept_name
ORDER BY Percentage_of_total DESC;

-- Retrieve employees who have salaries higher than the highest-paid manager.
SELECT employees.emp_no, CONCAT(first_name,' ', last_name) AS names_of_employees, Salaries.Salary 
FROM employees 
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.salary > (SELECT MAX(salary)
								FROM salaries
                                WHERE emp_no IN (SELECT emp_no FROM dept_manager))

ORDER BY salaries.salary DESC;

-- Identify the employee(s) with the longest overall tenure in the company.
SELECT employees.emp_no, 
	   CONCAT(first_name, ' ', last_name) AS full_name, 
       IFNULL(dept_emp.to_date, CURRENT_DATE) AS to_date, 
       dept_emp.from_date, 
       ROUND(DATEDIFF(IFNULL(dept_emp.to_date, CURRENT_DATE), dept_emp.from_date)/365.25,2) AS longest_overall_tenure
FROM employees 
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
ORDER BY longest_overall_tenure DESC
LIMIT 1;
















