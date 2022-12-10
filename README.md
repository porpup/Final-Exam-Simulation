# PL-SQL_Final_Exam

#### Question 1:
An instance of table emp is as follow:
<pre>--------------------------------------------------
| empno |  ename |  hiredate   | Job     | salary |
--------------------------------------------------
| 1     |  Joe   |  12-12-2000 | CLERK   | 3000   |
| 2     |  Adam  |  10-10-2000 | MANAGER | 5000   |
--------------------------------------------------</pre>
Create an overloading functions named find_emp_info which 
returns a number represent the number of year of experiences 
if a date is passed into the function.

If an employee number is passed to the function 
find_emp_info, it will return the job of the employee. 
<br>    HINT: the age of a person can be found using the formula:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FLOOR((sysdate - birthdate)/365.25)

We need to display all columns of the table emp, create a 
procedure that accepts an employee number. Using the 
overloading functions find_emp_info just created previously 
to find, to calculate and to display the following: 
<br>Employee number Y is N, an J with X years of experiences 
        earning a salary of $S

Where Y is employee number, N is employee name, J is the job, 
S is the salary, and X is number of years of experiences. 
<br>Any negative value inserted into the procedure is considered 
as an ERROR, you must handle this error with an EXCEPTION, 
and display appropriate message. 

Can you handle the case when the employee number inserted 
does not exist? 
<br>If yes, please make sure to display 
appropriate message when this happens. 
<br>Write a command to run 
the procedure and the expected result.

#### Question 2: (use script 7Northwoods)
Working with table student, create a function called 
your_name_find_age that accepts the student_id s_dob, 
to calculate the age of the student using the formula:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Age = FLOOR((sysdate birthdate)/365.25)

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
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Student number X is Y Z Born on the M, N year old.
<br>OR
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Student number X is Y Z Not born yet.

Where X is the student ID, Y and Z are full name, M is the 
birthdate and N is the age returned from the function.

#### Question 3: (use script EMP_DEPT(scott))
We need to display all departments and the employees 
who work in each department. Create a procedure to 
display the department name and the location of each 
department. 
<br>Under each department, display the name, 
job, salary, hiredate, and the number of years of 
experiences of the employee who work for the department.

#### Question 4: (use script EMP_DEPT(scott))
Create a table to audit the table emp as follow:

CREATE TABLE audit_emp (audit_id NUMBER, old_empno NUMBER, old_ename NUMBER, old_hiredate DATE, old_salary NUMBER, old_job VARCHAR2(40), updating_user VARCHAR2(30), date_updated DATE)

Create a trigger for the table EMP used to record the old 
name, hiredate, job, salary, who and when the table emp is updated.

#### Question 5: (use script oleksandr(scott_and_7Northwood))
Create a package specification and package body (name the package:
your_name_final with all the procedures and functions of question 2, 3.

Execute the package’s procedure at least 3 times.
