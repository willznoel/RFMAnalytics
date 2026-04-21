-- step1 : append all monthly sales table together 

CREATE OR REPLACE TABLE `rfm-analysis-494003.sales.sales_2025` AS

SELECT * FROM `rfm-analysis-494003.sales.sales202501`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202502`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202503`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202504`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202505`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202506`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202507`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202508`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202509`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202510`
UNION ALL SELECT * FROM `rfm-analysis-494003.sales.sales202511`

-- 👇 only take matching columns from December
UNION ALL 
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue
FROM `rfm-analysis-494003.sales.sales202512`;
--step2 : calculate recency, frequency, monetary, r,f,m ranks 
-- Combine views with CTEs
CREATE OR REPLACE VIEW `rfm-analysis-494003.sales.rfm_Metrics`
AS
WITH current_date AS (
  SELECT DATE ('2026-03-06') AS analysis_date --today's date
),
rfm AS(
  SELECT
    CustomerID,
    MAX(OrderDate) AS last_order_date,
    date_diff((select analysis_date FROM current_date), MAX (OrderDate), DAY) AS recency,
    COUNT(*) AS frequency, 
    SUM(OrderValue) AS monetary
  FROM  `rfm-analysis-494003.sales.sales_2025`
  GROUP BY CustomerID
)
SELECT
 rfm.*,
 ROW_NUMBER() OVER(ORDER BY recency ASC) AS r_rank,
 row_number() OVER(ORDER BY frequency DESC) AS f_rank,
 row_number() OVER(ORDER BY monetary DESC) AS m_rank
FROM rfm;

--step 3 :Assigning deciles (10=best, 1=worst)
CREATE OR REPLACE VIEW `rfm-analysis-494003.sales.rfm_scores`
AS
SELECT
  *,
  NTILE(10) OVER(Order By r_rank DESC) as r_score,
  NTILE(10) OVER(Order By f_rank DESC) as f_score,
  NTILE(10) OVER(Order By m_rank DESC) as m_score
FROM  `rfm-analysis-494003.sales.rfm_Metrics`;


--step 4: total score
CREATE OR REPLACE VIEW `rfm-analysis-494003.sales.rfm_total_scores`
AS
select
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  (r_score +f_score + m_score) as rfm_total_score
FROM `rfm-analysis-494003.sales.rfm_scores`
order by rfm_total_score desc;

--step 5 :BI ready rfm segments table 
CREATE OR REPLACE TABLE  `rfm-analysis-494003.sales.rfm_segments_final`
AS
SELECT
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_total_score,
  CASE
   WHEN rfm_total_score >= 28 THEN 'Champions'
   WHEN rfm_total_score >= 24 THEN 'Loyal VIPs'
   WHEN rfm_total_score >= 20 THEN 'Potential Loyalists'
   WHEN rfm_total_score >= 16 THEN 'Promising'
   WHEN rfm_total_score >= 12 THEN 'Engaged'
   WHEN rfm_total_score >= 8 THEN 'Requires Attention'
   WHEN rfm_total_score >= 4 THEN 'At Risk'
   ELSE 'Lost/Inactive'
  END AS rfm_segment
FROM  `rfm-analysis-494003.sales.rfm_total_scores`
ORDER BY rfm_total_score DESC;

