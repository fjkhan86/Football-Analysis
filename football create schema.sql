drop table if exists teamstats;

-- Leagues table
CREATE TABLE Leagues (
    leagueID INT PRIMARY KEY,
    name VARCHAR(255),
    understatNotation VARCHAR(255)
);

-- Teams table
CREATE TABLE Teams (
    teamID INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Players table
CREATE TABLE Players (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    playerID INT,
    name VARCHAR(255)
);

-- Games table
CREATE TABLE Games (
    gameID INT PRIMARY KEY,
    leagueID INT,
    season YEAR,
    date DATE,
    homeTeamID INT,
    awayTeamID INT,
    homeGoals INT,
    awayGoals INT,
    homeProbability FLOAT,
    drawProbability FLOAT,
    awayProbability FLOAT,
    homeGoalsHalfTime INT,
    awayGoalsHalfTime INT,
    B365H FLOAT,
    B365D FLOAT,
    B365A FLOAT,
    BWH FLOAT,
    BWD FLOAT,
    BWA FLOAT,
    IWH FLOAT,
    IWD FLOAT,
    IWA FLOAT,
    PSH FLOAT,
    PSD FLOAT,
    PSA FLOAT,
    WHH FLOAT,
    WHD FLOAT,
    WHA FLOAT,
    VCH FLOAT,
    VCD FLOAT,
    VCA FLOAT,
    PSCH FLOAT,
    PSCD FLOAT,
    PSCA FLOAT,
    -- FOREIGN KEY (leagueID) REFERENCES Leagues(leagueID),
    FOREIGN KEY (homeTeamID) REFERENCES Teams(teamID),
    FOREIGN KEY (awayTeamID) REFERENCES Teams(teamID)
);

-- Appearances table
CREATE TABLE Appearances (
    gameID INT,
    playerID INT,
    goals INT,
    ownGoals INT,
    shots INT,
    xGoals FLOAT,
    xGoalsChain FLOAT,
    xGoalsBuildup FLOAT,
    assists INT,
    keyPasses INT,
    xAssists FLOAT,
    position VARCHAR(50),
    positionOrder INT,
    yellowCard INT,
    redCard INT,
    time INT,
    substituteIn INT,
    substituteOut INT,
    leagueID INT,
    PRIMARY KEY (gameID, playerID)
    -- FOREIGN KEY (gameID) REFERENCES Games(gameID)
    -- FOREIGN KEY (playerID) REFERENCES Players(playerID)
    );

-- Teamstats table
CREATE TABLE Teamstats (
    gameID INT,
    teamID INT,
    season YEAR,
    date DATE,
    location VARCHAR(50),
    goals INT,
    xGoals FLOAT,
    shots INT,
    shotsOnTarget INT,
    deep INT,
    ppda FLOAT,
    fouls INT,
    corners INT,
    yellowCards INT,
    redCards INT,
    result VARCHAR(50),
    PRIMARY KEY (gameID, teamID)
    -- FOREIGN KEY (gameID) REFERENCES Games(gameID),
    -- FOREIGN KEY (teamID) REFERENCES Teams(teamID)
);

-- Shots table
CREATE TABLE Shots (
    gameID INT,
    shooterID INT,
    assisterID INT,
    minute INT,
    situation VARCHAR(50),
    lastAction VARCHAR(50),
    shotType VARCHAR(50),
    shotResult VARCHAR(50),
    xGoal FLOAT,
    positionX INT,
    positionY INT,
    PRIMARY KEY (gameID, shooterID),
    -- FOREIGN KEY (gameID) REFERENCES Games(gameID),
);

