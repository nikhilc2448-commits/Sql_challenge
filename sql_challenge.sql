use sql_challenge;
-- SQL Challenge

-- Q1: Salary Ranking With Ties
SELECT dept, name, salary,
       DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS salary_rank,
       MAX(salary) OVER (PARTITION BY dept) - salary AS below_top_earner
FROM Employees
ORDER BY dept, salary DESC, name;

-- Q2: Month-Over-Month Growth
WITH monthly_sales AS (
    SELECT DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
           SUM(amount) AS total_sales
    FROM Sales
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
),
sales_with_previous AS (
    SELECT sale_month, total_sales,
           LAG(total_sales) OVER (ORDER BY sale_month) AS previous_month_total
    FROM monthly_sales
)
SELECT sale_month, total_sales, previous_month_total,
       CASE
           WHEN previous_month_total IS NULL OR previous_month_total = 0 THEN NULL
           ELSE ROUND((total_sales - previous_month_total) * 100.0
                      / previous_month_total, 2)
       END AS percentage_change
FROM sales_with_previous
ORDER BY sale_month;

-- Q3: Top Performer Per Region
WITH employee_region_sales AS (
    SELECT s.region, e.emp_id, e.name, SUM(s.amount) AS total_sales
    FROM Sales s
    JOIN Employees e ON e.emp_id = s.emp_id
    GROUP BY s.region, e.emp_id, e.name
),
ranked_sales AS (
    SELECT region, emp_id, name, total_sales,
           RANK() OVER (PARTITION BY region ORDER BY total_sales DESC) AS sales_rank
    FROM employee_region_sales
)
SELECT region, emp_id, name, total_sales
FROM ranked_sales
WHERE sales_rank = 1
ORDER BY region, name;

-- Q4: Employees With No Sales
SELECT e.emp_id, e.name, e.dept
FROM Employees e
LEFT JOIN Sales s ON s.emp_id = e.emp_id
WHERE s.sale_id IS NULL
ORDER BY e.dept, e.name;

-- Q5: Management Hierarchy Depth
WITH RECURSIVE hierarchy AS (
    SELECT emp_id, name, mgr_id, 1 AS level
    FROM Employees
    WHERE mgr_id IS NULL

    UNION ALL

    SELECT e.emp_id, e.name, e.mgr_id, h.level + 1
    FROM Employees e
    JOIN hierarchy h ON e.mgr_id = h.emp_id
)
SELECT level, COUNT(*) AS employee_count,
       GROUP_CONCAT(name SEPARATOR ', ') AS employee_names
FROM hierarchy
GROUP BY level
ORDER BY level;

-- Q6: Products Against Category Average
WITH product_prices AS (
    SELECT product_id, category, price,
           AVG(price) OVER (PARTITION BY category) AS category_average
    FROM Products
)
SELECT product_id, category, price,
       ROUND(category_average, 2) AS category_average,
       CASE
           WHEN category_average = 0 THEN NULL
           ELSE ROUND((price - category_average) * 100.0
                      / category_average, 2)
       END AS percentage_from_average
FROM product_prices
ORDER BY category, product_id;

-- Q7: Running Total and Moving Average
-- Moving average shows recent sales trends that running total does not.
WITH employee_sales AS (
    SELECT s.sale_id, e.name, s.sale_date, s.amount
    FROM Sales s
    JOIN Employees e ON e.emp_id = s.emp_id
    WHERE e.name = 'Priya'
)
SELECT sale_id, name, sale_date, amount,
       SUM(amount) OVER (
           ORDER BY sale_date, sale_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total,
       ROUND(AVG(amount) OVER (
           ORDER BY sale_date, sale_id
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS moving_average_3_sales
FROM employee_sales
ORDER BY sale_date, sale_id;

-- Q8: Tenure Bands
SELECT
    CASE
        WHEN hire_date < '2021-01-01' THEN 'Before 2021'
        WHEN hire_date < '2023-01-01' THEN '2021 to 2022'
        ELSE '2023 onward'
    END AS tenure_band,
    COUNT(*) AS headcount,
    ROUND(AVG(salary), 2) AS average_salary
FROM Employees
GROUP BY
    CASE
        WHEN hire_date < '2021-01-01' THEN 'Before 2021'
        WHEN hire_date < '2023-01-01' THEN '2021 to 2022'
        ELSE '2023 onward'
    END
ORDER BY average_salary DESC;