WITH next_purchase AS (
    SELECT 
        previous.id AS id,
    FROM Sales previous
    JOIN Sales next ON previous.buyer = next.buyer
    WHERE previous.id < next.id
    GROUP BY previous.id
),
purchase_2 AS (
    SELECT
        previous.id
    FROM Sales previous
    JOIN next_purchase ON next_purchase.id = Sales.id
    JOIN Sales next ON next_purchase.id_next = next.id
    WHERE 


)
SELECT 
    Company.name,
    COUNT(next_purchase.id)
FROM Company
LEFT JOIN Sales ON Sales.buyer = Company.name
JOIN 
JOIN next_purchase


