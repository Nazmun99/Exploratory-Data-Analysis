USE EMPLOYEE;

RENAME TABLE city_of_chicago_payroll_data TO payroll;

-- Show first five records in your data.**
SELECT * 
FROM payroll
LIMIT 5;

-- COUNT Total number of rows
SELECT
     COUNT(*)
FROM payroll;

-- Get overview of the data
DESCRIBE payroll;

-- how many null values in each column
SELECT
    SUM(CASE WHEN `Name` IS NULL THEN 1 ELSE 0 END) AS Name_nulls,
    SUM(CASE WHEN `Job Titles` IS NULL THEN 1 ELSE 0 END) AS Job_title_nulls,
    SUM(CASE WHEN `Department` IS NULL THEN 1 ELSE 0 END) AS Department_nulls,
    SUM(CASE WHEN `Full or Part-Time` IS NULL THEN 1 ELSE 0 END) AS Time_nulls,
    SUM(CASE WHEN `Salary or Hourly` IS NULL THEN 1 ELSE 0 END) AS salary_hourly_nulls,
    SUM(CASE WHEN `Typical Hours` IS NULL THEN 1 ELSE 0 END) AS typical_hrs_nulls,
    SUM(CASE WHEN `Annual Salary` IS NULL THEN 1 ELSE 0 END) AS An_salary_nulls,
    SUM(CASE WHEN `Hourly Rate` IS NULL THEN 1 ELSE 0 END) AS Hourly_rate_nulls
FROM payroll;

-- 6. What are the maximum, minimum and average Typical Hours? (use 'Typical Hours' column)
SELECT
     CAST(`Typical Hours` AS DECIMAL(10,2)) AS Typical_hours
FROM payroll;

SELECT
     MAX(CAST(`Typical Hours` AS DECIMAL(10,2))) as Max,
     MIN(CAST(`Typical Hours` AS DECIMAL(10,2))) AS Min,
     AVG(CAST(`Typical Hours` AS DECIMAL(10,2))) AS avrg
FROM payroll;

-- 7. How many employees are on salary and how many are working on hourly basis?

SELECT
     `Salary or Hourly`,
     COUNT(*)
FROM payroll
GROUP BY `Salary or Hourly`;

WITH CTE AS
(SELECT
     Department,
     count(*) AS CNT
FROM payroll
GROUP BY Department
ORDER BY 2 DESC)
-- LIMIT 1;
SELECT
     Department,
     CNT
FROM CTE
WHERE CNT=(SELECT MAX(CNT) FROM CTE);

-- 9. How many employees are on Salary and how many are on Hourly in the Police department?

SELECT
     *
FROM payroll
WHERE Department='POLICE';

SELECT
     `Salary or Hourly`,
     COUNT(*)
FROM (SELECT
     *
FROM payroll
WHERE Department='POLICE') as CTE
GROUP BY `Salary or Hourly`;

-- **10. What are the mean, max and min salaries?
SELECT
     MIN(CAST(REPLACE(REPLACE(`Annual Salary`,'$', ''), ',', '') AS DECIMAL(10,2))) AS MN,
     MAX(CAST(REPLACE(REPLACE(`Annual Salary`,'$', ''), ',', '') AS DECIMAL(10,2))) AS MX,
     round(AVG(CAST(REPLACE(REPLACE(`Annual Salary`,'$', ''), ',' , '') AS DECIMAL(10,2))),2) AS AG
FROM payroll;

-- 11. Find the employee who has the maximum salary.
WITH CTE AS
(SELECT
     Name,
     CAST(REPLACE(REPLACE(`Annual Salary`,'$', ''), ',', '') AS DECIMAL(10,2)) as salary
FROM payroll)

SELECT
     Name,
     salary
FROM CTE
WHERE salary= (SELECT MAX(salary) from CTE);

-- 13. What are the mean, max and min Hourly Rate?
SELECT
     MAX(CAST(REPLACE(`Hourly Rate`,'$','') as DECIMAL(10,2))) AS Max,
	 MIN(CAST(REPLACE(`Hourly Rate`,'$','') as DECIMAL(10,2))) AS Min,
	 ROUND(AVG(CAST(REPLACE(`Hourly Rate`,'$','') as DECIMAL(10,2))),2) AS avg
FROM payroll;

-- 14. How many employees are getting max Hourly Rate?
WITH CTE AS
(SELECT
     Name,
     CAST(REPLACE(`Hourly Rate`,'$', '') AS DECIMAL(10,2)) as H_rate
FROM payroll)

SELECT
    COUNT(*)
FROM CTE
WHERE H_rate= (SELECT MAX(H_rate) from CTE);


-- 15. Who is getting max Hourly Rate?
WITH CTE AS
(SELECT
     Name,
     CAST(REPLACE(`Hourly Rate`,'$', '') AS DECIMAL(10,2)) as H_rate
FROM payroll)

SELECT
    Name
FROM CTE
WHERE H_rate= (SELECT MAX(H_rate) from CTE);

-- 16. How many employees are earning less than the average Hourly Rate?
WITH CTE AS
(SELECT
     Name,
     CAST(REPLACE(`Hourly Rate`,'$','') AS DECIMAL(10,2)) AS H_Rate
FROM payroll)

SELECT
     COUNT(H_Rate) AS Total
FROM CTE
WHERE H_Rate<(SELECT AVG(H_Rate) FROM CTE);

-- 17. How many employees are paid hourly and they have full-time job?
SELECT
     COUNT(*)
FROM payroll
WHERE `Salary or Hourly`='Hourly' AND `Full or Part-Time`='F';

-- 18. Find the full-time employees who are working at hourly rate of $10.00?
WITH CTE AS
(SELECT
      `Full or Part-Time`,
      (CAST(REPLACE(REPLACE(`Hourly Rate`,'$',''),',','') as DECIMAL(10,2))) as H_Rate
FROM payroll)

SELECT
     COUNT(*)
FROM CTE
WHERE `H_Rate`=10.00 AND `Full or Part-Time`='F';

-- 19. How many unique Job Titles are there in the data?
SELECT
     COUNT(DISTINCT `Job Titles`) as Total
FROM payroll;

-- 20. What was the average Salary of the employees in each department?

SELECT
     Department,
     AVG(CAST(REPLACE(REPLACE(`Annual Salary`,'$',''),',','') as DECIMAL(10,2))) AS Average_Salary
FROM payroll
GROUP BY Department;

-- 21. What is the job title of 'AGAR,  BULENT B'? please note, there are two spaces between AGAR, and BULENT.
SELECT
     Name,
	 `Job Titles`
FROM payroll
WHERE Name='AGAR,  BULENT B';

-- 22. What are the top most common job titles?
SELECT
     `Job Titles`,
     COUNT(*)
FROM payroll
GROUP BY `Job Titles`
ORDER BY 2 DESC
LIMIT 1;

-- 23. How many people have the word 'officer' in their job title? 
SELECT
     COUNT(*) as Officer_count
FROM payroll
WHERE  Lower(`Job Titles`) LIKE '%officer%';

-- 