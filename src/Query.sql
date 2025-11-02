create database Smart_Agriculture_3;
use Smart_Agriculture_3;

CREATE TABLE Farmers (
    Farmer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Contact VARCHAR(50),
    Address VARCHAR(255),
    Farm_Count INT,
    Experience_Years INT
);

CREATE TABLE Farms (
    Farm_ID INT PRIMARY KEY,
    Farmer_ID INT,
    Farm_Name VARCHAR(100),
    Location VARCHAR(100),
    Total_Area FLOAT,
    Soil_Type VARCHAR(50),
    FOREIGN KEY (Farmer_ID) REFERENCES Farmers(Farmer_ID)
);

CREATE TABLE Fields (
    Field_ID INT PRIMARY KEY,
    Farm_ID INT,
    Field_Name VARCHAR(100),
    Crop_ID INT,
    Area FLOAT,
    Irrigation_Unit_ID INT,
    FOREIGN KEY (Farm_ID) REFERENCES Farms(Farm_ID)
);

CREATE TABLE Crops (
    Crop_ID INT PRIMARY KEY,
    Crop_Name VARCHAR(100),
    Crop_Type VARCHAR(50),
    Planting_Season VARCHAR(50),
    Expected_Yield_Per_Hectare FLOAT
);

CREATE TABLE Workers (
    Worker_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Contact VARCHAR(50),
    Assigned_Farm_ID INT,
    Task_Assignment VARCHAR(255),
    FOREIGN KEY (Assigned_Farm_ID) REFERENCES Farms(Farm_ID)
);

CREATE TABLE Irrigation_Units (
    Irrigation_Unit_ID INT PRIMARY KEY,
    Type VARCHAR(50),
    Field_ID INT,
    Status VARCHAR(50),
    Last_Maintenance_Date DATE,
    FOREIGN KEY (Field_ID) REFERENCES Fields(Field_ID)
);

CREATE TABLE Soil_Sensors (
    Sensor_ID INT PRIMARY KEY,
    Field_ID INT,
    Moisture_Level FLOAT,
    pH_Level FLOAT,
    Temperature FLOAT,
    Reading_Timestamp DATETIME,
    FOREIGN KEY (Field_ID) REFERENCES Fields(Field_ID)
);

CREATE TABLE Fertilizer_Inventory (
    Fertilizer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Stock_Level INT,
    Recommended_Crop_ID INT,
    Expiry_Date DATE,
    FOREIGN KEY (Recommended_Crop_ID) REFERENCES Crops(Crop_ID)
);

CREATE TABLE Pesticide_Inventory (
    Pesticide_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Stock_Level INT,
    Recommended_Crop_ID INT,
    Expiry_Date DATE,
    FOREIGN KEY (Recommended_Crop_ID) REFERENCES Crops(Crop_ID)
);

CREATE TABLE Equipment (
    Equipment_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Type VARCHAR(50),
    Purchase_Date DATE,
    Last_Maintenance_Date DATE,
    Assigned_Farm_ID INT,
    FOREIGN KEY (Assigned_Farm_ID) REFERENCES Farms(Farm_ID)
);

CREATE TABLE Harvest_Records (
    Harvest_ID INT PRIMARY KEY,
    Field_ID INT,
    Crop_ID INT,
    Quantity FLOAT,
    Harvest_Date DATE,
    Quality_Grade VARCHAR(50),
    FOREIGN KEY (Field_ID) REFERENCES Fields(Field_ID),
    FOREIGN KEY (Crop_ID) REFERENCES Crops(Crop_ID)
);

CREATE TABLE Market_Prices_Sales (
    Sale_ID INT PRIMARY KEY,
    Crop_ID INT,
    Quantity FLOAT,
    Price_Per_Unit FLOAT,
    Sale_Date DATE,
    Buyer VARCHAR(100),
    FOREIGN KEY (Crop_ID) REFERENCES Crops(Crop_ID)
);

CREATE TABLE Weather_Data (
    Weather_ID INT PRIMARY KEY,
    Location VARCHAR(100),
    Date DATE,
    Assigned_Farm_ID INT,
    Temperature FLOAT,
    Rainfall FLOAT,
    Humidity FLOAT,
    Wind_Speed FLOAT,
    FOREIGN KEY (Assigned_Farm_ID) REFERENCES Farms(Farm_ID)
);

CREATE TABLE Maintenance_Logs (
    Maintenance_ID INT PRIMARY KEY,
    Equipment_ID INT,
    Maintenance_Date DATE,
    Description VARCHAR(255),
    Technician VARCHAR(100),
    FOREIGN KEY (Equipment_ID) REFERENCES Equipment(Equipment_ID)
);

CREATE TABLE Alerts_Notifications (
    Alert_ID INT PRIMARY KEY,
    Field_ID INT,
    Alert_Type VARCHAR(50),
    Alert_Description VARCHAR(255),
    Date_Time DATETIME,
    FOREIGN KEY (Field_ID) REFERENCES Fields(Field_ID)
);

CREATE TABLE Farm_Expenses_Payments (
    Expense_ID INT PRIMARY KEY,
    Farm_ID INT,
    Expense_Type VARCHAR(100),
    Amount FLOAT,
    Date DATE,
    FOREIGN KEY (Farm_ID) REFERENCES Farms(Farm_ID)
);

CREATE TABLE Crop_Disease_Reports (
    Report_ID INT PRIMARY KEY,
    Field_ID INT,
    Disease_Name VARCHAR(100),
    Severity VARCHAR(50),
    Date_Detected DATE,
    FOREIGN KEY (Field_ID) REFERENCES Fields(Field_ID)
);
 

-- 1. Sensor-based soil moisture tracking

SELECT Field_ID, Moisture_Level, Reading_Timestamp
FROM Soil_Sensors
ORDER BY Reading_Timestamp DESC;


-- 2. Automated irrigation scheduling

SELECT f.Field_ID, s.Moisture_Level, i.Status
FROM Fields f
JOIN Soil_Sensors s ON f.Field_ID = s.Field_ID
JOIN Irrigation_Units i ON f.Irrigation_Unit_ID = i.Irrigation_Unit_ID
WHERE s.Moisture_Level < 30 AND i.Status = 'OFF';


-- 3. Predictive yield calculation

SELECT f.Field_ID, c.Crop_Name,
       (c.Expected_Yield_Per_Hectare * f.Area) AS Predicted_Yield
FROM Fields f
JOIN Crops c ON f.Crop_ID = c.Crop_ID;


-- 4. Fertilizer/pesticide optimization

SELECT c.Crop_Name, fz.Name AS Recommended_Fertilizer, ps.Name AS Recommended_Pesticide
FROM Crops c
LEFT JOIN Fertilizer_Inventory fz ON fz.Recommended_Crop_ID = c.Crop_ID
LEFT JOIN Pesticide_Inventory ps ON ps.Recommended_Crop_ID = c.Crop_ID;


-- 5. Equipment maintenance alerts

SELECT Equipment_ID, Name, Last_Maintenance_Date
FROM Equipment
WHERE DATEDIFF(CURDATE(), Last_Maintenance_Date) > 90;


-- 6. Crop disease tracking & alerts

SELECT Field_ID, Disease_Name, Severity, Date_Detected
FROM Crop_Disease_Reports
WHERE Severity = 'High';


-- 7. Real-time weather integration

SELECT Location, Date, Temperature, Rainfall, Humidity, Wind_Speed
FROM Weather_Data
ORDER BY Date DESC;


-- 8. Market price tracking

SELECT c.Crop_Name, m.Quantity, m.Price_Per_Unit, m.Sale_Date
FROM Market_Prices_Sales m
JOIN Crops c ON m.Crop_ID = c.Crop_ID
ORDER BY m.Sale_Date DESC;


-- 9. Farm worker task assignment & tracking

SELECT w.Name, f.Farm_Name, w.Task_Assignment
FROM Workers w
JOIN Farms f ON w.Assigned_Farm_ID = f.Farm_ID;


-- 10. Analytics dashboard (basic summary)

SELECT 
    (SELECT COUNT(*) FROM Farmers) AS Total_Farmers,
    (SELECT COUNT(*) FROM Farms) AS Total_Farms,
    (SELECT COUNT(*) FROM Fields) AS Total_Fields,
    (SELECT SUM(Quantity) FROM Harvest_Records) AS Total_Harvest;


-- 11. Export-ready reports (harvest + sales)

SELECT h.Field_ID, c.Crop_Name, h.Quantity, h.Harvest_Date,
       m.Price_Per_Unit, (h.Quantity * m.Price_Per_Unit) AS Revenue
FROM Harvest_Records h
JOIN Crops c ON h.Crop_ID = c.Crop_ID
LEFT JOIN Market_Prices_Sales m ON h.Crop_ID = m.Crop_ID
ORDER BY h.Harvest_Date DESC;