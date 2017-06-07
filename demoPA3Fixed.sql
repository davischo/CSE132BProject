-- DROP CURRENT TABLE:
drop table meetings ;
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
  taught_by   TEXT REFERENCES faculty(fac_name),
  lecture 	  TEXT,
  discussion  TEXT,
  lab 		  TEXT,
  review1  	  TEXT,
  review2     TEXT,
  Final   	  TEXT
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
Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values (10,5,7,'Adele', 'T Th 0500', 'W 0700', 'T Th 0300', 'Feb15 M 1100', 'March14 M 1100', 'March15 Tu 0800');
