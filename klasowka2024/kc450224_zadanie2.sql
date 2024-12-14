--Kacper Chorzela kc450224 gr. 6 Zadanie 2
WITH count_shareholders AS (
    SELECT 
        Company.name AS name, 
        COALESCE(COUNT(Ownership.shareholder),0) AS shareholders_count
    FROM Company 
    LEFT JOIN Ownership ON Company.name = Ownership.company
    GROUP BY Company.name
)
SELECT name 
FROM (
    SELECT 
        Company.name AS name
    FROM Company
    JOIN Ownership ON Company.name = Ownership.company
    RIGHT JOIN Sales ON Sales.seller = Company.name AND Sales.buyer = Ownership.shareholder
    JOIN count_shareholders ON count_shareholders.name = Company.name
    GROUP BY Company.name, count_shareholders.shareholders_count
    HAVING COUNT(DISTINCT Sales.buyer) = count_shareholders.shareholders_count
    UNION 
    SELECT 
        Company.name AS name
    FROM Company
    LEFT JOIN Ownership ON Company.name = Ownership.company
    WHERE Ownership.company IS NULL
) temp
ORDER BY name;