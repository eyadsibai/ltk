---
name: e2e-testing
description: Use when implementing end-to-end tests, using Playwright or Cypress, testing user journeys, debugging flaky tests, or asking about "E2E testing", "Playwright", "Cypress", "browser testing", "visual regression", "test automation"
version: 1.0.0
---

# E2E Testing Patterns

Build reliable, fast, and maintainable end-to-end test suites with Playwright and Cypress.

## What to Test with E2E

**Good for:**

- Critical user journeys (login, checkout, signup)
- Complex interactions (drag-and-drop, multi-step forms)
- Cross-browser compatibility
- Real API integration

**Not for:**

- Unit-level logic (use unit tests)
- API contracts (use integration tests)
- Edge cases (too slow)

## Playwright Configuration

```typescript
// playwright.config.ts
export default defineConfig({
    testDir: './e2e',
    timeout: 30000,
    fullyParallel: true,
    retries: process.env.CI ? 2 : 0,
    use: {
        baseURL: 'http://localhost:3000',
        trace: 'on-first-retry',
        screenshot: 'only-on-failure',
    },
    projects: [
        { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
        { name: 'mobile', use: { ...devices['iPhone 13'] } },
    ],
});
```

## Page Object Model

```typescript
export class LoginPage {
    readonly page: Page;
    readonly emailInput: Locator;
    readonly loginButton: Locator;

    constructor(page: Page) {
        this.page = page;
        this.emailInput = page.getByLabel('Email');
        this.loginButton = page.getByRole('button', { name: 'Login' });
    }

    async login(email: string, password: string) {
        await this.emailInput.fill(email);
        await this.page.getByLabel('Password').fill(password);
        await this.loginButton.click();
    }
}
```

## Waiting Strategies

```typescript
// Bad: Fixed timeouts
await page.waitForTimeout(3000);  // Flaky!

// Good: Wait for conditions
await expect(page.getByText('Welcome')).toBeVisible();
await page.waitForURL('/dashboard');

// Wait for API response
const responsePromise = page.waitForResponse(
    r => r.url().includes('/api/users') && r.status() === 200
);
await page.click('button');
await responsePromise;
```

## Network Mocking

```typescript
test('displays error when API fails', async ({ page }) => {
    await page.route('**/api/users', route => {
        route.fulfill({
            status: 500,
            body: JSON.stringify({ error: 'Server Error' }),
        });
    });

    await page.goto('/users');
    await expect(page.getByText('Failed to load')).toBeVisible();
});
```

## Visual Regression

```typescript
test('homepage looks correct', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveScreenshot('homepage.png', {
        fullPage: true,
        maxDiffPixels: 100,
    });
});
```

## Accessibility Testing

```typescript
import AxeBuilder from '@axe-core/playwright';

test('no accessibility violations', async ({ page }) => {
    await page.goto('/');
    const results = await new AxeBuilder({ page }).analyze();
    expect(results.violations).toEqual([]);
});
```

## Best Practices

1. **Use Data Attributes**: `data-testid` for stable selectors
2. **Test User Behavior**: Click, type, see - not implementation
3. **Keep Tests Independent**: Each test runs in isolation
4. **Clean Up Test Data**: Create and destroy per test
5. **Use Page Objects**: Encapsulate page logic
6. **Optimize for Speed**: Mock when possible, parallel execution

## Bad vs Good Selectors

```typescript
// Bad
cy.get('.btn.btn-primary.submit-button').click();
cy.get('div > form > div:nth-child(2) > input').type('text');

// Good
cy.getByRole('button', { name: 'Submit' }).click();
cy.get('[data-testid="email-input"]').type('user@example.com');
```

## Debugging

```bash
# Headed mode
npx playwright test --headed

# Debug mode (step through)
npx playwright test --debug

# Trace viewer
npx playwright show-trace trace.zip
```
