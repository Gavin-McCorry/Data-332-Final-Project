library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(readxl)
library(dplyr)
library(readr)
library(gridExtra)

df_full <- read_rds("Full Data Set")

ui <- dashboardPage(
  dashboardHeader(title = "Summer Olympic Medals Won Vs. Country GDP and Immigration Percentage", titleWidth = 800),
  dashboardSidebar(
    sidebarMenu(width = 4,
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("Graphs", icon = icon("chart-bar"),
               menuSubItem("Medals by GDP", tabName = "Medals_By_GDP"),
               menuSubItem("Medals by Immigration Rate", tabName = "Medals_by_Immigration_Rate"),
               menuSubItem("Example of Immigration Rates", tabName = "Ex_of_imm_rates"), 
               menuSubItem(HTML("Top 10 GDP Vs. Top 10 <br> Medal Winners"), tabName = "gdp_vs_medal"), 
               menuSubItem(HTML("Top 10 Immigration Rates <br> Vs. Top 10 Medal Winners"), tabName = "immrate_vs_medal")
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              h2("Home Page"), 
              fluidRow(
                box(title = "About", status = "primary",solidHeader = TRUE, width = 6,
                    HTML('<div style="font-size: 20px;">
                      Our goal with the project was to try and find a connection between countries, the amount of medals 
                      a country wins at a summer Olympic games, and that country\'s GDP and Immigration Rates. We 
                      hypothesized that both GDP and Immigration Rates would be positively correlated with the number 
                      of medals a country won at a summer Olympic games. This shiny app includes the cleaned data set 
                      we used to create our graphs and draw conclusions from. This data set is a cleaned combination of 
                      three different datasets with five variables, as seen in the displayed data set underneath the Data tab. The graphs we 
                      made can be found underneath the Graphs tab. This tab contains a dropdown with 5 different graphs that 
                      display the relationship between medals won and GDP and Immigration Rates.
                    </div>')
                ),
                box(title = "Authors", status = "primary", solidHeader = TRUE, width = 3,
                    HTML('<div style="font-size: 20px;">
                    Gavin McCorry and Patrick Mayer
                    </div>')
                )
              )
      ),
      tabItem(tabName = "data",
              h2("Data Set"), 
              DT::dataTableOutput("df_full_table")
      ),
      tabItem(tabName = "Medals_By_GDP",
              h2("Medals by GDP"),
              fluidRow(
                column(width = 8,
                       plotOutput("Medals_By_GDP_Chart", height = "800px", width = "100%")
                ),
                column(width = 4,
                       box(title = "About Graph", solidHeader = TRUE, status = "primary", width ="85%",
                           HTML('<div style="font-size: 20px;">Shows the relationship between the total number of medals won by a 
                           country and its GDP for every olympic year. The dashed regression line tends to show that higher GDP results
                           in winning more medals. 
                           </div>'))
                )
              )
      ),
      tabItem(tabName = "Medals_by_Immigration_Rate",
              h2("Medals by Immigration Rate"), 
              fluidRow(
                column(width = 8, 
                       plotOutput("Medals_by_Immigration_Rate_chart", height = "800px", width = "100%")
                ), 
                column(width = 4,
                       box(title = "About Graph", solidHeader = TRUE, status = "primary", width ="85%",
                           HTML('<div style="font-size: 20px;">This graph shows the relationship between the total number of medals won by a 
                           country and the immigration percentage of the total population. As you can see through the regression lines there 
                           isn’t one common singular trend between them.
                           </div>'))
                  
                )
              )
      ),
      tabItem(tabName = "Ex_of_imm_rates",
              h2("Example of Immigration Rates"), 
              fluidRow(
                column(width = 8, 
                       plotOutput("Ex_of_imm_rates_chart", height = "800px", width = "100%")
                ), 
                column(width = 4,
                       box(title = "About Graph", solidHeader = TRUE, status = "primary", width ="85%",
                           HTML('<div style="font-size: 20px;">This graph shows the relationship of the total number 
                           of medals and the immigration percentage of the total population of the United Kingdom. As 
                           you can see as the UK’s immigration percentage rose so did the total number of medals.
                           </div>'))
                       
                )
              )
      ), 
      tabItem(tabName = "gdp_vs_medal", 
              h2("Top 10 GDP Vs. Top 10 Medal Winners"), 
              fluidRow(
                column(width = 8, 
                       plotOutput("gdp_vs_medal_chart", height = "800px", width = "100%")
                ), 
                column(width =  4, 
                       box(title = "About Graph", solidHeader = TRUE, status = "primary", width ="85%",
                           HTML('<div style="font-size: 20px;"> This graph shows a comparison between the top 10 Countries by GDP and the 
                           top 10 Countries by medals won in 2016. As we can see from this graph only the United States is in both graphs. This is supirsing
                           given our graph compairng counties GDP to medals one seemed to have a decently strong positive corrilation. 
                           </div>'))
                )
              )
      ),
      tabItem(tabName = "immrate_vs_medal", 
              h2("Top 10 Immigration Rates Vs. Top 10 Medal Winners"), 
              fluidRow(
                column(width = 8, 
                       plotOutput("immrate_vs_medal_chart", height = "800px", width = "100%")
                ), 
                column(width =  4, 
                       box(title = "About Graph", solidHeader = TRUE, status = "primary", width ="85%",
                           HTML('<div style="font-size: 20px;"> This graph shows a comparison between the top 10 Countries by Immigartion as a perecentage of the 
                           totl population and the top 10 Countries by medals won in 2016. As we can see from this graph only Australia and Canada are in both
                           graphs. This isnt ass suprising as the GDP Vs. Medals graph because the correlation from our Immigration Rate Vs. Medal Count graph
                           didn\'t have a strong correlation.
                             </div>')))
              )
            )
    )
    
  )
)

server <- function(input, output) {
  df_full <- df_full %>%
    mutate(
      Immigration_Perc_of_total_Pop = as.numeric(as.character(Immigration_Perc_of_total_Pop)))
  
  uk_pivot <- df_full %>%
    filter(Country == "United Kingdom")
  
  # Top ten Medal Winners Pivot
  top_ten_medal_winners <- df_full %>%
    filter(Year == 2016) %>%
    group_by(Year) %>%
    arrange(desc(Total_Medals)) %>%
    slice(1:10) %>%
    mutate(Category = "Top Medals")
  
  # Top Ten GDP Countries
  top_gdp_countries <- df_full %>%
    filter(Year == 2016) %>%
    group_by(Year) %>%
    arrange(Year, desc(GDP)) %>%
    slice(1:10) %>%
    mutate(Category = "Top GDP")
  
  # Top 10 Immigration Rates Countries
  top_imm_rates_countries <- df_full %>%
    filter(Year == 2016) %>%
    group_by(Year) %>%
    arrange(desc(Immigration_Perc_of_total_Pop)) %>%
    slice(1:10) %>%
    mutate(Category = "Top Immigration Rates")  
  
  top_imm_rates_countries <- df_full %>%
    filter(Year == 2016) %>%
    group_by(Year) %>%
    arrange(desc(Immigration_Perc_of_total_Pop)) %>%
    slice(1:10) %>%
    mutate(Category = "Top Immigration Rates")
  
  medal_plot <- ggplot(top_ten_medal_winners, aes(x = reorder(Country, Total_Medals), y = Total_Medals)) +
    geom_bar(stat = "identity", position = "dodge", fill = "red") +
    scale_y_continuous(labels = abs, expand = c(0, 0)) +
    scale_x_discrete(position = "top") +
    labs(title = "Top 10 Medal Winners Each Year", 
         x = "Country", 
         y = "Number of Medals") +
    theme_minimal() +
    coord_flip()
  
  gdp_plot <- ggplot(top_gdp_countries, aes(x = reorder(Country, GDP), y = -1 * GDP)) +
    geom_bar(stat = "identity", position = "dodge", fill = "blue") +
    scale_y_continuous(labels = abs, expand = c(0, 0)) +
    labs(title = "Top 10 GDP Countries", 
         x = "Country", 
         y = "GDP") +
    theme_minimal() +
    coord_flip()
  
  
  imm_rate_plot <- ggplot(top_imm_rates_countries, aes(x = reorder(Country, Immigration_Perc_of_total_Pop), y = (-1 * Immigration_Perc_of_total_Pop))) + 
    geom_bar(stat = "identity", position = "dodge", fill = "blue") +
    scale_y_continuous(labels = abs, expand = c(0, 0)) + 
    labs(title = "Top 10 Immigration Rates Countries", 
         x = "Country", 
         y = "Immigration Rate % of Population") +
    theme_minimal() + 
    coord_flip()
  
  # Server logic for the Home page
  # output$homeContent <- renderUI({ ... })
  
  # Server logic for the Data page
  output$df_full_table <- DT::renderDataTable(df_full)
  
  # Server logic for Medals_By_GDP_Chart
  output$Medals_By_GDP_Chart <- renderPlot({
    ggplot(df_full, aes(x = GDP, y = Total_Medals)) +
      geom_point(aes(color = Country), size = 3, alpha = 0.7, show.legend = FALSE) + # Points colored by country, legend hidden
      geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") + # Add regression line
      scale_x_continuous(limits = c(min(df_full$GDP, na.rm = TRUE), max(df_full$GDP, na.rm = TRUE))) + # Set x-axis limits
      labs(title = "Total Medals by GDP",
           x = "GDP",
           y = "Total Medals") +
      theme_minimal(base_size = 15) + # Use a minimal theme with larger base font size
      theme(
        legend.position = "none", # Hide the legend
        strip.background = element_rect(fill = "lightblue", color = "black"), # Customize facet strip background
        strip.text = element_text(face = "bold") # Bold facet strip text
      ) +
      facet_wrap(~ Year, ncol = 3) # Facet by Year with 3 columns
  })
  
  # Server logic for Medals_by_Immigration_Rate_chart
  output$Medals_by_Immigration_Rate_chart <- renderPlot({ 
    ggplot(df_full, aes(x = Immigration_Perc_of_total_Pop, y = Total_Medals)) +
      geom_point(aes(color = Country), size = 3, alpha = 0.7, show.legend = FALSE) + # Points colored by country
      geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") + # Add regression line
      scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) + # Set x-axis limits and breaks
      labs(title = "Total Medals by Immigration ",
           x = "Immigrant Percentage of Total Population",
           y = "Total Medals",
           color = "Country") + # Add color legend
      theme_minimal(base_size = 15) + # Use a minimal theme with larger base font size
      theme(
        legend.position = "bottom", # Position the legend at the bottom
        strip.background = element_rect(fill = "lightblue", color = "black"), # Customize facet strip background
        strip.text = element_text(face = "bold") # Bold facet strip text
      ) +
      facet_wrap(~ Year, ncol = 3) # Facet by Year with 3 columns
    })
  
  # Server logic for Graph 3
  output$Ex_of_imm_rates_chart <- renderPlot({ 
    ggplot(uk_pivot, aes(x = Immigration_Perc_of_total_Pop, y = Total_Medals)) +
    geom_point(aes(color = Country), size = 3, alpha = 0.7, show.legend = FALSE) + # Points colored by country
    geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") + # Add regression line
    scale_x_continuous(limits = c(0, 20), breaks = seq(0, 20, 4)) + # Set x-axis limits and breaks
    labs(title = "UK Medals by Immigration Percentage",
         x = "Immigrant Percentage of Total Population",
         y = "Total Medals",
         color = "Country") + # Add color legend
    theme_minimal(base_size = 15) + # Use a minimal theme with larger base font size
    theme(
      legend.position = "bottom", # Position the legend at the bottom
      strip.background = element_rect(fill = "lightblue", color = "black"), # Customize facet strip background
      strip.text = element_text(face = "bold")
      ) # Bold facet strip text 
    })
  
  output$gdp_vs_medal_chart <- renderPlot({
    grid.arrange(gdp_plot, medal_plot, ncol=2)
  })
  
  output$immrate_vs_medal_chart <- renderPlot({
    grid.arrange(imm_rate_plot, medal_plot, ncol = 2)
  })

}

shinyApp(ui, server)

  

