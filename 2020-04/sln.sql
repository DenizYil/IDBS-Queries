-- employees(emp no, birthday, name)
-- departments(dept no, name)
-- dept_emp(emp no, dept no, from date, to date)
-- dept_manager(emp no, dept no, from date, to date)
-- salaries(emp no, salary, from date, to date)
-- titles(emp no, title, from date, to date)

-- A) 23228
SELECT COUNT(*) FROM employees
WHERE EXTRACT(year from birthday) = 1954;

-- B) 1957
SELECT EXTRACT(year from birthday) FROM dept_manager dm
JOIN departments d ON dm.dept_no = d.dept_no
JOIN employees e ON dm.emp_no = e.emp_no
WHERE dm.to_date is null AND d.name = 'Finance';

-- C) 2
SELECT COUNT(*) FROM (
	SELECT COUNT(dept_no) FROM dept_emp
	WHERE to_date is null
	GROUP BY dept_no
	HAVING COUNT(dept_no) > 50000
) X;

-- D
-- INVALID

-- E) 9456
-- Forstår ikke hvorfor denne her ikke virker
SELECT DISTINCT t.emp_no FROM (
	SELECT DISTINCT emp_no FROM titles
	WHERE title NOT LIKE '%Engineer'
) t
JOIN dept_emp de ON de.emp_no = t.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.name = 'Development';

SELECT COUNT(*) FROM (
	SELECT emp_no FROM dept_emp de
	JOIN departments d ON de.dept_no = d.dept_no
	WHERE d.name = 'Development'
	EXCEPT
	SELECT emp_no FROM titles
	WHERE title LIKE '%Engineer'
) X;

-- F)  7
SELECT COUNT(DISTINCT title) FROM dept_emp de
JOIN departments d ON d.dept_no = de.dept_no
JOIN titles t ON t.emp_no = de.emp_no
WHERE d.name = 'Development' AND de.to_date IS null;

-- G)
-- SELECT emp_no FROM titles T1
-- HAVING title LIKE '%Engineer' AND emp_no = (
-- 	SELECT * FROM titles T2
-- 	WHERE T1.emp_no = T2.emp_no
-- )

-- H

