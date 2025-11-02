const mysql = require('mysql2/promise');
const { faker } = require('@faker-js/faker');

async function main() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'agri_user',
    password: 'AgriPass123',
    database: 'Smart_Agriculture_3',
  });

  console.log('Connected to database');

  // ---------- 1. Farmers ----------
  const farmerCount = 50;
  const farmerValues = [];
  for (let i = 1; i <= farmerCount; i++) {
    farmerValues.push([
      i,
      faker.person.fullName(),
      faker.phone.number(),
      faker.location.streetAddress(),
      faker.number.int({ min: 1, max: 5 }),
      faker.number.int({ min: 1, max: 30 }),
    ]);
  }
  await connection.query(
    'INSERT INTO Farmers (Farmer_ID, Name, Contact, Address, Farm_Count, Experience_Years) VALUES ?',
    [farmerValues]
  );
  console.log(`Inserted ${farmerCount} Farmers`);

  // ---------- 2. Farms ----------
  const farmCount = 100;
  const farmValues = [];
  for (let i = 1; i <= farmCount; i++) {
    const farmerId = Math.floor(Math.random() * farmerCount) + 1;
    farmValues.push([
      i,
      farmerId,
      faker.company.name(),
      faker.location.city(),
      faker.number.float({ min: 1, max: 50, precision: 0.1 }),
      faker.helpers.arrayElement(['Loamy','Sandy','Clay','Silt']),
    ]);
  }
  await connection.query(
    'INSERT INTO Farms (Farm_ID, Farmer_ID, Farm_Name, Location, Total_Area, Soil_Type) VALUES ?',
    [farmValues]
  );
  console.log(`Inserted ${farmCount} Farms`);

  // ---------- 3. Fields ----------
  const fieldCount = 500;
  const fieldValues = [];
  for (let i = 1; i <= fieldCount; i++) {
    const farmId = Math.floor(Math.random() * farmCount) + 1;
    const irrigationUnitId = i; 
    fieldValues.push([
      i,
      farmId,
      `Field ${i}`,
      Math.floor(Math.random() * 50) + 1, 
      faker.number.float({ min: 0.5, max: 10, precision: 0.01 }),
      irrigationUnitId,
    ]);
  }
  await connection.query(
    'INSERT INTO Fields (Field_ID, Farm_ID, Field_Name, Crop_ID, Area, Irrigation_Unit_ID) VALUES ?',
    [fieldValues]
  );
  console.log(`Inserted ${fieldCount} Fields`);

  // ---------- 4. Crops ----------
  const cropCount = 50;
  const cropValues = [];
  const cropTypes = ['Vegetable', 'Fruit', 'Grain', 'Legume'];
  const plantingSeasons = ['Spring','Summer','Autumn','Winter'];
  for (let i = 1; i <= cropCount; i++) {
    cropValues.push([
      i,
      faker.word.sample(),
      faker.helpers.arrayElement(cropTypes),
      faker.helpers.arrayElement(plantingSeasons),
      faker.number.float({ min: 1, max: 10, precision: 0.1 }),
    ]);
  }
  await connection.query(
    'INSERT INTO Crops (Crop_ID, Crop_Name, Crop_Type, Planting_Season, Expected_Yield_Per_Hectare) VALUES ?',
    [cropValues]
  );
  console.log(`Inserted ${cropCount} Crops`);

  // ---------- 5. Workers ----------
  const workerCount = 300;
  const workerValues = [];
  for (let i = 1; i <= workerCount; i++) {
    const farmId = Math.floor(Math.random() * farmCount) + 1;
    workerValues.push([
      i,
      faker.person.fullName(),
      faker.phone.number(),
      farmId,
      faker.lorem.sentence()
    ]);
  }
  await connection.query(
    'INSERT INTO Workers (Worker_ID, Name, Contact, Assigned_Farm_ID, Task_Assignment) VALUES ?',
    [workerValues]
  );
  console.log(`Inserted ${workerCount} Workers`);

  // ---------- 6. Irrigation Units ----------
  const irrigationCount = fieldCount; 
  const irrigationValues = [];
  for (let i = 1; i <= irrigationCount; i++) {
    irrigationValues.push([
      i,
      faker.helpers.arrayElement(['Drip','Sprinkler','Flood']),
      i, // field_id
      faker.helpers.arrayElement(['ON','OFF']),
      faker.date.recent(180)
    ]);
  }
  await connection.query(
    'INSERT INTO Irrigation_Units (Irrigation_Unit_ID, Type, Field_ID, Status, Last_Maintenance_Date) VALUES ?',
    [irrigationValues]
  );
  console.log(`Inserted ${irrigationCount} Irrigation Units`);

  // ---------- 7. Soil Sensors ----------
  const sensorCount = fieldCount; 
  const sensorValues = [];
  for (let i = 1; i <= sensorCount; i++) {
    sensorValues.push([
      i,
      i, // field_id
      faker.number.float({ min: 10, max: 90 }),
      faker.number.float({ min: 5, max: 8 }),
      faker.number.float({ min: 15, max: 45 }),
      faker.date.recent(30)
    ]);
  }
  await connection.query(
    'INSERT INTO Soil_Sensors (Sensor_ID, Field_ID, Moisture_Level, pH_Level, Temperature, Reading_Timestamp) VALUES ?',
    [sensorValues]
  );
  console.log(`Inserted ${sensorCount} Soil Sensors`);

  // ---------- 8. Fertilizer Inventory ----------
  const fertilizerCount = 100;
  const fertilizerValues = [];
  for (let i = 1; i <= fertilizerCount; i++) {
    fertilizerValues.push([
      i,
      faker.word.sample(),
      faker.number.int({ min: 10, max: 500 }),
      Math.floor(Math.random() * cropCount) + 1,
      faker.date.future()
    ]);
  }
  await connection.query(
    'INSERT INTO Fertilizer_Inventory (Fertilizer_ID, Name, Stock_Level, Recommended_Crop_ID, Expiry_Date) VALUES ?',
    [fertilizerValues]
  );
  console.log(`Inserted ${fertilizerCount} Fertilizers`);

  // ---------- 9. Pesticide Inventory ----------
  const pesticideCount = 100;
  const pesticideValues = [];
  for (let i = 1; i <= pesticideCount; i++) {
    pesticideValues.push([
      i,
      faker.word.sample(),
      faker.number.int({ min: 10, max: 500 }),
      Math.floor(Math.random() * cropCount) + 1,
      faker.date.future()
    ]);
  }
  await connection.query(
    'INSERT INTO Pesticide_Inventory (Pesticide_ID, Name, Stock_Level, Recommended_Crop_ID, Expiry_Date) VALUES ?',
    [pesticideValues]
  );
  console.log(`Inserted ${pesticideCount} Pesticides`);

  // ---------- 10. Equipment ----------
  const equipmentCount = 150;
  const equipmentValues = [];
  for (let i = 1; i <= equipmentCount; i++) {
    const farmId = Math.floor(Math.random() * farmCount) + 1;
    equipmentValues.push([
      i,
      faker.vehicle.model(),
      faker.helpers.arrayElement(['Tractor','Sprayer','Harvester']),
      faker.date.past({ years:2 }),
      faker.date.recent(180),
      farmId
    ]);
  }
  await connection.query(
    'INSERT INTO Equipment (Equipment_ID, Name, Type, Purchase_Date, Last_Maintenance_Date, Assigned_Farm_ID) VALUES ?',
    [equipmentValues]
  );
  console.log(`Inserted ${equipmentCount} Equipment`);

  // ---------- 11. Harvest Records ----------
  const harvestCount = 500;
  const harvestValues = [];
  for (let i = 1; i <= harvestCount; i++) {
    const fieldId = Math.floor(Math.random() * fieldCount) + 1;
    const cropId = Math.floor(Math.random() * cropCount) + 1;
    harvestValues.push([
      i,
      fieldId,
      cropId,
      faker.number.float({ min: 100, max: 5000 }),
      faker.date.recent(100),
      faker.helpers.arrayElement(['A','B','C'])
    ]);
  }
  await connection.query(
    'INSERT INTO Harvest_Records (Harvest_ID, Field_ID, Crop_ID, Quantity, Harvest_Date, Quality_Grade) VALUES ?',
    [harvestValues]
  );
  console.log(`Inserted ${harvestCount} Harvest Records`);

  // ---------- 12. Market Prices ----------
  const marketCount = 1000;
  const marketValues = [];
  for (let i = 1; i <= marketCount; i++) {
    const cropId = Math.floor(Math.random() * cropCount) + 1;
    marketValues.push([
      i,
      cropId,
      faker.number.float({ min: 10, max: 1000 }),
      faker.number.float({ min: 5, max: 500 }),
      faker.date.recent(100),
      faker.person.fullName()
    ]);
  }
  await connection.query(
    'INSERT INTO Market_Prices (Sale_ID, Crop_ID, Quantity, Price_Per_Unit, Sale_Date, Buyer) VALUES ?',
    [marketValues]
  );
  console.log(`Inserted ${marketCount} Market Prices`);

  // ---------- 13. Weather Data ----------
  const weatherCount = 2500;
  const weatherValues = [];
  for (let i = 1; i <= weatherCount; i++) {
    const farmId = Math.floor(Math.random() * farmCount) + 1;
    weatherValues.push([
      i,
      faker.location.city(),
      faker.date.recent(30),
      farmId,
      faker.number.float({ min: 15, max: 45 }),
      faker.number.float({ min: 0, max: 200 }),
      faker.number.float({ min: 20, max: 100 }),
      faker.number.float({ min: 0, max: 50 })
    ]);
  }
  await connection.query(
    'INSERT INTO Weather_Data (Weather_ID, Location, Date, Assigned_Farm_ID, Temperature, Rainfall, Humidity, Wind_Speed) VALUES ?',
    [weatherValues]
  );
  console.log(`Inserted ${weatherCount} Weather Records`);

  // ---------- 14. Maintenance Logs ----------
  const maintenanceCount = 300;
  const maintenanceValues = [];
  for (let i = 1; i <= maintenanceCount; i++) {
    const equipmentId = Math.floor(Math.random() * equipmentCount) + 1;
    maintenanceValues.push([i, equipmentId, faker.date.recent(100), faker.lorem.sentence(), faker.person.fullName()]);
  }
  await connection.query(
    'INSERT INTO Maintenance_Logs (Maintenance_ID, Equipment_ID, Maintenance_Date, Description, Technician) VALUES ?',
    [maintenanceValues]
  );
  console.log(`Inserted ${maintenanceCount} Maintenance Logs`);

  // ---------- 15. Alerts & Notifications ----------
  const alertsCount = 2000;
  const alertValues = [];
  for (let i = 1; i <= alertsCount; i++) {
    const fieldId = Math.floor(Math.random() * fieldCount) + 1;
    alertValues.push([i, fieldId, faker.helpers.arrayElement(['Moisture Low','Disease Alert','Irrigation Failure']), faker.lorem.sentence(), faker.date.recent(30)]);
  }
  await connection.query(
    'INSERT INTO Alerts (Alert_ID, Field_ID, Alert_Type, Alert_Description, Date_Time) VALUES ?',
    [alertValues]
  );
  console.log(`Inserted ${alertsCount} Alerts`);

  // ---------- 16. Farm Expenses ----------
  const expenseCount = 200;
  const expenseValues = [];
  for (let i = 1; i <= expenseCount; i++) {
    const farmId = Math.floor(Math.random() * farmCount) + 1;
    expenseValues.push([i, farmId, faker.commerce.department() + ' Expense', faker.number.float({ min: 100, max: 5000, precision: 0.01 }), faker.date.recent(100)]);
  }
  await connection.query(
    'INSERT INTO Farm_Expenses (Expense_ID, Farm_ID, Expense_Type, Amount, Date) VALUES ?',
    [expenseValues]
  );
  console.log(`Inserted ${expenseCount} Expenses`);

  // ---------- 17. Crop Disease Reports ----------
  const diseaseCount = 3000;
  const diseaseValues = [];
  const severities = ['Low', 'Medium', 'High'];
  for (let i = 1; i <= diseaseCount; i++) {
    const fieldId = Math.floor(Math.random() * fieldCount) + 1;
    diseaseValues.push([i, fieldId, faker.word.sample() + ' Disease', faker.helpers.arrayElement(severities), faker.date.recent(30)]);
  }
  await connection.query(
    'INSERT INTO Crop_Disease_Reports (Report_ID, Field_ID, Disease_Name, Severity, Date_Detected) VALUES ?',
    [diseaseValues]
  );
  console.log(`Inserted ${diseaseCount} Crop Disease Reports`);

  console.log('🎉 All tables populated successfully!');

  await connection.end();
}

main().catch(err => console.error(err));
