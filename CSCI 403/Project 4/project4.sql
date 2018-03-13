 CSCI 403
1.
select count(*) from hogwarts_students where house='Slytherin';
27
2.
select min(start) from hogwarts_students;
1892
3.
select count(*) from hogwarts_students where finish is null or start is null or house is null or first is null or last is null
50
4.select count(*) from hogwarts_students where finish is  not null and start is not null and house is not null and first is not null and last is not null;
60
5.
select house, count(*) from hogwarts_students group by house order by count desc;
house	count
Gryffindor	46
Slytherin	27
Ravenclaw	18
Hufflepuff	14
<null>	5
6.
select first,last, start from hogwarts_students where start=(select min(start) from hogwarts_students);
first	last	start
Albus	Dumbledore	1,892
7.
select house,count(*) from hogwarts_students where start=(select start from hogwarts_dada where first='Alastor') group by house;
house	count
Ravenclaw	2
<null>	1
Slytherin	2
Hufflepuff	4
Gryffindor	2
8.
Select students.first,students.last,students.house,houses.colors from hogwarts_students as students, hogwarts_dada as dada, hogwarts_houses as houses
where students.first=dada.first and students.house=houses.house; 
first	last	house	colors
Remus	Lupin	Gryffindor	Red and Gold
Severus	Snape	Slytherin	Green and Silver
9.very exhaustive search for all periods
select first, last,start,finish from hogwarts_students where house='Gryffindor' and(
(start<(select start from hogwarts_dada where first='Gilderoy') and finish>(select start from hogwarts_dada where first='Gilderoy')) or
(start<(select start from hogwarts_dada where first='Gilderoy') and finish>(select finish from hogwarts_dada where first='Gilderoy')) or
(start<(select finish from hogwarts_dada where first='Gilderoy') and finish>(select finish from hogwarts_dada where first='Gilderoy')) or
(start=(select start from hogwarts_dada where first='Gilderoy'))or
(finish=(select finish from hogwarts_dada where first='Gilderoy')) or 
(start>(select start from hogwarts_dada where first='Gilderoy') and finish<(select finish from hogwarts_dada where first='Gilderoy'))or
(start>(select start from hogwarts_dada where first='Gilderoy') and start<(select finish from hogwarts_dada where first='Gilderoy'))) order by start desc;
first	last	start	finish
Ginny	Weasley	1,992	1,999
Colin	Creevey	1,992	1,997
Seamus	Finnigan	1,991	1,998
Hermione	Granger	1,991	1,997
Ronald	Weasley	1,991	1,997
Neville	Longbottom	1,991	1,998
Parvati	Patil	1,991	1,998
Dean	Thomas	1,991	1,997
Harry	Potter	1,991	1,997
Lavender	Brown	1,991	1,998
Katie	Bell	1,990	1,997
Fred	Weasley	1,989	1,996
George	Weasley	1,989	1,996
Lee	Jordan	1,989	1,996
Angelina	Johnson	1,989	1,996
Percy	Weasley	1,987	1,994
Oliver	Wood	1,987	1,994

