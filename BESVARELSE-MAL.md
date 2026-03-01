# Besvarelse - Refleksjon og Analyse

**Student:** Mohammad Saad Shahid

**Studentnummer:** [Ditt studentnummer]

**Dato:** 01.03.2026

---

## Del 1: Datamodellering

### Oppgave 1.1: Entiteter og attributter

**Identifiserte entiteter:**

Utleie
Sykkel
Sykkelstasjon
Kunde
Lås

**Attributter for hver entitet:**

Utleie:
utleie_id
kunde_id (FK)
sykkel_id (FK)
start_tid
slutt_tid
pris

Sykkel:
sykkel_id
serienummer
modell
status
stasjon_id

Sykkelstasjon:
stasjon_id
navn
adresse
kapasitet

Kunde:
kunde_id
fornavn
etternavn
epost
telefon
registrert_dato

Lås:
lås_id
sykkel_id
status

---

### Oppgave 1.2: Datatyper og `CHECK`-constraints

**Valgte datatyper og begrunnelser:**

Primærnøkler:
INTEGER (SERIAL)
Jeg valgte dette fordi det er enkelt og fungerer bra i Postgres.

fornavn, etternavn:
VARCHAR(50)
Virker som passe lengde.

epost:
VARCHAR(100)
Kunne kanskje hatt 150, men 100 holder i de fleste tilfeller.

telefon:
VARCHAR(15)
Siden det kan være +47 osv.

status:
VARCHAR(20)
Brukes for å lagre f.eks. "ledig", "utleid", "defekt".

pris:
NUMERIC(8,2)
Valgte NUMERIC i stedet for FLOAT for å unngå avrundingsfeil.

start_tid og slutt_tid:
TIMESTAMP

kapasitet:
INTEGER

**`CHECK`-constraints:**

kapasitet > 0
pris >= 0
slutt_tid > start_tid
status IN ('ledig', 'utleid', 'defekt')
Jeg er litt usikker på om status burde vært egen tabell i stedet, men valgte CHECK for enkelhet

**ER-diagram:**

Jeg klarte ikke å løse hele oppgaven, men dette er det jeg klarte å gjøre:

KUNDE:
kunde_id (PK)
fornavn
etternavn
epost

SYKKEL:
sykkel_id (PK)
serienummer
status
stasjon_id (FK)

SYKKELSTASJON:
stasjon_id (PK)
navn
adresse
kapasitet

LÅS:
lås_id (PK)
sykkel_id (FK)
status

UTLEIE:
utleie_id (PK)
kunde_id (FK)
sykkel_id (FK)
start_tid
slutt_tid
pris

---

### Oppgave 1.3: Primærnøkler

**Valgte primærnøkler og begrunnelser:**

kunde_id
sykkel_id
stasjon_id
lås_id
utleie_id

Jeg vurderte å bruke epost som naturlig nøkkel, men det kan endres, så det er ikke så lurt.

**Naturlige vs. surrogatnøkler:**

Jeg har brukt surrogatnøkler nesten overalt. Det gjør joins enklere og mer effektivt.
Ulempen er at de ikke har noen “mening” i seg selv.

**Oppdatert ER-diagram:**

skjønte ikke denne 

---

### Oppgave 1.4: Forhold og fremmednøkler

**Identifiserte forhold og kardinalitet:**

Forhold:
En kunde kan ha mange utleier
En sykkel kan brukes i mange utleier (over tid)
En stasjon har mange sykler
En sykkel har én lås

**Fremmednøkler:**

Fremmednøkler:
utleie.kunde_id → kunde.kunde_id
utleie.sykkel_id → sykkel.sykkel_id
sykkel.stasjon_id → sykkelstasjon.stasjon_id
lås.sykkel_id → sykkel.sykkel_id

**Oppdatert ER-diagram:**

skjønte ikke denne

---

### Oppgave 1.5: Normalisering

**Vurdering av 1. normalform (1NF):**

1NF fordi kolonnene inneholder atomiske verdier

**Vurdering av 2. normalform (2NF):**

2NF fordi hver tabell bruker engel primærnøkkel og derfor er det ikke delvis avhengig

**Vurdering av 3. normalform (3NF):**

[Skriv ditt svar her - forklar om datamodellen din tilfredsstiller 3NF og hvorfor]

**Eventuelle justeringer:**

3NF fordi det ikke er noen transitive avhengiheter da f.eks stasjonsavn ikke lagres i Sykkel

---

## Del 2: Database-implementering

### Oppgave 2.1: SQL-skript for database-initialisering

**Plassering av SQL-skript:**

[Bekreft at du har lagt SQL-skriptet i `init-scripts/01-init-database.sql`] Yes den ligger der nå

**Antall testdata:**

skjønte ikke oppgaven

- Kunder: [antall]
- Sykler: [antall]
- Sykkelstasjoner: [antall]
- Låser: [antall]
- Utleier: [antall]

---

### Oppgave 2.2: Kjøre initialiseringsskriptet

**Dokumentasjon av vellykket kjøring:**

Dokumentasjon: “Jeg kjørte skriptet i docker-compose. Fikk ‘CREATE TABLE’ på alle tabeller og til slutt ‘Database initialisert!!’”

**Spørring mot systemkatalogen:**

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Resultat:**

kunde
sykkel
sykkelstasjon
utleie
las

---

## Del 3: Tilgangskontroll

### Oppgave 3.1: Roller og brukere

**SQL for å opprette rolle:**

Rolle: CREATE ROLE kunde;

**SQL for å opprette bruker:**

Bruker: CREATE USER kunde_1 WITH PASSWORD 'passord123';


**SQL for å tildele rettigheter:**

Rettigheter: GRANT SELECT ON utleie TO kunde; GRANT kunde TO kunde_1;

---

### Oppgave 3.2: Begrenset visning for kunder

**SQL for VIEW:**

CREATE VIEW mine_utleier AS
SELECT *
FROM utleie
WHERE kunde_id = 1;  -- enkel studentversjon

**Ulempe med VIEW vs. POLICIES:**

Jeg vet ikke svaret på denne
[Skriv ditt svar her - diskuter minst én ulempe med å bruke VIEW for autorisasjon sammenlignet med POLICIES]

---

## Del 4: Analyse og Refleksjon

### Oppgave 4.1: Lagringskapasitet

**Gitte tall for utleierate:**

- Høysesong (mai-september): 20000 utleier/måned
- Mellomsesong (mars, april, oktober, november): 5000 utleier/måned
- Lavsesong (desember-februar): 500 utleier/måned

**Totalt antall utleier per år:**

[Skriv din utregning her]
20000×5 + 5000×4 + 500×3 = 121500

**Estimat for lagringskapasitet:**

ca 12mb kanskje

**Totalt for første år:**

tror det kanskje er sånn 20-25mb

---

### Oppgave 4.2: Flat fil vs. relasjonsdatabase

**Analyse av CSV-filen (`data/utleier.csv`):**

**Problem 1: Redundans**

Kundeinfo gjentas i hver rad

**Problem 2: Inkonsistens**

Telefon endres, må oppdateres flere steder

**Problem 3: Oppdateringsanomalier**

slette-, innsettings-, oppdateringsanomalier

**Fordeler med en indeks:**

Raskere søk på kunde_id

**Case 1: Indeks passer i RAM**

[Skriv ditt svar her - forklar hvordan indeksen fungerer når den passer i minnet]

**Case 2: Indeks passer ikke i RAM**

[Skriv ditt svar her - forklar hvordan flettesortering kan brukes]

**Datastrukturer i DBMS:**

[Skriv ditt svar her - diskuter B+-tre og hash-indekser]

---

### Oppgave 4.3: Datastrukturer for logging

**Foreslått datastruktur:**

LSM-tree

**Begrunnelse:**

Passer bra når man har mange skrive-operasjoner.
Skriver først i minne, så flettes det til disk senere

**Skrive-operasjoner:**

Håndteres veldig effektivt fordi nye logging-events først legges i minnet (memtable)

**Lese-operasjoner:**

Lesepårasjoner er mer sjelden, men da det skjer leses det fra minne og disk som kalles for merge.
Det er litt tregere en B+-tree for range-søk, men funker greit fordi looging ikke skjer ofte i sanntid.

---

### Oppgave 4.4: Validering i flerlags-systemer

**Hvor bør validering gjøres:**

[Skriv ditt svar her - argumenter for validering i ett eller flere lag]

**Validering i nettleseren:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i applikasjonslaget:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i databasen:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Konklusjon:**

[Skriv ditt svar her - oppsummer hvor validering bør gjøres og hvorfor]

---

### Oppgave 4.5: Refleksjon over læringsutbytte

**Hva har du lært så langt i emnet:**

[Skriv din refleksjon her - diskuter sentrale konsepter du har lært]

**Hvordan har denne oppgaven bidratt til å oppnå læringsmålene:**

[Skriv din refleksjon her - koble oppgaven til læringsmålene i emnet]

Se oversikt over læringsmålene i en PDF-fil i Canvas https://oslomet.instructure.com/courses/33293/files/folder/Plan%20v%C3%A5ren%202026?preview=4370886

**Hva var mest utfordrende:**

[Skriv din refleksjon her - diskuter hvilke deler av oppgaven som var mest krevende]

**Hva har du lært om databasedesign:**

[Skriv din refleksjon her - reflekter over prosessen med å designe en database fra bunnen av]

---

## Del 5: SQL-spørringer og Automatisk Testing

**Plassering av SQL-spørringer:**

[Bekreft at du har lagt SQL-spørringene i `test-scripts/queries.sql`]


**Eventuelle feil og rettelser:**

[Skriv ditt svar her - hvis noen tester feilet, forklar hva som var feil og hvordan du rettet det]

---

## Del 6: Bonusoppgaver (Valgfri)

### Oppgave 6.1: Trigger for lagerbeholdning

**SQL for trigger:**

```sql
[Skriv din SQL-kode for trigger her, hvis du har løst denne oppgaven]
```

**Forklaring:**

[Skriv ditt svar her - forklar hvordan triggeren fungerer]

**Testing:**

[Skriv ditt svar her - vis hvordan du har testet at triggeren fungerer som forventet]

---

### Oppgave 6.2: Presentasjon

**Lenke til presentasjon:**

[Legg inn lenke til video eller presentasjonsfiler her, hvis du har løst denne oppgaven]

**Hovedpunkter i presentasjonen:**

[Skriv ditt svar her - oppsummer de viktigste punktene du dekket i presentasjonen]

---

**Slutt på besvarelse**
