
library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)

# Load dataset
final_data <- read.csv(
  "C:/Users/vishu/Documents/India_Air_Quality_Intelligence/data/processed/cleaned_air_quality.csv"
)

# UI
ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "darkly",
    primary = "#00BFA6",
    bg = "#101827",
    fg = "#FFFFFF"
  ),
  div(
    style = "text-align:center; padding:20px; margin-bottom:20px;",
    h1(
      "INDIA AIR QUALITY INTELLIGENCE PLATFORM",
      style = "font-weight:800; color:#00BFA6;"
    ),
    p(
      "Interactive Environmental Data Analytics | 2023–2025",
      style = "font-size:16px; color:#B0BEC5;"
    )
  ),
  sidebarLayout(
    sidebarPanel(
      h4("Dashboard Filters"),
      selectInput(
        "year", "Select Year",
        choices = c("All", sort(unique(final_data$year))),
        selected = "All"
      ),
      selectInput(
        "state", "Select State",
        choices = c("All", sort(unique(final_data$state))),
        selected = "All"
      ),
      selectInput(
        "city", "Select City",
        choices = c("All", sort(unique(final_data$city))),
        selected = "All"
      )
    ),
    mainPanel(
      fluidRow(
        column(3, wellPanel(h4("Total Records"), h3(textOutput("records")))),
        column(3, wellPanel(h4("Total Cities"), h3(textOutput("cities")))),
        column(3, wellPanel(h4("Total States"), h3(textOutput("states")))),
        column(3, wellPanel(h4("Monitoring Stations"), h3(textOutput("stations"))))
      ),
      fluidRow(
        column(
          6,
          h3("CO Concentration Trend"),
          plotlyOutput("co_plot", height = "350px")
        ),
        column(
          6,
          h3("Monthly NO2 Analysis"),
          plotlyOutput("no2_plot", height = "350px")
        )
      ),
      h3("Pollutant Distribution"),
      plotlyOutput("pollutant_plot", height = "350px"),
      h3("Environmental Correlation Heatmap"),
      plotlyOutput("correlation_plot", height = "450px"),
      h3("Key Findings"),
      wellPanel(
        h4("CO Concentration"),
        p("Average CO concentration decreased by approximately 4.36% between 2023 and 2025."),
        h4("NO2 Concentration"),
        p("NO2 concentration remained relatively stable, with a slight overall decline."),
        h4("Correlation Analysis"),
        p("CO and NO2 showed a moderate positive correlation of approximately 0.52."),
        h4("Seasonal Pattern"),
        p("CO concentrations were relatively higher during January and November.")
      ),
      h3("Air Quality Dataset Explorer"),
      DTOutput("data_table"),
      downloadButton("download_data", "Download Filtered Data")
    )
  )
)

# Server
server <- function(input, output, session) {
  filtered_data <- reactive({
    data <- final_data
    if (input$year != "All") {
      data <- data %>% filter(year == as.numeric(input$year))
    }
    if (input$state != "All") {
      data <- data %>% filter(state == input$state)
    }
    if (input$city != "All") {
      data <- data %>% filter(city == input$city)
    }
    data
  })
  output$records <- renderText(nrow(filtered_data()))
  output$cities <- renderText(
    length(unique(filtered_data()$city))
  )
  output$states <- renderText(
    length(unique(filtered_data()$state))
  )
  
  output$stations <- renderText(
    length(unique(filtered_data()$station))
  )
  output$co_plot <- renderPlotly({
    data <- filtered_data() %>%
      group_by(year) %>%
      summarise(Average_CO = mean(co, na.rm = TRUE))
    p <- ggplot(data, aes(year, Average_CO)) +
      geom_line(color = "#00BFA6", linewidth = 1.2) +
      geom_point(color = "#FFB74D", size = 3) +
      theme_minimal()
    
    ggplotly(p)
  })
  output$no2_plot <- renderPlotly({
    data <- filtered_data() %>%
      group_by(month) %>%
      summarise(Average_NO2 = mean(no2, na.rm = TRUE))
    p <- ggplot(data, aes(factor(month), Average_NO2)) +
      geom_col(fill = "#00BFA6") +
      theme_minimal()
    ggplotly(p)
  })
  output$pollutant_plot <- renderPlotly({
    data <- filtered_data() %>%
      summarise(
        CO = mean(co, na.rm = TRUE),
        NO2 = mean(no2, na.rm = TRUE),
        SO2 = mean(so2, na.rm = TRUE),
        O3 = mean(o3, na.rm = TRUE)
      ) %>%
      tidyr::pivot_longer(
        everything(),
        names_to = "Pollutant",
        values_to = "Average"
      )
    p <- ggplot(data, aes(Pollutant, Average, fill = Pollutant)) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~Pollutant, scales = "free_y") +
      theme_minimal()
    ggplotly(p)
  })
  output$correlation_plot <- renderPlotly({
    
    correlation_data <- filtered_data() %>%
      select(co, no2, so2, o3, temperature, dew_point)
    
    correlation_matrix <- cor(
      correlation_data,
      use = "complete.obs"
    )
    
    plot_ly(
      x = colnames(correlation_matrix),
      y = rownames(correlation_matrix),
      z = correlation_matrix,
      type = "heatmap",
      colors = colorRamp(c("blue", "white", "red")),
      text = round(correlation_matrix, 2),
      texttemplate = "%{text}"
    )
  })
  output$data_table <- renderDT({
    display_data <- filtered_data() %>%
      select(
        city, state, year, month,
        co, no2, so2, o3,
        temperature, dew_point
      )
    datatable(
      head(display_data, 100),
      options = list(
        scrollX = TRUE,
        pageLength = 10,
        autoWidth = TRUE
      ),
      rownames = FALSE
    )
  })
  output$download_data <- downloadHandler(
    filename = function() {
      "filtered_air_quality_data.csv"
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# Run application
shinyApp(ui = ui, server = server)