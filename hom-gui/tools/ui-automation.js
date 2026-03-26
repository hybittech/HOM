import { chromium } from 'playwright';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Viewports configuration
const viewports = [
  { name: 'HP', width: 375, height: 812 },
  { name: 'Tablet', width: 768, height: 1024 },
  { name: 'PC', width: 1440, height: 900 }
];

// Pages to test
const pagesToTest = [
  { path: '/', name: 'landing' },
  { path: '/explorer', name: 'explorer' },
  { path: '/lab', name: 'lab' }
];

const BASE_URL = 'http://localhost:5173'; // Make sure the server runs on this port
const screenshotsDir = path.join(__dirname, '..', 'tests', 'screenshots');

async function run() {
  console.log('Starting Playwright UI Automation Tests...');
  
  // Ensure directory exists
  if (!fs.existsSync(screenshotsDir)) {
    fs.mkdirSync(screenshotsDir, { recursive: true });
  }

  const browser = await chromium.launch();

  try {
    for (const vp of viewports) {
      const context = await browser.newContext({
        viewport: { width: vp.width, height: vp.height },
        deviceScaleFactor: 2, // HiDPI
      });
      const page = await context.newPage();

      for (const p of pagesToTest) {
        console.log(`Testing ${vp.name} viewport for page: ${p.name}`);
        try {
          // Add a timeout and wait until network is mostly idle
          await page.goto(`${BASE_URL}${p.path}`, { waitUntil: 'networkidle', timeout: 30000 });
          
          // Wait an extra second for any animations (like glowing lines) to settle
          await page.waitForTimeout(1000);

          const ssPath = path.join(screenshotsDir, `${p.name}_${vp.name.toLowerCase()}.png`);
          await page.screenshot({ path: ssPath, fullPage: true });
          console.log(`  -> Screenshot saved: ${ssPath}`);
        } catch (err) {
          console.error(`  -> Failed to capture ${p.name} on ${vp.name}:`, err.message);
        }
      }
      await context.close();
    }
  } catch (err) {
    console.error('Test execution failed:', err);
  } finally {
    await browser.close();
    console.log('UI Automation Tests Completed.');
  }
}

// Check if dev server is running before executing
fetch(BASE_URL).then(() => {
  run();
}).catch(() => {
  console.error(`Error: Dev server is not running at ${BASE_URL}`);
  console.error(`Please run 'npm run dev' in another terminal first.`);
  process.exit(1);
});
