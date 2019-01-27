--insert values in the librarian table
Begin
insert into librarian values(201,'Mark',2345674907,'Mark@abcd.com','Mark1','qwer');
insert into librarian values(202,'Christine',2345674908,'Christine@abcd.com','Christine2','asdf');
insert into librarian values(203,'Jennifer',2345674909,'Jennifer@abcd.com','Jennifer3','zxcv');
insert into librarian values(204,'Jose',2345674910,'Jose@abcd.com','Jose4','uiop');
insert into librarian values(205,'Laura',2345674911,'Laura@abcd.com','Laura5','ghjk');
End;

select * from librarian;

--insert values in the member table
Begin
insert into member values(1001,'Alice','Student',1234569056,'Alice@abcd.com',201,'8-1-2015','5-30-2019','Active',xmltype ('<address><permanent><Street>585 Westcott Ct.</Street><City>Sacramento</City><State>CA</State><Pincode>12345</Pincode></permanent><present><Street>585 Westcott Ct.</Street><City>Robbins</City><State>CA</State><Pincode>67891</Pincode></present></address>'));
insert into member values(1002,'John','Student',1234569057,'John@abcd.com',203,'8-1-2016','5-30-2020','Active',xmltype ('<address><permanent><Street>1355 S Hines Blvd</Street><City>Gainesville</City><State>FL</State><Pincode>12346</Pincode></permanent><present><Street>357 Acacia St.</Street><City>Robbins</City><State>CA</State><Pincode>67892</Pincode></present></address>'));
insert into member values(1003,'Susan','Student',1234569058,'Susan@abcd.com',205,'1-1-2016','12-1-2020','Inactive',xmltype ('<address><permanent><Street>1545 S.W. 17th St.</Street><City>Plano</City><State>TX</State><Pincode>12347</Pincode></permanent><present><Street>267 Pepper St.</Street><City>Robbins</City><State>CA</State><Pincode>67893</Pincode></present></address>'));
insert into member values(1004,'Adam','Faculty',1234569059,'Adam@abcd.com',201,'6-1-2015','6-1-2025','Active',xmltype ('<address><permanent><Street>1900 Allard Ave.</Street><City>Albany</City><State>NY</State><Pincode>12348</Pincode></permanent><present><Street>902 Ainsdale Dr.</Street><City>Robbins</City><State>CA</State><Pincode>67894</Pincode></present></address>'));
insert into member values(1005,'Finn','Faculty',1234569060,'Finn@abcd.com',202,'1-1-2012','12-31-2022','Active',xmltype ('<address><permanent><Street>1925 Beltline Rd.</Street><City>Carteret</City><State>NJ</State><Pincode>12349</Pincode></permanent><present><Street>195 Beckett Dr.</Street><City>Robbins</City><State>CA</State><Pincode>67895</Pincode></present></address>'));
insert into member values(1006,'Elizabeth','Student',1234569061,'Elizabeth@abcd.com',205,'8-15-2017','6-15-2021','Active',xmltype ('<address><permanent><Street>5585 Westcott Ct.</Street><City>Sacramento</City><State>CA</State><Pincode>12350</Pincode></permanent><present><Street>285 Warm Springs Dr.</Street><City>Robbins</City><State>CA</State><Pincode>67896</Pincode></present></address>'));
insert into member values(1007,'Robert','Faculty',1234569062,'Robert@abcd.com',202,'1-2-2014','12-31-2024','Inactive',xmltype ('<address><permanent><Street>325 Flatiron Dr.</Street><City>Boulder</City><State>CO</State><Pincode>12351</Pincode></permanent><present><Street>748 Oak St.</Street><City>Robbins</City><State>CA</State><Pincode>67897</Pincode></present></address>'));
insert into member values(1008,'Jack','Student',1234569063,'Jack@abcd.com',204,'8-1-2015','6-30-2019','Active',xmltype ('<address><permanent><Street>394 Rainbow Dr.</Street><City>Seattle</City><State>WA</State><Pincode>12352</Pincode></permanent><present><Street>936 Beckett Dr.</Street><City>Robbins</City><State>CA</State><Pincode>67898</Pincode></present></address>'));
insert into member values(1009,'Taylor','Faculty',1234569064,'Taylor@abcd.com',201,'1-5-2014','12-1-2024','Active',xmltype ('<address><permanent><Street>816 Peach Rd.</Street><City>Santa Clara</City><State>CA</State><Pincode>12353</Pincode></permanent><present><Street>306 Ainsdale Dr.</Street><City>Robbins</City><State>CA</State><Pincode>67899</Pincode></present></address>'));
insert into member values(1010,'Nancy','Faculty',1234569065,'Nancy@abcd.com',203,'7-10-2012','6-1-2022','Active',xmltype ('<address><permanent><Street>6679 College Ave.</Street><City>Carlisle</City><State>PA</State><Pincode>12354</Pincode></permanent><present><Street>293 Acacia St.</Street><City>Robbins</City><State>CA</State><Pincode>67900</Pincode></present></address>'));
End;

select * from member;

--insert values in the student table
Begin
insert into student values(50121,1001,3);
insert into student values(50122,1002,4);
insert into student values(50123,1003,7);
insert into student values(50124,1006,1);
insert into student values(50125,1008,4);
End;

select * from student;

--insert values in the faculty table
Begin
insert into faculty values(401,1004,'Professor');
insert into faculty values(402,1005,'Associate Professor');
insert into faculty values(403,1007,'Professor');
insert into faculty values(404,1009,'Assistant Professor');
insert into faculty values(405,1010,'Associate Professor');
End;

select * from faculty;

--insert values in the category table
Begin
insert into category values (101,'Engineering');
insert into category values (102,'Business');
insert into category values (103,'Arts');
insert into category values (104,'Religious');
insert into category values (105,'Novel');
insert into category values (106,'General Knowledge');
End;

select * from category;

--insert values in the section table
Begin
insert into section values (201,'Reference');
insert into section values (202,'Fiction');
insert into section values (203,'Non fiction');
insert into section values (204,'Magazine');
insert into section values (205,'Reserved');
End;

select * from section;

--insert values in the section_category table
Begin
insert into section_category values (701,201,101);
insert into section_category values (702,205,101);
insert into section_category values (703,202,105);
insert into section_category values (704,201,102);
insert into section_category values (705,205,106);
insert into section_category values (706,204,102);
End;

select * from section_category;

--insert values in the language table
Begin
insert into language values (301,'English');
insert into language values (302,'Spanish');
insert into language values (303,'French');
insert into language values (304,'German');
insert into language values (305,'Sanskrit');
End;

select * from language;

--insert values in the publisher table
Begin
insert into publisher values (401,'Wadsworth','California');
insert into publisher values (402,'Mc-Graw Hill','New York');
insert into publisher values (403,'Egmont Books Ltd','Denmark');
insert into publisher values (404,'Prentice Hall PTR','New Jersey');
insert into publisher values (405,'Nabu Press','South Carolina');
End;

select * from publisher;

--insert values in the author table
Begin
insert into author values (801,'','Anderson');
insert into author values (802,'Paul','V');
insert into author values (803,'','Alexander');
insert into author values (804,'Charles ','K');
insert into author values (805,'Mathew','N.O');
insert into author values (806,'Antoine De','Saint-Exupery');
insert into author values (807,'','Meyers');
insert into author values (808,'Fred','E');
insert into author values (809,'Jim','R');
insert into author values (810,'','Anonymous');
End;

select * from author;

--insert values in the books table
Begin
insert into books values (1001,'Technical Communication','9781133309819',8,301,401,701,to_date('03/19/2013'),to_date('11/20/2017'),10,author_id_array(801,802),150.5);
insert into books values (1002,'Fundamentals of Electric Circuits','9780073380575',5,301,402,701,to_date('1/12/2012'),to_date('1/30/2017'),8,author_id_array(803,804,805),120);
insert into books values (1003,'The Little Prince','9780749707231',1,303,403,703,to_date('01/01/1991'),to_date('5/15/2016'),5,author_id_array(806),75);
insert into books values (1004,'Motion and Time Study for Lean Manufacturing','9780130316707',3,301,404,704,to_date('05/22/2001'),to_date('10/14/2010'),3,author_id_array(807,808,809),250);
insert into books values (1005,'The Sanskrit Reader','978-1279182253',1,305,405,705,to_date('03/12/2012'),to_date('03/01/2018'),2,author_id_array(810),95);
insert into books values (1006,'The Toyota Way','B000EUMM3O',1,301,402,706,to_date('06/05/2016'),to_date('03/01/2018'),2,author_id_array(811),64);
End;

select * from books;

--insert values in the ebooks table
Begin
insert into ebooks values (10,1001,'pdf');
insert into ebooks values (20,1002,'pdf');
insert into ebooks values (30,1002,'doc');
insert into ebooks values (40,1004,'pdf');
insert into ebooks values (50,1004,'png');
End;

select * from ebooks;

