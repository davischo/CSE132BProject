--section 1 --> sectionid = 33
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(1,2,39,'Adele'); --sec33 CURRRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A1','M W F 1000',33);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Discussion','true','false','R1', 'T Th 1000', 33);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Lab','true','false','L1', 'F 0600', 33);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A1', 'March14 M 0800', 33);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values(1,2,39,'Adele', 'M W F 1000', 'T Th 1000','F 0600', '','', 'March14 M 0800');

--section 2  --> sectionid = 24
Insert into sections(sec_id,enr_limit,class_id) values(2,5,30,'Kelly Clarkson'); -- CURRENT SEC sec24
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A2','M W F 1000',24);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Discussion','true','false','R2', 'T Th 1100', 24);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S2', 'March07 M 0800', 24);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A2', 'March14 M 0800', 24);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values(2,5,30,'Kelly Clarkson', 'M W F 1000', 'T Th 1100', '', '', 'March07 M 0800', 'March14 M 0800');


--section 3 --> sectionid = 20
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(3,5,24,'Flo Rida'); --sec20 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A3','M W F 1200',20);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A3', 'March16 W 0800', 20);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values(3,5,24,'Flo Rida', 'M W F 1200', '','','','','March16 W 0800');

--Section 4 --> sectionid = 38
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(4,2,45,'Adam Levine'); --sec38 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A4','M W F 1200',38);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Discussion','true','false','R4', 'W F 100', 38);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S4', 'March07 M 0900', 38);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A4', 'March14 M 0800', 38);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values(4,2,45,'Adam Levine', 'M W F 1200', 'W F 100' ,'','','March07 M 0900','March16 W 0800');


--section 5 --> sectionid = 26
Insert into sections(sec_id,enr_limit,class_id) values(5,3,30,'Kelly Clarkson'); -- CURRENT SEC sec26
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A5','M W F 1200',26);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Discussion','true','false','R5', 'T Th 1200', 26);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S5', 'March08 T 0800', 26);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A5', 'March15 T 0800', 26);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values(5,3,30,'Kelly Clarkson', 'M W F 1200', 'T Th 1200' ,'','','March08 T 0800','March15 T 0800');


--section 6 --> sectionid = 10
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(6,3,11,'Taylor Swift'); --sec10 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A6','T Th 0200',10);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','R6','F 0600',10);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S6', 'March15 T 0100', 10);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A6', 'March17 Th 0800', 10);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values(6,3,11,'Taylor Swift', 'T Th 0200', 'F 0600', '','','March15 T 0100', 'March17 Th 0800');


-- section 7 --> sectionid = 44
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(7,3,52,'Adam Levine'); --sec44 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A7','T Th 0300',44);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','R7','Th 0100',44);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S7', 'Jan29 F 0800', 44);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S7', 'March17 Th 0500', 44);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A7', 'March18 F 0800', 44);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values(7,3,52,'Adam Levine', 'T Th 0300', 'Th 0100', '', 'Jan29 F 0800', 'March17 Th 0500', 'March18 F 0800');


-- section 8 --> sectionid = 34
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(8,1,39,'Selena Gomez'); --sec34 CURRRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A8','T Th 0300',34);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','R8','M 0300',34);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Lab','true','false','L8', 'F 0500', 34);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A8', 'March15 T 0800', 34);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values(8,1,39,'Selena Gomez','T Th 0300','M 0300', 'F 0500', '','', 'March15 T 0800');

-- section 9   -> sectionid = 25
Insert into sections(sec_id,enr_limit,class_id) values(9,2,30,'Justin Bieber'); -- CURRENT SEC sec25
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A9','T Th 0500',25);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','R9','M F 0900',25);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S9', 'March09 W 0900', 25);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A9', 'March16 W 0800', 25);

Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values (9,2,30,'Justin Bieber', 'T Th 0500','M F 0900', '', '','March09 W 0900',  'March16 W 0800' );

-- secion 10 --> sectionid = 7
Insert into sections(sec_id,enr_limit,class_id,taught_by) values(10,5,7,'Adele'); --sec7 CURRENT SEC
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Lecture','true','false','A10','T Th 0500',7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values('Discussion','true','false','D10','W 0700',7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Lab','true','false','L10', 'T Th 0300', 7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S10', 'Feb15 M 1100', 7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Review Session','false','false','S10', 'March14 M 1100', 7);
Insert into meetings(type, weekly, mandatory, room, day_time, sec_id) values ('Final','false','true','A10', 'March15 Tu 0800', 7);



Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final)
values (10,5,7,'Adele', 'T Th 0500', 'W 0700', 'T Th 0300', 'Feb15 M 1100', 'March14 M 1100', 'March15 Tu 0800');

