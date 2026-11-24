/* ============================================================================
   CSC6302 Database Principles
   Intermediate SQL – Practice Queries
   VideoGameSystems Database
   Michael Thomas
   ============================================================================ */

USE VideoGameSystems;


/* QUESTION 1
   Using a join approach, get the names of all the games, along with their
   console name and series name. Do not show games lacking a console or series.
*/
SELECT
    G.GameName,
    G.ConsoleName,
    S.SeriesName
FROM Game G
INNER JOIN Series S ON G.Series = S.Id
WHERE G.ConsoleName IS NOT NULL
ORDER BY G.GameName;


/* QUESTION 2
   Using a subquery approach, get the names of all the games, along with their
   console name and series name. Do not show games lacking a console or series.
*/
SELECT
    G.GameName,
    G.ConsoleName,
    (SELECT S.SeriesName
     FROM Series S
     WHERE S.Id = G.Series) AS SeriesName
FROM Game G
WHERE G.Series IS NOT NULL
  AND G.ConsoleName IS NOT NULL
ORDER BY G.GameName;


/* QUESTION 3
   Using a join approach, get the names of all the games, along with their
   console name, that do not have a series.
*/
SELECT
    G.GameName,
    G.ConsoleName
FROM Game G
LEFT OUTER JOIN Series S ON G.Series = S.Id
WHERE S.Id IS NULL
ORDER BY G.GameName;


/* QUESTION 4
   Using a subquery approach, get the names of all the games, along with their
   console name, that do not have a series.
*/
SELECT
    G.GameName,
    G.ConsoleName
FROM Game G
WHERE G.Series IS NULL
   OR G.Series NOT IN (SELECT Id FROM Series)
ORDER BY G.GameName;


/* QUESTION 5
   How many consoles did the Animal Crossing Series release a title on?
*/
SELECT
    COUNT(DISTINCT G.ConsoleName) AS ConsoleCount
FROM Game G
INNER JOIN Series S ON G.Series = S.Id
WHERE S.SeriesName = 'Animal Crossing';


/* QUESTION 6
   How many consoles did the Animal Crossing Series not release a title on?
*/
SELECT
    COUNT(*) AS ConsoleCount
FROM Console C
WHERE C.ConsoleName NOT IN (
    SELECT DISTINCT G.ConsoleName
    FROM Game G
    INNER JOIN Series S ON G.Series = S.Id
    WHERE S.SeriesName = 'Animal Crossing'
);


/* QUESTION 7
   What consoles have a game that was released in the Sonic Series?
*/
SELECT DISTINCT
    G.ConsoleName
FROM Game G
INNER JOIN Series S ON G.Series = S.Id
WHERE S.SeriesName = 'Sonic'
ORDER BY G.ConsoleName;


/* QUESTION 8
   What consoles do not have a game that was released in the Sonic Series?
*/
SELECT
    C.ConsoleName
FROM Console C
LEFT OUTER JOIN (
    SELECT DISTINCT G.ConsoleName
    FROM Game G
    INNER JOIN Series S ON G.Series = S.Id
    WHERE S.SeriesName = 'Sonic'
) AS SonicConsoles ON C.ConsoleName = SonicConsoles.ConsoleName
WHERE SonicConsoles.ConsoleName IS NULL
ORDER BY C.ConsoleName;


/* QUESTION 9
   How many games have been released on each console?
   Show the name of the console and the total number of released games.
*/
SELECT
    ConsoleName,
    COUNT(*) AS GameCount
FROM Game
GROUP BY ConsoleName
ORDER BY GameCount DESC, ConsoleName;


/* QUESTION 10
   What series has released the most games?
   Show the console name, series name, and total number of
   released games in that series.
*/
WITH SeriesGameCounts AS (
    SELECT
        S.Id,
        S.SeriesName,
        COUNT(*) AS GameCount
    FROM Game G
    INNER JOIN Series S ON G.Series = S.Id
    GROUP BY S.Id, S.SeriesName
),
TopSeries AS (
    SELECT
        Id,
        SeriesName,
        GameCount
    FROM SeriesGameCounts
    WHERE GameCount = (
        SELECT MAX(GameCount)
        FROM SeriesGameCounts
    )
)
SELECT DISTINCT
    C.ConsoleName,
    TS.SeriesName,
    TS.GameCount
FROM TopSeries TS
INNER JOIN Game G ON TS.Id = G.Series
INNER JOIN Console C ON G.ConsoleName = C.ConsoleName
ORDER BY C.ConsoleName;
