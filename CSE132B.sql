EATE TABLE courses (
  id          SERIAL,
  course_name TEXT UNIQUE NOT NULL PRIMARY KEY,
  lab         BOOLEAN     NOT NULL,
  min_unit    INTEGER CHECK (min_unit > 0),
  max_unit    INTEGER CHECK (max_unit >= min_unit),
  grad_opt    TEXT NOT NULL,
  instr_cons  BOOLEAN NOT NULL
);

CREATE TABLE students(
  id          SERIAL PRIMARY KEY,
  first       TEXT NOT NULL,
  middle      TEXT,
  last        TEXT NOT NULL,
  s_id        INTEGER NOT NULL UNIQUE,
  SSN         INTEGER NOT NULL UNIQUE,
  residency   TEXT NOT NULL
);

CREATE TABLE departments(
  dept_id     SERIAL PRIMARY KEY,
  dept_name   TEXT NOT NULL UNIQUE
);

CREATE TABLE categories(
  id          SERIAL PRIMARY KEY,
  name        TEXT UNIQUE NOT NULL
);

//Just testing
INSERT INTO courses(course_name,lab,min_unit,max_unit,grad_opt,instr_cons) VALUES( 'random',true,1,1,'grade',true  );

CREATE TABLE faculty(
  id          SERIAL,
  fac_name    TEXT NOT NULL UNIQUE PRIMARY KEY,
  title       TEXT NOT NULL,
  department  INTEGER REFERENCES departments(dept_id)
);

CREATE TABLE classes(
  class_id    SERIAL PRIMARY KEY,
  course_name TEXT REFERENCES courses(course_name),
  title       TEXT NOT NULL,
  term        TEXT NOT NULL
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
  s_id        INTEGER REFERENCES students(s_id),
  class_id    INTEGER REFERENCES classes(class_id),
  sec         INTEGER REFERENCES sections(id),
  term        TEXT NOT NULL,
  units       INTEGER NOT NULL,
  grade_opt   TEXT NOT NULL,
  grade       TEXT
);

CREATE TABLE thesis_committee(
  id          SERIAL PRIMARY KEY,
  s_id        INTEGER REFERENCES students(s_id),
  fac_name    TEXT REFERENCES faculty(fac_name)
);

CREATE TABLE probations(
  id          SERIAL PRIMARY KEY,
  s_id        INTEGER REFERENCES students(s_id),
  term        TEXT NOT NULL,
  reason      TEXT NOT NULL
);

CREATE TABLE degrees(
  id          SERIAL PRIMARY KEY,
  name        TEXT NOT NULL UNIQUE,
  department  INTEGER REFERENCES departments(dept_id)
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

CREATE TABLE prerequisistes(
  id          SERIAL PRIMARY KEY,
  course      TEXT REFERENCES courses(course_name),
  pre         TEXT REFERENCES courses(course_name)
);
