-- ============================================
-- BANKING SYSTEM - SQL Queries
-- ============================================

-- Q1: Show repayment dates for clients who do NOT have a mortgage
SELECT DATE_ADD(kd.datum_uzimanja, INTERVAL kd.rok_otplate MONTH) AS datum_vracanja
FROM kredit_detalji kd
JOIN klijent_kredit kk ON kk.kredit_id = kd.kredit_id
LEFT JOIN klijent_hipoteka kh ON kh.klijent_id = kk.klijent_id
WHERE kh.hipoteka_id IS NULL;

-- Q2: Calculate age of clients with loan amount under 500,000
--     Age is extracted from the Serbian JMBG national ID number
SELECT TIMESTAMPDIFF(YEAR, STR_TO_DATE(
    CONCAT(
        CASE WHEN SUBSTRING(k.jmbg, 5, 1) = '0'
            THEN CONCAT('2', SUBSTRING(k.jmbg, 5, 3))
            ELSE CONCAT('1', SUBSTRING(k.jmbg, 5, 3))
        END,
        SUBSTRING(k.jmbg, 3, 2),
        SUBSTRING(k.jmbg, 1, 2)
    ), '%Y%m%d'), CURRENT_DATE()) AS Godine
FROM klijenti k
NATURAL JOIN klijent_kredit kk
NATURAL JOIN kredit_detalji kd
WHERE kd.iznos_kredita < 500000;

-- Q3: Show loan types that no client has applied for
SELECT k.tip_kredita
FROM kredit k
LEFT JOIN kredit_detalji kd ON kd.kredit_id = k.kredit_id
LEFT JOIN klijent_kredit kk ON kk.kredit_id = k.kredit_id
WHERE kk.klijent_id IS NULL;

-- Q4: Count loans per branch where loan amount exceeds minimum
--     loan amount with interest rate below 5%
SELECT COUNT(kde.id_kredita), kde.sifra_ekspoziture
FROM kredit_bankar_ekspozitura kde
NATURAL JOIN kredit_detalji kd
WHERE kd.iznos_kredita > (
    SELECT MIN(iznos_kredita)
    FROM kredit_detalji
    WHERE kamata < 0.05
)
GROUP BY sifra_ekspoziture;
