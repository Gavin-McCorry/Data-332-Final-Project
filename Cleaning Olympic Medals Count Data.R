library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(reshape2)

setwd("C:/Users/gwmcc/OneDrive/Documents/GitHub/Data-332-Final Project")

df_medals <- read.csv("Summer_olympic_Medals.csv")

df_medals$Total_Medals <- df_medals$Gold + df_medals$Silver + df_medals$Bronze

df_medals$Country_Name <- sub("Great Britain", "United Kingdom", df_medals$Country_Name)
df_medals$Host_country <- sub("Great Britain", "United Kingdom", df_medals$Host_country)


df_medals <- df_medals %>%
  unite("Country_Year", Country_Name, Year, sep = "-")

saveRDS(df_medals, "Olympic Medals Count Data")
