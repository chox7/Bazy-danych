# Zadanie 3.

1. Wybierz wszystkich urzędników (clerk).

```sql
SELECT * FROM emp WHERE job = 'CLERK';
```

2. Wybierz miasta w których firma ma swoje departamenty.

```sql
SELECT DISTINCT loc FROM dept;
```

3. Wybierz imiona, pensje i stanowisko wszystkich pracowników którzy: albo mają imię zaczynające się na literę T i zarabiają między 1500 a 2000, albo są analitykami.

```sql
SELECT ename AS imie, sal AS pensja, job AS stanowisko
FROM emp 
WHERE (ename LIKE 'T%' AND sal BETWEEN 1500 AND 2000)
OR (job = 'ANALYST');
```

4. Wybierz imiona pracowników którzy nie mają szefów ('mgr'  to skrót od  'manager').

```sql
SELECT ename AS imie FROM emp WHERE mgr IS NULL;
```

5. Wybierz numery wszystkich pracowników, którzy mają podwładnych, sortując je malejąco.

```sql
SELECT DISTINCT mgr AS numer 
FROM emp 
WHERE mgr IS NOT NULL
ORDER BY mgr DESC;
```

6. Wybierz wszystkich pracowników i dla każdego wypisz w dodatkowej kolumnie o nazwie 'starszy' 1 jeżeli ma wcześniejsze id niż jego szef, 0 jeżeli ma późniejsze, oraz '-1' jeżeli nie ma szefa.

```sql
SELECT ename,
CASE
    WHEN mgr IS NULL THEN '-1'
    WHEN empno < mgr THEN '1'
    ELSE '0'
END AS starszy
FROM emp;
```

7. Wylicz sinus liczby 3.14.

```sql
SELECT SIN(3.14) FROM dual; 
```
# Zadanie 4.
1. Do tabeli z departamentami wstaw departament IT z Warszawy.

```sql
INSERT INTO dept (deptno, dname, loc) VALUES (50, 'IT', 'WARSAW');
```

2. Dodaj siebie jako informatyka w tym departamencie bez przełożonego z pensją 2000.

```sql
INSERT INTO emp (empno, ename, job, mgr, sal, deptno) VALUES (7777, 'Chorzela', 'Junior', NULL, 2000, 50);
```

3. Daj sobie podwyżkę o kwotę podatku 23%.

```sql
UPDATE emp SET sal = sal * 1.23 WHERE ename = 'Chorzela';
```

4. Skasuj wszystkich, którzy zarabiają więcej niż Ty (więcej niż 2460).

```sql
DELETE FORM emp WHERE sal > 2460;
```

5. Okazało się, że Miller ma brata bliźniaka i przychodzą do pracy na zmianę; wstaw jego brata jako nowego pracownika z tymi samymi danymi i numerem 8015 (nie przepisuj ich jednak do zapytania) po czym osobnym zapytaniem podziel ich pensje na pół.

```sql
INSERT INTO emp (empno, ename, job, mgr, sal, comm, deptno)
(SELECT 8015, ename, job, mgr, sal, comm, deptno
FROM emp 
WHERE ename = 'Miller');
```

# Zadanie 4
Stwórz tabele Student(imie, nazwisko, nr_indeksu, plec, aktywny, data_przyjecia) nie zapominając o odpowiednich warunkach na kolumny. 

```sql
CREATE TABLE Student (
    imie VARCHAR2(10) NOT NULL,
    nazwisko VARCHAR2(10) NOT NULL,
    nr_indeksu NUMBER(6) PRIMARY KEY,
    plec CHAR(1) CHECK (plec IN ('M', 'K')), 
    aktywny CHAR(1) DEFAULT 'T' CHECK (aktywny IN ('T', 'N')),
    data_przyjecia DATE DEFAULT SYSDATE
);
```

# Zadanie 5
1. Czy w tabeli emp zawarta jest informacja o której godzinie zostali zatrudnieni wszyscy pracownicy?

- Nie. Kolumna hiredate ma typ danych DATE, zatem przechowuje tylko datę (dzień, miesiąc, rok) bez informacji o godzinie.

2. Którzy pracownicy zostali zatrudnieni w 1982?

```sql
SELECT ename, hiredate
FROM emp
WHERE TO_CHAR(hiredate, 'YYYY') = '1982';
```

3. Jaki dzień tygodnia był 11 września 2001 roku?

```sql
SELECT TO_CHAR(TO_DATE('11-SEP-2001', 'DD-MON-YYYY'), 'D') AS dzien_tygodnia FROM dual;
```

4. Dla każdego pracownika wypisz kolumnę postaci "Józek (sprzedawca), WARSZAWA".

```sql
SELECT INITCAP(ename) || ' (' || LOWER(job) || '), ' || UPPER(loc) AS dane_pracownika
FROM emp
JOIN dept ON emp.deptno = dept.deptno;
```
