-- FITNESS CLUB - Database Schema

CREATE TABLE clan (
    sifra_clana         INT PRIMARY KEY AUTO_INCREMENT,
    ime_prezime         VARCHAR(100) NOT NULL,
    broj_telefona       VARCHAR(20),
    mejl_clana          VARCHAR(100)
);

CREATE TABLE trener (
    sifra_trenera       INT PRIMARY KEY AUTO_INCREMENT,
    ime_prezime         VARCHAR(100) NOT NULL,
    strucna_sprema      VARCHAR(100)
);

CREATE TABLE trening (
    sifra_treninga      INT PRIMARY KEY AUTO_INCREMENT,
    ime_treninga        VARCHAR(100),
    sifra_trenera       INT,
    broj_mesta          INT,
    vreme_pocetka       TIME,
    vreme_kraja         TIME,
    FOREIGN KEY (sifra_trenera) REFERENCES trener(sifra_trenera)
);

CREATE TABLE trening_clan (
    sifra_clana         INT,
    sifra_treninga      INT,
    datum_prisustva     DATE,
    PRIMARY KEY (sifra_clana, sifra_treninga, datum_prisustva),
    FOREIGN KEY (sifra_clana) REFERENCES clan(sifra_clana),
    FOREIGN KEY (sifra_treninga) REFERENCES trening(sifra_treninga)
);

CREATE TABLE clanarina (
    sifra_clanarine     INT PRIMARY KEY AUTO_INCREMENT,
    tip_clanarine       VARCHAR(50),
    datum_pocetka       DATE,
    datum_isteka        DATE,
    sifra_clana         INT,
    FOREIGN KEY (sifra_clana) REFERENCES clan(sifra_clana)
);
