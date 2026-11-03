USE SQLPracticeProblems57;
GO

-- Exercise 18
select ProductID , ProductName , CompanyName
	from Products
	join Suppliers
		on [Products].SupplierID = Suppliers.SupplierID
		order by ProductID;

-- Exercise 19
select
	OrderID , convert(date, OrderDate) as OrderDate , CompanyName
	from Orders
	join shippers
		on Orders.ShipVia = Shippers.ShipperID
		where OrderID < 10300
	order by OrderID;

-- Exercise 29
select
	employees.EmployeeID,
	employees.lastname,
	orders.OrderID,
	products.ProductName,
	[OrderDetails].Quantity
	from Employees
	inner join orders
		on employees.EmployeeID = orders.EmployeeID
	inner join [OrderDetails]
		on orders.OrderId = [OrderDetails].orderID
	inner join products
		on products.productID = [OrderDetails].productID
	order by orderID , products.ProductID;

-- Exercise 30
select
	customers.customerID,
	Orders.CustomerID
	from customers
	left join orders
	on customers.CustomerID = Orders.CustomerID
	where OrderID is null;

-- Exercise 31
select
	customers.customerID,
	Orders.CustomerID
	from customers
	left join orders
	on customers.CustomerID = Orders.CustomerID
	where Orders.CustomerID is null
	and  orders.EmployeeID = 4;

-- Exercise 32
select
	customers.CustomerID,
	customers.CompanyName,
	orders.OrderID,
	sum(Quantity * UnitPrice) as TotalOrderAmount
	from Customers
	join orders
		on customers.CustomerID = Orders.CustomerID
	join [OrderDetails]
		on [OrderDetails].OrderID = Orders.OrderID
	where 
		 Orders.OrderDate >= '20160101'
		 and
		 Orders.OrderDate < '20170101'
	group by 
			Customers.CustomerID,
			Customers.CompanyName,
			Orders.OrderID
	having 
		sum(Quantity * UnitPrice) >= 10000
	order by 
		TotalOrderAmount desc;

-- Exercise 33
select
	customers.CustomerID,
	customers.CompanyName,
	sum([dbo].[OrderDetails].Quantity * [dbo].[OrderDetails].UnitPrice) as TotalOrderAmount
    from Customers
	 join orders
		on customers.CustomerID = Orders.CustomerID
	 join [dbo].[OrderDetails]
		on [dbo].[OrderDetails].OrderID = Orders.OrderID
	where 
		 Orders.OrderDate >= '20160101'
		 and
		 Orders.OrderDate < '20170101'
	group by 
			Customers.CustomerID,
			Customers.CompanyName
	having 
		sum([dbo].[OrderDetails].Quantity * [dbo].[OrderDetails].UnitPrice) >= 15000
	order by 
		TotalOrderAmount desc;

-- Exercise 34
SELECT
    Customers.CustomerID,
    Customers.CompanyName,
    SUM(
        [OrderDetails].Quantity
        * [OrderDetails].UnitPrice
        * (1 - [OrderDetails].Discount)
		) AS TotalOrderAmount

FROM Customers

JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID

JOIN [OrderDetails]
    ON Orders.OrderID = [OrderDetails].OrderID

WHERE
    Orders.OrderDate >= '20160101'
    AND Orders.OrderDate < '20170101'

GROUP BY
    Customers.CustomerID,
    Customers.CompanyName

HAVING
    SUM(
        [OrderDetails].Quantity
        * [OrderDetails].UnitPrice
        * (1 - [OrderDetails].Discount)
    ) >= 15000

ORDER BY
    TotalOrderAmount DESC;
