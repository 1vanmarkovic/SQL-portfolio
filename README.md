# SQL Portfolio – Ivan Markovic

A collection of relational database projects designed and queried during my studies at the **Faculty of Economics, University of Belgrade** (Business Informatics, 2021–2026).

Each project includes a full database schema design and a set of SQL queries demonstrating real-world analytical thinking.

---

## Projects

| # | Domain | Tables | Key Concepts |
|---|--------|--------|--------------|
| 1 | [Banking System](#1-banking-system) | 10 | Subqueries, LEFT JOIN, DATE functions |
| 2 | [Kindergarten Management](#2-kindergarten-management) | 7 | HAVING, correlated subqueries, aggregation |
| 3 | [Bookstore & Orders](#3-bookstore--orders) | 7 | CASE WHEN, REPLACE, GROUP BY, NULL handling |
| 4 | [Fitness Club](#4-fitness-club) | 5 | BETWEEN, string functions, NOT IN logic |

---

## 1. Banking System

**Domain:** Retail banking — clients, loans, mortgages, branch offices

### Schema

```
client          (client_id, name, address, jmbg)
banker          (banker_id, name)
branch          (branch_id, address, description, price)
banker_branch   (banker_id, branch_id)
loan            (loan_id, loan_code, loan_type)
client_loan     (loan_id, client_id)
loan_details    (loan_id, loan_code, issue_date, repayment_period, amount, interest_rate)
loan_branch     (banker_id, loan_id, branch_id)
mortgage        (mortgage_id, mortgage_type)
client_mortgage (client_id, mortgage_id)
```

### Queries

```sql
-- 1. Show repayment dates for all clients who do NOT have a mortgage
SELECT DATE_ADD(kd.datum_uzimanja, INTERVAL kd.rok_otplate MONTH) AS datum_vracanja
FROM kredit_detalji kd
JOIN klijent_kredit kk ON kk.kredit_id = kd.kredit_id
LEFT JOIN klijent_hipoteka kh ON kh.klijent_id = kk.klijent_id
WHERE kh.hipoteka_id IS NULL;

-- 2. Calculate age of clients whose loan amount is less than 500,000
--    (age is derived from the Serbian JMBG national ID number)
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

-- 3. Show loan types that no client has applied for
SELECT k.tip_kredita
FROM kredit k
LEFT JOIN kredit_detalji kd ON kd.kredit_id = k.kredit_id
LEFT JOIN klijent_kredit kk ON kk.kredit_id = k.kredit_id
WHERE kk.klijent_id IS NULL;

-- 4. Count loans per branch where loan amount exceeds the minimum loan
--    amount where interest rate is below 5%
SELECT COUNT(kde.id_kredita), kde.sifra_ekspoziture
FROM kredit_bankar_ekspozitura kde
NATURAL JOIN kredit_detalji kd
WHERE kd.iznos_kredita > (
    SELECT MIN(iznos_kredita)
    FROM kredit_detalji
    WHERE kamata < 0.05
)
GROUP BY sifra_ekspoziture;
```

---

## 2. Kindergarten Management

**Domain:** Childcare — children, parents, caregivers, accommodation, payments

### Schema

```
dete          (maticni_br_deteta, ime_prezime, datum_rodjenja)
roditelj      (maticni_br_roditelja, ime_prezime, pol, mesecna_primanja, zaposlen)
smestaj       (sifra_smestaja, opis_smestaja, cena_smestaja)
vaspitac      (sifra_vaspitaca, strucna_sprema)
uplata        (sifra_smestaja, sifra_deteta, datum_uplate, iznos_uplate, sifra_roditelja)
vaspitac_dete (mat_br_deteta, sifra_vaspitaca)
dete_roditelj (mat_br_det, mat_br_rod)
```

### Queries

```sql
-- 1. Show qualifications and IDs of caregivers responsible for more than 2 children
SELECT v.strucna_sprema_vaspitaca, v.sifra_vaspitaca
FROM vaspitac v
JOIN vaspitac_dete vd ON vd.sifra_vaspitaca = v.sifra_vaspitaca
GROUP BY v.strucna_sprema, v.sifra_vaspitaca
HAVING COUNT(vd.maticni_broj_deteta) > 2;

-- 2. Count parents who paid more than 50% of accommodation cost in May 2022
--    (excluding the lowest-income parent)
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

-- 3. How many days have passed since the last payment for half-day accommodation
SELECT TIMESTAMPDIFF(DAY, MAX(u.datum_uplate), CURRENT_DATE())
FROM uplata u
NATURAL JOIN smestaj s
WHERE opis_smestaja = 'poludnevni';

-- 4. Show IDs of children whose payment exceeded any payment made in September
SELECT maticni_broj_deteta
FROM deca d
NATURAL JOIN uplata u
WHERE iznos_uplate > (
    SELECT MIN(iznos_uplate)
    FROM uplata
    WHERE MONTH(datum_uplate) = 9
);

-- 5. Show parents and payment dates where payments were less than
--    total payments made in July and August combined
SELECT r.ime_i_prezime_roditelja, u.datum_uplate
FROM roditelj r
NATURAL JOIN uplata u
WHERE iznos_uplate < (
    SELECT SUM(iznos_uplate)
    FROM uplate
    WHERE MONTH(datum_uplate) IN (7, 8)
);
```

---

## 3. Bookstore & Orders

**Domain:** Book retail — authors, books, categories, customers, orders

### Schema

```
autor           (sifra_autora, ime_autora)
knjiga          (sifra_knjige, naziv_knjige, cena_knjige, sifra_kategorije)
kategorija      (sifra_kategorije, naziv_kategorije)
kupac           (sifra_kupca, ime_kupca, adresa, mejl)
narudzbina      (sifra_narudzbine, datum_narudzbine, sifra_kupca, nacin_placanja)
narudzbina_det  (sifra_narudzbine, kolicina, sifra_knjige)
autor_knjiga    (sifra_knjige, sifra_autora)
```

### Queries

```sql
-- 1. Show author ID, category ID, and adjusted price for specific categories
SELECT sifra_autora_knjige, sifra_kategorije_knjige,
    CASE
        WHEN sifra_kategorije = 'Mem02' OR sifra_kategorije = 'Poe03'
            THEN cena_knjige * 1.2
        ELSE 0
    END AS adjusted_price
FROM autor a
NATURAL JOIN autor_knjiga ak
NATURAL JOIN knjiga k;

-- 2. Show book names without commas, and category codes without zeros
SELECT REPLACE(naziv_knjige, ',', ' '),
       REPLACE(sifra_kategorije_knjige, '0', '')
FROM knjiga;

-- 3. Total order value per order in April and May (excluding the minimum)
SELECT SUM(k.cena_knjige * nd.kolicina) AS total_value
FROM knjiga k
NATURAL JOIN narudzbina_detalji nd
NATURAL JOIN narudzbina n
WHERE MONTH(datum_narudzbine) = 4 OR MONTH(datum_narudzbine) = 3
GROUP BY sifra_narudzbine
ORDER BY 1
LIMIT 1, 999999;

-- 4. Books that have never been ordered but are available for purchase
SELECT k.naziv_knjige
FROM knjige k
LEFT JOIN narudzbina_knjiga nk ON k.sifra_knjige = nk.sifra_knjige
WHERE nk.sifra_knjige IS NULL;
```

---

## 4. Fitness Club

**Domain:** Gym management — members, trainers, training sessions, memberships

### Schema

```
clan         (sifra_clana, ime_prezime, broj_telefona, mejl_clana)
trener       (sifra_trenera, ime_prezime, strucna_sprema)
trening      (sifra_treninga, ime_treninga, sifra_trenera, broj_mesta, vreme_pocetka, vreme_kraja)
trening_clan (sifra_clana, sifra_treninga, datum_prisustva)
clanarina    (sifra_clanarine, tip_clanarine, datum_pocetka, datum_isteka, sifra_clana)
```

### Queries

```sql
-- 1. Show total training sessions attended per membership type,
--    only where count is between 2 and 5, sorted descending
SELECT c.sifra_clanarine, COUNT(p.sifra_treninga) AS broj_treninga
FROM prisustvo p
INNER JOIN clanarine c ON p.sifra_clana = c.sifra_clana
GROUP BY c.sifra_clanarine
HAVING broj_treninga BETWEEN 2 AND 5
ORDER BY broj_treninga DESC;

-- 2. Show all members who use Yahoo email and have never attended
--    a session with trainer 'Srki'
SELECT c.sifra_clana
FROM clan c
NATURAL JOIN trening_clan tr
NATURAL JOIN trening t
NATURAL JOIN trener tt
WHERE SUBSTRING(mejl_clana, 6, 16) = 'yahoo'
AND tt.ime_i_prezime != 'Srki';
```

---

## Skills Demonstrated

- **Schema design:** normalization, primary/foreign keys, junction tables, many-to-many relationships
- **Query complexity:** multi-table JOINs, correlated subqueries, aggregate functions
- **Data transformation:** DATE functions, CASE WHEN, REPLACE, SUBSTRING
- **Filtering logic:** HAVING, NULL checks, NOT IN patterns, BETWEEN

---

## About

**Ivan Markovic** | Business Informatics, Faculty of Economics, University of Belgrade  
1van2markovic3@gmail.com | 🔗 https://www.linkedin.com/in/ivan-markovic-1875262b0/
