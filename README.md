# SQL Challenge

## Overview

This project contains SQL solutions for 8 business-oriented query challenges using the `Employees`, `Sales`, and `Products` tables.

## Challenges Covered

- **Q1:** Salary ranking with ties using `DENSE_RANK()`
- **Q2:** Month-over-month sales growth using `LAG()`
- **Q3:** Top sales performer per region with tie handling
- **Q4:** Employees with no recorded sales
- **Q5:** Management hierarchy using a recursive CTE
- **Q6:** Product prices compared with category averages
- **Q7:** Running total and 3-sale moving average for an employee
- **Q8:** Employee tenure bands with headcount and average salary

## SQL Concepts

- Joins
- Aggregations
- CTEs
- Recursive CTEs
- Window Functions
- `DENSE_RANK()`
- `RANK()`
- `LAG()`
- `SUM() OVER()`
- `AVG() OVER()`
- `MAX() OVER()`
- `CASE`
- `DATE_FORMAT()`
- `GROUP_CONCAT()`
- Percentage calculations

Setup & Execution

Open MySQL Workbench.
Create or select a database.
Run SQL Challenge Setup.sql to create and populate the tables.
Run sql_challenge.sql to execute all 8 solutions.
Review the result of each query.

Requirements

MySQL 8.0+
MySQL Workbench or any compatible MySQL client

Author

NikhilChougale
