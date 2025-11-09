const express = require('express');
const app = express();
app.use(express.json());

// Enable CORS for cross-origin requests from different ports
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// in-memory "db"
const reservations = [];

// POST /reserve
// body: { name: "Danielle", time: "2025-11-02T20:00", guests: 4 }
app.post('/reserve', (req, res) => {
  const { name, time, guests } = req.body || {};
  if (!name || !time || !guests) {
    return res.status(400).json({ error: 'missing fields' });
  }
  const r = {
    id: reservations.length + 1,
    name,
    time,
    guests
  };
  reservations.push(r);
  return res.status(201).json(r);
});

// GET /reservations
app.get('/reservations', (_req, res) => {
  return res.json({ count: reservations.length, reservations });
});

// health for uptime / k8s
app.get('/health', (_req, res) => {
  res.json({ ok: true });
});

const port = process.env.PORT || 3001;
app.listen(port, () => {
  console.log(`[reservation-api] listening on ${port}`);
});

module.exports = { reservations }; // exported for test
