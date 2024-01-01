# Power BI Data Analysis Project

This project consists of 10 Milestone. Each milestone demonstrates different aspects of importing, manipulating and visualising data using Microsoft Power BI. 

### Table of Contents
1. [Import the Data](#import-the-data)
2. [Data Model](#data-model)
3. [Customer Detail Report Page](#customer-detail-report-page)
4. [Executive Summary Report Page](#executive-summary-report-page)
5. [Product Detail Report Page](#product-detail-report-page)
6. [Stores Map Report Page](#stores-map-report-page)
7. [Cross Filtering and Navigation](#cross-filtering-and-navigation)
8. [SQL Analysis](#sql-analysis)


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

## Product Detail Report Page

The purpose of this page is to provide an in-depth look of how the individual products are performing. As part of this report page the following visualisation have been created

### Gauge

Three gauges displaying Quarterly Orders, Revenue and Profit comparing the the Quarterly Target. The gauges used new measures that have been created for this purposes. Their DAX formulas can be seen below

```
Current Quarter Orders = CALCULATE([Total Orders], DATESQTD(Orders[Order Date]))
Target Quarter Orders = CALCULATE([Current Quarter Orders] * 1.10)
```

```
Current Quarter Revenue = CALCULATE([Total Revenue], DATESQTD(Orders[Order Date]))
Target Quarter Revenue = CALCULATE([Current Quarter Revenue] * 1.10)
```

```
Current Quarter Profit = CALCULATE([Total Profit], DATESQTD(Orders[Order Date]))
Target Quarter Profit = CALCULATE([Current Quarter Profit] * 1.10)
```

Additional conditional formating have been used to display the values in red if the target has not been met.

### Area chart

Area chart displaying how different products are performing over time with regards to the revenue using Dates column, Total Revenue measure and Products Category column.

### Table

A new table has been created to display all the products alongside their related revenue, total number of customers who bought the product, total orders and profit per order. Profit per order values have been calculated from already existed measures:

```
Profit per Order = [Total Profit] / [Total Orders]
```

### Scatter plot

To visualise and compare best to the worst selling products, scatter plot has been used, where profit per item and product quantity of each product category has been plotted. Profit per item is a new calculated column created within the Products table

```
Profit per Item = [Sale Price] - [Cost Price]
```

### Slicers

For the user to be able to filter the data in all the visualisations, two new slicers have been added. One to filter product category and one for the country. The slicers have been implemented so that the user is able to select multiple product categories but only one country. However, all countries can be selected using Select All tick box within the Country slicers.

#### Filtering side bar

These slicers have been implemented as a hidden feature and the user can bring them up using Filter icon in the navigation side bar. To achieve this, Bookmarks pane have been used to record current state of the page. Clickig the filter icon will bring the two slicers inside a rectangle and back button (these elements are grouped together using Selection pane). Once the filter is selected the user can click the back button to hide the filter side bar.

### Final result

![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/8b9ea0cf-f413-43fb-be9c-e20f4d3d754f)

![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/d2bdc55e-0adf-4f23-81a9-bc1d1b253e54)

## Stores Map Report Page

The purpose of this report page is to display a map with all the stores and be able to filter out the most profitable one and wheather they meet the quarterly set revenue and profit targets.

### Map

The page consist of a map visual with the Geographical hierarchy as the location and the bubble size as the Profit YTD measure. This allows to see locations with the highest profit when the user zooms in. 

### Slicer

Tile slicer has been setup for being able to filter the map by three countries and additional option to allow select all countries.

### Stores Drillthrough Page

To be able to see a progress of a given store a new stores drillthrough report page has been created with five additional visuals. The page has been set as a Drillthrough page with allowing drillthrough when used as a category.

#### Table

Displaying five top products with the Product description, Profit YTD, Total Orders and Total Revenue columns.

#### Column Chart

Viualising number of Total Orders ordered by product category

#### Gauges

Two new gauges, one for Profit YTD and one for Revenue YTD with the target set to 20 % year-on-year growth vs the same period in the last year. This required setting up two new measures.

```
Profit Goal = CALCULATE([Profit YTD] * 1.20, SAMEPERIODLASTYEAR(Dates[Date]))
Revenue Goal = CALCULATE([Revenue YTD] * 1.20, SAMEPERIODLASTYEAR(Dates[Date]))
```

### Stores Tooltip Page

The last step was to create a new tooltip page in order to be able to see each store's year-to-date profit performance against the profit target only by hovering over over a store. The profit gauge visual from the Stores Drillthrough Page was copied over and the page was set as a tooltip page. This allows the newly created page to be used as a tooltip. Finally, the Stores Map Page Tooltip was set to the newly created Tooltip page which got the final result of hovering over the stores and seeing the gauge visual.
### Final Results

**Stores Map**
![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/9c496d96-3987-48ca-a154-3e4e56a42398)

**Stores Drillthrough Page**
![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/2464fc81-6f31-4f47-84b4-cfd13b3ba01f)

**Tooltip Page**
![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/48f8b789-7367-4d7a-9044-a7eba2581f20)

**Setting Tooltip for the Map Page**
![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/d112496d-b7b1-49de-93fa-f6156ae8981e)

## Cross Filtering and Navigation

The last touch for the report was to sort out the cross-filtering of the visuals. Power BI uses cross-filtering as default and since it is not required for some of the visuals filter some other visuals, it is needed to edit their interactions. This can be achieved using Edit Interaction feature in the Format tab ribbon. This feature allows to switch on and of cross-filtering and highliting. The third option is to use no filter which is used in the case if it is not needed one visual to have any affect on the other.

<ins>**The follwing filtering has been changed**:</ins>

1. Product Category Bar Chart in **Executive Summary** page does not affect card visuals and KPI.
2. Top 20 Customers table in **Customer Detail** page does not affect any other visuals.
3. Total Customers by Product in the same page does not affect Line Graph in the **Customers Detail** page.
4. Total Customers by Country was set to cross-filter Total Customers by Product donut visual.
5. In the **Product Detail** page the scatter plot does not have any affect on any other visuals.

<ins>**Navigation side bar**</ins>

For each report page custome images have been added for easier navigation between pages. Each icon has a custome white image added and in the Format pane the image is set to a different color on hover. And an appropriate page has been assigned as the destination.

### Final result

**Edit interactions** example

![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/e0ebc262-ca47-4c78-9d3a-a78fe0383ff7)

**Side bar navigation** example

*Setting custome image on hovering*

![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/8ccc1d03-1680-4ce6-a751-8263aab1b866)

![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/969f4329-eb79-42ea-8f32-d2e18e6370d4)

*Setting Action to the appropriate page*

![image](https://github.com/robogo83/data-analytics-power-bi-report549/assets/45542109/cac2f276-57cb-49e4-aa4b-15345b85624d)

## SQL Analysis

As a part of this project, some basic SQL analysis has been conducted. This is important to provide data analysis for all the users who do not have access to tools such as Microsoft Power BI. As part of the analysis 5 questions have been answered using postgresql queries. First step was to connect to the sql server using **VS Code** and its **SQL Tools** extension. After connecting, the list of tables and columns in the orders-db database have been saved in the csv files.

After connecting to the database the following questions have been answered using SQL queries:
1. How many staff are there in all of the UK stores?
2. Which month in 2022 has had the highest revenue?
3. Which German store type had the highest revenue for 2022?
4. Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders.
5. Which product category generated the most profit for the "Wiltshire, UK" region in 2021?

The results of the queries have been exported and saved as CSV files and uploaded to this github repository.












