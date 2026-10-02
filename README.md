# Sales Performance Analysis | SQL & Power BI

![SQL](https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-8E44AD?style=for-the-badge)
![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)

An end-to-end retail sales analysis. **SQL** was used to prepare the data and answer business questions, and an interactive **Power BI** dashboard presents sales, profit, quantity, products, cities and promotions for January 2020 to January 2024.

<img width="1626" height="925" alt="Image" src="https://github.com/user-attachments/assets/29dd6c9a-91e7-44bd-8cb1-c402f3a2f381" />

> **About the data:** this project uses a **randomly generated (synthetic) dataset** created for practice. It does not represent a real company or real customers. Profit is modelled at a fixed 10% of net sales, so the analysis focuses on products, cities, promotions and time trends rather than margin differences.

---

## Project at a Glance

| Metric | Value |
| --- | --- |
| Period | 1 Jan 2020 – 1 Jan 2024 (four full years, 2020–2023) |
| Orders | 3,510 |
| Units sold | 7,125 |
| Gross sales (before discounts) | ≈ ₹129.5M |
| Net sales (after discounts) | ≈ ₹122.3M |
| Profit | ≈ ₹12.2M (10% of net sales) |
| Customers / cities | 50 customers across 16 cities and 12 states |
| Products | 30 products in 8 product lines |
| Promotions | 5 campaigns |

---

## Business Questions

1. Which products and product lines drive the most sales, profit and quantity, and which drive the least?
2. How do sales and profit change over time?
3. Which cities generate the most sales?
4. How do promotions and discounts affect orders and sales?
5. How does performance compare between two selected time periods?

---

## Tools

SQL · Power BI Desktop · DAX · Power Query · Microsoft Excel (source data)

---

## Project Workflow

<img width="2001" height="475" alt="Image" src="https://github.com/user-attachments/assets/8f502693-cbda-4bbb-8696-dbb2c977a353" />

---

## Dataset

The source file is [`data/Store_Data.xlsx`]([Store+Data.xlsx](https://github.com/user-attachments/files/32978293/Store%2BData.xlsx)). It has four sheets:

| Sheet | Rows | Contents |
| --- | --- | --- |
| Orders (fact) | 3,510 | Date, CustomerID, PromotionID, Product ID, Units Sold |
| Dim Customers | 50 | Customer ID, name, city, state, pincode |
| Dim Product | 30 | ProductID, product name, product line, price (INR) |
| Dim Promotion | 5 | PromotionID, name, ad type, coupon code, price reduction type |

**Product lines:** Electronics, Home Appliances, Clothing, Footwear, Accessories, Bags, Kitchenware, Personal Care.

**Promotions:**

| Promotion | Ad type | Offer |
| --- | --- | --- |
| Summer Sale | Email | 20% off |
| Festive Diwali | Social media | 10% off |
| New Year Special | Website banner | Buy 1 Get 1 Free |
| Weekend Flash Sale | Mobile push | 50% off |
| Clearance Sale | In-app | 70% off |

### Data model

<img width="1425" height="855" alt="Image" src="https://github.com/user-attachments/assets/6c1d2edf-1272-49ce-a134-0078d4554ad2" />

Two additional date tables (Date Table 1 and Date Table 2) power the period comparison page.

---

## Approach

### 1. SQL: data preparation and analysis
- Joined the orders to the customer, product and promotion tables
- Calculated the derived fields for every order: price per unit, total sales, discount percentage, discount value, net sales and profit
- Wrote queries for the business questions: sales, profit and quantity by product, product line, city, year and promotion, plus top and bottom 5 rankings
- All scripts are in the [`sql/`](sql) folder

### 2. Power BI: modelling and dashboard
- Loaded and shaped the data with Power Query
- Built a **star schema**: one fact table connected to Customers, Product and Promotion dimension tables
- Added two separate date tables (**Date Table 1** and **Date Table 2**) so two time periods can be compared side by side
- Created measures for total sales, total profit and total quantity in a dedicated measures table
- Designed a five-page interactive report with slicers and cross-filtering

### Metric definitions

| Metric | Definition |
| --- | --- |
| Total Sales (gross) | Units sold × price per unit, before discounts |
| Discount Value | Total sales × discount percentage of the promotion |
| Net Sales | Total sales − discount value |
| Profit | 10% of net sales |

The Top / Bottom 5 pages rank products by **Total Sales** (before discounts). The Overview and Comparison pages use **Net Sales** (after discounts).

---

## Dashboard Pages

### 1. Overview
Sales by city on a map, number of orders, average discount value per order by promotion, profit vs net sales, and the sales trend over time.

<img width="1626" height="925" alt="Image" src="https://github.com/user-attachments/assets/937561c0-fd29-45ff-abb1-e95be530b050" />

### 2. Top / Bottom 5 Analysis
Top 5 and bottom 5 products by sales, profit and quantity.

<img width="1535" height="887" alt="Image" src="https://github.com/user-attachments/assets/b9636d62-2fbb-42de-9d54-56cb76ec8ac7" />

### 3. Comparison on Profit / Sales / Quantity
Compares total sales, profit and quantity sold between two independently selectable date ranges.

<img width="1622" height="917" alt="Image" src="https://github.com/user-attachments/assets/8e24ed4c-287e-4731-8d5b-ad0e3bb10978" />

### 4. Edit Interaction
Demonstrates Power BI's edit interactions: each group of visuals has its own date slicer and responds only to its own filter.

<img width="1487" height="920" alt="Image" src="https://github.com/user-attachments/assets/1601deab-7679-4def-bb59-441c7e65078a" />

### 5. Table Visuals
Order-level detail table with slicers for date, customer, product and promotion.

<img width="1357" height="902" alt="Image" src="https://github.com/user-attachments/assets/401ce29a-3dfe-4b57-b769-a5029d809d1e" />

---

## Key Insights

**Products**
- **Electronics dominate revenue.** They account for about ₹95.4M of ₹129.5M gross sales (roughly 74%). The top 5 products by sales are all electronics: Apple iPhone 14 (₹22.5M), Apple MacBook Air (₹20.8M), Sony Bravia 55" TV (₹20.5M), Samsung Galaxy S21 (₹16.1M) and HP Pavilion Laptop (₹15.5M).
- **The lowest sellers are low-price personal care and kitchenware items.** The bottom 5 by sales are Colgate Toothpaste (₹22K), Dove Soap Pack (₹87K), Nivea Body Lotion (₹87K), L'Oreal Shampoo (₹173K) and Tupperware Lunch Box (₹279K).
- **Volume does not equal revenue.** The top products by quantity are Apple iPhone 14 (281 units), Raymond Suit (274), Zara Casual Shirt (269), Fossil Smartwatch (269) and IFB Microwave Oven (259). The bottom 5 products by sales still sold about 200 units each, but earn very little revenue because of their low prices.

**Time and cities**
- Net sales by year: about ₹31.4M (2020), ₹30.0M (2021), ₹28.6M (2022) and ₹32.3M (2023), a dip in 2022 followed by the strongest year in 2023. The data has a single order in 2024 (1 January), so 2024 is not a full year.
- The top cities by net sales are Bhopal (≈ ₹15.4M), Kanpur (≈ ₹14.1M), Indore (≈ ₹13.4M), Lucknow (≈ ₹10.5M) and Mumbai (≈ ₹10.0M).

**Promotions**
- Only about 21% of orders (720 of 3,510) used a promotion.
- **Summer Sale (20% off) is the most used promotion**, with 574 orders and about ₹17.0M in net sales. Its average discount is about ₹7.4K per order.
- **Deeper discounts cost more per order.** The average discount value per order is about ₹22.6K for Weekend Flash Sale (50% off) and about ₹17.7K for Clearance Sale (70% off).
- Festive Diwali and New Year Special have only 2 orders each, which is too few to draw conclusions.

---

## Recommendations

- Focus stock, advertising and promotion planning on high-revenue electronics, since a small number of products drives most of the sales.
- Bundle or cross-sell low-price items (personal care, kitchenware) with higher-value products instead of relying on them for revenue.
- Review the 50% and 70% discount events against the extra sales they generate before repeating them. The average discount per order is high, and Clearance Sale produced only 59 orders.
- Investigate the 2022 dip, and compare the strongest cities (Bhopal, Kanpur, Indore) with weaker ones to find where growth is possible.

---

## Limitations

- The data is synthetic, so the findings illustrate the method and are not real business results.
- Profit is a fixed 10% of net sales, so it does not show margin differences between products.
- The dataset has 50 customers and 30 products, and 2024 contains a single day of orders.

---

## Repository Structure

```
Sales-Performance-Analysis-SQL-PowerBI/
├── README.md
├── data/
│   └── Store_Data.xlsx
├── sql/                    SQL scripts for preparation and analysis
├── powerbi/
│   └── Sales-data-Analysis.pbix
└── screenshots/            dashboard page images
```

## How to Use

1. Download `Sales-data-Analysis.pbix` from the `powerbi/` folder and open it in **Power BI Desktop**.
2. Use the slicers on each page to explore the data. On the Comparison page, set two different date ranges to compare periods.
3. To reproduce the SQL analysis, load `data/Store_Data.xlsx` into your SQL database and run the scripts in `sql/`.

---

## Author

**Mohammed Tabrez Ali Khan** · Data Analyst
Riyadh, Saudi Arabia · [LinkedIn](https://www.linkedin.com/in/md-tabrez-ali-khan) · mdtabrezalik@gmail.com
