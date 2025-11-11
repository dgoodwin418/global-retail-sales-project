![Global Sales Overview Dashboard](Global_Sales_Overview_2023-2024.png)


# 🧭 Global Sales Overview Dashboard (R + Tableau)

### 📊 Overview
This project analyzes simulated global retail sales data (10,000 transactions from 2023–2024) to uncover key insights about **revenue, profit, and customer behavior** across different regions and product categories.  
The analysis was conducted in **R (tidyverse)** for data cleaning and transformation, and visualized in **Tableau Desktop** through an interactive executive-style dashboard.

---

### 🎯 Objectives
- Create a realistic retail dataset programmatically using R.  
- Clean, structure, and enrich the data for visualization.  
- Design an interactive Tableau dashboard with clear KPIs and filters.  
- Present actionable insights for global business decisions.

---

### 🧮 Tools & Technologies
| Category | Tools Used |
|-----------|-------------|
| **Data Generation** | R, base R randomization functions |
| **Data Cleaning & Prep** | tidyverse, dplyr, lubridate |
| **Visualization** | Tableau Desktop |
| **Export** | Tableau PNG + Packaged Workbook (.twbx) |
| **Data Size** | 10,000 transactions |

---

### 🧱 Dataset Structure
The dataset includes 10,000 records with the following key fields:

| Column | Description |
|--------|--------------|
| `Order_ID` | Unique transaction ID |
| `Order_Date` | Purchase date (2023–2024) |
| `Region` | Global region (North America, Europe, Asia-Pacific, South America) |
| `Country` | Country associated with region |
| `Category` | Product category (Electronics, Clothing, Furniture) |
| `Subcategory` | Specific product type (Laptop, Sofa, etc.) |
| `Quantity` | Items purchased per transaction |
| `Revenue` | Total order revenue |
| `Profit` | Profit per order |
| `Profit_Margin` | Profit as % of revenue |
| `Payment_Method` | Credit Card, PayPal, or Bank Transfer |
| `Shipping_Mode` | Standard, Express, or Same-Day |

---

### 📈 Dashboard Features

#### 🧩 **Dashboard 1 — Global Sales Overview**
- **KPI Summary Tiles**
  - Total Revenue, Total Profit, Profit Margin %, and Average Order Value
  - Clean layout with bold values and subtle accent colors
- **Interactive Filters**
  - Year (drop-down)
  - Category and Region
- **Global Map**
  - Revenue by Country (color intensity)
  - Tooltips with profit and margin details
- **Profit by Region Bar Chart**
  - Region-level comparison with Profit Margin color legend
- **Footer**
  > *Data Source: Simulated Global Retail Dataset (R + Tableau) | Dashboard by Derrick Goodwin*

---

### 🔍 Key Insights
- **Asia-Pacific and Europe** consistently lead in overall revenue performance.  
- **Furniture** products have the **highest average order value** but lower margins due to shipping costs.  
- **Electronics** show strong Q4 sales spikes, suggesting seasonal demand.  
- **Profit Margin** varies by region — North America maintains steadier returns compared to South America.

---

### 📁 Project Files

```
Global_Retail_Sales_Project/
├── README.md
├── global_retail_analysis.R
├── global_retail_sales.csv
├── global_retail_sales_clean.csv
├── Global_Sales_Overview_Dashboard.twbx
├── Global_Sales_Overview.png
└── data_cleaning_walkthrough.Rmd (optional)
```

### 🌐 View Online
🔗 [View the Interactive Dashboard on Tableau Public](https://public.tableau.com/shared/TWH68X4SX?:display_count=n&:origin=viz_share_link)

---

### 💬 Author
**Derrick Goodwin**  
Data Analyst | R + Tableau | Business Intelligence  
📧 [LinkedIn](https://www.linkedin.com/in/derrick-goodwin)

<sub>**Keywords:** Tableau, R, Data Analytics, Data Visualization, Dashboard Design, Portfolio Project, Business Intelligence</sub>






