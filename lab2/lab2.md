# Zadanie 1.
1. W jakim mieście pracują sprzedawcy (salesman)?

```sql
SELECT DISTINCT dept.loc
FROM emp
JOIN dept
ON emp.deptno = dept.deptno
WHERE emp.job = 'SALESMAN';
```

2. Dla każdego pracownika podaj nazwisko jego przełożonego (lub NULL jeżeli nie ma szefa).

```sql
SELECT
    employer.ename AS employer_name,
    CASE
        WHEN manager.ename IS NULL THEN NULL
        ELSE manager.ename
    END AS manager_name
FROM emp employer
LEFT JOIN emp manager
ON employer.mgr = manager.empno;
```

3. Dla każdego pracownika podaj miasto w jakim pracuje jego przełożony (lub NULL jeżeli nie ma szefa).

```sql
SELECT 
    e.ename AS employer_name,
    CASE
        WHEN m.ename IS NULL THEN NULL
        ELSE d.loc
    END AS manager_location
FROM emp e
LEFT JOIN emp m
ON e.mgr = m.empno
LEFT JOIN dept d
ON m.deptno = d.deptno;
```

4. W którym departamencie nikt nie pracuje?

```sql
SELECT 
    dept.deptno, 
    dept.dname
FROM dept
LEFT JOIN emp 
ON dept.deptno = emp.deptno
WHERE emp.deptno IS NULL;
```

5. Dla każdego pracownika wypisz imię jego szefa jeżeli (ten szef) zarabia więcej niż 3000 (lub NULL jeżeli nie ma takiego szefa).

```sql
SELECT
    e.ename AS employer_name,
    CASE
        WHEN (m.ename IS NULL OR m.sal <= 3000) THEN NULL
        ELSE m.ename
    END AS manager_name
FROM emp e
LEFT JOIN emp m
ON e.mgr = m.empno;
```

6. Który pracownik pracuje w firmie najdłużej?

```sql
SELECT * from emp WHERE hiredate = (SELECT MIN(hiredate) FROM emp);