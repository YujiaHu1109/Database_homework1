# Database_homework1
## Content : Database first-job northwind &amp; sql
## Author : HuYujia

1.Get all unique ShipNames from the Order table that contain a hyphen '-'.
Details: In addition, get all the characters preceding the (first) hyphen. Return ship names alphabetically.

`My code`
```
SELECT distinct ShipName, substr(ShipName,1,instr(ShipName,'-')-1)
FROM [Order]
WhERE ShipName like '%-%'
Order by ShipName asc;
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q1.png)

2.Indicate if an order's ShipCountry is in North America. For our purposes, this is 'USA', 'Mexico', 'Canada'
Details: You should print the Order Id, ShipCountry, and another column that is 
either 'NorthAmerica' or 'OtherPlace' depending on the Ship Country.Order by the primary key (Id) ascending and return 20 rows starting from Order Id 15445.

`My code`
```
UPDATE [Order]
SET ShipRegion = "OtherPlace"
WHERE ShipRegion <> "North America";
```
```
SELECT Id, ShipCountry, ShipRegion
FROM [Order]
WHERE Id>=15445 and Id<=15464;
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q2.png)

3.For each Shipper, find the percentage of orders which are late.
Details: An order is considered late if ShippedDate > RequiredDate. Print the following format, order by descending precentage, rounded to the nearest hundredths.

`My code`
```
With total_num(cn, tot) as
	(SELECT CompanyName, count(*)
	FROM Shipper,[Order] 
	WHERE Shipper.id = [Order].ShipVia
	GROUP BY CompanyName),
delay_num(cn, del) as 
(SELECT CompanyName, count(*)
FROM Shipper,[Order]
WHERE Shipper.id = [Order].ShipVia and ShippedDate>RequiredDate
GROUP BY CompanyName)
SELECT distinct total_num.cn,round((cast(del*100 as float)/cast(tot as float)),2) as DP
FROM total_num, delay_num 
WHERE total_num.cn = delay_num.cn
ORDER BY DP desc;
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q3.png)

4.Compute some statistics about categories of products
Details: Get the number of products, average unit price (rounded to 2 decimal places), minimum unit price, maximum unit price, and total units on order for categories containing greater than 10 products.Order by Category Id.

`My code`(ignore Discount)
```
With ca_pr(ca, pr_num, to_ui) as
	(SELECT CategoryName, count(*), sum(UnitsOnOrder)
	FROM Product,Category
	WHERE Product.CategoryId = Category.Id 
	GROUP BY CategoryId)
SELECT distinct ca_pr.ca,ca_pr.pr_num, round(avg(OrderDetail.UnitPrice),2), min(OrderDetail.UnitPrice), max(OrderDetail.UnitPrice), ca_pr.to_ui
FROM Product,OrderDetail,Category,ca_pr
WHERE Product.Id=OrderDetail.ProductId 
	and Product.CategoryId=Category.Id
	and Category.CategoryName = ca_pr.ca
	and ca_pr.pr_num>10
GROUP BY Category.Id
ORDER BY Category.Id; 
```

`My code`(consider Discount)
```
With ca_pr(ca, pr_num, to_ui) as
	(SELECT CategoryName, count(*), sum(UnitsOnOrder)
	FROM Product,Category
	WHERE Product.CategoryId = Category.Id 
	GROUP BY CategoryId)
SELECT distinct ca_pr.ca,ca_pr.pr_num, round(avg(OrderDetail.UnitPrice*(1-OrderDetail.discount)),2), min(OrderDetail.UnitPrice*(1-OrderDetail.discount)), max(OrderDetail.UnitPrice*(1-OrderDetail.discount)), ca_pr.to_ui
FROM Product,OrderDetail,Category,ca_pr
WHERE Product.Id=OrderDetail.ProductId 
	and Product.CategoryId=Category.Id
	and Category.CategoryName = ca_pr.ca
	and ca_pr.pr_num>10
GROUP BY Category.Id
ORDER BY Category.Id; 
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q4.png)

5.For each of the 8 discontinued products in the database, which customer made the first ever order for the product? Output the customer's CompanyName and ContactName
Details: Print the following format, order by ProductName alphabetically.

`My code`
```
SELECT distinct p1.ProductName,CompanyName,ContactName
FROM Product p1, OrderDetail d1,[Order] o1,Customer
WHERE p1.id=d1.Productid and d1.Orderid=[o1].id and [o1].Customerid=Customer.id and p1.Discontinued=1
and not exists(SELECT *
	FROM Product p2, OrderDetail d2, [Order] o2 
	WHERE o2.OrderDate<o1.OrderDate and p2.id=d2.Productid and d2.Orderid=[o2].id and p2.Id = p1.Id
)

Order by p1.ProductName;
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q5.png)

6.For the first 10 orders by CutomerId BLONP: get the Order's Id, OrderDate, previous OrderDate, and difference between the previous and current. Return results ordered by OrderDate (ascending)
Details: The "previous" OrderDate for the first order should default to itself (lag time = 0). Use the julianday() function for date arithmetic (example).Use lag(expr, offset, default) for grabbing previous dates. Please round the lag time to the nearest hundredth.

`My code`
```
SELECT [Order].Id, lag(OrderDate) over(order by OrderDate), OrderDate,round(julianday(OrderDate) - julianday(lag(OrderDate) over(order by OrderDate)), 2)
FROM Customer, [Order]
WHERE Customer.Id = [Order].CustomerId and Customer.Id = "BLONP"
Order by OrderDate asc
LIMIT 10;
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q6.png)

7.For each Customer, get the CompanyName, CustomerId, and "total expenditures". Output the bottom quartile of Customers, as measured by total expenditures.
Details: Calculate expenditure using UnitPrice and Quantity (ignore Discount). Compute the quartiles for each company's total expenditures using NTILE. The bottom quartile is the 1st quartile, order them by increasing expenditure.Make sure your output is formatted as follows (round expenditure to nearest hundredths)

`My code`
```
SELECT IFNULL(NULL,"MISSING_NAME")
FROM [Customer];
```

`My code`
```
SELECT cn,ci,s
FROM(
SELECT NTILE(4) over (order by sum(UnitPrice*Quantity) asc) as gn, Customer.CompanyName as cn, CustomerID as ci, round(sum(UnitPrice*Quantity),2) as s
FROM Customer, [Order], OrderDetail
WHERE Customer.Id = [Order].CustomerId and [Order].Id = OrderDetail.OrderId 
GROUP BY CompanyName)
Where gn = 1;
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q7.png)

8.Find the youngest employee serving each Region. If a Region is not served by an employee, ignore it.
Details: Print the Region Description, First Name, Last Name, and Birth Date. Order by Region Id.

`My code`
```
SELECT  distinct RegionDescription, FirstName, LastName, BirthDate
FROM Region r1, Territory, EmployeeTerritory, Employee e1
WHERE e1.Id = EmployeeTerritory.EmployeeId
	and EmployeeTerritory.TerritoryId = Territory.Id
	and Territory.RegionId = r1.Id
	and not exists(SELECT * FROM Region r2, Territory, EmployeeTerritory, Employee e2 WHERE  e2.BirthDate > e1.BirthDate and e2.Id = EmployeeTerritory.EmployeeId
	and EmployeeTerritory.TerritoryId = Territory.Id
	and Territory.RegionId = r2.Id
	and r1.Id = r2.Id)
Order BY r1.Id asc;
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q8.png)


9.Concatenate the ProductNames ordered by the Company 'Queen Cozinha' on 2014-12-25
Details: Order the products by Id (ascending). Print a single string containing all the dup names separated by commas

`My code`
```
With A(info) as(
SELECT distinct product.productName
FROM Customer,[Order],OrderDetail,Product
WHERE Customer.Id = [Order].CustomerId 
and [Order].Id = OrderDetail.OrderId 
and OrderDetail.ProductId = Product.Id 
and [Order].OrderDate like '%2014-12-25%'
and (product.productName) in 
(SELECT product.productName
FROM Customer,[Order],OrderDetail,Product
WHERE Customer.Id = [Order].CustomerId 
and [Order].Id = OrderDetail.OrderId 
and OrderDetail.ProductId = Product.Id 
and [Order].OrderDate like '%2014-12-25%'
GROUP BY product.productName
HAVING count(*)>=2)
Order by Product.Id)
select GROUP_CONCAT(A.Info) from A;
```

`My result`

![](https://github.com/YujiaHu1109/Database_homework1/blob/main/results/q9.png)

