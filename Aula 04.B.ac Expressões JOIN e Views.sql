/*Questão 1. Gere uma lista de todos os instrutores, mostrando sua ID
nome e número de seções que eles ministraram. 
Não se esqueça de mostrar o número de seções como 0 para os instrutores que não ministraram qualquer seção.
Sua consulta deverá utilizar outer join e não deverá utilizar subconsultas escalares.
*/

SELECT instructor.id, instructor.name, COUNT(teaches.sec_id) AS number_of_sec
FROM instructor
LEFT OUTER JOIN 
teaches ON instructor.id = teaches.id
GROUP BY instructor.id, instructor.name
ORDER BY instructor.id; 

/*Questão 2. Escreva a mesma consulta do item anterior, mas usando uma subconsulta escalar, sem outer join.
*/

SELECT instructor.id, instructor.name, (SELECT COUNT(teaches.id)
FROM teaches
WHERE teaches.id = instructor.id) AS number_of_sec
FROM instructor
ORDER BY instructor.id;

/* Questão 3. Gere a lista de todas as seções de curso oferecidas na primavera de 2010, 
junto com o nome dos instrutores ministrando 
a seção. Se uma seção tiver mais de 1 instrutor,
ela deverá aparecer uma vez no resultado para cada instrutor.
Se não tiver instrutor algum, ela ainda deverá aparecer no resultado, com o nome do instrutor definido como “-”.
*/

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

/*Questão 4. Suponha que você tenha recebido uma relação grade_points (grade, points), 
que oferece uma conversão de conceitos (letras) na relação takes para notas numéricas;
por exemplo, uma nota “A+” poderia ser especificada para corresponder a 4 pontos, um “A” para 3,7 pontos, e “A-” para 3,4, e 
“B+” para 3,1 pontos, e assim por diante. 
Os Pontos totais obtidos por um aluno para uma oferta de curso (
section) são definidos como o número de créditos para o curso multiplicado pelos pontos numéricos para a nota que o aluno recebeu.
Dada essa relação e o nosso esquema university, escreva: 
Ache os pontos totais recebidos por aluno, para todos os cursos realizados por ele.
*/

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

--criação da tabela grade_points

CREATE TABLE grade_points (
    grade VARCHAR(2) PRIMARY KEY,
    points DECIMAL(3,1) NOT NULL
);

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

/* Questão 5. Crie uma view a partir do resultado da Questão 4 com o nome “coeficiente_rendimento”.
*/

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
