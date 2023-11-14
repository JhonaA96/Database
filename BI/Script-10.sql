USE AdventureWorks2022;
--1. Un query que permita obtener la cantidad total de productos vendidos por cada categoría por año

SELECT 
	pc.Name AS Category_Name,
	p.Name AS Product,
	YEAR (sod.ModifiedDate) AS 'Year',
	COUNT(*) AS Quantity
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY YEAR(sod.ModifiedDate), p.Name, pc.Name
ORDER BY pc.Name ASC, p.Name ASC, YEAR (sod.ModifiedDate) ASC;

--2. Un query que permita calcular el margen de beneficio de cada producto en el último año:

SELECT 
	p.Name AS Product,
	--p.StandardCost as Cost,
	--SUM(sod.OrderQty) AS Quantity_Selled,
	--FORMAT(SUM(sod.OrderQty) * p.StandardCost, 'C', 'En-us') AS Total_Cost,
	--FORMAT(SUM(sod.LineTotal) / SUM(sod.OrderQty), 'C', 'En-us') AS unit_price,
	--FORMAT(SUM(sod.LineTotal), 'C', 'En-us') as total_selled,
 	(SUM(sod.LineTotal) - (SUM(sod.OrderQty) * p.StandardCost)) / SUM(sod.LineTotal) as Profit_Margin
FROM Sales.SalesOrderDetail sod
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product p ON sod.ProductID  = p.ProductID
WHERE YEAR(soh.OrderDate) = 2014
group by p.Name, p.StandardCost;

--3. Un query que permita calcular el tiempo promedio de envío por categoría de productos en el último trimestre:

SELECT 
	pc.Name as Category_Name,
	AVG(DATEDIFF(day, soh.OrderDate, soh.ShipDate)) AS Averager_Days
FROM Sales.SalesOrderDetail sod
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE YEAR(soh.OrderDate) = 2014
AND DATEPART(qq, soh.OrderDate) = 2
GROUP BY pc.Name, soh.OrderDate;

--4. Un query que permita calcular el tiempo promedio de envío por categoría de productos en el último trimestre, 
-- incluyendo información sobre clientes, empleados y proveedores.

SELECT 
	pc.Name as Category_Name,
	CONCAT(p2.FirstName, ' ', p2.LastName) AS Customer_Name,
	CONCAT(p3.FirstName, ' ', p3.LastName) AS Sales_Person_Name,
	AVG(DATEDIFF(day, soh.OrderDate, soh.ShipDate)) AS Averager_Days
FROM Sales.SalesOrderDetail sod
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
INNER JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
INNER JOIN Person.Person p2 ON c.PersonID = p2.BusinessEntityID
INNER JOIN Person.Person p3 ON sp.BusinessEntityID = p3.BusinessEntityID
WHERE YEAR(soh.OrderDate) = 2014
AND DATEPART(qq, soh.OrderDate) = 2
GROUP BY pc.Name, p2.FirstName, p2.LastName, p3.FirstName, p3.LastName, soh.OrderDate;


--5. Un query que permita analizar el desempeño de los productos en función de las revisiones de los clientes, 
--mostrando información sobre empleados y clientes asociados a las revisiones

SELECT * FROM Production.ProductReview pr;

--6. Un query que permita identificar los productos más devueltos en el último mes, 
--incluyendo información sobre los clientes y empleados asociados a las devoluciones



--7. Un query que permita analizar la distribución de ventas por canal de marketing en el último semestre

SELECT
	sr.ReasonType,
	sr.Name AS Channel,
	p.Name AS Product,
	FORMAT(SUM(soh.TotalDue), 'C', 'En-us')
FROM Sales.SalesOrderHeaderSalesReason sohsr
INNER JOIN Sales.SalesReason sr ON sohsr.SalesReasonID = sr.SalesReasonID
INNER JOIN Sales.SalesOrderHeader soh ON sohsr.SalesOrderID = soh.SalesOrderID
INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE sr.ReasonType = 'Marketing'
GROUP BY sr.ReasonType, sr.Name, p.Name ;

--8. Un query que permita identificar los clientes con mayor valor de compras en el último 
--trimestre, mostrando información sobre empleados y productos asociados a las ventas

SELECT 
	CONCAT(p.FirstName, ' ', p.LastName) AS Customer_Name,
	CONCAT(p2.FirstName, ' ', p2.LastName) AS Sales_Person_Name,
	p3.Name AS Product,
	FORMAT(SUM(sod.LineTotal), 'C', 'En-us') AS Total_Selled 
FROM Sales.SalesOrderDetail sod
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
INNER JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
INNER JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
INNER JOIN Person.Person p2 ON sp.BusinessEntityID = p2.BusinessEntityID
INNER JOIN Production.Product p3 ON sod.ProductID = p3.ProductID
WHERE YEAR(soh.OrderDate) = 2014
AND DATEPART(qq, soh.OrderDate) = 2
GROUP BY p.FirstName, p.LastName, p2.FirstName, p2.LastName, p3.Name
ORDER BY SUM(sod.LineTotal) DESC;

--9. Un query que permita analizar las tendencias de ventas por región en el último año, 
--mostrando información sobre empleados, clientes y productos asociados a las ventas

SELECT 
	st.Name AS Territory,
	CONCAT(p2.FirstName, ' ', p2.LastName) AS Sales_Person_Name,
	CONCAT(p.FirstName, ' ', p.LastName) AS Customer_Name,
	p3.Name AS Product,
	FORMAT(SUM(sod.LineTotal), 'C', 'En-us') AS Total_Selled 
FROM Sales.SalesOrderDetail sod
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
INNER JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
INNER JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
INNER JOIN Person.Person p2 ON sp.BusinessEntityID = p2.BusinessEntityID
INNER JOIN Production.Product p3 ON sod.ProductID = p3.ProductID
INNER JOIN Sales.SalesTerritoryHistory sth ON sp.BusinessEntityID = sth.BusinessEntityID
INNER JOIN Sales.SalesTerritory st ON sth.TerritoryID = st.TerritoryID
WHERE YEAR(soh.OrderDate) = 2014
GROUP BY st.Name, p.FirstName, p.LastName, p2.FirstName, p2.LastName, p3.Name;


------------------------------- PROCEDIMIENTOS ALMACENADOS -------------------------------
CREATE OR ALTER FUNCTION dbo.GenerarCorreo(
	@nombre NVARCHAR(50),
	@apellido NVARCHAR(50),
	@codigo INT
)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @correo NVARCHAR(100);
	SET @correo = LOWER(LEFT(@nombre, 1) + @apellido + RIGHT (CONVERT(NVARCHAR, @codigo), 2) + '@adventureworks.com');
	RETURN @correo;
END;

DECLARE @nombre NVARCHAR(50) = 'Jhonatan';
DECLARE @apellido NVARCHAR(50) = 'acuna';
DECLARE @codigo INT = 67000261;
DECLARE @correo NVARCHAR(100);

SET @correo = dbo.GenerarCorreo(@nombre, @apellido, @codigo);

PRINT 'CORREO GENERADO ' + @correo;



