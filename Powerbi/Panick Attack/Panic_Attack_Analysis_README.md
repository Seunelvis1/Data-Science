# 😰 Panic Attack Analysis Dashboard

An interactive Power BI dashboard analysing panic attack patterns, physical symptoms, and lifestyle triggers across a patient population — built to help clinicians and analysts understand what factors correlate with panic attack severity and frequency.

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=flat&logo=snowflake&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-217346?style=flat)
![Status](https://img.shields.io/badge/status-complete-brightgreen)

---

## 📊 Project Overview

This project analyses patient-level panic attack data to answer three core questions:

1. **Which physical symptoms** (dizziness, trembling, sweating, shortness of breath, chest pain) are most prevalent among patients experiencing panic attacks?
2. **What lifestyle and clinical factors** — sleep hours, alcohol consumption, caffeine intake, medical history, therapy — relate to panic attack duration and severity?
3. **How does panic score, sleep, and attack frequency vary by age group**, and which trigger reasons are most common within each group?

## ☁️ Data Source & Pipeline

- **Source:** **Snowflake** — data was connected live from a Snowflake warehouse (`POWERBI_PROJECT` database) using Power BI's native Snowflake connector
- **Grain:** One row per patient record
- **Preparation:** Data cleaning and shaping performed in **Power Query (M)** after connecting to Snowflake, including:
  - Type conversions (age, panic score, heart rate, and other numeric fields cast to whole numbers)
  - Standardising boolean symptom fields (sweating, shortness of breath) from text to numeric flags
  - A conditional column bucketing patients into **Low / Medium / High** panic score bands
  - A data correction applied to the heart rate field

## 🛠️ Tools & Techniques

- **Snowflake** — cloud data warehouse, source of truth for the dataset
- **Power BI** — data modelling, report design, DAX
- **Power Query (M)** — data cleaning and transformation
- **DAX** — calculated columns and measures for segmentation and rate calculations

## 🧮 Key DAX Highlights

| Calculation | Type | Purpose |
|---|---|---|
| `% Patient Dizziness` | Measure | Share of patients reporting dizziness as a symptom |
| `Age Group IF` | Calculated column | Buckets patients into Child / Adolescent / Adult / Senior using nested `IF` |
| `Age Group Switch` | Calculated column | Same age-group logic, implemented with `SWITCH(TRUE())` |

*Note: `Age Group IF` and `Age Group Switch` intentionally solve the same problem two different ways — a small but deliberate demonstration of DAX pattern versatility.*

## 📄 Report Pages

1. **Cover Page** — title page and project introduction
2. **Number of Patients by Symptoms** — bar charts breaking down patient counts across dizziness, trembling, sweating, shortness of breath, and chest pain
3. **Required Analysis** — area charts for alcohol consumption, sleep hours, and attack duration, filterable by panic score band, gender, trigger reason, and medical history
4. **Age Group Page** — average sleep hours, panic score, and attack frequency by age group and trigger reason

## 📸 Screenshots

*(Add exported screenshots of each page here — see publishing steps below)*

```
![Cover Page](images/cover-page.png)
![Symptoms Overview](images/symptoms-overview.png)
![Required Analysis](images/required-analysis.png)
![Age Group Analysis](images/age-group-analysis.png)
```

## 💡 Key Insights

*(Fill in 2-4 sentence bullets once you've reviewed the final visuals, e.g.:)*
- **[Symptom]** is the most commonly reported physical symptom among patients in this dataset
- Patients with **[trigger reason]** as their primary trigger show **[higher/lower]** average panic scores
- **[Age group]** reports the highest average panic attack frequency, most often triggered by **[reason]**

## 🚀 How to Use

1. Download `Panic_Attack_Analysis.pbit`
2. Open in [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free) — you'll be prompted to connect to the Snowflake source (or point it at your own copy of the dataset)
3. Use the slicers on the Required Analysis page to filter by panic score band, gender, trigger reason, or medical history

## 👤 Author

**Michael Oluwaseun**
Power BI Specialist | PL-300 Certified
[LinkedIn](#) · [Portfolio](#)
