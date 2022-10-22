SELECT cn,ci,s
FROM(
SELECT NTILE(4) over (order by sum(UnitPrice*Quantity) asc) as gn, Customer.CompanyName as cn, CustomerID as ci, round(sum(UnitPrice*Quantity),2) as s
FROM Customer, [Order], OrderDetail
WHERE Customer.Id = [Order].CustomerId and [Order].Id = OrderDetail.OrderId 
GROUP BY CompanyName)
Where gn = 1;
