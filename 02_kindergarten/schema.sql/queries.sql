
-- KINDERGARTEN MANAGEMENT - Database Schema

CREATE TABLE dete (
    maticni_br_deteta   CHAR(13) PRIMARY KEY,
    ime_prezime         VARCHAR(100) NOT NULL,
    datum_rodjenja      DATE
);

CREATE TABLE roditelj (
    maticni_br_roditelja    CHAR(13) PRIMARY KEY,
    ime_prezime             VARCHAR(100) NOT NULL,
    pol                     CHAR(1),
    mesecna_primanja        DECIMAL(10,2),
    zaposlen                BOOLEAN
);

CREATE TABLE smestaj (
    sifra_smestaja      INT PRIMARY KEY AUTO_INCREMENT,
    opis_smestaja       VARCHAR(100),
    cena_smestaja       DECIMAL(10,2)
);

CREATE TABLE vaspitac (
    sifra_vaspitaca         INT PRIMARY KEY AUTO_INCREMENT,
    strucna_sprema_vaspitaca VARCHAR(100)
);

CREATE TABLE uplata (
    sifra_smestaja      INT,
    sifra_deteta        CHAR(13),
    datum_uplate        DATE,
    iznos_uplate        DECIMAL(10,2),
    sifra_roditelja     CHAR(13),
    FOREIGN KEY (sifra_smestaja) REFERENCES smestaj(sifra_smestaja),
    FOREIGN KEY (sifra_deteta) REFERENCES dete(maticni_br_deteta),
    FOREIGN KEY (sifra_roditelja) REFERENCES roditelj(maticni_br_roditelja)
);

CREATE TABLE vaspitac_dete (
    maticni_br_deteta   CHAR(13),
    sifra_vaspitaca     INT,
    PRIMARY KEY (maticni_br_deteta, sifra_vaspitaca),
    FOREIGN KEY (maticni_br_deteta) REFERENCES dete(maticni_br_deteta),
    FOREIGN KEY (sifra_vaspitaca) REFERENCES vaspitac(sifra_vaspitaca)
);

CREATE TABLE dete_roditelj (
    maticni_br_deteta       CHAR(13),
    maticni_br_roditelja    CHAR(13),
    PRIMARY KEY (maticni_br_deteta, maticni_br_roditelja),
    FOREIGN KEY (maticni_br_deteta) REFERENCES dete(maticni_br_deteta),
    FOREIGN KEY (maticni_br_roditelja) REFERENCES roditelj(maticni_br_roditelja)
);
