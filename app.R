combined_dashboard_data <- readRDS("combined_dashboard_data.rds")

# Load required libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(DT)

# Dashboard Function for Combined Strategy and Utilization View
run_combined_dashboard <- function(combined_dashboard_data) {
  ui <- dashboardPage(
    dashboardHeader(title = "Fleet Intelligence Dashboard"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Cost Strategy", tabName = "strategy_tab", icon = icon("dollar-sign")),
        menuItem("Asset Utilization", tabName = "utilization_tab", icon = icon("tachometer-alt")),
        menuItem("Strategic Insights", tabName = "combined_tab", icon = icon("project-diagram")),
        selectInput("company", "Filter by Company", choices = c("All", unique(combined_dashboard_data$Company)), selected = "All"),
        selectInput("risk", "Filter by Risk Level", choices = c("All", unique(combined_dashboard_data$risk_level)), selected = "All"),
        selectInput("strategy", "Filter by Strategy", choices = c("All", unique(combined_dashboard_data$strategy)), selected = "All")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "strategy_tab",
                fluidRow(
                  valueBoxOutput("total_assets_strategy"),
                  valueBoxOutput("total_cost_strategy"),
                  valueBoxOutput("estimated_savings_strategy"),
                  valueBoxOutput("avg_repair_duration")
                ),
                fluidRow(
                  box(title = "Predicted Cost by Strategy", width = 6, plotOutput("cost_by_strategy")),
                  box(title = "Strategy Distribution", width = 6, plotOutput("strategy_distribution"))
                ),
                fluidRow(
                  box(title = "Company-wise Predicted Cost", width = 12, plotOutput("cost_by_company"))
                )
        ),
        tabItem(tabName = "utilization_tab",
                fluidRow(
                  valueBoxOutput("total_assets_util"),
                  valueBoxOutput("avg_util_score"),
                  valueBoxOutput("expected_time_savings"),
                  valueBoxOutput("expected_cost_savings")
                ),
                fluidRow(
                  box(title = "Strategy 2025 Breakdown", width = 6, plotOutput("strategy_2025_chart")),
                  box(title = "Utilization Score Distribution", width = 6, plotOutput("util_score_dist"))
                ),
                fluidRow(
                  box(title = "Risk Level by Company", width = 12, plotOutput("risk_by_company"))
                )
        ),
        tabItem(tabName = "combined_tab",
                fluidRow(
                  box(title = "Cost vs Time Savings by Strategy", width = 6, plotOutput("cost_vs_time")),
                  box(title = "Confidence vs Risk Rate", width = 6, plotOutput("confidence_vs_risk"))
                ),
                fluidRow(
                  box(title = "Combined Insights Table", width = 12, DTOutput("combined_table"))
                )
        )
      )
    )
  )
  
  server <- function(input, output) {
    filtered_data <- reactive({
      df <- combined_dashboard_data
      if (input$company != "All") df <- df %>% filter(Company == input$company)
      if (input$risk != "All") df <- df %>% filter(risk_level == input$risk)
      if (input$strategy != "All") df <- df %>% filter(strategy == input$strategy)
      df
    })
    
    # Strategy Tab KPIs
    output$total_assets_strategy <- renderValueBox({
      valueBox(nrow(filtered_data()), "Total Assets", icon = icon("truck"), color = "aqua")
    })
    
    output$total_cost_strategy <- renderValueBox({
      valueBox(sum(filtered_data()$total_predicted_cost, na.rm = TRUE), "Total Predicted Cost", icon = icon("dollar-sign"), color = "blue")
    })
    
    output$estimated_savings_strategy <- renderValueBox({
      valueBox(sum(filtered_data()$estimated_savings, na.rm = TRUE), "Estimated Savings", icon = icon("chart-line"), color = "green")
    })
    
    output$avg_repair_duration <- renderValueBox({
      valueBox(round(mean(filtered_data()$avg_repair_duration, na.rm = TRUE), 1), "Avg. Repair Duration", icon = icon("clock"), color = "orange")
    })
    
    output$cost_by_strategy <- renderPlot({
      ggplot(filtered_data(), aes(x = strategy, y = total_predicted_cost, fill = strategy)) +
        geom_bar(stat = "summary", fun = sum) + theme_minimal()
    })
    
    output$strategy_distribution <- renderPlot({
      ggplot(filtered_data(), aes(x = strategy, fill = strategy)) +
        geom_bar() + theme_minimal()
    })
    
    output$cost_by_company <- renderPlot({
      ggplot(filtered_data(), aes(x = reorder(Company, -total_predicted_cost), y = total_predicted_cost, fill = Company)) +
        geom_bar(stat = "summary", fun = sum) + coord_flip() + theme_minimal()
    })
    
    # Utilization Tab KPIs
    output$total_assets_util <- renderValueBox({
      valueBox(nrow(filtered_data()), "Total Assets", icon = icon("warehouse"), color = "purple")
    })
    
    output$avg_util_score <- renderValueBox({
      valueBox(round(mean(filtered_data()$utilization_score, na.rm = TRUE), 1), "Avg Utilization Score", icon = icon("tachometer-alt"), color = "yellow")
    })
    
    output$expected_time_savings <- renderValueBox({
      valueBox(sum(filtered_data()$expected_time_savings_hours, na.rm = TRUE), "Time Savings (hrs)", icon = icon("hourglass-half"), color = "olive")
    })
    
    output$expected_cost_savings <- renderValueBox({
      valueBox(sum(filtered_data()$expected_cost_savings, na.rm = TRUE), "Cost Savings ($)", icon = icon("piggy-bank"), color = "maroon")
    })
    
    output$strategy_2025_chart <- renderPlot({
      ggplot(filtered_data(), aes(x = strategy_2025, fill = strategy_2025)) +
        geom_bar() + theme_minimal()
    })
    
    output$util_score_dist <- renderPlot({
      ggplot(filtered_data(), aes(x = utilization_score)) +
        geom_histogram(bins = 30, fill = "steelblue") + theme_minimal()
    })
    
    output$risk_by_company <- renderPlot({
      ggplot(filtered_data(), aes(x = Company, fill = risk_level)) +
        geom_bar(position = "dodge") + theme_minimal() + coord_flip()
    })
    
    # Combined Tab Visuals
    output$cost_vs_time <- renderPlot({
      ggplot(filtered_data(), aes(x = expected_time_savings_hours, y = estimated_savings, color = strategy)) +
        geom_point(alpha = 0.6) + theme_minimal()
    })
    
    output$confidence_vs_risk <- renderPlot({
      ggplot(filtered_data(), aes(x = confidence_level, y = risk_rate, color = risk_level)) +
        geom_point(alpha = 0.6) + theme_minimal()
    })
    
    output$combined_table <- renderDT({
      datatable(filtered_data(), options = list(scrollX = TRUE))
    })
  }
  
  shinyApp(ui, server)
}





run_combined_dashboard(combined_dashboard_data)
