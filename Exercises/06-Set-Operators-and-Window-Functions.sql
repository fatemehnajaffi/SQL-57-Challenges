USE SQLPracticeProblems57;
GO

-- Exercise 52
Select Country
From Suppliers

Union

Select Country
From Customers
Order By Country;

-- Exercise 53
With SupplierCountries As
(
    Select Distinct Country
    From Suppliers
),
CustomerCountries As
(
    Select Distinct Country
    From Customers
)
Select
    SupplierCountries.Country As SupplierCountry,
    CustomerCountries.Country As CustomerCountry
From SupplierCountries
Full Outer Join CustomerCountries
    On SupplierCountries.Country = CustomerCountries.Country
Order By
    IsNull(SupplierCountries.Country, CustomerCountries.Country);

-- Exercise 54
With SupplierCountries As
(
    Select
        Country,
        Count(*) As TotalSuppliers
    From Suppliers
    Group By Country
),
CustomerCountries As
(
    Select
        Country,
        Count(*) As TotalCustomers
    From Customers
    Group By Country
)
Select
    IsNull(SupplierCountries.Country, CustomerCountries.Country) As Country,
    IsNull(TotalSuppliers, 0) As TotalSuppliers,
    IsNull(TotalCustomers, 0) As TotalCustomers
From SupplierCountries
Full Outer Join CustomerCountries
    On SupplierCountries.Country = CustomerCountries.Country
Order By Country;

-- Exercise 55
With FirstOrders As
(
    Select
        ShipCountry,
        CustomerId,
        OrderId,
        Convert(Date, OrderDate) As OrderDate,
        Row_Number() Over
        (
            Partition By ShipCountry
            Order By OrderId
        ) As RowNumberPerCountry
    From Orders
)
Select
    ShipCountry,
    CustomerId,
    OrderId,
    OrderDate
From FirstOrders
Where RowNumberPerCountry = 1
Order By OrderId;

-- Exercise 56
Select
    InitialOrder.CustomerId,
    InitialOrder.OrderId As InitialOrderId,
    InitialOrder.OrderDate As InitialOrderDate,
    NextOrder.OrderId As NextOrderId,
    NextOrder.OrderDate As NextOrderDate,
    DateDiff(Day, InitialOrder.OrderDate, NextOrder.OrderDate) As DaysBetween
From Orders InitialOrder
Join Orders NextOrder
    On InitialOrder.CustomerId = NextOrder.CustomerId
    And InitialOrder.OrderId < NextOrder.OrderId
Where DateDiff(Day, InitialOrder.OrderDate, NextOrder.OrderDate) <= 5
Order By
    InitialOrder.CustomerId,
    InitialOrder.OrderId;

-- Exercise 57
With CustomerOrders As
(
    Select
        CustomerId,
        OrderId,
        Convert(Date, OrderDate) As OrderDate,
        Convert(Date,
         Lead(OrderDate, 1) Over
            (
                Partition By CustomerId
                Order By OrderDate, OrderId
            )
        ) As NextOrderDate
    From Orders
)Select
    CustomerId,
    OrderDate,
    NextOrderDate,
    DateDiff(Day, OrderDate, NextOrderDate) As DaysBetween
From CustomerOrders
Where
    NextOrderDate Is Not Null
    And DateDiff(Day, OrderDate, NextOrderDate) <= 5
Order By
    CustomerId,
    OrderDate;
