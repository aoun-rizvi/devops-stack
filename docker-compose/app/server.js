const express = require('express');

const app = express();
const port = process.env.PORT || 8080;
const serviceName = process.env.SERVICE_NAME || 'devops-stack';

app.get('/', (_req, res) => {
  res.json({
    message: 'Startup DevOps Stack API',
    service: serviceName,
    docs: '/health'
  });
});

app.get('/health', (_req, res) => {
  res.status(200).json({
    status: 'ok',
    service: serviceName,
    timestamp: new Date().toISOString()
  });
});

app.get('/ready', (_req, res) => {
  res.status(200).json({
    ready: true,
    service: serviceName
  });
});

const server = app.listen(port, () => {
  console.log(`${serviceName} listening on port ${port}`);
});

process.on('SIGTERM', () => {
  console.log('SIGTERM received. Closing HTTP server.');
  server.close(() => {
    console.log('HTTP server closed.');
    process.exit(0);
  });
});

module.exports = app;
