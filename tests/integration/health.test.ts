import { describe, it, expect } from 'vitest';
import request from 'supertest';
import { createApp } from '../../src/app.js';

describe('System Health & Info API', () => {
  const app = createApp();

  it('GET / should return root API metadata', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.body.name).toBe('Mausam Backend API');
    expect(res.body.version).toBe('1.0.0');
    expect(res.body.health).toBe('/api/v1/health');
  });

  it('GET /api/v1/ping should return pong', async () => {
    const res = await request(app).get('/api/v1/ping');
    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.message).toBe('pong');
  });

  it('GET /api/v1/non-existent-route should return 404 with structured error', async () => {
    const res = await request(app).get('/api/v1/non-existent-route');
    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
    expect(res.body.error.code).toBe('ROUTE_NOT_FOUND');
    expect(res.headers['x-request-id']).toBeDefined();
  });
});
