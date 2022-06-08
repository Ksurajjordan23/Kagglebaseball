
--1--
WITH DATA AS (SELECT DISTINCT(t.teamid) AS teams, t.yearid FROM teams t
INNER JOIN managers m USING(yearid)
WHERE t.w >= 70 and t.yearid = 2010 
AND m.inseason <> 0) SELECT COUNT(teams)||' teams'||':'|| STRING_AGG(teams, ',') AS answer1 FROM DATA
--2--
WITH DATA AS (SELECT DISTINCT(t.teamid) AS teams, t.yearid, m.playerid AS players, m.inseason AS 
			  managerial FROM teams t
INNER JOIN managers m USING(yearid)
WHERE t.w >= 70 and t.yearid = 2010 
AND m.inseason <> 0) SELECT teams||':'||STRING_AGG(players,',') AS answer2 FROM (
	SELECT players, teams, RANK() OVER( PARTITION BY teams ORDER BY managerial) as r FROM DATA
	WHERE teams IN (
		SELECT teams FROM DATA
		GROUP BY teams
		HAVING COUNT(DISTINCT managerial) >1))as t WHERE r >1 GROUP BY teams

--3--
WITH DATA AS (SELECT DISTINCT(t.teamid) AS teams, t.yearid, m.playerid AS players, m.inseason AS 
			  managerial FROM teams t
                INNER JOIN managers m USING(yearid)
                WHERE t.w >= 70 and t.yearid = 2010 
                AND m.inseason <> 0)
					SELECT teams, players, RANK() OVER(PARTITION by teams ORDER BY players) FROM (
                SELECT players, teams, RANK() OVER( PARTITION BY teams ORDER BY managerial) as r FROM DATA
                WHERE teams IN (
		SELECT teams FROM DATA
		GROUP BY teams
		HAVING COUNT(DISTINCT managerial) >1))as t WHERE r>1 GROUP BY teams, players ORDER BY rank DESC LIMIT 23



