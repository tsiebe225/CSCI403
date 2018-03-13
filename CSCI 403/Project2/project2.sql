/*
 *  project2.sql
 * 
 *  author:*
 */
/*What year did Nymphadora Tonks start at Hogwarts?
SELECT start FROM hogwarts_students where last='Tonks';
1984*/
/*What records do we have for students who started at Hogwarts before 1900?
select * from hogwarts_students where start <1900;
Dumbledore	Albus	Gryffindor	1,892	1,899*/
/*What house did Padma Patil sort into?
select * from hogwarts_students where last ='Patil' and first ='Padma';
She was in RavenClaw,
Patil	Padma	Ravenclaw	1,991	1,998*/
/*How many years was Percy Weasley at Hogwarts?
select finish - start from hogwarts_students where last ='Weasley' and first='Percy';
7*/
/*What students have a last name starting with "Q" or a first name starting with "Ph"?
select last,first from hogwarts_students where last like 'Q%' or first like 'Ph%';
Black	Phineas
Quirke	Orla*/
/*What students' houses are unknown?
select last,first from hogwarts_students where house='unknown';
No students house is unknown*/
/*Who founded the house whose crest displays a badger?
select founder from hogwarts_houses where animal='Badger';
Helga Hufflepuff*/
/*What are the names of all Gryffindor students, given as "firstname lastname", without extra spaces, ordered by last name and first name? E.g., the answer should include strings like
select first,last from hogwarts_students where house='Gryffindor' order by last,first;
Euan	Abercrombie
Katie	Bell
Sirius	Black
Lavender	Brown
Ritchie	Coote
Colin	Creevey
Dennis	Creevey
Albus	Dumbledore
Lily	Evans
Seamus	Finnigan
Victoria	Frobisher
Hermione	Granger
Rubeus	Hagrid
Geoffrey	Hooper
Angelina	Johnson
Lee	Jordan
Andrew	Kirke
Neville	Longbottom
Remus	Lupin
Mary	MacDonald
Natalie	MacDonald
Minerva	McGonagall
Cormac	McLaggen
Eloise	Midgen
Parvati	Patil
Jimmy	Peakes
Peter	Pettigrew
Harry	Potter
James	Potter
Molly	Prewett
Demelza	Robins
Jack	Sloper
Alicia	Spinnet
Patricia	Stimpson
Dean	Thomas
Kenneth	Towler
Romilda	Vane
Arthur	Weasley
Bill	Weasley
Charlie	Weasley
Fred	Weasley
George	Weasley
Ginny	Weasley
Percy	Weasley
Ronald	Weasley
Oliver	Wood*/
/*What defense against the dark arts teacher's first name started with 'A' whose last name did not start with 'M'?
select first,last from hogwarts_dada where first like'A%' and last not like'M%';
Amycus	Carrow*/
/*What are the names of the Gryffindor students who started in 1991, sorted by last name then first name?
select first,last from hogwarts_students where house='Gryffindor' and start=1991 order by last,first;
Lavender	Brown
Seamus	Finnigan
Hermione	Granger
Neville	Longbottom
Parvati	Patil
Harry	Potter
Dean	Thomas
Ronald	Weasley*/
/*What unique ending years do we have student records for, ordered by ending year?
select distinct finish from hogwarts_students order by finish;
1,899
1,943
1,945
1,954
1,968
1,972
1,973
1,978
1,989
1,991
1,994
1,995
1,996
1,997
1,998
1,999
<null>*/
/*What are the names and years of all the students whose houses are known, together with their house colors, ordered by starting year?
select first, last, start, colors from hogwarts_students as hs, hogwarts_houses as hh where hs.house=hh.house order by start;
Albus	Dumbledore	1,892	Red and Gold
Tom	Riddle	1,938	Green and Silver
Rubeus	Hagrid	1,940	Red and Gold
Myrtle	Warren	1,940	Blue and Bronze
Minerva	McGonagall	1,947	Red and Gold
Arthur	Weasley	1,961	Red and Gold
Bellatrix	Black	1,962	Green and Silver
Lucius	Malfoy	1,965	Green and Silver
Narcissa	Black	1,966	Green and Silver
Severus	Snape	1,971	Green and Silver
Peter	Pettigrew	1,971	Red and Gold
Sirius	Black	1,971	Red and Gold
James	Potter	1,971	Red and Gold
Remus	Lupin	1,971	Red and Gold
Lily	Evans	1,971	Red and Gold
Regulus	Black	1,972	Green and Silver
Bill	Weasley	1,982	Red and Gold
Nymphadora	Tonks	1,984	Yellow and Black
Charlie	Weasley	1,984	Red and Gold
Marcus	Flint	1,986	Green and Silver
Percy	Weasley	1,987	Red and Gold
Oliver	Wood	1,987	Red and Gold
Penelope	Clearwater	1,987	Blue and Bronze
Angelina	Johnson	1,989	Red and Gold
Patricia	Stimpson	1,989	Red and Gold
Kenneth	Towler	1,989	Red and Gold
Fred	Weasley	1,989	Red and Gold
George	Weasley	1,989	Red and Gold
Adrian	Pucey	1,989	Green and Silver
Cedric	Diggory	1,989	Yellow and Black
Lee	Jordan	1,989	Red and Gold
Katie	Bell	1,990	Red and Gold
Cho	Chang	1,990	Blue and Bronze
Eddie	Carmichael	1,990	Blue and Bronze
Theodore	Nott	1,991	Green and Silver
Padma	Patil	1,991	Blue and Bronze
Parvati	Patil	1,991	Red and Gold
Harry	Potter	1,991	Red and Gold
Ronald	Weasley	1,991	Red and Gold
Susan	Bones	1,991	Yellow and Black
Terry	Boot	1,991	Blue and Bronze
Mandy	Brocklehurst	1,991	Blue and Bronze
Lavender	Brown	1,991	Red and Gold
Millicent	Bulstrode	1,991	Green and Silver
Blaise	Zabini	1,991	Green and Silver
Vincent	Crabbe	1,991	Green and Silver
Tracey	Davis	1,991	Green and Silver
Seamus	Finnigan	1,991	Red and Gold
Lisa	Turpin	1,991	Blue and Bronze
Gregory	Goyle	1,991	Green and Silver
Hermione	Granger	1,991	Red and Gold
Daphne	Greengrass	1,991	Green and Silver
Wayne	Hopkins	1,991	Yellow and Black
Megan	Jones	1,991	Yellow and Black
Dean	Thomas	1,991	Red and Gold
Su	Li	1,991	Blue and Bronze
Neville	Longbottom	1,991	Red and Gold
Zacharias	Smith	1,991	Yellow and Black
Ernie	Macmillan	1,991	Yellow and Black
Draco	Malfoy	1,991	Green and Silver
Morag	McDougal	1,991	Blue and Bronze
Pansy	Parkinson	1,991	Green and Silver
Colin	Creevey	1,992	Red and Gold
Luna	Lovegood	1,992	Blue and Bronze
Ginny	Weasley	1,992	Red and Gold
Romilda	Vane	1,993	Red and Gold
Dennis	Creevey	1,994	Red and Gold
Stewart	Ackerley	1,994	Blue and Bronze
Malcolm	Baddock	1,994	Green and Silver
Eleanor	Branstone	1,994	Yellow and Black
Owen	Cauldwell	1,994	Yellow and Black
Laura	Madley	1,994	Yellow and Black
Jimmy	Peakes	1,994	Red and Gold
Graham	Pritchard	1,994	Green and Silver
Orla	Quirke	1,994	Blue and Bronze
Kevin	Whitby	1,994	Yellow and Black
Euan	Abercrombie	1,995	Red and Gold
Rose	Zeller	1,995	Yellow and Black
Demelza	Robins	<null>	Red and Gold
Evan	Rosier	<null>	Green and Silver
Jack	Sloper	<null>	Red and Gold
Horace	Slughorn	<null>	Green and Silver
Natalie	MacDonald	<null>	Red and Gold
Rodolphus	Lestrange	<null>	Green and Silver
Alicia	Spinnet	<null>	Red and Gold
Rabastan	Lestrange	<null>	Green and Silver
Andrew	Kirke	<null>	Red and Gold
Geoffrey	Hooper	<null>	Red and Gold
Terence	Higgs	<null>	Green and Silver
Anthony	Goldstein	<null>	Blue and Bronze
Victoria	Frobisher	<null>	Red and Gold
Filius	Flitwick	<null>	Blue and Bronze
Justin	Finch-Fletchley	<null>	Yellow and Black
Marietta	Edgecombe	<null>	Blue and Bronze
Roger	Davies	<null>	Blue and Bronze
Hannah	Abbott	<null>	Yellow and Black
Michael	Corner	<null>	Blue and Bronze
Ritchie	Coote	<null>	Red and Gold*/
/*Who founded the house that Morag McDougal sorted into?
select founder from hogwarts_students as hs, hogwarts_houses as hh where hs.last='McDougal' and hs.house=hh.house order by start;
Rowena Ravenclaw*/
/*What are the names and houses of the defense against the dark arts teachers (you only need worry about the teachers who also have student records)?
select hs.first,hs.last,hs.house from hogwarts_students as hs, hogwarts_dada as hd where hs.first=hd.first and hs.last=hd.last order by last,first;
Remus	Lupin	Gryffindor
Severus	Snape	Slytherin
*/

