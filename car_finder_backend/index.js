const express = require('express');
const fs = require('fs');
const app = express();
const port = 5000;

app.use(express.json());

app.get('/', (req, res) => {
  res.send('Welcome to Car Finder Backend!');
});

app.get('/all-locations', (req, res) => {
  if (fs.existsSync('locations.json')) {
    const rawData = fs.readFileSync('locations.json');
    const locations = JSON.parse(rawData);
    res.json(locations);
  } else {
    res.json([]);
  }
});

app.post('/save-location', (req, res) => {
  const newLocation = req.body;

  if (!newLocation.latitude || !newLocation.longitude || !newLocation.id) {
    console.log('Validation Failed: Missing required fields');
    return res.status(400).json({ error: 'Missing required location fields' });
  }

  console.log('Received Valid Location Data:', newLocation);

  let savedData = [];
  if (fs.existsSync('locations.json')) {
    try {
      const rawData = fs.readFileSync('locations.json');
      savedData = JSON.parse(rawData);
    } catch (e) {
      savedData = [];
    }
  }

  savedData.push(newLocation);
  fs.writeFileSync('locations.json', JSON.stringify(savedData, null, 2));

  res.json({
    status: 'success',
    message: 'Location validated and saved successfully'
  });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});