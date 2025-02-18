-- Netflix project 

create table Netflix(
	show_id varchar(6),
	type varchar(10),
	title varchar(150),
	director varchar(308),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	realese_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250)
);

select * from Netflix;

select 
	distinct type
from Netflix;

-- 15 Business problem

-- Q.1 count the number of the Movies and TV shows 
select
	type,
	count(*) as total_content
from Netflix
group by 1;


-- Q.2 find the most common rating for movies and TV shows
select
	type,
	rating
from
(
	select 
		type,
		rating,
		count(*),
		rank () over(partition by type order by count(*) desc) as ranking
	from Netflix
	group by 1, 2
) as t1
where ranking = 1;


-- Q.3 list all movies realesed in a specific year (2020)
select *
from Netflix
where 
	type = 'Movie' 
and 
	realese_year = 2020;


 --Q.4 find the top 5 countries with the most content on Netflix
select 
	unnest(string_to_array(country, ',')) as country,
	count(show_id) as total_content
from Netflix
group by 1
order by 2 desc
limit 5;


-- Q.5 identify the longest movie duration
select *
from netflix
where 
	type = 'Movie'
	and
	duration = (select max(duration) from netflix)


-- Q.6 find content added in the last 5 years
select 
	*
from netflix
where 
	to_date(date_Added, 'month DD, YYYY') >= current_date - interval '5 years';

select current_date - interval '5 years'


-- Q.7 find all the movies/TV show by director 'Rajiv Chilaka'
select *
from netflix
where
	director ilike '%Rajiv Chilaka%'


-- Q.8 list all TV show with more than 5 seasons
select *
from netflix
where
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::numeric > 5 


-- Q.9 count the number of content items in each genre
select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by 1
order by 1 asc;



-- Q.10 find each year and the average numbers of content realese by india on netflix. return top  year with highest avg content realese
select 
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as total_content,
	round(
	count(*)::numeric/(select count(*) from netflix where country = 'India') * 100
	, 2) as avg_content_per_year
from netflix
where 
	country = 'India'
group by 1;


-- Q.11 list all movies that are documentaries
select* 
from netflix
where 
	listed_in ilike '%documentaries%'



-- Q.12 find all content without director
select *
from netflix
where 
	director is null 


-- Q.13 find how many movies actor 'Salman Khan' appeared in last 10 years
select *
from netflix
where 
	casts ilike '%Salman Khan%'
	and 
	realese_year > extract(year from current_Date) - 10


-- Q.14 find the top actors who have appeared in the highest number of movies produced in India
select 
	unnest(string_to_array(casts, ',')) as actor,
	count(show_id) as total_content
from netflix
where 
	country ilike '%India%'
group by 1
order by 2 desc
limit 10;


/* Q.15 categories the content based on the presence of the keywords 'kill' and 'voilence' in the description field. 
Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many item into each category.
*/

with new_table 
as 
(select
*,
	case 
	when
		description ilike '%kill%'
		or 
		description ilike '%violence%' 
		then 'Bad_content'
	else 'Good_content'
	end category
from netflix
)
select 
	category,
	count(*) as total_content
from new_table
group by 1;






 





