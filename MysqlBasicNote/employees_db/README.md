SAMPLE EMPLOYEE DATABASE 
Copyright (C) 2007,2008, MySQL AB
==================================

This is a sample database for testing purposes.

The original data was created by Fusheng Wang and Carlo Zaniolo at 
Siemens Corporate Research. The data is in XML format.
http://www.cs.aau.dk/TimeCenter/software.htm
http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip

Giuseppe Maxia made the relational schema and Patrick Crews exported
the data in relational format.

The database contains about 300,000 employee records with 2.8 million 
salary entries. The export data is 167 MB, which is not huge, but
heavy enough to be non-trivial for testing.

The data was generated, and as such there are inconsistencies and subtle
problems. Rather than removing them, we decided to leave the contents
untouched, and use these issues as data cleaning exercises.

USAGE
=====

To install the database, get the archive

* employees_VERSION.tar.bz2, using a flexible loader, with 
  a SQL schema that can be modified easily for usage with a different
  engine (MyISAM, Falcon, PBXT) and contains a *test unit*.
  This version can be loaded with MySQL 4.1 or newer.

  $ bunzip2 employees_VERSION.tar.bz2
  $ cd employees_VERSION 
  $ mysql -t < employees.sql
  
  If something goes wrong, you can inspect the proceedings using
  the verbose output
  $ mysql -v -v -v -t < employees.sql

  The test unit is included in the package (choose between MD5 and SHA)

  $ mysql -t < test_employees_md5.sql
  $ mysql -t < test_employees_sha.sql

If you get the project code from the source tree, you should also download the dump files
from http://launchpad.net/test-db.  

LICENSE
=======
This work is licensed under the 
Creative Commons Attribution-Share Alike 3.0 Unported License. 
To view a copy of this license, visit 
http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
Creative Commons, 171 Second Street, Suite 300, San Francisco, 
California, 94105, USA.

DISCLAIMER
===========
To the best of our knowledge, this data is fabricated, and
it does not correspond to real people. 
Any similarity to existing people is purely coincidental.

BUGS
====

Please report bugs to community@mysql.com

