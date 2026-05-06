CREATE TABLE klijent (
    klijent_id      INT PRIMARY KEY AUTO_INCREMENT,
    ime_prezime     VARCHAR(100) NOT NULL,
    adresa          VARCHAR(200),
    jmbg            CHAR(13) UNIQUE NOT NULL
);

CREATE TABLE bankar (
    bankar_id       INT PRIMARY KEY AUTO_INCREMENT,
    ime_prezime     VARCHAR(100) NOT NULL
);

CREATE TABLE ekspozitura (
    ekspozitura_id  INT PRIMARY KEY AUTO_INCREMENT,
    adresa          VARCHAR(200)
);

CREATE TABLE bankar_ekspozitura (
    bankar_id       INT,
    ekspozitura_id  INT,
    PRIMARY KEY (bankar_id, ekspozitura_id),
    FOREIGN KEY (bankar_id) REFERENCES bankar(bankar_id),
    FOREIGN KEY (ekspozitura_id) REFERENCES ekspozitura(ekspozitura_id)
);

CREATE TABLE kredit (
    kredit_id       INT PRIMARY KEY AUTO_INCREMENT,
    sifra_kredita   VARCHAR(20),
    tip_kredita     VARCHAR(50)
);

CREATE TABLE klijent_kredit (
    kredit_id       INT,
    klijent_id      INT,
    PRIMARY KEY (kredit_id, klijent_id),
    FOREIGN KEY (kredit_id) REFERENCES kredit(kredit_id),
    FOREIGN KEY (klijent_id) REFERENCES klijent(klijent_id)
);

CREATE TABLE kredit_detalji (
    kredit_id           INT PRIMARY KEY,
    sifra_kredita       VARCHAR(20),
    datum_uzimanja      DATE,
    rok_otplate         INT,         
    iznos_kredita       DECIMAL(15,2),
    kamata              DECIMAL(5,4),
    FOREIGN KEY (kredit_id) REFERENCES kredit(kredit_id)
);

CREATE TABLE kredit_bankar_ekspozitura (
    bankar_id       INT,
    kredit_id       INT,
    ekspozitura_id  INT,
    PRIMARY KEY (bankar_id, kredit_id, ekspozitura_id),
    FOREIGN KEY (bankar_id) REFERENCES bankar(bankar_id),
    FOREIGN KEY (kredit_id) REFERENCES kredit(kredit_id),
    FOREIGN KEY (ekspozitura_id) REFERENCES ekspozitura(ekspozitura_id)
);

CREATE TABLE hipoteka (
    hipoteka_id     INT PRIMARY KEY AUTO_INCREMENT,
    vrsta_hipoteke  VARCHAR(100)
);

CREATE TABLE klijent_hipoteka (
    klijent_id      INT,
    hipoteka_id     INT,
    PRIMARY KEY (klijent_id, hipoteka_id),
    FOREIGN KEY (klijent_id) REFERENCES klijent(klijent_id),
    FOREIGN KEY (hipoteka_id) REFERENCES hipoteka(hipoteka_id)
);
