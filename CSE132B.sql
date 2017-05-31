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
  name        TEXT NOT NULL UNIQUE,
  department  TEXT REFERENCES departments(dept_name),
  type        TEXT NOT NULL
);

--ADDED THIS RECENTLY
CREATE TABLE students_to_degrees(
  s_id        INTEGER REFERENCES students(id),
  d_id        INTEGER REFERENCES degrees(id),
  completed   TEXT NOT NULL
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


