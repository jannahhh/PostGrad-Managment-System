create DATABASE PostGradsubmission;

CREATE TABLE PostGradUser
(
id int PRIMARY KEY IDENTITY,
email VARCHAR(50),
password VARCHAR(50)
) ;

create table admin(
id int PRIMARY KEY ,
FOREIGN KEY(id) REFERENCES PostGradUser 
);


CREATE TABLE GucianStudent
(
id int PRIMARY KEY ,
firstName VARCHAR(50),
lastName VARCHAR(50),
type VARCHAR(50),
faculty VARCHAR(50),
address VARCHAR(100),
gpa decimal(10,2),
undergradID int,
FOREIGN KEY(id) REFERENCES PostGradUser ,
) ;

CREATE TABLE GUCStudentPhoneNumber
(
id int ,
phone int,
PRIMARY KEY ( id , phone),
FOREIGN KEY(id) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
) ;

CREATE TABLE NonGucianStudent
(
id int PRIMARY KEY ,
firstName VARCHAR(50),
lastName VARCHAR(50),
type VARCHAR(50),
faculty VARCHAR(50),
address VARCHAR(50),
gpa decimal(10,2),
FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE,
) ;

CREATE TABLE NonGUCStudentPhoneNumber
(
id int ,
phone int,
PRIMARY KEY ( id , phone),
FOREIGN KEY(id) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
) ;

CREATE TABLE course
(
id int PRIMARY KEY identity,
fees int  ,
creditHours int,  
code int,
);


CREATE TABLE supervisor 
(
id int PRIMARY KEY ,
firstName VARCHAR(50),
faculty VARCHAR(50),
FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE,
) ;



CREATE TABLE Publication 
(
id int PRIMARY KEY identity, -- identity 
title VARCHAR(50),
date datetime NOT NULL,
place VARCHAR(50),
accepted BIT, 
host VARCHAR(50),
) ;



CREATE TABLE Payment
(
id int IDENTITY PRIMARY KEY,
amount int ,
no_installments int ,
fundPercentage int ,
) ;

CREATE TABLE Thesis 
(
serialNumber int PRIMARY KEY IDENTITY ,
field VARCHAR(50),
type VARCHAR(50),
title VARCHAR(50),
startDate datetime NOT NULL,
endDate datetime NOT NULL,
defenseDate datetime NOT NULL,
years AS (YEAR(endDate)-YEAR(startDate)),
grade DECIMAL(10,2),
payment_id int,
noExtension int , 
FOREIGN KEY(payment_id) REFERENCES Payment ON DELETE CASCADE ON UPDATE CASCADE,
);


CREATE TABLE Examiner(
id int PRIMARY KEY ,
name VARCHAR(50),
fieldOfWork VARCHAR(50),
isNational BIT,
FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE,
) ;

CREATE TABLE Defense
(
serialNumber int ,
date datetime NOT NULL,
location VARCHAR(50),
grade DECIMAL(10,2),
PRIMARY KEY (serialNumber,date),
FOREIGN KEY(serialNumber) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE,
) ;

CREATE TABLE GucianProgressReport
(
sid int,
no int IDENTITY , 
date datetime NOT NULL,
eval int,
state int,
thesisSerialNumber int ,
supid int,
PRIMARY KEY (sid,no),
FOREIGN KEY(sid) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(thesisSerialNumber) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(supid) REFERENCES Supervisor ON DELETE NO ACTION ON UPDATE NO ACTION,
) ;

CREATE TABLE NonGucianProgressReport
(
sid int,
no int IDENTITY , 
date datetime NOT NULL,
eval int,
state int,
thesisSerialNumber int ,
supid int,
PRIMARY KEY (sid,no),
FOREIGN KEY(sid) REFERENCES nonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(thesisSerialNumber) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(supid) REFERENCES Supervisor ON DELETE NO ACTION ON UPDATE NO ACTION,
) ;

CREATE TABLE Installment
(
date datetime NOT NULL,
paymentID int ,
amount int , 
done BIT,
PRIMARY KEY(date, paymentID),
FOREIGN KEY(paymentID) REFERENCES Payment ON DELETE CASCADE ON UPDATE CASCADE,
) ;


CREATE TABLE NonGucianStudentPayForCourse
(
sid int ,
paymentNo int, 
cid int, 
PRIMARY KEY(sid,paymentNo,cid),
FOREIGN KEY(sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(paymentNo) REFERENCES Payment ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
)

CREATE TABLE NonGucianStudentTakeCourse
(
sid int ,
grade decimal (10,2), 
cid int, 
PRIMARY KEY(sid,cid),
FOREIGN KEY(sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
);


CREATE TABLE GUCianStudentRegisterThesis
(
sid int ,
supid int, 
serial_no int, 
PRIMARY KEY(sid,supid,serial_no),
FOREIGN KEY(sid) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(supid) REFERENCES supervisor ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(serial_no) REFERENCES Thesis ON DELETE NO ACTION ON UPDATE NO ACTION,
);

CREATE TABLE NonGUCianStudentRegisterThesis
(
sid int ,
supid int, 
serial_no int, 
PRIMARY KEY(sid,supid,serial_no),
FOREIGN KEY(sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(supid) REFERENCES supervisor ON DELETE NO ACTION ON UPDATE NO ACTION,
FOREIGN KEY(serial_no) REFERENCES Thesis ON DELETE NO ACTION ON UPDATE NO ACTION,
);

CREATE TABLE ExaminerEvaluateDefense
(
date datetime NOT NULL,
serialNo int, 
examinerID int, 
comment VARCHAR(50),
PRIMARY KEY(date,serialNo,examinerID),
FOREIGN KEY(serialNo,date) REFERENCES Defense ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(examinerID) REFERENCES Examiner ON DELETE NO ACTION ON UPDATE NO ACTION,
);

CREATE TABLE ThesisHasPublication
(
serial_no int , 
pubid int , 
PRIMARY KEY(serial_no , pubid),
FOREIGN KEY(pubid) REFERENCES publication ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(serial_no) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE,
);


