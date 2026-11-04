# India Air Quality Intelligence Platform
# Step 1: Dataset Importing

# Import CSV dataset
air_data <- read.csv("data/raw/MASTER DATASET.csv")

# Display first 6 records
head(air_data)

# Display dataset dimensions
dim(air_data)

# Display column names
colnames(air_data)

# Step 2: Understanding Dataset Structure

# Check data types
str(air_data)

# Statistical summary
summary(air_data)

# Check number of unique cities
length(unique(air_data$city))

# Check number of unique states
length(unique(air_data$state))

# Check number of monitoring stations
length(unique(air_data$station))

# Check available years
table(air_data$Year)

# =========================================
# STEP 3: DATA QUALITY CHECKING
# =========================================

# 1. Check missing values
colSums(is.na(air_data))


# 2. Check duplicate records
sum(duplicated(air_data))


# 3. Check unique dates
length(unique(air_data$Date))


# 4. Check year distribution
table(air_data$Year)


# 5. Check unique months
sort(unique(air_data$Month))


# 6. Check negative environmental values
environmental_columns <- c(
  "CO", "NO2", "SO2", "O3", "HCHO"
)
sapply(
  air_data[environmental_columns],
  function(x) sum(x < 0, na.rm = TRUE)
)
# =========================================
# END OF DATA QUALITY CHECKING
# =========================================

# =========================================
# STEP 4: INVESTIGATION OF NEGATIVE VALUES
# =========================================

# Check minimum values of pollutants
summary(air_data[, c(
  "CO", "NO2", "SO2", "O3", "HCHO"
)])

# Display records with negative SO2 values
negative_so2 <- air_data[air_data$SO2 < 0, ]
head(negative_so2, 10)

# Count negative SO2 values by year
table(negative_so2$Year)

# Display records with negative HCHO values
negative_hcho <- air_data[air_data$HCHO < 0, ]
head(negative_hcho, 10)

# Count negative HCHO values by year
table(negative_hcho$Year)

# =========================================
# END OF INVESTIGATION
# =========================================

# =========================================
# STEP 5: CITY-WISE NEGATIVE VALUE ANALYSIS
# =========================================

library(dplyr)

# City-wise negative SO2 values
so2_city_analysis <- air_data %>%
  filter(SO2 < 0) %>%
  group_by(city, state) %>%
  summarise(
    Negative_Records = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Negative_Records))

# Display top 15 cities
head(so2_city_analysis, 15)

# City-wise negative HCHO values
hcho_city_analysis <- air_data %>%
  filter(HCHO < 0) %>%
  group_by(city, state) %>%
  summarise(
    Negative_Records = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Negative_Records))

# Display affected cities
print(hcho_city_analysis)

# =========================================
# STEP 6: DATA PREPROCESSING
# =========================================

library(dplyr)
library(lubridate)
library(janitor)

# Create a copy of original dataset
clean_data <- air_data

# 1. Standardize column names
clean_data <- clean_data %>%
  clean_names()

# 2. Convert date into Date format
clean_data$date <- as.Date(
  clean_data$date,
  format = "%d-%m-%Y"
)

# 3. Check updated column names
colnames(clean_data)

# 4. Check date data type
class(clean_data$date)

# 5. Check date range
range(clean_data$date)

# 6. Display first six records
head(clean_data)

# =========================================
# STEP 7: DATE VALIDATION
# =========================================

# Check if Month matches Date
sum(clean_data$month !=
      lubridate::month(clean_data$date))

# Check if Year matches Date
sum(clean_data$year !=
      lubridate::year(clean_data$date))

# Check invalid dates
sum(is.na(clean_data$date))

# Check date range
range(clean_data$date)

# =========================================
# STEP 8: ENVIRONMENTAL DATA SUMMARY
# =========================================

# Select environmental variables
environmental_data <- clean_data %>%
  select(co, no2, so2, o3, hcho,
         temperature, dew_point, wind_u, wind_v)

# Calculate statistical summary
summary(environmental_data)

# Calculate standard deviation
sapply(environmental_data, sd, na.rm = TRUE)

# Calculate variance
sapply(environmental_data, var, na.rm = TRUE)

# =========================================
# END OF STEP 8
# =========================================

# =========================================
# STEP 9: OUTLIER DETECTION USING IQR
# =========================================

# Function to detect outliers
detect_outliers <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR_value <- IQR(x, na.rm = TRUE)
  lower_limit <- Q1 - 1.5 * IQR_value
  upper_limit <- Q3 + 1.5 * IQR_value
  sum(
    x < lower_limit | x > upper_limit,
    na.rm = TRUE
  )
}

# Apply function to all environmental variables
outlier_counts <- sapply(
  environmental_data,
  detect_outliers
)

# Display results
print(outlier_counts)

# =========================================
# END OF STEP 9
# =========================================

# =========================================
# STEP 10: BOXPLOT VISUALIZATION
# =========================================

library(ggplot2)
library(tidyr)

# Convert data into long format
boxplot_data <- environmental_data %>%
  pivot_longer(
    cols = everything(),
    names_to = "Parameter",
    values_to = "Value"
  )

# Create boxplot
ggplot(
  boxplot_data,
  aes(x = Parameter, y = Value)
) +
  geom_boxplot(fill = "skyblue", color = "black") +
  facet_wrap(~Parameter, scales = "free", ncol = 3) +
  labs(
    title = "Distribution and Outlier Analysis of Environmental Parameters",
    x = "Environmental Parameters",
    y = "Measured Values"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold"
    ),
    axis.text.x = element_blank()
  )

# =========================================
# END OF STEP 10
# =========================================

# Investigate minimum temperature observations
clean_data %>%
  arrange(temperature) %>%
  select(city, state, station, date, temperature) %>%
  head(10)

# Investigate maximum temperature observations
clean_data %>%
  arrange(desc(temperature)) %>%
  select(city, state, station, date, temperature) %>%
  head(10)

# =========================================
# STEP 12: FINAL DATA CLEANING
# =========================================

library(dplyr)

# Create final processed dataset
final_data <- clean_data %>%
  mutate(
    
    # Flag negative SO2 measurements
    so2_flag = ifelse(so2 < 0, "Review", "Valid"),
    # Flag negative HCHO measurements
    hcho_flag = ifelse(hcho < 0, "Review", "Valid")
  )

# Check total records
nrow(final_data)

# Check SO2 flags
table(final_data$so2_flag)

# Check HCHO flags
table(final_data$hcho_flag)

# Check dataset structure
str(final_data)

# =========================================
# END OF STEP 12
# =========================================

# Save processed dataset

write.csv(
  final_data,
  "data/processed/cleaned_air_quality.csv",
  row.names = FALSE
)

# Confirmation

print("Processed dataset saved successfully!")