-- cities(ID, name)
-- clubs(ID, name, cityID)
-- seasons(ID, startdate, enddate)
-- matches(homeID, awayID, seasonID, homegoals, awaygoals, awaywin)
-- players(ID, name)
-- signedwith(playerID, clubID, seasonID)

-- 1.A) ANSWER = 6
SELECT COUNT(*) 
FROM cities AS city 
JOIN clubs ON city.id = clubs.cityID
WHERE city.name = 'London';

-- 1.B)
SELECT COUNT(DISTINCT playerID) FROM signedwith s
WHERE NOT EXISTS (
    SELECT * FROM clubs
    WHERE s.clubID = clubs.ID
);

-- 1.C) 
SELECT COUNT(*) FROM (
    SELECT COUNT(name) FROM clubs 
    JOIN matches ON clubs.ID = matches.awayID
    WHERE matches.awaywin
    GROUP BY clubs.name
    HAVING COUNT(name) = (
        SELECT MAX(count) FROM (
            SELECT COUNT(*) FROM clubs 
            JOIN matches ON clubs.ID = matches.awayID
            WHERE matches.awaywin
            GROUP BY clubs.name
        ) x
    )
) y;

-- 1.D)
SELECT SUM(awaygoals) FROM (
    SELECT DISTINCT clubid, seasonid FROM players 
    JOIN signedwith ON players.ID = signedwith.playerid
    WHERE name = 'Steven Gerrard'
) X
JOIN matches ON clubid = matches.awayid AND x.seasonid = matches.seasonid;

-- 1.E)
DROP VIEW IF EXISTS clubcount;

CREATE VIEW clubcount AS (
    SELECT name, COUNT(name) FROM (
        SELECT DISTINCT * FROM (
            SELECT name, clubid FROM players 
            JOIN signedwith ON players.ID = signedwith.playerID
        ) x
    ) y
    GROUP BY name
);

SELECT name FROM clubcount
WHERE count = (
    SELECT MAX(count) FROM clubcount
);

-- 1.F) 
SELECT COUNT(*) FROM (
    SELECT id FROM players 
    EXCEPT
    SELECT DISTINCT playerid FROM signedwith s
    JOIN clubs ON s.clubid = clubs.id
    JOIN cities ON clubs.cityid = cities.id
    WHERE cities.name = 'London'
) x;

-- 1.G)
DROP VIEW IF EXISTS londonclubs;

CREATE VIEW londonclubs AS (
    SELECT clubs.id, clubs.name FROM clubs
    JOIN cities ON clubs.cityid = cities.id
    WHERE cities.name = 'London'
);

SELECT * FROM londonclubs;


-- cities(ID, name)
-- clubs(ID, name, cityID)
-- seasons(ID, startdate, enddate)
-- matches(homeID, awayID, seasonID, homegoals, awaygoals, awaywin)
-- players(ID, name)
-- signedwith(playerID, clubID, seasonID)