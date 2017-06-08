
drop schema public cascade;
create schema public;
--CREATE TABLE:
CREATE TABLE departments(
  dept_id     SERIAL PRIMARY KEY,
  dept_name   TEXT NOT NULL UNIQUE,
  CHECK (dept_name <> '')
);

CREATE TABLE faculty(
  id          SERIAL PRIMARY KEY,
  fac_name    TEXT UNIQUE NOT NULL,
  title       TEXT NOT NULL,
  department  INTEGER REFERENCES departments(dept_id),
  Check(fac_name <> '')
);

CREATE TABLE courses (
  id          SERIAL,
  course_name TEXT UNIQUE NOT NULL PRIMARY KEY,
  department  INTEGER REFERENCES departments(dept_id),
  lab         BOOLEAN NOT NULL,
  min_unit    INTEGER CHECK (min_unit > 0),
  max_unit    INTEGER CHECK (max_unit >= min_unit),
  grad_opt    TEXT NOT NULL,
  instr_cons  BOOLEAN NOT NULL
  CHECK(course_name <> '')
);

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
  taught_by   TEXT REFERENCES faculty(fac_name),
  lec_day     TEXT,
  lec_time    TEXT,
  dis_day     TEXT,
  dis_time    TEXT,
  lab_day     TEXT,
  lab_time    TEXT,
  rev1        TEXT,
  rev2        TEXT,
  fin         TEXT
);

CREATE TABLE students(
  id          SERIAL PRIMARY KEY,
  first       TEXT NOT NULL CHECK (first <> ''),
  middle      TEXT,
  last        TEXT NOT NULL CHECK (last <> ''),
  s_id        TEXT NOT NULL UNIQUE CHECK (s_id <> ''),
  SSN         INTEGER NOT NULL UNIQUE CHECK (SSN >= 0),
  level       TEXT NOT NULL,
  residency   TEXT NOT NULL,
  college     TEXT
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

CREATE TABLE thesis_committee(
  id          SERIAL PRIMARY KEY,
  s_id        TEXT REFERENCES students(s_id),
  fac_name    TEXT REFERENCES faculty(fac_name)
);

CREATE TABLE probations(
  id          SERIAL PRIMARY KEY,
  s_id        TEXT REFERENCES students(s_id),
  year        INTEGER NOT NULL CHECK(year>1960),
  quarter     TEXT NOT NULL,
  reason      TEXT NOT NULL
);

CREATE TABLE degrees(
  id          SERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  department  INTEGER REFERENCES departments(dept_id),
  type        TEXT NOT NULL,
  totalU      INTEGER NOT NULL check(totalU > 0),
  lowerDiv    INTEGER NOT NULL check (lowerDiv  >= 0),
  upperDiv    INTEGER NOT NULL check (upperDiv >= 0),
  techElec    INTEGER check (techElec >= 0),
  gradUnits   INTEGER check (gradUnits >= 0)
);

CREATE TABLE prerequisites(
  id          SERIAL PRIMARY KEY,
  course      TEXT REFERENCES courses(course_name),
  pre         TEXT REFERENCES courses(course_name),
  CHECK ( course <> pre)
);

CREATE TABLE concentration(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  minGPA REAL check (minGPA>=0.0),
  units INTEGER check (units>=0),
  did INTEGER references degrees(id)
);

CREATE TABLE con_to_course(
  id      SERIAL PRIMARY KEY,
  con       INTEGER REFERENCES concentration(id),
  course      TEXT REFERENCES courses(course_name)
);

CREATE TABLE course_to_cat(
  id          SERIAL PRIMARY KEY,
  course      TEXT REFERENCES courses(course_name),
  isLD        boolean,
  isUD        boolean,
  isTechE   boolean,
  isGrad   boolean
);


CREATE TABLE students_to_degrees(
  s_id INTEGER references students(id),
  d_id INTEGER references degrees(id),
  completed TEXT NOT NULL
);

create table GRADE_CONVERSION
( LETTER_GRADE CHAR(2) NOT NULL,
NUMBER_GRADE DECIMAL(2,1)
);


--STUDENTS
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(1, 'Benjamin', 'B', 'Undergraduate',1,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(2, 'Kristen', 'W', 'Undergraduate',2,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(3, 'Daniel', 'F', 'Undergraduate',3,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(4, 'Claire', 'J', 'Undergraduate',4,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(5, 'Julie', 'C', 'Undergraduate',5,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(6, 'Kevin', 'L', 'Undergraduate',6,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(7, 'Michael', 'B', 'Undergraduate',7,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(8, 'Joseph', 'J', 'Undergraduate',8,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(9, 'Devin', 'P', 'Undergraduate',9,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(10, 'Logan', 'F', 'Undergraduate',10,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(11, 'Vikram', 'N', 'Undergraduate',11,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(12, 'Rachel',	'Z', 'Undergraduate',12,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(13, 'Zach', 'M', 'Undergraduate',13,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(14, 'Justin', 'H', 'Undergraduate',14,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(15, 'Rahul', 'R', 'Undergraduate',15,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(16, 'Dave', 'C', 'MS',16,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(17, 'Nelson', 'H', 'MS',17,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(18, 'Andrew', 'P', 'MS',18,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(19, 'Nathan', 'S', 'MS',19,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(20, 'John', 'H', 'MS',20,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(21, 'Anwell', 'W', 'MS',21,'California');
INSERT INTO students(SSN, first, last, level, s_id, residency) VALUES(22, 'Tim', 'K', 'MS',22,'California');

--DEPARTMENTS
INSERT INTO departments(dept_name) VALUES('Computer Science');
INSERT INTO departments(dept_name) VALUES('Mechanical Engineering');
INSERT INTO departments(dept_name) VALUES('Philosophy');

--FACULTY
INSERT INTO faculty(fac_name, title, department) VALUES('Justin Bieber','Associate Professor',1);
INSERT INTO faculty(fac_name, title, department) VALUES('Flo Rida','Professor',1);
INSERT INTO faculty(fac_name, title, department) VALUES('Selena Gomez','Professor',1);
INSERT INTO faculty(fac_name, title, department) VALUES('Adele','Professor',1);
INSERT INTO faculty(fac_name, title, department) VALUES('Taylor Swift','Professor',1);
INSERT INTO faculty(fac_name, title, department) VALUES('Kelly Clarkson','Professor',1);
INSERT INTO faculty(fac_name, title, department) VALUES('Adam Levine','Professor',1);
INSERT INTO faculty(fac_name, title, department) VALUES('Bjork','Professor',1);

--COURSES
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('CSE8A',1,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('CSE105',1,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('CSE123',1,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('CSE250A',1,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('CSE250B',1,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('CSE255',1,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('CSE232A',1,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('CSE221',1,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('MAE3',2,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('MAE107',2,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('MAE108',2,'false',2,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('PHIL10',3,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('PHIL12',3,'false',4,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('PHIL165',3,'false',2,4,'Both','No');
INSERT INTO courses(course_name, department, lab, min_unit, max_unit, grad_opt, instr_cons) VALUES('PHIL167',3,'false',4,4,'Both','No');

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
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values (10,5,7,'Adele', 'TTh', '0500', 'W','0700', 'TTh','0300', 'Feb15 M 1100', 'Mar14 M 1100', 'Mar15 Tu 0800');

Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','SP',2018); --NEXT OFFERED ,class8
---------------------------------------------------------------

Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','WI',2015); --class9
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','WI',2016); --class10
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','SP',2017); --class11 CURRENT QUARTER
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,9,'Taylor Swift'); --sec8
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,10,'Taylor Swift'); --sec9

--CURRENT OFFERED : section 6 --> section_id = 10
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(6,3,11,'Taylor Swift', 'TTh', '0200', 'F', '0600', '','','','Mar15 T 0100', 'Mar17 Th 0800');

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
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(3,5,24,'Flo Rida', 'MWF','1200', '','','','','','','Mar16 W 0800');

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
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(2,5,30,'Kelly Clarkson', 'MWF','1000', 'TTh', '1100', '', '','', 'Mar07 M 0800', 'Mar14 M 0800');

--section 9 --> section_id = 25
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values (9,2,30,'Justin Bieber', 'TTh', '0500','MF', '0900', '', '','','Mar09 W 0900',  'Mar16 W 0800' );

--section 5 --> section_id = 26
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(5,3,30,'Kelly Clarkson', 'MWF','1200', 'TTh', '1200' ,'','','','Mar08 T 0800','Mar15 T 0800');

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
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(1,2,39,'Adele', 'MWF', '1000', 'TTh','1000','F', '0600','','', 'Mar14 M 0800');

-- section 8 --> section_id =  34
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(8,1,39,'Selena Gomez','TTh', '0300','M', '0300', 'F','0500', '','', 'Mar15 T 0800');

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
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(4,2,45,'Adam Levine', 'MWF', '1200', 'WF','100' ,'','','','Mar07 M 0900','Mar16 W 0800');

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
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(7,3,52,'Adam Levine', 'TTh', '0300', 'Th', '0100', '','', 'Jan29 F 0800', 'Mar17 Th 0500', 'Mar18 F 0800');

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

insert into grade_conversion values('A+', 4.0);
insert into grade_conversion values('A', 4.0);
insert into grade_conversion values('A-', 3.7);
insert into grade_conversion values('B+', 3.3);
insert into grade_conversion values('B', 3.0);
insert into grade_conversion values('B-', 2.7);
insert into grade_conversion values('C+', 2.3);
insert into grade_conversion values('C', 2.0);
insert into grade_conversion values('C-', 1.7);
insert into grade_conversion values('D', 1.0);
insert into grade_conversion values('F', 0.0);

-- creating a section
create  or replace function isConflicts() returns trigger as
$body$
declare
	lec_day TEXT;
  lec_time TEXT;
	dis_day TEXT;
  dis_time TEXT;
	lab_day TEXT;
  lab_time TEXT;
	rev2 TEXT;
	rev1 TEXT;
	rev1temp TEXT;
	rev1day TEXT;
	rev1time TEXT;
	rev2temp TEXT;
	rev2day TEXT;
	rev2time TEXT;
	fin TEXT;
	fintemp TEXT;
	finday TEXT;
	fintime TEXT;
begin
	select NEW.lec_day, NEW.lec_time, NEW.dis_day, NEW.dis_time, NEW.lab_day, NEW.lab_time, NEW.rev1, NEW.rev2, NEW.fin
    INTO lec_day,lec_time, dis_day,dis_time,lab_day,lab_time, rev1, rev2, fin;
    select right(rev1,6) into rev1temp;
    select left(rev1temp,1) into rev1day;
    select right(rev1temp,4) into rev1time;
    select right(rev2,6) into rev2temp;
    select left(rev2temp,1) into rev2day;
    select right(rev2temp,4) into rev2time;
    select right(fin,6) into fintemp;
    select left(fintemp,1) into finday;
    select right(fintemp,4) into fintime;
 	if ( (lec_day LIKE '%'||dis_day||'%' AND lec_time LIKE dis_time) OR (lec_day LIKE '%'||lab_day||'%' AND lec_time LIKE lab_time) OR
 		(lec_day LIKE '%'||rev1day||'%' AND lec_time LIKE rev1time) OR (lec_day LIKE '%'||rev2day||'%' AND lec_time LIKE rev2time) OR
		(lec_day LIKE '%'||finday||'%' AND lec_time LIKE fintime) OR

		(dis_day LIKE '%'||lec_day||'%' AND dis_time LIKE lec_time) OR (dis_day LIKE '%'||lab_day||'%' AND dis_time LIKE lab_time) OR
 		(dis_day LIKE '%'||rev1day||'%' AND dis_time LIKE rev1time) OR (dis_day LIKE '%'||rev2day||'%' AND dis_time LIKE rev2time) OR
		(dis_day LIKE '%'||finday||'%' AND dis_time LIKE fintime) OR

		(lab_day LIKE '%'||lec_day||'%' AND lab_time LIKE lec_time) OR (lab_day LIKE '%'||dis_day||'%' AND lab_time LIKE dis_time) OR
 		(lab_day LIKE '%'||rev1day||'%' AND lab_time LIKE rev1time) OR (lab_day LIKE '%'||rev2day||'%' AND lab_time LIKE rev2time) OR
		(lab_day LIKE '%'||finday||'%' AND lab_time LIKE fintime) )
 	THEN raise exception 'Lecture and Discussion/Lab/Review Sessions are overlapping';
    end if;
 	if (rev1 like rev2 or rev1 like fin or rev2 like fin)
 	then raise exception 'Review Sessions or/and Finals are overlapping';
 	end if;
 	raise notice 'Adding section %', New.id;
 	return NEW;
 	end;
 	$body$language plpgsql;

drop trigger checkConflicts on sections;

create trigger checkConflicts
before insert on sections
for each row
execute procedure isConflicts();

Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day, lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(8,1,39,'Selena Gomez','MW', '0700','T', '0700', 'Su','0700', 'Mar1 Th 0700','Mar21 Th 0700', 'Apr15 T 0800');
select * from sections;

-- enrolling a student
create or replace function isLimit() returns trigger as
$body$
declare
	sectionLimit INTEGER;
    sectionEnrolled INTEGER;
begin
	select count(s_id), s.enr_limit into sectionEnrolled, sectionLimit
    from enrollment e, sections s
    where e.sec = New.sec and s.id = e.sec group by e.sec, s.enr_limit;

    if (sectionEnrolled = sectionLimit) then raise exception 'The section is full. No more students can be added';
    end if;
    raise notice 'Adding student %', New.s_id;
    return NEW;
end;
$body$language plpgsql;

create trigger checkLimit
before insert on enrollment
for each row
execute procedure isLimit()

--TO CHECK LECTURES OF A FACULTY

create  or replace function isConflictsLecs() returns trigger as
$body$
begin
	if( (select COUNT(*)
    FROM sections s WHERE s.id<>NEW.id AND s.taught_by=NEW.taught_by AND (
    (NEW.lec_day LIKE '%'||lec_day||'%' OR lec_day LIKE '%'||NEW.lec_day||'%') AND NEW.lec_time LIKE lec_time))> 0 )
  THEN raise exception 'A lecture at that day/time already exists';
    end if;
  if( (select COUNT(*)
    FROM sections s WHERE s.id<>NEW.id AND s.taught_by=NEW.taught_by AND (
    (NEW.lec_day LIKE '%'||dis_day||'%' OR dis_day LIKE '%'||NEW.lec_day||'%') AND NEW.lec_time LIKE dis_time))> 0 )
  THEN raise exception 'A discussion at that day/time already exists';
    end if;
  if( (select COUNT(*)
    FROM sections s WHERE s.id<>NEW.id AND s.taught_by=NEW.taught_by AND (
    (NEW.lec_day LIKE '%'||lab_day||'%' OR lab_day LIKE '%'||NEW.lec_day||'%') AND NEW.lec_time LIKE lab_time))> 0 )
  THEN raise exception 'A lab at that day/time already exists';
    end if;
 	raise notice 'Adding section %', New.id;
 	return NEW;
 	end;
 	$body$language plpgsql;

drop trigger checkLecs ON sections;

create trigger checkLecs
before insert on sections
for each row
execute procedure isConflictsLecs();

Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day,lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(8,1,39,'Adam Levine','M', '0300','T', '0800', 'Su','0700', 'Mar1 Th 0700','Mar21 Th 0700', 'Apr15 T 0900');
select * from sections;

--FOR FUTURE

create  or replace function isConflicts() returns trigger as
$body$
declare
	lec_day TEXT;
  lec_time TEXT;
	dis_day TEXT;
  dis_time TEXT;
	lab_day TEXT;
  lab_time TEXT;
	rev2 TEXT;
	rev1 TEXT;
	rev1temp TEXT;
	rev1day TEXT;
	rev1time TEXT;
	rev2temp TEXT;
	rev2day TEXT;
	rev2time TEXT;
	fin TEXT;
	fintemp TEXT;
	finday TEXT;
	fintime TEXT;
begin
	select s.lec_day, s.lec_time, s.dis_day, s.dis_time, s.lab_day, s.lab_time, s.rev1, s.rev2, s.fin
    INTO lec_day,lec_time, dis_day,dis_time,lab_day,lab_time, rev1, rev2, fin
    FROM sections s;
    select right(rev1,6) into rev1temp;
    select left(rev1temp,1) into rev1day;
    select right(rev1temp,4) into rev1time;
    select right(rev2,6) into rev2temp;
    select left(rev2temp,1) into rev2day;
    select right(rev2temp,4) into rev2time;
    select right(fin,6) into fintemp;
    select left(fintemp,1) into finday;
    select right(fintemp,4) into fintime;
 	if ( (NEW.lec_day LIKE '%'||dis_day||'%' AND NEW.lec_time LIKE dis_time) OR (NEW.lec_day LIKE '%'||lab_day||'%' AND NEW.lec_time LIKE lab_time) OR
 		(NEW.lec_day LIKE '%'||rev1day||'%' AND NEW.lec_time LIKE rev1time) OR (NEW.lec_day LIKE '%'||rev2day||'%' AND NEW.lec_time LIKE rev2time) OR
		(lec_day LIKE '%'||finday||'%' AND lec_time LIKE fintime) OR

		(NEW.dis_day LIKE '%'||lec_day||'%' AND NEW.dis_time LIKE lec_time) OR (NEW.dis_day LIKE '%'||lab_day||'%' AND NEW.dis_time LIKE lab_time) OR
 		(NEW.dis_day LIKE '%'||rev1day||'%' AND NEW.dis_time LIKE rev1time) OR (NEW.dis_day LIKE '%'||rev2day||'%' AND NEW.dis_time LIKE rev2time) OR
		(NEW.dis_day LIKE '%'||finday||'%' AND NEW.dis_time LIKE fintime) OR

		(NEW.lab_day LIKE '%'||lec_day||'%' AND NEW.lab_time LIKE lec_time) OR (NEW.lab_day LIKE '%'||dis_day||'%' AND NEW.lab_time LIKE dis_time) OR
 		(NEW.lab_day LIKE '%'||rev1day||'%' AND NEW.lab_time LIKE rev1time) OR (NEW.lab_day LIKE '%'||rev2day||'%' AND NEW.lab_time LIKE rev2time) OR
		(NEW.lab_day LIKE '%'||finday||'%' AND NEW.lab_time LIKE fintime) )
 	THEN raise exception 'Lecture and Discussion/Lab/Review Sessions are overlapping';
    end if;
 	if (rev1 like rev2 or rev1 like fin or rev2 like fin)
 	then raise exception 'Review Sessions or/and Finals are overlapping';
 	end if;
 	raise notice 'Adding section %', New.id;
 	return NEW;
 	end;
 	$body$language plpgsql;
