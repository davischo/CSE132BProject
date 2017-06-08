-- 4.1 creating a section
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

create trigger checkConflicts
before insert on sections
for each row
execute procedure isConflicts();

-- 4.2 enrolling a student
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

--TO CHECK LECTURES,DISCUSSIONS, AND LABS OF A FACULTY
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

--Used for testing
Insert into sections(sec_id,enr_limit,class_id,taught_by,lec_day,lec_time,dis_day,dis_time,lab_day,lab_time,rev1,rev2,fin)
values(8,1,39,'Adam Levine','M', '0300','T', '0800', 'Su','0700', 'Mar1 Th 0700','Mar21 Th 0700', 'Apr15 T 0900');
select * from sections;

