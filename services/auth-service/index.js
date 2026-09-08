const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Health probe for Kubernetes and Ingress
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'healthy', service: 'auth-service' });
});

// Mock authentication endpoint
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body || {};
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password required' });
  }
  return res.status(200).json({
    token: `jwt-mock-token-${Buffer.from(username).toString('base64')}`,
    user: username
  });
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Auth service listening on port ${PORT}`);
  });
}

module.exports = app;