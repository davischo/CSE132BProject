CREATE TABLE departments(
  dept_id     SERIAL PRIMARY KEY,
  dept_name   TEXT NOT NULL UNIQUE,
  CHECK (dept_name <> '')
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

CREATE TABLE faculty(
  id          SERIAL PRIMARY KEY,
  fac_name    TEXT UNIQUE NOT NULL,
  title       TEXT NOT NULL,
  department  INTEGER REFERENCES departments(dept_id),
  Check(fac_name <> '')

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
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(10,90,7,'Adele'); --sec7 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0500',7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','A1','W 0700',7);
Insert into classes(course_name,title,quarter,year) values('CSE8A','Introduction to CS: Java','SP',2018); --NEXT OFFERED ,class8
---
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','WI',2015); --class9
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','WI',2016); --class10
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','SP',2017); --class11 CURRENT QUARTER
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,9,'Taylor Swift'); --sec8
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,10,'Taylor Swift'); --sec9
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(6,90,11,'Taylor Swift'); --sec10 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0200',10);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','A1','F 0600',10);
Insert into classes(course_name,title,quarter,year) values('CSE105','Intro to Theory','FA',2017); --NEXT OFFERED, class12

---

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


Insert into classes(course_name,title,quarter,year) values('CSE255','Data Mining And Predictive Analytics','FA',2015); --class22
Insert into classes(course_name,title,quarter,year) values('CSE255','Data Mining And Predictive Analytics','WI',2016); --class23
Insert into classes(course_name,title,quarter,year) values('CSE255','Data Mining And Predictive Analytics','SP',2017); --CURRENT QUARTER class24
Insert into sections(sec_id,enr_limit,class_id) values(11,90,22); --sec18
Insert into sections(sec_id,enr_limit,class_id) values(11,90,23); --sec19
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(3,90,24,'Flo Rida'); --sec20 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1200',20);
Insert into classes(course_name,title,quarter,year) values('CSE255','Data Mining And Predictive Analytics','WI',2018); --NEXT OFFERED class25

Insert into classes(course_name,title,quarter,year) values('CSE232A','Databases','FA',2015); --class26
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,26,'Kelly Clarkson'); --sec21
Insert into classes(course_name,title,quarter,year) values('CSE232A','Databases','SP',2018); --NEXT OFFERED class27

Insert into classes(course_name,title,quarter,year) values('CSE221','Operating Systems','SP',2015); --class28
Insert into classes(course_name,title,quarter,year) values('CSE221','Operating Systems','WI',2016); --class29
Insert into classes(course_name,title,quarter,year) values('CSE221','Operating Systems','SP',2017); --CURRENT QUARTER class30
Insert into sections(sec_id,enr_limit,class_id) values(11,90,28); --sec22
Insert into sections(sec_id,enr_limit,class_id) values(11,90,29); --sec23
Insert into sections(sec_id,enr_limit,class_id) values(2,90,30); -- CURRENT SEC sec24
Insert into sections(sec_id,enr_limit,class_id) values(9,90,30); -- CURRENT SEC sec25
Insert into sections(sec_id,enr_limit,class_id) values(5,90,30); -- CURRENT SEC sec26
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1000',24);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0500',25);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1200',26);
Insert into classes(course_name,title,quarter,year) values('CSE221','Operating Systems','FA',2017); --NEXT OFFERED class31


Insert into classes(course_name,title,quarter,year) values('MAE107','Computational Methods','SP',2015); --class32
Insert into classes(course_name,title,quarter,year) values('MAE107','Computational Methods','SP',2016); --class33
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,32,'Bjork'); --sec27
Insert into sections(sec_id,enr_limit,class_id) values(11,90,33); --sec28
Insert into classes(course_name,title,quarter,year) values('MAE107','Computational Methods','SP',2018); --NEXT OFFERED class34

Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','FA',2014); --class35
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','WI',2015); --class36
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','WI',2016); --class37
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','WI',2017); --class38
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','SP',2017); --CURRENT QUARTER class39
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,35,'Selena Gomez');  --sec29
Insert into sections(sec_id,enr_limit,class_id) values(11,90,36); --sec30
Insert into sections(sec_id,enr_limit,class_id) values(11,90,37); --sec31
Insert into sections(sec_id,enr_limit,class_id) values(11,90,38); --sec32
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(1,90,39,'Adele'); --sec33 CURRRENT SEC
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(8,90,39,'Selena Gomez'); --sec34 CURRRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1000',33);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0300',34);
Insert into classes(course_name,title,quarter,year) values('MAE108','Probability And Statistics','FA',2018); --NEXT OFFERED class40

Insert into classes(course_name,title,quarter,year) values('PHIL10','Intro to Logic','FA',2015); --class41
Insert into classes(course_name,title,quarter,year) values('PHIL10','Intro to Logic','FA',2016); --class42
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(11,90,41,'Bjork'); --sec35
Insert into sections(sec_id,enr_limit,class_id) values(11,90,42); --sec36
Insert into classes(course_name,title,quarter,year) values('PHIL10','Intro to Logic','WI',2018); --NEXT OFFERED class43

Insert into classes(course_name,title,quarter,year) values('PHIL12','Scientific Reasoning','WI',2016); --class44
Insert into classes(course_name,title,quarter,year) values('PHIL12','Scientific Reasoning','SP',2017); --class45 CURRENT QUARTER
Insert into sections(sec_id,enr_limit,class_id) values(11,90,44); --sec37
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(4,90,45,'Adam Levine'); --sec38 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1200',38);
Insert into classes(course_name,title,quarter,year) values('PHIL12','Scientific Reasoning','SP',2018); --NEXT OFFERED class46

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
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(7,90,52,'Adam Levine'); --sec44 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0300',44);
Insert into classes(course_name,title,quarter,year) values('PHIL165','Freedom, Equality, and The Law','SP',2018); --NEXT OFFERED class53

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

--QUERY USED FOR ENROLLMENT
-- select st.id, cs.course_name,cs.class_id, sec_id
-- from students st, classes cs, sections s
-- where first = 'Vikram' and cs.course_name='PHIL165'
-- and cs.quarter='FA' and cs.year = 2015
-- and cs.class_id = s.class_id

--Get all currently enrolled classes and sections and times for specified student
  SELECT c.class_id, c.course_name, sec.sec_id, m.type, m.day_time FROM students s, enrollment e, sections sec, meetings m, classes c
  WHERE s.id=e.s_id AND e.sec=sec.id AND m.sec_id=sec.id AND sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 AND s.SSN=9

--Get all current sections student is not enrolled in
    SELECT
      c.class_id,
      c.course_name,
      sec.sec_id,
      m.day_time,
      c.title
    FROM classes c, sections sec, meetings m
    WHERE c.class_id = sec.class_id AND m.sec_id = sec.id AND
          c.quarter = 'SP' AND c.year = 2017 AND
          c.course_name NOT IN
          (SELECT c.course_name
           FROM students s, enrollment e, sections sec, meetings m, classes c
           WHERE
             s.id = e.s_id AND e.sec = sec.id AND m.sec_id = sec.id AND sec.class_id = c.class_id AND c.quarter = 'SP'
             AND c.year = 2017 AND s.SSN = 9)
    ORDER BY c.class_id;

--Get all students of select section
SELECT c.class_id, c.course_name, sec.sec_id, m.type, m.day_time, s.id AS s_id FROM students s, enrollment e, sections sec, meetings m, classes c
WHERE s.id=e.s_id AND e.sec=sec.id AND m.sec_id=sec.id AND sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 AND sec.sec_id='1';

--Get all unavailable times for a given section
WITH enrolled AS (
  SELECT s.SSN FROM students s, enrollment e, sections sec, classes c
  WHERE s.id=e.s_id AND e.sec=sec.id AND sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 AND sec.sec_id='10')
  SELECT m.day_time FROM students s, enrollment e, sections sec, meetings m, classes c, enrolled
  WHERE s.id=e.s_id AND e.sec=sec.id AND m.sec_id=sec.id AND sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 AND s.SSN=enrolled.SSN;

--Get all unavailable times
SELECT m.day_time FROM students s, enrollment e, sections sec, meetings m, classes c
WHERE s.id=e.s_id AND e.sec=sec.id AND m.sec_id=sec.id AND sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 AND s.SSN=9


--Grade conversion
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

-- NEW STUFF I ENTER
insert into departments(dept_name) values('BUSINESS');
--INSERTING DEGREES (Note to self: change degrees name into NOT UNIQUE, could be CS BS and CS MS)
Insert into degrees(name,department,type,totalU,lowerDiv,upperDiv,techElec,gradUnits) values('COMPUTER SCIENCE', 1, 'B.S',40,10,15,15,0);
Insert into degrees(name,department, type,totalU,lowerDiv,upperDiv,techElec,gradUnits) values('PHILOSOPHY', 3, 'B.A', 35,15,20,0,0);
Insert into degrees(name,department, type,totalU,lowerDiv,upperDiv,techElec,gradUnits) values('MECHANICAL ENGINEERING', 2,'B.S',50,20,20,10,0);
Insert into degrees(name,department, type,totalU,lowerDiv,upperDiv,techElec,gradUnits) values('COMPUTER SCIENCE', 1, 'M.S',45,0,0,0,45);
Insert into degrees(name,department, type,totalU,lowerDiv,upperDiv,techElec,gradUnits) values('MBA', 4, 'M.S',45,0,0,0,45);

--STUDENT - DEGREE
--INSERTING MAJOR FOR EACH CUSTOMER
insert into students_to_degrees(s_id, d_id, completed) values(1,1,'N');
insert into students_to_degrees(s_id, d_id, completed) values(2,1,'N');
insert into students_to_degrees(s_id, d_id, completed) values(3,1,'N');
insert into students_to_degrees(s_id, d_id, completed) values(4,1,'N');
insert into students_to_degrees(s_id, d_id, completed) values(5,1,'N');

insert into students_to_degrees(s_id, d_id, completed) values(6,3,'N');
insert into students_to_degrees(s_id, d_id, completed) values(7,3,'N');
insert into students_to_degrees(s_id, d_id, completed) values(8,3,'N');
insert into students_to_degrees(s_id, d_id, completed) values(9,3,'N');
insert into students_to_degrees(s_id, d_id, completed) values(10,3,'N');

insert into students_to_degrees(s_id, d_id, completed) values(11,2,'N');
insert into students_to_degrees(s_id, d_id, completed) values(12,2,'N');
insert into students_to_degrees(s_id, d_id, completed) values(13,2,'N');
insert into students_to_degrees(s_id, d_id, completed) values(14,2,'N');
insert into students_to_degrees(s_id, d_id, completed) values(15,2,'N');

insert into students_to_degrees(s_id, d_id, completed) values(16,4,'N');
insert into students_to_degrees(s_id, d_id, completed) values(17,4,'N');
insert into students_to_degrees(s_id, d_id, completed) values(18,4,'N');
insert into students_to_degrees(s_id, d_id, completed) values(19,4,'N');
insert into students_to_degrees(s_id, d_id, completed) values(20,4,'N');
insert into students_to_degrees(s_id, d_id, completed) values(21,4,'N');
insert into students_to_degrees(s_id, d_id, completed) values(22,4,'N')

-- INSERT COURSE TO CATEGORIES
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('CSE8A',true,false,false,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('CSE105',false,true,true,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('CSE123',false,true,false,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('CSE250A',false,false,true,true);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('CSE250B',false,false,false,true);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('CSE255',false,false,false,true);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('CSE232A',false,false,false,true);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('CSE221',false,false,true,true);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('MAE3',true,false,true,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('MAE107',false,true,true,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('PHIL10',true,false,false,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('PHIL12',true,false,false,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('PHIL165',false,true,false,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('PHIL167',false,true,false,false);
insert into course_to_cat(course,isLD,isUD,isTechE,isGrad) values('MAE108',false,true,false,false);


-- CONCENTRATION
insert into concentration(name,minGPA,units,did) values('Databases',3.0,4,4);
insert into concentration(name,minGPA,units,did) values('AI',3.1,8,4);
insert into concentration(name,minGPA,units,did) values('Systems',3.3,4,4);
insert into concentration(name,minGPA,units,did) values('Statistics',3.5,4,3);
insert into concentration(name,minGPA,units,did) values('Aerospace',3.4,4,3);

--INSERT INTO CON_TO_COURSE
insert into con_to_course(con,course) values(1,'CSE232A');
insert into con_to_course(con,course) values(2,'CSE255');
insert into con_to_course(con,course) values(2,'CSE250A');
insert into con_to_course(con,course) values(3,'CSE221');

/*
insert into con_to_course(con,course) values(2,'CSE105');
Insert into classes (course_name,title,quarter,year)
values('CSE105','Theory', 'FA',2017)
*/