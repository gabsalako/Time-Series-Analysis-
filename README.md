**Biodiversity Resilience to Extreme Flood Disturbance
Long-term time-series analysis biodiversity resilience of soil fauna communities — Elbe River Floodplain**
**Dr. Gabriel Salako | Quantitative Ecologist & IPBES Expert**

**Overview**
This repository contains the R code and analytical framework used to investigate how soil fauna communities collapse and recover following an extreme flood disturbance. Using long-term monitoring data (2001–2010) from the Elbe River floodplain, the project quantifies resistance and resilience dynamics of three earthworm ecological groups (ecogroups) — Endogeic, Epigeic, and Anecic — across a decadal window that brackets the catastrophic 2002 Elbe flood.
The framework is designed to be transferable to larger-scale biodiversity time-series datasets, including European freshwater biodiversity monitoring and multi-stressor analyses.

**Research Questions**
    • How do soil fauna communities collapse following an extreme flood event? 
    • What recovery trajectories are observed across different ecological groups? 
    • Which environmental variables drive resistance and recovery dynamics? 
    • How does abundance vary across land-use types (grassland, forest, arable)? 

**Data**
Source: Edaphobase — the German soil zoology data repository.
Temporal coverage: 2001–2010 (pre-flood baseline: 2001; flood year: 2002; recovery: 2004–2010)
Sampling criteria: Only sites with at least two consistent measurements per observation year were retained to ensure temporal reliability.
Ecological groups modelled:
Ecogroup	Habitat	Flood sensitivity
Endogeic	Mineral soil layers	Moderate
Epigeic	Surface litter/topsoil	High
Anecic	Deep-burrowing	Moderate–High
Note: The data included in this repository is a pooled spatio-temporal section of observations along the River Elbe and its basin. The full dataset resides in Edaphobase and is subject to its data access terms.

**Methods**
1. Data Preparation
    • Abundance data for three ecogroups aggregated across sites and years 
    • Wide-to-long format reshaping using tidyr::pivot_longer() 
    • Ecogroup treated as a factor variable 
2. Generalised Additive Mixed Model (GAMM)
    • Model: Abundance ~ Species + s(Year, by = Species, k = 5) 
    • Random effect: Species-level intercept (random = list(Species = ~1)) 
    • Family: Poisson with log link (appropriate for count data) 
    • Package: mgcv 
    • Adjusted R²: 0.42 
The species-specific smooth terms (s(Year, by = Species)) capture non-linear recovery trajectories for each ecogroup independently, allowing comparison of post-flood dynamics across groups.
3. Resistance Index
A resistance index was calculated to quantify the degree to which each ecogroup withstood the 2002 flood disturbance. Epigeic worms, despite lower absolute abundance, showed the highest resistance index among the three groups.
4. Aggregate Spatial Prediction
    • A Random Forest (RF) model was used to predict aggregate soil fauna abundance across the floodplain extent 
    • Predicted abundance mapped spatially using coordinate data within the study region (longitude ~11.5–14°E, latitude ~51.4–52.2°N) 
    • Predictions were also summarised by land-use class (Grassland, Forest, Arable) 
5. Environmental Optima
Partial response curves from the GAMM were used to identify environmental optima for each predictor:
Variable	Approximate optimum
Elevation	Lower elevations (~100 m)
Soil pH	~4.5–5.5
Clay content	Increasing positive trend
Precipitation	~650–750 mm
Soil Moisture	~8–10 units
Bulk Density	~1.4–1.5 g/cm³

**Repository Structure**
├── Scripts/
│   └── Time.seriesProj.R       # Main analysis script
├── Data/
│   └── (Edaphobase-derived data — see Data section above)
├── Outputs/
│   └── figures/                # Generated plots
└── README.md

**Dependencies**
Install required packages in R:
install.packages(c("tidyr", "ggplot2", "dplyr", "forecast", "mgcv", "here"))
Package	Purpose
tidyr	Data reshaping (wide → long)
ggplot2	Visualisation
dplyr	Data manipulation
forecast	Time series utilities
mgcv	GAMM fitting
here	Reproducible file paths

Usage
Clone the repository and run the main script:
git clone https:https://github.com/gabsalako/Time-Series-Analysis-

# In R, from the project root:
source("Scripts/Time.seriesProj.R")
The script will:
    1. Build the aggregated earthworm abundance dataset (2001–2010) 
    2. Fit the GAMM with species-specific smooth terms over time 
    3. Produce the GAMM smooth plots with confidence intervals 
    4. Generate the stacked area chart of recovery and resistance trajectories 

**Key Results**
    • Community collapse: All three ecogroups showed sharp abundance declines in the 2002 flood year, with Endogeic worms experiencing the steepest drop (from ~302 to 3 individuals). 
    • Recovery: Abundance rebounded substantially by 2004–2007, with Endogeic worms peaking around 2008 before declining again toward 2010. 
    • Resistance: Epigeic worms showed the highest resistance index (0.25–0.30), maintaining relatively stable presence through the disturbance period despite low absolute numbers. 
    • Environmental drivers: Soil pH was the strongest relative contributor to abundance variation (24%), followed by soil moisture (19%), clay content (17%), precipitation (15%), land use (14%), and elevation (11%). 
    • Land use: Grassland supported the highest predicted abundance, followed by Arable and Forest sites. 

**Visualisations**
The script produces the following figures:
    • Time series scatter plot — raw abundance by ecogroup across years 
    • GAMM smooth plots — non-linear temporal trends per ecogroup with 95% confidence bands 
    • Stacked area chart — community-level recovery and resistance trajectories (2001–2010) 
Additional outputs shown in the presentation include:
    • Spatial RF prediction map of aggregate abundance across the floodplain 
    • Bar chart of predicted abundance by land-use class 
    • Partial response curves for six environmental predictors 

**Broader Applications**
This analytical framework is designed to be transferable to:
    • European freshwater biodiversity time series — applying the same GAMM + resistance index approach to aquatic invertebrate communities 
    • Multi-stressor analyses — extending the model to include compound disturbance events (e.g., flooding combined with drought or pollution) 
    • IPBES biodiversity synthesis — contributing empirical evidence to large-scale assessments of disturbance-driven biodiversity change 

**Citation**
If you use this code or framework, please cite:
Salako, G. Zaytsev, A. Russell, D. et al. (2026). Biodiversity resilience to extreme flood disturbance: Long-term time-series analysis of soil fauna communities, Elbe River floodplain. GitHub repository.https://github.com/gabsalako/Time-Series-Analysis-

Contact
Dr. Gabriel Salako
Quantitative Ecologist & IPBES Expert
📧 (Google Scholar: scholar.google.com/citations?user=9xrm4cAAAAAJ )
🌐 (ORCID: 0000-0001-7960-8200)

Licence
This project is licensed under the MIT Licence. See LICENSE for details.
