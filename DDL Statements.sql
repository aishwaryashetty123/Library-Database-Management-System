--Create the tables

create table publisher(publisher_id integer, publisher_name varchar(20) not null, location varchar(50), primary key (publisher_id));

create table category(category_id integer, category_name varchar(20) not null, primary key(category_id));

create table section(section_id integer, section_name varchar(20) not null, primary key(section_id));

create table section_category(sc_id integer, section_id integer not null,category_id integer not null,primary key(sc_id),foreign key(section_id) references section(section_id), foreign key(category_id) references category(category_id));

create table author(author_id integer, first_name varchar(20), last_name varchar(20) not null, primary key(author_id));

create table librarian(librarian_id integer, librarian_name varchar(20) not null, phone_no integer, email varchar(50), username varchar(50) not null, password varchar(50) not null, primary key (librarian_id));

create table language(language_id integer, language varchar(20) not null, primary key(language_id));

create table member(member_id integer, member_name varchar(50) not null, member_type varchar(20) not null, phone_no integer, email varchar(50),  created_by integer not null, created_on date, expiry_date date, membership_status varchar(10), address xmltype, primary key(member_id), foreign key(created_by) references librarian(librarian_id));

create table student(student_id integer, member_id integer not null, semester integer, primary key(student_id), foreign key(member_id) references member(member_id));

create table faculty(faculty_id integer, member_id integer not null, designation varchar(30), primary key(faculty_id), foreign key(member_id) references member(member_id));

create or replace type author_id_array as varray(5) of integer;

create table books(book_id integer, title varchar(50) not null, isbn varchar(50) not null, edition integer not null, language_id integer not null, publisher_id integer not null, sc_id integer not null, publication_date date, date_of_purchase date, no_of_copies integer, author_ids author_id_array not null, cost number(6,2) not null, primary key(book_id), foreign key(language_id) references language(language_id), foreign key(publisher_id) references publisher(publisher_id), foreign key(sc_id) references section_category(sc_id));

create table ebooks(ebook_id integer, book_id integer not null, extension varchar(20), primary key(ebook_id), foreign key(book_id) references books(book_id));

create table copies(copy_id integer, book_id integer not null, status varchar(20), primary key(copy_id), foreign key(book_id) references books(book_id));

create table borrow_transaction(borrow_transaction_id integer, librarian_id integer not null, member_id integer not null, copy_id integer not null, borrow_date date not null, return_date date, due_date date not null, primary key(borrow_transaction_id), foreign key(librarian_id) references librarian(librarian_id), foreign key(member_id) references member(member_id), foreign key(copy_id) references copies(copy_id));

create table fine_transaction(fine_transaction_id integer, borrow_transaction_id integer not null, fine_amount integer not null, is_settled varchar(10),primary key(fine_transaction_id), foreign key(borrow_transaction_id) references borrow_transaction(borrow_transaction_id));

--create sequences for borrow and fine transaction IDs
create sequence borrow_seq start with 12000 increment by 1;

create sequence fine_seq start with 1200 increment by 1;
