--customer_segments
CREATE VIEW customer_segments As
Select
id,
age,

CASE 
    WHEN age <= 30 THEN 'Young'
    WHEN age <= 45 THEN 'Adult'
    ELSE 'Old'
END AS age_group,

total_spending,

CASE 
    WHEN total_spending > 1000 THEN 'High'
    ELSE 'Low'
END AS spend_category,

total_purchases,
response,
NumWebPurchases,
NumStorePurchases,
NumCatalogPurchases,
NumWebVisitsMonth

FROM marketing_campaign;

--campaign_summary
CREATE VIEW campaign_summary As
SELECT 
spend_category,

COUNT(*) As total_customers,
COUNT(*) FILTER (Where response = 1) AS responders,

ROUND(
COUNT(*) FILTER (Where response = 1) * 100.0 / COUNT(*),
2) AS response_rate

FROM customer_segments
GROUP BY spend_category;

select * from campaign_summary;

--product_summary
CREATE VIEW product_summary As
Select 
SUM(MntWines) AS wines,
SUM(MntFruits) AS fruits,
SUM(MntMeatProducts) AS meat,
SUM(MntFishProducts) AS fish,
SUM(MntSweetProducts) AS sweets,
SUM(MntGoldProds) AS gold
From marketing_campaign;

--chanel_summary
CREATE VIEW channel_summary As
SELECT 
SUM(NumWebPurchases) AS web,
SUM(NumStorePurchases) AS store,
SUM(NumCatalogPurchases) AS catalog
From marketing_campaign;






