-- BOOKSTORE & ORDERS - SQL Queries


-- Q1: Author ID, category ID, and price adjusted by 20% for specific categories

SELECT sifra_autora_knjige, sifra_kategorije_knjige,
    CASE
        WHEN sifra_kategorije = 'Mem02' OR sifra_kategorije = 'Poe03'
            THEN cena_knjige * 1.2
        ELSE 0
    END AS adjusted_price
FROM autor a
NATURAL JOIN autor_knjiga ak
NATURAL JOIN knjiga k;

-- Q2: Book names without commas; category codes without zeros

SELECT REPLACE(naziv_knjige, ',', ' '),
       REPLACE(sifra_kategorije_knjige, '0', '')
FROM knjiga;

-- Q3: Total value per order in April and May, excluding the minimum value order

SELECT SUM(k.cena_knjige * nd.kolicina) AS total_value
FROM knjiga k
NATURAL JOIN narudzbina_detalji nd
NATURAL JOIN narudzbina n
WHERE MONTH(datum_narudzbine) = 4 OR MONTH(datum_narudzbine) = 3
GROUP BY sifra_narudzbine
ORDER BY 1
LIMIT 1, 999999;

-- Q4: Books that have never been ordered but are available for purchase

SELECT k.naziv_knjige
FROM knjige k
LEFT JOIN narudzbina_knjiga nk ON k.sifra_knjige = nk.sifra_knjige
WHERE nk.sifra_knjige IS NULL;
