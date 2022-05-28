--Register to the website by using my name (First and last name), password, faculty, email, and address.
GO
CREATE PROCEDURE StudentRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@faculty varchar(20),
@Gucian bit,
@email VARCHAR (50),
@address varchar(50)
AS
BEGIN
INSERT INTO PostGradUser VALUES(@email,@password);
declare  @PostGrad_id int ;

select @PostGrad_id = max(id)
from PostGradUser
where email = @email and password= @password ;
IF (@Gucian = 1 )
INSERT INTO GucianStudent VALUES( @PostGrad_id, @first_name, @last_name, null, @faculty, @address,null,null)
ELSE 
INSERT INTO NonGucianStudent VALUES(@PostGrad_id,@first_name,@last_name,null,@faculty,@address,null)
END


go 
CREATE PROCEDURE SupervisorRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20), 
@faculty varchar(20),
@email varchar(50)
AS
BEGIN
INSERT INTO PostGradUser VALUES(@email,@password);
declare  @PostGrad_id int ;
select @PostGrad_id = max(id)
from PostGradUser
where email = @email and password= @password ;
INSERT INTO supervisor VALUES(@PostGrad_id,@first_name,@faculty)
END


--login using my username and password.
GO
CREATE PROCEDURE userLogin
@id int ,
@password varchar(20), 
@success bit output
AS 
BEGIN 
IF EXISTS (
SELECT * FROM PostGradUser 
WHERE @id = id AND @password =[password])
SET @success ='1';
else 
SET @success ='0'
end 


--add my mobile number(s).
GO
CREATE PROCEDURE addMobile
@ID int, 
@mobile_number varchar(20)
AS
BEGIN
IF EXISTS (select id from GucianStudent WHERE id=@ID)
INSERT into GUCStudentPhoneNumber VALUES(@ID,@mobile_number)
else 
INSERT into NonGUCStudentPhoneNumber values (@ID,@mobile_number)
end 


--List all supervisors in the system.
GO 
CREATE PROCEDURE AdminListSup
AS 
SELECT * FROM Supervisor 



--view the profile of any supervisor that contains all his/her information
GO
CREATE PROCEDURE AdminViewSupervisorProfile
@supId int 
AS 
BEGIN
select * FROM supervisor WHERE supervisor.id = @supId 
end


--List all Theses in the system.
GO
CREATE PROCEDURE AdminViewAllTheses
AS
SELECT * FROM Thesis 


--List the number of on going theses.
GO 
create PROCEDURE AdminViewOnGoingTheses
@thesesCount int OUTPUT
AS
BEGIN
SELECT COUNT(*) FROM Thesis where endDate >= CURRENT_TIMESTAMP
set  @thesesCount = COUNT(*)
END
 

--List all supervisors’ names currently supervising students, theses title, student name.
GO
create PROCEDURE AdminViewStudentThesisBySupervisor 
AS 
BEGIN
SELECT S.firstname , T.title ,G.firstName  FROM supervisor S  
INNER JOIN GUCianStudentRegisterThesis  ON S.id = GUCianStudentRegisterThesis.supId
INNER join thesis T on GUCianStudentRegisterThesis.serial_no=T.serialNumber
INNER JOIN GucianStudent G ON GUCianStudentRegisterThesis.sid = G.id 
WHERE T.endDate >= CURRENT_TIMESTAMP 

UNION

SELECT S.firstname , T.title ,NG.firstName  FROM supervisor S  
INNER JOIN NonGUCianStudentRegisterThesis  ON S.id = NonGUCianStudentRegisterThesis.supId 
INNER join thesis T on NonGUCianStudentRegisterThesis.serial_no= T.serialNumber 
INNER JOIN NonGucianStudent NG ON NonGUCianStudentRegisterThesis.sid = NG.id
WHERE T.endDate >= CURRENT_TIMESTAMP 
END

--List nonGucians names, course code, and respective grade.
GO
CREATE PROCEDURE AdminListNonGucianCourse
@courseID int
AS
SELECT NonGucianStudent.firstName,NonGucianStudent.lastName,C.cid,C.grade FROM NonGucianStudent 
INNER JOIN NonGucianStudentTakeCourse C on NonGucianStudent.id = C.sid
WHERE C.cid = @courseID


--Update the number of thesis extension by 1.
GO
CREATE PROCEDURE AdminUpdateExtension
@ThesisSerialNo int
AS
BEGIN
UPDATE Thesis
SET noExtension = noExtension+1 
WHERE serialNumber = @ThesisSerialNo;
END



--Issue a thesis payment. 
GO
CREATE PROCEDURE AdminIssueThesisPayment
@ThesisSerialNo int, 
@amount decimal, 
@noOfInstallments int, 
@fundPercentage decimal,
@success bit OUTPUT
AS
BEGIN
DECLARE @payid int 
INSERT into Payment(amount,no_installments,fundPercentage) VALUES (@amount,@noOfInstallments,@fundPercentage)
SET @payid = SCOPE_IDENTITY(); 
UPDATE Thesis SET  Thesis.payment_id=@payid WHERE Thesis.serialNumber = @ThesisSerialNo
IF EXISTS (select * from Payment where Payment.id=@payid)
SET @success =1 
ELSE SET @success =0 
END


--view the profile of any student that contains all his/her information
GO
CREATE PROCEDURE AdminViewStudentProfile
@sid int
AS 
BEGIN
IF exists (SELECT * FROM GucianStudent WHERE id=@sid)
SELECT * FROM GucianStudent WHERE id=@sid
ELSE
SELECT * FROM NonGucianStudent WHERE id=@sid
END


--issue installments as per the number of installments for a certain payment every six months starting from the entered date.
GO
CREATE PROCEDURE AdminIssueInstallPayment
@paymentID int, @InstallStartDate date
AS
BEGIN
DECLARE @Counter INT 
DECLARE @installDate DATE = @InstallStartDate
DECLARE @amount int 
DECLARE @no_installments INT
SELECT @amount= Payment.amount ,@no_installments=Payment.no_installments From Payment WHERE Payment.id=@paymentID 
SET @Counter=0
SET @amount = @amount /@no_installments
WHILE (@Counter < @no_installments)
BEGIN
    INSERT INTO installment VALUES(@installDate,@paymentID,@amount,1);
    set @Counter +=1 
    set @installDate= DATEADD(MONTH,6,@installDate)
END;
END


--List the title(s) of accepted publication(s) per thesis.
GO
create PROCEDURE AdminListAcceptPublication
AS
BEGIN
SELECT P.title,T.title As thesis_titles FROM Publication P ,ThesisHasPublication TP, Thesis T WHERE P.id = TP.pubid AND accepted=1 
END


--Add courses and link courses to students
GO
CREATE PROCEDURE AddCourse
@courseCode varchar(10), 
@creditHrs int, 
@fees decimal
AS
BEGIN 
INSERT INTO course (code,creditHours,fees)VALUES(@courseCode,@creditHrs,@fees)
END


GO
CREATE PROCEDURE linkCourseStudent
@courseID int, @studentID int
AS
BEGIN
INSERT INTO NonGucianStudentTakeCourse VALUES (@studentID,null,@courseID)
END


GO 
CREATE PROCEDURE addStudentCourseGrade
@courseID int, @studentID int, @grade decimal
AS
BEGIN
UPDATE NonGucianStudentTakeCourse SET grade= @grade WHERE sid=@studentID AND cid=@courseID
END


--3.m View examiners and supervisor(s) names attending a thesis defense taking place on a certain date.
GO
CREATE PROCEDURE ViewExamSupDefense
@defenseDate datetime
AS
BEGIN
SELECT examiner.name as examiner_name ,S.firstName AS supervisor_Name from Thesis T INNER JOIN Defense D ON T.serialNumber=D.serialNumber 
INNER JOIN GUCianStudentRegisterThesis GRegister ON T.serialNumber=GRegister.serial_no
INNER JOIN supervisor S ON GRegister.supid=S.id 
INNER JOIN ExaminerEvaluateDefense E ON D.serialNumber = E.serialNo
INNER JOIN Examiner on E.examinerID = Examiner.id
WHERE T.defenseDate = @defenseDate
UNION
SELECT examiner.name as examiner_name ,S.firstName AS supervisor_Name from Thesis T INNER JOIN Defense D ON T.serialNumber=D.serialNumber 
INNER JOIN NonGUCianStudentRegisterThesis NGRegister ON T.serialNumber=NGRegister.serial_no
INNER JOIN supervisor S ON NGRegister.supid=S.id
INNER JOIN ExaminerEvaluateDefense E ON D.serialNumber = E.serialNo
INNER JOIN Examiner on E.examinerID = Examiner.id
WHERE T.defenseDate = @defenseDate
END


-----------------------------------------------------------------------------------------

-- 4) supervisor

--a
-- Evaluate a student’s progress report, and give evaluation value 0 to 3.
go
CREATE PROCEDURE EvaluateProgressReport
@supervisorID int,
@thesisSerialNo int,
@progressReportNo int,
@evaluation int
AS 
IF EXISTS (select *
from GucianProgressReport
where GucianProgressReport.no=@progressReportNo
)
BEGIN
UPDATE GucianProgressReport
SET eval=@evaluation
where supid= @supervisorID and thesisSerialNumber=@thesisSerialNo and no=@progressReportNo
END
ELSE
BEGIN
select *
from NonGucianProgressReport
WHERE NonGucianProgressReport.no=@progressReportNo
UPDATE NonGucianProgressReport
SET eval=@evaluation
where supid= @supervisorID and thesisSerialNumber=@thesisSerialNo and no=@progressReportNo
END 

--b
--View all my students’s names and years spent in the thesis
go
CREATE PROCEDURE ViewSupStudentsYears
@supervisorID int
AS
BEGIN 
SELECT GucianStudent.firstName, GucianStudent.lastName, Thesis.years
FROM GucianStudent INNER JOIN GUCianStudentRegisterThesis ON GucianStudent.id= GUCianStudentRegisterThesis.sid
INNER JOIN Thesis ON Thesis.serialNumber= GUCianStudentRegisterThesis.serial_no 
WHERE GUCianStudentRegisterThesis.supid= @supervisorID
union 
SELECT NonGucianStudent.firstName, NonGucianStudent.lastName, Thesis.years
FROM NonGucianStudent INNER JOIN NonGUCianStudentRegisterThesis ON NonGucianStudent.id= NonGUCianStudentRegisterThesis.sid
INNER JOIN Thesis ON Thesis.serialNumber= NonGUCianStudentRegisterThesis.serial_no 
WHERE NonGUCianStudentRegisterThesis.supid= @supervisorID
END


go

--c
--View my profile and update my personal information
GO
CREATE PROCEDURE SupViewProfile
@supervisorID int

AS
begin
SELECT * 
FROM PostGradUser INNER JOIN supervisor ON PostGradUser.id=Supervisor.id
WHERE supervisor.id=@supervisorID
END



GO
CREATE PROC UpdateSupProfile
@supervisorID int, @name varchar(20), @faculty varchar(20)
AS
BEGIN

UPDATE Supervisor 
SET firstName= @name, faculty=@faculty
WHERE supervisor.id=@supervisorID

END

--d
--View all publications of a student
go
create procedure ViewAStudentPublications
@StudentID int
AS
if exists (select * 
            from GucianStudent
            where GucianStudent.id= @StudentID)
BEGIN
select * 
from GUCianStudentRegisterThesis inner join ThesisHasPublication on GUCianStudentRegisterThesis.serial_no=ThesisHasPublication.serial_no
                    inner join publication on ThesisHasPublication.pubid= publication.id
END
ELSE 
BEGIN 
select *
from NonGUCianStudentRegisterThesis inner join ThesisHasPublication on NonGUCianStudentRegisterThesis.serial_no=ThesisHasPublication.serial_no
                    inner join publication on ThesisHasPublication.pubid= publication.id
end


--e
--Add defense for a thesis, for nonGucian students all courses’ grades should be greater than 50 percent
go
create procedure AddDefenseGucian
@ThesisSerialNo int,
@DefenseDate Datetime,
@DefenseLocation varchar(15)
AS
BEGIN

declare @studentID INT
IF EXISTS (
SELECT GUCianStudentRegisterThesis.sid From GUCianStudentRegisterThesis where GUCianStudentRegisterThesis.serial_no = @ThesisSerialNo)

INSERT INTO Defense(serialNumber,date,location)VALUES(@ThesisSerialNo,@DefenseDate,@DefenseLocation)
END



--Add defense for a thesis, for nonGucian students all courses’ grades should be greater than 50 percent.
go
create procedure AddDefenseNonGucian
@ThesisSerialNo int,
@DefenseDate Datetime,
@DefenseLocation varchar(15)

AS
BEGIN
declare @studentID INT
select @studentID =  NonGUCianStudentRegisterThesis.sid From NonGUCianStudentRegisterThesis where NonGUCianStudentRegisterThesis.serial_no = @ThesisSerialNo

if NOT EXISTS( 
SELECT * 
FROM NonGucianStudentTakeCourse where NonGucianStudentTakeCourse.sid=@studentID
AND NonGucianStudentTakeCourse.grade<=50)
INSERT INTO Defense(serialNumber,date,location) VALUES (@ThesisSerialNo,@DefenseDate, @DefenseLocation)
END


--f
-- Add examiner(s) for a defense
go
CREATE PROCEDURE AddExaminer
@ThesisSerialNo int, @DefenseDate Datetime, @ExaminerName varchar(20), @National bit, @fieldOfWork varchar(20)
AS
BEGIN
INSERT INTO PostGradUser(email,password) VALUES(NULL,NULL)
declare @examinerid int = Scope_IDentity()
INSERT INTO Examiner (id, name, fieldOfWork,isNational) VALUES (@examinerid,@ExaminerName,@fieldOfWork,@National)
INSERT INTO ExaminerEvaluateDefense (date,serialNo,examinerID,comment) 
VALUES (@DefenseDate,@ThesisSerialNo,@examinerid,NULL)
END

--g
-- Cancel a Thesis if the evaluation of the last progress report is zero
go
CREATE PROC  CancelThesis
@ThesisSerialNo int
AS
BEGIN
IF EXISTS (SELECT * 
FROM GucianProgressReport
WHERE GucianProgressReport.thesisSerialNumber=@ThesisSerialNo
)
AND (SELECT TOP 1 eval from GucianProgressReport
WHERE GucianProgressReport.thesisSerialNumber=@ThesisSerialNo
ORDER BY GucianProgressReport.date DESC  
) = 0
BEGIN
DELETE FROM Thesis
WHERE Thesis.serialNumber=@ThesisSerialNo
END

ELSE IF EXISTS (SELECT * 
FROM NonGucianProgressReport
WHERE NonGucianProgressReport.thesisSerialNumber=@ThesisSerialNo
)
AND (SELECT TOP 1 eval from NonGucianProgressReport
WHERE NonGucianProgressReport.thesisSerialNumber=@ThesisSerialNo
ORDER BY NonGucianProgressReport.date DESC  
) = 0
BEGIN
DELETE FROM Thesis
WHERE Thesis.serialNumber=@ThesisSerialNo
END

ELSE
print 'this thesis doesnt have any progress reports'
END


--update GucianProgressReport set eval =0 where sid=19
--select * from GucianProgressReport
--h
--Add a grade for a thesis
go
CREATE PROC AddGrade
@ThesisSerialNo int,
@gradeG decimal
AS
BEGIN
IF EXISTS(SELECT *
FROM Thesis
WHERE Thesis.serialNumber=@ThesisSerialNo
)
BEGIN
UPDATE Thesis
SET grade= @gradeG
WHERE thesis.serialNumber= @ThesisSerialNo
END
ELSE
print 'this serial number doesn not exist'
END

------------------------------------------------------------------------------------------------


--Add grade for a defense.
GO
CREATE PROC AddDefenseGrade
@ThesisSerialNo int , 
@DefenseDate Datetime ,
@grade decimal
AS
IF exists(select * from Defense where Defense.serialNumber=@ThesisSerialNo and Defense.[date]=@DefenseDate)
BEGIN
UPDATE Defense
set Defense.grade=@grade
WHERE defense.serialNumber=@ThesisSerialNo AND Defense.[date]=@DefenseDate
END


--Add comments for a defense.
GO 
create PROC AddCommentsGrade
@ThesisSerialNo int , @DefenseDate Datetime , 
@comments varchar(300)
as 
UPDATE ExaminerEvaluateDefense 
set ExaminerEvaluateDefense.comment=@comments
WHERE ExaminerEvaluateDefense.serialNo=@ThesisSerialNo and ExaminerEvaluateDefense.[date]=@DefenseDate


 --View my profile that contains all my information.
 GO
CREATE proc viewMyProfile
@studentId int
AS
DECLARE @tmp INT
select @tmp = GucianStudent.id from GucianStudent WHERE GucianStudent.id=@studentId
if @studentId=@tmp
BEGIN
select * from GucianStudent WHERE GucianStudent.id=@studentId
END

ELSE
BEGIN
SELECT * FROM NonGucianStudent WHERE NonGucianStudent.id=@studentId
END


--Edit my profile (change any of my personal information).
GO
CREATE PROC editMyProfile
@studentID int,
@firstName VARCHAR(10),
@lastname VARCHAR(10),
@password VARCHAR(10),
@email VARCHAR(10),
@address VARCHAR(10),
@type VARCHAR(10)
AS
If exists (
    select *
    from GucianStudent 
    where id=@studentID
)
BEGIN
UPDATE GucianStudent 
set firstName=@firstName,lastName=@lastname, address=@address,type=@type
WHERE id=@studentID
END
IF exists(select * from PostGradUser WHERE PostGradUser.id= @studentID)
BEGIN
UPDATE PostGradUser
SET PostGradUser.email=@email , postGradUser.PASSWORD=@password
END

If exists (
    select *
    from NonGucianStudent 
    where id=@studentID
)
BEGIN
UPDATE NonGucianStudent
set firstName=@firstName,lastName=@lastname, address=@address,type=@type
WHERE id=@studentID
END
IF exists(select * from PostGradUser WHERE PostGradUser.id= @studentID)
BEGIN
UPDATE PostGradUser
SET PostGradUser.email=@email , postGradUser.PASSWORD=@password
END


--As a Gucian graduate, add my undergarduate ID
go
 CREATE proc addUndergradID 
 @studentID int,
 @undergradID varchar(10)
 AS
 UPDATE GucianStudent
 set GucianStudent.undergradID= @undergradID
 WHERE GucianStudent.id= @studentID


 --As a nonGucian student, view my courses’ grades
GO
 CREATE PROC ViewCoursesGrades
 @studentID int
 as
 SELECT NonGucianStudentTakeCourse.grade from NonGucianStudentTakeCourse WHERE NonGucianStudentTakeCourse.sid=@studentID





--View all my payments and installments 


go 
create proc ViewCoursePaymentsInstall
@studentID int
AS
SELECT * from NonGucianStudentPayForCourse LEFT outer join Payment on NonGucianStudentPayForCourse.paymentNo=Payment.id 
LEFT outer join Installment on Payment.id=Installment.paymentID WHERE NonGucianStudentPayForCourse.sid=@studentID

go
 CREATE PROC ViewThesisPaymentsInstall
 @studentID int
 AS
 if exists(select GUCianStudentRegisterThesis.sid from GUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=GUCianStudentRegisterThesis.serial_no where GUCianStudentRegisterThesis.sid=@studentID)
 begin 
 select * from GUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=GUCianStudentRegisterThesis.serial_no LEFT OUTER JOIN 
 Payment ON Payment.id=Thesis.payment_id LEFT OUTER JOIN Installment ON Installment.paymentID=Payment.no_installments
 where GUCianStudentRegisterThesis.sid=@studentID
 end
 ELSE
 BEGIN
 select * from nonGUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=nonGUCianStudentRegisterThesis.serial_no LEFT OUTER JOIN 
 Payment ON Payment.id=Thesis.payment_id LEFT OUTER JOIN Installment ON Installment.paymentID=Payment.no_installments
 where nonGUCianStudentRegisterThesis.sid=@studentID
 END


GO
create PROC ViewUpcomingInstallments
@studentID int
as
if exists(select GUCianStudentRegisterThesis.sid from GUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=GUCianStudentRegisterThesis.serial_no where GUCianStudentRegisterThesis.sid=@studentID)
BEGIN
 select * from GUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=GUCianStudentRegisterThesis.serial_no LEFT OUTER JOIN 
 Payment ON Payment.id=Thesis.payment_id LEFT OUTER JOIN Installment ON Installment.paymentID=Payment.no_installments
 where GUCianStudentRegisterThesis.sid=@studentID and  Installment.date > CURRENT_TIMESTAMP and Installment.done = '0'
END
ELSE
BEGIN
 select Payment.* , Installment.* from nonGUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=nonGUCianStudentRegisterThesis.serial_no LEFT OUTER JOIN 
 Payment ON Payment.id=Thesis.payment_id LEFT OUTER JOIN Installment ON Installment.paymentID=Payment.no_installments
 where nonGUCianStudentRegisterThesis.sid=@studentID and  Installment.date > CURRENT_TIMESTAMP and Installment.done = '0'
 UNION
 SELECT Payment.* , Installment.* from NonGucianStudentPayForCourse LEFT outer join 
 Payment ON payment.id=NonGucianStudentPayForCourse.paymentNo LEFT outer join  
 Installment ON Installment.paymentID=Payment.no_installments where NonGucianStudentPayForCourse.sid=@studentID and  Installment.date > CURRENT_TIMESTAMP and Installment.done = '0'
end


GO
create PROC ViewMissedInstallments
@studentID int
as
if exists(select GUCianStudentRegisterThesis.sid from GUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=GUCianStudentRegisterThesis.serial_no where GUCianStudentRegisterThesis.sid=@studentID)
BEGIN
 select * from GUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=GUCianStudentRegisterThesis.serial_no LEFT OUTER JOIN 
 Payment ON Payment.id=Thesis.payment_id LEFT OUTER JOIN Installment ON Installment.paymentID=Payment.no_installments
 where GUCianStudentRegisterThesis.sid=@studentID and  Installment.date < CURRENT_TIMESTAMP and Installment.done = '0'
END
ELSE
BEGIN
 select Payment.* , Installment.* from nonGUCianStudentRegisterThesis left outer join Thesis on Thesis.serialNumber=nonGUCianStudentRegisterThesis.serial_no LEFT OUTER JOIN 
 Payment ON Payment.id=Thesis.payment_id LEFT OUTER JOIN Installment ON Installment.paymentID=Payment.no_installments
 where nonGUCianStudentRegisterThesis.sid=@studentID and  Installment.date < CURRENT_TIMESTAMP and Installment.done = '0'
  UNION
 SELECT Payment.* , Installment.* from NonGucianStudentPayForCourse LEFT outer join 
 Payment ON payment.id=NonGucianStudentPayForCourse.paymentNo LEFT outer join  
 Installment ON Installment.paymentID=Payment.no_installments
  where NonGucianStudentPayForCourse.sid=@studentID and  Installment.date < CURRENT_TIMESTAMP and Installment.done = '0'
end



 --Add and fill my progress report(s).
 GO
CREATE PROC AddProgressReport
 @thesisSerialNo int, @progressReportDate date
 as 
DECLARE @tmp INT
DECLARE @tmp2 INT
if exists(select Thesis.serialNumber from GUCianStudentRegisterThesis INNER join Thesis on GUCianStudentRegisterThesis.serial_no=Thesis.serialNumber)
BEGIN
select @tmp=GUCianStudentRegisterThesis.sid FROM GUCianStudentRegisterThesis WHERE GUCianStudentRegisterThesis.serial_no=@thesisSerialNo
SELECT @tmp2=GUCianStudentRegisterThesis.supid FROM GUCianStudentRegisterThesis WHERE GUCianStudentRegisterThesis.serial_no=@thesisSerialNo
INSERT into GucianProgressReport VALUES(@tmp ,@progressReportDate ,null,null,@thesisSerialNo,@tmp2)
END
if exists(select Thesis.serialNumber from nonGUCianStudentRegisterThesis INNER join Thesis on nonGUCianStudentRegisterThesis.serial_no=Thesis.serialNumber)
BEGIN
select @tmp=nonGUCianStudentRegisterThesis.sid FROM nonGUCianStudentRegisterThesis WHERE nonGUCianStudentRegisterThesis.serial_no=@thesisSerialNo
SELECT @tmp2=nonGUCianStudentRegisterThesis.supid FROM nonGUCianStudentRegisterThesis WHERE nonGUCianStudentRegisterThesis.serial_no=@thesisSerialNo
INSERT into nonGucianProgressReport VALUES(@tmp ,@progressReportDate ,null,null,@thesisSerialNo,@tmp2)
END



GO
CREATE PROC FillProgressReport 
@thesisSerialNo int, 
@progressReportNo int, 
@state int, 
@description varchar(200)
AS
IF exists(select * from GUCianProgressReport where GUCianProgressReport.thesisSerialNumber=@thesisSerialNo and GUCianProgressReport.NO=@progressReportNo )
update GUCianProgressReport
set GUCianProgressReport.state=@state WHERE GUCianProgressReport.thesisSerialNumber=@thesisSerialNo and GUCianProgressReport.NO=@progressReportNo
ELSE
BEGIN
update nonGUCianProgressReport
set nonGUCianProgressReport.state=@state WHERE nonGUCianProgressReport.thesisSerialNumber=@thesisSerialNo and nonGUCianProgressReport.NO=@progressReportNo
END



--View my progress report(s) evaluations.
GO
CREATE PROC ViewEvalProgressReport
@thesisSerialNo int, @progressReportNo int

AS
if exists(select Thesis.serialNumber from GUCianStudentRegisterThesis INNER join Thesis on GUCianStudentRegisterThesis.serial_no=Thesis.serialNumber)
BEGIN
SELECT * from GucianProgressReport where GucianProgressReport.no=@progressReportNo
END
else
BEGIN
SELECT * from nonGucianProgressReport where nonGucianProgressReport.no=@progressReportNo
END


-- Add publication.
 GO
CREATE proc addPublication
@title varchar(50), @pubDate datetime, 
@host varchar(50), @place varchar(50), @accepted bit
as
INSERT into Publication (title,date,place,accepted,host) VALUES(@title,@pubDate,@place, @accepted,@host)


--Link publication to my thesis.
GO 
create PROC linkPubThesis
 @PubID int, @thesisSerialNo int
  AS
  INSERT into ThesisHasPublication(serial_no,pubid) VALUES(@PubID,@thesisSerialNo)


