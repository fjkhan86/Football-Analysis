--  **Player Performance:**
--  1. Forwards (appearances.position) score more goals (appearances.goals) compared to midfielders and defenders.
SELECT position, AVG(goals) as avg_goals
from appearances
group by position
order by avg_goals DESC;

--  2. Players (player.id) with more assists (appearances.assists) have more wins (teamstats.result).
WITH PlayerAssistsWins AS (
    SELECT
        a.position AS POS,
        p.playerID AS PID,
        p.name AS PNAME,
        SUM(a.assists) AS total_assists,
        COUNT(CASE WHEN t.result = 'W' THEN 1 END) AS total_wins
    FROM
        players p
    JOIN
        appearances a ON p.playerID = a.playerID
    JOIN
        teamstats t ON a.gameID = t.gameID
    GROUP BY
        a.position, p.playerID, p.name
)
SELECT
    POS,
    PID,
    PNAME,
    total_assists,
    total_wins
FROM
    PlayerAssistsWins
ORDER BY
    total_assists DESC
LIMIT 10;

-- **Match Statistics:**
--  1. The number of corners (teamstats.corner) taken by a team (teamstats.teamID) correlates with the number of goals (teamstats.goals) scored.
-- Number of Corners by goals scored
SELECT 
    t.teamID,
    tm.name,
    SUM(t.corners) AS total_corners,
    SUM(t.goals) AS total_goals
FROM 
    teamstats t
JOIN 
    teams tm ON t.teamID = tm.teamID
GROUP BY 
    t.teamID, tm.name
ORDER BY 
    total_corners DESC
    LIMIT 10;

-- Number of goals scored
SELECT 
    t.teamID,
    tm.name,
    SUM(t.goals) AS total_goals
FROM 
    teamstats t
JOIN 
    teams tm ON t.teamID = tm.teamID
GROUP BY 
    t.teamID, tm.name
ORDER BY 
    total_goals DESC
    LIMIT 10;

--  2. Teams with more shots taken have a higher number of goals scored.

-- Shots taken and goals scored
SELECT 
    tm.name,
    SUM(ts.shots) AS total_shots,
    SUM(ts.goals) AS total_goals
FROM 
    teamstats ts
JOIN 
    teams tm ON ts.teamID = tm.teamID
GROUP BY 
    tm.name
ORDER BY 
    total_shots DESC
LIMIT 10;

-- Goals scored
SELECT 
    tm.name,
    SUM(ts.goals) AS total_goals
FROM 
    teamstats ts
JOIN 
    teams tm ON ts.teamID = tm.teamID
GROUP BY 
    tm.name
ORDER BY 
    total_goals DESC
LIMIT 10;

  
--  - - **Team Performance:**
--  Home teams have a higher win rate compared to away teams.
    
   WITH TeamWins AS (
    SELECT 
        g.homeTeamID AS teamID,
        COUNT(CASE WHEN ts.result = 'W' THEN 1 END) AS home_wins,
        COUNT(*) AS home_games,
        0 AS away_wins,
        0 AS away_games
    FROM 
        games g
    JOIN 
        teamstats ts ON g.gameID = ts.gameID AND g.homeTeamID = ts.teamID
    GROUP BY 
        g.homeTeamID
    
    UNION ALL
    
    SELECT 
        g.awayTeamID AS teamID,
        0 AS home_wins,
        0 AS home_games,
        COUNT(CASE WHEN ts.result = 'W' THEN 1 END) AS away_wins,
        COUNT(*) AS away_games
    FROM 
        games g
    JOIN 
        teamstats ts ON g.gameID = ts.gameID AND g.awayTeamID = ts.teamID
    GROUP BY 
        g.awayTeamID
),

-- Aggregate results for both home and away games
AggregateResults AS (
    SELECT 
        teamID,
        SUM(home_wins) AS total_home_wins,
        SUM(home_games) AS total_home_games,
        SUM(away_wins) AS total_away_wins,
        SUM(away_games) AS total_away_games,
        SUM(home_wins) + SUM(away_wins) AS total_wins,
        SUM(home_games) + SUM(away_games) AS total_games
    FROM 
        TeamWins
    GROUP BY 
        teamID
)

-- Calculate win rates for home, away, and total games, and include total games played
SELECT
    tm.name AS team_name,
    CASE 
        WHEN SUM(total_home_games) = 0 THEN 0
        ELSE SUM(total_home_wins) / SUM(total_home_games)
    END AS home_win_rate,
    CASE 
        WHEN SUM(total_away_games) = 0 THEN 0
        ELSE SUM(total_away_wins) / SUM(total_away_games)
    END AS away_win_rate,
    CASE 
        WHEN SUM(total_games) = 0 THEN 0
        ELSE SUM(total_wins) / SUM(total_games)
    END AS total_win_rate,
    SUM(total_games) AS total_games_played
FROM 
    AggregateResults ar
JOIN
    teams tm ON ar.teamID = tm.teamID
GROUP BY
    tm.name
ORDER BY
    total_win_rate DESC;

    
    
--  Total goals by league.

SELECT 
    l.leagueID, 
    l.name, 
    COUNT(DISTINCT a.gameID) AS total_games,
    COUNT(a.goals) AS total_goals
FROM 
    leagues l
JOIN 
    appearances a ON l.leagueID = a.leagueID
GROUP BY 
    l.leagueID, l.name
ORDER BY 
    total_goals DESC;
