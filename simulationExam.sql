SPOOL /tmp/oracle/simulationExam.txt

SELECT
    TO_CHAR(SYSDATE, 'DD Month YYYY Year Day HH:MI:SS AM')
FROM
    DUAL;

/* Question 1:
An instance of table emp is as follow:
--------------------------------------------------
| empno |  ename |  hiredate   | Job     | salary |
--------------------------------------------------
| 1     |  Joe   |  12-12-2000 | CLERK   | 3000   |
| 2     |  Adam  |  10-10-2000 | MANAGER | 5000   |
-------------------------------------------------
Create an overloading functions named find_emp_info which 
returns a number represent the number of year of experiences 
if a date is passed into the function.

If an employee number is passed to the function 
find_emp_info, it will return the job of the employee. 
    hint: the age of a person can be found using the formula: 
        FLOOR((sysdate - birthdate)/365.25)

We need to display all columns of the table emp, create a 
procedure that accepts an employee number. Using the 
overloading functions find_emp_info just created previously 
to find, to calculate and to display the following: 
        Employee number Y is N, an J with X years of experiences 
        earning a salary of $S

Where Y is employee number, N is employee name, J is the job, 
S is the salary, and X is number of years of experiences. 
Any negative value inserted into the procedure is considered 
as an ERROR, you must handle this error with an EXCEPTION, 
and display appropriate message. 

Can you handle the case when the employee number inserted 
does not exist? If yes, please make sure to display 
appropriate message when this happens. Write a command to run 
the procedure and the expected result. */
CONNECT scott/tiger

SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE oleksandr_pck AS
    FUNCTION find_emp_info(p_hiredate DATE)
    RETURN NUMBER;
    
    FUNCTION find_emp_info(p_empno NUMBER)
    RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY oleksandr_pck AS
    FUNCTION find_emp_info(p_hiredate DATE)
    RETURN NUMBER AS
    BEGIN
        RETURN FLOOR((sysdate - p_hiredate) / 365.25);
    END;

    FUNCTION find_emp_info(p_empno NUMBER) 
    RETURN VARCHAR2 AS
    v_job VARCHAR2(30);
    BEGIN
        SELECT
            JOB
        INTO
            v_job
        FROM
            EMP
        WHERE
            EMPNO = p_empno;
        RETURN v_job;
    END;
END;
/

CREATE OR REPLACE PROCEDURE proc1 (p_empno NUMBER) AS
v_hiredate DATE;
v_sal NUMBER;
v_year NUMBER;
v_ename VARCHAR2(50);
v_job VARCHAR2(50);
e_neg_empno EXCEPTION;
BEGIN
    IF p_empno < 0 THEN
        RAISE e_neg_empno;
    END IF;

    SELECT
        HIREDATE,
        SAL,
        ENAME,
        JOB
    INTO
        v_hiredate,
        v_sal,
        v_ename,
        v_job
    FROM
        EMP
    WHERE
        EMPNO = p_empno;
    DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno || ' EXIST!');
    v_year := oleksandr_pck.find_emp_info(v_hiredate);
    DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno || ' is ' || v_ename || ', an '
                        || v_job || ' with ' || v_year || 
                        ' years of experiences earning a salary of $' || v_sal);
EXCEPTION
    WHEN e_neg_empno THEN
        DBMS_OUTPUT.PUT_LINE('Please insert positive empno!');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno || ' does NOT EXIST!');
END;
/

EXEC PROC1(7369);

EXEC PROC1(8000);





/* Question 2: (use script 7Northwoods)
Working with table student, create a function called 
your_name_find_age that accepts the student_id s_dob, 
to calculate the age of the student using the formula:
        Age = FLOOR((sysdate birthdate)/365.25)

Create a procedure called your_name_p1 that accepts 
student id, s_last, s_first, s_dob to INSERT or UPDATE 
table student (If the student ID is exist, it is an UPDATE. 
Otherwise, it is an INSERT)

For an INSERT the value of the birthdate can be in the 
pass or in the future. BUT, for an UPDATE a birthdate 
in the FUTURE is considered an ERROR, please create an
EXCEPTION to handle this kind of error.

After the UPDATE or INSERT is committed, please display 
the confirmation of the action performed (record updated 
OR record inserted) and use the f unction your_name_find_age
to display the student’s information EITHER as:
            Student number X is Y Z Born on the M, N year old.
        OR
            Student number X is Y Z Not born yet.

Where X is the student ID, Y and Z are full name, M is the 
birthdate and N is the age returned from the function. */
CONNECT des03/des03

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION oleksandr_find_age (p_s_id NUMBER, p_s_dob date) 
RETURN NUMBER AS
BEGIN
    RETURN FLOOR((SYSDATE - p_s_dob) / 365.25);
END;
/

CREATE OR REPLACE PROCEDURE oleksandr_p1 (p_s_id NUMBER, p_s_last VARCHAR2, 
                                            p_s_first VARCHAR2, p_s_dob DATE) AS
v_age NUMBER;
e_age EXCEPTION;
BEGIN
    IF p_s_dob > SYSDATE THEN
        RAISE e_age;
    ELSE 
        UPDATE STUDENT
        SET
            S_LAST = p_s_last,
            S_FIRST = p_s_first,
            S_DOB = p_s_dob
        WHERE
            S_ID = p_s_id;
        DBMS_OUTPUT.PUT_LINE('Student UPDATED!');
        v_age := oleksandr_find_age(p_s_id, p_s_dob);
        DBMS_OUTPUT.PUT_LINE('Student number ' || p_s_id || ' is ' || 
                            p_s_last || ' ' || p_s_first || '. Born on the ' ||
                            p_s_dob || ', ' || v_age || ' years old.');
    COMMIT;
    END IF;
EXCEPTION
    WHEN e_age THEN
        DBMS_OUTPUT.PUT_LINE('Student number ' || p_s_id || ' is ' || 
                            p_s_last || ' ' || p_s_first || '. Not born yet.');
    WHEN NO_DATA_FOUND THEN
        INSERT INTO STUDENT (
                            S_ID,
                            S_LAST,
                            S_FIRST,
                            S_DOB
        ) VALUES (
                    p_s_id,
                    p_s_last,
                    p_s_first,
                    p_s_dob
        );
        DBMS_OUTPUT.PUT_LINE('Student INSERTED!');
        v_age := oleksandr_find_age(p_s_id, p_s_dob);
        DBMS_OUTPUT.PUT_LINE('Student number ' || p_s_id || ' is ' || 
                            p_s_last || ' ' || p_s_first || '. Born on the ' ||
                            p_s_dob || ', ' || v_age || ' years old.');
    COMMIT;
END;
/

EXEC oleksandr_p1(15, 'Smith', 'John', sysdate - 1);

EXEC oleksandr_p1(15, 'Smith', 'John', sysdate - 1);

EXEC oleksandr_p1(15, 'Smith', 'John', sysdate + 1);





/* Question 3: (use script EMP_DEPT(scott))
We need to display all departments and the employees 
who work in each department. Create a procedure to 
display the department name and the location of each 
department. Under each department, display the name, 
job, salary, hiredate, and the number of years of 
experiences of the employee who work for the department. */
CONNECT scott/tiger

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE oleksandr_p3 AS
v_years_of_exp NUMBER;
BEGIN
    FOR i IN (
                SELECT
                    DEPTNO,
                    DNAME,
                    LOC
                FROM
                    DEPT
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Department ' || i.DEPTNO || ' is ' || i.DNAME || 
                            ' located in ' || i.LOC);

        FOR j IN (
                    SELECT
                        EMPNO,
                        ENAME,
                        JOB,
                        SAL,
                        HIREDATE
                    FROM
                        EMP
                    WHERE
                        DEPTNO = i.DEPTNO
        ) LOOP
            v_years_of_exp := oleksandr_pck.find_emp_info(j.HIREDATE);
            DBMS_OUTPUT.PUT_LINE('Employee NO.:' || j.EMPNO || ' is ' || j.ENAME || 
                                ', a ' || j.JOB || ', with salary $' || j.SAL || ', hired on ' || j.HIREDATE || '. Years of expirience: ' || v_years_of_exp);
        END LOOP;
    
    END LOOP;
END;
/

EXEC oleksandr_p3





/* Question 4: (use script EMP_DEPT(scott))
Create a table to audit the table emp as follow:
        CREATE TABLE audit_emp (audit_id NUMBER, 
                                old_empno NUMBER, 
                                old_ename NUMBER, 
                                old_hiredate DATE, 
                                old_salary NUMBER, 
                                old_job VARCHAR2(40), 
                                updating_user VARCHAR2(30), 
                                date_updated DATE)
Create a trigger for the table EMP used to record the old 
name, hiredate, job, salary, who and when the table emp is updated. */
CONNECT scott/tiger

CREATE SEQUENCE emp_row_audit_seq;

CREATE TABLE emp_row_audit(audit_id NUMBER, 
                            old_empno NUMBER, 
                            old_ename VARCHAR2(40), 
                            old_hiredate DATE, 
                            old_salary NUMBER, 
                            old_job VARCHAR2(40), 
                            updeting_user VARCHAR2(30), 
                            updated_date DATE);

CREATE OR REPLACE TRIGGER emp_row_audit_trigger
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    INSERT INTO emp_row_audit 
    VALUES (
            emp_row_audit_seq.NEXTVAL, 
            :OLD.empno, 
            :OLD.ename, 
            :OLD.hiredate, 
            :OLD.sal, 
            :OLD.job, 
            user,
            sysdate            
    );
END;
/

GRANT SELECT, UPDATE ON EMP TO des02;

GRANT SELECT, UPDATE ON EMP TO des03;

CONNECT des03/des03

UPDATE scott.EMP 
SET SAL = 10000 
WHERE EMPNO = 7369;
COMMIT;

CONNECT des02/des02

UPDATE scott.EMP 
SET ENAME = 'Polo' 
WHERE EMPNO = 7369;
COMMIT;

CONNECT scott/tiger

SET LINESIZE 1000;

select * from emp_row_audit;





/*Question 5: (use script oleksandr(scott_and_7Northwood))
Create a package specification and package body (name the package:
your_name_final with all the procedures and functions of question 2,3.

Execute the package’s procedure at least 3 times. */
CONNECT oleksandr/123

SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE oleksandr_final IS
    FUNCTION oleksandr_find_age (p_s_id NUMBER, p_s_dob date) 
    RETURN NUMBER;

    PROCEDURE oleksandr_p1 (p_s_id NUMBER, p_s_last VARCHAR2, 
                                            p_s_first VARCHAR2, p_s_dob DATE);

    PROCEDURE oleksandr_p3;
END;
/

CREATE OR REPLACE PACKAGE BODY oleksandr_final IS
    FUNCTION oleksandr_find_age (p_s_id NUMBER, p_s_dob date) 
    RETURN NUMBER AS
    BEGIN
        RETURN FLOOR((SYSDATE - p_s_dob) / 365.25);
    END;

    PROCEDURE oleksandr_p1 (p_s_id NUMBER, p_s_last VARCHAR2, 
                                                p_s_first VARCHAR2, p_s_dob DATE) AS
        v_age NUMBER;
        e_age EXCEPTION;
    BEGIN
        IF p_s_dob > SYSDATE THEN
            RAISE e_age;
        ELSE 
            UPDATE STUDENT
            SET
                S_LAST = p_s_last,
                S_FIRST = p_s_first,
                S_DOB = p_s_dob
            WHERE
                S_ID = p_s_id;
            DBMS_OUTPUT.PUT_LINE('Student UPDATED!');
            v_age := oleksandr_find_age(p_s_id, p_s_dob);
            DBMS_OUTPUT.PUT_LINE('Student number ' || p_s_id || ' is ' || 
                                p_s_last || ' ' || p_s_first || '. Born on the ' ||
                                p_s_dob || ', ' || v_age || ' years old.');
        COMMIT;
        END IF;
    EXCEPTION
        WHEN e_age THEN
            DBMS_OUTPUT.PUT_LINE('Student number ' || p_s_id || ' is ' || 
                                p_s_last || ' ' || p_s_first || '. Not born yet.');
        WHEN NO_DATA_FOUND THEN
            INSERT INTO STUDENT (
                                S_ID,
                                S_LAST,
                                S_FIRST,
                                S_DOB
            ) VALUES (
                        p_s_id,
                        p_s_last,
                        p_s_first,
                        p_s_dob
            );
            DBMS_OUTPUT.PUT_LINE('Student INSERTED!');
            v_age := oleksandr_find_age(p_s_id, p_s_dob);
            DBMS_OUTPUT.PUT_LINE('Student number ' || p_s_id || ' is ' || 
                                p_s_last || ' ' || p_s_first || '. Born on the ' ||
                                p_s_dob || ', ' || v_age || ' years old.');
        COMMIT;
    END;

    PROCEDURE oleksandr_p3 AS
    v_years_of_exp NUMBER;
    BEGIN
        FOR i IN (
                    SELECT
                        DEPTNO,
                        DNAME,
                        LOC
                    FROM
                        DEPT
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('----------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Department ' || i.DEPTNO || ' is ' || i.DNAME || 
                                ' located in ' || i.LOC);

            FOR j IN (
                        SELECT
                            EMPNO,
                            ENAME,
                            JOB,
                            SAL,
                            HIREDATE
                        FROM
                            EMP
                        WHERE
                            DEPTNO = i.DEPTNO
            ) LOOP
                v_years_of_exp := FLOOR((sysdate - j.HIREDATE) / 365.25);
                DBMS_OUTPUT.PUT_LINE('Employee NO.:' || j.EMPNO || ' is ' || j.ENAME || 
                                    ', a ' || j.JOB || ', with salary $' || j.SAL || ', hired on ' || j.HIREDATE || '. Years of expirience: ' || v_years_of_exp);
            END LOOP;
        
        END LOOP;
    END;

END;
/

SELECT oleksandr_final.oleksandr_find_age (1, SYSDATE - 1000)
FROM DUAL;

SELECT oleksandr_final.oleksandr_find_age (1, SYSDATE - 13800)
FROM DUAL;

SELECT oleksandr_final.oleksandr_find_age (1, SYSDATE + 7984)
FROM DUAL;


EXEC oleksandr_final.oleksandr_p1 (10, 'Pitt', 'Brad', SYSDATE - 1000)

EXEC oleksandr_final.oleksandr_p1 (10, 'Tiger', 'Scott', SYSDATE - 13800)

EXEC oleksandr_final.oleksandr_p1 (10, 'Bond', 'James', SYSDATE + 1000)


EXEC oleksandr_final.oleksandr_p3


SPOOL OFF;