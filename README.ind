# 📊 RFM Customer Segmentation (BigQuery + Power BI)

## 🔍 Overview
This project performs customer segmentation using the RFM (Recency, Frequency, Monetary) model.

Sales data from multiple monthly CSV files was processed and transformed using Google BigQuery. The data was cleaned, standardized, and combined into a unified dataset. SQL was then used to calculate RFM metrics and assign customer segments.

The final dataset was connected to Power BI to build an interactive dashboard for analysis and insights.

---

## ⚙️ Data Pipeline

### Step 1: Data Preparation
- Combined multiple monthly sales tables into one dataset
- Resolved schema inconsistencies across datasets
- Standardized columns for consistency

### Step 2: RFM Metrics Calculation
- **Recency**: Days since last purchase
- **Frequency**: Number of transactions per customer
- **Monetary**: Total spending per customer

### Step 3: Scoring
- Used `NTILE(10)` to rank customers for:
  - Recency score (R)
  - Frequency score (F)
  - Monetary score (M)

### Step 4: Total Score
- Combined R, F, M scores into a single **RFM total score**

### Step 5: Customer Segmentation
Customers were grouped into segments:
- Champions
- Loyal VIPs
- Potential Loyalists
- Engaged
- Promising
- Requires Attention
- At Risk
- Lost/Inactive

---

## 🛠️ Tools Used
- SQL (Google BigQuery)
- Power BI

---

## 📊 BigQuery Processing Steps
<img src="rf1.PNG" width="700"/>
<img src="rf2.PNG" width="700"/>
<img src="rf3.PNG" width="700"/>

---

## 📈 Power BI Dashboard
<img src="BI4.PNG" width="700"/>

---

## 💡 Key Insights
- Identified high-value customers (Champions & Loyal VIPs)
- Detected customers at risk of churn
- Analyzed customer engagement distribution across segments

---

## 📁 Project Files
- `Step1&2 RFM.sql` → SQL queries for data transformation and RFM analysis  
- `RFMana.pbix` → Power BI dashboard file  
- `.PNG files` → Screenshots of pipeline and dashboard  

---

## 🚀 How to Use
1. Upload CSV datasets into BigQuery
2. Run the SQL script to generate RFM tables
3. Connect Power BI to the final dataset (`rfm_segments_final`)
4. Explore the dashboard

---

## 📌 Conclusion
This project demonstrates how to build an end-to-end data analytics workflow using cloud-based SQL processing and BI visualization tools. It highlights the importance of performing data transformations upstream before visualization.

---
