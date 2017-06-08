--section 1 --> sectionid = 33
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(1,2,39,'Adele'); --sec33 CURRRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1000',33);

--section 2  --> sectionid = 24
Insert into sections(sec_id,enr_limit,class_id) values(2,5,30); -- CURRENT SEC sec24
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1000',24);

--section 3 --> sectionid = 20
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(3,5,24,'Flo Rida'); --sec20 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1200',20);


--Section 4 --> sectionid = 38
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(4,2,45,'Adam Levine'); --sec38 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1200',38);


--section 5 --> sectionid = 26
Insert into sections(sec_id,enr_limit,class_id) values(5,3,30); -- CURRENT SEC sec26
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1200',26);

--section 6 --> sectionid = 10
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(6,3,11,'Taylor Swift'); --sec10 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0200',10);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','A1','F 0600',10);


-- section 7 --> sectionid = 44
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(7,3,52,'Adam Levine'); --sec44 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0300',44);

-- section 8 --> sectionid = 34
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(8,1,39,'Selena Gomez'); --sec34 CURRRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0300',34);

-- section 9   -> sectionid = 25
Insert into sections(sec_id,enr_limit,class_id) values(9,2,30); -- CURRENT SEC sec25
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0500',25);

-- secion 10 --> sectionid = 7
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(10,5,7,'Adele'); --sec7 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','T Th 0500',7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','A1','W 0700',7);





