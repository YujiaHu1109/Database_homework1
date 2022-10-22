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

