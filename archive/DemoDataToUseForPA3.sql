-- DROP CURRENT TABLE:
drop table meetings ;
drop table enrollment;
drop table sections;
drop table classes;

--CREATE TABLE:
CREATE TABLE classes(
  class_id      SERIAL PRIMARY KEY,
  course_name   TEXT REFERENCES courses(course_name),
  title         TEXT NOT NULL CHECK (title <> ''),
  quarter       TEXT NOT NULL CHECK (quarter <> ''),
  year          INTEGER NOT NULL CHECK (year >= 1960),
  scheduled_fac TEXT references faculty(fac_name)
);

CREATE TABLE sections(
  id          SERIAL PRIMARY KEY,
  sec_id      TEXT NOT NULL,
  enr_limit   INTEGER NOT NULL CHECK(enr_limit>0),
  class_id    INTEGER REFERENCES classes(class_id),
  taught_by   TEXT REFERENCES faculty(fac_name)
);

CREATE TABLE meetings(
  id          SERIAL PRIMARY KEY,
  type        TEXT NOT NULL,
  weekly      BOOLEAN NOT NULL,
  mandatory   BOOLEAN NOT NULL,
  room        TEXT NOT NULL,
  day_time    TEXT NOT NULL,
  sec_id      INTEGER REFERENCES sections(id)
);

CREATE TABLE enrollment(
  s_id        INTEGER REFERENCES students(id),
  class_id    INTEGER REFERENCES classes(class_id),
  sec         INTEGER REFERENCES sections(id),
  quarter     TEXT NOT NULL CHECK (quarter <> ''),
  year        INTEGER NOT NULL,
  units       INTEGER NOT NULL,
  grade_opt   TEXT,
  grade       TEXT
);


--INSERTION:
--CLASSES AND SECTIONS
Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','FA',2014); --class1
Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','SP',2015); --class2
Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','FA',2015); --class3
Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','FA',2016); --class4
Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','WI',2016); --class5
Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','WI',2017); --class6
Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','SP',2017); --class7 CURRENT QUARTER
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,1,'Justin Bieber'); --sec1
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,2,'Kelly Clarkson'); --sec2
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,3,'Selena Gomez'); --sec3
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,4,'Selena Gomez'); --sec4
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,5,'Selena Gomez'); --sec5
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,6,'Selena Gomez'); --sec6

--CURRENT OFFERED: section 10 --> section_id = 7
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(10,5,7,'Adele'); --sec7 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A10','T Th 0500',7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','D10','W 0700',7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Lab','true','false','L10', 'T Th 0300', 7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S10', 'Feb15 M 1100', 7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S10', 'March14 M 1100', 7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A10', 'March15 Tu 0800', 7);

Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','SP',2018); --NEXT OFFERED ,class8

---------------------------------------------------------------
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','WI',2015); --class9
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','WI',2016); --class10
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','SP',2017); --class11 CURRENT QUARTER
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,9,'Taylor Swift'); --sec8
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,10,'Taylor Swift'); --sec9

--CURRENT OFFERED : section 6 --> section_id = 10
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(6,3,11,'Taylor Swift'); --sec10 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A6','T Th 0200',10);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','R6','F 0600',10);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S6', 'March15 T 0100', 10);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A6', 'March17 Th 0800', 10);

Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','FA',2017); --NEXT OFFERED, class12

---------------------------------------------------------------

Insert into classes(course_name,title,quarter,year) values('CSE250A','Probability Reasoning','FA',2014); --class13
Insert into classes(course_name,title,quarter,year) values('CSE250A','Probability Reasoning','FA',2015); --class14
Insert into classes(course_name,title,quarter,year) values('CSE250A','Probability Reasoning','WI',2015); --class15
Insert into classes(course_name,title,quarter,year) values('CSE250A','Probability Reasoning','FA',2016); --class16
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,13,'Bjork'); --sec11
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,14,'Bjork'); --sec12
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,15,'Bjork'); --sec13
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,16,'Bjork'); --sec14
Insert into classes(course_name,title,quarter,year) values('CSE250A','Probability Reasoning','SP',2018); --NEXT OFFERED, class17

Insert into classes(course_name,title,quarter,year) values('CSE250B','Machine Learning','WI',2015); --class18
Insert into classes(course_name,title,quarter,year) values('CSE250B','Machine Learning','WI',2016); --class19
Insert into classes(course_name,title,quarter,year) values('CSE250B','Machine Learning','FA',2015); --class20
Insert into sections(sec_id,enr_limit,class_id) values(11,90,18); --sec15
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,19,'Justin Bieber'); --sec16
Insert into sections(sec_id,enr_limit,class_id) values(11,90,20); --sec17
Insert into classes(course_name,title,quarter,year) values('CSE250B','Machine Learning','FA',2018); --NEXT OFFERED, class21

---------------------------------------------------------------
Insert into classes(course_name,title,quarter,year) values('CSE255','Data Mining And Predictive Analytics','FA',2015); --class22
Insert into classes(course_name,title,quarter,year) values('CSE255','Data Mining And Predictive Analytics','WI',2016); --class23
Insert into classes(course_name,title,quarter,year) values('CSE255','Data Mining And Predictive Analytics','SP',2017); --CURRENT QUARTER class24
Insert into sections(sec_id,enr_limit,class_id) values(11,90,22); --sec18
Insert into sections(sec_id,enr_limit,class_id) values(11,90,23); --sec19

--CURRENT OFFER: section 3 --> section_id =  20
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(3,5,24,'Flo Rida'); --sec20 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A3','M W F 1200',20);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A3', 'March16 W 0800', 20);

Insert into classes(course_name,title,quarter,year) values('CSE255','Data Mining And Predictive Analytics','WI',2018); --NEXT OFFERED class25


---------------------------------------------------------------
Insert into classes(course_name,title,quarter,year) values('CSE232A','Databases','FA',2015); --class26
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,26,'Kelly Clarkson'); --sec21
Insert into classes(course_name,title,quarter,year) values('CSE232A','Databases','SP',2018); --NEXT OFFERED class27

---------------------------------------------------------------
Insert into classes(course_name,title,quarter,year) values('CSE221','Operating Systems','SP',2015); --class28
Insert into classes(course_name,title,quarter,year) values('CSE221','Operating Systems','WI',2016); --class29
Insert into classes(course_name,title,quarter,year) values('CSE221','Operating Systems','SP',2017); --CURRENT QUARTER class30
Insert into sections(sec_id,enr_limit,class_id) values(11,90,28); --sec22
Insert into sections(sec_id,enr_limit,class_id) values(11,90,29); --sec23

--CURRENTLY OFFERED: 
--section 2 --> section_id = 24
Insert into sections(sec_id,enr_limit,class_id) values(2,5,30); -- CURRENT SEC sec24
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A2','M W F 1000',24);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Discussion','true','false','R2', 'T Th 1100', 24);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S2', 'March07 M 0800', 24);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A2', 'March14 M 0800', 24);
--section 9 --> section_id = 25
Insert into sections(sec_id,enr_limit,class_id) values(9,2,30); -- CURRENT SEC sec25
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A9','T Th 0500',25);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','R9','M F 0900',25);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S9', 'March09 W 0900', 25);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A9', 'March16 W 0800', 25);
--section 5 --> section_id = 26
Insert into sections(sec_id,enr_limit,class_id) values(5,3,30); -- CURRENT SEC sec26
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A5','M W F 1200',26);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Discussion','true','false','R5', 'T Th 1200', 26);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S5', 'March08 T 0800', 26);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A5', 'March15 T 0800', 26);

Insert into classes(course_name,title,quarter,year) values('CSE221','Operating Systems','FA',2017); --NEXT OFFERED class31

---------------------------------------------------------------

Insert into classes(course_name,title,quarter,year) values('MAE107','Computational Methods','SP',2015); --class32
Insert into classes(course_name,title,quarter,year) values('MAE107','Computational Methods','SP',2016); --class33
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,32,'Bjork'); --sec27
Insert into sections(sec_id,enr_limit,class_id) values(11,90,33); --sec28
Insert into classes(course_name,title,quarter,year) values('MAE107','Computational Methods','SP',2018); --NEXT OFFERED class34

---------------------------------------------------------------

Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','FA',2014); --class35
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','WI',2015); --class36
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','WI',2016); --class37
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','WI',2017); --class38
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','SP',2017); --CURRENT QUARTER class39
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,35,'Selena Gomez');  --sec29
Insert into sections(sec_id,enr_limit,class_id) values(11,90,36); --sec30
Insert into sections(sec_id,enr_limit,class_id) values(11,90,37); --sec31
Insert into sections(sec_id,enr_limit,class_id) values(11,90,38); --sec32


--CURRENTLY OFFERED:
-- section 1 --> section_id = 33
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(1,2,39,'Adele'); --sec33 CURRRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1000',33);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Discussion','true','false','R1', 'T Th 1000', 33);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Lab','true','false','L1', 'F 0600', 33);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A1', 'March14 M 0800', 33);

-- section 8 --> section_id =  34
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(8,1,39,'Selena Gomez'); --sec34 CURRRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A8','T Th 0300',34);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','R8','M 0300',34);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Lab','true','false','L8', 'F 0500', 34);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A8', 'March15 T 0800', 34);

Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','FA',2018); --NEXT OFFERED class40

---------------------------------------------------------------

Insert into classes(course_name,title,quarter,year) values('PHIL10','Intro to Logic','FA',2015); --class41
Insert into classes(course_name,title,quarter,year) values('PHIL10','Intro to Logic','FA',2016); --class42
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,41,'Bjork'); --sec35
Insert into sections(sec_id,enr_limit,class_id) values(11,90,42); --sec36
Insert into classes(course_name,title,quarter,year) values('PHIL10','Intro to Logic','WI',2018); --NEXT OFFERED class43

---------------------------------------------------------------

Insert into classes(course_name,title,quarter,year) values('PHIL12','Scientific Reasoning','WI',2016); --class44
Insert into classes(course_name,title,quarter,year) values('PHIL12','Scientific Reasoning','SP',2017); --class45 CURRENT QUARTER
Insert into sections(sec_id,enr_limit,class_id) values(11,90,44); --sec37
--Currently Offered: section 4 --> section_id = 38
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(4,2,45,'Adam Levine'); --sec38 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A4','M W F 1200',38);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Discussion','true','false','R4', 'W F 100', 38);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S4', 'March07 M 0900', 38);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A4', 'March14 M 0800', 38);

Insert into classes(course_name,title,quarter,year) values('PHIL12','Scientific Reasoning','SP',2018); --NEXT OFFERED class46

---------------------------------------------------------------

Insert into classes(course_name,title,quarter,year) values('PHIL165','Freedom, Equality, and The Law','SP',2015); --class47
Insert into classes(course_name,title,quarter,year) values('PHIL165','Freedom, Equality, and The Law','FA',2015); --class48
Insert into classes(course_name,title,quarter,year) values('PHIL165','Freedom, Equality, and The Law','WI',2016); --class49
Insert into classes(course_name,title,quarter,year) values('PHIL165','Freedom, Equality, and The Law','SP',2016); --class50
Insert into classes(course_name,title,quarter,year) values('PHIL165','Freedom, Equality, and The Law','FA',2016); --class51
Insert into classes(course_name,title,quarter,year) values('PHIL165','Freedom, Equality, and The Law','SP',2017); --class52 CURRENT QUARTER
Insert into sections(sec_id,enr_limit,class_id) values(11,90,47); --sec39
Insert into sections(sec_id,enr_limit,class_id) values(11,90,48); --sec40
Insert into sections(sec_id,enr_limit,class_id) values(11,90,49); --sec41
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,50,'Flo Rida'); --sec42
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,51,'Adam Levine'); --sec43

--Currently Offered: section 7 --> section_id = 44
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(7,3,52,'Adam Levine'); --sec44 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A7','T Th 0300',44);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','R7','Th 0100',44);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S7', 'Jan29 F 0800', 44);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S7', 'March17 Th 0500', 44);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A7', 'March18 F 0800', 44);

Insert into classes(course_name,title,quarter,year) values('PHIL165','Freedom, Equality, and The Law','SP',2018); --NEXT OFFERED class53
---------------------------------------------------------------

--ENROLLMENT
--CSE8A---
--Benjamin
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(1,1,'FA',2014,4,'Letter','A-');
--Daniel
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(3,1,'FA',2014,4,'Letter','B+');
--Kristen
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(2,2,'SP',2015,4,'Letter','C-');
--Claire
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(4,3,'FA',2015,4,'Letter','A-');
--Julie
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(5,3,'FA',2015,4,'Letter','B');
--CSE105
--Benjamin
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(1,9,'WI',2015,4,'Letter','A-');
--Julie
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(5,9,'WI',2015,4,'Letter','B+');
--Claire
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(4,9,'WI',2015,4,'Letter','C');
--CSE250A
--Dave
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(16,13,'WI',2015,4,'Letter','C');
--Tim
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(22,14,'WI',2015,4,'Letter','B+');
--Andrew
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(18,14,'WI',2015,4,'Letter','D');
--Nathan
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(19,14,'WI',2015,4,'Letter','F');
--CSE250B
--Nelson
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(17,18,'WI',2015,4,'Letter','A');
--Nathan
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(19,18,'WI',2015,4,'Letter','A');
--CSE255
--John	CSE255	fa2015	Letter Grade	4	B-
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(20,22,'FA',2015,4,'Letter','B-');
--Andrew	CSE255	fa2015	Letter Grade	4	B
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(18,22,'FA',2015,4,'Letter','B');
--Anwell	CSE255	fa2015	Letter Grade	4	F
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(21,22,'FA',2015,4,'Letter','F');
--CSE232A
--Nelson	CSE232A	fa2015	Letter Grade	4	A-
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(17,26,'FA',2015,4,'Letter','A-');
--CSE221
--Tim	CSE221	sp2015	Letter Grade	4	A
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(22,28,'SP',2015,4,'Letter','A');
--John	CSE221	sp2015	Letter Grade	4	A
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(20,28,'SP',2015,4,'Letter','A');
--MAE107
--Logan	MAE107	sp2015	Letter Grade	4	B+
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(10,32,'SP',2015,4,'Letter','B+');
--MAE108
--Joseph	MAE108	fa2014	Letter Grade	2	B-
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(8,35,'FA',2014,4,'Letter','B-');
--Michael	MAE108	fa2014	Letter Grade	2	A-
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(7,35,'FA',2014,4,'Letter','A-');
--Kevin	MAE108	wi2015	Letter Grade	2	B
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(6,36,'WI',2015,4,'Letter','B');
--Logan	MAE108	wi2015	Letter Grade	2	B+
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(10,36,'WI',2015,4,'Letter','B+');
--PHIL10
--Vikram	PHIL10	fa2015	Letter Grade	4	A
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(11,41,'FA',2015,4,'Letter','A');
--Rachel	PHIL10	fa2015	Letter Grade	4	A
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(12,41,'FA',2015,4,'Letter','A');
--Zack	PHIL10	fa2015	Letter Grade	4	C-
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(13,41,'FA',2015,4,'Letter','C-');
--Justin	PHIL10	fa2015	Letter Grade	4	C+
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(14,41,'FA',2015,4,'Letter','C+');
--PHIL165
--Rahul	PHIL165	sp2015	Letter Grade	2	F
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(15,47,'SP',2015,4,'Letter','F');
--Rachel	PHIL165	sp2015	Letter Grade	2	D
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(12,47,'SP',2015,4,'Letter','D');
--Vikram	PHIL165	fa2015	Letter Grade	2	A-
insert into enrollment(s_id,class_id, quarter, year, units, grade_opt, grade)
values(11,48,'FA',2015,4,'Letter','A-');

1->38,33
2->30,24
3->24,20
4->44,38
5->30,26
6->11,10
7->51,44
8->38,34
9->30,25
10->7,7

--CURRENT ENROLLED STUDENTS
--name  sec grade           units
--Dave	2	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(16,30,24,'SP',2017,4,'Letter');
--Nelson	9	S/U				4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(17,30,25,'SP',2017,4,'PNP');
--Andrew	5	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(18,30,26,'SP',2017,4,'Letter');
--Nathan	2	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(19,30,24,'SP',2017,4,'Letter');
--John	9	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(20,30,25,'SP',2017,4,'Letter');
--Anwell	5	S/U				4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(21,30,26,'SP',2017,4,'PNP');
--Tim		3	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(22,24,20,'SP',2017,4,'Letter');
--Dave	3	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(16,24,20,'SP',2017,4,'Letter');
--Nelson	3	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(17,24,20,'SP',2017,4,'Letter');
--Benjamin10	S/U				4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(1,7,7,'SP',2017,4,'PNP');
--Julie	10	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(5,7,7,'SP',2017,4,'Letter');
--Daniel	10	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(3,7,7,'SP',2017,4,'Letter');
--Michael	1	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(7,38,33,'SP',2017,4,'Letter');
--Joseph	1	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(8,38,33,'SP',2017,4,'Letter');
--Devin	8	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(9,38,34,'SP',2017,4,'Letter');
--Claire	6	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(4,11,10,'SP',2017,4,'Letter');
--Rachel	4	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(12,44,38,'SP',2017,4,'Letter');
--Zach	7	S/U				4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(13,51,44,'SP',2017,4,'PNP');
--Justin	4	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(14,44,38,'SP',2017,4,'Letter');
--Rahul	7	Letter Grade	4
insert into enrollment(s_id,class_id, sec, quarter, year, units, grade_opt)
values(15,51,44,'SP',2017,4,'Letter');