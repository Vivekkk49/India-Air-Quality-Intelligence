# 🇮🇳 India Air Quality Intelligence Platform

### Spatio-Temporal Analysis, Statistical Modelling and Interactive Dashboard Using R

An interactive data analytics project that explores air-quality pollutant patterns across India using environmental observations from 2023 to 2025.

The project uses R Programming, statistical analysis, data visualization and Shiny to transform environmental data into meaningful insights through an interactive dashboard.

---

## 📌 Project Overview

The India Air Quality Intelligence Platform is designed to analyse environmental pollutant patterns across different Indian cities and states over a three-year period.

It focuses on data cleaning, exploratory data analysis, statistical testing, correlation analysis and interactive visualization.

The project provides an interactive dashboard where users can explore observations using year, state and city filters.

## 🎯 Objectives

* Analyse environmental pollutant patterns across India.
* Study monthly and yearly variations in selected pollutants.
* Explore relationships between environmental variables.
* Perform statistical analysis and regression modelling.
* Develop an interactive dashboard using R Shiny.
* Present analytical findings through visualizations.

## 📊 Dataset Overview

| Attribute           | Details   |
| ------------------- | --------- |
| Time period         | 2023–2025 |
| Total observations  | 17,681    |
| Cities              | 266       |
| States              | 30        |
| Monitoring stations | 495       |
| Time coverage       | 36 months |

**Variables analysed include:**

* CO
* NO2
* SO2
* O3
* HCHO
* Temperature
* Dew Point
* Wind U and Wind V

*Note: The dataset does not contain direct AQI, PM2.5 or PM10 measurements. Therefore, this project does not calculate or claim to analyse those indicators.*

## ✨ Key Features

* Data cleaning and preprocessing using R.
* Missing-value and duplicate checks.
* Outlier detection using the IQR method.
* State-wise and city-wise exploration.
* Monthly and yearly pollutant trend analysis.
* Correlation analysis between environmental variables.
* Statistical hypothesis testing.
* Linear regression modelling.
* Interactive Plotly visualizations.
* Interactive R Shiny dashboard.
* Dataset exploration and CSV download functionality.

## 📈 Key Findings

Some important findings from the analysis include:

* Average CO observations decreased by approximately 4.36% between 2023 and 2025.
* NO2 observations remained relatively stable over the study period.
* CO and NO2 showed a positive correlation of approximately 0.52.
* January showed higher average CO and NO2 values than August in the monthly analysis.
* The relationship between CO and temperature was statistically significant but had very low explanatory power (R² approximately 0.0052).

These findings describe patterns in the available dataset and should not be interpreted as proof of environmental causes or nationwide pollution trends.

## 🛠️ Technologies Used

| Technology    | Purpose                                 |
| ------------- | --------------------------------------- |
| R Programming | Data analysis and statistical computing |
| RStudio       | Development environment                 |
| dplyr         | Data manipulation                       |
| ggplot2       | Data visualization                      |
| tidyr         | Data transformation                     |
| lubridate     | Date handling                           |
| janitor       | Data cleaning                           |
| Plotly        | Interactive visualizations              |
| Shiny         | Interactive dashboard                   |
| DT            | Interactive data tables                 |
| R Markdown    | Analytical reporting                    |

## 📂 Project Structure

```text
India-Air-Quality-Intelligence/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── R/
│   ├── 01_data_import.R
│   └── 02_exploratory_data_analysis.R
│
├── dashboard/
│   ├── app.R
│   ├── air_quality_dashboard.Rmd
│   └── air_quality_dashboard.html
│
├── report/
│   └── regression_results.txt
│
├── visualizations/
│   ├── correlation_heatmap.png
│   ├── environmental_boxplots.png
│   ├── monthly_co_analysis.png
│   ├── monthly_no2_analysis.png
│   ├── pollutant_comparison.png
│   ├── state_wise_co_analysis.png
│   ├── yearly_co_trend.png
│   └── yearly_no2_trend.png
│
├── .gitignore
└── India_Air_Quality_Intelligence.Rproj
```

## 🚀 How to Run the Project

### 1. Clone the repository

```bash
git clone https://github.com/Vivekkk49/India-Air-Quality-Intelligence.git
```

### 2. Open the project

Open `India_Air_Quality_Intelligence.Rproj` in RStudio.

### 3. Add the dataset

Place the original dataset named `MASTER DATASET.csv` inside:

```text
data/raw/
```

The raw and processed datasets are excluded from this repository. You must obtain the dataset separately from its original source.

### 4. Install required packages

Run in the RStudio Console:

```r
install.packages(c(
  "dplyr",
  "ggplot2",
  "tidyr",
  "lubridate",
  "janitor",
  "skimr",
  "plotly",
  "rmarkdown",
  "knitr",
  "shiny",
  "bslib",
  "DT"
))
```

### 5. Run data preprocessing

```r
source("R/01_data_import.R")
```

### 6. Run exploratory data analysis

```r
source("R/02_exploratory_data_analysis.R")
```

### 7. Launch the interactive dashboard

```r
shiny::runApp("dashboard")
```

## ⚠️ Limitations

* The analysis is limited to the variables available in the supplied dataset.
* Direct AQI, PM2.5 and PM10 measurements are not available.
* The original dataset's provenance and measurement methodology should be verified before drawing broader conclusions.
* Statistical associations do not establish causation.
* Repeated observations from monitoring stations may affect the independence assumptions of statistical tests.
* The regression model has limited explanatory power.

## 🔮 Future Scope

* Integrate verified real-time environmental data sources.
* Incorporate PM2.5, PM10 and official AQI measurements.
* Develop more advanced predictive models.
* Expand geographical and temporal coverage.
* Improve dashboard deployment and accessibility.

## 👨‍💻 Author

**Vivek Sharma**

B.Tech – Information Technology

Developed as an academic project for INT232 – R Programming.

## 📄 License

This repository contains the project's source code and visualizations. Dataset redistribution rights have not been established; the original dataset is therefore excluded.
