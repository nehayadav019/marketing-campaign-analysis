--product_long
CREATE VIEW product_long AS
SELECT 'Wines' AS product, SUM(MntWines) AS total_spending
FROM marketing_campaign

UNION ALL

SELECT 'Fruits', SUM(MntFruits)
FROM marketing_campaign

UNION ALL

SELECT 'Meat', SUM(MntMeatProducts)
FROM marketing_campaign

UNION ALL

SELECT 'Fish', SUM(MntFishProducts)
FROM marketing_campaign

UNION ALL

SELECT 'Sweets', SUM(MntSweetProducts)
FROM marketing_campaign

UNION ALL

SELECT 'Gold', SUM(MntGoldProds)
FROM marketing_campaign;