-- Show Sale 2016
select * from AW_Sales_2016
order by OrderDate, StockDate ASC

--Create Temporary Table
SELECT * INTO #AW_Sales_Temp
FROM (
    SELECT * FROM AW_Sales_2016
    UNION
    SELECT * FROM AW_Sales_2017
    UNION
    SELECT * FROM AW_Sales_2015
) AS CombinedSales;

-- Show Sale 2015+ 2016 + 2017
Select * from #AW_Sales_Temp
order by 1, 2 ASC

-- Show number of order by productkey
Select T1.ProductKey, T2.ProductName, sum(OrderQuantity) as Number_of_Order 
from #AW_Sales_Temp as T1
left join AW_Products as T2
on T1.ProductKey = T2.ProductKey
group by T1.ProductKey, T2.ProductName
order by Number_of_Order Asc

-- Calculate return rate by productkey
WITH CTE AS (
    SELECT 
        T1.ProductKey,
        T1.Number_of_Order,
        T2.Number_of_return
    FROM (
        SELECT ProductKey, SUM(OrderQuantity) AS Number_of_Order
        FROM #AW_Sales_Temp
        GROUP BY ProductKey
    ) T1
    LEFT JOIN (
        SELECT ProductKey, SUM(ReturnQuantity) AS Number_of_return
        FROM AW_Returns
        GROUP BY ProductKey
    ) T2 ON T1.ProductKey = T2.ProductKey
)
SELECT 
T1.ProductKey, T1.Number_of_Order, T1.Number_of_return, p.ProductSKU, p.ProductName, p.ModelName, p.ProductCost, p.ProductPrice,
    CASE 
        WHEN T1.Number_of_return IS NOT NULL  -- Replace Null value
        THEN concat(ROUND(convert(float, T1.Number_of_return)/ T1.Number_of_Order, 4) * 100, '%')
        ELSE '0%'
    END AS Return_rate
FROM CTE as T1
left join AW_Products as p
on T1. ProductKey = p.ProductKey
order by Return_rate



-- Create Temporary Table to get Profit, Revenue
Drop table if exists #Summary_order_return_of_product
SELECT * INTO #Summary_order_return_of_product
from
(Select s.*, p.ProductSKU, p.ProductName, p.ModelName, p.ProductCost, p.ProductPrice, p.ProductSubcategoryKey from
(SELECT 
        T1.ProductKey,
        T1.Number_of_Order,
		Case
		When T2.Number_of_return is not null
        then T2.Number_of_return
		else 0
		end as Number_of_return
    FROM (
        (SELECT ProductKey, SUM(OrderQuantity) AS Number_of_Order
        FROM #AW_Sales_Temp
        GROUP BY ProductKey
    ) as T1
    LEFT JOIN (
        SELECT ProductKey, SUM(ReturnQuantity) AS Number_of_return
        FROM AW_Returns
        GROUP BY ProductKey
    ) as T2 ON T1.ProductKey = T2.ProductKey )) as s
	left join AW_Products as p
	on s.ProductKey = p.ProductKey) as Final_Table



-- Calculate Revenue, Profit by productkey
Select ProductKey, 
round(ProductPrice*(Number_of_Order - Number_of_return), 2) as Revenue, 
round((ProductPrice*(Number_of_Order - Number_of_return) - ProductCost*(Number_of_Order - Number_of_return)), 2) as Profit from #Summary_order_return_of_product
order by  Profit desc




-- Calculate Revenue, Profit by product Subcategories
select T1.ProductSubcategoryKey, T2.SubcategoryName, 
sum(T1.ProductPrice*(T1.Number_of_Order - T1.Number_of_return)) as revenue, 
sum(T1.ProductPrice*(T1.Number_of_Order - T1.Number_of_return) - T1.ProductCost*(T1.Number_of_Order - T1.Number_of_return)) as profit
from #Summary_order_return_of_product as T1
left join AW_Product_Subcategories as T2
on T1.ProductSubcategoryKey = T2.ProductSubcategoryKey
group by T1.ProductSubcategoryKey,  T2.SubcategoryName
order by profit DESC

-- Create View
Create View product_summary as 
(Select s.*, p.ProductSKU, p.ProductName, p.ModelName, p.ProductCost, p.ProductPrice, p.ProductSubcategoryKey, 
round(p.ProductPrice*(s.Number_of_Order - s.Number_of_return), 2) as Revenue, 
round((p.ProductPrice*(s.Number_of_Order - s.Number_of_return) - p.ProductCost*(s.Number_of_Order - s.Number_of_return)), 2) as Profit  
from
(SELECT 
        T1.ProductKey,
        T1.Number_of_Order,
		Case
		When T2.Number_of_return is not null
        then T2.Number_of_return
		else 0
		end as Number_of_return
    FROM (
        (SELECT ProductKey, SUM(OrderQuantity) AS Number_of_Order
        FROM (SELECT * FROM AW_Sales_2016
	UNION
    SELECT * FROM AW_Sales_2017
    UNION
    SELECT * FROM AW_Sales_2015
) AS CombinedSales
        GROUP BY ProductKey
    ) as T1
    LEFT JOIN (
        SELECT ProductKey, SUM(ReturnQuantity) AS Number_of_return
        FROM AW_Returns
        GROUP BY ProductKey
    ) as T2 ON T1.ProductKey = T2.ProductKey )) as s
	left join AW_Products as p
	on s.ProductKey = p.ProductKey)

Select * from  product_summary