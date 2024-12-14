--Kacper Chorzela kc450224 gr. 6 Zadanie 4
WITH next_purchase AS (
    SELECT 
        Company.name AS name,
        Sales.id AS id,
        Sales.price AS previous_price,
        SUM(Sales.price) OVER (PARTITION BY Company.name ORDER BY Sales.price DESC ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING) AS next_price
    FROM Company
    JOIN Sales ON Sales.buyer = Company.name
)
SELECT 
    Company.name,
    COALESCE(COUNT(next_purchase.id), 0) AS l_zakupow
FROM Company
JOIN next_purchase ON next_purchase.name = Company.name
WHERE next_purchase.previous_price >= 2 * next_purchase.next_price
GROUP BY Company.name
ORDER BY l_zakupow DESC;