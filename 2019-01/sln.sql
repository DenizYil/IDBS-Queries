-- Player(id,name,email)
-- Game(id,version,name,producer,releasedate)
-- Achievement(id,gameId,description)
-- Score(playerId,gameId,timeStamp,level,score)
-- PlayerAchievement(playerId,achievementId)

-- A) 87
SELECT COUNT(*) FROM player
WHERE email like '%yahoo.dk';

-- B) 967
SELECT COUNT(*) FROM score
WHERE score < (SELECT AVG(score) FROM score);

-- C) 2
SELECT COUNT(*) FROM playerachievement pa
LEFT JOIN achievement a ON pa.achievementid = a.id
WHERE a.id IS null;

-- D) 6
SELECT COUNT(DISTINCT s.playerid) FROM score s 
JOIN game g ON s.gameid = g.id
WHERE g.producer = 'Codemasters' AND EXISTS (
	SELECT pa.playerid FROM achievement a
	JOIN playerachievement pa ON a.id = pa.achievementid
	WHERE a.gameId = s.gameId AND pa.playerId = s.playerId
);

-- D2) Bjorn
select count(distinct PA.playerId)
from PlayerAchievement PA 
	join Achievement A on PA.achievementId = A.id
    join Game G on A.gameId = G.id
	join Score S on PA.playerId = S.playerId and S.gameId = G.id
where G.producer = 'Codemasters';

-- E) BLANK

-- F) 2
SELECT COUNT(*) FROM (
	SELECT playerid FROM game
	JOIN score ON score.gameid = game.id
	WHERE name = 'Project Eden'
	GROUP BY playerid
	HAVING COUNT(gameid) = (
		SELECT COUNT(*) FROM game
		WHERE name = 'Bioforge'
	)
) X;

-- H)
-- FORKERT!!
SELECT SUM(count) FROM (
	SELECT COUNT(name) FROM game
	GROUP BY name
	HAVING COUNT(name) > 1
) X;

--KORREKTE MULIGHEDER
select count(*) 
from game G1 
	join game G2 on G1.name = G2.name and G1.id < G2.id;

select count(*) 
from (
	select *
    from Game a 
		join Game b on a.id > b.id 
	where a.name = b.name
) as Z;

-- Player(id,name,email)
-- Game(id,version,name,producer,releasedate)
-- Achievement(id,gameId,description)
-- Score(playerId,gameId,timeStamp,level,score)
-- PlayerAchievement(playerId,achievementId)