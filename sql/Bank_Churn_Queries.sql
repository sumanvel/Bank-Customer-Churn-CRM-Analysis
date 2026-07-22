use BankChurnDB;

-- Objective Questions

-- 2.	Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year. 

select CustomerID, Surname, EstimatedSalary, BankDOJ from customerinfo
where quarter(bankdoj) = 4
order by estimatedsalary desc
limit 5;

-- 3.	Calculate the average number of products used by customers who have a credit card. 

select avg(Numofproducts) as Avg_Products
from bank_churn 
where hascrCard = 1;

-- 5.	Compare the average credit score of customers who have exited and those who remain. 

select 
case
when exited = 1 then "Exited"
else "Retained" 
end
as CustomerStatus, round(avg(creditscore),2) as AvgCreditScore
from bank_churn 
group by exited;

-- 6.	Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? 

select g.GenderCategory, 
sum(case when b.isActivemember = 1 then 1 else 0 end) as ActiveCustomer,
round(avg(c.EstimatedSalary),2) as AvgEstimatedSalary
from bank_churn b join customerinfo c on b.customerid = c.customerid
join gender g on g.genderid = c.genderid
group by g.gendercategory;


-- 7.	Segment the customers based on their credit score and identify the segment with the highest exit rate. 

with cte1 as 
(
select *, 
case
when creditscore >= 800 then "Excellent"
when creditscore >= 740 then "Very Good"
when creditscore >= 670 then "Good"
when creditscore >= 580 then "Fair"
else "Poor"
end as CreditCategory 
from bank_churn 
)
select CreditCategory, count(*) as TotalCustomers,
sum(case when exited = 1 then 1 else 0 end)as ExitedCustomers,
round((sum(case when exited = 1 then 1 else 0 end)*100/count(*)),2) as ExitRate
from cte1
group by CreditCategory
order by exitrate desc;

-- 8.	Find out which geographic region has the highest number of active customers with a tenure greater than 5 years.

select  GeographyLocation, count(*) as ActiveCustomers
from customerinfo c join bank_churn b on c.customerid = b.customerid
join geography g on g.geographyid = c.geographyid
where b.isactivemember = 1  and b.tenure > 5
group by g.geographylocation
order by ActiveCustomers desc;


-- 11.	Examine the trend of customers joining over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it.

select year(Bankdoj) as Year, count(*) as CustomersCount from customerinfo
group by year(Bankdoj)
order by Year;

select month(Bankdoj) as Month, count(*) as CustomersCount from customerinfo
group by  month(Bankdoj)
order by  Month;

select quarter(Bankdoj) as Quarter,count(*) as CustomersCount from customerinfo
group by  Quarter(Bankdoj)
order by Quarter;


-- 15.	Using SQL, write a query to find out the gender-wise average income of males and females in each geography id. 
-- Also, rank the gender according to the average value. 

with cte1 as 
(
select g.GenderCategory, go.GeographyLocation, round(avg(estimatedSalary),2) as AvgSalary
from customerinfo c 
join gender g on g.genderid = c.genderid
join geography go on go.geographyid = c.geographyid
group by  g.GenderCategory, go.GeographyLocation
)

select * ,
rank() over(partition by GeographyLocation order by AvgSalary desc) as Rnk
from cte1;


-- 16.	Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).

with cte1 as 
(
select customerid,
case
when age between 18 and 30 then "18-30"
when age between 31 and 50 then "31-50"
else "50+"
end as AgeBracket 
from customerinfo
)

select c.AgeBracket, round(avg(b.Tenure),2) as AvgTenure
from bank_churn b 
join cte1 c on c.customerid = b.customerid
where b.exited = 1
group by c.AgeBracket
order by c.AgeBracket;


-- 22.	As we can see that the “CustomerInfo” table has the CustomerID and Surname, now if we have to join it with a table where 
-- the primary key is also a combination of CustomerID and Surname, come up with a column where the format is “CustomerID_Surname”.

select concat(customerid, "_", surname) as CustomerKey
from customerinfo;


-- 23.	Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL.

select *,
(select exitcategory from exitcustomer e where e.exitid = b.exited ) 
as ExitCategory
from bank_churn b;

-- 25.	Write the query to get the customer IDs, their last name, and whether they are active or not for the customers whose surname ends with “on”.

select c.Customerid, c.Surname,
case 
when b.isActivemember = 1 then "Active"
else "Inactive"
end as ActiveStatus
from customerinfo c
join bank_churn b on b.customerid = c.customerId
where c.surname like "%on";


-- 26.	Can you observe any data disrupency in the Customer’s data? As a hint it’s present in the IsActiveMember and Exited columns. 
-- One more point to consider is that the data in the Exited Column is absolutely correct and accurate.

select
IsActiveMember , Exited , count(*) as CustomerCount
from bank_churn
group by isactivemember , exited;


-- Subjective Question

-- 9.	Utilize SQL queries to segment customers based on demographics and account details.

SELECT
    c.CustomerID,
    g.GenderCategory AS Gender,
    geo.GeographyLocation AS Geography,
    CASE
        WHEN c.Age BETWEEN 18 AND 30 THEN 'Young'
        WHEN c.Age BETWEEN 31 AND 50 THEN 'Middle Aged'
        ELSE 'Senior'
    END AS Age_Group,

    CASE
        WHEN b.CreditScore >= 800 THEN 'Excellent'
        WHEN b.CreditScore >= 740 THEN 'Very Good'
        WHEN b.CreditScore >= 670 THEN 'Good'
        WHEN b.CreditScore >= 580 THEN 'Fair'
        ELSE 'Poor'
    END AS Credit_Segment,

    CASE
        WHEN b.Balance >= 100000 THEN 'High Balance'
        WHEN b.Balance >= 50000 THEN 'Medium Balance'
        ELSE 'Low Balance'
    END AS Balance_Segment,

    CASE
        WHEN b.NumOfProducts = 1 THEN 'Single Product'
        WHEN b.NumOfProducts = 2 THEN 'Two Products'
        ELSE 'Multiple Products'
    END AS Product_Segment,

    CASE
        WHEN b.IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS Membership_Status,
    
    case
		when b.hascrcard = 1 then 'Credit Card Holder'
        else 'Non Credit Card Holder'
    end as Credit_Card_Status,
    CASE
    WHEN b.Tenure <= 3 THEN 'New Customer'
    WHEN b.Tenure <= 5 THEN 'Mid-Tenure Customer'
    ELSE 'Long-Term Customer'
END AS Tenure_Segment

FROM CustomerInfo c
JOIN Bank_Churn b
    ON c.CustomerID = b.CustomerID
JOIN Gender g
    ON c.GenderID = g.GenderID
JOIN Geography geo
    ON c.GeographyID = geo.GeographyID;
    

-- 14.	In the “Bank_Churn” table how can you modify the name of the “HasCrCard” column to “Has_creditcard”?
ALTER TABLE Bank_Churn
RENAME COLUMN HasCrCard TO Has_creditcard;
