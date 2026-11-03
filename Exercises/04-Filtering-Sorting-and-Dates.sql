USE SQLPracticeProblems57;
GO

-- Exercise 22
select 
	UnitsInStock , ReorderLevel
	from Products
	where UnitsInStock < ReorderLevel
	order by ProductID;

-- Exercise 23
select
	ProductID , ProductName , UnitsInStock , UnitsOnOrder , ReorderLevel , Discontinued , UnitsInStock + UnitsOnOrder as reordering
	from products 
	where 
	UnitsInStock + UnitsOnOrder <= ReorderLevel
	and
	Discontinued = 0;

-- Exercise 24
select
	customerid , companyname , region
	from customers
	order by 
			case 
				when Region is null then 1
				else 0
			end,
			region,
			CustomerID;

-- Exercise 27
Select
    OrderId
From Orders
Where
    OrderDate >= '20151231'
    And OrderDate < '20160101'
    And Freight = 2000;

-- Exercise 35
select
	employeeID,
	orderID,
	OrderDate
	from Orders
	where 
	    Orders.OrderDate =
    DATEADD
		(
        DAY,-1,DATEADD(MONTH,DATEDIFF(MONTH, 0, Orders.OrderDate) + 1,0)
		)
	order by 
			EmployeeID,
			OrderID;

-- Exercise 41
Select
    OrderID,
    OrderDate,
    RequiredDate,
    ShippedDate
From Orders
Where ShippedDate > RequiredDate
Order By OrderID;

-- Exercise 42
Select
    Employees.EmployeeID,
    Employees.LastName,
    Count(*) As TotalLateOrders
From Orders
Join Employees
    On Orders.EmployeeID = Employees.EmployeeID
Where Orders.ShippedDate > Orders.RequiredDate
Group By
    Employees.EmployeeID,
    Employees.LastName
Order By TotalLateOrders Desc;
