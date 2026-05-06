-- FITNESS CLUB - SQL Queries


-- Q1: Training count per membership type where attendance is between 2 and 5,
--     sorted by count descending

SELECT c.sifra_clanarine, COUNT(p.sifra_treninga) AS broj_treninga
FROM prisustvo p
INNER JOIN clanarine c ON p.sifra_clana = c.sifra_clana
GROUP BY c.sifra_clanarine
HAVING broj_treninga BETWEEN 2 AND 5
ORDER BY broj_treninga DESC;

-- Q2: Members with Yahoo email who have never attended a session with trainer 'Srki'

SELECT c.sifra_clana
FROM clan c
NATURAL JOIN trening_clan tr
NATURAL JOIN trening t
NATURAL JOIN trener tt
WHERE SUBSTRING(mejl_clana, 6, 16) = 'yahoo'
AND tt.ime_i_prezime != 'Srki';
