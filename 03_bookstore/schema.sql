-- BOOKSTORE & ORDERS - Database Schema

CREATE TABLE kategorija (
    sifra_kategorije    VARCHAR(10) PRIMARY KEY,
    naziv_kategorije    VARCHAR(100)
);

CREATE TABLE knjiga (
    sifra_knjige        INT PRIMARY KEY AUTO_INCREMENT,
    naziv_knjige        VARCHAR(200) NOT NULL,
    cena_knjige         DECIMAL(10,2),
    sifra_kategorije    VARCHAR(10),
    FOREIGN KEY (sifra_kategorije) REFERENCES kategorija(sifra_kategorije)
);

CREATE TABLE autor (
    sifra_autora        INT PRIMARY KEY AUTO_INCREMENT,
    ime_autora          VARCHAR(100) NOT NULL
);

CREATE TABLE autor_knjiga (
    sifra_knjige        INT,
    sifra_autora        INT,
    PRIMARY KEY (sifra_knjige, sifra_autora),
    FOREIGN KEY (sifra_knjige) REFERENCES knjiga(sifra_knjige),
    FOREIGN KEY (sifra_autora) REFERENCES autor(sifra_autora)
);

CREATE TABLE kupac (
    sifra_kupca         INT PRIMARY KEY AUTO_INCREMENT,
    ime_kupca           VARCHAR(100) NOT NULL,
    adresa              VARCHAR(200),
    mejl                VARCHAR(100)
);

CREATE TABLE narudzbina (
    sifra_narudzbine    INT PRIMARY KEY AUTO_INCREMENT,
    datum_narudzbine    DATE,
    sifra_kupca         INT,
    nacin_placanja      VARCHAR(50),
    FOREIGN KEY (sifra_kupca) REFERENCES kupac(sifra_kupca)
);

CREATE TABLE narudzbina_detalji (
    sifra_narudzbine    INT,
    sifra_knjige        INT,
    kolicina            INT,
    PRIMARY KEY (sifra_narudzbine, sifra_knjige),
    FOREIGN KEY (sifra_narudzbine) REFERENCES narudzbina(sifra_narudzbine),
    FOREIGN KEY (sifra_knjige) REFERENCES knjiga(sifra_knjige)
);
