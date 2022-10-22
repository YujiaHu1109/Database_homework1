# Database_homework1
Database first-job northwind &amp; sql
---------------------------------------
1.Get all unique ShipNames from the Order table that contain a hyphen '-'.
Details: In addition, get all the characters preceding the (first) hyphen. Return ship 
names alphabetically.

`My code`
```
SELECT distinct ShipName, substr(ShipName,1,instr(ShipName,'-')-1)
FROM [Order]
WhERE ShipName like '%-%'
Order by ShipName asc;
```
![]
(https://github.com/YujiaHu1109/Database_homework1/raw/result/q1.png)

