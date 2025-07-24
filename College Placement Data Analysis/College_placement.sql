-- Creating The Database
CREATE DATABASE college_placement;

-- Creating The Table in The Database
CREATE TABLE student (
    College_ID VARCHAR,
    IQ INT,
    Prev_Sem_Result FLOAT,
    CGPA FLOAT,
    Academic_Performance INT,
    Internship_Experience VARCHAR,
    Extra_Curricular_Score INT,
    Communication_Skills INT,
    Projects_Completed INT,
    Placement VARCHAR
);


-- Viewing First 5 Data of our dataset
SELECT * FROM student LIMIT 5;

-- 1. DATA QUALITY CHECKS
-- Q1.1. How many rows are in the dataset?
SELECT COUNT(*) FROM student; 

-- Q1.2. Any null/missing values?
SELECT 
	SUM(CASE WHEN college_id IS NULL THEN 1 ELSE 0 END) AS Missing_college_id,
	SUM(CASE WHEN iq IS NULL THEN 1 ELSE 0 END) AS Missing_iq,
	SUM(CASE WHEN prev_sem_result IS NULL THEN 1 ELSE 0 END) AS Missing_prev_sem_result,
	SUM(CASE WHEN cgpa IS NULL THEN 1 ELSE 0 END) AS Missing_cgpa,
	SUM(CASE WHEN academic_performance IS NULL THEN 1 ELSE 0 END) AS Missing_academic_performance,
	SUM(CASE WHEN internship_experience IS NULL THEN 1 ELSE 0 END) AS Missing_internship_experience,
	SUM(CASE WHEN extra_curricular_score IS NULL THEN 1 ELSE 0 END) AS Missing_extra_curricular_score,
	SUM(CASE WHEN communication_skills IS NULL THEN 1 ELSE 0 END) AS Missing_communication_skills,
	SUM(CASE WHEN projects_completed IS NULL THEN 1 ELSE 0 END) AS Missing_projects_completed,
	SUM(CASE WHEN placement IS NULL THEN 1 ELSE 0 END) AS Missing_placement
FROM student;

-- Q1.3. Are College_IDs really unique to 100 colleges?
SELECT COUNT(DISTINCT College_id) AS Total_college_id
FROM student;

-- 2. OVERALL PLACEMENT INSIGHTS
-- Q2.1. What is the distribution of placed vs. unplaced students?
WITH placed_and_non_placed AS (
	SELECT 
		placement, 
		COUNT(*) AS no_of_students
	FROM student
	GROUP BY placement
),
total_students AS (
	SELECT COUNT(*) AS total FROM student
)
SELECT 
	p.placement, 
	p.no_of_students,
	ROUND(p.no_of_students * 100.0 / t.total, 2) AS placement_rate
FROM placed_and_non_placed p
CROSS JOIN total_students t;

-- Q2.2. Placement rate by internship experience
SELECT 
	internship_experience,
    COUNT(*) AS Total_Students,
    SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) AS Placed_Students,
    ROUND(SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Placement_Rate
FROM student
GROUP BY internship_experience;

-- 3. ACADEMIC PERFORMANCE
-- Q3.1. Average CGPA of placed vs not placed students
SELECT 
	placement,
	ROUND(AVG(cgpa)::Decimal,2) AS average_cgpa,
	ROUND(AVG(prev_sem_result)::Decimal,2) AS average_prev_sem_result,
	ROUND(AVG(Academic_Performance)::Decimal,2) AS AvgAcademicPerformance
FROM student
GROUP BY placement;

-- Q3.2. Placement rate by Academic_Performance rating
SELECT
    Academic_Performance,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) AS PlacedStudents,
    ROUND((SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2) AS PlacementRate
FROM student
GROUP BY Academic_Performance
ORDER BY Academic_Performance;

-- Q3.3. Placement rate by CGPA ranges (Example: 0-6, 6-7, 7-8, 8-9, 9-10)
SELECT
    CASE
        WHEN CGPA >= 9.0 THEN '9.0 - 10.0'
        WHEN CGPA >= 8.0 THEN '8.0 - 8.9'
        WHEN CGPA >= 7.0 THEN '7.0 - 7.9'
        WHEN CGPA >= 6.0 THEN '6.0 - 6.9'
        ELSE 'Below 6.0'
    END AS CGPA_Range,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) AS PlacedStudents,
    ROUND((SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2) AS PlacementRate
FROM student
GROUP BY CGPA_Range
ORDER BY CGPA_Range;

-- 4. Experience, Skills, and Placement
-- Q4.1. Impact of Internship Experience on Placement Rate
SELECT 
	internship_experience,
    COUNT(*) AS Total_Students,
    SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) AS Placed_Students,
    ROUND(SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Placement_Rate
FROM student
GROUP BY internship_experience;

-- Q4.2. Placement rate by number of Projects_Completed
SELECT
    Projects_Completed,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) AS PlacedStudents,
    ROUND(SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Placement_Rate
FROM student
GROUP BY Projects_Completed
ORDER BY Projects_Completed;

-- Q4.3. Average Communication Skills score for placed vs. unplaced students
SELECT
    Placement,
    ROUND(AVG(Communication_Skills)::Decimal, 2) AS AvgCommunicationSkills
FROM student
GROUP BY Placement;

-- Q4.4. Placement rate by Extra_Curricular_Score ranges
SELECT
    CASE
        WHEN Extra_Curricular_Score >= 8 THEN 'Excellent (8-10)'
        WHEN Extra_Curricular_Score >= 5 THEN 'Good (5-7)'
        ELSE 'Average/Low (0-4)'
    END AS EC_Score_Range,
    COUNT(*) AS TotalStudents,
    ROUND(SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END),2) AS PlacedStudents,
    ROUND((SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2) AS PlacementRate
FROM student
GROUP BY EC_Score_Range
ORDER BY EC_Score_Range;

-- 5. IQ and Other Factors
-- Q5.1. Average IQ for placed vs. unplaced students
SELECT
    Placement,
    ROUND(AVG(IQ),2) AS AvgIQ
FROM student
GROUP BY Placement;

-- Q5.2. Placement rate by IQ ranges
SELECT
    CASE
        WHEN IQ >= 120 THEN 'Very High (>=120)'
        WHEN IQ >= 110 THEN 'High (110-119)'
        WHEN IQ >= 90 THEN 'Average (90-109)'
        ELSE 'Below Average (<90)'
    END AS IQ_Range,
    COUNT(*) AS TotalStudents,
    ROUND(SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END),2) AS PlacedStudents,
    ROUND((SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2) AS PlacementRate
FROM student
GROUP BY IQ_Range
ORDER BY IQ_Range;

-- Q5.3. Top 5 colleges with the highest placement rates
SELECT
    College_ID,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) AS PlacedStudents,
    ROUND((SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2) AS PlacementRate
FROM student
GROUP BY College_ID
ORDER BY PlacementRate DESC
LIMIT 5;

-- 5.4. Average CGPA and Academic Performance for placed students, grouped by IQ range (to see if IQ + academics correlate)
SELECT
    CASE
        WHEN IQ >= 120 THEN 'Very High (>=120)'
        WHEN IQ >= 110 THEN 'High (110-119)'
        WHEN IQ >= 90 THEN 'Average (90-109)'
        ELSE 'Below Average (<90)'
    END AS IQ_Range,
    ROUND(AVG(CGPA)::DECIMAL,2) AS AvgCGPA_Placed,
    ROUND(AVG(Academic_Performance)::DECIMAL,2) AS AvgAcademicPerformance_Placed
FROM student
WHERE Placement = 'Yes'
GROUP BY IQ_Range
ORDER BY IQ_Range;

-- 6. Identifying High-Impact Factors and Combinations
-- Q6.1. Placement rate for students with high CGPA AND internship experience
SELECT
    ROUND(SUM(CASE WHEN Placement = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS PlacementRate
FROM student
WHERE CGPA > 8.0 AND Internship_Experience = 'Yes';

-- Q6.2. Profile of placed students with lower CGPA but high Communication and Projects
SELECT
    COUNT(*) AS NumberOfStudents,
    ROUND(AVG(CGPA)::DECIMAL,2) AS AvgCGPA,
    ROUND(AVG(Communication_Skills)::DECIMAL,2) AS AvgCommSkills,
    CEIL(AVG(Projects_Completed)) AS AvgProjects
FROM student
WHERE Placement = 'Yes'
  AND CGPA < (SELECT AVG(CGPA) FROM student WHERE Placement = 'Yes') -- Lower than average CGPA for placed
  AND Communication_Skills >= 8
  AND Projects_Completed >= 3;

-- Q6.3. Typical profile of placed vs. unplaced students
SELECT
    Placement,
    CEIL(AVG(IQ)) AS AvgIQ,
    CEIL(AVG(Prev_Sem_Result)) AS AvgPrevSemResult,
    CEIL(AVG(CGPA)) AS AvgCGPA,
    CEIL(AVG(Academic_Performance)) AS AvgAcademicPerformance,
    CEIL(AVG(CASE WHEN Internship_Experience = 'Yes' THEN 1 ELSE 0 END) * 100) AS PctInternshipExperience,
    CEIL(AVG(Extra_Curricular_Score)) AS AvgExtraCurricularScore,
    CEIL(AVG(Communication_Skills)) AS AvgCommunicationSkills,
    CEIL(AVG(Projects_Completed)) AS AvgProjectsCompleted
FROM student
GROUP BY Placement;


SELECT * FROM STUDENT;