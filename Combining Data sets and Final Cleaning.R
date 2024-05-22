library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(reshape2)

setwd("C:/Users/gwmcc/OneDrive/Documents/GitHub/Data-332-Final Project/Data")

df_GDP <- read_rds("GDP")
df_medals <- read_rds("Olympic Medals Count Data")
df_immigration_rates <- read_rds("Country_Immigration_perc_by_year")

df_full <- merge(df_medals, df_GDP, by = "Country_Year")
df_full <- merge(df_complete, df_immigration_rates, by = "Country_Year")

df_full <- separate(df_complete, Country_Year, into = c("Country", "Year"), sep = "-")

df_full$Host_country = NULL
df_full$Host_city = NULL
df_full$Country_Code = NULL
df_full$`Country Code`= NULL
df_full$`Location code`= NULL

# Removing medal columns besides total medals
df_full$Gold = NULL
df_full$Silver = NULL
df_full$Bronze = NULL

df_full <- df_full %>%
  rename(Immigration_Perc_of_total_Pop = percentage)

saveRDS(df_full, "Full Data Set")
