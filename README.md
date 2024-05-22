# Olympic Medals Relationship With GDP Immigration Rates

## About
This project explores the relationship between Olympic medals won by countries and their GDP (Gross Domestic Product) and immigration rates. By analyzing this relationship, we aim to understand how economic factors and immigration patterns might influence a country's performance in the Olympics.

## Data Dictionary
- **Country:** The name of the country
- **Year:** The year all the data was recorded from
- **Total Medals:** The total amount of medals one by a country at a single Olympics
- **GDP:** The Gross Domestic Product of the country
- **Immigration_Perc_of_total_Pop:** The immigration percentage of the country's population

## Data Collection
- **Olympic Medals Data:** Obtained from Kaggle(A Data Science platform containing published data sets). [Source](https://www.kaggle.com/datasets/ramontanoeiro/summer-olympic-medals-1986-2020?resource=download)
- **GDP Data:**  Obtained from Kaggle(A Data Science platform containing published data sets). [Source](https://www.kaggle.com/datasets/yapwh1208/countries-gdp-2012-to-2021?resource=download)
- **Immigration Data:** Gathered from the United Nations website under Data, International Migrant Stock. [Source](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fwww.un.org%2Fdevelopment%2Fdesa%2Fpd%2Fsites%2Fwww.un.org.development.desa.pd%2Ffiles%2Fundesa_pd_2020_ims_stock_by_sex_and_destination.xlsx&wdOrigin=BROWSELINK)

  
## Data Cleaning
To be able to use all of this data, we first had to clean each data set separately before being able to combine the data in one data frame. 

### Olympic Medals Data:
1. This data set was overall relatively clean. We started by adding a total medal column, done by adding up the medal counts of Gold, Silver, and Bronze for each country for each Olympic Games.
2. Next, to match the naming convention used in the other data sets a few country names were changed. EX:
```{r}
df_medals$Country_Name <- sub("Great Britain", "United Kingdom", df_medals$Country_Name)
```

### GDP Data:
1. This data set was organized poorly. It had all the countries as rows and then each year as a different column, resulting in a lot of null values. To fix this we decided to change all the year columns into 1 single year column that displays the year
```
gdp <- melt(gdp, id.vars = c("Country Name", "Country Code"), variable.name = "Year", value.name = "GDP")
```
2. We also had to filter the Year => 1990, since the data started in 1960 but the first year we had Olympic data was 1990

### Immigration Data
1. This was by far the hardest data set to clean. To start the Excel file that contained the data had 5 different sheets with different measurements of immigration for each. We elected to use the sheet containing "International migrant stock as a percentage of the total population". We decided that this would best show the correlation between immigration and Olympic medals won since it shows the percentage of a country that is immigrants in a given year. As for the other sheets we deleted them.
2. The Data was given in an untidy way where each year was a column containing an immigration rate for a corresponding country. To fix this we first melted the data to be tidy:
```{r}
df <- melt(df, 
          id.vars = c("Country", "Location code"), 
          variable.name = "Year", 
          value.name = "Immigration_Perc_of_total_Pop")
```
3. The Last thing we had to do was fill in the missing data points. Since the Immigration percentage was only evaluated every 5 years, for the missing data we assumed the immigration rate was the same for the next 4 years after it was recorded. Using this assumption we filled in every missing year's immigration percentage using the most recent recorded immigration percentage:
```{r}
df <- df %>%
  group_by(Country, `Location code`) %>%
  complete(year = full_seq(1990:2020, 1)) %>% 
  fill(percentage, .direction = "down")
```

### Combining the Data
The last thing we had to do in the cleaning process was to combine the data. To do this we created a primary key "Country_Year" where for each separate data frame we combned the country name and  the year, separating the two using a hyphen:
```{r}
df <- df %>%
  unite("Country_Year", Country, year, sep = "-")
```
Once this was done we could merge the data on that primary key:
```{r}
df_full <- merge(df_medals, df_GDP, by = "Country_Year")
df_full <- merge(df_complete, df_immigration_rates, by = "Country_Year")
```
After the data was combined we split the "Country_Year" column back into the original columns "Country" and "Year":
```{r}
df_full <- separate(df_complete, Country_Year, into = c("Country", "Year"), sep = "-")
```

## Shiny App
https://gavin-mccorry.shinyapps.io/Olympic-Medals-App/

## Copyright Notice

The content and code snippets in this repository, unless otherwise indicated, are Gavin McCorry and Patrick Mayer's. All rights reserved.

### Restrictions on Use

1. **Use of Code**: You may view and refer to the code for educational and personal use. However, you may not reproduce, distribute, or create derivative works based on this code without explicit permission from the copyright owner.

2. **Use of Shiny App**: The Shiny app deployed in this repository is intended for demonstration purposes only. You may interact with the app through the provided link but may not copy, modify, or redistribute the app without permission.

### Permissions

For inquiries regarding the use of the code or the Shiny app for commercial or other purposes not mentioned above, please contact [gavin.mccorry2025@gmail.com].

### Attribution

If you refer to or use any portion of this repository in your own work, please provide appropriate attribution by linking back to this repository.


