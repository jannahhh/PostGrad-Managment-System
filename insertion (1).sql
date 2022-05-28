-- Payments with installments.
INSERT INTO Payment VALUES('60000','2','10');
INSERT INTO Payment  VALUES('90000','1','10');
INSERT INTO Payment  VALUES('70000','3','20');
INSERT INTO Payment  VALUES('9000','4','20');
INSERT INTO Payment  VALUES('6000','5','20');

INSERT INTO Installment VALUES('01/01/2011' ,1,20000,1);
INSERT INTO Installment VALUES('01/02/2017' ,2,20000,0);
INSERT INTO Installment VALUES('01/01/2020' ,3,30000,0);
INSERT INTO Installment VALUES('01/01/2030' ,5,30000,0);

--thesis with diffrent types 
INSERT INTO Thesis VALUES ('appiled arts','Master','Building Conservation',01/05/2012,01/06/2014,03/01/2012,100,1,0);
INSERT INTO Thesis VALUES ('appiled arts','phd','CAD','03/01/2010','03/01/2012','04/01/2012','90','2','0');
INSERT INTO Thesis VALUES ( 'appiled arts','Master','Building Process and Industry','05/01/2012','05/01/2015','06/01/2015','80','3','0');
INSERT INTO Thesis VALUES ( 'pharmacy','Master',' Pharmaceutical Cell Biology','05/01/2013','05/01/2017','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'pharmacy','Master','Morphogenesis Definition','05/01/2014','05/01/2017','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'pharmacy','Master','Cancer Drug Studies','05/01/2014','05/01/2018','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'engineering','Master','MANET','05/01/2014','05/01/2018','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'engineering','Master','IOT','05/01/2014','05/01/2018','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'engineering','Master','Data Warehousing','05/01/2015','05/01/2024','04/01/2014','80','3','3');
INSERT INTO Thesis VALUES ( 'Economics','phd','Electricity markets','05/01/2012','05/01/2014','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'Economics','phd','owned enterprises','05/01/2013','05/01/2015','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'Economics','phd','Simulating the price of anarchy in auctions','05/01/2014','05/01/2016','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'Bussiness','Master','Environmental Politics in Postwar Japan','05/01/2020','05/01/2022','04/01/2014','80','3','0');
INSERT INTO Thesis VALUES ( 'Bussiness','Master','Study about Sustainable Digitalization','05/01/2020','05/01/2023','04/01/2014','80','3','1');
INSERT INTO Thesis  VALUES ( 'Bussiness','Master','The Legal Policy for Travel Dealings','05/01/2018','05/01/2024','04/01/2014','80','3','2');
INSERT INTO Thesis  VALUES ( 'Bussiness','Master','The Legal Policy for Travel Dealings',05/01/2018,05/01/2024,04/01/2014,80,3,2);
INSERT INTO Thesis  VALUES ( 'Bussiness','phd','The Legal Policy for Travel Dealings',05/01/2018,05/01/2024,04/01/2014,80,5 ,2);
   
   

   
--13 users of different types 

INSERT INTO PostGradUser(email,PASSWORD) VALUES('jannah1@gmail.com','jannah1');
INSERT INTO Examiner (id,name,fieldOfWork,isNational) VALUES(1,'jannah1','engneering','1')

INSERT INTO PostGradUser VALUES('jannah2@gmail.com','jannah2');
INSERT INTO Examiner (id,name,fieldOfWork,isNational) VALUES(2,'jannah2','doctor','0')

INSERT INTO PostGradUser VALUES('jannah3@gmail.com','jannah3');
INSERT INTO Examiner (id,name,fieldOfWork,isNational) VALUES(3,'jannah3','business','1')

INSERT INTO PostGradUser VALUES('alaa1@gmail.com','alaa1');
INSERT INTO supervisor (id,firstName,faculty) 
VALUES(4,'alaa1','met');
INSERT INTO PostGradUser VALUES('alaa2@gmail.com','alaa2');
INSERT INTO supervisor (id,firstName,faculty) 
VALUES(5,'alaa2','iet');

INSERT INTO PostGradUser VALUES('dija1@gmail.com','dija1');
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
 VALUES(6,'dija1' ,'ahmed','masters','pharmacy ','el maadi',2.0);

INSERT INTO PostGradUser VALUES('dija2@gmail.com','dija2');
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
 VALUES(7,'dija2' ,'gabr','master','appiled','el maadi',1.5);

INSERT INTO PostGradUser VALUES('dija3@gmail.com','dija3');
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
 VALUES(8,'dija3' ,'gabr','master','business','el maadi',1.0);

INSERT INTO PostGradUser VALUES('dija4@gmail.com','amrsalem17');
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
 VALUES(9,'dija4' ,'gabr','phd','engineering','el maadi',4.0);

INSERT INTO PostGradUser VALUES('amr1@gmail.com','amrsalem7');
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)

 VALUES(10,'amr1' ,'salem','phd','engineering','el maadi',0.7);

INSERT INTO PostGradUser VALUES('amr2@gmail.com','amrsalem7');
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
 VALUES(11,'amr1' ,'salem','masters','engineering','el maadi',1.5);

INSERT INTO PostGradUser VALUES('amr3@gmail.com','amrsalem8');
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
 VALUES(12,'amr3' ,'salem','masters','economics','el maadi',4.0);

INSERT INTO PostGradUser VALUES('amr4@gmail.com','amrsalem6');
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
 VALUES(13,'amr4' ,'salem','phd','applied','el maadi',3.7);

INSERT INTO PostGradUser VALUES('amr5@gmail.com','amrsalem9');
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES(14,'amr5' ,'salem','phd','applied ','el maadi',2.0);

--Courses attended by non Gucians.
set identity_insert course on 
INSERT INTO course(id,fees,creditHours,code) VALUES(1,1000,6,401); 
INSERT INTO course (id,fees,creditHours,code)VALUES(2,4000,6,402); 
INSERT INTO course (id,fees,creditHours,code)VALUES(3,6000,6,403); 
set identity_insert course on 
INSERT INTO NonGucianStudentTakeCourse VALUES(10, 80,1);
INSERT INTO NonGucianStudentTakeCourse VALUES(11, 80,2);
INSERT INTO NonGucianStudentTakeCourse VALUES(12, 80,3);



-- Progress reports filled and evaluated.
INSERT INTO GucianProgressReport(sid,date,eval,state,thesisSerialNumber,supid) VALUES(6,01/01/2015, 60,7,9,4);
INSERT INTO GucianProgressReport (sid,date,eval,state,thesisSerialNumber,supid)VALUES(7,01/02/2016, 70,8,10,4);
INSERT INTO GucianProgressReport (sid,date,eval,state,thesisSerialNumber,supid)VALUES(8,01/03/2017, 80,9,11,5) ;
INSERT INTO GucianProgressReport (sid,date,eval,state,thesisSerialNumber,supid)VALUES(9,01/03/2017, 80,10,12,5) ;

INSERT INTO NonGucianProgressReport (sid,date,eval,state,thesisSerialNumber,supid)VALUES(13, 01/04/2018, 90,12,13,4);
INSERT INTO NonGucianProgressReport(sid,date,eval,state,thesisSerialNumber,supid) VALUES(11, 01/04/2018, 60,7,14,5);
INSERT INTO NonGucianProgressReport (sid,date,eval,state,thesisSerialNumber,supid)VALUES(12, 01/04/2019, 90,7,15,4);

--Defenses and the examiners attending them
INSERT INTO Defense(serialNumber,date,location,grade) values (8,01/01/2010, 'GUC',90);
INSERT INTO Defense values (13,01/02/2012, 'GUC',90);
INSERT INTO Defense(serialNumber,date,location,grade) values (1,01/01/2010, 'GUC',90);
INSERT INTO Defense values (2,01/02/2012, 'GUC',90);

INSERT INTO ExaminerEvaluateDefense VALUES (01/01/2010,8,1,null); 
INSERT INTO ExaminerEvaluateDefense VALUES (01/02/2012,13 ,2,null);
INSERT INTO ExaminerEvaluateDefense VALUES (01/01/2010,1,1,null); 
INSERT INTO ExaminerEvaluateDefense VALUES (01/02/2012,2,2,null);

INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) VALUES (6,4,15);
INSERT INTO Publication ( title, date, place, accepted, host) VALUES ('YYY',01/02/2012,'PP',1,'AMR')
INSERT INTO ThesisHasPublication (serial_no,pubid) VALUES (12,1) 


INSERT into  NonGUCianStudentRegisterThesis VALUES(10,4,4)
INSERT into GUCianStudentRegisterThesis VALUES(6,4,4)
INSERT into GUCianStudentRegisterThesis VALUES (6,4,5)

INSERT into GUCianStudentRegisterThesis VALUES (7,4,17)
select * from thesis
insert into NonGucianStudentPayForCourse Values (12,2,3)


INSERT into GUCianStudentRegisterThesis VALUES (7,4,12)

INSERT INTO ExaminerEvaluateDefense VALUES (01/01/2010,1,1,null); 
INSERT INTO ExaminerEvaluateDefense VALUES (01/02/2012,2,2,null);

insert into GUCianStudentRegisterThesis VALUES (8,4,8)

select * from Thesis
select * from Defense
select * from GUCianStudentRegisterThesis
select * from supervisor
select * from ExaminerEvaluateDefense
