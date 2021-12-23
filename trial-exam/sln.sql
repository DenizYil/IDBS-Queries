
-- A) 2853 - CORRECT
SELECT * FROM ggarments
WHERE g_price IS null;

-- B) 250 - CORRECT
SELECT DISTINCT GD.d_ID FROM gDesigners GD
JOIN gGarments GG ON GD.d_ID = GG.d_ID
JOIN gMadeOf GM ON GM.g_ID = GG.g_ID
JOIN gElements GE ON GE.f_ID = GM.f_ID
WHERE GM.mo_percentage > 25 AND GE.e_element = 'Procrastinium';

-- C) 100 - CORRECT
SELECT COUNT(*) FROM (
	SELECT d_Id FROM gDesigners GD
	EXCEPT
	(
		SELECT DISTINCT d_Id FROM gGarments GG
	 	WHERE co_Id IS NOT NULL
		UNION
		SELECT DISTINCT co_Id FROM gGarments GG
		WHERE co_Id IS NOT NULL
	)
) X;

-- D) 1481 - CORRECT
DROP VIEW IF EXISTS designers_grouped;
CREATE VIEW  designers_grouped AS (
	SELECT d_id, AVG(g_price) AS average FROM gGarments GG
	GROUP BY d_id
);

SELECT d_id FROM designers_grouped
WHERE average = (SELECT MAX(average) FROM designers_grouped);

-- E) 2 - CORRECT
SELECT COUNT(*) FROM (
	SELECT GE.e_element FROM gFabrics GF
	JOIN gElements GE ON GF.f_Id = GE.f_id
	WHERE GE.e_element LIKE 'C%'
	GROUP BY GE.e_element
	HAVING COUNT(GE.e_element) >= 5
) X;

-- F) 4267 - WRONG
SELECT COUNT(*) FROM (
	SELECT g_id FROM gMadeOf
	GROUP BY g_Id
	HAVING SUM(mo_percentage) != 100
) X;

-- G) 6 - CORRECT
SELECT COUNT(*) FROM (
	SELECT d_Id FROM gGarments GG
	JOIN gHasType GH ON GG.g_Id = GH.g_Id
	JOIN gTypes GT ON GH.t_Id = GT.t_Id
	WHERE t_category = 'Dress'
	GROUP BY d_id
	HAVING COUNT(DISTINCT t_name) = (
		SELECT COUNT(DISTINCT t_name) FROM gTypes GT
		WHERE t_category = 'Dress'
	)
) X;
