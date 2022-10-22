SELECT distinct ShipName, substr(ShipName,1,instr(ShipName,'-')-1)
FROM [Order]
WhERE ShipName like '%-%'
Order by ShipName asc;
