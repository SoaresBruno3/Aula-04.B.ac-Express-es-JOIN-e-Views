SELECT instructor.id, instructor.name, COUNT(teaches.sec_id) AS number_of_sec
FROM instructor
LEFT OUTER JOIN 
teaches ON instructor.id = teaches.id
GROUP BY instructor.id, instructor.name
ORDER BY instructor.id; 

SELECT instructor.id, instructor.name, (SELECT COUNT(teaches.id)
FROM teaches
WHERE teaches.id = instructor.id) AS number_of_sec
FROM instructor
ORDER BY instructor.id;
 


SELECT 
s.course_id, s.sec_id, s.semester, s.year,
COALESCE(i.name, '-') AS instructor_name
FROM 
    section s
LEFT JOIN 
    teaches t ON s.course_id = t.course_id 
             AND s.sec_id = t.sec_id 
             AND s.semester = t.semester 
             AND s.year = t.year
LEFT JOIN 
    instructor i ON t.id = i.id
WHERE 
    s.semester = 'Spring' 
    AND s.year = 2010
ORDER BY 
    s.course_id, s.sec_id, instructor_name;

-- com a tabela grade points criada 
SELECT s.ID AS student_id, 
       s.name AS student_name, 
       c.title AS course_title, 
       c.dept_name, 
       t.grade, 
       g.points, 
       c.credits, 
       (c.credits * g.points) AS total_points
FROM takes t
JOIN student s ON t.ID = s.ID
JOIN course c ON t.course_id = c.course_id
JOIN grade_points g ON t.grade = g.grade
ORDER BY s.ID;
 
CREATE TABLE grade_points (
    grade VARCHAR(2) PRIMARY KEY,
    points DECIMAL(3,1) NOT NULL
);

--criação da tabela grade_points
INSERT INTO grade_points (grade, points) VALUES
('A+', 4.0), ('A', 3.7), ('A-', 3.4),
('B+', 3.1), ('B', 2.7), ('B-', 2.3),
('C+', 2.0), ('C', 1.7), ('C-', 1.3),
('D+', 1.0), ('D', 0.7), ('F', 0.0);

--resolução com ela criada 

SELECT student.id AS student_id, 
       student.name AS student_name, 
       c.title AS course_title, 
       c.dept_name, 
       t.grade, 
       g.points, 
       c.credits, 
       (c.credits * g.points) AS total_points
FROM takes t
JOIN student ON t.ID = student.id
JOIN course c ON t.course_id = c.course_id
JOIN grade_points g ON t.grade = g.grade
ORDER BY student.id;

-- caso não exsitir a tabela grade_points o when cria condições temporarias--
SELECT student.id AS student_id, 
       student.name AS student_name, 
       c.title AS course_title, 
       c.dept_name, 
       t.grade, 
       CASE 
           WHEN t.grade = 'A+' THEN 4.0
           WHEN t.grade = 'A' THEN 3.7
           WHEN t.grade = 'A-' THEN 3.4
           WHEN t.grade = 'B+' THEN 3.1
           WHEN t.grade = 'B' THEN 2.7
           WHEN t.grade = 'B-' THEN 2.3
           WHEN t.grade = 'C+' THEN 2.0
           WHEN t.grade = 'C' THEN 1.7
           WHEN t.grade = 'C-' THEN 1.3
           WHEN t.grade = 'D+' THEN 1.0
           WHEN t.grade = 'D' THEN 0.7
           WHEN t.grade = 'F' THEN 0.0
           ELSE NULL 
       END AS points,
       c.credits, 
       (c.credits * 
           CASE 
               WHEN t.grade = 'A+' THEN 4.0
               WHEN t.grade = 'A' THEN 3.7
               WHEN t.grade = 'A-' THEN 3.4
               WHEN t.grade = 'B+' THEN 3.1
               WHEN t.grade = 'B' THEN 2.7
               WHEN t.grade = 'B-' THEN 2.3
               WHEN t.grade = 'C+' THEN 2.0
               WHEN t.grade = 'C' THEN 1.7
               WHEN t.grade = 'C-' THEN 1.3
               WHEN t.grade = 'D+' THEN 1.0
               WHEN t.grade = 'D' THEN 0.7
               WHEN t.grade = 'F' THEN 0.0
               ELSE NULL 
           END
       ) AS total_points
FROM takes t
JOIN student ON t.ID = student.ID
JOIN course c ON t.course_id = c.course_id
ORDER BY student.ID;


CREATE VIEW coef_rendi AS
SELECT student.ID AS student_id, 
       student.name AS student_name, 
       course.title AS course_title, 
       course.dept_name, 
       takes.grade, 
       grade_points.points, 
       course.credits, 
       (course.credits * grade_points.points) AS total_points
FROM takes
JOIN student ON takes.ID = student.ID
JOIN course ON takes.course_id = course.course_id
JOIN grade_points ON takes.grade = grade_points.grade;

SELECT * FROM coef_rendi; 