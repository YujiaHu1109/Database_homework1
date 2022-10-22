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

