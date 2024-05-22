library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(reshape2)
library(ggplot2)
library(gridExtra)


# Medals by GDP
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

# top 10 countries medals vs top 10 gdp
top_ten_medal_winners <- df_full %>%
  filter(Year == 2016) %>%
  group_by(Year) %>%
  arrange(desc(Total_Medals)) %>%
  slice(1:10) %>%
  mutate(Category = "Top Medals")


top_gdp_countries <- df_full %>%
  filter(Year == 2016) %>%
  group_by(Year) %>%
  arrange(Year, desc(GDP)) %>%
  slice(1:10) %>%
  mutate(Category = "Top GDP")


medal_plot <- ggplot(top_ten_medal_winners, aes(x = reorder(Country, Total_Medals), y = Total_Medals)) +
  geom_bar(stat = "identity", position = "dodge", fill = "red") +
  scale_y_continuous(labels = abs, expand = c(0, 0)) +
  scale_x_discrete(position = "top") +
  labs(title = "Top 10 Medal Winners Each Year", 
       x = "Country", 
       y = "Number of Medals") +
  theme_minimal() +
  coord_flip()

medal_plot

gdp_plot <- ggplot(top_gdp_countries, aes(x = reorder(Country, GDP), y = -1 * GDP)) +
  geom_bar(stat = "identity", position = "dodge", fill = "blue") +
  scale_y_continuous(labels = abs, expand = c(0, 0)) +
  labs(title = "Top 10 GDP Countries", 
       x = "Country", 
       y = "GDP") +
  theme_minimal() +
  coord_flip()
    

gdp_plot

grid.arrange(gdp_plot, medal_plot, ncol=2)

# top 10 countries medals vs top 10 countries immigration 
df_full <- df_full %>%
  mutate(
    Immigration_Perc_of_total_Pop = as.numeric(as.character(Immigration_Perc_of_total_Pop)))

top_imm_rates_countries <- df_full %>%
  filter(Year == 2016) %>%
  group_by(Year) %>%
  arrange(desc(Immigration_Perc_of_total_Pop)) %>%
  slice(1:10) %>%
  mutate(Category = "Top Immigration Rates")

imm_rate_plot <- ggplot(top_imm_rates_countries, aes(x = reorder(Country, Immigration_Perc_of_total_Pop), y = (-1 * Immigration_Perc_of_total_Pop))) + 
  geom_bar(stat = "identity", position = "dodge", fill = "blue") +
  scale_y_continuous(labels = abs, expand = c(0, 0)) + 
  labs(title = "Top 10 Immigration Rates Countries", 
       x = "Country", 
       y = "Immigration Rate % of Population") +
  theme_minimal() + 
  coord_flip()

imm_rate_plot

grid.arrange(imm_rate_plot, medal_plot, ncol = 2)


#Medals bi Immigration Rate
df_full <- df_full %>%
  mutate(
    Immigration_Perc_of_total_Pop = as.numeric(as.character(Immigration_Perc_of_total_Pop)))

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

# EXample of Immigration rates: UK
# just plot frances medals vs Immigration rates
uk_pivot <- df_full %>%
  filter(Country == "United Kingdom")

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

