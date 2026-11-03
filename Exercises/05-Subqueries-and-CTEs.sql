USE SQLPracticeProblems57;
GO

-- Exercise 37
select 
	top (2) percent
    Orders.OrderID,
    RandomValue = RAND(CHECKSUM(NEWID()))
	from orders
	ORDER BY RandomValue;

-- Exercise 38
select 
	OrderID,
	quantity
	from OrderDetails
	where Quantity >= 60
	group by OrderID , Quantity
	having Count(*) > 1
	order by OrderID;

-- Exercise 39
With DuplicateOrders As
(
    Select Distinct
        OrderId
    From OrderDetails
    Where Quantity >= 60
    Group By
        OrderId,
        Quantity
    Having Count(*) > 1
)

Select
    OrderDetails.OrderId,
    OrderDetails.ProductId,
    OrderDetails.Quantity
From OrderDetails
Join DuplicateOrders
    On OrderDetails.OrderId = DuplicateOrders.OrderId
Order By OrderDetails.OrderId;

-- Exercise 40
Select
    OrderDetails.OrderID,
    ProductID,
    UnitPrice,
    Quantity,
    Discount
From OrderDetails
Join
(
    Select Distinct
        OrderID
    From OrderDetails
    Where Quantity >= 60
    Group By
        OrderID,
        Quantity
    Having Count(*) > 1
) PotentialProblemOrders
    On PotentialProblemOrders.OrderID = OrderDetails.OrderID
Order By
    OrderID,
    ProductID;

-- Exercise 43
With LateOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalLateOrders
    From Orders
    Where RequiredDate <= ShippedDate
    Group By EmployeeId
),
TotalOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalOrders
    From Orders
    Group By EmployeeId
)
Select
    Employees.EmployeeId,
    Employees.LastName,
    LateOrders.TotalLateOrders,
    TotalOrders.TotalOrders,
    Cast(LateOrders.TotalLateOrders * 100.0 / TotalOrders.TotalOrders As Decimal(5,2)) As LateOrderPercentage
From Employees
Join LateOrders
    On Employees.EmployeeId = LateOrders.EmployeeId
Join TotalOrders
    On Employees.EmployeeId = TotalOrders.EmployeeId
Order By LateOrderPercentage Desc;

-- Exercise 44
With LateOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalLateOrders
    From Orders
    Where RequiredDate <= ShippedDate
    Group By EmployeeId
),
AllOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalOrders
    From Orders
    Group By EmployeeId
)
Select
    Employees.EmployeeId,
    Employees.LastName,
    LateOrders.TotalLateOrders,
    AllOrders.TotalOrders
From Employees
Join AllOrders
    On Employees.EmployeeId = AllOrders.EmployeeId
Left Join LateOrders
    On Employees.EmployeeId = LateOrders.EmployeeId
Order By Employees.EmployeeId;

-- Exercise 45
With LateOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalLateOrders
    From Orders
    Where RequiredDate <= ShippedDate
    Group By EmployeeId
),
AllOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalOrders
    From Orders
    Group By EmployeeId
)
Select
    Employees.EmployeeId,
    Employees.LastName,
    IsNull(LateOrders.TotalLateOrders, 0) As TotalLateOrders,
    AllOrders.TotalOrders
From Employees
Join AllOrders
    On Employees.EmployeeId = AllOrders.EmployeeId
Left Join LateOrders
    On Employees.EmployeeId = LateOrders.EmployeeId
Order By Employees.EmployeeId;

-- Exercise 46
With LateOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalLateOrders
    From Orders
    Where RequiredDate <= ShippedDate
    Group By EmployeeId
),
AllOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalOrders
    From Orders
    Group By EmployeeId
)
Select
    Employees.EmployeeId,
    Employees.LastName,
    IsNull(LateOrders.TotalLateOrders, 0) As TotalLateOrders,
    AllOrders.TotalOrders,
    Cast(IsNull(LateOrders.TotalLateOrders, 0) * 100.0 / AllOrders.TotalOrders As Decimal(5,2)) As LateOrderPercentage
From Employees
Join AllOrders
    On Employees.EmployeeId = AllOrders.EmployeeId
Left Join LateOrders
    On Employees.EmployeeId = LateOrders.EmployeeId
Order By LateOrderPercentage Desc;

-- Exercise 47
With LateOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalLateOrders
    From Orders
    Where RequiredDate <= ShippedDate
    Group By EmployeeId
),
AllOrders As
(
    Select
        EmployeeId,
        Count(*) As TotalOrders
    From Orders
    Group By EmployeeId
)
Select
    Employees.EmployeeId,
    Employees.LastName,
    IsNull(LateOrders.TotalLateOrders, 0) As TotalLateOrders,
    AllOrders.TotalOrders,
    Convert(Decimal(10,2),
        IsNull(LateOrders.TotalLateOrders, 0) * 100.0 / AllOrders.TotalOrders
    ) As PercentageLateOrders
From Employees
Join AllOrders
    On Employees.EmployeeId = AllOrders.EmployeeId
Left Join LateOrders
    On Employees.EmployeeId = LateOrders.EmployeeId
Order By PercentageLateOrders Desc;

-- Exercise 48
With CustomerOrders As
(
    Select
        Customers.CustomerId,
        Customers.CompanyName,
        Sum(OrderDetails.Quantity * OrderDetails.UnitPrice) As TotalOrderAmount
    From Customers
    Join Orders
        On Orders.CustomerId = Customers.CustomerId
    Join OrderDetails
        On Orders.OrderId = OrderDetails.OrderId
    Where
        OrderDate >= '20160101'
        And OrderDate < '20170101'
    Group By
        Customers.CustomerId,
        Customers.CompanyName
)
Select
    CustomerId,
    CompanyName,
    TotalOrderAmount,
    Case
        When TotalOrderAmount >= 0 And TotalOrderAmount < 1000 Then 'Low'
        When TotalOrderAmount >= 1000 And TotalOrderAmount < 5000 Then 'Medium'
        When TotalOrderAmount >= 5000 And TotalOrderAmount < 10000 Then 'High'
        When TotalOrderAmount >= 10000 Then 'Very High'
    End As CustomerGroup
From CustomerOrders
Order By CustomerId;

-- Exercise 49
With CustomerOrders As
(
    Select
        Customers.CustomerId,
        Customers.CompanyName,
        Sum(OrderDetails.Quantity * OrderDetails.UnitPrice) As TotalOrderAmount
    From Customers
    Join Orders
        On Orders.CustomerId = Customers.CustomerId
    Join OrderDetails
        On Orders.OrderId = OrderDetails.OrderId
    Where
        OrderDate >= '20160101'
        And OrderDate < '20170101'
    Group By
        Customers.CustomerId,
        Customers.CompanyName
)
Select
    CustomerId,
    CompanyName,
    TotalOrderAmount,
    Case
        When TotalOrderAmount >= 0 And TotalOrderAmount < 1000 Then 'Low'
        When TotalOrderAmount >= 1000 And TotalOrderAmount < 5000 Then 'Medium'
        When TotalOrderAmount >= 5000 And TotalOrderAmount < 10000 Then 'High'
        When TotalOrderAmount >= 10000 Then 'Very High'
        Else 'No Group'
    End As CustomerGroup
From CustomerOrders
Order By CustomerId;

-- Exercise 50
With CustomerOrders As
(
    Select
        Customers.CustomerId,
        Customers.CompanyName,
        Sum(OrderDetails.Quantity * OrderDetails.UnitPrice) As TotalOrderAmount
    From Customers
    Join Orders
        On Orders.CustomerId = Customers.CustomerId
    Join OrderDetails
        On Orders.OrderId = OrderDetails.OrderId
    Where
        OrderDate >= '20160101'
        And OrderDate < '20170101'
    Group By
        Customers.CustomerId,
        Customers.CompanyName
),
CustomerGroups As
(
    Select
        Case
            When TotalOrderAmount >= 0 And TotalOrderAmount < 1000 Then 'Low'
            When TotalOrderAmount >= 1000 And TotalOrderAmount < 5000 Then 'Medium'
            When TotalOrderAmount >= 5000 And TotalOrderAmount < 10000 Then 'High'
            When TotalOrderAmount >= 10000 Then 'Very High'
            Else 'No Group'
        End As CustomerGroup
    From CustomerOrders
),
GroupCounts As
(
    Select
        CustomerGroup,
        Count(*) As TotalCustomers
    From CustomerGroups
    Group By CustomerGroup
)
Select
    CustomerGroup,
    TotalCustomers,
    Convert(Decimal(10,2), TotalCustomers * 100.0 / Sum(TotalCustomers) Over()) As Percentage
From GroupCounts
Order By TotalCustomers Desc;

-- Exercise 51
with Orders2016 as (
Select
Customers.CustomerID
,Customers.CompanyName
,TotalOrderAmount = SUM(Quantity * UnitPrice)
From Customers
Join Orders
on Orders.CustomerID = Customers.CustomerID
Join OrderDetails
on Orders.OrderID = OrderDetails.OrderID
Where
OrderDate >= '20160101'
and OrderDate < '20170101'
Group by
Customers.CustomerID
,Customers.CompanyName
)
Select
CustomerID
,CompanyName
,TotalOrderAmount
,CustomerGroupName
from Orders2016
Join CustomerGroupThresholds
on Orders2016.TotalOrderAmount between
CustomerGroupThresholds.RangeBottom and CustomerGroupThresholds.RangeTop
Order by CustomerID;
