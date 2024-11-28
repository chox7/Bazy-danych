# Rekurencja

# Zadanie 1.
1. wypisz wszystkich podwładnych KING'a bez niego

```sql
    SELECT empno, ename, PRIOR ename AS mgr_ename, LEVEL 
    FROM emp
    WHERE ename != 'KING'
    START WITH mgr IS NULL
    CONNECT BY PRIOR empno = mgr;
```

2. wypisz wszystkich podwładnych KING'a bez BLAKE'a i jego podwładnych

```sql
    SELECT empno, ename, PRIOR ename AS mgr_ename, LEVEL 
    FROM emp
    WHERE ename != 'KING'
    START WITH mgr IS NULL
    CONNECT BY PRIOR empno = mgr
    AND ename != 'BLAKE';
```

3. wypisz wszystkich pracowników którzy mają "pod sobą" SALESMANa

```sql
    SELECT DISTINCT empno, ename, mgr, LEVEL 
    FROM emp
    WHERE LEVEl != 1
    START WITH job = 'SALESMAN'
    CONNECT BY empno = PRIOR mgr;
```

4. wypisz dla każdego pracownika sumę zarobków jego i jego podwładnych
```sql 
    SELECT 
        root_empno AS empno, 
        root_ename AS ename,
        SUM(sal) AS total_sal
    FROM (
        SELECT 
            CONNECT_BY_ROOT empno AS root_empno,
            CONNECT_BY_ROOT ename AS root_ename,
            sal
        FROM emp
        START WITH empno=empno
        CONNECT BY PRIOR empno = mgr
    )
    GROUP BY root_empno, root_ename;
```

5. wypisz imiona wszystkich podwładnych KING'a (razem z nim) w taki sposób aby uzyskać strukturę drzewa:
    ```
    KING
        JONES
            SCOTT
                ADAMS
            FORD
                SMITH
        ...
    ```

```sql
    SELECT RPAD(' ', 2 * LEVEL) || ename AS tree
    FROM emp
    START WITH mgr IS NULL
    CONNECT BY PRIOR empno = mgr;
```

# Zadanie 2.
1. Popraw poniższe zapytanie, aby poprawnie wyliczało domknięcie przechodnie dowolnie dużego grafu.

```sql
WITH path (src, tgt, step) AS (
  SELECT src, tgt, 1 FROM e
    UNION ALL
  SELECT path.src, e.tgt, step+1 FROM path, e WHERE path.tgt = e.src AND step < 5
)
SELECT DISTINCT src, tgt FROM path;
```
Poprawione:
```sql

```
2. Zrealizuj zapytania z Zadania 1 za pomocą konstrukcji WITH RECURSIVE. 

1. wypisz wszystkich podwładnych KING'a bez niego

```sql
    WITH sub (empno, ename) AS (
        SELECT empno, ename
            FROM emp 
            WHERE ename = 'KING'
        UNION ALL
        SELECT e.empno, e.ename 
            FROM emp e
            JOIN sub s ON e.mgr = s.empno
    )
    SELECT * FROM sub
    WHERE ename <> 'KING';
```

2. wypisz wszystkich podwładnych KING'a bez BLAKE'a i jego podwładnych

```sql
    WITH sub (empno, ename) AS (
        SELECT empno, ename
            FROM emp 
            WHERE ename = 'KING'
        UNION ALL
        SELECT e.empno, e.ename 
            FROM emp e
            JOIN sub s ON e.mgr = s.empno
            WHERE e.ename <> 'BLAKE'
    )
    SELECT * FROM sub
    WHERE ename <> 'KING';
```

3. wypisz wszystkich pracowników którzy mają "pod sobą" SALESMANa

```sql

```