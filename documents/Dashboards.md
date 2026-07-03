# 📊 Calgary Building Inspections — Tableau Dashboards

This document provides direct access to the interactive Tableau dashboards created for the Calgary Building Inspections Analysis project. These dashboards visualize key insights related to permit durations, inspection workload, deficiency patterns, and long‑term outlier behavior across Residential and Commercial construction projects.

---

## 🔹 1. Outlier Analysis by Project Category  
**Three‑Year Rolling Window Outlier Detection (2000–2025)**

🔗 https://public.tableau.com/app/profile/jose.alberto.martinez.morales/viz/dashboardprojectcalgarybuildings/OutlierAnalysisbyProjectCategory

**Includes:**
- Rolling 3‑year windows  
- Residential vs Commercial duration comparison  
- Q1, Q3, IQR, and outlier fences  
- Outlier counts and percentages  
- Long‑term operational variability trends  

This dashboard is based on the recursive SQL windowing logic and quartile interpolation implemented in Script B6.

---

## 🔹 2. Calgary Building Inspections — Business Insights Dashboard  
**Permit Duration, Inspection Workload, and Operational Bottlenecks**

🔗 https://public.tableau.com/app/profile/jose.alberto.martinez.morales/viz/Businessinsights_17813447866530/CalgaryBuildingInspectionsPerformanceDashboardAnalysisofPermitDurationsInspectionWorkloadandOperationalBottlenecks

**Includes:**
- Average permit duration by job type  
- Inspection workload distribution  
- Deficiency frequency and patterns  
- Contractor and location performance  
- Operational bottleneck identification  

This dashboard is built using SQL datasets from Section 6.1 and the unified permit‑inspection table.

---

## 📌 Notes
- Both dashboards are publicly accessible on Tableau Public.  
- Dashboards automatically update when republished.  
- These visualizations complement the statistical modeling performed in SPSS and the SQL‑based analytical workflow documented in the project.

---

## 🧩 Repository Location
This file is stored in:

```
documents/Dashboards.md
```

and referenced in the main project README for easy access.

