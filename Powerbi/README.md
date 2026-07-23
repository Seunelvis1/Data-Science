# 🏠 Housing Market Performance Dashboard

An interactive Power BI dashboard analysing residential property sales performance, pricing trends, and the economic drivers behind purchase prices — built to surface actionable insight for stakeholders tracking regional market performance.

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-217346?style=flat)
![Status](https://img.shields.io/badge/status-complete-brightgreen)

---

## 📊 Project Overview

This project analyses residential property transactions to answer three core business questions:

1. **How is sales performance trending** across regions, time periods, and sales types?
2. **How closely do offer prices track final purchase prices**, and where is negotiation leverage strongest?
3. **What drives purchase price** — property size, house type, or macroeconomic conditions (inflation, interest rates, mortgage bond yields)?

The dashboard is built across multiple report pages, moving from a high-level performance overview into deeper segment-level and driver analysis.

## 🗂️ Dataset

- **Domain:** Residential property sales (Denmark)
- **Grain:** One row per property transaction
- **Key fields:** region, area, city, house type, sales type, offer price, purchase price, property size (sqm), price per sqm, property age, annual inflation rate, nominal interest rate, mortgage credit bond yield
- **Source:** *[add your dataset source/link here]*
- **Storage & preparation:** Data was connected via **Google BigQuery**, where initial data cleaning (handling nulls, standardising field formats, and filtering out invalid records) was carried out before the dataset was pulled into Power BI

## 🛠️ Tools & Techniques

- **Google BigQuery** — data storage and initial data cleaning/preparation
- **Power BI** — data modelling, report design, DAX
- **Power Query (M)** — additional data shaping and cleaning after import
- **DAX** — custom measures for YoY growth, YTD totals, and ratio calculations
- **Key Influencers (AI visual)** — automated driver analysis on purchase price
- **Custom theme** — branded colour palette and typography for a polished, non-default look

## ☁️ Data Pipeline

1. Raw housing data loaded into **Google BigQuery**
2. Data cleaning performed in BigQuery (null handling, format standardisation, invalid record filtering) — see screenshot below
3. Cleaned dataset connected to Power BI via the BigQuery connector
4. Additional shaping and modelling done in Power Query and the Power BI data model

![BigQuery data cleaning](images/bigquery-console.png)

## 🧮 Key DAX Measures

| Measure | Purpose |
|---|---|
| `YOY_Sales_Growth` | Year-over-year sales growth by sales type |
| `Median Sales Price Change` | Regional price movement |
| `Units sold in Latest Year & Quarter` | Current-period volume KPI |
| `Last 12 Month Sales` | Trailing 12-month sales total |
| `Sales By Region` | Regional sales aggregation |
| `TotalYTD` | Year-to-date running total |
| `AvgPricePerSQM` | Average price normalised by property size |
| `Offer to SQM Ratio` | Offer price efficiency relative to property size |

*(Add the actual DAX formulas here once finalised — this makes the repo far more useful to anyone reviewing your technical approach.)*

## 📄 Report Pages

1. **Market Overview** — headline KPIs, YoY sales growth by type, offer vs. purchase price relationship, regional price movement
2. **Sales Performance** — regional sales breakdown, sales detail by period, price-per-sqm by region, AI-driven purchase 
                           price drivers, offer/purchase price, economic indicators, and size/price trends by house type, with city/area/region/sales-type filtering
I've filled in what I can verify from the file itself (pages, measures, dataset fields) — the bracketed placeholders are for things only you know (dataset source link, final insights, LinkedIn URL). Fill those in before publishing.

## Publishing to GitHub properly

**1. Export visuals as images first** — GitHub can't render a `.pbix` inline, so screenshots are what actually sell the project when someone lands on your repo.
- In Power BI Desktop, go to each page → File → Export → Export to PDF, or just use Win+Shift+S / Snipping Tool per page
- Save them as `market-overview.png`, `sales-performance.png`, `house-type-analysis.png`

**2. Set up the repo folder structure locally:**
```
housing-market-dashboard/
├── README.md
├── Housing_Project.pbix
├── images/
│   ├── market-overview.png
│   ├── sales-performance.png
│   └── house-type-analysis.png
└── data/                  (optional — only if the dataset is public/shareable)
```

**3. Initialise and push:**
```bash
cd housing-market-dashboard
git init
git add .
git commit -m "Initial commit: Housing market Power BI dashboard"
git branch -M main
git remote add origin https://github.com/<your-username>/housing-market-dashboard.git
git push -u origin main
```

**4. A few things worth doing before you push:**
- Create the repo on GitHub first (github.com → New repository) — don't initialise it with a README there, since you already have one, or you'll get a merge conflict on first push
- `.pbix` files are binary — GitHub handles them fine up to 100MB (yours is ~11MB, no issue), but they won't diff cleanly, so don't expect meaningful commit history on the file itself
- If your dataset came from a source with usage restrictions, don't commit the raw data — link to the source in the README instead
- Add a `.gitignore` if you're keeping any local Power BI temp/cache files out of the repo (Power BI Desktop doesn't usually leave junk behind, but worth a check)

**5. Once pushed**, the README renders automatically on the repo homepage — that's your shop window, so this is the thing recruiters actually read before they'd ever download the `.pbix`.

Want me to also draft the LinkedIn post copy to announce it once it's live?I've filled in what I can verify from the file itself (pages, measures, dataset fields) — the bracketed placeholders are for things only you know (dataset source link, final insights, LinkedIn URL). Fill those in before publishing.

## Publishing to GitHub properly

**1. Export visuals as images first** — GitHub can't render a `.pbix` inline, so screenshots are what actually sell the project when someone lands on your repo.
- In Power BI Desktop, go to each page → File → Export → Export to PDF, or just use Win+Shift+S / Snipping Tool per page
- Save them as `market-overview.png`, `sales-performance.png`, `house-type-analysis.png`

**2. Set up the repo folder structure locally:**
```
housing-market-dashboard/
├── README.md
├── Housing_Project.pbix
├── images/
│   ├── market-overview.png
│   ├── sales-performance.png
│   └── house-type-analysis.png
└── data/                  (optional — only if the dataset is public/shareable)
```

**3. Initialise and push:**
```bash
cd housing-market-dashboard
git init
git add .
git commit -m "Initial commit: Housing market Power BI dashboard"
git branch -M main
git remote add origin https://github.com/<your-username>/housing-market-dashboard.git
git push -u origin main
```

**4. A few things worth doing before you push:**
- Create the repo on GitHub first (github.com → New repository) — don't initialise it with a README there, since you already have one, or you'll get a merge conflict on first push
- `.pbix` files are binary — GitHub handles them fine up to 100MB (yours is ~11MB, no issue), but they won't diff cleanly, so don't expect meaningful commit history on the file itself
- If your dataset came from a source with usage restrictions, don't commit the raw data — link to the source in the README instead
- Add a `.gitignore` if you're keeping any local Power BI temp/cache files out of the repo (Power BI Desktop doesn't usually leave junk behind, but worth a check)

**5. Once pushed**, the README renders automatically on the repo homepage — that's your shop window, so this is the thing recruiters actually read before they'd ever download the `.pbix`.

Want me to also draft the LinkedIn post copy to announce it once it's live?I've filled in what I can verify from the file itself (pages, measures, dataset fields) — the bracketed placeholders are for things only you know (dataset source link, final insights, LinkedIn URL). Fill those in before publishing.

## Publishing to GitHub properly

**1. Export visuals as images first** — GitHub can't render a `.pbix` inline, so screenshots are what actually sell the project when someone lands on your repo.
- In Power BI Desktop, go to each page → File → Export → Export to PDF, or just use Win+Shift+S / Snipping Tool per page
- Save them as `market-overview.png`, `sales-performance.png`, `house-type-analysis.png`

**2. Set up the repo folder structure locally:**
```
housing-market-dashboard/
├── README.md
├── Housing_Project.pbix
├── images/
│   ├── market-overview.png
│   ├── sales-performance.png
│   └── house-type-analysis.png
└── data/                  (optional — only if the dataset is public/shareable)
```

**3. Initialise and push:**
```bash
cd housing-market-dashboard
git init
git add .
git commit -m "Initial commit: Housing market Power BI dashboard"
git branch -M main
git remote add origin https://github.com/<your-username>/housing-market-dashboard.git
git push -u origin main
```

**4. A few things worth doing before you push:**
- Create the repo on GitHub first (github.com → New repository) — don't initialise it with a README there, since you already have one, or you'll get a merge conflict on first push
- `.pbix` files are binary — GitHub handles them fine up to 100MB (yours is ~11MB, no issue), but they won't diff cleanly, so don't expect meaningful commit history on the file itself
- If your dataset came from a source with usage restrictions, don't commit the raw data — link to the source in the README instead
- Add a `.gitignore` if you're keeping any local Power BI temp/cache files out of the repo (Power BI Desktop doesn't usually leave junk behind, but worth a check)

**5. Once pushed**, the README renders automatically on the repo homepage — that's your shop window, so this is the thing recruiters actually read before they'd ever download the `.pbix`.

Want me to also draft the LinkedIn post copy to announce it once it's live?
## 📸 Screenshots

*(Add exported screenshots of each page here — see publishing steps below)*

```
![Market Overview](images/market-overview.png)
![Sales Performance](images/sales-performance.png)
![House Type Analysis](images/house-type-analysis.png)
```

## 💡 Key Insights

*(Fill in 2-4 sentence bullets once you've reviewed the final visuals, e.g.:)*
- Sales growth is strongest in **[region]**, driven by **[sales type]**
- Offer-to-purchase price gaps are widest for **[house type]**, suggesting greater negotiation flexibility in that segment
- **[Economic indicator]** shows the strongest relationship with purchase price per the Key Influencers analysis

## 🚀 How to Use

1. Download `Housing_Project.pbix`
2. Open in [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free)
3. Use the slicers on the House Type Analysis page to filter by city, area, sales type, or region

## 👤 Author

**Michael Oluwaseun**
Power BI Specialist | PL-300 Certified
[LinkedIn](#) · [Portfolio](#)

