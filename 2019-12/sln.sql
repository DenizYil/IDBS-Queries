-- continents(Continent)
-- countries(Code, Name, Region, ..., Population, ...)
-- countries_continents(CountryCode, Continent, Percentage)
-- cities(ID, Name, CountryCode, District, Population)
-- empires(CountryCode, Empire)
-- countries_languages(CountryCode, Language, IsOfficial, Percentage)


-- A) 3
SELECT COUNT(*) FROM empires e
JOIN countries c on e.countrycode = c.code
WHERE e.empire = 'Danish Empire';

-- B) 4064
SELECT COUNT(*) FROM cities ci
JOIN countries co ON ci.countrycode = co.code
WHERE ((co.population / 100) * 50) < ci.population;

-- C) 2
SELECT * FROM (
	SELECT countrycode FROM countries_continents cc
	GROUP BY countrycode
	HAVING COUNT(countrycode) > 1
) X 
JOIN countries_continents cc ON x.countrycode = cc.countrycode
WHERE cc.continent = 'Europe';

-- D)
SELECT COUNT(*) FROM (
	SELECT cl.countrycode FROM countries c
	JOIN countries_languages cl ON cl.countrycode = c.code
	GROUP BY countrycode
	HAVING SUM(percentage) < 100
	UNION
	SELECT code FROM countries
	WHERE NOT EXISTS (
		SELECT * FROM countries_languages cl
		WHERE cl.countrycode = countries.code 
	)
) X;

-- E)
SELECT SUM(c.population / 100 * cl.percentage) 
FROM countries_languages cl
JOIN countries_continents cc ON cl.countrycode = cc.countrycode
JOIN countries c ON c.code = cl.countrycode
WHERE c.population > 1000000 AND cc.continent = 'South America' AND cl.language = 'Spanish';

-- F) 456
DROP VIEW IF EXISTS cities_ratios;
DROP VIEW IF EXISTS smallest_cities;
DROP VIEW IF EXISTS biggest_cities;

CREATE VIEW smallest_cities AS (
	SELECT * FROM cities 
	WHERE cities.population = (
		SELECT MIN(population) FROM (
			SELECT population FROM cities c2
			WHERE cities.countrycode = c2.countrycode
		) X
	)
);

CREATE VIEW biggest_cities AS (
	SELECT * FROM cities 
	WHERE cities.population = (
		SELECT MAX(population) FROM (
			SELECT population FROM cities c2
			WHERE cities.countrycode = c2.countrycode
		) X
	)
);

CREATE VIEW cities_ratios AS (
	SELECT bc.id, (bc.population / sc.population) AS ratio FROM biggest_cities bc
	JOIN smallest_cities sc ON bc.countrycode = sc.countrycode
);

SELECT id FROM cities_ratios
WHERE ratio = (SELECT MAX(ratio) FROM cities_ratios)

-- continents(Continent)
-- countries(Code, Name, Region, ..., Population, ...)
-- countries_continents(CountryCode, Continent, Percentage)
-- cities(ID, Name, CountryCode, District, Population)
-- empires(CountryCode, Empire)
-- countries_languages(CountryCode, Language, IsOfficial, Percentage)
