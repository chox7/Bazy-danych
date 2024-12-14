
/home/students/inf/t/tk448325$
/home/students/inf/m/mk448316/studia
/home/students/inf/m/mj406163

# Zadanie 1.  
Stwórz tabelę E poleceniem powyżej, zaludnij ją korzystając ze skryptu ba10k.sql i odśwież statystyki. Obejrzyj plan zapytania powyżej, zmieniając na różne sposoby kolejność aliasów (bez zmiany warunku w klauzuli WHERE). Czy plan zmienia się w jakikolwiek sposób? 

```sql
CREATE TABLE E (SRC NUMBER, TGT NUMBER);
@lab5/ba10k

EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT count(*)
FROM E e, E f, E g
WHERE e.tgt = f.src AND f.tgt = g.src;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());


EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT count(*)
FROM E e, E g, E f
WHERE e.tgt = f.src AND f.tgt = g.src;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```


# Zadanie 2. Porównaj plan zapytania powyżej ze wskazówką dla optymalizatora i bez. Dlaczego wersja ze wskazówką działa tak wolno?

```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT /*+ ORDERED */ count(*)
FROM e e, e g, e f
WHERE e.tgt = f.src AND f.tgt = g.src;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());


EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT count(*)
FROM e e, e g, e f
WHERE e.tgt = f.src AND f.tgt = g.src;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```

# Zadanie 3. 
Zmodyfikuj zapytanie powyżej (bez wskazówki dla optymalizatora) na trzy sposoby, tak aby zliczało ścieżki długości 5, które: (a) zaczynają się w wierzchołku 0; (b) kończą się w wierzchołku o numerze mniejszym niż 50; (c) spełniają oba powyższe warunki. Zanim wykonasz te zapytania, zastanów się, które powinno działać najszybciej i dlaczego. Sprawdź, jak jest faktycznie: wykorzystaj dane z pliku ba100k.sql (pamiętaj o odświeżeniu statystyk). Obejrzyj plany zapytań i zastanów się, jaka może być tego przyczyna. 
(a):
```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT count(*)
FROM e e, e f, e g, e h, e i
WHERE e.src = 0 
    AND e.tgt = f.src 
    AND f.tgt = g.src
    AND g.tgt = h.src
    AND h.tgt = i.src;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```

(b): 
```sql 
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT count(*)
FROM e e, e f, e g, e h, e i
WHERE e.tgt = f.src 
    AND f.tgt = g.src
    AND g.tgt = h.src
    AND h.tgt = i.src
    AND i.tgt < 50;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```

(c):
```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT count(*)
FROM e e, e f, e g, e h, e i
WHERE e.src = 0 
    AND e.tgt = f.src 
    AND f.tgt = g.src
    AND g.tgt = h.src
    AND h.tgt = i.src
    AND i.tgt < 50;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```

# Zadanie 4. 
Jaka byłaby optymalna kolejność wyliczania złączeń w zapytaniu z punktu (c) z poprzedniego zadania? Czy da się napisać zapytanie, które tę kolejność wymusi? A ciąg zapytań wykorzystujący pomocnicze tabele? Czy to się opłaca?
```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT /*+ LEADING(e i h g f) */ count(*)
FROM e e, e f, e g, e h, e i
WHERE e.src = 0 
    AND e.tgt = f.src 
    AND f.tgt = g.src
    AND g.tgt = h.src
    AND h.tgt = i.src
    AND i.tgt < 50;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```

# Zadanie 5. 
Zbadaj, czy indeks faktycznie przyspiesza to zapytanie. (Aby lepiej zaobserwować różnicę, możesz dokonać cudownego rozmnożenia danych w tabeli e wykonując kilkukrotnie poleceniem  INSERT INTO e SELECT * FROM e;, ale zanim to zrobisz, skopiuj sobie tabelę  e na boku poleceniem CREATE TABLE kopia_E AS SELECT * FROM e; na wszelki wypadek. Pamiętaj o odświeżeniu statystyk. )

```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT count(*)
FROM e
WHERE e.src=0;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```


```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);
CREATE INDEX e_src_idx ON e(src);

EXPLAIN PLAN FOR 
SELECT count(*)
FROM e
WHERE e.src=0;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```











# MIKROPROJEKT
```sql
CREATE TABLE E (SRC NUMBER, TGT NUMBER);
@lab5/d10k
```

```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
SELECT count(*)  
FROM e e, e f, e g, e h, e i
WHERE e.src=0 
    AND e.tgt=f.src 
    AND f.tgt=g.src 
    AND g.tgt=h.src 
    AND h.tgt=i.src;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```
## CREATE INDEX 
```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

CREATE INDEX e_src_idx ON e(src);

EXPLAIN PLAN FOR 
SELECT count(*)  
FROM e e, e f, e g
WHERE e.src=0 
    AND e.tgt=f.src 
    AND f.tgt=g.src 
    AND g.tgt=h.src 
    AND h.tgt=i.src;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```
## 
```sql
EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
WITH
step1 AS (
    SELECT tgt
    FROM e
    WHERE src = 0
    GROUP BY tgt
),
step2 AS (
    SELECT e.tgt
    FROM e
    JOIN step1 s1 ON e.src = s1.tgt
),
step3 AS (
    SELECT e.tgt
    FROM e
    JOIN step2 s2 ON e.src = s2.tgt
),
step4 AS (
    SELECT e.tgt
    FROM e
    JOIN step3 s3 ON e.src = s3.tgt
),
step5 AS (
    SELECT e.tgt
    FROM e
    JOIN step4 s4 ON e.src = s4.tgt
)
SELECT COUNT(*)
FROM step5;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
```


WITH step1 AS (
    SELECT e.tgt AS node
    FROM e
    WHERE e.src = 0
),
step2 AS (
    SELECT e.src, e.tgt
    FROM e
    JOIN step1 s1 ON e.src = s1.node
),
step3 AS (
    SELECT e.src, e.tgt, e.tgt AS next_node
    FROM e
    JOIN step2 s2 ON e.src = s2.tgt
),
step4 AS (
    SELECT e.src, e.tgt, e.tgt AS next_node, e.tgt AS end_node
    FROM e
    JOIN step3 s3 ON e.src = s3.tgt
)
SELECT COUNT(end_node)
FROM step4;










xd



SELECT tgt
FROM   e
WHERE  LEVEL = 5
START WITH src = 0
CONNECT BY PRIOR tgt = src
GROUP BY tgt;z







WITH path1 AS (
    -- Step 1: Start with all edges from the source node (e.g., 0)
    SELECT 
        src AS node1, 
        tgt AS node2, 
        TO_CHAR(src) || ',' || TO_CHAR(tgt) AS visited_nodes
    FROM e
    WHERE src = 0
),
path2 AS (
    -- Step 2: Extend paths from path1
    SELECT 
        p1.node1, 
        e.tgt AS node2, 
        p1.visited_nodes || ',' || TO_CHAR(e.tgt) AS visited_nodes
    FROM path1 p1
    JOIN e ON p1.node2 = e.src
    WHERE INSTR(p1.visited_nodes, ',' || TO_CHAR(e.tgt) || ',') = 0
),
path3 AS (
    -- Step 3: Extend paths from path2
    SELECT 
        p2.node1, 
        e.tgt AS node2, 
        p2.visited_nodes || ',' || TO_CHAR(e.tgt) AS visited_nodes
    FROM path2 p2
    JOIN e ON p2.node2 = e.src
    WHERE INSTR(p2.visited_nodes, ',' || TO_CHAR(e.tgt) || ',') = 0
),
path4 AS (
    -- Step 4: Extend paths from path3
    SELECT 
        p3.node1, 
        e.tgt AS node2, 
        p3.visited_nodes || ',' || TO_CHAR(e.tgt) AS visited_nodes
    FROM path3 p3
    JOIN e ON p3.node2 = e.src
    WHERE INSTR(p3.visited_nodes, ',' || TO_CHAR(e.tgt) || ',') = 0
),
path5 AS (
    -- Step 5: Extend paths from path4
    SELECT 
        p4.node1, 
        e.tgt AS node2, 
        p4.visited_nodes || ',' || TO_CHAR(e.tgt) AS visited_nodes
    FROM path4 p4
    JOIN e ON p4.node2 = e.src
    WHERE INSTR(p4.visited_nodes, ',' || TO_CHAR(e.tgt) || ',') = 0
)
-- Final step: Count paths of length 5
SELECT COUNT(*) AS num_paths
FROM path5;



# CORRECT:
10 min
SELECT count(*)  
FROM e e, e f, e g, e h, e i
WHERE e.src=0 AND e.tgt=f.src AND f.tgt=g.src AND g.tgt=h.src AND h.tgt=i.src;




SELECT COUNT(*) AS num_paths
FROM e e1
RIGHT JOIN e e2 ON e1.tgt = e2.src
RIGHT JOIN e e3 ON e2.tgt = e3.src
RIGHT JOIN e e4 ON e3.tgt = e4.src
RIGHT JOIN e e5 ON e4.tgt = e5.src
WHERE e1.src = 0
  AND e2.src IS NOT NULL
  AND e3.src IS NOT NULL
  AND e4.src IS NOT NULL
  AND e5.src IS NOT NULL;


2 min 
WITH path1 AS (
    SELECT 
        tgt AS node2
    FROM e
    WHERE src = 0
),
path2 AS (
    SELECT 
        e.tgt AS node2
    FROM e 
    RIGHT JOIN path1 p1
    ON p1.node2 = e.src
    WHERE node2 IS NOT NULL
),
path3 AS (
    SELECT 
        e.tgt AS node2
    FROM e 
    RIGHT JOIN path2 p2
    ON p2.node2 = e.src
    WHERE node2 IS NOT NULL
),
path4 AS (
    SELECT 
        e.tgt AS node2
    FROM e 
    RIGHT JOIN path3 p3
    ON p3.node2 = e.src
    WHERE node2 IS NOT NULL
),
path5 AS (
    SELECT 
        e.tgt AS node2
    FROM e 
    RIGHT JOIN path4 p4
    ON p4.node2 = e.src
    WHERE node2 IS NOT NULL
)
SELECT COUNT(*) AS num_paths
FROM path5
WHERE node2 IS NOT NULL;


WITH path1 AS (
    SELECT 
        tgt AS node2
    FROM e
    WHERE src = 0
),
path2 AS (
    SELECT 
        e.tgt AS node2
    FROM e 
    JOIN path1 p1
    ON p1.node2 = e.src
),
path3 AS (
    SELECT 
        e.tgt AS node2
    FROM e 
    JOIN path2 p2
    ON p2.node2 = e.src
),
path4 AS (
    SELECT 
        e.tgt AS node2
    FROM e 
    JOIN path3 p3
    ON p3.node2 = e.src
),
path5 AS (
    SELECT 
        e.tgt AS node2
    FROM e 
    JOIN path4 p4
    ON p4.node2 = e.src
)
SELECT COUNT(*) AS num_paths
FROM path5
WHERE node2 IS NOT NULL;




WITH paths (current_vertex, next_vertex, path_length) AS (
    -- Base case: Start at node 0, with path length 1
    SELECT src, tgt, 1
    FROM e
    WHERE src = 0
    UNION ALL
    -- Recursive case: Extend the path
    SELECT p.next_vertex, e.tgt, p.path_length + 1
    FROM paths p
    JOIN e ON p.next_vertex = e.src
    WHERE p.path_length < 5  -- Limit the path length to n
)
SELECT COUNT(*) AS path_count
FROM paths
WHERE path_length = 5;




SELECT COUNT(*) AS num_paths
FROM (
    SELECT src, tgt, LEVEL AS path_length
    FROM e
    START WITH src = 0
    CONNECT BY PRIOR tgt = src
    AND LEVEL <= 5  -- Ensure the path stops at length 5
)
WHERE path_length = 5;  -- Count only paths of length 5



SELECT COUNT(*) AS num_paths
FROM (
    SELECT src, tgt, LEVEL AS path_length
    FROM d
    START WITH src = 0
    CONNECT BY PRIOR tgt = src
    AND PRIOR src != src 
    AND LEVEL <= 5
)
WHERE path_length = 5;



SELECT count(*)  
FROM d e, d f, d g
WHERE e.src=0 AND e.tgt=f.src AND f.tgt=g.src ;

SELECT COUNT(*) AS num_paths
FROM (
    SELECT src, tgt, LEVEL AS path_length
    FROM d
    START WITH src = 0
    CONNECT BY PRIOR tgt = src
    AND LEVEL <= 5
)
WHERE path_length = 5;



WITH 
Level1 AS (
    SELECT src, tgt
    FROM e
    WHERE src = 0
),
FilteredLevel2 AS (
    SELECT *
    FROM e
    WHERE src <> 0
),
Level2 AS (
    SELECT l1.src AS src_start, l1.tgt AS level1_tgt, fl2.tgt
    FROM Level1 l1
    JOIN FilteredLevel2 fl2 ON fl2.src = l1.tgt
),
FilteredLevel3 AS (
    SELECT *
    FROM e
    WHERE src NOT IN (SELECT src_start FROM Level2)
),
Level3 AS (
    SELECT l2.src_start, l2.level1_tgt, fl3.tgt
    FROM Level2 l2
    JOIN FilteredLevel3 fl3 ON fl3.src = l2.tgt
),
FilteredLevel4 AS (
    SELECT *
    FROM e
    WHERE src NOT IN (SELECT level1_tgt FROM Level3)
),
Level4 AS (
    SELECT l3.src_start, l3.level1_tgt, fl4.tgt
    FROM Level3 l3
    JOIN FilteredLevel4 fl4 ON fl4.src = l3.tgt
),
FilteredLevel5 AS (
    SELECT *
    FROM e
    WHERE src NOT IN (SELECT level1_tgt FROM Level4)
),
Level5 AS (
    SELECT l4.src_start, l4.level1_tgt, fl5.tgt
    FROM Level4 l4
    JOIN FilteredLevel5 fl5 ON fl5.src = l4.tgt
)
SELECT COUNT(*) AS num_paths
FROM Level5;



WITH Level1 AS (
    SELECT src, tgt
    FROM e
    WHERE src = 0
),
FilteredLevel2 AS (
    SELECT *
    FROM e
    WHERE src != 0
),
Level2 AS (
    SELECT l1.tgt AS src, fl2.tgt AS tgt
    FROM Level1 l1
    JOIN FilteredLevel2 fl2 ON fl2.src = l1.tgt
),
FilteredLevel3 AS (
    SELECT *
    FROM e
    WHERE src <> ANY(SELECT src FROM Level2)
),
Level3 AS (
    SELECT l2.tgt AS src, fl3.tgt AS tgt
    FROM Level2 l2
    JOIN FilteredLevel3 fl3 ON fl3.src = l2.tgt
),
FilteredLevel4 AS (
    SELECT *
    FROM e
    WHERE src NOT IN (SELECT src FROM Level3)
),
Level4 AS (
    SELECT l3.tgt AS src, fl4.tgt AS tgt
    FROM Level3 l3
    JOIN FilteredLevel4 fl4 ON fl4.src = l3.tgt
),
FilteredLevel5 AS (
    SELECT *
    FROM e
    WHERE src NOT IN (SELECT src FROM Level4)
),
Level5 AS (
    SELECT l4.tgt AS src, fl5.tgt AS tgt
    FROM Level4 l4
    JOIN FilteredLevel5 fl5 ON fl5.src = l4.tgt
)
SELECT COUNT(*) AS num_paths
FROM Level5;




EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS('kc450224', DBMS_STATS.AUTO_SAMPLE_SIZE);

EXPLAIN PLAN FOR 
WITH Level1 AS (
    SELECT src, tgt
    FROM e
    WHERE src = 0
),
FilteredLevel2 AS (
    SELECT *
    FROM e
    WHERE src != 0
),
Level2 AS (
    SELECT l1.tgt AS src, fl2.tgt AS tgt
    FROM Level1 l1
    JOIN FilteredLevel2 fl2 ON fl2.src = l1.tgt
),
FilteredLevel3 AS (
    SELECT *
    FROM e
    WHERE src NOT IN (SELECT DISTINCT src FROM Level2)
),
Level3 AS (
    SELECT l2.tgt AS src, fl3.tgt AS tgt
    FROM Level2 l2
    JOIN FilteredLevel3 fl3 ON fl3.src = l2.tgt
),
FilteredLevel4 AS (
    SELECT *
    FROM e
    WHERE src NOT IN (SELECT DISTINCT src FROM Level3)
),
Level4 AS (
    SELECT l3.tgt AS src, fl4.tgt AS tgt
    FROM Level3 l3
    JOIN FilteredLevel4 fl4 ON fl4.src = l3.tgt
),
Level5 AS (
    SELECT l4.tgt AS src, e.tgt AS tgt
    FROM Level4 l4
    JOIN e ON e.src = l4.tgt
)
SELECT COUNT(*) AS num_paths
FROM Level5;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());