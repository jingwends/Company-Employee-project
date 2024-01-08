-- Retrieve the names of all employees in department 5 who work more than 10 hours per week on the ProductX project. 
SELECT E.Lname, E.Fname
FROM EMPLOYEE E JOIN WORKS_ON W ON
	 E.Ssn = W.Essn
     JOIN PROJECT P ON 
     P.Pnumber = W.Pno
WHERE Hours > 10 AND E.Dno = 5 AND P.Pname ='ProductX';

-- Find the names of all female employees who are directly supervised by ‘Franklin Wong’. 
-- E1 is the regular employee while E2 is the manager 
SELECT E1.Lname, E1.Fname
FROM EMPLOYEE E1 JOIN EMPLOYEE E2 ON 
	 E2.Ssn = E1.Super_ssn
WHERE E1.Sex = 'F' AND E2.Fname = "Franklin" AND E2.Lname = "Wong";

-- Retrieve the names of all employees whose supervisor’s supervisor has ‘888665555’ for Ssn
SELECT E1.Lname, E1.Fname
FROM EMPLOYEE E1 JOIN EMPLOYEE E2 ON 
	 E2.Ssn = E1.Super_ssn
     JOIN EMPLOYEE E3 ON
     E2.Super_ssn = E3.Ssn
WHERE E3.Ssn = '888665555' ;

-- Retrieve the names of all employees who do not work on any project.
-- Establish a new table Names E_P
SELECT E_P.Lname, E_P.Fname
FROM (SELECT E.Lname, E.Fname, W.Essn
	  FROM EMPLOYEE E LEFT JOIN WORKS_ON W
	  ON E.Ssn = W.Essn) AS E_P
WHERE E_P.Essn IS NULL;

-- A view that has the project name, controlling department name, number of employees, 
-- and total hours worked per week on the project for each project with more than one employee working on it. 
CREATE VIEW PRO_WORK AS
SELECT P.Pname, D.Dname, COUNT(W.Pno) AS N_Employee, SUM(W.Hours)
FROM PROJECT P 
JOIN DEPARTMENT D ON
	 P.Dnum = D.Dnumber
JOIN WORKS_ON W ON
     P.Pnumber = W.Pno
GROUP BY P.Pname; 

SELECT * FROM PRO_WORK; -- Show VIEW PRO_WORK


-- Bonus: Retrieve the names of all employees who work on every project. 
SELECT P.Pname, E.Fname, E.Minit, E.Lname
FROM PROJECT P 
LEFT JOIN WORKS_ON W ON
     P.Pnumber = W.Pno
JOIN EMPLOYEE E ON
	 W.Essn = E.Ssn
ORDER BY P.Pname;

-- fixed code for above question: 
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Ssn IN (SELECT Essn
FROM WORKS_ON
GROUP BY Essn
HAVING COUNT(*) IN (SELECT COUNT(*)
FROM PROJECT )
);

-- Find the names and addresses of all employees who work on at least one project located in Houston 
-- but whose department has no location in Houston.
SELECT E.Fname, E.Minit, E.Lname, E.Address
FROM EMPLOYEE E
JOIN DEPT_LOCATIONS L ON
	 L.Dnumber = E.Dno
JOIN WORKS_ON W ON
     W.Essn = E.Ssn
JOIN PROJECT P ON
	 P.Pnumber = W.Pno
WHERE P.Plocation = "Houston" AND 
	 E.Dno NOT IN (
	 SELECT L.Dnumber
     FROM DEPT_LOCATIONS L
     WHERE L.Dlocation = "Houston")
GROUP BY E.Fname, E.Minit, E.Lname, E.Address;

-- For each project, list the project name and the total hours per week (by all employees) spent on that project. 
SELECT P.Pname, SUM(W.Hours) AS Working_Hour
FROM PROJECT P
JOIN WORKS_ON W ON
	 W.Pno = P.Pnumber
GROUP BY W.Pno;       
