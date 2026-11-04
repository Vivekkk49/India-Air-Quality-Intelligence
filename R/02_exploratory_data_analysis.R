# =========================================
# INDIA AIR QUALITY INTELLIGENCE
# PHASE 2: EXPLORATORY DATA ANALYSIS
# =========================================

# Load libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

# Import cleaned dataset
final_data <- read.csv(
  "data/processed/cleaned_air_quality.csv"
)

# Check dataset
dim(final_data)
head(final_data)

# =========================================
# STATE-WISE CO ANALYSIS
# =========================================

state_co <- final_data %>%
  group_by(state) %>%
  summarise(
    Average_CO = mean(co, na.rm = TRUE),
    Total_Observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Average_CO))

# Display top 10 states
head(state_co, 10)

# =========================================
# STATE-WISE CO VISUALIZATION
# =========================================

top_states <- head(state_co, 10)
ggplot(
  top_states,
  aes(
    x = reorder(state, Average_CO),
    y = Average_CO
  )
) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 10 States by Average CO Concentration",
    x = "State",
    y = "Average CO Concentration"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold"
    )
  )

# =========================================
# STEP 14: YEAR-WISE CO ANALYSIS
# =========================================

yearly_co <- final_data %>%
  group_by(year) %>%
  summarise(
    Average_CO = mean(co, na.rm = TRUE),
    Total_Observations = n(),
    .groups = "drop"
  )

print(yearly_co)

# =========================================
# STEP 15: YEAR-WISE CO VISUALIZATION
# =========================================

ggplot(
  yearly_co,
  aes(x = year, y = Average_CO)
) +
  geom_line(color = "steelblue", linewidth = 1.2) +
  geom_point(color = "red", size = 3) +
  scale_x_continuous(breaks = 2023:2025) +
  labs(
    title = "Year-wise CO Concentration Trend (2023-2025)",
    x = "Year",
    y = "Average CO Concentration"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold"
    )
  )

ggsave(
  "visualizations/yearly_co_trend.png",
  width = 10,
  height = 6,
  dpi = 300
)

# =========================================
# STEP 16: MONTH-WISE CO ANALYSIS
# =========================================

monthly_co <- final_data %>%
  group_by(month) %>%
  summarise(
    Average_CO = mean(co, na.rm = TRUE),
    Total_Observations = n(),
    .groups = "drop"
  ) %>%
  arrange(month)

print(monthly_co)

# =========================================
# STEP 17: MONTH-WISE CO VISUALIZATION
# =========================================

ggplot(
  monthly_co,
  aes(x = factor(month), y = Average_CO)
) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Monthly Average CO Concentration",
    x = "Month",
    y = "Average CO Concentration"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold"
    )
  )

# =========================================
# STEP 18: YEAR-WISE NO2 ANALYSIS
# =========================================

yearly_no2 <- final_data %>%
  group_by(year) %>%
  summarise(
    Average_NO2 = mean(no2, na.rm = TRUE),
    Total_Observations = n(),
    .groups = "drop"
  )

print(yearly_no2)

# =========================================
# STEP 19: YEAR-WISE NO2 VISUALIZATION
# =========================================

ggplot(
  yearly_no2,
  aes(x = year, y = Average_NO2)
) +
  geom_line(color = "darkgreen", linewidth = 1.2) +
  geom_point(color = "red", size = 3) +
  scale_x_continuous(breaks = 2023:2025) +
  labs(
    title = "Year-wise NO2 Concentration Trend (2023-2025)",
    x = "Year",
    y = "Average NO2 Concentration"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold"
    )
  )

# =========================================
# STEP 20: MONTHLY NO2 ANALYSIS
# =========================================

monthly_no2 <- final_data %>%
  group_by(month) %>%
  summarise(
    Average_NO2 = mean(no2, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(month)

print(monthly_no2)

ggplot(monthly_no2,
       aes(x = factor(month), y = Average_NO2)) +
  geom_col(fill = "darkgreen") +
  labs(
    title = "Monthly Average NO2 Concentration",
    x = "Month",
    y = "Average NO2 Concentration"
  ) +
  theme_minimal()

# =========================================
# STEP 22: SO2 AND O3 ANALYSIS
# =========================================

pollutant_summary <- final_data %>%
  summarise(
    Average_SO2 = mean(so2, na.rm = TRUE),
    Average_O3 = mean(o3, na.rm = TRUE),
    Average_NO2 = mean(no2, na.rm = TRUE),
    Average_CO = mean(co, na.rm = TRUE)
  )

print(pollutant_summary)

pollutant_data <- final_data %>%
  summarise(
    SO2 = mean(so2, na.rm = TRUE),
    O3 = mean(o3, na.rm = TRUE),
    NO2 = mean(no2, na.rm = TRUE),
    CO = mean(co, na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Pollutant",
    values_to = "Average"
  )

ggplot(pollutant_data,
       aes(x = Pollutant, y = Average, fill = Pollutant)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~Pollutant, scales = "free_y") +
  labs(
    title = "Average Concentration of Major Pollutants",
    x = "Pollutant",
    y = "Average Concentration"
  ) +
  theme_minimal()

# =========================================
# STEP 23: CORRELATION ANALYSIS
# =========================================

correlation_data <- final_data %>%
  select(co, no2, so2, o3, temperature, dew_point)

correlation_matrix <- cor(
  correlation_data,
  use = "complete.obs"
)

print(round(correlation_matrix, 3))

# =========================================
# STEP 24: CORRELATION HEATMAP
# =========================================

library(ggplot2)

correlation_long <- as.data.frame(
  as.table(correlation_matrix)
)

ggplot(
  correlation_long,
  aes(Var1, Var2, fill = Freq)
) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(Freq, 2)), size = 4) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    midpoint = 0
  ) +
  labs(
    title = "Correlation Heatmap of Environmental Variables",
    x = "",
    y = "",
    fill = "Correlation"
  ) +
  theme_minimal()

# =========================================
# STEP 25: CO STATISTICAL TEST
# =========================================

co_comparison <- final_data %>%
  filter(year %in% c(2023, 2025))

co_test <- t.test(
  co ~ factor(year),
  data = co_comparison
)

print(co_test)

co_2023 <- mean(final_data$co[final_data$year == 2023])
co_2025 <- mean(final_data$co[final_data$year == 2025])

percentage_change <- 
  ((co_2025 - co_2023) / co_2023) * 100

print(percentage_change)

# =========================================
# STEP 26: LINEAR REGRESSION MODEL
# =========================================

co_model <- lm(co ~ temperature, data = final_data)

summary(co_model)

capture.output(
  summary(co_model),
  file = "report/regression_results.txt"
)

# =========================================
# STEP 27: INTERACTIVE CO VISUALIZATION
# =========================================

co_plot <- ggplot(
  final_data,
  aes(x = temperature, y = co)
) +
  geom_point(
    color = "steelblue",
    alpha = 0.4
  ) +
  labs(
    title = "Relationship Between Temperature and CO",
    x = "Temperature",
    y = "CO Concentration"
  ) +
  theme_minimal()

interactive_plot <- ggplotly(co_plot)

interactive_plot

