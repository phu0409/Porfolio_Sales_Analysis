CREATE TABLE AW_Product_Categories (
    ProductCategoryKey INT PRIMARY KEY,    -- Mã danh mục sản phẩm (Khóa chính)
    CategoryName NVARCHAR(100)            -- Tên danh mục sản phẩm
);
CREATE TABLE AW_Product_Subcategories (
    ProductSubcategoryKey INT PRIMARY KEY,       -- Mã danh mục phụ sản phẩm (Khóa chính)
    SubcategoryName NVARCHAR(100),              -- Tên danh mục phụ sản phẩm
    ProductCategoryKey INT,                     -- Mã danh mục sản phẩm (Khóa ngoại)
    FOREIGN KEY (ProductCategoryKey) REFERENCES AW_Product_Categories(ProductCategoryKey) -- Tham chiếu đến bảng cha
);
CREATE TABLE AW_Products (
    ProductKey INT PRIMARY KEY,                -- Mã sản phẩm (Khóa chính)
    ProductSubcategoryKey INT,                -- Mã danh mục phụ sản phẩm (Khóa ngoại)
    ProductSKU NVARCHAR(50),                  -- Mã SKU sản phẩm
    ProductName NVARCHAR(255),                -- Tên sản phẩm
    ModelName NVARCHAR(255),                  -- Tên mẫu sản phẩm
    ProductDescription NVARCHAR(MAX),         -- Mô tả sản phẩm
    ProductColor NVARCHAR(50),                -- Màu sản phẩm
    ProductSize NVARCHAR(10),                 -- Kích cỡ sản phẩm
    ProductStyle NVARCHAR(10),                -- Phong cách sản phẩm
    ProductCost DECIMAL(18, 4),               -- Chi phí sản xuất sản phẩm
    ProductPrice DECIMAL(18, 4),              -- Giá bán sản phẩm
    FOREIGN KEY (ProductSubcategoryKey) REFERENCES AW_Product_Subcategories(ProductSubcategoryKey) -- Tham chiếu đến danh mục phụ sản phẩm
);
CREATE TABLE AW_Customers (
    CustomerKey INT PRIMARY KEY,             -- Mã khách hàng (Khóa chính)
    Prefix NVARCHAR(10),                     -- Danh xưng (Mr., Ms., Mrs.)
    FirstName NVARCHAR(50),                  -- Tên khách hàng
    LastName NVARCHAR(50),                   -- Họ khách hàng
    BirthDate DATE,                          -- Ngày sinh
    MaritalStatus NVARCHAR(1),               -- Tình trạng hôn nhân (M: Married, S: Single)
    Gender NVARCHAR(1),                      -- Giới tính (M: Male, F: Female)
    EmailAddress NVARCHAR(255),              -- Địa chỉ email
    AnnualIncome DECIMAL(18, 2),             -- Thu nhập hàng năm
    TotalChildren INT,                       -- Tổng số con
    EducationLevel NVARCHAR(50),             -- Trình độ học vấn
    Occupation NVARCHAR(50),                 -- Nghề nghiệp
    HomeOwner NVARCHAR(1)                    -- Có sở hữu nhà không (Y: Yes, N: No)
);
CREATE TABLE AW_Calendar (
    Date DATE PRIMARY KEY  -- Ngày (Khóa chính)
);
CREATE TABLE AdventureWorks_Territories (
    SalesTerritoryKey INT PRIMARY KEY,      -- Mã lãnh thổ bán hàng (Khóa chính)
    Region NVARCHAR(100),                   -- Khu vực
    Country NVARCHAR(100),                  -- Quốc gia
    Continent NVARCHAR(100)                 -- Lục địa
);
CREATE TABLE AW_Sales_2015 (
    OrderDate DATE,                          -- Ngày đặt hàng
    StockDate DATE,                          -- Ngày xuất kho
    OrderNumber NVARCHAR(50),                -- Mã số đơn hàng
    ProductKey INT,                          -- Mã sản phẩm (Khóa ngoại)
    CustomerKey INT,                         -- Mã khách hàng (Khóa ngoại)
    TerritoryKey INT,                        -- Mã lãnh thổ (Khóa ngoại)
    OrderLineItem INT,                       -- Dòng sản phẩm trong đơn hàng
    OrderQuantity INT,                       -- Số lượng đặt hàng
    PRIMARY KEY (OrderNumber, OrderLineItem), -- Khóa chính
    FOREIGN KEY (ProductKey) REFERENCES AW_Products(ProductKey),         -- Khóa ngoại tham chiếu bảng sản phẩm
    FOREIGN KEY (CustomerKey) REFERENCES AW_Customers(CustomerKey),      -- Khóa ngoại tham chiếu bảng khách hàng
    FOREIGN KEY (TerritoryKey) REFERENCES AdventureWorks_Territories(SalesTerritoryKey) -- Khóa ngoại tham chiếu bảng lãnh thổ
);
CREATE TABLE AW_Sales_2016 (
    OrderDate DATE,
    StockDate DATE,
    OrderNumber NVARCHAR(50),
    ProductKey INT,
    CustomerKey INT,
    TerritoryKey INT,
    OrderLineItem INT,
    OrderQuantity INT,
    PRIMARY KEY (OrderNumber, OrderLineItem),
    FOREIGN KEY (ProductKey) REFERENCES AW_Products(ProductKey),
    FOREIGN KEY (CustomerKey) REFERENCES AW_Customers(CustomerKey),
    FOREIGN KEY (TerritoryKey) REFERENCES AdventureWorks_Territories(SalesTerritoryKey)
);
CREATE TABLE AW_Sales_2017 (
    OrderDate DATE,
    StockDate DATE,
    OrderNumber NVARCHAR(50),
    ProductKey INT,
    CustomerKey INT,
    TerritoryKey INT,
    OrderLineItem INT,
    OrderQuantity INT,
    PRIMARY KEY (OrderNumber, OrderLineItem),
    FOREIGN KEY (ProductKey) REFERENCES AW_Products(ProductKey),
    FOREIGN KEY (CustomerKey) REFERENCES AW_Customers(CustomerKey),
    FOREIGN KEY (TerritoryKey) REFERENCES AdventureWorks_Territories(SalesTerritoryKey)
);
CREATE TABLE AW_Returns (
    ReturnDate DATE,                          -- Ngày trả hàng
    TerritoryKey INT,                        -- Mã lãnh thổ (Khóa ngoại)
    ProductKey INT,                          -- Mã sản phẩm (Khóa ngoại)
    ReturnQuantity INT,                      -- Số lượng trả
    PRIMARY KEY (ReturnDate, TerritoryKey, ProductKey), -- Khóa chính
    FOREIGN KEY (TerritoryKey) REFERENCES AdventureWorks_Territories(SalesTerritoryKey), -- Tham chiếu bảng lãnh thổ
    FOREIGN KEY (ProductKey) REFERENCES AW_Products(ProductKey) -- Tham chiếu bảng sản phẩm
);






