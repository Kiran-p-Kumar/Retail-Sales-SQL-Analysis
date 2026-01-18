# Retail Sales & Customer Segmentation Analytics
### BSc Data Science - Final Portfolio Project

## 📌 Project Overview
This project demonstrates a full data analytics pipeline: from cleaning raw "dirty" data in **MySQL** to performing advanced **RFM (Recency, Frequency, Monetary)** segmentation and creating an interactive executive dashboard in **Power BI**.

The goal is to identify high-value customers, at-risk segments, and product categories with high return rates to drive better business decisions.

---

## 🛠️ Tech Stack
* **Database:** MySQL (Data Cleaning, ETL, RFM Modeling)
* **Visualization:** Power BI (Interactive Dashboards)
* **Data Source:** Superstore Retail Dataset (50,000+ transactions)

---

## 📈 Key Analysis Features

### 1. SQL Data Engineering & Cleaning
* **ETL Process:** Handled BOM character encoding issues and converted string-based dates into SQL-ready `DATE` formats.
* **Metric Calculation:** Developed queries for Monthly Revenue Trends, Return Rates, and Customer Lifetime Value (CLV).

### 2. RFM Customer Segmentation
Using SQL **Window Functions (NTILE)**, customers were ranked from 1-5 across three metrics:
* **Recency:** How recently did they buy?
* **Frequency:** How often do they buy?
* **Monetary:** How much do they spend?

**Segments Created:**
* 🏆 **Champions:** Best customers; highly frequent and high spenders.
* ⚠️ **At Risk:** Used to shop often but haven't returned lately.
* 💤 **Lost Customers:** Lowest scores in all categories.

### 3. Power BI Executive Dashboard
* **Dynamic Filtering:** Implemented a "Button Slicer" to filter the entire report by customer segment.
* **Sales Trends:** Line charts visualizing seasonal peaks.
* **Product Risk:** Bar charts identifying products with the highest loss/return percentages.

---

## 📂 Project Structure
* `SQL_Scripts/`: Contains the master `.sql` file with all cleaning and analysis queries.
* `Data_Exports/`: Cleaned CSV files exported from MySQL for Power BI.
* `PowerBI_Reports/`: The `.pbix` dashboard file.
* `README.md`: Documentation of the project.

---

## 💡 Business Insights
* **Segment Strategy:** The "At Risk" segment accounts for a significant portion of potential lost revenue; targeted email campaigns are recommended.
* **Operational Efficiency:** Certain products in the "Technology" category have high return rates, suggesting a need for better quality control or clearer product descriptions.