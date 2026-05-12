CREATE TABLE marketing_campaign (
ID INT,
Year_Birth INT,
Education VARCHAR(50),
Marital_Status VARCHAR(50),
Income FLOAT,
Kidhome INT,
Teenhome INT,
Dt_Customer DATE,
Recency INT,
MntWines INT,
MntFruits INT,
MntMeatProducts INT,
MntFishProducts INT,
MntSweetProducts INT,
MntGoldProds INT,
NumDealsPurchases INT,
NumWebPurchases INT,
NumCatalogPurchases INT,
NumStorePurchases INT,
NumWebVisitsMonth INT,
AcceptedCmp1 INT,
AcceptedCmp2 INT,
AcceptedCmp3 INT,
AcceptedCmp4 INT,
AcceptedCmp5 INT,
Response INT,
Complain INT,
Z_CostContact INT,
Z_Revenue INT
);

--Data analysis
SELECT * FROM marketing_campaign LIMIT 10;

--check nulls
SELECT 
COUNT(*) FILTER (WHERE income IS NULL) AS null_income
FROM marketing_campaign;

-- Checking duplicates
SELECT id, COUNT(*)
FROM marketing_campaign
GROUP BY id
HAVING COUNT(*) > 1;

-- Income stats
SELECT MIN(income), MAX(income), AVG(income)
FROM marketing_campaign;

--replace nulls with average
UPDATE marketing_campaign
SET income = (
    SELECT AVG(income) FROM marketing_campaign
)
WHERE income IS NULL;

--checked again
SELECT COUNT(*) 
FROM marketing_campaign
WHERE income IS NULL;

select * from marketing_campaign ;

--age 
SELECT 
year_birth,
EXTRACT(YEAR FROM CURRENT_DATE) - year_birth AS age
FROM marketing_campaign
LIMIT 10;

--to store it in table permanently
Alter table marketing_campaign
add column age INT ;

update marketing_campaign
set age = EXTRACT(YEAR FROM CURRENT_DATE) - year_birth ;

--totalpurchases with coalesce to handle null values
SELECT 
COALESCE(NumWebPurchases,0) + 
COALESCE(NumCatalogPurchases,0) +
COALESCE(NumStorePurchases,0) AS total_purchases
FROM marketing_campaign;

Alter table marketing_campaign
ADD COLUMN total_purchases INT;

Update marketing_campaign
set total_purchases = 
COALESCE(NumWebPurchases,0) + 
COALESCE(NumCatalogPurchases,0) +
COALESCE(NumStorePurchases,0);

SELECT NumWebPurchases, NumCatalogPurchases, NumStorePurchases, total_purchases
FROM marketing_campaign
;

--Totalspending
Select id ,( MntWines +
MntFruits +
MntMeatProducts +
MntFishProducts +
MntSweetProducts +
MntGoldProds) as Totalspending
From marketing_campaign
;

ALTER TABLE marketing_campaign
ADD COLUMN total_spending FLOAT ;

UPDATE marketing_campaign
SET total_spending =  
COALESCE(MntWines, 0) +
COALESCE(MntFruits, 0) +
COALESCE(MntMeatProducts, 0) +
COALESCE(MntFishProducts, 0) +
COALESCE(MntSweetProducts, 0) +
COALESCE(MntGoldProds, 0);

-- Analysis (Channel analysis)
select sum(NumWebPurchases) as total_web, 
sum(NumStorePurchases) as total_store, 
sum(NumCatalogPurchases) as total_catalog 
from marketing_campaign ;


SELECT 'Web' AS channel, SUM(NumWebPurchases) AS total
FROM marketing_campaign

UNION ALL

SELECT 'Store', SUM(NumStorePurchases)
FROM marketing_campaign

UNION ALL

SELECT 'Catalog', SUM(NumCatalogPurchases)
FROM marketing_campaign
ORDER BY total DESC;
 
-- Insight : 
-- Store purchases are highest, showing customers prefer offline channel.

---Product_Analysis
SELECT 
SUM(MntWines) AS wines,
SUM(MntFruits) AS fruits,
SUM(MntMeatProducts) AS meat,
SUM(MntFishProducts) AS fish,
SUM(MntSweetProducts) AS sweets,
SUM(MntGoldProds) AS gold
FROM marketing_campaign ;

--or

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
FROM marketing_campaign
ORDER BY total_spending DESC;

--Insight : Customers spend the most on Wines

---Customer segmentation
SELECT 
CASE 
    WHEN age BETWEEN 18 AND 30 THEN 'Youngster'
    WHEN age BETWEEN 31 AND 45 THEN 'Adults'
    ELSE 'Old'
END AS age_group,
Avg(total_spending) AS avg_spending

FROM marketing_campaign
GROUP BY age_group
ORDER BY avg_spending DESC;


Insight:
-- Older customers have the highest average spending, followed by adults,
-- while younger customers contribute significantly less, indicating a need 
-- for targeted strategies for younger segments.

--Engagement Analysis
Select 
CASE WHEN recency <= 30 THEN 'Active' 
when recency between 31 and 90 THEN 'medactive' 
Else 'Inactive' 
end as customer_segment , 
Count(*) as total_customers

from marketing_Campaign 
group by customer_segment
order by total_customers DESC;

--campaign analysis
select * from marketing_Campaign ;

SELECT 
Response,
COUNT(*) AS total_customers
FROM marketing_campaign
GROUP BY Response;

--Insight:
-- The campaign response rate is extremely low, with only a very small

--resonse rate, total responders, total cust within age group
SELECT 
CASE 
    WHEN age <= 30 THEN 'Young'
    WHEN age <= 45 THEN 'Adult'
    ELSE 'Old'
END AS age_group,
COUNT(*) AS responders
FROM marketing_campaign
WHERE Response = 1
GROUP BY age_group;
---
SELECT 
CASE 
    WHEN age <= 30 THEN 'Young'
    WHEN age <= 45 THEN 'Adult'
    ELSE 'Old'
END AS age_group,

COUNT(*) FILTER (WHERE Response = 1) AS responders,
COUNT(*) AS total_customers,

ROUND(
COUNT(*) FILTER (WHERE Response = 1) * 100.0 / COUNT(*), 2
) AS response_rate

FROM marketing_campaign
GROUP BY age_group
ORDER BY response_rate DESC;


-- Insight:
-- Although older customers have the highest number of responses,
-- adults (31–45 age group) show the highest response rate,
-- making them the most responsive segment for campaigns.

---Conversion Analysis
--(For analyzing the Do high spenders respond more to campaign analysis ? )


WITH temp AS (
SELECT 
CASE 
WHEN total_spending > 1000 THEN 'High Spender'
ELSE 'Low Spender'
END AS spend_category,
Response
FROM marketing_campaign
)

SELECT 
    spend_category,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE Response = 1) AS responders,
    
    ROUND(
        COUNT(*) FILTER (WHERE Response = 1) * 100.0 / COUNT(*), 
    2) AS response_rate

FROM temp
GROUP BY spend_category
ORDER BY response_rate DESC;

-- Insight:
-- Low spenders have a higher response rate (1.16%) compared to high spenders (0.33%).


-- Final Analysis
-- Campaigns should primarily target adults (31–45 age group) who are low spenders
-- and moderately active, as they demonstrate the highest responsiveness.
-- Separate strategies should be designed to improve engagement among older customers.





