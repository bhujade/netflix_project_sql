create table netflix(
show_id	 varchar(6),
type	varchar(10),
title	varchar(150),
director	varchar(208),
casts	varchar(1000),
country	varchar(150),
date_added	varchar(50),
release_year	int,
rating	varchar(10),
duration	varchar(15),
listed_in	varchar(100),
description varchar(250)

)

select * from netflix;

select count(*) from netflix;


-- business problem
-- Q1. Count the number of movies vs tv shows.

select type, count(*) as total_count
from netflix
group by type;

--Q2. find the most common rating for movies and tv show.
select type,rating 
from (
select type ,  rating ,count(*),
       rank() over(partition by type order by count(*) desc ) as rn
from netflix 
group by type , rating) as t1
where t1.rn = 1;

--3. List all movies released in a specific year (2020).

 select *
 from netflix
 where type = 'Movie' and release_year  = 2020;

-- 4. find the top 5 countries with the most content on Netflix.

 select unnest(string_to_array(country,',')) as new_country, count(country)
 from netflix
 group by 1
 order by 2 desc
 limit 5;
 
-- 5. Identify the longest movie .

select *
from netflix
where type = 'Movie' and duration = (select max(duration) from netflix);

-- 6. find content that added in the  last 5 years



SELECT * 
FROM netflix 
WHERE to_date(date_added , 'DD-Mon-YY') >= CURRENT_DATE - INTERVAL '5 years';


select CURRENT_DATE - INTERVAL '5 years'; 

-- 7.find all the movies/tv shows directed by 'Rajiv Chilaka'.

select *
from netflix
where director ilike  '%rajiv Chilaka%';


-- 8. List all tv show with more than 5 seasons.

select *
from netflix
where type = 'TV Show' and duration > '5 Seasons';

select *
from netflix
where type = 'TV Show' and split_part(duration,' ',1)::numeric >5 ;

--9.count the number of content items in each genre

select unnest(string_to_array(listed_in,',')) as genre,
count(show_id)
from netflix
group by genre ; 

--10 . find each year and average number of content release by india on netflix 
--     return top 5 year with the highest average content release.                     

  select extract(year from to_date(date_added, 'dd Mon, yy')) as year,
   count(*) as yearly_count,
   round(
    count(*)::numeric / (select count(*) from netflix where country = 'India')::numeric * 100 , 2
   ) as avg_Content_per_year
   from netflix
   where country = 'India'
   group by 1;


--11.  list all movies that are documentries.
 
select *
from netflix
where type = 'Movie' and listed_in  like '%Documentaries%'


--12. find all content without director.
select *
from netflix
where director is null;

--13. find how many movies actor 'salman khan' appeared in last 10 years.

 select *	
 from netflix
 where casts ilike '%salman khan%' and release_year > extract( year from current_date )  ;

--14.find the top 10 acters who appered in the highest number of movies produced in india.

select  unnest(string_to_array(casts,',')) as new_casts, count(casts)
from netflix
where country = 'India'
group by 1
order by 2 desc limit 10;

-- 15. categorize the content based on the presence of the keyword 'kill' and 'violence' in the discription 
--  feild . label content containing this keyword as 'bad' and all other content is 'good'. count how many items
--  fall into each category.

with new_table
as
(select *,
      case 
	    when description ilike '%kill%' or description ilike '%violence%'  then 'bad_content'
		else 'good_content'
		end  category
from netflix		
)
select category,
 count(*) as total
 from new_table
 group by 1;






  