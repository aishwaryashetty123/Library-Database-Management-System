--FEATURES

--FEATURE 1
--insert values in the copies table
--Auto populate the copies table indicating all book copies are available
declare
cid integer:=501; --integer variable
cursor c is select book_id, no_of_copies from books; --explicit cursor to get number of copies for each book
copies integer;
status varchar(20):='Available'; --set the initial status to Available
begin
for row in c --loop for each record pointed by cursor
loop
 copies:=row.no_of_copies; 
 for i in 1..copies
 loop
   execute immediate 'insert into copies values(:p1,:p2,:p3)' using cid,row.book_id,status; --insert Available status for each body copy into the copies table
   cid:=cid+1; --increment the primary key for copies
 end loop;
end loop;
end;

select * from copies;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 2
--create a trigger to insert values into fine_transaction when the borrowed book is returned after the due date
create or replace trigger fine_trigger
after update on borrow_transaction
for each row when (new.return_date > old.due_date and old.return_date is NULL) --check if return date has exceeded due date
begin
insert into fine_transaction values (fine_seq.nextval, :new.borrow_transaction_id, (:new.return_date - :old.due_date)*2 , 'No'); --fine=2*number of days exceeded
end;

--create a trigger to update the book copy status whenever a borrow transaction is made
create or replace trigger book_status_trigger
after insert or update on borrow_transaction
for each row 
begin
if :new.return_date is not null then --when the book is returned
 update copies set status='Available' where copy_id=:new.copy_id;
elsif :old.return_date is null then --when the book is borrowed
 update copies set status='Borrowed' where copy_id=:new.copy_id;
end if;
End;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 3
--insert values into borrow transaction ensuring that a book copy is available and a reserved book is taken only by a faculty

--function to get the first book copy that is available
--parameter: book ID
create or replace function get_copy_id (b_id in number) return number
is c_id number;
begin
select min(copy_id) into c_id from copies where book_id=b_id and status='Available'; --implicit cursor to get the first available copy
if c_id is not null then
return c_id; --return the copy ID
else
return 0;
end if;
exception
when no_data_found then --exception handler when no data is found in cursor
return 0; 
end;
 
--function to check if the book copy is reserved or not
--parameter: copy ID
create or replace function is_reserved (c_id in number) return number
is s_name varchar(50);
begin
select s.section_name into s_name from section s inner join section_category sc on s.section_id=sc.section_id
                                                 inner join books b on b.sc_id=sc.sc_id 
                                                 inner join copies c on c.book_id=b.book_id where c.copy_id=c_id;
--implicit cursor to get the section name for the given book copy
if s_name='Reserved' then --return 1 if the book copy is reserved
return 1;
else
return -1;
end if;
exception
when no_data_found then --exception handler when no data is found in cursor
return -1;
when too_many_rows then --exception handler when the query returns many rows
return -1; 
end;
 
--function to check if the member is faculty
--parameter: member ID
create or replace function is_faculty (m_id in number) return number
is f_id number;
begin
select faculty_id into f_id from faculty where member_id=m_id;
return 1; --return 1 if member is a faculty
Exception
when no_data_found then
return -1;
end;

--define a procedure to insert values into borrow_transaction table
--parameters: librarian ID, member ID, book ID, borrow date
create or replace procedure insert_into_borrow(lib_id in integer,mem_id in integer,b_id in integer,bor_date in date)
is c_id integer;
begin
c_id:=get_copy_id(b_id);
if c_id=0 then --when all copies of the book are borrowed
 dbms_output.put_line('Book unavailable');
else --when a copy is available
 if is_reserved(c_id)=1 then
  if is_faculty(mem_id)=1 then --when a reserved book is borrowed by a faculty
  insert into borrow_transaction values(borrow_seq.nextval,lib_id,mem_id,c_id,bor_date,null,bor_date+7);
    else --don't allow a student to borrow a reserved book
  dbms_output.put_line('Book ID '||b_id||' is reserved book');
  end if;
 else --when book is not reserved
 insert into borrow_transaction values(borrow_seq.nextval,lib_id,mem_id,c_id,bor_date,null,bor_date+7);
 end if;
end if;
end;

--anonymous procedure to insert values into borrow_transaction by calling the insert_into_borrow procedure
Begin
insert_into_borrow(202,1002,1001,'11-13-2018');
insert_into_borrow(205,1008,1003,'11-17-2018');
insert_into_borrow(201,1001,1005,'11-18-2018');
insert_into_borrow(201,1004,1005,'11-18-2018');
insert_into_borrow(201,1005,1002,'11-18-2018');
insert_into_borrow(202,1007,1004,'11-20-2018');
insert_into_borrow(204,1006,1002,'11-18-2018');
insert_into_borrow(202,1003,1006,'11-20-2018');
insert_into_borrow(203,1009,1006,'11-25-2018');
End;

Begin
insert_into_borrow(203,1010,1006,'11-26-2018');
end;

--anonymous procedure to update the borrow_transaction table by adding return dates for few books
--trigger fine_trigger is fired whenever return date exceeds the due date and a new record is added to the fine_transaction table
--trigger book_status_trigger is fired to change the status of the book copy
begin
update borrow_transaction set return_date='11-30-2018' where borrow_transaction_id=12000;
update borrow_transaction set return_date='12-03-2018' where borrow_transaction_id=12001;
update borrow_transaction set return_date='12-12-2018' where borrow_transaction_id=12002;
update borrow_transaction set return_date='12-01-2018' where borrow_transaction_id=12003;
update borrow_transaction set return_date='11-24-2018' where borrow_transaction_id=12004;
end;

select * from borrow_transaction;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 4
--get the list of members who haven't returned a borrowed book
create or replace procedure not_returned is
cursor c1 is select m.member_id, m.member_name from borrow_transaction b, member m where b.member_id=m.member_id and b.return_date is null;
--explicit cursor to get member details who have return date as null
r c1%rowtype; --cursor row type variable
begin
open c1; --open cursor
loop
fetch c1 into r;
exit when c1%notfound; --exit condition
dbms_output.put_line('Member ID: '||r.member_id||', Member name: '||r.member_name);
end loop;
close c1; --close cursor
end;
 
--anonymous procedure to call the procedure
begin
not_returned;
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 5
--get all books that have been borrowed by a particular member
--parameter: member id
create or replace procedure books_borrowed(m_id in integer) is
cursor c1 is select b.title from borrow_transaction t inner join copies c on t.copy_id=c.copy_id inner join books b on c.book_id=b.book_id where t.member_id=m_id;
--cursor to hold book titles that have been borrowed by a member
b_title books.title%type; --column type variable
begin
open c1; --open cursor
loop
fetch c1 into b_title;
exit when c1%notfound; --exit condition
dbms_output.put_line('Book title: '||b_title);
end loop;
close c1; --close cursor
end;
 
--anonymous procedure to call the procedure
begin
books_borrowed(1008);
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 6
--get the list of members with pending fines
create or replace procedure fines_pending is
cursor c1 is select distinct m.member_id, m.member_name from fine_transaction f inner join borrow_transaction b on f.borrow_transaction_id=b.borrow_transaction_id inner join member m on b.member_id=m.member_id where f.is_settled='No';
--explicit cursor to hold member names with pending fines
r c1%rowtype;
begin
open c1; --open cursor
loop
fetch c1 into r;
exit when c1%notfound; --exit condition
dbms_output.put_line('Member ID: '||r.member_id||', Member name: '||r.member_name);
end loop;
close c1; --close cursor
end;
 
--anonymous procedure to call the procedure
begin
fines_pending;
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 7
--check if a member has any pending fines
--parameter: member ID
create or replace procedure if_fine (m_id in integer) is
cursor c1 is select fine_amount from fine_transaction f inner join borrow_transaction b on f.borrow_transaction_id=b.borrow_transaction_id where member_id = m_id and is_settled='No';
--get the fine amount that hasn't been settled for a particular member
fines integer;
sum1 integer;
begin
sum1:=0;
open c1; --open cursor
loop
fetch c1 into fines;
exit when c1%notfound; --exit condition
sum1:=sum1+fines; --calculate the total fine
end loop;
close c1; --close cursor
dbms_output.put_line('Pending fine: '||sum1);
end;

--anonymous procedure to call the procedure
begin
if_fine(1002);
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 8
--get the list of members living in a particular state
--parameter: state name
create or replace procedure member_state(m_state in varchar) is
cursor c1 is select m.member_id, m.member_name from member m where (m.address.extract('/address/permanent/State/text()').getStringVal())=m_state;
--use xpath to extract the state names from the address field
r c1%rowtype; --row type variable
begin
dbms_output.put_line('Members from '||m_state||':');
dbms_output.new_line;
open c1; --open cursor
loop
fetch c1 into r;
exit when c1%notfound; --exit condition
dbms_output.put_line('Member ID: '||r.member_id||', Member name: '||r.member_name);
end loop;
close c1; --close cursor
end;

--anonymous procedure to call the procedure
begin
member_state('CA');
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 9
--get books bought in a particular year
--parameter: year
create or replace procedure books_bought(b_year in integer) is
cursor c1 is select b.title from books b where extract(year from date_of_purchase)=b_year;
--explicit cursor holding book titles bought in the particular year
b_title books.title%type;
begin
dbms_output.put_line('Books bought in '||b_year||':');
dbms_output.new_line;
open c1; --open cursor
loop
fetch c1 into b_title;
exit when c1%notfound; --exit condition
dbms_output.put_line(b_title);
end loop; 
close c1; --close cursor
end;

--anonymous procedure to call the procedure
begin
books_bought(2017);
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 10
--get the total cost of books in each section_category 
create or replace procedure total_section_cost as
cursor cs is select b.title,s.section_name,sum(b.cost) over(partition by s.section_id) total
from books b JOIN section_category sc on b.sc_id=sc.sc_id
             JOIN section s on sc.section_id=s.section_id;
			 --use of window function to display the total cost for each section
begin
 for rec in cs --loop over each record pointed by the cursor
 loop
  dbms_output.put_line('Section: '||rec.section_name||', Book Title: '||rec.title||', Total Cost: '||rec.total);
 end loop;
end;

--anonymous procedure to call the procedure
begin
 total_section_cost;
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 11
--get the ebook extension for a particular book
--parameter: book ID
create or replace procedure get_ebooks(bid integer) as
cursor cs is select b.title,extension from ebooks e JOIN books b on b.book_id=e.book_id where e.book_id=bid;
--explicit cursor to get the ebook extension
title books.title%type; --column type variable
ext ebooks.extension%type;
begin
 open cs; --open cursor
 loop
 fetch cs into title,ext;
  exit when cs%NOTFOUND; --exit condition
  dbms_output.put_line('Extension: '||ext);
 end loop;
 if cs%ROWCOUNT<=0 then --when no ebooks are available
   dbms_output.put_line('No ebooks available for book id '||bid);
 else
   dbms_output.put_line('Title: '||title);
 end if;
 close cs; --close cursor
end;

--anonymous procedure to call the procedure
begin
get_ebooks(1001);
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 12
--get the book details that is published by the same publisher of a given book
--parameter: book name
create or replace procedure get_same_publisher_book(bname in varchar) as
cursor cs is select b2.book_id, b2.title, b2.isbn, publisher.publisher_name 
from books b1, books b2 join publisher on b2.publisher_id=publisher.publisher_id
where b1.publisher_id=b2.publisher_id and b1.title=bname;
--explicit cursor to get the books published by publisher of a particular book
bid books.book_id%type;
title books.title%type; --column type variables
isbn books.isbn%type;
pname publisher.publisher_name%type;
begin
open cs; -- open cursor
loop
fetch cs into bid,title,isbn,pname; -- fetch
exit when cs%NOTFOUND; --- exit check
dbms_output.put_line('Book ID: '||bid||', Book Title: '||title||', ISBN: '||isbn||', Publisher name: '||pname);
end loop;
close cs; --close cursor
end;

--anonymous procedure to call the procedure
begin
get_same_publisher_book('The Toyota Way');
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 13
--get all the book details for a given book ID

--function to return the name of the author for a given author ID
--parameter: author ID
create or replace function get_author_name(authorid integer) return varchar as
 lname author.last_name%type;
 fname author.first_name%type;
 name varchar(30);
begin
 select first_name,last_name into fname,lname from author where author_id=authorid;
  --implicit cursor to get the names of the author
 if fname is null then --if there is no first name
  name:=lname;
 else
  name:=fname||' '||lname; --concatenate first and last name
 end if;
 return name;
exception --exception handlers when no data is found or too many rows are returned by the query
 when no_data_found then
   return 'No authors';
 when too_many_rows then
   return 'SQL error';
end;

--procedure to fetch all the book details for a given book ID
--parameter: book ID
create or replace procedure get_book_details(bookid integer) as
cursor cs is select b.book_id, b.title, b.author_ids, l.language, s.section_name, c.category_name
from books b JOIN section_category sc on b.sc_id=sc.sc_id
     JOIN section s on s.section_id=sc.section_id
     JOIN category c on c.category_id=sc.category_id
     JOIN language l on l.language_id=b.language_id
where b.book_id=bookid;
--explicit cursor holding the book details
authors author_id_array; --varray type variable
begin
for rec in cs --for each record pointed by the cursor
loop
dbms_output.put_line('Book ID: '||rec.book_id); --display the details
dbms_output.put_line('Title: '||rec.title);
if rec.author_ids is not null then
authors:=rec.author_ids;
for i in 1..authors.count --iterate through the varray for the author names
loop
dbms_output.put_line('Author '||i||': '||get_author_name(authors(i))) ;
end loop;
end if;
dbms_output.put_line('Language: '||rec.language);
dbms_output.put_line('Section: '||rec.section_name);
dbms_output.put_line('Category: '||rec.category_name);
dbms_output.put_line('');
end loop;
end;

--anonymous procedure to call the procedure
begin
get_book_details(1004);
end;
	
	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 14
--get the book details that have atmost 5 available copies
--parameter: number of copies
create or replace procedure get_available_books(cop integer) as
cursor cs is select book_id, count(status) cnt
              from copies where status='Available' group by book_id having count(*)<=5;
			  --explicit cursor to get the count of books that have <= cop copies
begin
 for rec in cs --for each record pointed by the cursor
 loop
  dbms_output.put_line('Available copies: '||rec.cnt);
  get_book_details(rec.book_id); --call to procedure implemented in feature 13
 end loop;
end;

--anonymous procedure to call the procedure
begin
get_available_books(5);
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FEATURE 15
--assign rank to each book based on the number of times it has been borrowed
create or replace procedure rank_book_copy as
cursor cs is select b.book_id, b.title, c.copy_id, copycount, dense_rank() over(order by copycount desc) rank
             from (select copy_id cid,count(*) copycount from borrow_transaction group by copy_id)
                   JOIN copies c on cid=c.copy_id
                   JOIN books b on b.book_id=c.book_id; 
				   --rank window function to assign ranks to the book copies based on the borrow frequency
begin
 for rec in cs --for each record pointed by the cursor
 loop
   dbms_output.put_line('RANK: '||rec.rank); --display rank
   dbms_output.put_line('Book ID: '||rec.book_id);
   dbms_output.put_line('Title: '||rec.title);
   dbms_output.put_line('Copy ID: '||rec.copy_id);
   dbms_output.put_line('Borrowed count: '||rec.copycount);
   dbms_output.put_line('');
 end loop;
end;

--anonymous procedure to call the procedure
begin
insert_into_borrow(202,1002,1001,'11-13-2018'); --insert values to borrow_transaction to demonstrate this feature
rank_book_copy;
end;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


