---
name: React
description: This skill should be used when the user asks about "React", "React components", "React hooks", "useState", "useEffect", "JSX", "React patterns", "React best practices", or mentions React development.
version: 1.0.0
---

# React Development

Guidance for building React applications with modern patterns.

---

## Hooks Reference

### Built-in Hooks

| Hook | Purpose | When to Use |
|------|---------|-------------|
| **useState** | Local state | Simple values, toggles, form inputs |
| **useReducer** | Complex state | Multiple sub-values, state machines |
| **useEffect** | Side effects | Data fetching, subscriptions, DOM manipulation |
| **useContext** | Consume context | Theme, auth, global state |
| **useRef** | Mutable reference | DOM access, persist values across renders |
| **useMemo** | Memoize value | Expensive calculations |
| **useCallback** | Memoize function | Stable callbacks for child components |
| **useLayoutEffect** | Sync DOM effects | Measure DOM before paint |
| **useId** | Unique IDs | Accessibility, form labels |

### Hook Rules

| Rule | Why |
|------|-----|
| Only call at top level | Hooks rely on call order |
| Only call from React functions | Components or custom hooks |
| Name custom hooks with "use" | Convention for linting |

---

## Component Patterns

| Pattern | Use Case | Key Concept |
|---------|----------|-------------|
| **Presentational** | Pure UI, no logic | Props in, JSX out |
| **Container** | Data fetching, state | Wraps presentational |
| **Compound Components** | Related components sharing state | Parent provides context |
| **Render Props** | Share behavior | Function as child |
| **Custom Hooks** | Reusable stateful logic | Extract from components |
| **HOC** | Legacy pattern | Prefer hooks instead |

---

## State Management Decision

| Solution | Best For | Trade-offs |
|----------|----------|------------|
| **useState** | Component-local | Simplest, prop drilling for sharing |
| **useReducer** | Complex local state | More boilerplate, predictable |
| **Context** | Theme, auth, i18n | Re-renders all consumers |
| **Zustand** | Simple global | Minimal API, good devtools |
| **Redux Toolkit** | Complex global | Powerful, more boilerplate |
| **React Query/TanStack** | Server state | Caching, background refresh |
| **Jotai/Recoil** | Atomic state | Fine-grained updates |

**Key concept**: Server state (API data) and client state (UI state) should be managed differently. Use React Query for server state.

---

## useEffect Patterns

| Pattern | Dependency Array | Purpose |
|---------|------------------|---------|
| Run once | `[]` | Initial fetch, setup |
| Run on change | `[dep1, dep2]` | React to specific changes |
| Run every render | (omit) | Rarely needed |
| Cleanup | Return function | Subscriptions, timers |

### Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Infinite loops | Include all dependencies, use useCallback |
| Stale closures | Use refs or functional updates |
| Race conditions | Cleanup flag or AbortController |
| Missing deps | Trust the linter, refactor if needed |

---

## Performance Optimization

| Technique | When to Use | Cost |
|-----------|-------------|------|
| **React.memo** | Expensive child, frequent parent renders | Shallow comparison |
| **useMemo** | Expensive calculation | Memory for cached value |
| **useCallback** | Callback passed to memoized child | Memory for function |
| **Lazy loading** | Large components, routes | Initial load vs waterfall |
| **Virtualization** | Long lists (100+ items) | Complexity |

**Key concept**: Don't optimize prematurely. Measure first with React DevTools Profiler.

---

## Conditional Rendering

| Pattern | Use Case |
|---------|----------|
| **&&** | Show/hide single element |
| **Ternary** | Two alternatives |
| **Early return** | Multiple conditions, cleaner |
| **Switch/object map** | Many alternatives |

---

## Form Handling

| Approach | Use Case |
|----------|----------|
| **Controlled** | Need validation, formatting |
| **Uncontrolled (refs)** | Simple forms, performance |
| **React Hook Form** | Complex forms, validation |
| **Formik** | Legacy, full-featured |

**Key concept**: Controlled components store value in React state. Uncontrolled use DOM as source of truth.

---

## Project Structure

| Directory | Purpose |
|-----------|---------|
| **components/ui/** | Generic, reusable (Button, Card) |
| **components/features/** | Feature-specific compositions |
| **hooks/** | Custom hooks |
| **contexts/** | React contexts + providers |
| **pages/** or **routes/** | Route components |
| **services/** or **api/** | API calls, data fetching |
| **types/** | TypeScript types |
| **utils/** | Pure helper functions |

---

## Best Practices

| Practice | Why |
|----------|-----|
| Keep components small (<100 lines) | Readable, testable |
| Colocate related code | Easier to maintain |
| Lift state only when needed | Avoid unnecessary complexity |
| Use TypeScript for props | Catch errors, better DX |
| Prefer composition over inheritance | React's design philosophy |
| Extract custom hooks | Reusable logic, testable |

## Resources

- React Docs: <https://react.dev/>
- Patterns: <https://patterns.dev/>
