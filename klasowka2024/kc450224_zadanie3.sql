WITH expenses AS (
    SELECT 
        Company.name AS name,
        COALESCE(SUM(Sales.price), 0) AS sum
    FROM Company
    LEFT JOIN Sales ON Sales.buyer = Company.name
    GROUP BY Company.name
)
SELECT 
    name 
FROM
(
    SELECT 
        temp.name
    FROM
    (
        SELECT 
            Company.name AS name,
            SUM(Sales.price) OVER(PARTITION BY Company.name ORDER BY Sales.price DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS sum
        FROM Company
        LEFT JOIN Sales ON Sales.buyer = Company.name
    ) temp
    JOIN expenses ON expenses.name = temp.name
    GROUP BY temp.name, expenses.sum
    HAVING MAX(temp.sum) * 10 >= expenses.sum * 9
    UNION 
    SELECT 
        Company.name AS name
    FROM Company
    LEFT JOIN Sales ON Sales.buyer = Company.name
    GROUP BY Company.name
    HAVING COALESCE(COUNT(Sales.id), 0) <= 3
)
ORDER BY name;