-- How many staff are there in all of the UK stores? 
SELECT COUNT(DISTINCT staff_numbers) AS number_of_staff
FROM dim_store