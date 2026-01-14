---
name: React
description: This skill should be used when the user asks about "React", "React components", "React hooks", "useState", "useEffect", "JSX", "React patterns", "React best practices", or mentions React development.
version: 1.0.0
---

# React Development

Guidance for building React applications with modern patterns.

## Component Patterns

### Functional Components

```tsx
// Simple component
function Greeting({ name }: { name: string }) {
  return <h1>Hello, {name}!</h1>;
}

// With children
interface CardProps {
  title: string;
  children: React.ReactNode;
}

function Card({ title, children }: CardProps) {
  return (
    <div className="card">
      <h2>{title}</h2>
      {children}
    </div>
  );
}
```

### Hooks

```tsx
// useState
const [count, setCount] = useState(0);
const [user, setUser] = useState<User | null>(null);

// useEffect
useEffect(() => {
  fetchData();
}, [dependency]);

// useEffect cleanup
useEffect(() => {
  const subscription = subscribe();
  return () => subscription.unsubscribe();
}, []);

// useMemo - expensive calculations
const sortedItems = useMemo(
  () => items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
);

// useCallback - stable function references
const handleClick = useCallback(() => {
  doSomething(id);
}, [id]);
```

### Custom Hooks

```tsx
function useLocalStorage<T>(key: string, initialValue: T) {
  const [value, setValue] = useState<T>(() => {
    const stored = localStorage.getItem(key);
    return stored ? JSON.parse(stored) : initialValue;
  });

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(value));
  }, [key, value]);

  return [value, setValue] as const;
}

// Usage
const [theme, setTheme] = useLocalStorage('theme', 'light');
```

## State Management

### Context

```tsx
interface AuthContextType {
  user: User | null;
  login: (credentials: Credentials) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);

  const login = async (credentials: Credentials) => {
    const user = await api.login(credentials);
    setUser(user);
  };

  const logout = () => setUser(null);

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
}
```

## Common Patterns

### Conditional Rendering

```tsx
// Short-circuit
{isLoggedIn && <Dashboard />}

// Ternary
{isLoading ? <Spinner /> : <Content />}

// Early return
if (isLoading) return <Spinner />;
if (error) return <Error message={error} />;
return <Content data={data} />;
```

### List Rendering

```tsx
{items.map(item => (
  <ListItem key={item.id} item={item} />
))}
```

### Event Handling

```tsx
<button onClick={() => handleClick(id)}>Click</button>
<input onChange={e => setName(e.target.value)} />
<form onSubmit={e => { e.preventDefault(); handleSubmit(); }}>
```

## Project Structure

```
src/
├── components/
│   ├── ui/           # Generic UI components
│   └── features/     # Feature-specific components
├── hooks/            # Custom hooks
├── contexts/         # React contexts
├── pages/            # Page components
├── services/         # API calls
├── types/            # TypeScript types
└── utils/            # Helper functions
```

## Best Practices

1. **Keep components small** - Extract when > 100 lines
2. **Lift state up** - Share state via common ancestor
3. **Colocate related code** - Keep styles/tests near components
4. **Use TypeScript** - Type all props and state
5. **Memoize wisely** - Only when there's a performance issue
