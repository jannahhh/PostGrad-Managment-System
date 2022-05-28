--1.a. Register to the website by using my name (First and last name), password, faculty, email, and address.
EXEC StudentRegister 'amr','salem', 'amr', 'engineering','1' ,'amr@gmail.com','rehab'
select * from postGradUser;

EXEC SupervisorRegister 'slim', 'abdelnadder','slim' ,'cs','slim@guc.edu.eg'
select * FROM supervisor

--2.a. login using my username and password.
DECLARE @successOut BIT ;
EXEC userLogin 1,'jannah1', @successOut Output 
PRINT @successOut

--2.b.add my mobile number(s).
EXEC addMobile 6 , '0111567891'
EXEC addMobile 10 , '0111563391'
select * FROM GUCStudentPhoneNumber
SELECT * from NonGucianStudent

--3.a. List all supervisors in the system.%
EXEC  AdminListSup

--3.b. view the profile of any supervisor that contains all his/her information%
EXEC AdminViewSupervisorProfile 4

--3.c. List all Theses in the system.%
EXEC AdminViewAllTheses

--3.d. List the number of on going theses.%

DECLARE @Count INT
EXEC AdminViewOnGoingTheses @Count Output
PRINT @Count

--3.e. List all supervisors’ names currently supervising students, theses title, student name.%
EXEC AdminViewStudentThesisBySupervisor

--3.f. List nonGucians names, course code, and respective grade.%
EXEC AdminListNonGucianCourse 2

--3.g. Update the number of thesis extension by 1.%
EXEC AdminUpdateExtension 1
select * FROM Thesis

--3.h. Issue a thesis payment.
DECLARE @Successbit BIT 
EXEC AdminIssueThesisPayment 2 , 20000,2,20,@Successbit Output 
PRINT @Successbit
SELECT * FROM Thesis
SELECT * FROM Payment


--3.i. view the profile of any student that contains all his/her information
EXEC AdminViewStudentProfile 10 


--3.j. issue installments as per the number of installments for a certain payment every six months starting from the entered date.
EXEC AdminIssueInstallPayment 1, '02/1/2022 '
select * From installment

--3.k. List the title(s) of accepted publication(s) per thesis.
EXEC AdminListAcceptPublication  

--3.l Add courses and link courses to students
EXEC AddCourse '605',6,3000

EXEC linkCourseStudent  2, 12
select * from NonGucianStudentTakeCourse
select * from ExaminerEvaluateDefense

EXEC addStudentCourseGrade 2 ,12,90

--3.m View examiners and supervisor(s) names attending a thesis defense taking place on a certain date.
EXEC ViewExamSupDefense '04/07/2010' -- no output 

----- supervisor 4
--(4.a): -- Evaluate a student’s progress report, and give evaluation value 0 to 3.
EXEC EvaluateProgressReport 4,16,1,0



--(4.b):--View all my students’s names and years spent in the thesis. %
EXEC ViewSupStudentsYears 4

--(4.c):--View my profile and update my personal information.%
EXEC SupViewProfile 4
EXEC UpdateSupProfile 5, SALEM, EMS

--(4.d):----View all publications of a student %
EXEC ViewAStudentPublications 7


select * from GUCianStudentRegisterThesis

--(4.e):----Add defense for a thesis, for nonGucian students all courses’ grades should be greater than 50 percent %
EXEC AddDefenseGucian 1,'2020-01-01','auc'
EXEC AddDefenseNonGucian 4,'04/07/2010','GUC'


--(4.f):----- Add examiner(s) for a defense 
EXEC AddExaminer 2 , '1900-01-01' , 'KIMZO' , 0 , 'GAMING' 


--(4.g):----- Cancel a Thesis if the evaluation of the last progress report is zero
EXEC CancelThesis 16

--(4.h):----Add a grade for a thesis
EXEC AddGrade 1, 78

---5.a
EXEC AddDefenseGrade 1 , '1/1/1900' , 100
 --5.b
 EXEC AddCommentsGrade 1 , '1/1/1900' ,'good'

--6.a
EXEC viewMyProfile 7

--6.b
EXEC editMyProfile 7,'jannah3','gabr','amrsalem16','janna3@gmail.com','el maadi','masters'

--6.c
EXEC addUndergradID 7 ,"01101010"

--6.d
EXEC ViewCoursesGrades 11

--6.e
 exec ViewCoursePaymentsInstall 12  

--6.e
EXEC  ViewThesisPaymentsInstall 6

--6.e
EXEC ViewUpcomingInstallments 7 

--6.e
EXEC ViewMissedInstallments 6 

--6.f
exec AddProgressReport 1,'01/01/2015' 

--6.f
exec  FillProgressReport 1,12,12,'asmasm'

--6.g
EXEC ViewEvalProgressReport 4 ,1 

--6.h
EXEC addPublication 'publication' ,'1/1/2021','host','guc',1 

--6.i
EXEC linkPubThesis 1, 1



