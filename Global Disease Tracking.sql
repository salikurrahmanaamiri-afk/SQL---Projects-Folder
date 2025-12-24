-- Project: Global Disease Tracking (GIPTS) By Rahman Saliq

-- Create Database
CREATE DATABASE IF NOT EXISTS GIPTS_Project;
USE GIPTS_Project;

-- Create Table
CREATE TABLE IF NOT EXISTS Countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    population BIGINT,
    continent VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Variants (
    variant_id INT AUTO_INCREMENT PRIMARY KEY,
    variant_name VARCHAR(50) NOT NULL UNIQUE,
    lineage VARCHAR(20),
    discovery_date DATE
);

CREATE TABLE IF NOT EXISTS DailyCaseReports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT,
    variant_id INT,
    report_date DATE NOT NULL,
    new_cases INT DEFAULT 0,
    new_deaths INT DEFAULT 0,
    total_tests INT DEFAULT 0,
    -- Foreign Key Constraints
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    FOREIGN KEY (variant_id) REFERENCES Variants(variant_id),
    -- Unique constraint to prevent duplicate reporting on the same day for a country
    UNIQUE (country_id, report_date)
);

-- Insert data 
INSERT INTO Countries (country_name, population, continent) VALUES
('India', 1428000000, 'Asia'),
('USA', 335000000, 'North America'),
('Brazil', 214000000, 'South America'),
('Germany', 83000000, 'Europe'),
('Nigeria', 223000000, 'Africa'),
('Canada', 40000000, 'North America');

INSERT INTO Variants (variant_name, lineage, discovery_date) VALUES
('Wild Type', 'Wuhan-Hu-1', '2019-12-01'),
('Alpha', 'B.1.1.7', '2020-09-01'),
('Delta', 'B.1.617.2', '2020-10-01'),
('Omicron', 'B.1.1.529', '2021-11-24'),
('XBB.1.5', 'XBB', '2022-10-01');

INSERT INTO DailyCaseReports (country_id, variant_id, report_date, new_cases, new_deaths, total_tests) VALUES
(1, 3, '2023-10-01', 15000, 150, 500000),
(1, 3, '2023-10-02', 17000, 165, 520000),
(1, 4, '2024-01-01', 5000, 50, 100000),
(1, 4, '2024-01-02', 5500, 55, 110000);

INSERT INTO DailyCaseReports (country_id, variant_id, report_date, new_cases, new_deaths, total_tests) VALUES
(2, 4, '2023-10-01', 25000, 250, 800000),
(2, 4, '2023-10-02', 24000, 240, 780000),
(2, 5, '2024-01-01', 8000, 80, 200000);

INSERT INTO DailyCaseReports (country_id, variant_id, report_date, new_cases, new_deaths, total_tests) VALUES
(3, 3, '2023-10-01', 10000, 100, 300000),
(3, 4, '2024-01-01', 3000, 30, 60000);

INSERT INTO DailyCaseReports (country_id, variant_id, report_date, new_cases, new_deaths, total_tests) VALUES
(4, 4, '2024-01-01', 4500, 45, 90000);

INSERT INTO DailyCaseReports (country_id, variant_id, report_date, new_cases, new_deaths, total_tests) VALUES
(5, 4, '2024-01-01', 1200, 12, 30000);

-- SELECT & Filtering
SELECT report_date, new_cases, new_deaths FROM dailycasereports WHERE new_cases > 10000 AND new_deaths < 100;

-- Filtering by ID
SELECT report_date, new_cases, total_tests FROM dailycasereports WHERE country_id = 2;

-- String Filtering
SELECT variant_name, lineage FROM variants WHERE lineage LIKE 'B.1.%';

-- Aggregation
SELECT max(new_cases), min(total_tests) FROM dailycasereports;

-- ORDER BY
SELECT country_name, continent, population FROM countries ORDER BY population DESC;

-- Filtering by Date Range
SELECT variant_name, discovery_date FROM variants WHERE discovery_date BETWEEN '2020-01-01' AND '2021-01-01';

-- NULL and NOT NULL
SELECT country_name, continent FROM countries WHERE population IS NOT NULL ORDER BY continent;

-- Aggregation & Grouping
SELECT c.continent, avg(d.total_tests) as avg_test 
from dailycasereports d inner join countries c on d.country_id = c.country_id group by continent;

-- Calculated Column
SELECT c.country_name, d.report_date, (new_cases/total_tests)*100 as test_pos_rate 
from dailycasereports d inner join countries c on d.country_id = c.country_id order by report_date;

-- HAVING Clause
SELECT c.country_name, sum(d.new_cases) as total_case_count 
from dailycasereports d inner join countries c on d.country_id = c.country_id group by c.country_name having total_case_count > 50000;

-- Subquery (Scalar)
select country_name, population from countries where population = (select max(population) from countries);

-- LEFT JOIN & Filtering
select c.country_name from countries c left join dailycasereports d on d.country_id = c.country_id where d.country_id is null;

-- UNION/Set Operations
select country_name, 'Country' as source_type from countries union all select variant_name, 'Variant' as source_type from variants;

-- Joining Three Tables
select d.report_id, c.country_name, d.new_cases, v.variant_name 
from dailycasereports d inner join countries c on d.country_id = c.country_id inner join variants v on d.variant_id = v.variant_id;