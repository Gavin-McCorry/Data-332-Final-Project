library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(reshape2)

setwd("C:/Users/gwmcc/OneDrive/Documents/GitHub/Data-332-Final Project/Data")

df <- read_xlsx("undesa_pd_2020_ims_stock_by_sex_and_destination.xlsx")

# melt the data from 5 columns to 2
df <- melt(df, 
          id.vars = c("Country", "Location code"), 
          variable.name = "year", 
          value.name = "percentage")

# Change year from time format to integer
df$year <- as.numeric(as.character(df$year))

df$Country <- sub("\\*$", "", df$Country)
df$Country <- sub("United States of America", "United States", df$Country)

# Complete missing combinations of Country and year
df <- df %>%
  group_by(Country, `Location code`) %>%
  complete(year = full_seq(1990:2020, 1)) %>% 
  fill(percentage, .direction = "down")

df <- df %>%
  unite("Country_Year", Country, year, sep = "-")

saveRDS(df, "Country_Immigration_perc_by_year")