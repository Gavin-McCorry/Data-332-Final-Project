# Olympic Medals Relationship With GDP Immigration Rates

## About
This project explores the relationship between Olympic medals won by countries and their GDP (Gross Domestic Product) and immigration rates. By analyzing this relationship, we aim to understand how economic factors and immigration patterns might influence a country's performance in the Olympics.

## Data Dictionary


## Data Collection
- **Olympic Medals Data:** Obtained from Kaggle(A Data Science platform containing published data sets). [Source](https://www.kaggle.com/datasets/ramontanoeiro/summer-olympic-medals-1986-2020?resource=download)
- **GDP Data:**  Obtained from Kaggle(A Data Science platform containing published data sets)
- **Immigration Data:** Gathered from th United Nations website under Data, International Migrant Stock. [Source](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fwww.un.org%2Fdevelopment%2Fdesa%2Fpd%2Fsites%2Fwww.un.org.development.desa.pd%2Ffiles%2Fundesa_pd_2020_ims_stock_by_sex_and_destination.xlsx&wdOrigin=BROWSELINK)

  
## Data Cleaning
To be able to use all of this data, we first had to clean each data set speratley before being able to combine the data in one data frame. 

### Olympic Medals Data:
1. This data set was overall relativley clean. We started by adding a total medal column, done by dding up the medal counts of Gold, Silver, and Bronze for each country for each Olympic Games.
2. Next, to match the naming convention used in the other data sets a few country names were changed. EX:
```{r}
df_medals$Country_Name <- sub("Great Britain", "United Kingdom", df_medals$Country_Name)
```

### GDP Data:
1. 

### Immigration Data
1. This was by far the hardest data set to clean. To start the exel file that contained the data had 5 different sheets with different measurements of immigration for each. We elected to use the sheet containing "International migrant stock as a percentage of the total population". We decided that this would best show correlation between imigration and Olympic medals won since it shows th percentage of a country that are immigrants in a given year. As for the other sheets we deleted them.
2. The Data was given in an untidy way were each yar was a column containing an immigration rat for a corrrespoding country

## Shiny App
- The project includes a Shiny web application for interactive data visualization and exploration.
- Users can interact with the app to visualize the relationship between Olympic medals, GDP, and immigration rates through various charts and graphs.
- The app provides a user-friendly interface for exploring the data and gaining insights into the topic.

---
Feel free to customize the content and organization of the README file to better suit your project's needs. This layout provides a structured overview of the project, making it easier for others to understand and engage with your work.
