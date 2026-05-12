CREATE VIEW channel_long AS
SELECT 'Web' AS channel, SUM(NumWebPurchases) AS total
FROM marketing_campaign

UNION ALL

SELECT 'Store', SUM(NumStorePurchases)
FROM marketing_campaign

UNION ALL

SELECT 'Catalog', SUM(NumCatalogPurchases)
FROM marketing_campaign;