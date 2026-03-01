-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller



-- Sett inn testdata



-- DBA setninger (rolle: kunde, bruker: kunde_1)



-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;

SVAR:
CREATE TABLE sykkelstasjon (
    stasjon_id SERIAL PRIMARY KEY,
    navn VARCHAR(50),
    adresse VARCHAR(100),
    kapasitet INTEGER CHECK (kapasitet > 0)
);

CREATE TABLE sykkel (
    sykkel_id SERIAL PRIMARY KEY,
    serienummer VARCHAR(50),
    modell VARCHAR(50),
    status VARCHAR(20) CHECK (status IN ('ledig','utleid','defekt')),
    stasjon_id INT REFERENCES sykkelstasjon(stasjon_id)
);

CREATE TABLE kunde (
    kunde_id SERIAL PRIMARY KEY,
    fornavn VARCHAR(50),
    etternavn VARCHAR(50),
    epost VARCHAR(100),
    telefon VARCHAR(15),
    registrert_dato DATE
);

CREATE TABLE las (
    las_id SERIAL PRIMARY KEY,
    sykkel_id INTEGER REFERENCES sykkel(sykkel_id),
    status VARCHAR(20) CHECK (status IN ('ledig','utleid','defekt'))
);

CREATE TABLE utleie (
    utleie_id SERIAL PRIMARY KEY,
    kunde_id INT REFERENCES kunde(kunde_id),
    sykkel_id INT REFERENCES sykkel(sykkel_id),
    start_tid TIMESTAMP,
    slutt_tid TIMESTAMP CHECK (slutt_tid > start_tid),
    pris NUMERIC(8,2) CHECK (pris >= 0)
);

INSERT INTO sykkelstasjon (navn, adresse, kapasitet)
VALUES 
('Sentrum','Hovedgata 1',10),
('Vika','Vikaveien 5',8),
('Grunerlokka','Markveien 12',12),
('Majorstuen','Bogstadveien 20',9);

INSERT INTO sykkel (serienummer, modell, status, stasjon_id)
VALUES
('S123','Standard','ledig',1),
('S124','Standard','ledig',1),
('S125','El-sykkel','utleid',2),
('S126','El-sykkel','ledig',3),
('S127','Standard','defekt',4);

INSERT INTO kunde (fornavn, etternavn, epost, telefon, registrert_dato)
VALUES
('Ola','Nordmann','ola@example.com','+4712345678','2026-03-01'),
('Kari','Nordmann','kari@example.com','+4798765432','2026-03-01');

INSERT INTO las (sykkel_id, status)
VALUES
(1,'ledig'),
(2,'ledig'),
(3,'uteild'),  
(4,'ledig'),
(5,'defekt');

INSERT INTO utleie (kunde_id, sykkel_id, start_tid, slutt_tid, pris)
VALUES
(1,3,'2026-03-01 08:00','2026-03-01 10:00',150),
(2,2,'2026-03-01 09:00','2026-03-01 11:00',120);

CREATE ROLE kunde;
CREATE USER kunde_1 WITH PASSWORD 'passord123';
GRANT kunde TO kunde_1;

GRANT SELECT ON utleie TO kunde;
GRANT SELECT ON sykkel TO kunde;
GRANT SELECT ON sykkelstasjon TO kunde;

CREATE INDEX idx_utleie_kunde ON utleie(kunde_id);
CREATE INDEX idx_utleie_sykkel ON utleie(sykkel_id);

SELECT 'Database initialisert!!' AS status;
