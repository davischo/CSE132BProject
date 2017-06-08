drop table CPQG;
drop table CPG;

-- create table CPQG
CREATE TABLE CPQG AS
(Select cl.course_name, en.class_id as cid, sec.taught_by as fac, en.quarter, en.year,
	COUNT( CASE WHEN en.grade LIKE 'A%' THEN 1 END) AS Acount,
	COUNT(CASE WHEN en.grade LIKE 'B%' THEN 1 END) AS Bcount,
	COUNT(CASE WHEN en.grade LIKE 'C%' THEN 1 END) AS Ccount,
	COUNT(CASE WHEN en.grade LIKE 'D%' THEN 1 END) AS Dcount,
	COUNT(CASE WHEN en.grade LIKE 'F%' OR en.grade = 'S/U' or en.grade = 'PNP' THEN 1 END)  AS otherCount
 From classes cl join sections sec on cl.class_id = sec.class_id join enrollment en on en.class_id = sec.class_id 
 group by  cl.course_name,cid, fac, en.quarter,en.year
)

-- create table CPQ
CREATE TABLE CPG AS 
(Select cl.course_name, sec.taught_by as fac,
	COUNT( CASE WHEN en.grade LIKE 'A%' THEN 1 END) AS Acount,
	COUNT(CASE WHEN en.grade LIKE 'B%' THEN 1 END) AS Bcount,
	COUNT(CASE WHEN en.grade LIKE 'C%' THEN 1 END) AS Ccount,
	COUNT(CASE WHEN en.grade LIKE 'D%' THEN 1 END) AS Dcount,
	COUNT(CASE WHEN en.grade in ('F%', 'S/U', 'PNP') THEN 1 END)  AS otherCount
 From classes cl join sections sec on cl.class_id = sec.class_id join enrollment en on en.class_id = sec.class_id 
 group by fac, cl.course_name
)


--TRIGGER CODE FOR INSERTING INTO ENROLLMENT
create or replace function insertGrade() returns trigger as
	$body$
	begin
	if(New.grade LIKE 'A%') then 
	UPDATE CPQG SET Acount = Acount + 1;
	UPDATE CPG SET Acount = Acount +1;
	end if;

	if(New.grade LIKE 'B%') then 
	UPDATE CPQG SET Bcount = Bcount + 1;
	UPDATE CPG SET Bcount = Bcount +1;
	end if;

	if(New.grade LIKE 'C%') then 
	UPDATE CPQG SET Ccount = Ccount + 1;
	UPDATE CPG SET Ccount = Ccount +1;
	end if;

	if(New.grade LIKE 'D%') then 
	UPDATE CPQG SET Dcount = Dcount + 1;
	UPDATE CPG SET Dcount = Dcount +1;
	end if;

	if(New.grade LIKE 'F%' OR NEW.grade = 'S/U' or NEW.grade = 'PNP') then 
	UPDATE CPQG SET Dcount = Dcount + 1;
	UPDATE CPG SET Dcount = Dcount +1;
	end if;
	return New;
	end;
$body$language plpgsql;
DROP trigger if exists insertMaintainance on enrollment;
Create trigger insertMaintainance 
After insert on enrollment 
For each row execute procedure insertGrade();


--TRIGGER CODE FOR UPDATE ENROLLMENT
create or replace function updateGrades() returns trigger as
	$body$
	declare 
		oldGrade STRING;
	begin
	if(Old.grade NOT LIKE New.grade||'%' or New.grade NOT LIKE Old.grade||'%' ) then
		if(New.grade LIKE 'A%') then 
		UPDATE CPQG SET Acount = Acount + 1;
		UPDATE CPG SET Acount = Acount +1;
		end if;

		if(New.grade LIKE 'B%') then 
		UPDATE CPQG SET Bcount = Bcount + 1;
		UPDATE CPG SET Bcount = Bcount +1;
		end if;

		if(New.grade LIKE 'C%') then 
		UPDATE CPQG SET Ccount = Ccount + 1;
		UPDATE CPG SET Ccount = Ccount +1;
		end if;

		if(New.grade LIKE 'D%') then 
		UPDATE CPQG SET Dcount = Dcount + 1;
		UPDATE CPG SET Dcount = Dcount +1;
		end if;

		if(New.grade LIKE 'F%' OR NEW.grade = 'S/U' or NEW.grade = 'PNP') then 
		UPDATE CPQG SET Dcount = Dcount + 1;
		UPDATE CPG SET Dcount = Dcount +1;
		end if;


		if(old.grade LIKE 'A%') then 
		UPDATE CPQG SET Acount = Acount - 1;
		UPDATE CPG SET Acount = Acount  - 1;
		end if;

		if(old.grade LIKE 'B%') then 
		UPDATE CPQG SET Bcount = Bcount - 1;
		UPDATE CPG SET Bcount = Bcount  -1;
		end if;

		if(old.grade LIKE 'C%') then 
		UPDATE CPQG SET Ccount = Ccount - 1;
		UPDATE CPG SET Ccount = Ccount  - 1;
		end if;

		if(old.grade LIKE 'D%') then 
		UPDATE CPQG SET Dcount = Dcount -  1;
		UPDATE CPG SET Dcount = Dcount  - 1;
		end if;

		if(old.grade LIKE 'F%' OR old.grade = 'S/U' or old.grade = 'PNP') then 
		UPDATE CPQG SET Dcount = Dcount -  1;
		UPDATE CPG SET Dcount = Dcount  - 1;
		end if;
	end if;
	return New;
	end;
$body$language plpgsql;

DROP trigger if exists updateViews on enrollment;
Create trigger updateViews
After update on enrollment 
For each row execute procedure updateGrades();
