# Complete React.js Guide - From Zero to Hero

## Table of Contents
1. [Introduction & Setup](#introduction--setup)
2. [React Fundamentals](#react-fundamentals)
3. [Components Deep Dive](#components-deep-dive)
4. [State Management](#state-management)
5. [Hooks - Complete Guide](#hooks---complete-guide)
6. [Event Handling](#event-handling)
7. [Forms & Input Handling](#forms--input-handling)
8. [Lifecycle Methods](#lifecycle-methods)
9. [Routing](#routing)
10. [API Integration](#api-integration)
11. [Context API](#context-api)
12. [Redux & State Management](#redux--state-management)
13. [Performance Optimization](#performance-optimization)
14. [Testing React Applications](#testing-react-applications)
15. [Advanced Patterns](#advanced-patterns)
16. [Real-World Projects](#real-world-projects)
17. [Interview Questions](#interview-questions)
18. [Best Practices](#best-practices)

---

## 1. Introduction & Setup

### What is React?
React is a JavaScript library for building user interfaces, developed by Facebook. It uses a component-based architecture and virtual DOM for efficient updates.

### Why React?
- **Component-Based**: Build encapsulated components that manage their own state
- **Declarative**: Design simple views for each state in your application
- **Learn Once, Write Anywhere**: Can be used for web, mobile (React Native), and desktop apps
- **Virtual DOM**: Efficient updates and rendering
- **Large Ecosystem**: Huge community and lots of third-party libraries

### Setting Up React

#### Method 1: Create React App (CRA)
```bash
# Install Node.js first (https://nodejs.org)
npx create-react-app my-app
cd my-app
npm start
```

#### Method 2: Vite (Faster, Modern)
```bash
npm create vite@latest my-react-app -- --template react
cd my-react-app
npm install
npm run dev
```

#### Method 3: Manual Setup
```bash
mkdir my-react-app
cd my-react-app
npm init -y
npm install react react-dom
npm install --save-dev @vitejs/plugin-react vite
```

Create `vite.config.js`:
```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
```

### Project Structure
```
my-react-app/
├── node_modules/
├── public/
│   ├── index.html
│   └── favicon.ico
├── src/
│   ├── components/
│   ├── styles/
│   ├── utils/
│   ├── App.jsx
│   ├── App.css
│   └── index.js
├── package.json
└── README.md
```

---

## 2. React Fundamentals

### JSX (JavaScript XML)
JSX is a syntax extension that looks like HTML but is JavaScript.

```jsx
// JSX Example
const element = <h1>Hello, World!</h1>;

// This compiles to:
const element = React.createElement('h1', null, 'Hello, World!');

// JSX with JavaScript expressions
const name = 'John';
const greeting = <h1>Hello, {name}!</h1>;

// JSX with attributes
const link = <a href="https://reactjs.org" target="_blank">Learn React</a>;

// JSX with className (not class)
const divElement = <div className="container">Content</div>;

// Conditional rendering in JSX
const isLoggedIn = true;
const userGreeting = (
  <div>
    {isLoggedIn ? <h1>Welcome back!</h1> : <h1>Please sign up.</h1>}
  </div>
);

// JSX with inline styles
const styledDiv = (
  <div style={{ color: 'blue', fontSize: '20px' }}>
    Styled content
  </div>
);
```

### Components - The Building Blocks

#### Functional Components (Modern Approach)
```jsx
// Simple functional component
function Welcome(props) {
  return <h1>Hello, {props.name}!</h1>;
}

// Arrow function component
const Welcome = (props) => {
  return <h1>Hello, {props.name}!</h1>;
};

// With destructuring
const Welcome = ({ name, age }) => {
  return (
    <div>
      <h1>Hello, {name}!</h1>
      <p>Age: {age}</p>
    </div>
  );
};

// Usage
<Welcome name="Alice" age={25} />
```

#### Class Components (Legacy but Important to Know)
```jsx
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}!</h1>;
  }
}

// With state
class Counter extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
  }

  increment = () => {
    this.setState({ count: this.state.count + 1 });
  };

  render() {
    return (
      <div>
        <p>Count: {this.state.count}</p>
        <button onClick={this.increment}>Increment</button>
      </div>
    );
  }
}
```

### Props - Passing Data to Components

```jsx
// Parent component
function App() {
  const user = {
    name: 'John Doe',
    email: 'john@example.com',
    age: 30
  };

  return (
    <div>
      <UserCard user={user} />
      <UserCard name="Jane" email="jane@example.com" age={25} />
    </div>
  );
}

// Child component with props
function UserCard(props) {
  // If user object is passed
  if (props.user) {
    return (
      <div className="user-card">
        <h2>{props.user.name}</h2>
        <p>Email: {props.user.email}</p>
        <p>Age: {props.user.age}</p>
      </div>
    );
  }

  // If individual props are passed
  return (
    <div className="user-card">
      <h2>{props.name}</h2>
      <p>Email: {props.email}</p>
      <p>Age: {props.age}</p>
    </div>
  );
}

// Props with default values
function Button({ text = 'Click Me', color = 'blue', onClick }) {
  return (
    <button
      style={{ backgroundColor: color }}
      onClick={onClick}
    >
      {text}
    </button>
  );
}

// PropTypes for type checking
import PropTypes from 'prop-types';

UserCard.propTypes = {
  user: PropTypes.shape({
    name: PropTypes.string.isRequired,
    email: PropTypes.string.isRequired,
    age: PropTypes.number
  })
};
```

---

## 3. Components Deep Dive

### Component Composition

```jsx
// Header Component
const Header = () => (
  <header>
    <h1>My App</h1>
    <Navigation />
  </header>
);

// Navigation Component
const Navigation = () => (
  <nav>
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
      <li><a href="/contact">Contact</a></li>
    </ul>
  </nav>
);

// Layout Component (Composition)
const Layout = ({ children }) => (
  <div className="app">
    <Header />
    <main>{children}</main>
    <Footer />
  </div>
);

// Footer Component
const Footer = () => (
  <footer>
    <p>&copy; 2024 My App</p>
  </footer>
);

// Usage
function App() {
  return (
    <Layout>
      <h2>Welcome to my app!</h2>
      <p>This is the main content.</p>
    </Layout>
  );
}
```

### Component Communication

```jsx
// Parent to Child - via props
function Parent() {
  const message = "Hello from parent!";
  return <Child message={message} />;
}

function Child({ message }) {
  return <p>{message}</p>;
}

// Child to Parent - via callback functions
function Parent() {
  const [dataFromChild, setDataFromChild] = useState('');

  const handleDataFromChild = (data) => {
    setDataFromChild(data);
  };

  return (
    <div>
      <h2>Parent Component</h2>
      <p>Data from child: {dataFromChild}</p>
      <Child onSendData={handleDataFromChild} />
    </div>
  );
}

function Child({ onSendData }) {
  const sendDataToParent = () => {
    onSendData('Hello from child!');
  };

  return (
    <div>
      <h3>Child Component</h3>
      <button onClick={sendDataToParent}>Send Data to Parent</button>
    </div>
  );
}

// Sibling Communication - via parent state
function Parent() {
  const [sharedData, setSharedData] = useState('');

  return (
    <div>
      <SiblingA onDataChange={setSharedData} />
      <SiblingB data={sharedData} />
    </div>
  );
}

function SiblingA({ onDataChange }) {
  return (
    <input
      type="text"
      onChange={(e) => onDataChange(e.target.value)}
      placeholder="Type something..."
    />
  );
}

function SiblingB({ data }) {
  return <p>Sibling A typed: {data}</p>;
}
```

---

## 4. State Management

### useState Hook - Local State

```jsx
import React, { useState } from 'react';

// Simple state
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <button onClick={() => setCount(count - 1)}>Decrement</button>
      <button onClick={() => setCount(0)}>Reset</button>
    </div>
  );
}

// Object state
function UserProfile() {
  const [user, setUser] = useState({
    name: '',
    email: '',
    age: 0
  });

  const updateName = (name) => {
    setUser(prevUser => ({ ...prevUser, name }));
  };

  const updateEmail = (email) => {
    setUser(prevUser => ({ ...prevUser, email }));
  };

  return (
    <div>
      <input
        placeholder="Name"
        value={user.name}
        onChange={(e) => updateName(e.target.value)}
      />
      <input
        placeholder="Email"
        value={user.email}
        onChange={(e) => updateEmail(e.target.value)}
      />
      <p>Name: {user.name}</p>
      <p>Email: {user.email}</p>
    </div>
  );
}

// Array state
function TodoList() {
  const [todos, setTodos] = useState([]);
  const [inputValue, setInputValue] = useState('');

  const addTodo = () => {
    if (inputValue.trim()) {
      setTodos([...todos, {
        id: Date.now(),
        text: inputValue,
        completed: false
      }]);
      setInputValue('');
    }
  };

  const toggleTodo = (id) => {
    setTodos(todos.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };

  const deleteTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  return (
    <div>
      <h2>Todo List</h2>
      <div>
        <input
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && addTodo()}
        />
        <button onClick={addTodo}>Add Todo</button>
      </div>
      <ul>
        {todos.map(todo => (
          <li key={todo.id}>
            <span
              style={{
                textDecoration: todo.completed ? 'line-through' : 'none'
              }}
              onClick={() => toggleTodo(todo.id)}
            >
              {todo.text}
            </span>
            <button onClick={() => deleteTodo(todo.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

// Complex state with multiple values
function Form() {
  const [formData, setFormData] = useState({
    username: '',
    password: '',
    email: '',
    country: '',
    acceptTerms: false
  });

  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData(prevData => ({
      ...prevData,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Form submitted:', formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="username"
        value={formData.username}
        onChange={handleInputChange}
        placeholder="Username"
      />
      <input
        name="email"
        type="email"
        value={formData.email}
        onChange={handleInputChange}
        placeholder="Email"
      />
      <input
        name="password"
        type="password"
        value={formData.password}
        onChange={handleInputChange}
        placeholder="Password"
      />
      <select name="country" value={formData.country} onChange={handleInputChange}>
        <option value="">Select Country</option>
        <option value="usa">USA</option>
        <option value="uk">UK</option>
        <option value="canada">Canada</option>
      </select>
      <label>
        <input
          name="acceptTerms"
          type="checkbox"
          checked={formData.acceptTerms}
          onChange={handleInputChange}
        />
        Accept Terms
      </label>
      <button type="submit">Submit</button>
    </form>
  );
}
```

---

## 5. Hooks - Complete Guide

### useEffect - Side Effects

```jsx
import React, { useState, useEffect } from 'react';

// Basic useEffect - runs after every render
function Example1() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    console.log('Component rendered or updated');
  });

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

// useEffect with empty dependency array - runs once on mount
function Example2() {
  const [data, setData] = useState(null);

  useEffect(() => {
    console.log('Component mounted');
    // Fetch initial data
    fetchData().then(setData);
  }, []); // Empty array means run once on mount

  return <div>{data ? <p>{data}</p> : <p>Loading...</p>}</div>;
}

// useEffect with dependencies
function Example3() {
  const [count, setCount] = useState(0);
  const [name, setName] = useState('');

  useEffect(() => {
    console.log(`Count changed to: ${count}`);
  }, [count]); // Only runs when count changes

  useEffect(() => {
    console.log(`Name changed to: ${name}`);
  }, [name]); // Only runs when name changes

  return (
    <div>
      <input value={name} onChange={(e) => setName(e.target.value)} />
      <button onClick={() => setCount(count + 1)}>Count: {count}</button>
    </div>
  );
}

// useEffect with cleanup
function Timer() {
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setSeconds(prev => prev + 1);
    }, 1000);

    // Cleanup function
    return () => {
      clearInterval(interval);
      console.log('Timer cleaned up');
    };
  }, []);

  return <div>Seconds: {seconds}</div>;
}

// Real-world example: Fetching data
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let cancelled = false;

    async function fetchUser() {
      try {
        setLoading(true);
        const response = await fetch(`/api/users/${userId}`);
        if (!response.ok) throw new Error('Failed to fetch');
        const data = await response.json();

        if (!cancelled) {
          setUser(data);
          setError(null);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err.message);
          setUser(null);
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }

    fetchUser();

    // Cleanup to prevent setting state on unmounted component
    return () => {
      cancelled = true;
    };
  }, [userId]);

  if (loading) return <div>Loading user...</div>;
  if (error) return <div>Error: {error}</div>;
  if (!user) return <div>No user found</div>;

  return (
    <div>
      <h2>{user.name}</h2>
      <p>{user.email}</p>
    </div>
  );
}
```

### useContext - Global State

```jsx
import React, { createContext, useContext, useState } from 'react';

// Create a context
const ThemeContext = createContext();
const UserContext = createContext();

// Theme Provider
function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// User Provider
function UserProvider({ children }) {
  const [user, setUser] = useState(null);

  const login = (userData) => {
    setUser(userData);
  };

  const logout = () => {
    setUser(null);
  };

  return (
    <UserContext.Provider value={{ user, login, logout }}>
      {children}
    </UserContext.Provider>
  );
}

// Custom hooks for using context
function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

function useUser() {
  const context = useContext(UserContext);
  if (!context) {
    throw new Error('useUser must be used within UserProvider');
  }
  return context;
}

// Components using context
function Header() {
  const { theme, toggleTheme } = useTheme();
  const { user, logout } = useUser();

  return (
    <header style={{
      backgroundColor: theme === 'light' ? '#fff' : '#333',
      color: theme === 'light' ? '#333' : '#fff'
    }}>
      <h1>My App</h1>
      {user ? (
        <div>
          <span>Welcome, {user.name}!</span>
          <button onClick={logout}>Logout</button>
        </div>
      ) : (
        <span>Please login</span>
      )}
      <button onClick={toggleTheme}>
        Switch to {theme === 'light' ? 'dark' : 'light'} mode
      </button>
    </header>
  );
}

// App with providers
function App() {
  return (
    <ThemeProvider>
      <UserProvider>
        <Header />
        <MainContent />
      </UserProvider>
    </ThemeProvider>
  );
}
```

### useReducer - Complex State Logic

```jsx
import React, { useReducer } from 'react';

// Simple counter reducer
const counterReducer = (state, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return { count: state.count + 1 };
    case 'DECREMENT':
      return { count: state.count - 1 };
    case 'RESET':
      return { count: 0 };
    case 'SET':
      return { count: action.payload };
    default:
      return state;
  }
};

function Counter() {
  const [state, dispatch] = useReducer(counterReducer, { count: 0 });

  return (
    <div>
      <p>Count: {state.count}</p>
      <button onClick={() => dispatch({ type: 'INCREMENT' })}>+</button>
      <button onClick={() => dispatch({ type: 'DECREMENT' })}>-</button>
      <button onClick={() => dispatch({ type: 'RESET' })}>Reset</button>
      <button onClick={() => dispatch({ type: 'SET', payload: 100 })}>
        Set to 100
      </button>
    </div>
  );
}

// Complex todo reducer
const todoReducer = (state, action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        ...state,
        todos: [...state.todos, {
          id: Date.now(),
          text: action.payload,
          completed: false
        }]
      };
    case 'TOGGLE_TODO':
      return {
        ...state,
        todos: state.todos.map(todo =>
          todo.id === action.payload
            ? { ...todo, completed: !todo.completed }
            : todo
        )
      };
    case 'DELETE_TODO':
      return {
        ...state,
        todos: state.todos.filter(todo => todo.id !== action.payload)
      };
    case 'SET_FILTER':
      return {
        ...state,
        filter: action.payload
      };
    default:
      return state;
  }
};

function TodoApp() {
  const initialState = {
    todos: [],
    filter: 'all' // all, active, completed
  };

  const [state, dispatch] = useReducer(todoReducer, initialState);
  const [inputValue, setInputValue] = useState('');

  const addTodo = () => {
    if (inputValue.trim()) {
      dispatch({ type: 'ADD_TODO', payload: inputValue });
      setInputValue('');
    }
  };

  const filteredTodos = state.todos.filter(todo => {
    if (state.filter === 'active') return !todo.completed;
    if (state.filter === 'completed') return todo.completed;
    return true;
  });

  return (
    <div>
      <h2>Todo App with useReducer</h2>

      <div>
        <input
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && addTodo()}
        />
        <button onClick={addTodo}>Add Todo</button>
      </div>

      <div>
        <button onClick={() => dispatch({ type: 'SET_FILTER', payload: 'all' })}>
          All
        </button>
        <button onClick={() => dispatch({ type: 'SET_FILTER', payload: 'active' })}>
          Active
        </button>
        <button onClick={() => dispatch({ type: 'SET_FILTER', payload: 'completed' })}>
          Completed
        </button>
      </div>

      <ul>
        {filteredTodos.map(todo => (
          <li key={todo.id}>
            <span
              style={{
                textDecoration: todo.completed ? 'line-through' : 'none',
                cursor: 'pointer'
              }}
              onClick={() => dispatch({ type: 'TOGGLE_TODO', payload: todo.id })}
            >
              {todo.text}
            </span>
            <button onClick={() => dispatch({ type: 'DELETE_TODO', payload: todo.id })}>
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### Custom Hooks

```jsx
// useLocalStorage hook
function useLocalStorage(key, initialValue) {
  const [storedValue, setStoredValue] = useState(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error(error);
      return initialValue;
    }
  });

  const setValue = (value) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      console.error(error);
    }
  };

  return [storedValue, setValue];
}

// useFetch hook
function useFetch(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetch(url);
        if (!response.ok) throw new Error('Network response was not ok');
        const data = await response.json();
        setData(data);
      } catch (error) {
        setError(error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [url]);

  return { data, loading, error };
}

// useDebounce hook
function useDebounce(value, delay) {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debouncedValue;
}

// useWindowSize hook
function useWindowSize() {
  const [windowSize, setWindowSize] = useState({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  useEffect(() => {
    const handleResize = () => {
      setWindowSize({
        width: window.innerWidth,
        height: window.innerHeight,
      });
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return windowSize;
}

// Usage examples
function App() {
  // Using useLocalStorage
  const [name, setName] = useLocalStorage('name', 'Guest');

  // Using useFetch
  const { data, loading, error } = useFetch('/api/users');

  // Using useDebounce
  const [searchTerm, setSearchTerm] = useState('');
  const debouncedSearchTerm = useDebounce(searchTerm, 500);

  // Using useWindowSize
  const { width, height } = useWindowSize();

  useEffect(() => {
    if (debouncedSearchTerm) {
      // Perform search
      console.log('Searching for:', debouncedSearchTerm);
    }
  }, [debouncedSearchTerm]);

  return (
    <div>
      <input
        value={name}
        onChange={(e) => setName(e.target.value)}
        placeholder="Enter your name"
      />

      <input
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        placeholder="Search..."
      />

      <p>Window size: {width} x {height}</p>

      {loading && <p>Loading users...</p>}
      {error && <p>Error: {error.message}</p>}
      {data && <pre>{JSON.stringify(data, null, 2)}</pre>}
    </div>
  );
}
```

### Other Important Hooks

```jsx
// useMemo - Memoize expensive computations
function ExpensiveComponent({ data }) {
  const expensiveValue = useMemo(() => {
    console.log('Computing expensive value...');
    return data.reduce((acc, item) => acc + item.value, 0);
  }, [data]); // Only recompute when data changes

  return <div>Total: {expensiveValue}</div>;
}

// useCallback - Memoize functions
function ParentComponent() {
  const [count, setCount] = useState(0);
  const [otherState, setOtherState] = useState(0);

  // Without useCallback, this function is recreated on every render
  const handleClick = useCallback(() => {
    console.log('Button clicked');
    setCount(c => c + 1);
  }, []); // Function is only created once

  return (
    <div>
      <ChildComponent onClick={handleClick} />
      <button onClick={() => setOtherState(o => o + 1)}>
        Other State: {otherState}
      </button>
    </div>
  );
}

const ChildComponent = React.memo(({ onClick }) => {
  console.log('ChildComponent rendered');
  return <button onClick={onClick}>Click me</button>;
});

// useRef - Access DOM elements and persist values
function FormWithFocus() {
  const inputRef = useRef(null);
  const renderCount = useRef(0);

  useEffect(() => {
    renderCount.current += 1;
  });

  const focusInput = () => {
    inputRef.current.focus();
  };

  return (
    <div>
      <p>Render count: {renderCount.current}</p>
      <input ref={inputRef} type="text" />
      <button onClick={focusInput}>Focus Input</button>
    </div>
  );
}

// useLayoutEffect - Synchronous version of useEffect
function LayoutEffectExample() {
  const [value, setValue] = useState(0);
  const divRef = useRef(null);

  useLayoutEffect(() => {
    // This runs synchronously after DOM mutations
    if (divRef.current) {
      divRef.current.style.transform = `translateX(${value * 10}px)`;
    }
  }, [value]);

  return (
    <div>
      <div ref={divRef}>Animated div</div>
      <button onClick={() => setValue(v => v + 1)}>Move</button>
    </div>
  );
}

// useImperativeHandle - Customize instance value exposed to parent
const FancyInput = React.forwardRef((props, ref) => {
  const inputRef = useRef();

  useImperativeHandle(ref, () => ({
    focus: () => {
      inputRef.current.focus();
    },
    clear: () => {
      inputRef.current.value = '';
    },
    getValue: () => {
      return inputRef.current.value;
    }
  }));

  return <input ref={inputRef} {...props} />;
});

function ParentOfFancyInput() {
  const inputRef = useRef();

  return (
    <div>
      <FancyInput ref={inputRef} />
      <button onClick={() => inputRef.current.focus()}>Focus</button>
      <button onClick={() => inputRef.current.clear()}>Clear</button>
      <button onClick={() => console.log(inputRef.current.getValue())}>
        Get Value
      </button>
    </div>
  );
}
```

---

## 6. Event Handling

### Basic Event Handling

```jsx
// Click Events
function ButtonExample() {
  const handleClick = () => {
    alert('Button clicked!');
  };

  const handleClickWithParam = (message) => {
    alert(message);
  };

  return (
    <div>
      <button onClick={handleClick}>Click me</button>
      <button onClick={() => handleClickWithParam('Hello!')}>
        Click with param
      </button>
      <button onClick={(e) => {
        e.preventDefault();
        console.log('Event object:', e);
      }}>
        Click with event
      </button>
    </div>
  );
}

// Input Events
function InputExample() {
  const [value, setValue] = useState('');

  const handleChange = (e) => {
    setValue(e.target.value);
  };

  const handleFocus = () => {
    console.log('Input focused');
  };

  const handleBlur = () => {
    console.log('Input blurred');
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      console.log('Enter pressed:', value);
    }
  };

  return (
    <div>
      <input
        value={value}
        onChange={handleChange}
        onFocus={handleFocus}
        onBlur={handleBlur}
        onKeyPress={handleKeyPress}
        placeholder="Type something..."
      />
      <p>You typed: {value}</p>
    </div>
  );
}

// Mouse Events
function MouseExample() {
  const [position, setPosition] = useState({ x: 0, y: 0 });
  const [isHovered, setIsHovered] = useState(false);

  const handleMouseMove = (e) => {
    setPosition({ x: e.clientX, y: e.clientY });
  };

  return (
    <div
      style={{
        height: '200px',
        backgroundColor: isHovered ? 'lightblue' : 'lightgray',
        position: 'relative'
      }}
      onMouseMove={handleMouseMove}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <p>Mouse position: X: {position.x}, Y: {position.y}</p>
      <p>Hovered: {isHovered ? 'Yes' : 'No'}</p>
    </div>
  );
}

// Form Events
function FormExample() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: ''
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Form submitted:', formData);
    // Send data to server
  };

  const handleReset = () => {
    setFormData({
      name: '',
      email: '',
      message: ''
    });
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  return (
    <form onSubmit={handleSubmit} onReset={handleReset}>
      <input
        name="name"
        value={formData.name}
        onChange={handleChange}
        placeholder="Name"
        required
      />
      <input
        name="email"
        type="email"
        value={formData.email}
        onChange={handleChange}
        placeholder="Email"
        required
      />
      <textarea
        name="message"
        value={formData.message}
        onChange={handleChange}
        placeholder="Message"
        required
      />
      <button type="submit">Submit</button>
      <button type="reset">Reset</button>
    </form>
  );
}
```

### Advanced Event Patterns

```jsx
// Event Delegation
function ListWithDelegation() {
  const [items, setItems] = useState(['Item 1', 'Item 2', 'Item 3']);

  const handleListClick = (e) => {
    // Check if clicked element is a button
    if (e.target.tagName === 'BUTTON') {
      const index = parseInt(e.target.dataset.index);
      console.log(`Clicked item ${index}: ${items[index]}`);
    }
  };

  return (
    <ul onClick={handleListClick}>
      {items.map((item, index) => (
        <li key={index}>
          {item}
          <button data-index={index}>Click</button>
        </li>
      ))}
    </ul>
  );
}

// Preventing Default and Stopping Propagation
function EventPropagationExample() {
  const handleOuterClick = () => {
    console.log('Outer div clicked');
  };

  const handleInnerClick = (e) => {
    e.stopPropagation(); // Prevents event from bubbling up
    console.log('Inner div clicked');
  };

  const handleLinkClick = (e) => {
    e.preventDefault(); // Prevents default link behavior
    console.log('Link clicked but not followed');
  };

  return (
    <div onClick={handleOuterClick} style={{ padding: '50px', backgroundColor: 'lightgray' }}>
      <div onClick={handleInnerClick} style={{ padding: '20px', backgroundColor: 'white' }}>
        <a href="https://example.com" onClick={handleLinkClick}>
          Click me (prevented)
        </a>
      </div>
    </div>
  );
}

// Synthetic Events
function SyntheticEventExample() {
  const handleEvent = (e) => {
    console.log('Event type:', e.type);
    console.log('Target:', e.target);
    console.log('Current target:', e.currentTarget);
    console.log('Native event:', e.nativeEvent);

    // Async access to event properties
    const eventType = e.type; // Save before async
    setTimeout(() => {
      console.log('Event type after timeout:', eventType);
      // e.type would be null here without saving
    }, 1000);
  };

  return (
    <button
      onClick={handleEvent}
      onMouseEnter={handleEvent}
      onMouseLeave={handleEvent}
    >
      Hover or Click me
    </button>
  );
}
```

---

## 7. Forms & Input Handling

### Controlled Components

```jsx
// Single Input Control
function ControlledInput() {
  const [value, setValue] = useState('');

  return (
    <div>
      <input
        type="text"
        value={value}
        onChange={(e) => setValue(e.target.value)}
      />
      <p>Value: {value}</p>
    </div>
  );
}

// Complete Form with Validation
function RegistrationForm() {
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: '',
    confirmPassword: '',
    age: '',
    country: '',
    gender: '',
    hobbies: [],
    newsletter: false,
    terms: false
  });

  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});

  const countries = ['USA', 'UK', 'Canada', 'Australia'];
  const hobbiesOptions = ['Reading', 'Gaming', 'Traveling', 'Cooking'];

  const validate = () => {
    const newErrors = {};

    if (!formData.username) {
      newErrors.username = 'Username is required';
    } else if (formData.username.length < 3) {
      newErrors.username = 'Username must be at least 3 characters';
    }

    if (!formData.email) {
      newErrors.email = 'Email is required';
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = 'Email is invalid';
    }

    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (formData.password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match';
    }

    if (!formData.age || formData.age < 18) {
      newErrors.age = 'You must be at least 18 years old';
    }

    if (!formData.country) {
      newErrors.country = 'Please select a country';
    }

    if (!formData.terms) {
      newErrors.terms = 'You must accept the terms';
    }

    return newErrors;
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;

    if (type === 'checkbox' && name === 'hobbies') {
      setFormData(prev => ({
        ...prev,
        hobbies: checked
          ? [...prev.hobbies, value]
          : prev.hobbies.filter(h => h !== value)
      }));
    } else {
      setFormData(prev => ({
        ...prev,
        [name]: type === 'checkbox' ? checked : value
      }));
    }
  };

  const handleBlur = (e) => {
    const { name } = e.target;
    setTouched(prev => ({ ...prev, [name]: true }));

    const newErrors = validate();
    setErrors(newErrors);
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    const newErrors = validate();
    setErrors(newErrors);

    if (Object.keys(newErrors).length === 0) {
      console.log('Form submitted:', formData);
      // Submit to server
    } else {
      setTouched(
        Object.keys(formData).reduce((acc, key) => {
          acc[key] = true;
          return acc;
        }, {})
      );
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <input
          name="username"
          value={formData.username}
          onChange={handleChange}
          onBlur={handleBlur}
          placeholder="Username"
        />
        {touched.username && errors.username && (
          <span style={{ color: 'red' }}>{errors.username}</span>
        )}
      </div>

      <div>
        <input
          name="email"
          type="email"
          value={formData.email}
          onChange={handleChange}
          onBlur={handleBlur}
          placeholder="Email"
        />
        {touched.email && errors.email && (
          <span style={{ color: 'red' }}>{errors.email}</span>
        )}
      </div>

      <div>
        <input
          name="password"
          type="password"
          value={formData.password}
          onChange={handleChange}
          onBlur={handleBlur}
          placeholder="Password"
        />
        {touched.password && errors.password && (
          <span style={{ color: 'red' }}>{errors.password}</span>
        )}
      </div>

      <div>
        <input
          name="confirmPassword"
          type="password"
          value={formData.confirmPassword}
          onChange={handleChange}
          onBlur={handleBlur}
          placeholder="Confirm Password"
        />
        {touched.confirmPassword && errors.confirmPassword && (
          <span style={{ color: 'red' }}>{errors.confirmPassword}</span>
        )}
      </div>

      <div>
        <input
          name="age"
          type="number"
          value={formData.age}
          onChange={handleChange}
          onBlur={handleBlur}
          placeholder="Age"
        />
        {touched.age && errors.age && (
          <span style={{ color: 'red' }}>{errors.age}</span>
        )}
      </div>

      <div>
        <select
          name="country"
          value={formData.country}
          onChange={handleChange}
          onBlur={handleBlur}
        >
          <option value="">Select Country</option>
          {countries.map(country => (
            <option key={country} value={country}>{country}</option>
          ))}
        </select>
        {touched.country && errors.country && (
          <span style={{ color: 'red' }}>{errors.country}</span>
        )}
      </div>

      <div>
        <label>
          <input
            type="radio"
            name="gender"
            value="male"
            checked={formData.gender === 'male'}
            onChange={handleChange}
          />
          Male
        </label>
        <label>
          <input
            type="radio"
            name="gender"
            value="female"
            checked={formData.gender === 'female'}
            onChange={handleChange}
          />
          Female
        </label>
      </div>

      <div>
        <p>Hobbies:</p>
        {hobbiesOptions.map(hobby => (
          <label key={hobby}>
            <input
              type="checkbox"
              name="hobbies"
              value={hobby}
              checked={formData.hobbies.includes(hobby)}
              onChange={handleChange}
            />
            {hobby}
          </label>
        ))}
      </div>

      <div>
        <label>
          <input
            type="checkbox"
            name="newsletter"
            checked={formData.newsletter}
            onChange={handleChange}
          />
          Subscribe to newsletter
        </label>
      </div>

      <div>
        <label>
          <input
            type="checkbox"
            name="terms"
            checked={formData.terms}
            onChange={handleChange}
          />
          I accept the terms and conditions
        </label>
        {touched.terms && errors.terms && (
          <span style={{ color: 'red' }}>{errors.terms}</span>
        )}
      </div>

      <button type="submit">Register</button>
    </form>
  );
}
```

### Uncontrolled Components with Refs

```jsx
function UncontrolledForm() {
  const nameRef = useRef();
  const emailRef = useRef();
  const fileRef = useRef();

  const handleSubmit = (e) => {
    e.preventDefault();

    const formData = {
      name: nameRef.current.value,
      email: emailRef.current.value,
      file: fileRef.current.files[0]
    };

    console.log('Form data:', formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input ref={nameRef} type="text" placeholder="Name" />
      <input ref={emailRef} type="email" placeholder="Email" />
      <input ref={fileRef} type="file" />
      <button type="submit">Submit</button>
    </form>
  );
}
```

### Form Libraries Integration (Formik Example)

```jsx
import { Formik, Form, Field, ErrorMessage } from 'formik';
import * as Yup from 'yup';

const SignupSchema = Yup.object().shape({
  firstName: Yup.string()
    .min(2, 'Too Short!')
    .max(50, 'Too Long!')
    .required('Required'),
  lastName: Yup.string()
    .min(2, 'Too Short!')
    .max(50, 'Too Long!')
    .required('Required'),
  email: Yup.string()
    .email('Invalid email')
    .required('Required'),
  password: Yup.string()
    .min(6, 'Password too short')
    .required('Required')
});

function FormikExample() {
  return (
    <Formik
      initialValues={{
        firstName: '',
        lastName: '',
        email: '',
        password: ''
      }}
      validationSchema={SignupSchema}
      onSubmit={(values, { setSubmitting }) => {
        setTimeout(() => {
          console.log(JSON.stringify(values, null, 2));
          setSubmitting(false);
        }, 400);
      }}
    >
      {({ isSubmitting, errors, touched }) => (
        <Form>
          <Field type="text" name="firstName" placeholder="First Name" />
          <ErrorMessage name="firstName" component="div" />

          <Field type="text" name="lastName" placeholder="Last Name" />
          <ErrorMessage name="lastName" component="div" />

          <Field type="email" name="email" placeholder="Email" />
          <ErrorMessage name="email" component="div" />

          <Field type="password" name="password" placeholder="Password" />
          <ErrorMessage name="password" component="div" />

          <button type="submit" disabled={isSubmitting}>
            Submit
          </button>
        </Form>
      )}
    </Formik>
  );
}
```

---

## 8. Lifecycle Methods

### Class Component Lifecycle

```jsx
class LifecycleComponent extends React.Component {
  constructor(props) {
    super(props);
    console.log('1. Constructor');
    this.state = {
      count: 0,
      data: null
    };
  }

  static getDerivedStateFromProps(props, state) {
    console.log('2. getDerivedStateFromProps');
    // Return new state based on props, or null
    return null;
  }

  componentDidMount() {
    console.log('3. componentDidMount');
    // API calls, subscriptions, timers
    this.fetchData();
    this.timer = setInterval(() => {
      this.setState(prev => ({ count: prev.count + 1 }));
    }, 1000);
  }

  shouldComponentUpdate(nextProps, nextState) {
    console.log('4. shouldComponentUpdate');
    // Return true to update, false to prevent update
    return true;
  }

  getSnapshotBeforeUpdate(prevProps, prevState) {
    console.log('5. getSnapshotBeforeUpdate');
    // Capture some information from the DOM
    return null;
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    console.log('6. componentDidUpdate');
    // Operate on the DOM or make network requests
    if (prevState.count !== this.state.count) {
      console.log('Count changed:', this.state.count);
    }
  }

  componentWillUnmount() {
    console.log('7. componentWillUnmount');
    // Cleanup: cancel subscriptions, timers, etc.
    clearInterval(this.timer);
  }

  fetchData = async () => {
    const response = await fetch('/api/data');
    const data = await response.json();
    this.setState({ data });
  };

  render() {
    console.log('Render');
    return (
      <div>
        <h2>Lifecycle Component</h2>
        <p>Count: {this.state.count}</p>
        {this.state.data && <pre>{JSON.stringify(this.state.data)}</pre>}
      </div>
    );
  }
}
```

### Functional Component Lifecycle with Hooks

```jsx
function FunctionalLifecycle() {
  const [count, setCount] = useState(0);
  const [data, setData] = useState(null);

  // ComponentDidMount & ComponentDidUpdate
  useEffect(() => {
    console.log('Component mounted or updated');

    // ComponentDidMount logic
    fetchData();
    const timer = setInterval(() => {
      setCount(c => c + 1);
    }, 1000);

    // ComponentWillUnmount
    return () => {
      console.log('Cleanup');
      clearInterval(timer);
    };
  }, []); // Empty array = componentDidMount only

  // ComponentDidUpdate for specific state
  useEffect(() => {
    console.log('Count updated:', count);
  }, [count]);

  const fetchData = async () => {
    const response = await fetch('/api/data');
    const data = await response.json();
    setData(data);
  };

  return (
    <div>
      <h2>Functional Lifecycle</h2>
      <p>Count: {count}</p>
      {data && <pre>{JSON.stringify(data)}</pre>}
    </div>
  );
}
```

---

## 9. Routing

### React Router Setup

```bash
npm install react-router-dom
```

### Basic Routing

```jsx
import {
  BrowserRouter,
  Routes,
  Route,
  Link,
  NavLink,
  Outlet,
  useNavigate,
  useLocation,
  useParams
} from 'react-router-dom';

// App with Routing
function App() {
  return (
    <BrowserRouter>
      <div>
        <Navigation />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/users" element={<Users />}>
            <Route index element={<UsersList />} />
            <Route path=":userId" element={<UserDetail />} />
            <Route path="new" element={<NewUser />} />
          </Route>
          <Route path="/products/:id" element={<Product />} />
          <Route path="/dashboard/*" element={<Dashboard />} />
          <Route path="*" element={<NotFound />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

// Navigation Component
function Navigation() {
  return (
    <nav>
      <ul>
        <li><Link to="/">Home</Link></li>
        <li><Link to="/about">About</Link></li>
        <li><NavLink to="/users" className={({ isActive }) => isActive ? 'active' : ''}>
          Users
        </NavLink></li>
      </ul>
    </nav>
  );
}

// Home Component
function Home() {
  const navigate = useNavigate();

  const goToAbout = () => {
    navigate('/about');
  };

  return (
    <div>
      <h1>Home Page</h1>
      <button onClick={goToAbout}>Go to About</button>
    </div>
  );
}

// Users Component with Nested Routes
function Users() {
  return (
    <div>
      <h1>Users</h1>
      <nav>
        <Link to="/users">All Users</Link>
        <Link to="/users/new">New User</Link>
      </nav>
      <Outlet /> {/* Renders nested routes */}
    </div>
  );
}

// UserDetail Component with Params
function UserDetail() {
  const { userId } = useParams();
  const location = useLocation();
  const navigate = useNavigate();

  return (
    <div>
      <h2>User Detail</h2>
      <p>User ID: {userId}</p>
      <p>Current Path: {location.pathname}</p>
      <button onClick={() => navigate(-1)}>Go Back</button>
    </div>
  );
}
```

### Protected Routes

```jsx
import { Navigate } from 'react-router-dom';

// Protected Route Component
function ProtectedRoute({ children }) {
  const isAuthenticated = checkAuth(); // Your auth check logic

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  return children;
}

// Usage in Routes
function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />
        <Route
          path="/profile"
          element={
            <ProtectedRoute>
              <Profile />
            </ProtectedRoute>
          }
        />
      </Routes>
    </BrowserRouter>
  );
}
```

### Route with Query Parameters

```jsx
import { useSearchParams } from 'react-router-dom';

function SearchPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const query = searchParams.get('q');
  const category = searchParams.get('category');

  const updateSearch = (newQuery) => {
    setSearchParams({ q: newQuery, category: category || 'all' });
  };

  return (
    <div>
      <h1>Search Page</h1>
      <p>Query: {query}</p>
      <p>Category: {category}</p>
      <input
        type="text"
        value={query || ''}
        onChange={(e) => updateSearch(e.target.value)}
      />
    </div>
  );
}
```

---

## 10. API Integration

### Fetch API

```jsx
// GET Request
function UsersList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const response = await fetch('https://jsonplaceholder.typicode.com/users');

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      setUsers(data);
    } catch (error) {
      setError(error.message);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

// POST Request
function CreateUser() {
  const [formData, setFormData] = useState({ name: '', email: '' });
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await fetch('https://jsonplaceholder.typicode.com/users', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      const data = await response.json();
      console.log('User created:', data);
      setFormData({ name: '', email: '' }); // Reset form
    } catch (error) {
      console.error('Error:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        value={formData.name}
        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
        placeholder="Name"
      />
      <input
        value={formData.email}
        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        placeholder="Email"
      />
      <button type="submit" disabled={loading}>
        {loading ? 'Creating...' : 'Create User'}
      </button>
    </form>
  );
}

// PUT/PATCH Request
function UpdateUser({ userId }) {
  const updateUser = async (updates) => {
    try {
      const response = await fetch(`https://jsonplaceholder.typicode.com/users/${userId}`, {
        method: 'PATCH', // or 'PUT' for full replacement
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updates)
      });

      const data = await response.json();
      console.log('User updated:', data);
    } catch (error) {
      console.error('Error:', error);
    }
  };

  return (
    <button onClick={() => updateUser({ name: 'New Name' })}>
      Update User
    </button>
  );
}

// DELETE Request
function DeleteUser({ userId, onDelete }) {
  const deleteUser = async () => {
    try {
      const response = await fetch(`https://jsonplaceholder.typicode.com/users/${userId}`, {
        method: 'DELETE'
      });

      if (response.ok) {
        console.log('User deleted');
        onDelete(userId);
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };

  return <button onClick={deleteUser}>Delete User</button>;
}
```

### Axios Integration

```bash
npm install axios
```

```jsx
import axios from 'axios';

// Axios instance with base configuration
const api = axios.create({
  baseURL: 'https://jsonplaceholder.typicode.com',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Request interceptor
api.interceptors.request.use(
  config => {
    // Add auth token if available
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  error => Promise.reject(error)
);

// Response interceptor
api.interceptors.response.use(
  response => response,
  error => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// API Service
const userService = {
  getAll: () => api.get('/users'),
  getById: (id) => api.get(`/users/${id}`),
  create: (data) => api.post('/users', data),
  update: (id, data) => api.put(`/users/${id}`, data),
  delete: (id) => api.delete(`/users/${id}`)
};

// Component using Axios
function AxiosExample() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    setLoading(true);
    try {
      const response = await userService.getAll();
      setUsers(response.data);
    } catch (error) {
      console.error('Error loading users:', error);
    } finally {
      setLoading(false);
    }
  };

  const createUser = async (userData) => {
    try {
      const response = await userService.create(userData);
      setUsers([...users, response.data]);
    } catch (error) {
      console.error('Error creating user:', error);
    }
  };

  const deleteUser = async (id) => {
    try {
      await userService.delete(id);
      setUsers(users.filter(user => user.id !== id));
    } catch (error) {
      console.error('Error deleting user:', error);
    }
  };

  return (
    <div>
      {loading ? (
        <p>Loading...</p>
      ) : (
        <ul>
          {users.map(user => (
            <li key={user.id}>
              {user.name}
              <button onClick={() => deleteUser(user.id)}>Delete</button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
```

---

## 11. Context API

### Creating and Using Context

```jsx
import React, { createContext, useContext, useState, useEffect } from 'react';

// Auth Context Example
const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check if user is logged in
    const token = localStorage.getItem('token');
    if (token) {
      // Verify token and get user data
      verifyToken(token).then(userData => {
        setUser(userData);
        setLoading(false);
      });
    } else {
      setLoading(false);
    }
  }, []);

  const login = async (email, password) => {
    try {
      const response = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password })
      });

      const data = await response.json();

      if (response.ok) {
        localStorage.setItem('token', data.token);
        setUser(data.user);
        return { success: true };
      } else {
        return { success: false, error: data.message };
      }
    } catch (error) {
      return { success: false, error: error.message };
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
  };

  const value = {
    user,
    login,
    logout,
    loading,
    isAuthenticated: !!user
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}

// Custom hook for using auth context
export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
}

// Theme Context Example
const ThemeContext = createContext();

export function ThemeProvider({ children }) {
  const [theme, setTheme] = useState(() => {
    return localStorage.getItem('theme') || 'light';
  });

  useEffect(() => {
    localStorage.setItem('theme', theme);
    document.body.className = theme;
  }, [theme]);

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

// Shopping Cart Context
const CartContext = createContext();

export function CartProvider({ children }) {
  const [items, setItems] = useState([]);

  const addItem = (product) => {
    setItems(prevItems => {
      const existingItem = prevItems.find(item => item.id === product.id);

      if (existingItem) {
        return prevItems.map(item =>
          item.id === product.id
            ? { ...item, quantity: item.quantity + 1 }
            : item
        );
      }

      return [...prevItems, { ...product, quantity: 1 }];
    });
  };

  const removeItem = (productId) => {
    setItems(prevItems => prevItems.filter(item => item.id !== productId));
  };

  const updateQuantity = (productId, quantity) => {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    setItems(prevItems =>
      prevItems.map(item =>
        item.id === productId ? { ...item, quantity } : item
      )
    );
  };

  const clearCart = () => {
    setItems([]);
  };

  const totalPrice = items.reduce(
    (total, item) => total + (item.price * item.quantity),
    0
  );

  const itemCount = items.reduce(
    (count, item) => count + item.quantity,
    0
  );

  return (
    <CartContext.Provider value={{
      items,
      addItem,
      removeItem,
      updateQuantity,
      clearCart,
      totalPrice,
      itemCount
    }}>
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error('useCart must be used within CartProvider');
  }
  return context;
}

// App using multiple contexts
function App() {
  return (
    <AuthProvider>
      <ThemeProvider>
        <CartProvider>
          <Router>
            <Layout />
          </Router>
        </CartProvider>
      </ThemeProvider>
    </AuthProvider>
  );
}

// Components using contexts
function Header() {
  const { user, logout } = useAuth();
  const { theme, toggleTheme } = useTheme();
  const { itemCount } = useCart();

  return (
    <header className={`header-${theme}`}>
      <h1>My Shop</h1>
      {user ? (
        <div>
          <span>Welcome, {user.name}!</span>
          <button onClick={logout}>Logout</button>
        </div>
      ) : (
        <Link to="/login">Login</Link>
      )}
      <button onClick={toggleTheme}>
        {theme === 'light' ? '🌙' : '☀️'}
      </button>
      <Link to="/cart">Cart ({itemCount})</Link>
    </header>
  );
}

function ProductList() {
  const { addItem } = useCart();
  const products = [
    { id: 1, name: 'Product 1', price: 29.99 },
    { id: 2, name: 'Product 2', price: 39.99 },
    { id: 3, name: 'Product 3', price: 49.99 }
  ];

  return (
    <div>
      {products.map(product => (
        <div key={product.id}>
          <h3>{product.name}</h3>
          <p>${product.price}</p>
          <button onClick={() => addItem(product)}>
            Add to Cart
          </button>
        </div>
      ))}
    </div>
  );
}

function Cart() {
  const { items, removeItem, updateQuantity, totalPrice, clearCart } = useCart();

  if (items.length === 0) {
    return <p>Your cart is empty</p>;
  }

  return (
    <div>
      <h2>Shopping Cart</h2>
      {items.map(item => (
        <div key={item.id}>
          <h3>{item.name}</h3>
          <p>${item.price}</p>
          <input
            type="number"
            value={item.quantity}
            onChange={(e) => updateQuantity(item.id, parseInt(e.target.value))}
          />
          <button onClick={() => removeItem(item.id)}>Remove</button>
        </div>
      ))}
      <p>Total: ${totalPrice.toFixed(2)}</p>
      <button onClick={clearCart}>Clear Cart</button>
    </div>
  );
}
```

---

## 12. Redux & State Management

### Redux Setup

```bash
npm install @reduxjs/toolkit react-redux
```

### Redux Toolkit (Modern Approach)

```jsx
// store.js
import { configureStore } from '@reduxjs/toolkit';
import counterReducer from './features/counter/counterSlice';
import todosReducer from './features/todos/todosSlice';
import userReducer from './features/user/userSlice';

export const store = configureStore({
  reducer: {
    counter: counterReducer,
    todos: todosReducer,
    user: userReducer
  }
});

// counterSlice.js
import { createSlice } from '@reduxjs/toolkit';

const counterSlice = createSlice({
  name: 'counter',
  initialState: {
    value: 0
  },
  reducers: {
    increment: (state) => {
      state.value += 1;
    },
    decrement: (state) => {
      state.value -= 1;
    },
    incrementByAmount: (state, action) => {
      state.value += action.payload;
    }
  }
});

export const { increment, decrement, incrementByAmount } = counterSlice.actions;
export default counterSlice.reducer;

// todosSlice.js
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

// Async thunk for fetching todos
export const fetchTodos = createAsyncThunk(
  'todos/fetchTodos',
  async () => {
    const response = await fetch('https://jsonplaceholder.typicode.com/todos');
    return response.json();
  }
);

const todosSlice = createSlice({
  name: 'todos',
  initialState: {
    items: [],
    status: 'idle', // idle | loading | succeeded | failed
    error: null
  },
  reducers: {
    addTodo: (state, action) => {
      state.items.push({
        id: Date.now(),
        text: action.payload,
        completed: false
      });
    },
    toggleTodo: (state, action) => {
      const todo = state.items.find(todo => todo.id === action.payload);
      if (todo) {
        todo.completed = !todo.completed;
      }
    },
    deleteTodo: (state, action) => {
      state.items = state.items.filter(todo => todo.id !== action.payload);
    }
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchTodos.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(fetchTodos.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.items = action.payload;
      })
      .addCase(fetchTodos.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error.message;
      });
  }
});

export const { addTodo, toggleTodo, deleteTodo } = todosSlice.actions;
export default todosSlice.reducer;

// App.jsx
import { Provider } from 'react-redux';
import { store } from './store';

function App() {
  return (
    <Provider store={store}>
      <Counter />
      <TodoList />
    </Provider>
  );
}

// Counter Component
import { useSelector, useDispatch } from 'react-redux';
import { increment, decrement, incrementByAmount } from './counterSlice';

function Counter() {
  const count = useSelector((state) => state.counter.value);
  const dispatch = useDispatch();

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => dispatch(increment())}>+</button>
      <button onClick={() => dispatch(decrement())}>-</button>
      <button onClick={() => dispatch(incrementByAmount(5))}>+5</button>
    </div>
  );
}

// TodoList Component
import { useSelector, useDispatch } from 'react-redux';
import { addTodo, toggleTodo, deleteTodo, fetchTodos } from './todosSlice';

function TodoList() {
  const { items, status, error } = useSelector((state) => state.todos);
  const dispatch = useDispatch();
  const [input, setInput] = useState('');

  useEffect(() => {
    if (status === 'idle') {
      dispatch(fetchTodos());
    }
  }, [status, dispatch]);

  const handleAddTodo = () => {
    if (input.trim()) {
      dispatch(addTodo(input));
      setInput('');
    }
  };

  if (status === 'loading') return <p>Loading...</p>;
  if (status === 'failed') return <p>Error: {error}</p>;

  return (
    <div>
      <input
        value={input}
        onChange={(e) => setInput(e.target.value)}
      />
      <button onClick={handleAddTodo}>Add Todo</button>

      <ul>
        {items.map(todo => (
          <li key={todo.id}>
            <span
              onClick={() => dispatch(toggleTodo(todo.id))}
              style={{
                textDecoration: todo.completed ? 'line-through' : 'none'
              }}
            >
              {todo.text || todo.title}
            </span>
            <button onClick={() => dispatch(deleteTodo(todo.id))}>
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

---

## 13. Performance Optimization

### React.memo - Prevent Unnecessary Re-renders

```jsx
// Without React.memo - rerenders on every parent render
function ExpensiveComponent({ data }) {
  console.log('ExpensiveComponent rendered');
  return <div>{/* Complex rendering */}</div>;
}

// With React.memo - only rerenders when props change
const OptimizedComponent = React.memo(function ExpensiveComponent({ data }) {
  console.log('OptimizedComponent rendered');
  return <div>{/* Complex rendering */}</div>;
});

// Custom comparison function
const OptimizedWithCustomCompare = React.memo(
  function Component({ user, settings }) {
    return <div>{user.name}</div>;
  },
  (prevProps, nextProps) => {
    // Return true if props are equal (skip re-render)
    // Return false if props are different (re-render)
    return prevProps.user.id === nextProps.user.id;
  }
);
```

### useMemo & useCallback

```jsx
function PerformanceExample() {
  const [count, setCount] = useState(0);
  const [input, setInput] = useState('');
  const [data, setData] = useState([1, 2, 3, 4, 5]);

  // Expensive calculation - recalculated on every render
  const expensiveValue = data.reduce((acc, val) => {
    console.log('Calculating expensive value...');
    return acc + val * 1000;
  }, 0);

  // Optimized with useMemo - only recalculated when data changes
  const memoizedValue = useMemo(() => {
    console.log('Calculating memoized value...');
    return data.reduce((acc, val) => acc + val * 1000, 0);
  }, [data]);

  // Function recreated on every render
  const handleClick = () => {
    console.log('Button clicked');
    setCount(count + 1);
  };

  // Optimized with useCallback - function only recreated when dependencies change
  const memoizedHandleClick = useCallback(() => {
    console.log('Button clicked');
    setCount(c => c + 1); // Use function form to avoid dependency on count
  }, []); // Empty array means function is created only once

  return (
    <div>
      <p>Count: {count}</p>
      <p>Expensive Value: {expensiveValue}</p>
      <p>Memoized Value: {memoizedValue}</p>

      <ChildComponent onClick={memoizedHandleClick} />

      <input
        value={input}
        onChange={(e) => setInput(e.target.value)}
        placeholder="This won't trigger expensive calculation"
      />
    </div>
  );
}

const ChildComponent = React.memo(({ onClick }) => {
  console.log('ChildComponent rendered');
  return <button onClick={onClick}>Click me</button>;
});
```

### Code Splitting & Lazy Loading

```jsx
import React, { lazy, Suspense } from 'react';

// Lazy load components
const HeavyComponent = lazy(() => import('./HeavyComponent'));
const Dashboard = lazy(() => import('./Dashboard'));

// With loading fallback
function App() {
  const [showHeavy, setShowHeavy] = useState(false);

  return (
    <div>
      <button onClick={() => setShowHeavy(true)}>
        Load Heavy Component
      </button>

      {showHeavy && (
        <Suspense fallback={<div>Loading Heavy Component...</div>}>
          <HeavyComponent />
        </Suspense>
      )}

      <Suspense fallback={<LoadingSpinner />}>
        <Routes>
          <Route path="/dashboard" element={<Dashboard />} />
        </Routes>
      </Suspense>
    </div>
  );
}

// Error Boundary for lazy loading
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <h2>Something went wrong loading this component.</h2>;
    }

    return this.props.children;
  }
}

// Usage
function AppWithErrorBoundary() {
  return (
    <ErrorBoundary>
      <Suspense fallback={<div>Loading...</div>}>
        <HeavyComponent />
      </Suspense>
    </ErrorBoundary>
  );
}
```

### Virtualization for Long Lists

```bash
npm install react-window
```

```jsx
import { FixedSizeList } from 'react-window';

function VirtualizedList({ items }) {
  const Row = ({ index, style }) => (
    <div style={style}>
      Item {index}: {items[index]}
    </div>
  );

  return (
    <FixedSizeList
      height={600}
      itemCount={items.length}
      itemSize={35}
      width='100%'
    >
      {Row}
    </FixedSizeList>
  );
}
```

---

## 14. Testing React Applications

### Jest & React Testing Library

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom @testing-library/user-event
```

```jsx
// Component to test
function LoginForm({ onLogin }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!email || !password) {
      setError('Please fill in all fields');
      return;
    }

    if (!email.includes('@')) {
      setError('Invalid email');
      return;
    }

    onLogin({ email, password });
  };

  return (
    <form onSubmit={handleSubmit}>
      {error && <div role="alert">{error}</div>}

      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        aria-label="Email"
      />

      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        aria-label="Password"
      />

      <button type="submit">Login</button>
    </form>
  );
}

// Tests
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import '@testing-library/jest-dom';

describe('LoginForm', () => {
  it('renders login form', () => {
    render(<LoginForm onLogin={() => {}} />);

    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /login/i })).toBeInTheDocument();
  });

  it('shows error when fields are empty', async () => {
    render(<LoginForm onLogin={() => {}} />);

    const button = screen.getByRole('button', { name: /login/i });
    await userEvent.click(button);

    expect(screen.getByRole('alert')).toHaveTextContent('Please fill in all fields');
  });

  it('shows error for invalid email', async () => {
    render(<LoginForm onLogin={() => {}} />);

    const emailInput = screen.getByLabelText(/email/i);
    const passwordInput = screen.getByLabelText(/password/i);
    const button = screen.getByRole('button', { name: /login/i });

    await userEvent.type(emailInput, 'invalidemail');
    await userEvent.type(passwordInput, 'password123');
    await userEvent.click(button);

    expect(screen.getByRole('alert')).toHaveTextContent('Invalid email');
  });

  it('calls onLogin with correct data', async () => {
    const mockOnLogin = jest.fn();
    render(<LoginForm onLogin={mockOnLogin} />);

    const emailInput = screen.getByLabelText(/email/i);
    const passwordInput = screen.getByLabelText(/password/i);
    const button = screen.getByRole('button', { name: /login/i });

    await userEvent.type(emailInput, 'user@example.com');
    await userEvent.type(passwordInput, 'password123');
    await userEvent.click(button);

    expect(mockOnLogin).toHaveBeenCalledWith({
      email: 'user@example.com',
      password: 'password123'
    });
  });
});

// Testing async components
function UserList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('/api/users')
      .then(res => res.json())
      .then(data => {
        setUsers(data);
        setLoading(false);
      });
  }, []);

  if (loading) return <div>Loading...</div>;

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

// Test for async component
import { rest } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  rest.get('/api/users', (req, res, ctx) => {
    return res(ctx.json([
      { id: 1, name: 'John' },
      { id: 2, name: 'Jane' }
    ]));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

test('loads and displays users', async () => {
  render(<UserList />);

  expect(screen.getByText(/loading/i)).toBeInTheDocument();

  await waitFor(() => {
    expect(screen.getByText('John')).toBeInTheDocument();
    expect(screen.getByText('Jane')).toBeInTheDocument();
  });
});
```

---

## 15. Advanced Patterns

### Higher-Order Components (HOC)

```jsx
// HOC for authentication
function withAuth(Component) {
  return function AuthenticatedComponent(props) {
    const { user } = useAuth();

    if (!user) {
      return <Navigate to="/login" />;
    }

    return <Component {...props} user={user} />;
  };
}

// Usage
const ProtectedProfile = withAuth(Profile);

// HOC for loading
function withLoading(Component) {
  return function LoadingComponent({ isLoading, ...props }) {
    if (isLoading) {
      return <div>Loading...</div>;
    }

    return <Component {...props} />;
  };
}

// HOC for error handling
function withErrorBoundary(Component) {
  return class extends React.Component {
    state = { hasError: false, error: null };

    static getDerivedStateFromError(error) {
      return { hasError: true, error };
    }

    render() {
      if (this.state.hasError) {
        return <div>Error: {this.state.error.message}</div>;
      }

      return <Component {...this.props} />;
    }
  };
}
```

### Render Props Pattern

```jsx
// Mouse tracker with render props
function MouseTracker({ render }) {
  const [position, setPosition] = useState({ x: 0, y: 0 });

  const handleMouseMove = (e) => {
    setPosition({ x: e.clientX, y: e.clientY });
  };

  return (
    <div onMouseMove={handleMouseMove} style={{ height: '100vh' }}>
      {render(position)}
    </div>
  );
}

// Usage
function App() {
  return (
    <MouseTracker
      render={({ x, y }) => (
        <div>
          Mouse position: {x}, {y}
        </div>
      )}
    />
  );
}

// Data fetcher with render props
function DataFetcher({ url, render }) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [url]);

  return render({ data, loading, error });
}

// Usage
function UserProfile({ userId }) {
  return (
    <DataFetcher
      url={`/api/users/${userId}`}
      render={({ data, loading, error }) => {
        if (loading) return <div>Loading...</div>;
        if (error) return <div>Error: {error.message}</div>;
        if (!data) return null;

        return (
          <div>
            <h1>{data.name}</h1>
            <p>{data.email}</p>
          </div>
        );
      }}
    />
  );
}
```

### Compound Components Pattern

```jsx
// Tab component using compound components
const TabContext = createContext();

function Tabs({ children, defaultTab }) {
  const [activeTab, setActiveTab] = useState(defaultTab);

  return (
    <TabContext.Provider value={{ activeTab, setActiveTab }}>
      <div className="tabs">{children}</div>
    </TabContext.Provider>
  );
}

function TabList({ children }) {
  return <div className="tab-list">{children}</div>;
}

function Tab({ children, value }) {
  const { activeTab, setActiveTab } = useContext(TabContext);

  return (
    <button
      className={`tab ${activeTab === value ? 'active' : ''}`}
      onClick={() => setActiveTab(value)}
    >
      {children}
    </button>
  );
}

function TabPanels({ children }) {
  return <div className="tab-panels">{children}</div>;
}

function TabPanel({ children, value }) {
  const { activeTab } = useContext(TabContext);

  if (activeTab !== value) return null;

  return <div className="tab-panel">{children}</div>;
}

// Assign sub-components
Tabs.TabList = TabList;
Tabs.Tab = Tab;
Tabs.TabPanels = TabPanels;
Tabs.TabPanel = TabPanel;

// Usage
function App() {
  return (
    <Tabs defaultTab="tab1">
      <Tabs.TabList>
        <Tabs.Tab value="tab1">Tab 1</Tabs.Tab>
        <Tabs.Tab value="tab2">Tab 2</Tabs.Tab>
        <Tabs.Tab value="tab3">Tab 3</Tabs.Tab>
      </Tabs.TabList>

      <Tabs.TabPanels>
        <Tabs.TabPanel value="tab1">
          Content for Tab 1
        </Tabs.TabPanel>
        <Tabs.TabPanel value="tab2">
          Content for Tab 2
        </Tabs.TabPanel>
        <Tabs.TabPanel value="tab3">
          Content for Tab 3
        </Tabs.TabPanel>
      </Tabs.TabPanels>
    </Tabs>
  );
}
```

---

## 16. Real-World Projects

### Project 1: Todo App with Local Storage

```jsx
// Complete Todo App
function TodoApp() {
  const [todos, setTodos] = useState(() => {
    const saved = localStorage.getItem('todos');
    return saved ? JSON.parse(saved) : [];
  });

  const [input, setInput] = useState('');
  const [filter, setFilter] = useState('all');
  const [editingId, setEditingId] = useState(null);
  const [editText, setEditText] = useState('');

  useEffect(() => {
    localStorage.setItem('todos', JSON.stringify(todos));
  }, [todos]);

  const addTodo = () => {
    if (input.trim()) {
      setTodos([...todos, {
        id: Date.now(),
        text: input,
        completed: false,
        createdAt: new Date().toISOString()
      }]);
      setInput('');
    }
  };

  const toggleTodo = (id) => {
    setTodos(todos.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };

  const deleteTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  const startEdit = (id, text) => {
    setEditingId(id);
    setEditText(text);
  };

  const saveEdit = () => {
    setTodos(todos.map(todo =>
      todo.id === editingId ? { ...todo, text: editText } : todo
    ));
    setEditingId(null);
    setEditText('');
  };

  const clearCompleted = () => {
    setTodos(todos.filter(todo => !todo.completed));
  };

  const filteredTodos = todos.filter(todo => {
    if (filter === 'active') return !todo.completed;
    if (filter === 'completed') return todo.completed;
    return true;
  });

  const stats = {
    total: todos.length,
    active: todos.filter(t => !t.completed).length,
    completed: todos.filter(t => t.completed).length
  };

  return (
    <div className="todo-app">
      <h1>Todo App</h1>

      <div className="add-todo">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && addTodo()}
          placeholder="What needs to be done?"
        />
        <button onClick={addTodo}>Add</button>
      </div>

      <div className="filters">
        <button
          className={filter === 'all' ? 'active' : ''}
          onClick={() => setFilter('all')}
        >
          All ({stats.total})
        </button>
        <button
          className={filter === 'active' ? 'active' : ''}
          onClick={() => setFilter('active')}
        >
          Active ({stats.active})
        </button>
        <button
          className={filter === 'completed' ? 'active' : ''}
          onClick={() => setFilter('completed')}
        >
          Completed ({stats.completed})
        </button>
      </div>

      <ul className="todo-list">
        {filteredTodos.map(todo => (
          <li key={todo.id} className={todo.completed ? 'completed' : ''}>
            {editingId === todo.id ? (
              <div>
                <input
                  value={editText}
                  onChange={(e) => setEditText(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && saveEdit()}
                />
                <button onClick={saveEdit}>Save</button>
                <button onClick={() => setEditingId(null)}>Cancel</button>
              </div>
            ) : (
              <div>
                <input
                  type="checkbox"
                  checked={todo.completed}
                  onChange={() => toggleTodo(todo.id)}
                />
                <span onClick={() => toggleTodo(todo.id)}>{todo.text}</span>
                <button onClick={() => startEdit(todo.id, todo.text)}>Edit</button>
                <button onClick={() => deleteTodo(todo.id)}>Delete</button>
              </div>
            )}
          </li>
        ))}
      </ul>

      {stats.completed > 0 && (
        <button onClick={clearCompleted}>
          Clear Completed ({stats.completed})
        </button>
      )}
    </div>
  );
}
```

### Project 2: Weather App

```jsx
function WeatherApp() {
  const [city, setCity] = useState('');
  const [weather, setWeather] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [favorites, setFavorites] = useState(() => {
    const saved = localStorage.getItem('favoritesCities');
    return saved ? JSON.parse(saved) : [];
  });

  const API_KEY = 'your_api_key_here';
  const API_URL = 'https://api.openweathermap.org/data/2.5/weather';

  const fetchWeather = async (cityName) => {
    setLoading(true);
    setError('');

    try {
      const response = await fetch(
        `${API_URL}?q=${cityName}&appid=${API_KEY}&units=metric`
      );

      if (!response.ok) {
        throw new Error('City not found');
      }

      const data = await response.json();
      setWeather(data);
    } catch (err) {
      setError(err.message);
      setWeather(null);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = (e) => {
    e.preventDefault();
    if (city.trim()) {
      fetchWeather(city);
    }
  };

  const addToFavorites = () => {
    if (weather && !favorites.includes(weather.name)) {
      const newFavorites = [...favorites, weather.name];
      setFavorites(newFavorites);
      localStorage.setItem('favoritesCities', JSON.stringify(newFavorites));
    }
  };

  const removeFromFavorites = (cityName) => {
    const newFavorites = favorites.filter(fav => fav !== cityName);
    setFavorites(newFavorites);
    localStorage.setItem('favoritesCities', JSON.stringify(newFavorites));
  };

  return (
    <div className="weather-app">
      <h1>Weather App</h1>

      <form onSubmit={handleSearch}>
        <input
          value={city}
          onChange={(e) => setCity(e.target.value)}
          placeholder="Enter city name..."
        />
        <button type="submit">Search</button>
      </form>

      {loading && <div>Loading...</div>}
      {error && <div className="error">{error}</div>}

      {weather && (
        <div className="weather-card">
          <h2>{weather.name}, {weather.sys.country}</h2>
          <p className="temperature">{Math.round(weather.main.temp)}°C</p>
          <p className="description">{weather.weather[0].description}</p>
          <div className="details">
            <p>Feels like: {Math.round(weather.main.feels_like)}°C</p>
            <p>Humidity: {weather.main.humidity}%</p>
            <p>Wind: {weather.wind.speed} m/s</p>
          </div>
          <button onClick={addToFavorites}>
            {favorites.includes(weather.name) ? '★ Favorited' : '☆ Add to Favorites'}
          </button>
        </div>
      )}

      {favorites.length > 0 && (
        <div className="favorites">
          <h3>Favorite Cities</h3>
          <ul>
            {favorites.map(fav => (
              <li key={fav}>
                <span onClick={() => fetchWeather(fav)}>{fav}</span>
                <button onClick={() => removeFromFavorites(fav)}>×</button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
```

---

## 17. Interview Questions

### Basic Level

1. **What is React?**
   - JavaScript library for building user interfaces
   - Component-based architecture
   - Virtual DOM for efficient updates
   - Declarative programming style

2. **What is JSX?**
   - JavaScript XML syntax extension
   - Allows writing HTML-like code in JavaScript
   - Transpiled to React.createElement() calls

3. **What are Props?**
   - Properties passed to components
   - Read-only and immutable
   - Flow from parent to child

4. **What is State?**
   - Component's internal data storage
   - Mutable and triggers re-renders
   - Managed using useState or this.state

5. **Difference between Props and State?**
   - Props: External, immutable, passed from parent
   - State: Internal, mutable, managed by component

### Intermediate Level

6. **What are Hooks?**
   - Functions that let you use state and lifecycle features in functional components
   - Examples: useState, useEffect, useContext, useReducer

7. **Explain useEffect Hook**
   - Handles side effects in functional components
   - Replaces componentDidMount, componentDidUpdate, componentWillUnmount
   - Cleanup function for subscriptions

8. **What is Virtual DOM?**
   - JavaScript representation of real DOM
   - Diffing algorithm compares changes
   - Batch updates for better performance

9. **What are Controlled Components?**
   - Form inputs controlled by React state
   - Value comes from state, changes through event handlers

10. **What is Context API?**
    - Provides way to pass data through component tree
    - Avoids prop drilling
    - Global state management

### Advanced Level

11. **What is React Fiber?**
    - New reconciliation algorithm
    - Enables incremental rendering
    - Priority-based updates

12. **Explain React.memo**
    - Higher-order component for performance
    - Memoizes component output
    - Prevents unnecessary re-renders

13. **What are Custom Hooks?**
    - Reusable stateful logic
    - Start with "use" prefix
    - Can use other hooks

14. **What is Code Splitting?**
    - Breaking bundle into smaller chunks
    - Lazy loading components
    - Improves initial load time

15. **Explain Server-Side Rendering (SSR)**
    - Rendering React on server
    - Better SEO and initial load
    - Frameworks: Next.js, Gatsby

### Coding Questions

```jsx
// 1. Implement a custom useDebounce hook
function useDebounce(value, delay) {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => clearTimeout(handler);
  }, [value, delay]);

  return debouncedValue;
}

// 2. Implement a custom usePrevious hook
function usePrevious(value) {
  const ref = useRef();

  useEffect(() => {
    ref.current = value;
  });

  return ref.current;
}

// 3. Create a HOC for authentication
function withAuth(Component) {
  return function AuthComponent(props) {
    const [isAuthenticated, setIsAuthenticated] = useState(false);

    useEffect(() => {
      // Check authentication
      const token = localStorage.getItem('token');
      setIsAuthenticated(!!token);
    }, []);

    if (!isAuthenticated) {
      return <div>Please login</div>;
    }

    return <Component {...props} />;
  };
}

// 4. Implement infinite scrolling
function InfiniteScroll() {
  const [items, setItems] = useState([]);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(false);
  const observerRef = useRef();

  useEffect(() => {
    loadMore();
  }, [page]);

  const loadMore = async () => {
    setLoading(true);
    const response = await fetch(`/api/items?page=${page}`);
    const newItems = await response.json();
    setItems(prev => [...prev, ...newItems]);
    setLoading(false);
  };

  const lastItemCallback = useCallback(node => {
    if (loading) return;
    if (observerRef.current) observerRef.current.disconnect();

    observerRef.current = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting) {
        setPage(prev => prev + 1);
      }
    });

    if (node) observerRef.current.observe(node);
  }, [loading]);

  return (
    <div>
      {items.map((item, index) => {
        if (items.length === index + 1) {
          return <div ref={lastItemCallback} key={item.id}>{item.name}</div>;
        }
        return <div key={item.id}>{item.name}</div>;
      })}
      {loading && <div>Loading...</div>}
    </div>
  );
}
```

---

## 18. Best Practices

### Component Design
1. **Single Responsibility**: One component, one purpose
2. **Composition over Inheritance**: Use component composition
3. **Keep Components Small**: Break large components into smaller ones
4. **Use Functional Components**: Prefer hooks over classes

### State Management
1. **Lift State Up**: Share state at lowest common ancestor
2. **Local State First**: Use local state before global
3. **Immutable Updates**: Never mutate state directly
4. **Normalize State Shape**: Keep state flat and normalized

### Performance
1. **Use React.memo**: For expensive components
2. **useMemo and useCallback**: For expensive computations/functions
3. **Lazy Loading**: Split code and load on demand
4. **Virtualization**: For long lists
5. **Avoid Inline Functions**: In render methods

### Code Organization
```
src/
├── components/
│   ├── common/
│   ├── features/
│   └── layouts/
├── hooks/
├── services/
├── utils/
├── styles/
└── constants/
```

### Naming Conventions
- Components: PascalCase (UserProfile)
- Hooks: camelCase starting with 'use' (useAuth)
- Event Handlers: handle* (handleClick)
- Boolean Props: is*, has*, should* (isLoading, hasError)

### Error Handling
```jsx
class ErrorBoundary extends React.Component {
  state = { hasError: false };

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Error caught:', error, errorInfo);
    // Log to error reporting service
  }

  render() {
    if (this.state.hasError) {
      return <h2>Something went wrong.</h2>;
    }

    return this.props.children;
  }
}
```

### Accessibility
```jsx
// Use semantic HTML
<button>Click me</button> // ✓
<div onClick={handleClick}>Click me</div> // ✗

// Add ARIA labels
<input aria-label="Search" />
<button aria-pressed="true">Toggle</button>

// Keyboard navigation
<div
  tabIndex={0}
  onKeyDown={(e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      handleAction();
    }
  }}
>
  Interactive element
</div>
```

---

## How to Practice

### 1. Build Projects
- Start with simple projects (Todo, Calculator)
- Progress to medium (Weather App, Blog)
- Build complex apps (E-commerce, Social Media)

### 2. Daily Challenges
- Solve one React problem daily
- Recreate popular UI components
- Implement custom hooks

### 3. Code Review
- Review others' code on GitHub
- Contribute to open source
- Get feedback on your code

### 4. Stay Updated
- Follow React blog
- Watch conference talks
- Join React communities

### 5. Practice Resources
- **Platforms**: CodeSandbox, StackBlitz
- **Challenges**: Frontend Mentor, React Coding Challenges
- **Courses**: React Official Docs, freeCodeCamp
- **Communities**: r/reactjs, Reactiflux Discord

### 6. Build a Portfolio
```jsx
// Portfolio Project Ideas
const projects = [
  "Personal Portfolio Website",
  "Task Management App",
  "Weather Dashboard",
  "Recipe Finder",
  "Movie Database",
  "Chat Application",
  "E-commerce Store",
  "Social Media Clone",
  "Admin Dashboard",
  "Real-time Collaboration Tool"
];
```

---

## Conclusion

React is a powerful library that requires practice to master. Focus on:

1. **Fundamentals First**: Master components, props, state
2. **Hooks Proficiency**: Understand all built-in hooks
3. **State Management**: Learn when to use local vs global state
4. **Performance**: Optimize rendering and bundle size
5. **Testing**: Write tests for components
6. **Best Practices**: Follow conventions and patterns
7. **Keep Learning**: React evolves, stay updated

Remember: The best way to learn React is by building projects. Start small, be consistent, and gradually increase complexity.

Happy Coding! 🚀