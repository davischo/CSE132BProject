DROP table students_to_degrees;
DROP table course_to_cat;
DROP TABLE con_to_course;
DROP table concentration;
DROP TABLE students_to_degrees;
DROP table degrees;
DROP table prerequisites;
DROP TABLE probations;
DROP TABLE thesis_committee;
DROP table enrollment;
DROP TABLE meetings;
DROP TABLE sections;
DROP TABLE classes;
DROP TABLE courses;
DROP TABLE students;
DROP table faculty;
DROP table departments;
DROP table grade_conversion

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





--OLD TABLE
-- CREATE TABLE degrees(
--   id          SERIAL PRIMARY KEY,
--   name        TEXT NOT NULL UNIQUE,
--   department  TEXT REFERENCES departments(dept_name),
--   type        TEXT NOT NULL
-- );

-- CREATE TABLE categories(
--   id          SERIAL PRIMARY KEY,
--   name        TEXT UNIQUE NOT NULL
-- );

-- CREATE TABLE requirements(
--   id          SERIAL PRIMARY KEY,
--   deg_id      INTEGER REFERENCES degrees(id),
--   cat_id      INTEGER REFERENCES categories(id),
--   units       INTEGER NOT NULL CHECK(units>0)
-- );

-- CREATE TABLE course_to_cat(
--   id          SERIAL PRIMARY KEY,
--   course      TEXT REFERENCES courses(course_name),
--   cat         INTEGER REFERENCES categories(id)
-- );