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
	SUM(sod.LineTotal/sod.OrderQty) AS total_selled,
	p.StandardCost AS Cost,
	SUM((sod.LineTotal/sod.OrderQty) - p.StandardCost)
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name, p.StandardCost;

SELECT * FROM Production.Product p
--3. Un query que permita calcular el tiempo promedio de envío por categoría de productos en el último trimestre:
--4. Un query que permita calcular el tiempo promedio de envío por categoría de productos en el último trimestre, incluyendo información sobre clientes, empleados y proveedores.
--5. Un query que permita analizar el desempeño de los productos en función de las revisiones de los clientes, mostrando información sobre empleados y clientes asociados a las revisiones
--6. Un query que permita identificar los productos más devueltos en el último mes, incluyendo información sobre los clientes y empleados asociados a las devoluciones
--7. Un query que permita analizar la distribución de ventas por canal de marketing en el último semestre
--8. Un query que permita identificar los clientes con mayor valor de compras en el último trimestre, mostrando información sobre empleados y productos asociados a las ventas
--9. Un query que permita analizar las tendencias de ventas por región en el último año, mostrando información sobre empleados, clientes y productos asociados a las ventas