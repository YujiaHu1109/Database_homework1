SELECT [Order].Id, lag(OrderDate) over(order by OrderDate), OrderDate,round(julianday(OrderDate) - julianday(lag(OrderDate) over(order by OrderDate)), 2)
FROM Customer, [Order]
WHERE Customer.Id = [Order].CustomerId and Customer.Id = "BLONP"
Order by OrderDate asc
LIMIT 10;


