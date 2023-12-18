# Power BI Data Analysis Project

This project consists of 10 Milestone. Each milestone demonstrates different aspects of importing, manipulating and visualising data using Microsoft Power BI. 

### Table of Contents
1. [Import the Data](#Import the Data)


## Import the Data

In the first step, four different tables have been important using four different methods. 

1. Orders - this table have been imported using Microsoft Azure SQL. Some basic transformation have been executed using Power Query Editor, such as removing, splitting, filtering out missing values in a column. 
2. Products - table has been imported from CSV file. Apart from basic transformation, new calculated column has been created to unify weights column. This column originally held values in kg and g. Splitting the column and then creating a calculated column with a condition to calculate all values in g into kg.
3. Stores - imported using Microsoft Blob Storage.
4. Customers - data for this table have come from zip file consisting of 3 folders. Using Power BI Folder Folder data connecter, the folders have been merged together. Columns with first and last name have been merged together into one Full Name column

For all tables, the columns have been renamed according to the Power BI column naming conventions. 
