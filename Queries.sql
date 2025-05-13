-- 1. Market Segmentation Analysis
Select Location, count(Customer_id) as number_of_customers
from Customers 
group by Location
order by number_of_customers desc
limit 3;

/*
The top 3 cities with the highest number of customers are Delhi, Chennai, and Jaipur. These cities determine key markets 
for targeted marketing and logistic optimization and must be focused as a part of marketing strategies.
*/

-- 2. Engagament Depth Analysis
SELECT
  NumberOfOrders,
  COUNT(*) AS CustomerCount
FROM (
  SELECT
    Customer_id,
    COUNT(Order_id) AS NumberOfOrders
  FROM Orders
  GROUP BY Customer_id
) AS OrderCounts
GROUP BY NumberOfOrders
ORDER BY NumberOfOrders ASC;

/*
TREND: As the number of orders increases, the Customer count decreases. 
As per the distribution of customers according to the number of orders placed, the company experiences occassional shoppers the most.
*/

-- 3. Purchase High-Value Products
Select Product_id, avg(quantity) as AvgQuantity, sum(quantity*price_per_unit) as TotalRevenue
from OrderDetails 
group by Product_id 
having AvgQuantity=2
order by TotalRevenue desc ;

-- Among products with an average purchase quantity of two, Product 1 exhibits the highest total revenue which categorises it into a premium product.

-- 4. Category-wise Customer Reach
Select p.Category, count(distinct o.customer_id) as unique_customers 
from Products p 
join OrderDetails od on p.Product_id = od.Product_id
join Orders o on o.Order_id = od.Order_id
group by p.Category
order by unique_customers desc;

-- Electronics category has the widest appeal across the customer base and needs more focus because of its high demand. 

-- 5. Sales Trend Analysis
Select Date_format(Order_date, '%Y-%m') as Month, sum(total_amount) as TotalSales,
             round(100*((sum(total_amount)-lag(sum(total_amount)) over(order by Date_format(Order_date, '%Y-%m')))/
             lag(sum(total_amount)) over(order by Date_format(Order_date, '%Y-%m'))),2) as PercentChange
from Orders
group by Month;

/* 
As per Sales Trend Analysis, in Feb 2024, the sales experience the largest decline.
Inference on sales trend from March to August: Sales fluctuated with no clear trend.
*/

-- 6. Average Order Value Fluctuation
Select Date_format(Order_date, '%Y-%m') as Month, avg(total_amount) as AvgOrderValue,
       round( avg(total_amount) - lag(avg(total_amount)) over(order by Date_format(Order_date,'%Y-%m')),2) as ChangeInValue
from Orders 
group by Month
order by ChangeInValue desc;

-- December has the highest change in the average order value.

-- 7. Inventory Refresh Rate
Select Product_id, count(order_id) as SalesFrequency
from OrderDetails
group by Product_id
order by SalesFrequency desc
limit 5;

-- The product_id that has the highest turnover rates and needs to be restocked frequently is product_id 7.

-- 8. Low Engagement Products
Select p.product_id, p.name,
    COUNT(DISTINCT o.customer_id) AS UniqueCustomerCount
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
JOIN Orders o ON od.order_id = o.order_id
GROUP BY p.product_id, p.name
HAVING COUNT(DISTINCT o.customer_id) < (
    SELECT 0.4 * COUNT(DISTINCT customer_id)
    FROM Customers
)
ORDER BY UniqueCustomerCount ASC;

/*
A reason for certain products having purchase rates below 40% of the total customer base is their poor visibility on the platform.
A strategic action to improve the sales of these underperforming products can be to implement targeted marketing campaigns to raise awareness and interest. 
*/

-- 9. Customer Acquisition Trends
SELECT 
    DATE_FORMAT(first_order_date, '%Y-%m') AS FirstPurchaseMonth,
    COUNT(*) AS TotalNewCustomers
FROM
    (SELECT 
        customer_id, MIN(order_date) AS first_order_date
    FROM
        Orders
    GROUP BY customer_id) c
GROUP BY FirstPurchaseMonth
ORDER BY FirstPurchaseMonth;

/*
Inference about the growth trend in the customer base from the result table after evaluating the month-on-month analysis 
is that it is a downward trend which implies that marketing campaigns are not much effective. 
*/

-- 10. Peak Sales Period Identification
Select date_format(order_date, '%Y-%m') as Month, sum(total_amount) as TotalSales
from Orders 
group by Month
order by TotalSales desc 
limit 3;

-- September and December will require major restocking of product and increased staffs since these months have the highest sales volume. 
