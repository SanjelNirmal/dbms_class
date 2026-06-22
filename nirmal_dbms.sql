-- ==========================================
-- TASK 1: Check Current Container Database
-- ==========================================
SHOW CON_NAME;

-- ==========================================
-- TASK 2: Check Current User
-- ==========================================
SHOW USER;

-- ==========================================
-- TASK 3: Create STUDENT Table
-- Oracle does NOT support IF NOT EXISTS
-- ==========================================
create table student (
   id    number(1),
   name  varchar2(100),
   class varchar2(50)
);

-- ==========================================
-- TASK 4: Drop STUDENT Table Permanently
-- PURGE skips recycle bin
-- ==========================================
drop table student purge;

-- ==========================================
-- TASK 5: Check Table Location
-- ==========================================
select owner,
       table_name,
       tablespace_name
  from all_tables
 where table_name = 'STUDENT';

-- ==========================================
-- TASK 6: Create Tablespace CMS
-- ==========================================
create tablespace cms
   datafile 'cms01.dbf' size 100M
   autoextend on next 10M maxsize 500M;

-- ==========================================
-- TASK 7: Give User Unlimited Quota
-- ==========================================
alter user nirmal
   quota unlimited on cms;

-- ==========================================
-- TASK 8: Set Default Tablespace
-- ==========================================
alter user nirmal
   default tablespace cms
   temporary tablespace temp;

-- ==========================================
-- TASK 9: Create PERSON Table
-- Oracle does NOT support IF NOT EXISTS
-- ==========================================
create table person (
   id    number(1),
   name  varchar2(100),
   class varchar2(50)
);

-- ==========================================
-- TASK 10: Check PERSON Table Tablespace
-- ==========================================
select owner,
       table_name,
       tablespace_name
  from all_tables
 where table_name = 'PERSON';

-- ==========================================
-- TASK 11: Create STUDENT Table
-- ==========================================
create table student (
   id     number(10),
   rollno number(3),
   sname  varchar2(20),
   sem    number(1),
   branch varchar2(20),
   marks  number(3),
   pno    number(3)
);

-- ==========================================
-- TASK 12: Describe Structure
-- ==========================================
DESC STUDENT;

-- ==========================================
-- TASK 13: Insert First Record
-- Must specify BRANCH column since column list used
-- ==========================================
insert into student (
   id,
   rollno,
   sname,
   sem,
   branch,
   marks,
   pno
) values ( 1,
           31,
           'SUNITA',
           4,
           'BCA',
           40,
           121 );

-- ==========================================
-- TASK 14: Insert Records
-- Values must follow table column order:
-- ID, ROLLNO, SNAME, SEM, BRANCH, MARKS, PNO
-- ==========================================

insert into student values ( 2,
                             16,
                             'NIRMAL',
                             5,
                             'CSE',
                             50,
                             122 );

insert into student values ( 23,
                             16,
                             'NIRMAL',
                             5,
                             'CSE',
                             55,
                             122 );

insert into student values ( 233,
                             16,
                             'NIRMAL',
                             5,
                             'IT',
                             65,
                             122 );

insert into student values ( 100,
                             16,
                             'NIRMAL',
                             5,
                             'CSE',
                             50,
                             122 );

commit;
-- ==========================================
-- TASK 15: Display All Records
-- ==========================================
select *
  from student;