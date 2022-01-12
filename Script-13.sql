

-- создаем таблицу colors для хранения названий цветов животных
CREATE TABLE colors (
id integer primary key autoincrement,
name varchar(25));

-- вставляем в таблицу colors уникальные цвета из столбов color1 и color2 исходной таблицы
insert into colors (name)
select * FROM 
(SELECT DISTINCT rtrim(color1) from animals
union
SELECT DISTINCT rtrim(color2) from animals
WHERE color2 is NOT NULL); 

-- создаем промежуточную таблицу цветов для заполнения с ее помощью итоговой таблицы
CREATE TABLE animals_colors1 (
id integer primary key autoincrement,
name varchar(25),
animal_id varchar(10),
color_id integer);

CREATE TABLE animals_colors2 (
id integer primary key autoincrement,
name varchar(25),
animal_id varchar(10),
color_id integer);

-- вставляем данные о цветах в промежуточную таблицу animals_colors из animals
INSERT into animals_colors1 (name, animal_id, color_id)
select colors.name, animals.animal_id, colors.id 
from animals
join colors on rtrim(animals.color1) = rtrim(colors.name);

INSERT into animals_colors2 (name, animal_id, color_id)
select colors.name, animals.animal_id, colors.id 
from animals
join colors on rtrim(animals.color2) = rtrim(colors.name);

-- создаем таблицу типов животных animals_types
CREATE TABLE animals_types (
id integer primary key autoincrement,
name varchar(25));

-- заполняем таблицу типов уникальными типами из animals
INSERT into animals_types (name)
select DISTINCT (animal_type) from animals; 

-- создаем таблицу пород животных animals_breed
CREATE TABLE animals_breed (
id integer primary key autoincrement,
name varchar(25));

-- заполняем таблицу пород уникальными породами из animals
INSERT into animals_breed (name)
select DISTINCT (breed) from animals;

-- создаем таблицу событий с животными outcomes
CREATE table outcomes (
id integer primary key autoincrement,
age_upon_outcome varchar(30),
outcome_subtype varchar(30),
outcome_type varchar(30),
outcome_month integer,
outcome_year integer,
animal_id varchar(10));

--заполняем таблицу событий уникальными событиями
INSERT into outcomes (animal_id, age_upon_outcome, outcome_subtype, outcome_type, outcome_month, outcome_year)
select DISTINCT animal_id, age_upon_outcome, outcome_subtype, outcome_type, outcome_month, outcome_year from animals;

--создаем итоговую новую таблицу animals_new
CREATE table animals_new(
id integer primary key autoincrement,
animal_id varchar(10),
type_id integer,
name varchar(30),
color1_id integer,
color2_id integer,
breed_id integer,
date_of_birth date);

--заполняем итоговую таблицу animals_new
INSERT into animals_new (animal_id, type_id, name, color1_id, color2_id, breed_id, date_of_birth)
select DISTINCT animals.animal_id, animals_types.id, animals.name, animals_colors1.color_id, animals_colors2.color_id, animals_breed.id, date_of_birth
from animals 
LEFT JOIN animals_types on animals.animal_type = animals_types.name
LEFT JOIN animals_colors1 on animals.animal_id = animals_colors1.animal_id
LEFT JOIN animals_colors2 on animals.animal_id = animals_colors2.animal_id
LEFT JOIN animals_breed on animals.breed = animals_breed.name
;

-- запрос для выборки итоговых данных из новой таблицы по id записи
select
an.id ,
an.animal_id,
at2.name as "Type",
an.name,
c.name as "Color_1",
c2.name as "Color_2",
ab.name as "Breed",
an.date_of_birth,
o.age_upon_outcome,
o.outcome_subtype,
o.outcome_type,
o.outcome_month,
o.outcome_year 
from animals_new an 
LEFT JOIN animals_types at2 on an.type_id = at2.id
LEFT JOIN colors c on an.color1_id = c.id
LEFT JOIN colors c2 on an.color2_id = c2.id
LEFT JOIN animals_breed ab on ab.id = an.breed_id
LEFT JOIN outcomes o on an.animal_id = o.animal_id 
WHERE an.id = 1
;