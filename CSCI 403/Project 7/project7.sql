/*Dropping tables*/
drop table if exists artist;
drop table if exists artist_artist_xref;
drop table if exists label;
drop table if exists track;
drop table if exists genre;
drop table if exists album;
/*Create tables*/
create table artist(
ID serial,
Name text not null,
Type text,
primary key(id)
);
 create table label(
ID serial,
Name Text,
Location Text,
primary key(id)
);
create table album(
 ID serial,
 Title Text,
 Year INT,
 label_id INT,
 artist_id INT,
 primary key (id),
 foreign key (label_id)
 references label(id),
 foreign key (artist_id)
 references artist(id)
);
create table track(
 Name TEXT,
 Number TEXT,
 album_id INT NOT NULL,
 foreign key (album_id)
 references album(id)
 on delete cascade,
 primary key (name, number, album_id)
);
create table genre(
 Genre TEXT,
 album_id INT,
 foreign key (album_id) references album(id)
);
create table artist_artist_xref(
 begin_year INT,
 end_year INT,
 individual_id INT,
 group_id INT,
 foreign key (individual_id) references artist(id),
 foreign key (group_id) references artist(id)
);
/*Loading data*/
insert into artist(name, type)(
 select distinct artist_name, artist_type
 from project7
);
insert into artist(name, type)(
 select distinct member_name, 'Person' 
 from project7 
 where artist_type = 'Group' 
 and member_name NOT IN (select name from artist)
);
drop table if exists xref;/*Dropping xref if exists*/
select distinct artist_name, member_name, member_begin_year, member_end_year 
 into xref 
 from project7 
 where artist_type = 'Group';
 insert into artist_artist_xref(group_id, individual_id, begin_year, end_year)(
 select a.id, b.id, x.member_begin_year, x.member_end_year 
 from artist as a, artist AS b, xref AS x 
 where a.name = x.artist_name AND b.name = x.member_name
);
insert into label(name, location)(
 select distinct label, headquarters from project7
);
 insert into album(title, year, artist_id, label_id)(
 select distinct album_title, album_year, artist.id as a_id, label.id as l_id 
 from project7, artist, label 
 where artist_name = artist.name and label = label.name
);
insert into genre(
 select distinct genre, id from project7, album where album_title = title
);
insert into track(
 select distinct track_name, track_number, id from project7, album where title = album_title
);

/*Questions*/
/*1*/
select name, begin_year, end_year 
 from artist_artist_xref as x, artist as a 
 where x.group_id = (select ID from artist where name = 'The Who') 
 and a.id = x.individual_id;
 
 /*2*/
 drop table if exists CHRIS_BANDS;
 select name 
 into CHRIS_BANDS
 from artist 
 where id IN (select group_id 
 from artist_artist_xref 
 where individual_id = (select id 
 from artist 
 where name = 'Chris Thile'));
select * from CHRIS_BANDS;

/*3*/
select title, year, album.title, label.name 
from artist, album, label 
where album.artist_id = artist.id 
 and album.label_id = label.id 
 and (
 artist.name in (select name from CHRIS_BANDS) 
 or artist.name = 'Chris Thile'
 ) 
order by year;
/*4*/
select name, title, year 
from album, artist 
where artist.id = artist_id 
 and album.id IN (SELECT album_id 
 from genre 
 where genre = 'electronica') 
order by year, name;
/*5*/
select track.name, track.number 
from artist, album, track 
where artist.id = album.artist_id 
 and track.album_id = album.id 
 and artist.name = 'Led Zeppelin' 
 and album.title = 'Houses of the Holy' 
order by track.number;
/*6*/
select distinct genre 
from artist, album, genre 
where artist.id = album.artist_id 
 and artist.name = 'James Taylor' 
 and genre.album_id = album.id;
 /*7*/
 select artist.name, album.title, album.year, label.name 
from artist, album, label 
where album.artist_id = artist.id 
 and album.label_id = label.id 
 and label.location = 'Hollywood';