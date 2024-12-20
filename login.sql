
-- ustawiania dlugosci linii i czestotliwosci powtarzania naglowkow w tabeli
SET linesize 150
SET pagesize 60
SET serverout ON
SET ESCAPE \

-- ustawianie na zmiennej today aktualnej daty (do SPOOL)
COLUMN date_column NEW_VALUE today
SELECT to_char(sysdate,'yyyy-mm-dd') date_column FROM dual;

-- czyszczenie ekranu
CLEAR screen

-- wyswietlenie powitania
PROMPT Witaj w SQL*Plus!
PROMPT
PROMPT Jestes w katalogu:
HOST pwd
PROMPT [Sesja jest zapisywana do pliku &today\.lst]

-- wypisanie nazw istniejacych tabel 
SELECT table_name AS "TABELE" FROM user_tables;

-- rozpoczecie zapisu do pliku YYYY-MM-DD.lst
SPOOL &today APPEND 