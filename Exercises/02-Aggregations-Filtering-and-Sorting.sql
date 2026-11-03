USE SQLPracticeProblems57;
GO

-- Exercise 14
select count(*)
	from Customers;

-- Exercise 15
select min(OrderDate)
	from [Orders];

-- Exercise 16
select country
	from customers
	group by Country;

-- Exercise 17
select ContactTitle , count(*) as TotalContactTitle
	from Customers
	group by ContactTitle;

-- Exercise 20
select 
	CategoryName , count(*) as totalNumberOfProducts
	from Categories
	join Products
	on categories.CategoryID = Products.CategoryID
	group by Categoryname;

-- Exercise 21
select
	Country , City , count(*) as  totalnumberofcustomers
	from Customers
	group by 
	city , country;

-- Exercise 25
select top 3
	ShipCountry , avg(freight) as AVGFreight
	from Orders
	group by ShipCountry
	order by AVGFreight desc;

-- Exercise 26
select top 3
	ShipCountry , avg(freight) as AVGFreight
	from Orders
	where  year(OrderDate)	=	1997
	group by ShipCountry
	order by AVGFreight desc;

-- Exercise 28
Select Top 3
	ShipCountry,AverageFreight = avg(freight)
	From Orders
	where OrderDate >=	 Dateadd(year, -1, (Select max(OrderDate) from Orders))
	Group By ShipCountry
	order by AverageFreight desc;

-- Exercise 36
select top 10
	orderID,
	COUNT(productID) as TotalOrderDetails
	from OrderDetails
	group by OrderID 
	order by TotalOrderDetails desc;
