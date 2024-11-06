-- Insert sample data into PCs table
INSERT INTO PCs
    (pc_name, ip_address, status, purchase_date, specification)
VALUES
    ('Alienware Aurora', '192.168.1.10', 'Available', '2023-02-15', 'Intel i9, 32GB RAM, Nvidia RTX 3080'),
    ('Asus ROG Strix', '192.168.1.11', 'In Use', '2022-10-05', 'AMD Ryzen 9, 16GB RAM, Nvidia GTX 1660'),
    ('HP Omen', '192.168.1.12', 'Under Maintenance', '2021-08-20', 'Intel i7, 16GB RAM, Nvidia GTX 1080');

-- Insert sample data into Customers table
INSERT INTO Customers
    (full_name, username, password, phone_number, email, is_vip, created_by, updated_by)
VALUES
    ('John Doe', 'johndoe', 'password123', '1234567890', 'johndoe@example.com', 'Yes', 1, NULL),
    ('Jane Smith', 'janesmith', 'password123', '0987654321', 'janesmith@example.com', 'No', 1, NULL),
    ('Alice Johnson', 'alicej', 'password123', '5551234567', 'alicej@example.com', 'Yes', 1, NULL);

-- Insert sample data into Games table
INSERT INTO Games
    (game_name, genre, developer, release_year, created_by, updated_by)
VALUES
    ('Cyberpunk 2077', 'RPG', 'CD Projekt', 2020, 1, NULL),
    ('Minecraft', 'Sandbox', 'Mojang', 2009, 1, NULL),
    ('Fortnite', 'Battle Royale', 'Epic Games', 2017, 1, NULL);

-- Insert sample data into Payments table
INSERT INTO Payments
    (customer_id, amount, payment_date, payment_method, admin_id)
VALUES
    (2, 150.00, '2024-11-01', 'Credit Card', 1),
    (3, 50.00, '2024-10-28', 'Cash', 2),
    (4, 100.00, '2024-11-02', 'E-wallet', 1);

-- Insert sample data into GameSessions table
INSERT INTO GameSessions
    (customer_id, game_id, pc_id, session_start_time, session_end_time)
VALUES
    (2, 4, 2, '2024-11-03 15:00:00', '2024-11-03 18:00:00'),
    (3, 2, 1, '2024-11-03 16:00:00', '2024-11-03 19:00:00'),
    (4, 3, 3, '2024-11-02 13:00:00', '2024-11-02 15:00:00');

-- Insert sample data into Companions table
INSERT INTO Companions
    (full_name, age, available, hourly_rate, description)
VALUES
    ('Lily', 25, 'Yes', 30.00, 'Fun and engaging gaming companion'),
    ('Mia', 27, 'No', 35.00, 'Great conversationalist with a love for strategy games'),
    ('Emma', 22, 'Yes', 25.00, 'Specializes in RPG and sandbox games');

-- Insert sample data into VIPServices table
INSERT INTO VIPServices
    (service_name, description, price)
VALUES
    ('Private Room', 'Exclusive gaming room with enhanced amenities', 100.00),
    ('Premium Snacks', 'Enjoy a selection of premium snacks and drinks', 20.00);

-- Insert sample data into VIPBookings table
INSERT INTO VIPBookings
    (customer_id, companion_id, service_id, booking_start_time, booking_end_time, total_price, admin_id)
VALUES
    (2, 1, NULL, '2024-11-03 16:00:00', '2024-11-03 18:00:00', 60.00, 1),
    (3, NULL, 1, '2024-11-02 17:00:00', '2024-11-02 19:00:00', 100.00, 2),
    (4, 2, 2, '2024-11-01 14:00:00', '2024-11-01 16:00:00', 55.00, 1);

-- Insert sample data into Bookings table
INSERT INTO Bookings
    (customer_id, pc_id, booking_start_time, booking_end_time, total_price, vip_booking_id, admin_id)
VALUES
    (2, 1, '2024-11-03 15:00:00', '2024-11-03 18:00:00', 120.00, 5, 1),
    (3, 2, '2024-11-02 17:00:00', '2024-11-02 19:00:00', 90.00, NULL, 2),
    (4, 3, '2024-11-01 14:00:00', '2024-11-01 16:00:00', 75.00, 6, 1);

-- Insert sample data into Admins table
INSERT INTO Admins
    (username, password, full_name, email, phone_number, role)
VALUES
    ('admin', 'adminpassword', 'Super Admin', 'admin@example.com', '1231231234', 'SuperAdmin'),
    ('moderator', 'modpassword', 'Site Moderator', 'mod@example.com', '3213214321', 'Moderator');


SELECT *
FROM Admins
SELECT *
FROM Bookings
SELECT *
FROM Companions
SELECT *
FROM Customers
SELECT *
FROM Games
SELECT *
FROM GameSessions
SELECT *
FROM Payments
SELECT *
FROM PCs
SELECT *
FROM VIPBookings
SELECT *
FROM VIPServices
