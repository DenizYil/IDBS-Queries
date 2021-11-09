-- Zips(zip, municipalityID, city)
-- Users(ID, name, zip)
-- Relationships(fromID, toID)
-- Roles(fromID, toID, role)
-- Posts(ID, posterID, time, text, url)
-- Likes(userID, postID)
-- Comments(ID, postID, posterID, userID, text)

-- A)
SELECT COUNT(DISTINCT id) FROM users
JOIN relationships ON relationships.toID = users.ID;

-- B)
SELECT * FROM relationships r1
JOIN relationships r2 
ON r1.fromID = r2.toID AND r2.fromID = r1.toID
where r1.fromID > r2.fromID;

-- C)
SELECT COUNT(*) FROM relationships re
LEFT JOIN roles ro
ON ro.fromID = re.fromID AND ro.toID = re.toID
WHERE role is null;

-- D)
DROP VIEW IF EXISTS postWithComments;

CREATE VIEW postWithComments AS (
		SELECT postID, COUNT(postID) FROM posts
		JOIN comments ON posts.ID = comments.postID
	GROUP BY postID
);

-- Original attempt:
SELECT id FROM posts
WHERE posts.ID = (
	SELECT postID FROM postWithComments
	WHERE count = (
		SELECT MAX(count) FROM postwithcomments
	)
);

-- Clean up:
SELECT postID FROM postWithComments
WHERE count = (
	SELECT MAX(count) FROM postWithComments
);

-- E - WRONG
SELECT COUNT(*) FROM postWithComments
WHERE count <= 3;

-- F

-- G
SELECT COUNT(DISTINCT toID) FROM (
	SELECT toID FROM roles
	GROUP BY fromID, toID
	HAVING COUNT(toID) = (
		SELECT COUNT(DISTINCT role) FROM roles
	)
) x;

-- H

