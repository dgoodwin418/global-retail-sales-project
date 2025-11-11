### ------------------------------------------------------------
### GLOBAL RETAIL SALES DATA GENERATOR (10,000 TRANSACTIONS)
### ------------------------------------------------------------

set.seed(2025)  # for reproducibility

# Number of rows
n <- 10000

# Date range (2023–2024)
dates <- seq(as.Date("2023-01-01"), as.Date("2024-12-31"), by = "day")

# Regions & countries
regions <- c("North America", "Europe", "Asia-Pacific", "South America")

countries_list <- list(
  "North America" = c("United States", "Canada", "Mexico"),
  "Europe" = c("United Kingdom", "Germany", "France", "Spain", "Italy"),
  "Asia-Pacific" = c("Japan", "China", "Australia", "India", "South Korea"),
  "South America" = c("Brazil", "Argentina", "Chile")
)

# Categories & Subcategories
categories <- c("Electronics", "Clothing", "Furniture")

subcategories <- list(
  "Electronics" = c("Smartphone", "Laptop", "Tablet", "Television"),
  "Clothing" = c("Shirt", "Shoes", "Jacket", "Pants"),
  "Furniture" = c("Sofa", "Table", "Chair", "Lamp")
)

# Generate main columns
Order_ID <- 100000 + 1:n
Order_Date <- sample(dates, n, replace = TRUE)
Customer_ID <- paste0("C", sample(1001:3000, n, replace = TRUE))
Region <- sample(regions, n, replace = TRUE)

# Map country to region
Country <- sapply(Region, function(r) sample(countries_list[[r]], 1))

Category <- sample(categories, n, replace = TRUE)

Subcategory <- mapply(function(c) sample(subcategories[[c]], 1), Category)

Quantity <- sample(1:10, n, replace = TRUE)

# Unit price ranges by category
Unit_Price <- ifelse(Category == "Electronics",
                     sample(200:2000, n, replace = TRUE),
                     ifelse(Category == "Clothing",
                            sample(10:300, n, replace = TRUE),
                            sample(100:1500, n, replace = TRUE)))

Discount <- round(runif(n, 0, 0.30), 2)

# Revenue and profit
Revenue <- round(Quantity * Unit_Price * (1 - Discount), 2)
Profit <- round(Revenue * runif(n, 0.10, 0.40), 2)

Payment_Method <- sample(c("Credit Card", "PayPal", "Bank Transfer"), n, replace = TRUE)
Shipping_Mode <- sample(c("Standard", "Express", "Same-Day"), n, replace = TRUE)

# Combine into a dataframe
retail_data <- data.frame(
  Order_ID,
  Order_Date,
  Customer_ID,
  Region,
  Country,
  Category,
  Subcategory,
  Quantity,
  Unit_Price,
  Discount,
  Revenue,
  Profit,
  Payment_Method,
  Shipping_Mode
)

# Save file
write.csv(retail_data, "global_retail_sales.csv", row.names = FALSE)

cat("✅ Dataset successfully created: global_retail_sales.csv\n")

data <- read.csv("global_retail_sales.csv")

library(dplyr)
library(ggplot2)

glimpse(data)
summary(data)

# ============================================================
# GLOBAL RETAIL SALES — CLEANING & ANALYSIS (R / tidyverse)
# Input:  global_retail_sales.csv  (10,000 rows you generated)
# Outputs:
#   - global_retail_sales_clean.csv  (Tableau-ready)
#   - summary tables (KPIs, trends, top countries, etc.)
# ============================================================

# ---- Setup
packages <- c("tidyverse", "lubridate", "janitor", "scales")
invisible(lapply(packages, function(p) if (!require(p, character.only=TRUE)) install.packages(p)))
lapply(packages, library, character.only=TRUE)

# ---- Load
raw <- read_csv("global_retail_sales.csv") |> clean_names()

# ---- Quick health check
glimpse(raw)
summary(raw)

# Expect columns:
# order_id, order_date, customer_id, region, country,
# category, subcategory, quantity, unit_price, discount, revenue, profit,
# payment_method, shipping_mode

# ---- Basic validation
# 1) Date & ranges
data <- raw |>
  mutate(
    order_date = as.Date(order_date),
    year = year(order_date),
    month = month(order_date, label = TRUE, abbr = TRUE),
    quarter = paste0("Q", quarter(order_date))
  ) |>
  filter(!is.na(order_date), year %in% c(2023, 2024))

# 2) Numeric sanity checks
# Remove negative or zero quantities/prices (shouldn’t exist, but just in case)
data <- data |>
  filter(quantity > 0, unit_price > 0, revenue >= 0, profit >= 0, discount >= 0, discount <= 0.3)

# 3) Duplicates
data <- data |> distinct()

# 4) Outlier handling (light-touch, winsorize revenue & profit at 1st/99th pct)
winsor <- function(x, probs=c(0.01, 0.99)) {
  q <- quantile(x, probs = probs, na.rm = TRUE)
  pmin(pmax(x, q[1]), q[2])
}
data <- data |>
  mutate(
    revenue_w = winsor(revenue),
    profit_w  = winsor(profit)
  )

# 5) Derived metrics
data <- data |>
  mutate(
    aov         = revenue_w / quantity,                 # average order value per line
    profit_margin = if_else(revenue_w > 0, profit_w / revenue_w, NA_real_)
  )

# ---- KPIs (for your executive summary)
kpi <- data |>
  summarise(
    total_revenue = sum(revenue_w),
    total_profit  = sum(profit_w),
    avg_order_value = mean(aov),
    profit_margin_pct = mean(profit_margin, na.rm = TRUE)
  )

print(kpi)
# Use scales::dollar/percent to pretty print
kpi_fmt <- kpi |>
  mutate(
    total_revenue = dollar(total_revenue),
    total_profit  = dollar(total_profit),
    avg_order_value = dollar(avg_order_value),
    profit_margin_pct = percent(profit_margin_pct)
  )
print(kpi_fmt)

# ---- Trends by month & region
trend_month_region <- data |>
  group_by(year, month, region) |>
  summarise(revenue = sum(revenue_w), profit = sum(profit_w), .groups = "drop") |>
  arrange(year, month, region)

# Example plot (optional, for your own EDA)
ggplot(trend_month_region, aes(x = interaction(year, month, sep="-"), y = revenue, group = region)) +
  geom_line(aes(linetype = region)) +
  labs(title = "Monthly Revenue by Region (2023–2024)", x = "Year-Month", y = "Revenue") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))

# ---- Category/Subcategory performance
cat_perf <- data |>
  group_by(category, subcategory) |>
  summarise(
    revenue = sum(revenue_w),
    profit = sum(profit_w),
    margin = profit / revenue,
    avg_price = mean(unit_price),
    .groups = "drop"
  ) |>
  arrange(desc(revenue))

head(cat_perf, 10)

# ---- Top countries by profit (great for a map in Tableau)
top_countries <- data |>
  group_by(region, country) |>
  summarise(
    revenue = sum(revenue_w),
    profit = sum(profit_w),
    margin = profit / revenue,
    orders = n(),
    .groups = "drop"
  ) |>
  arrange(desc(profit))

head(top_countries, 10)

# ---- Customer insights (optional but impressive)
# Top customers by revenue
top_customers <- data |>
  group_by(customer_id) |>
  summarise(revenue = sum(revenue_w), profit = sum(profit_w), orders = n(), .groups = "drop") |>
  arrange(desc(revenue)) |>
  slice_head(n = 20)

# Repeat purchase rate (customers with >1 order line across days)
customer_orders_per_day <- data |>
  group_by(customer_id, order_date) |>
  summarise(lines = n(), .groups = "drop")

repeat_rate <- customer_orders_per_day |>
  count(customer_id, name = "order_days") |>
  summarise(repeat_purchase_rate = mean(order_days > 1))

print(repeat_rate)

# ---- Export Tableau-ready dataset
# Keep original fields + engineered ones that are useful in Tableau
export_tbl <- data |>
  select(
    order_id, order_date, year, month, quarter,
    customer_id, region, country,
    category, subcategory,
    quantity, unit_price, discount,
    revenue = revenue_w, profit = profit_w, aov, profit_margin,
    payment_method, shipping_mode
  )

write_csv(export_tbl, "global_retail_sales_clean.csv")
cat("✅ Exported: global_retail_sales_clean.csv\n")

# ---- (Optional) Save summary tables to CSV for quick Tableau sheets
write_csv(trend_month_region, "trend_month_region.csv")
write_csv(cat_perf, "category_performance.csv")
write_csv(top_countries, "top_countries.csv")
write_csv(top_customers, "top_customers.csv")
cat("✅ Exported: trend/category/country/customer summaries\n")

