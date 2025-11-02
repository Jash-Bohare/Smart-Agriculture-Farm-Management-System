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