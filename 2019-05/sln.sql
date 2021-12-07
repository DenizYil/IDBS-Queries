-- acgroup(ag, agfullname)
-- aircraft(actype, actypefullname, capacity, ag)
-- airport(airport, country)
-- country(country, region)
-- flights(id, al, dep, arr, actype, start_op, end_op, ...)

-- A) 17
SELECT COUNT(*) FROM airport
WHERE country = 'DE';

-- B) 185
SELECT airport FROM airport a
JOIN country c ON a.country = c.country
WHERE c.region = 'EU' 
	AND EXISTS (
		SELECT * FROM flights f
		WHERE f.dep = a.airport
	) 
	AND EXISTS (
		SELECT * FROM flights f
		WHERE f.arr = a.airport
	);
	
-- C) 1572
SELECT MAX(end_op - start_op) FROM flights;

-- D) 185
SELECT * FROM flights f
JOIN airport a ON a.airport = f.dep
JOIN country c ON a.country = c.country
JOIN aircraft ac ON f.actype = ac.actype
WHERE c.region = 'AS' AND ac.capacity > 300;

-- E) 24
SELECT MAX(count) FROM (
	SELECT COUNT(*) FROM aircraft a
	GROUP BY a.ag
) X;

-- F)
select count(*) 
from airport a
where (
	select count(*) 
    from flights f1
	where f1.arr = a.airport
) > (
	select count(*) 
    from flights f2
	where f2.dep = a.airport
);

-- G)
SELECT * FROM flights f
JOIN aircraft ac ON f.actype = ac.actype
JOIN airport a1 ON f.dep = a1.airport
JOIN country c1 ON a1.country = c1.country
JOIN airport a2 ON f.arr = a2.airport
JOIN country c2 ON a2.country = c2.country
WHERE c1.region = c2.region 
AND c1.country != c2.country
AND ac.AG = 'F';

-- H)
SELECT COUNT(*) FROM (
	SELECT COUNT(al) FROM flights f
	JOIN airport a ON f.dep = a.airport
	WHERE a.country = 'NL'
	GROUP BY f.al
	HAVING COUNT(DISTINCT airport) = (
		SELECT COUNT(*) FROM airport a2
		WHERE a2.country = 'NL'
	)
) X;

-- acgroup(ag, agfullname)
-- aircraft(actype, actypefullname, capacity, ag)
-- airport(airport, country)
-- country(country, region)
-- flights(id, al, dep, arr, actype, start_op, end_op, ...)
