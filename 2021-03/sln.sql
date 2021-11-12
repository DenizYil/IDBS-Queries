-- Categories(ID, name)
-- Diseases(ID, catID, code, name, curable)
-- Companies(ID, name, country)
-- Vaccines(ID, name, disID, comID, effectyears)
-- People(ID, name, birthyear)
-- Injections(peoID, vacID, injectionyear)

-- A) 3
SELECT COUNT(*) FROM vaccines v
JOIN companies c ON c.ID = v.comID
WHERE c.name = 'Amgen';

-- Actual
SELECT COUNT(*) FROM vaccines v
JOIN diseases d ON v.disID = d.id
WHERE d.name = 'Coronavirus';

-- B) 514
SELECT COUNT(DISTINCT peoID) FROM injections i
JOIN vaccines v ON i.vacID = v.ID
JOIN diseases d ON d.ID = v.disID
JOIN categories c ON d.catID = c.ID
WHERE NOT d.curable AND c.name = 'Immune diseases';

-- Actual
SELECT COUNT(DISTINCT peoID) FROM injections i
JOIN vaccines v ON i.vacID = v.ID
JOIN diseases d ON d.ID = v.disID
JOIN categories c ON d.catID = c.ID
WHERE d.curable AND c.name = 'Bone diseases';

-- C) 536
DROP VIEW IF EXISTS corona;

CREATE VIEW corona AS (
	SELECT v.id, effectyears FROM vaccines v
	JOIN diseases d ON v.disID = d.id
	WHERE d.name = 'Coronavirus'
);

SELECT id FROM corona
WHERE corona.effectyears = (
	SELECT MIN(effectyears) FROM corona
);
	
-- Actual
SELECT id FROM corona
WHERE corona.effectyears = (
	SELECT MAX(effectyears) FROM corona
);

-- D) 10
SELECT COUNT(*) FROM (
	SELECT d.id FROM diseases d
	EXCEPT
	SELECT d2.id FROM diseases d2
	JOIN vaccines v ON d2.ID = v.disID
	GROUP BY d2.id
	HAVING COUNT(*) >= 5
) X;

-- E) 235
SELECT COUNT(DISTINCT peoid) FROM injections i
JOIN vaccines v ON i.vacID = v.ID
JOIN diseases d ON d.ID = v.disID
WHERE d.name = 'Coronavirus' 
	AND effectyears + injectionyear >= 2021;
	
-- F) 57.4908088235294118
SELECT (1.0 * (SELECT COUNT(*) FROM injections) / (SELECT COUNT(*) FROM people));

-- G) 450
SELECT COUNT(*) FROM (
	SELECT i.peoID FROM injections i
	JOIN vaccines v ON i.vacID = v.ID
	JOIN diseases d ON v.disID = d.ID
	GROUP BY i.peoID
	HAVING COUNT(DISTINCT d.catID) = (
		SELECT COUNT(*) FROM categories
	)
) X;

-- Categories(ID, name)
-- Diseases(ID, catID, code, name, curable)
-- Companies(ID, name, country)
-- Vaccines(ID, name, disID, comID, effectyears)
-- People(ID, name, birthyear)
-- Injections(peoID, vacID, injectionyear)
