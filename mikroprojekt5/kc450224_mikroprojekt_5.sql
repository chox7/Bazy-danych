CREATE INDEX idx_e_src ON e(src);
CREATE INDEX idx_e_tgt ON e(tgt);
WITH level1 AS (
	SELECT src, COUNT(*) AS cnt
	FROM e GROUP BY src
),
level2 AS (
        SELECT e.src, SUM(level1.cnt) AS cnt
        FROM e JOIN level1 ON e.tgt=level1.src GROUP BY e.src
),
level3 AS (
        SELECT e.src, SUM(level2.cnt) AS cnt
        FROM e JOIN level2 ON e.tgt=level2.src GROUP BY e.src
),
level4 AS (
        SELECT e.src, SUM(level3.cnt) AS cnt
        FROM e JOIN level3 ON e.tgt=level3.src GROUP BY e.src
),
level5 AS (
        SELECT e.src, SUM(level4.cnt) AS cnt
        FROM e JOIN level4 ON e.tgt=level4.src GROUP BY e.src
)
SELECT cnt FROM level5 WHERE src=0;