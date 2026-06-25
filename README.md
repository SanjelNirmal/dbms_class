**Lab_Manual:_Oracle_Database_Setup_&_Connection_Guide**

**Course:** Database Management Systems (DBMS)  
**Environment:** Docker + Oracle Free Database + Graphical Client (DBeaver / SQL Developer)

---

# Part 1: Container Architecture & User Provisioning

## Step 1: Spin Up the Database Container

Initialize your database service background process using Docker Compose. Ensure your Docker Desktop daemon application is actively running before executing this command in your repository terminal.

```bash
docker compose up -d
```

Expected Output:

Plaintext
[+] up 1/1
✔ Container oracle-db Started

## Step 2: Access the SQL\*Plus Interactive Shell

Execute an interactive terminal environment inside your running container to launch the SQL\*Plus utility with System Administrator (SYSDBA) privileges. Utilizing the local OS-authentication shortcut bypasses login credentials checks:

```bash
docker exec -it oracle-db sqlplus / as sysdba
```

Alternative Prompt Approach: If you choose to connect manually by executing docker exec -it oracle-db sqlplus, fill out the data fields carefully:

```bash
Enter user-name: sys as sysdba

Enter password: admin
```

(Note: Password input characters are hidden when typing)

## Step 3: Inspect Pluggable Databases (PDBs)

Oracle utilizes a Multitenant Architecture consisting of a root Container Database (CDB$ROOT) and separate isolated Pluggable Databases (PDBs). Query the v$pdbs data dictionary table view to list active operational spaces:

SQL

```bash
SQL> SELECT name, open_mode, restricted FROM v$pdbs;
```

Expected Output:

Plaintext
NAME OPEN_MODE RES

---

PDB$SEED READ ONLY NO
FREEPDB1 READ WRITE NO
💡 Core Concept: FREEPDB1 is the main read/write pluggable instance workspace. All application schemas, course assignments, and user tables must be located within this instance rather than the system root.

## Step 4: Shift Session Context to the Target PDB

Upon initial system admin login, your current session defaults to the central container manager layer. Point your active connection path over to the FREEPDB1 container database before creating user profiles:

SQL

```bash
SQL> ALTER SESSION SET CONTAINER = FREEPDB1;
```

Expected Output:

Plaintext
Session altered.

## Step 5: Provision a New Database User

Instantiate your permanent designated schema identity workspace. Here, we create an account explicitly named student secured with the password credential string 123.

SQL

```bash
SQL> CREATE USER student IDENTIFIED BY 123;
```

Expected Output:

Plaintext
User created.

## Step 6: Grant Administrative Roles and Permissions

Newly instantiated schemas contain zero login or structural rights by default. Assign the comprehensive Database Administrator (DBA) role to give your student user complete authority to establish remote connections and build relational schema structures:

SQL

```bash
SQL> GRANT DBA TO student;
```

Expected Output:

Plaintext
Grant succeeded.

# Part 2: Configuring Graphical Client Connections (GUI)

Once your custom student profile workspace has been officially declared and provisioned inside FREEPDB1, you can exit the command terminal and connect through a desktop client wrapper interface.

## Step 7: Launch Graphical Database Manager

Open Finder on your local machine system framework.

Locate and launch your installed graphical desktop client suite (such as DBeaver or Oracle SQL Developer).

Step 8: Initialize a New Connection Instance
Click the New Database Connection toggle icon (typically represented by a Network Plug icon or found via File > New).

Choose Oracle from your relational options menu wizard, then select Next.

Step 9: Configure Connection Parameters
Carefully fill out the configuration dashboard panel details exactly as laid out below:

🔹 General Identity Info

```bash
Connection Name: STUDENT DB

Database Type: Oracle

Authentication Type: Default

Username: student

Password: 123 (Check the Save Password checkbox option)
```

🔹 Network Parameters

```bash
Connection Type: Basic

Hostname: localhost

Port: 1521

Configuration Target Type: Switch the selector radio button from SID over to Service name \* Service name: FREEPDB1
```

Step 10: Validation and Connection Instantiation
Locate the Test Connection action link element inside the lower-left corner region of the wizard dialog frame.

Click Test.

Once the validation feedback dialog reports a successful network status confirmation message, click OK, followed by Connect / Finish.

# FILL THE DATA IN STUDENT.sql

```sql

show con_name;

show user;

CREATE TABLE IF NOT EXISTS STUDENT (
  ID NUMBER(1),
  Name VARCHAR2(100),
  class VARCHAR2(50)
);

DROP TABLE student PURGE;

SELECT owner, table_name, tablespace_name FROM all_tables WHERE table_name = 'STUDENT';

CREATE TABLESPACE cms
DATAFILE 'cms01.dbf'
SIZE 100M
AUTOEXTEND ON
NEXT 10M
MAXSIZE 500M;

ALTER USER NIRMAL QUOTA UNLIMITED ON cms;

ALTER USER NIRMAL
DEFAULT TABLESPACE cms
TEMPORARY TABLESPACE temp; 

CREATE TABLE IF NOT EXISTS PERSON (
  ID NUMBER(1),
  Name VARCHAR2(100),
  class VARCHAR2(50)
);

SELECT owner, table_name, tablespace_name FROM all_tables WHERE table_name = 'PERSON';

```


## ALL SQL 

```sql
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
-- ==========================================
CREATE TABLE STUDENT (
    ID NUMBER(10),
    NAME VARCHAR2(100),
    CLASS VARCHAR2(50)
);

-- ==========================================
-- TASK 4: Check Table Location
-- ==========================================
SELECT OWNER,
       TABLE_NAME,
       TABLESPACE_NAME
FROM ALL_TABLES
WHERE TABLE_NAME = 'STUDENT';

-- ==========================================
-- TASK 5: Drop STUDENT Table Permanently
-- ==========================================
DROP TABLE STUDENT PURGE;

-- ==========================================
-- TASK 6: Create PERSON Table
-- ==========================================
CREATE TABLE PERSON (
    ID NUMBER(10),
    NAME VARCHAR2(100),
    CLASS VARCHAR2(50)
);

-- ==========================================
-- TASK 7: Check PERSON Table Tablespace
-- ==========================================
SELECT OWNER,
       TABLE_NAME,
       TABLESPACE_NAME
FROM ALL_TABLES
WHERE TABLE_NAME = 'PERSON';

-- ==========================================
-- TASK 8: Create STUDENT Table
-- ==========================================
CREATE TABLE STUDENT (
    ID NUMBER(10),
    ROLLNO NUMBER(3),
    SNAME VARCHAR2(20),
    SEM NUMBER(1),
    BRANCH VARCHAR2(20),
    MARKS NUMBER(3),
    PNO NUMBER(3)
);

-- ==========================================
-- TASK 9: Describe Structure
-- ==========================================
DESC STUDENT;

-- ==========================================
-- TASK 10: Insert Records
-- ==========================================
INSERT INTO STUDENT
VALUES (1, 31, 'SUNITA', 4, 'BCA', 40, 121);

INSERT INTO STUDENT
VALUES (2, 16, 'NIRMAL', 5, 'CSE', 50, 122);

INSERT INTO STUDENT
VALUES (23, 16, 'NIRMAL', 5, 'CSE', 55, 122);

INSERT INTO STUDENT
VALUES (233, 16, 'NIRMAL', 5, 'IT', 65, 122);

INSERT INTO STUDENT
VALUES (100, 16, 'NIRMAL', 5, 'CSE', 50, 122);

COMMIT;

-- ==========================================
-- TASK 11: Display All Records
-- ==========================================
SELECT * FROM STUDENT;

-- ==========================================
-- TASK 12: Drop Table
-- ==========================================
DROP TABLE STUDENT PURGE;

-- ==========================================
-- TASK 13: Create STUDENT with Constraints
-- ==========================================
CREATE TABLE STUDENT (
    RollNo NUMBER(3)
        CONSTRAINT pk_student PRIMARY KEY,

    Name VARCHAR2(20)
        CONSTRAINT nn_student_name NOT NULL,

    Email VARCHAR2(50)
        CONSTRAINT uq_student_email UNIQUE,

    Marks NUMBER(3)
        CONSTRAINT ck_student_marks
        CHECK (Marks >= 0)
);

-- ==========================================
-- TASK 14: Describe Table
-- ==========================================
DESC STUDENT;

-- ==========================================
-- TASK 15: Insert Records
-- ==========================================
INSERT INTO STUDENT
VALUES (101, 'Aarav', 'aarav@example.com', 85);

INSERT INTO STUDENT
VALUES (102, 'Priya', 'priya@example.com', 92);

INSERT INTO STUDENT
VALUES (103, 'Rohan', 'rohan@example.com', 78);

INSERT INTO STUDENT
VALUES (104, 'Sneha', 'sneha@example.com', 88);

INSERT INTO STUDENT
VALUES (105, 'Vikram', 'vikram@example.com', 95);

COMMIT;

-- ==========================================
-- TASK 16: Display Records
-- ==========================================
SELECT * FROM STUDENT;


-- ==========================================
-- TASK 17: Create Backup Table Using CTAS
-- CTAS = Create Table As Select
-- ==========================================
CREATE TABLE NEW_TABLE_STUDENT AS
SELECT * FROM STUDENT;

-- ==========================================
-- TASK 18: Display Backup Table Records
-- ==========================================
SELECT * FROM NEW_TABLE_STUDENT;

COMMIT;


```