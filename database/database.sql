-- Create database
CREATE DATABASE CyberGaming;
GO

-- Use the database
USE CyberGaming;
GO

-- Table for managing gaming PCs
CREATE TABLE PCs
(
    pc_id INT PRIMARY KEY IDENTITY(1,1),
    pc_name VARCHAR(50) NOT NULL,
    ip_address VARCHAR(15) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Available', 'In Use', 'Under Maintenance')),
    purchase_date DATE,
    specification VARCHAR(MAX)
    -- Changed from TEXT to VARCHAR(MAX)
);
GO

-- Table for managing customers
CREATE TABLE Customers
(
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    email VARCHAR(100),
    is_vip VARCHAR(3) NOT NULL DEFAULT 'No' CHECK (is_vip IN ('Yes', 'No')),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Table for managing games
CREATE TABLE Games
(
    game_id INT PRIMARY KEY IDENTITY(1,1),
    game_name VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    developer VARCHAR(100),
    release_year INT,
    created_by INT NULL,
    updated_by INT NULL,
    FOREIGN KEY (created_by) REFERENCES Admins(admin_id),
    FOREIGN KEY (updated_by) REFERENCES Admins(admin_id)
);
GO

-- Table for managing payments
CREATE TABLE Payments
(
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('Cash', 'Credit Card', 'E-wallet')),
    admin_id INT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (admin_id) REFERENCES Admins(admin_id)
);
GO

-- Table for managing game sessions
CREATE TABLE GameSessions
(
    session_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    game_id INT NOT NULL,
    pc_id INT NOT NULL,
    session_start_time DATETIME NOT NULL,
    session_end_time DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id),
    FOREIGN KEY (pc_id) REFERENCES PCs(pc_id)
);
GO

-- Table for managing companions (female companions)
CREATE TABLE Companions
(
    companion_id INT PRIMARY KEY IDENTITY(1,1),
    full_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    available VARCHAR(3) NOT NULL DEFAULT 'Yes' CHECK (available IN ('Yes', 'No')),
    hourly_rate DECIMAL(10, 2) NOT NULL,
    description VARCHAR(MAX)
    -- Changed from TEXT to VARCHAR(MAX)
);
GO

-- Table for managing special VIP services (hiring companions and ordering oysters)
CREATE TABLE VIPServices
(
    service_id INT PRIMARY KEY IDENTITY(1,1),
    service_name VARCHAR(100) NOT NULL,
    description VARCHAR(MAX) NOT NULL,
    -- Changed from TEXT to VARCHAR(MAX)
    price DECIMAL(10, 2) NOT NULL
);
GO

-- Insert predefined services (e.g., Playing Game and Ordering Oysters)
INSERT INTO VIPServices
    (service_name, description, price)
VALUES
    ('Companion Play', 'Hire a female companion to play games with you', 50.00),
    ('Oysters Package', 'Order a plate of fresh oysters to enjoy during your session', 30.00);
GO

-- Table for managing VIP bookings (track when customers book a companion or service)
CREATE TABLE VIPBookings
(
    vip_booking_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    companion_id INT NULL,
    service_id INT NULL,
    booking_start_time DATETIME NOT NULL,
    booking_end_time DATETIME,
    total_price DECIMAL(10, 2) NOT NULL,
    admin_id INT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (companion_id) REFERENCES Companions(companion_id),
    FOREIGN KEY (service_id) REFERENCES VIPServices(service_id),
    FOREIGN KEY (admin_id) REFERENCES Admins(admin_id)
);
GO

-- Table for managing bookings
CREATE TABLE Bookings
(
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    pc_id INT NOT NULL,
    booking_start_time DATETIME NOT NULL,
    booking_end_time DATETIME NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    vip_booking_id INT NULL,
    admin_id INT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (pc_id) REFERENCES PCs(pc_id),
    FOREIGN KEY (vip_booking_id) REFERENCES VIPBookings(vip_booking_id),
    FOREIGN KEY (admin_id) REFERENCES Admins(admin_id)
);
GO

-- Table for managing admin users
CREATE TABLE Admins
(
    admin_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    -- Password should be securely hashed
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15),
    role VARCHAR(20) NOT NULL CHECK (role IN ('SuperAdmin', 'Moderator')),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Create additional tables with corrected syntax

-- Table for managing top-ups
CREATE TABLE Top_up
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(255),
    price DECIMAL(10),
    ImageLink VARCHAR(500)
);
GO

-- Table for managing drinks
CREATE TABLE Drinks
(
    id INT PRIMARY KEY IDENTITY(1,1),
    -- Changed AUTO_INCREMENT to IDENTITY
    name VARCHAR(255),
    price DECIMAL(10),
    ImageLink VARCHAR(500)
);
GO

-- Table for managing foods
CREATE TABLE Foods
(
    id INT PRIMARY KEY IDENTITY(1,1),
    -- Changed AUTO_INCREMENT to IDENTITY
    name VARCHAR(255),
    price DECIMAL(10),
    ImageLink VARCHAR(500)
);
GO

-- Table for managing game top-ups
CREATE TABLE Games_top_up
(
    id INT PRIMARY KEY IDENTITY(1,1),
    -- Changed AUTO_INCREMENT to IDENTITY
    option_name VARCHAR(255),
    price DECIMAL(10),
    ImageLink VARCHAR(500)
);
GO

-- Table for managing orders
CREATE TABLE Orders
(
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    total_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
GO

ALTER TABLE Orders
ADD is_locked BIT NOT NULL DEFAULT 0;
GO

-- Table for managing order details
CREATE TABLE OrderDetails
(
    detail_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('Food', 'Drink', 'Top_up', 'Games_Top_up')),
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_per_item DECIMAL(10, 2) NOT NULL,
    total_price AS (quantity * price_per_item) PERSISTED,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
GO

ALTER TABLE OrderDetails
ADD status VARCHAR(20) NOT NULL DEFAULT 'In-cart'
CHECK (status IN ('In-cart', 'Pending', 'Served'));

-- Trigger After Insert on OrderDetails
CREATE OR ALTER TRIGGER trg_OrderDetails_Insert
ON OrderDetails
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Orders
    SET total_price = (
        SELECT ISNULL(SUM(total_price), 0)
    FROM OrderDetails
    WHERE OrderDetails.order_id = Orders.order_id
        AND OrderDetails.status = 'In-cart'
    )
    WHERE Orders.order_id IN (
        SELECT DISTINCT order_id
    FROM inserted
    );
END;
GO

-- Trigger After Update on OrderDetails
CREATE OR ALTER TRIGGER trg_OrderDetails_Update
ON OrderDetails
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Orders
    SET total_price = (
        SELECT ISNULL(SUM(total_price), 0)
    FROM OrderDetails
    WHERE OrderDetails.order_id = Orders.order_id
        AND OrderDetails.status = 'In-cart'
    )
    WHERE Orders.order_id IN (
        SELECT DISTINCT order_id
        FROM inserted
    UNION
        SELECT DISTINCT order_id
        FROM deleted
    );
END;
GO


-- Trigger After Delete on OrderDetails
CREATE OR ALTER TRIGGER trg_OrderDetails_Delete
ON OrderDetails
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Orders
    SET total_price = (
        SELECT ISNULL(SUM(total_price), 0)
    FROM OrderDetails
    WHERE OrderDetails.order_id = Orders.order_id
        AND OrderDetails.status = 'In-cart'
    )
    WHERE Orders.order_id IN (
        SELECT DISTINCT order_id
    FROM deleted
    );
END;
GO


-- All orders in Served leads to update is_locked to 0
CREATE OR ALTER TRIGGER trg_UpdateOrderLockStatusOnAllServed
ON OrderDetails
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- For all orders affected by this update, check if all items are now 'Served'
    UPDATE o
    SET o.is_locked = 0
    FROM Orders o
        INNER JOIN (
        -- Get distinct order_ids from the updated rows
        SELECT DISTINCT i.order_id
        FROM inserted i
    ) as updatedOrders ON o.order_id = updatedOrders.order_id
    WHERE NOT EXISTS (
        -- If there's any item in the order that is not 'Served',
        -- then we do not unlock the order.
        SELECT 1
    FROM OrderDetails od
    WHERE od.order_id = o.order_id
        AND od.status <> 'Served'
    );
END;
GO


USE CyberGaming;