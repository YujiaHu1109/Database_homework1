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
