CREATE INDEX idx_e_src ON e(src);
CREATE INDEX idx_e_tgt ON e(tgt);
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