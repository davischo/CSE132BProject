
-- creating a section 
create or replace function isConflicts() returns trigger as
$body$
declare
	lec TEXT;
	dis TEXT;
	lab TEXT;
	rev1 TEXT;
	rev2 TEXT;
	rev11 TEXT;
	rev22 TEXT;
	fin TEXT;
begin 
	select NEW.lecture, NEW.discussion, New.lab, New.review1, New.review2, New.final
    INTO lec, dis,lab, rev11, rev22, fin;
    select right(rev11,6) into rev1;
    select right(rev22,6) into rev2;  
LIKE '%' || rev2|| '%'
 	if (dis LIKE '%' || lec || '%' or lab LIKE '%' || lec || '%' or rev1 LIKE '%' || lec || '%' or rev2 LIKE'%' || lec || '%'or
 		lec LIKE '%' || dis || '%' or lab LIKE '%' || dis || '%' or rev1 LIKE '%' || dis || '%' or rev2 LIKE '%' || dis || '%' or
 		lec LIKE '%' || lab || '%' or dis LIKE '%' || lab || '%' or rev1 LIKE '%' || lab || '%' or rev2 LIKE '%' || lab || '%' or 
 		lec LIKE '%' || rev1|| '%' or dis LIKE '%' || rev1|| '%' or lab LIKE '%' || rev1|| '%' or
 		lec LIKE '%' || rev2|| '%'or  dis LIKE '%' || rev2|| '%' or lab LIKE '%' || rev2|| '%' ) 
 	then raise exception 'Lecture and Discussion/Lab/Review Sessions are overlapping';
    end if;

 	if (rev11 like rev22 or rev11 like final or rev22 like final)
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
execute procedure isConflicts()




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

