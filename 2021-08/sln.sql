-- types(ID, name)
-- families(ID, typeID, name)
-- plants(ID, familyID, name)
-- people(ID, name, position)
-- parks(ID, name)
-- flowerbeds(ID, parkID, size, description)
-- plantedin(plantID, flowerbedID, percentage, planterID)

-- A) 18
SELECT COUNT(*) FROM plants
JOIN families ON families.ID = plants.familyID
WHERE families.name = 'Thespesia';

-- B) 9
SELECT COUNT(*) FROM people
WHERE NOT EXISTS (
	SELECT * FROM plantedin
	WHERE plantedin.planterID = people.ID
) AND position = 'Planter'

-- C)
