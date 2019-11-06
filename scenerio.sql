--Shows column names and data type in those columns
SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_name = 'naep';

--first 50 records of naep table
SELECT * FROM naep
LIMIT 50;

--Summary statistics for avg_math_4_score by state
SELECT COUNT(avg_math_4_score), MAX(avg_math_4_score), MIN(avg_math_4_score), AVG(avg_math_4_score), SUM(avg_math_4_score), state
FROM naep
GROUP BY state;
	
--takes the difference betweeen maximum and minimum avg_math_4_scores by state
--and if that difference is greater than 30 returns a list of those states at risk
WITH at_risk_states AS
(
SELECT state, MAX(avg_math_4_score), MIN(avg_math_4_score),
(MAX(avg_math_4_score) - MIN(avg_math_4_score)) as difference,
CASE
	WHEN (MAX(avg_math_4_score) - MIN(avg_math_4_score)) > 30 THEN 'Yes'
	ELSE 'No'
END as at_risk
FROM naep
GROUP BY state
ORDER BY at_risk DESC
)
SELECT * FROM at_risk_states
WHERE at_risk LIKE 'Yes';

--returns the 10 states with the lowest avg_math_4_score for the year 2000
SELECT state as bottom_10_states, avg_math_4_score
FROM naep
WHERE year = 2000
ORDER BY avg_math_4_score ASC
LIMIT 10;

--rounds the average avg_math_4_score for all states in the year 2000
--Returns 224.80
SELECT ROUND(AVG(avg_math_4_score), 2) as math_avg_2000
FROM naep
WHERE year = 2000;

--states below average in the year 2000
SELECT state, avg_math_4_score
FROM naep
WHERE avg_math_4_score < 224.8 AND year = 2000;

--states without data for avg_math_4_score in the year 2000
SELECT state as scores_missing_y2000
FROM naep
WHERE avg_math_4_score IS NULL AND year = 2000;

--compares the sum total_expenditure to to reveal a correlation I am not seeing
SELECT naep.state, ROUND(AVG(avg_math_4_score),2) as avg_math, SUM(total_expenditure)
FROM naep LEFT OUTER JOIN finance
ON naep.id = finance.id
WHERE naep.year = 2000 AND ROUND(avg_math_4_score,2) IS NOT NULL
GROUP BY naep.state
ORDER BY SUM(total_expenditure) DESC;

