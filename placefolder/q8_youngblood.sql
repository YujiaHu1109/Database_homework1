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

