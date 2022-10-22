SELECT distinct p1.ProductName,CompanyName,ContactName
FROM Product p1, OrderDetail d1,[Order] o1,Customer
WHERE p1.id=d1.Productid and d1.Orderid=[o1].id and [o1].Customerid=Customer.id and p1.Discontinued=1
and not exists(SELECT *
	FROM Product p2, OrderDetail d2, [Order] o2 
	WHERE o2.OrderDate<o1.OrderDate and p2.id=d2.Productid and d2.Orderid=[o2].id and p2.Id = p1.Id
)

Order by p1.ProductName;

