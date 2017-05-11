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
  enr_limit   INTEGER NOT NULL,
  class_id    INTEGER REFERENCES classes(class_id),
  taught_by   TEXT REFERENCES faculty(fac_name)
);

CREATE TABLE meetings(
  id          SERIAL PRIMARY KEY,
  type        TEXT NOT NULL,
  weekly      BOOLEAN NOT NULL,
  mandatory   BOOLEAN NOT NULL,
  room        TEXT NOT NULL,
  start_time  TEXT NOT NULL,
  end_time    TEXT NOT NULL,
  day         TEXT NOT NULL,
  sec_id      INTEGER REFERENCES sections(id)
);

CREATE TABLE enrollment(
  s_id        TEXT REFERENCES students(s_id),
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
  name        TEXT NOT NULL UNIQUE,
  department  INTEGER REFERENCES departments(dept_id)
);

CREATE TABLE categories(
  id          SERIAL PRIMARY KEY,
  name        TEXT UNIQUE NOT NULL
);

CREATE TABLE requirements(
  id          SERIAL PRIMARY KEY,
  deg_id      INTEGER REFERENCES degrees(id),
  cat_id      INTEGER REFERENCES categories(id),
  units       INTEGER NOT NULL CHECK(units>0)
);

CREATE TABLE course_to_cat(
  id          SERIAL PRIMARY KEY,
  course      TEXT REFERENCES courses(course_name),
  cat         INTEGER REFERENCES categories(id)
);

CREATE TABLE prerequisites(
  id          SERIAL PRIMARY KEY,
  course      TEXT REFERENCES courses(course_name),
  pre         TEXT REFERENCES courses(course_name),
  CHECK ( course <> pre)
);

INSERT INTO students(first, middle, last, s_id, SSN, level, residency, college)
    VALUES('test','jr','testingham','1','1','undergrad','resident','sixth');
INSERT INTO departments( dept_name ) VALUES( 'CSE' );
INSERT INTO departments( dept_name ) VALUES( 'ECE' );
INSERT INTO faculty(fac_name, title, department) VALUES( 'Deutsch Alin','professor',1 );
INSERT INTO faculty(fac_name, title, department) VALUES( 'Alvarado','professor',1 );
INSERT INTO courses(course_name,department,lab,min_unit,max_unit,grad_opt,instr_cons)
    VALUES( 'Back End Database',1,false,4,4,'both',false );
INSERT INTO courses(course_name,department,lab,min_unit,max_unit,grad_opt,instr_cons)
    VALUES( 'Beginning Back End Database',1,false,4,8,'grade',false );
INSERT INTO classes(course_name, title, quarter, year, scheduled_fac)
    VALUES( 'Back End Database', 'CSE132B', 'SP',2017, 'Deutsch Alin' );
INSERT INTO classes(course_name, title, quarter, year, scheduled_fac)
    VALUES( 'Beginning Back End Database', 'CSE132A', 'FA',2017, 'Deutsch Alin' );
INSERT INTO sections(sec_id, enr_limit, class_id, taught_by)
    VALUES( 'A01', 30, 1, 'Deutsch Alin');
INSERT INTO sections(sec_id, enr_limit, class_id, taught_by)
    VALUES( 'A02', 30, 1, 'Deutsch Alin');
INSERT INTO sections(sec_id, enr_limit, class_id, taught_by)
    VALUES( 'A01', 30, 2, 'Deutsch Alin');
INSERT INTO sections(sec_id, enr_limit, class_id, taught_by)
    VALUES( 'A02', 30, 2, 'Deutsch Alin');
INSERT INTO meetings(type, weekly, mandatory, room, start_time, end_time, day, sec_id)
    VALUES( 'lecture',true,true,'CSB3','11:00 am','12:30 pm', 'TUES/THURS', 1);
INSERT INTO meetings(type, weekly, mandatory, room, start_time, end_time, day, sec_id)
    VALUES( 'lecture',true,true,'CSB3','11:00 am','12:30 pm', 'MON/WED', 2);
INSERT INTO meetings(type, weekly, mandatory, room, start_time, end_time, day, sec_id)
    VALUES( 'lecture',true,true,'CNTR119','11:00 pm','12:30 am', 'TUES/THURS', 3);
INSERT INTO meetings(type, weekly, mandatory, room, start_time, end_time, day, sec_id)
    VALUES( 'lecture',true,true,'CNTR119','11:00 pm','12:30 am', 'MON/WED', 4);

INSERT INTO degrees(name, department)
VALUES('B.S. Computer Science', 1);
INSERT INTO degrees(name, department)
VALUES('B.S. Computer Engineering', 2);

INSERT INTO categories(name) VALUES('Upper Div');
INSERT INTO categories(name) VALUES('Lower Div');

