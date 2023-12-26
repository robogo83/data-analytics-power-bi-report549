# Power BI Data Analysis Project

This project consists of 10 Milestone. Each milestone demonstrates different aspects of importing, manipulating and visualising data using Microsoft Power BI. 

### Table of Contents
1. [Import the Data](#import-the-data)
2. [Data Model](#data-model)
3. [Customer Detail Report Page](#customer-detail-report-page)
4. [Executive Summary Report Page](#executive-summary-report-page)


## Import the Data

In the first step, four different tables have been important using four different methods. 

1. Orders - this table have been imported using Microsoft Azure SQL. Some basic transformation have been executed using Power Query Editor, such as removing, splitting, filtering out missing values in a column. 
2. Products - table has been imported from CSV file. Apart from basic transformation, new calculated column has been created to unify weights column. This column originally held values in kg and g. Splitting the column and then creating a calculated column with a condition to calculate all values in g into kg.
3. Stores - imported using Microsoft Blob Storage.
4. Customers - data for this table have come from zip file consisting of 3 folders. Using Power BI Folder Folder data connecter, the folders have been merged together. Columns with first and last name have been merged together into one Full Name column

For all tables, the columns have been renamed according to the Power BI column naming conventions. 

## Data Model

First step of this stage was to create Date table with the following columns:
- Day of Week
- Month Number 
- Month Name
- Quarter
- Year
- Start of Year
- Start of Quarter
- Start of Month
- Start of Week

Having all the tables prepared, I have checked if all relationship in the Power BI model view are correct to form star schema data model. The model can be seen on the image below

![Data_Model](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/6affcd37-ba6f-48ae-a463-b93e19118ede)

Seperate Measure table has been created to hold all the measures that will be used for data analysis. Following measures have been ceated using DAX:

**Total Orders**
```
Total Orders = COUNT(Orders[Order Date])
```
**Total Revenue**
```
Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))
```
**Total Profit**
```
Total Profit = SUMX(Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price]) * (Orders[Product Quantity])))
```
**Total Customers**
```
Total Customers = DISTINCTCOUNT(Orders[User ID])
```
**Total Quantity**
```
Total Quantity = SUMX(Orders, [Product Quantity]) 
```
**Profit YTD**
```
Profit YTD = TOTALYTD([Total Profit], Orders[Order Date]) 
```
**Revenue YTD**
```
Revenue YTD = TOTALYTD([Total Revenue], Orders[Order Date])
```

The last step at this stage was to create hierachies to allow to drill down into the data and perform data analysis. The following hierarchies have been created within our tables.

1. **Date hierarchy** with the following levels: 

***Start of Year -> Start of Quarter -> Start of Month -> Start of Week -> Date***

3. **Geography hierarchy** with the following levels: 

***World Region -> Country -> Country Region***

To create geography hierarchy some additional data transformation was necessary, such as creating calculated columns; Country, Geography; and assign these columns correct data category.

## Customer Detail Report Page

Customer Deatil Report Page consists of series of graphs that represent information about customers. In particular, the following visualisation have been used.

### Cards

Five cards have been used in the report to represent the following:

1. *Number of unique customers* - Total Customers measure have been used with 2 decimal numbers
2. *Revenue per Customer* - the respective measure from the measure table has been used. The measure data type has been changed to currency so the currency value is displayed.
3. *Top Revenue Customer* - for this card a new measure has been created to pull a top revenue customer using TOPN function, where the top 20 revenue customers are displayed.
                          For the measure the following formula has been used
   ```
   Top Customer Name = CALCULATE(FIRSTNONBLANK('Customers'[Full Name], 1),TOPN(1, ALL('Customers'), [Revenue per Customer], DESC))
   ```
5. *Number of Orders* - similar approach has been chosed. The following measure helped to pull the data. This approach has been chosen to adapt the value dynamicaly. Meaning if the top cutomer changes in the                             future the value in the report will change to after refreshing
   ```
   Top Customer Number of Orders = CALCULATE([Total Orders], TOPN(1, ALL('Customers'), [Total Revenue], DESC))
    ```
6. *Total Revenue* - the third new measure with the following formula
  ```
  Top Customer Revenue = CALCULATE([Total Revenue],TOPN(1, ALL('Customers'), [Total Revenue], DESC))
  ```

### Donut

Donut visualisation represents total customers by country. The visualisation filter customers by country using a filter from the Country column in the Customers table.

### Column Chart

This is yet another visualisation of customers but this time it is filtering customers by product type, where category column from Products table has been used.

### Table

Table visualisation has been used to display the top 20 customers ordered by their revenue. This was achieved by using TOPN filter for the Full Name column filtering out by Revenue per Customer measure.

### Line Graph

Line graph is a time visualisation of how the number of total customers change over period of time. In order to give more options, drill down feature using Data Hierarchy have been used. This way, the user can choose to drill down through Start of year, quarter and month.
This graph in addition introduces the trend line and prediction for the next 10 periods with 95% confidence interval.

### Slicer

Last but not least, between slicer has been used to add an option to filter the visualisation results according to the year. In this case 2010 - 2023.

### Final result

On the screenshot below, the final result of the report can be seen including the layout. 

![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/b3b972f6-2e20-472a-8b6e-6c6921db7058)

## Executive Summary Report Page

The purpose of this page is to provide high-level executive data analysis summary. As part of this summary a report with the following visualisations have been created.

### Cards

Three cards to visualise **Total Revenue**, **Total Orders**, **Total Profit**. For these cards respective measures have been used that have been created in the early stages of the data preparation have been created.

## Donut

Two donuts visualisations to compare revenue by store and country. This has been achieved using filtering feature in the Power BI.

### Line graph

As in the Customer Detail Page, this graph uses Power BI drill down feature to visualise total revenue using different time periods (Years, Quarters, Months).

### Clustered bar chart

This bar chart visualise total orders by product category on y-axis. 

### KPI

The new type of a visualistion, compared to Customer report page, are three KPI reports. These reports display quarterly revenue, orders and profit. The advantage of KPI reports is that they an display three vital information; value, trend and target. Since in this case, the intention is to provide a quarter comparison. The trend has been used as Start of Quarter (from our Date table), and for the target, the Previous Quarter Profit, Revenue and Orders have been used. To achieve this Power BI PREVIOUSQUARTER function has been used. DAX formula for these three new measures:

```
Previous Quarter Orders = CALCULATE([Total Orders], PREVIOUSQUARTER(Orders[Order Date]))
```

```
Previous Quarter Profit = CALCULATE([Total Profit], PREVIOUSQUARTER(Orders[Order Date]))
```

```
Previous Quarter Revenue = CALCULATE([Total Revenue], PREVIOUSQUARTER(Orders[Order Date]))
```

### Final result

Below, you can see a screenshot of the final design of the executive summary report page.

![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/6dd89976-80ae-418e-9fe4-a38000bc3485)

