-- KINDERGARTEN MANAGEMENT - SQL Queries


-- Q1: Show qualifications and IDs of caregivers responsible for more than 2 children

SELECT v.strucna_sprema_vaspitaca, v.sifra_vaspitaca
FROM vaspitac v
JOIN vaspitac_dete vd ON vd.sifra_vaspitaca = v.sifra_vaspitaca
GROUP BY v.strucna_sprema_vaspitaca, v.sifra_vaspitaca
HAVING COUNT(vd.maticni_broj_deteta) > 2;

-- Q2: Count parents who paid more than 50% of accommodation cost in May 2022
--     Exclude the lowest-income parent

SELECT COUNT(DISTINCT(sifra_roditelja))
FROM roditelji r
NATURAL JOIN smestaj s
NATURAL JOIN uplata u
WHERE u.iznos_uplate > (
    SELECT s.cena_smestaja * 0.5
    FROM smestaj
    WHERE MONTH(u.datum_uplate) = 5
    AND YEAR(u.datum_uplate) = 2022
)
AND r.mesecna_primanja != (
    SELECT MIN(r.mesecna_primanja) FROM roditelji r
);

-- Q3: Days since last payment for half-day accommodation

SELECT TIMESTAMPDIFF(DAY, MAX(u.datum_uplate), CURRENT_DATE())
FROM uplata u
NATURAL JOIN smestaj s
WHERE opis_smestaja = 'poludnevni';

-- Q4: Children whose payment exceeded any September payment

SELECT maticni_broj_deteta
FROM deca d
NATURAL JOIN uplata u
WHERE iznos_uplate > (
    SELECT MIN(iznos_uplate)
    FROM uplata
    WHERE MONTH(datum_uplate) = 9
);

-- Q5: Parents and payment dates where payment was less than
--     total payments in July and August combined

SELECT r.ime_i_prezime_roditelja, u.datum_uplate
FROM roditelj r
NATURAL JOIN uplata u
WHERE iznos_uplate < (
    SELECT SUM(iznos_uplate)
    FROM uplate
    WHERE MONTH(datum_uplate) IN (7, 8)
);
