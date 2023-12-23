# Power BI Data Analysis Project

This project consists of 10 Milestone. Each milestone demonstrates different aspects of importing, manipulating and visualising data using Microsoft Power BI. 

### Table of Contents
1. [Import the Data](#import-the-data)
2. [Data Model](#data-model)


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


Seperate Measure table has been created to hold all the measures that will be used for data analysis. Following measures have been ceated using DAX:
Total Orders

Total Revenue

Total Profit

Total Customers

Total Quantity

Profit YTD

Revenue YTD

The last step at this stage was to create hierachies to allow to drill down into the data and perform data analysis. The following hierarchies have been created within our tables.

1. Date hierarchy with the following levels: 

Start of Year
Start of Quarter
Start of Month
Start of Week
Date 

2. Geography hierarchy with the following levels: 

World Region
Country
Country Region 

To create geography hierarchy some additional data transformation was necessary, such as creating calculated columns; Country, Geography; and assign these columns correct data category.
