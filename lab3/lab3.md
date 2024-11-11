# Zadanie 1

1. dla każdego stanowiska wyznacz liczbę pracowników i średnią płacę

```sql
SELECT
    job AS stanowisko,
    COUNT(empno) AS liczba_pracownikow,
    AVG(SAL) AS srednia_placa
FROM emp
GROUP BY job;
```

2. dla każdego departamentu z pracownikami wypisz ilu spośród nich ma prowizję (comm)

```sql
SELECT 
    deptno AS nr_departamentu,
    COUNT(comm) AS liczba_prowizji
FROM emp
GROUP BY deptno;
```

3. znajdź maksymalną pensję na wszystkich stanowiskach na których pracuje co najmniej 3 pracowników zarabiających co najmniej 1000

```sql
SELECT 
    job AS stanowisko,
    MAX(sal) AS maksymalna_pensja
FROM emp
WHERE sal >= 1000
GROUP BY job
HAVING COUNT(sal) >= 3;
```

4. znajdź wszystkie miejsca w których rozpiętość pensji w tym samym departamencie na tym samym stanowisku przekracza 300 (nie da się bez tabeli dept, bo tam są miejsca).

```sql
SELECT 
    dept.loc AS lokalizacja
FROM 
    emp
JOIN 
    dept ON emp.deptno = dept.deptno
GROUP BY 
    emp.deptno, emp.job, dept.loc
HAVING 
    MAX(emp.sal) - MIN(emp.sal) > 300;

```

5. policz średnie zarobki w departamencie w którym pracuje szef wszystkich szefów (czyli osoba która nie ma szefa)

```sql
SELECT AVG(sal)
FROM emp
GROUP BY deptno
HAVING COUNT(mgr) < COUNT(*);
```

6. znajdź numer pracownika który ma podwładnych w różnych działach

```sql
SELECT mgr
FROM emp 
WHERE mgr IS NOT NULL
GROUP BY mgr
HAVING MIN(deptno) < MAX(deptno);
```

7. wypisz imiona oraz pensje wszystkich pracowników którzy nie mają zmiennika (osoby na tym samym stanowisku w tym samym departamencie) i posortuj ich według pensji malejąco

```sql
SELECT 
    MAX(ename),
    MAX(sal)
FROM emp 
GROUP BY deptno, job
HAVING COUNT(*) = 1
ORDER BY MAX(sal) DESC;
```


# Zadanie 2

1. Przepisz zapytanie na sumę prefiksową z JOIN-ami tak, aby liczyło sumę oddzielnie dla każdego departamentu.

```sql
SELECT 
    e.empno,
    e.deptno,
    e.ename,
    e.sal, 
    SUM(e2.sal) AS cumulative_sal
  FROM emp e
  JOIN emp e2
    ON e.deptno = e2.deptno AND (e.sal > e2.sal OR (e.sal = e2.sal AND e.empno >= e2.empno))
GROUP BY e.empno, e.deptno, e.ename, e.sal
ORDER BY e.deptno, cumulative_sal;
```

2. Przepisz zadanie 7 z Zadania 1 używając PARTITION BY aby uniknąc JOIN-a. Dla przypomnienia: wypisz imiona oraz pensje wszystkich pracowników którzy nie mają zmiennika (osoby na tym samym stanowisku w tym samym departamencie) i posortuj ich według pensji malejąco.

```sql

```

3. Dla każdego pracownika policz średnią zarobków w departamencie, w którym pracuje, a także jaka byłaby ta średnia, gdyby go zwolnić (może przydać się funkcja COALESCE(args), która zwraca pierwszy argument nie będący NULLem, np. COALESCE(NULL, 0) zwraca 0.

```sql

```

4. Dla każdego pracownika wypisz poprzednika i następnika na liście posortowanej wg pensji. Dla pierwszego pracownika poprzednik powinien być NULLem, a dla ostateniego następnik powinien być NULLem.

```sql

```
