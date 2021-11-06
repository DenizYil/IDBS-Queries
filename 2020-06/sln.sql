-- Places(ID, name, population)
-- Clubs(ID, name, placeID, founded)
-- Genders(ID, gender, description)
-- Teams(ID, clubID, ordinal, genderID)
-- Divisions(ID, name, genderID)
-- TeamsInDivisions(teamID, divisionID)
-- Matches(ID, divisionID, hometeamID, awayteamID, homesets, awaysets)
-- Sets(matchID, setnumber, homepoints, awaypoints)

-- A) 12
SELECT COUNT(*) FROM places
WHERE name LIKE '%lev';

-- B) 34
SELECT id FROM PLACES
WHERE population = (
	SELECT MAX(population) FROM places
);

-- C) 62 -- This is about finding duplicates
SELECT COUNT(teamid) FROM teamsindivisions
GROUP BY teamid
HAVING COUNT(*) > 1; 

-- D) 54
SELECT COUNT(DISTINCT T.id) FROM teamsindivisions TID
JOIN teams T ON TID.teamID = T.ID
JOIN divisions D ON TID.divisionID = D.ID
WHERE T.genderID != D.genderID;

-- E)


-- Places(ID, name, population)
-- Clubs(ID, name, placeID, founded)
-- Genders(ID, gender, description)
-- Teams(ID, clubID, ordinal, genderID)
-- Divisions(ID, name, genderID)
-- TeamsInDivisions(teamID, divisionID)
-- Matches(ID, divisionID, hometeamID, awayteamID, homesets, awaysets)
-- Sets(matchID, setnumber, homepoints, awaypoints)
