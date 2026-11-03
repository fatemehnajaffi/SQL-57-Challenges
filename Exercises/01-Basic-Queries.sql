USE SQLPracticeProblems57;
GO

-- Exercise 01
select *
	from Shippers;

-- Exercise 02
select CategoryName , Description
	from Categories;

-- Exercise 03
select FirstName, LastName , HireDate
	from Employees
	Where
	title = 'Sales Representative';

-- Exercise 04
select FirstName, LastName , HireDate
	from Employees
	Where
	title = 'Sales Representative'
	and
	Country = 'usa';

-- Exercise 05
select *
	from Orders
	where EmployeeID = 5;

-- Exercise 06
select SupplierID , ContactName , ContactTitle
	from Suppliers
	where ContactTitle <> 'Marketing Manager';

-- Exercise 07
select ProductID , ProductName
	from products
	where ProductName like '%queso%';

-- Exercise 08
select OrderID , CustomerID , ShipCountry
	from Orders
	where 
	ShipCountry = 'France'
	or
	ShipCountry = 'Belgium';

-- Exercise 09
select OrderID , CustomerID , ShipCountry
	from Orders
	where 
	ShipCountry in ('Brazil','Mexico','Argentina' , 'Venezuela');

-- Exercise 10
select FirstName, LastName , Title , BirthDate
	from Employees
	order by BirthDate desc;

-- Exercise 11
select 
	FirstName, LastName , Title ,  CONVERT(date, BirthDate) as BD
	from Employees;

-- Exercise 12
select 
	FirstName, LastName ,  concat(firstname , ' ' , lastname) as fullname
	from Employees;

-- Exercise 13
select 
	OrderID , ProductID , UnitPrice , UnitPrice * Quantity as TotalPrice
	from [Order Details];
