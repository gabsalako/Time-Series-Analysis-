#load packages
library(tidyr)
library(ggplot2)
library(dplyr)
library(forecast)
library(mgcv)
library(shiny)

#################################################
# Soil Fauna Shiny Dashboard
# Interactive exploration of recovery dynamics
#################################################
# -------------------------------
# Data Preparation
# -------------------------------
Ewts_data.1 <- data.frame(
  Year = 2001:2010,
  Endogeic = c(302, 3, 6, 250, 290, 307, 291, 350, 78, 40),
  Epigeic  = c(190, 15, 25, 140, 14, 40, 219, 1, 13, 19),
  Anecic   = c(52, 2, 3, 65, 72, 18, 75, 22, 12, 10)
)

Ewts_long.1 <- Ewts_data.1 %>%
  pivot_longer(cols = -Year,
               names_to = "Species",
               values_to = "Abundance") %>%
  mutate(Species = as.factor(Species))

# Fit GAMM model once
model <- gamm(
  Abundance ~ Species + s(Year, by = Species, k = 5),
  random = list(Species = ~1),
  data = Ewts_long.1,
  family = poisson(link = "log")
)

# -------------------------------
# UI
# -------------------------------
ui <- fluidPage(
  titlePanel("🌱 Soil Fauna Recovery Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        "species",
        "Select Ecological Groups:",
        choices = levels(Ewts_long.1$Species),
        selected = levels(Ewts_long.1$Species)
      ),
      
      sliderInput(
        "year",
        "Select Year Range:",
        min = min(Ewts_long.1$Year),
        max = max(Ewts_long.1$Year),
        value = c(min(Ewts_long.1$Year), max(Ewts_long.1$Year)),
        step = 1,
        sep = ""
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Time Series",
                 plotOutput("timePlot")),
        
        tabPanel("Area Plot",
                 plotOutput("areaPlot")),
        
        tabPanel("Model Trends",
                 plotOutput("gamPlot")),
        
        tabPanel("Model Summary",
                 verbatimTextOutput("modelSummary"))
      )
    )
  )
)

# -------------------------------
# Server
# -------------------------------
server <- function(input, output) {
  
  # Reactive filtered data
  filtered_data <- reactive({
    Ewts_long.1 %>%
      filter(
        Species %in% input$species,
        Year >= input$year[1],
        Year <= input$year[2]
      )
  })
  
  # ---------------------------
  # Time Series Plot
  # ---------------------------
  output$timePlot <- renderPlot({
    ggplot(filtered_data(),
           aes(x = Year, y = Abundance, color = Species)) +
      geom_point(size = 3) +
      geom_line() +
      theme_minimal() +
      labs(title = "Species Abundance Over Time",
           y = "Abundance")
  })
  
  # ---------------------------
  # Area Plot
  # ---------------------------
  output$areaPlot <- renderPlot({
    ggplot(filtered_data(),
           aes(x = Year, y = Abundance, fill = Species)) +
      geom_area(alpha = 0.7) +
      theme_minimal() +
      labs(title = "Recovery Trajectory",
           y = "Abundance")
  })
  
  # ---------------------------
  # GAMM Smooth Plot
  # ---------------------------
  output$gamPlot <- renderPlot({
    plot(model$gam, pages = 1, shade = TRUE)
  })
  
  # ---------------------------
  # Model Summary
  # ---------------------------
  output$modelSummary <- renderPrint({
    summary(model$gam)
  })
}

# -------------------------------
# Run App
# -------------------------------
shinyApp(ui = ui, server = server)
