import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['tests/**/*.test.ts', 'src/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
    },
  },
  resolve: {
    alias: {
      '@config': path.resolve(__dirname, './src/config'),
      '@core': path.resolve(__dirname, './src/core'),
      '@modules': path.resolve(__dirname, './src/modules'),
      '@integrations': path.resolve(__dirname, './src/integrations'),
      '@jobs': path.resolve(__dirname, './src/jobs'),
      '@queues': path.resolve(__dirname, './src/queues'),
      '@routes': path.resolve(__dirname, './src/routes'),
    },
  },
});
