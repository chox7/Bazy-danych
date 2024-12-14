WITH sold AS (
    SELECT 
        Company.name AS name,
        COALESCE(SUM(Sales.price), 0) AS sum
    FROM Company
    LEFT JOIN Sales ON Sales.seller = Company.name
    GROUP BY Company.name
), 
bought AS (
    SELECT 
        Company.name AS name,
        COALESCE(SUM(Sales.price), 0) AS sum
    FROM Company
    LEFT JOIN Sales ON Sales.buyer = Company.name
    GROUP BY Company.name
)
SELECT
    Company.name AS name,
    sold.sum - bought.sum AS bilans
FROM Company 
JOIN sold ON Company.name = sold.name
JOIN bought ON Company.name = bought.name
ORDER BY bilans DESC;