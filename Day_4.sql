use sql7challenge;

-- Count the total number of customers registered in the database.
Select count(customer_id) as total_customer
from customers;



-- Count the number of customers in each city and identify the city with the highest customer count.
select city, count(*) as total_customer
from customers
group by city
order by total_customer desc;


-- Identify the top 10 customers who placed the highest number of non-cancelled orders.
select customers.full_name, count(*) as total_orders
from customers
join orders on customers.customer_id=orders.customer_id
where orders.status <> "Cancelled"
group by customers.customer_id, customers.full_name
order by total_orders desc
limit 10;


-- Calculate the total spending of each customer based on order item values, excluding cancelled orders.
SELECT customers.customer_id, customers.full_name, ROUND(SUM(order_items.quantity * order_items.unit_price), 2) AS total_spending
FROM customers 
JOIN orders  ON orders.customer_id = customers.customer_id
JOIN order_items  ON order_items.order_id = orders.order_id
WHERE orders.status <> 'Cancelled'
GROUP BY customers.customer_id, customers.full_name
ORDER BY total_spending DESC;


-- Calculate the average spending per customer among customers who have placed at least one non-cancelled order.
SELECT ROUND(AVG(customer_total),2) AS avg_spending_per_customer
FROM (
    SELECT oRDERS.customer_id,
           SUM(order_items.quantity * order_items.unit_price) AS customer_total
    FROM orders 
    JOIN order_items  ON order_items.order_id = orders.order_id
    WHERE orders.status <> 'Cancelled'
    GROUP BY orders.customer_id
) t;


-- Find customers who have placed more than five non-cancelled orders.
select customers.customer_id, customers.full_name, count(*) as total_orders
from customers
join orders on customers.customer_id=orders.customer_id
where orders.status <> "Cancelled"
group by customers.customer_id, customers.full_name
having count(*) > 5
order by total_orders desc;



-- Count the number of customers in each customer segment.
select segment, count(*) as total_customer
from customers
group by segment
order by total_customer asc;


-- Calculate the average number of non-cancelled orders per customer, including customers with zero qualifying orders.
SELECT ROUND(COUNT(orders.order_id) / COUNT(DISTINCT customers.customer_id), 2) AS avg_orders_per_customer
FROM customers 
JOIN orders ON orders.customer_id = customers.customer_id AND orders.status <> 'Cancelled';


-- Identify the top 10 customers who generated the highest item sales value from non-cancelled orders.
SELECT customers.customer_id, customers.full_name, ROUND(SUM(order_items.quantity * order_items.unit_price), 2) AS total_spending
FROM customers 
JOIN orders ON orders.customer_id = customers.customer_id
JOIN order_items ON order_items.order_id = orders.order_id
WHERE orders.status <> 'Cancelled'
GROUP BY customers.customer_id, customers.full_name
ORDER BY total_spending DESC
LIMIT 10;


-- Count the number of new customer registrations per month and display the results chronologically.
select date_format(signup_date, '%y-%m') as ym, count(*) as signup_customers
from customers
group by ym
order by ym desc;


-- Insights
-- Spending is spread out the top 10 customers make up only about 3.4% of revenue (1.98M of 57.6M).
-- About 68 customers (7%) have never placed a valid order. Orders per customer average 2.97.
-- Top spenders buy often and spend more per order. They place 7 to 9 orders at 23K-33K each, against about 3 orders at about 19.4K for the average customer. Only about 59 customers have more than 5 orders.
-- Most customers are Regular. The split is Regular 56.4%, New 25.6% and Premium 18%.
-- Cities are evenly spread. Lucknow leads with 65 customers (6.5%), but the Delhi NCR cities together total 214 (21.4%).
-- Signups are flat at about 30 a month, with a slight dip in 2025. The peaks were 42 in January 2023 and November 2024.