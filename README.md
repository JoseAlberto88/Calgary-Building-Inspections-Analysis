# **Calgary Building Inspections Analysis**

A full analytical study of the City of Calgary’s building permit and inspection records.  
This project explores construction activity patterns, inspection outcomes, deficiency behavior, permit durations, and statistical differences between residential and commercial projects.

The work includes SQL data extraction, exploratory analysis, hypothesis testing, and business‑insight dashboards.

---

## 🛠️ **Tech Stack**

<p align="left">
  <img src="https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white&style=for-the-badge" />
  <img src="https://img.shields.io/badge/SQL-336791?logo=postgresql&logoColor=white&style=for-the-badge" />
  <img src="https://img.shields.io/badge/Pandas-150458?logo=pandas&logoColor=white&style=for-the-badge" />
  <img src="https://img.shields.io/badge/NumPy-013243?logo=numpy&logoColor=white&style=for-the-badge" />
  <img src="https://img.shields.io/badge/Matplotlib-11557C?logo=plotly&logoColor=white&style=for-the-badge" />
  <img src="https://img.shields.io/badge/Seaborn-4C8CBF?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Jupyter-F37626?logo=jupyter&logoColor=white&style=for-the-badge" />
  <img src="https://img.shields.io/badge/SPSS-FFCA28?logo=ibm&logoColor=black&style=for-the-badge" />
</p>

---

## 📁 Project Overview

This project analyzes administrative records documenting Calgary’s building permit and inspection processes.  
The dataset includes:

- Permit details  
- Inspection events  
- Deficiency records  
- Contractor information  
- Location data  
- Dimension tables for job types, outcomes, disciplines, and checklists  

The relational structure supports multi‑table joins and deep analytical exploration.

---

## 🔍 Key Questions Answered

- Which construction project types are most common in Calgary?  
- Do some project types require more inspections than others?  
- What are the most frequent inspection outcomes?  
- Are deficiencies more common in certain project categories?  
- How long do permits typically remain open?  
- Do residential and commercial projects differ significantly in duration?  
- Are missing close dates concentrated in specific job types?

---

## 📊 Data Analysis & SQL Extraction

The project includes:

- Row counts and distinct value exploration  
- Missing value identification  
- Duration calculations  
- Job type joins  
- Valid permit filtering  
- Inspection counts per permit  
- Deficiency pattern analysis  
- Year‑over‑year inspection trends  
- Common inspection types  
- Permit duration statistics  

All SQL scripts are included in the repository.

---

## 📈 Data Visualization

Dashboards and visualizations include:

- Average inspections per permit  
- Most common deficiency categories  
- Permit duration by inspection type  
- Permit duration by location  
- Histograms and boxplots for statistical assumption checks  
- Business‑insight dashboard  
- Statistical‑assumption dashboard  

---

## 📐 Statistical Modeling

The project applies:

- Welch’s independent samples t‑test  
- Confidence interval analysis  
- Effect size evaluation  
- Normality and variance assumption checks  

The model evaluates whether residential and commercial permit durations differ significantly.

---

## 📦 Repository Structure

```
Calgary-Building-Inspections-Analysis/
│
├── sql/
│   ├── 00_full_raw_sql_extraction.sql
│   ├── 01_initial_exploration.sql
│   ├── 02_table_structure_and_missing_values.sql
│   ├── 03_duration_and_job_type_analysis.sql
│   ├── 04_final_dataset_creation.sql
│   ├── 05_rolling_window_outlier_detection.sql
│   ├── 06_summary_statistics_2022_2024.sql
│   └── 07_visualization_queries.sql
│      
│
├── reports/
│   ├── Final_Report.pdf
│   ├── Dashboards/
│   └── Figures/
│
└── README.md
```

---

## 👥 Student Team

1. **Manpreet Kaur**  
2. **Nicolas Ricardo Ysa Pelaez**  
3. **Daniela Montilla Fernandez**  
4. **Jose Alberto Martinez Morales**  
5. **Sravani Maguluru**

---

## 📜 License

Academic project — educational use only.

