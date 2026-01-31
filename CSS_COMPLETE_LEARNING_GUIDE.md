# Complete CSS Learning Guide: From Basics to Mastery

## Table of Contents
1. [Introduction to CSS](#introduction)
2. [CSS Basics](#basics)
3. [Selectors](#selectors)
4. [Box Model](#box-model)
5. [Typography](#typography)
6. [Colors & Backgrounds](#colors-backgrounds)
7. [Layout Systems](#layout)
8. [Positioning](#positioning)
9. [Flexbox](#flexbox)
10. [Grid](#grid)
11. [Responsive Design](#responsive)
12. [Animations & Transitions](#animations)
13. [Advanced Concepts](#advanced)
14. [Real-World Scenarios](#scenarios)
15. [Interview Questions](#interview)
16. [Practice Projects](#practice)
17. [Best Practices](#best-practices)

---

## 1. Introduction to CSS {#introduction}

### What is CSS?
CSS (Cascading Style Sheets) is a stylesheet language used to describe the presentation of HTML documents.

### Why CSS?
- **Separation of concerns**: Keeps styling separate from HTML structure
- **Reusability**: Same styles can be applied to multiple elements
- **Maintainability**: Easy to update and maintain styles
- **Performance**: Reduces file size and improves loading times

### How to Add CSS to HTML

#### 1. Inline CSS (Not Recommended)
```html
<p style="color: red; font-size: 20px;">This is inline CSS</p>
```
**When to use**: Quick testing, email templates

#### 2. Internal CSS
```html
<head>
  <style>
    p {
      color: blue;
      font-size: 18px;
    }
  </style>
</head>
```
**When to use**: Single-page applications, page-specific styles

#### 3. External CSS (Recommended)
```html
<head>
  <link rel="stylesheet" href="styles.css">
</head>
```
**When to use**: Most projects, reusable styles

---

## 2. CSS Basics {#basics}

### CSS Syntax
```css
selector {
  property: value;
  property2: value2;
}
```

### Basic Example
```css
/* This is a comment */
h1 {
  color: navy;           /* Text color */
  font-size: 32px;      /* Font size */
  text-align: center;   /* Text alignment */
  margin-bottom: 20px;  /* Bottom margin */
}
```

### Multiple Selectors
```css
h1, h2, h3 {
  font-family: Arial, sans-serif;
  color: #333;
}
```

---

## 3. Selectors {#selectors}

### Basic Selectors

#### Element Selector
```css
/* Targets all <p> elements */
p {
  line-height: 1.6;
}
```
**Real-world use**: Resetting default styles for all paragraphs

#### Class Selector
```css
/* Targets elements with class="highlight" */
.highlight {
  background-color: yellow;
  padding: 2px;
}
```
```html
<span class="highlight">Important text</span>
```
**Real-world use**: Reusable components like buttons, cards

#### ID Selector
```css
/* Targets element with id="header" */
#header {
  background-color: #f4f4f4;
  padding: 20px;
}
```
```html
<div id="header">Header Content</div>
```
**Real-world use**: Unique sections like navigation, footer

### Advanced Selectors

#### Descendant Selector
```css
/* Targets <p> inside <article> */
article p {
  margin: 15px 0;
}
```
**Real-world use**: Styling blog post content

#### Child Selector
```css
/* Direct children only */
ul > li {
  list-style: none;
}
```
**Real-world use**: Navigation menus

#### Adjacent Sibling
```css
/* Element immediately after h2 */
h2 + p {
  font-weight: bold;
}
```
**Real-world use**: First paragraph after heading

#### Attribute Selector
```css
/* Links with target="_blank" */
a[target="_blank"] {
  color: red;
}

/* Input with type="email" */
input[type="email"] {
  border: 2px solid blue;
}
```
**Real-world use**: Form styling, external link indicators

#### Pseudo-classes
```css
/* Hover state */
button:hover {
  background-color: #0056b3;
  cursor: pointer;
}

/* First child */
li:first-child {
  font-weight: bold;
}

/* Nth child */
tr:nth-child(even) {
  background-color: #f2f2f2;
}

/* Form states */
input:focus {
  outline: 2px solid blue;
}

input:disabled {
  opacity: 0.5;
}
```
**Real-world use**: Interactive elements, table striping

#### Pseudo-elements
```css
/* Add content before */
.required::before {
  content: "* ";
  color: red;
}

/* First letter styling */
p::first-letter {
  font-size: 2em;
  font-weight: bold;
}

/* Selection styling */
::selection {
  background-color: yellow;
  color: black;
}
```
**Real-world use**: Icons, decorative elements

---

## 4. Box Model {#box-model}

### Understanding the Box Model
Every HTML element is a box with:
- **Content**: The actual content
- **Padding**: Space inside the border
- **Border**: The element's border
- **Margin**: Space outside the border

```css
.box {
  /* Content width */
  width: 300px;
  height: 200px;

  /* Padding */
  padding: 20px;           /* All sides */
  padding: 10px 20px;      /* Top/bottom, left/right */
  padding: 10px 20px 30px; /* Top, left/right, bottom */
  padding: 10px 20px 30px 40px; /* Top, right, bottom, left */

  /* Border */
  border: 2px solid black;
  border-radius: 10px;

  /* Margin */
  margin: 20px auto; /* Centers horizontally */
}
```

### Box-sizing
```css
/* Default: content-box */
.default-box {
  width: 300px;
  padding: 20px;
  border: 2px solid;
  /* Total width = 344px (300 + 40 + 4) */
}

/* Border-box (recommended) */
.border-box {
  box-sizing: border-box;
  width: 300px;
  padding: 20px;
  border: 2px solid;
  /* Total width = 300px */
}

/* Global reset */
* {
  box-sizing: border-box;
}
```

### Real-world Example: Card Component
```css
.card {
  box-sizing: border-box;
  width: 350px;
  padding: 20px;
  margin: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.card-title {
  margin: 0 0 10px 0;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}
```

---

## 5. Typography {#typography}

### Font Properties
```css
.text-styling {
  /* Font family */
  font-family: 'Helvetica Neue', Arial, sans-serif;

  /* Font size */
  font-size: 16px;        /* Pixels */
  font-size: 1.2rem;      /* Relative to root */
  font-size: 1.2em;       /* Relative to parent */

  /* Font weight */
  font-weight: normal;    /* 400 */
  font-weight: bold;      /* 700 */
  font-weight: 600;       /* Semi-bold */

  /* Font style */
  font-style: italic;

  /* Line height */
  line-height: 1.6;       /* Multiplier */
  line-height: 24px;      /* Fixed */

  /* Letter spacing */
  letter-spacing: 0.5px;

  /* Text transform */
  text-transform: uppercase;
  text-transform: capitalize;

  /* Text decoration */
  text-decoration: underline;
  text-decoration: line-through;

  /* Text alignment */
  text-align: center;
  text-align: justify;
}
```

### Web Fonts
```css
/* Google Fonts */
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap');

/* Custom font */
@font-face {
  font-family: 'CustomFont';
  src: url('font.woff2') format('woff2'),
       url('font.woff') format('woff');
  font-weight: normal;
  font-style: normal;
}

body {
  font-family: 'Roboto', sans-serif;
}
```

### Real-world Typography System
```css
/* Typography Scale */
:root {
  --font-size-xs: 0.75rem;   /* 12px */
  --font-size-sm: 0.875rem;  /* 14px */
  --font-size-base: 1rem;    /* 16px */
  --font-size-lg: 1.125rem;  /* 18px */
  --font-size-xl: 1.25rem;   /* 20px */
  --font-size-2xl: 1.5rem;   /* 24px */
  --font-size-3xl: 1.875rem; /* 30px */
  --font-size-4xl: 2.25rem;  /* 36px */
}

h1 { font-size: var(--font-size-4xl); }
h2 { font-size: var(--font-size-3xl); }
h3 { font-size: var(--font-size-2xl); }

.body-text {
  font-size: var(--font-size-base);
  line-height: 1.6;
}

.small-text {
  font-size: var(--font-size-sm);
}
```

---

## 6. Colors & Backgrounds {#colors-backgrounds}

### Color Formats
```css
.colors {
  /* Named colors */
  color: red;

  /* Hex */
  color: #ff0000;
  color: #f00;        /* Shorthand */

  /* RGB */
  color: rgb(255, 0, 0);

  /* RGBA (with transparency) */
  color: rgba(255, 0, 0, 0.5);

  /* HSL */
  color: hsl(0, 100%, 50%);

  /* HSLA */
  color: hsla(0, 100%, 50%, 0.5);

  /* Current color */
  border-color: currentColor;
}
```

### Backgrounds
```css
.backgrounds {
  /* Solid color */
  background-color: #f0f0f0;

  /* Image */
  background-image: url('image.jpg');
  background-size: cover;           /* Cover entire area */
  background-size: contain;         /* Fit inside */
  background-size: 100px 200px;    /* Specific size */

  background-position: center;
  background-position: top right;
  background-position: 50% 50%;

  background-repeat: no-repeat;
  background-repeat: repeat-x;

  background-attachment: fixed;     /* Parallax effect */

  /* Shorthand */
  background: #f0f0f0 url('bg.jpg') no-repeat center/cover;

  /* Multiple backgrounds */
  background:
    url('top-image.png') top center no-repeat,
    url('bottom-image.png') bottom center no-repeat,
    linear-gradient(to bottom, #fff, #f0f0f0);
}
```

### Gradients
```css
.gradients {
  /* Linear gradient */
  background: linear-gradient(to right, #ff0000, #00ff00);
  background: linear-gradient(45deg, #ff0000, #00ff00, #0000ff);

  /* Radial gradient */
  background: radial-gradient(circle, #ff0000, #00ff00);

  /* Repeating gradient */
  background: repeating-linear-gradient(
    45deg,
    #ff0000,
    #ff0000 10px,
    #00ff00 10px,
    #00ff00 20px
  );
}
```

### Real-world Example: Hero Section
```css
.hero {
  background:
    linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)),
    url('hero-bg.jpg') center/cover no-repeat;
  color: white;
  padding: 100px 20px;
  text-align: center;
}
```

---

## 7. Layout Systems {#layout}

### Display Property
```css
.display-examples {
  display: block;        /* Full width, new line */
  display: inline;       /* Inline with text */
  display: inline-block; /* Inline but with block properties */
  display: none;         /* Hidden */
  display: flex;         /* Flexbox container */
  display: grid;         /* Grid container */
}
```

### Float Layout (Legacy)
```css
.float-layout {
  float: left;
  float: right;
  clear: both;  /* Clear floats */
}

/* Clearfix hack */
.clearfix::after {
  content: "";
  display: table;
  clear: both;
}
```

---

## 8. Positioning {#positioning}

### Position Types
```css
/* Static (default) */
.static {
  position: static;
}

/* Relative */
.relative {
  position: relative;
  top: 10px;
  left: 20px;
  /* Moved from original position */
}

/* Absolute */
.absolute {
  position: absolute;
  top: 0;
  right: 0;
  /* Positioned relative to nearest positioned parent */
}

/* Fixed */
.fixed {
  position: fixed;
  bottom: 20px;
  right: 20px;
  /* Fixed to viewport */
}

/* Sticky */
.sticky {
  position: sticky;
  top: 0;
  /* Sticks when scrolling past */
}
```

### Z-index
```css
.layer1 { z-index: 1; }
.layer2 { z-index: 10; }
.layer3 { z-index: 100; }
```

### Real-world Examples

#### Modal Overlay
```css
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.5);
  z-index: 1000;
}

.modal {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: white;
  padding: 20px;
  z-index: 1001;
}
```

#### Sticky Navigation
```css
.navbar {
  position: sticky;
  top: 0;
  background: white;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  z-index: 100;
}
```

---

## 9. Flexbox {#flexbox}

### Flex Container Properties
```css
.flex-container {
  display: flex;

  /* Direction */
  flex-direction: row;          /* Default */
  flex-direction: column;
  flex-direction: row-reverse;

  /* Wrap */
  flex-wrap: nowrap;           /* Default */
  flex-wrap: wrap;

  /* Justify (main axis) */
  justify-content: flex-start;  /* Default */
  justify-content: center;
  justify-content: space-between;
  justify-content: space-around;
  justify-content: space-evenly;

  /* Align (cross axis) */
  align-items: stretch;         /* Default */
  align-items: center;
  align-items: flex-start;
  align-items: flex-end;

  /* Gap */
  gap: 20px;
  gap: 10px 20px;  /* row-gap column-gap */
}
```

### Flex Item Properties
```css
.flex-item {
  /* Grow */
  flex-grow: 1;    /* Takes available space */

  /* Shrink */
  flex-shrink: 1;  /* Can shrink if needed */

  /* Basis */
  flex-basis: 200px; /* Base size */

  /* Shorthand */
  flex: 1;         /* grow: 1, shrink: 1, basis: 0 */
  flex: 0 0 200px; /* No grow, no shrink, 200px */

  /* Align self */
  align-self: center;

  /* Order */
  order: -1;       /* Appears first */
  order: 1;        /* Appears later */
}
```

### Real-world Flexbox Examples

#### Navigation Bar
```css
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
}

.nav-links {
  display: flex;
  gap: 2rem;
  list-style: none;
}

.nav-logo {
  font-size: 1.5rem;
  font-weight: bold;
}
```

#### Card Layout
```css
.card-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  justify-content: center;
}

.card {
  flex: 0 1 300px;  /* Don't grow, can shrink, base 300px */
  padding: 20px;
  border: 1px solid #ddd;
}
```

#### Centering Content
```css
.center-perfect {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
```

#### Sidebar Layout
```css
.layout {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  flex: 0 0 250px;  /* Fixed width */
  background: #f4f4f4;
}

.main-content {
  flex: 1;  /* Takes remaining space */
  padding: 20px;
}
```

---

## 10. CSS Grid {#grid}

### Grid Container
```css
.grid-container {
  display: grid;

  /* Columns */
  grid-template-columns: 200px 200px 200px;
  grid-template-columns: repeat(3, 200px);
  grid-template-columns: 1fr 2fr 1fr;  /* Fractional units */
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));

  /* Rows */
  grid-template-rows: 100px auto 100px;

  /* Gap */
  gap: 20px;
  column-gap: 20px;
  row-gap: 10px;

  /* Alignment */
  justify-items: center;  /* Horizontal alignment */
  align-items: center;    /* Vertical alignment */
  justify-content: center; /* Grid in container */
  align-content: center;
}
```

### Grid Items
```css
.grid-item {
  /* Placement */
  grid-column: 1 / 3;     /* Start at 1, end at 3 */
  grid-row: 1 / 2;

  /* Shorthand */
  grid-area: 1 / 1 / 2 / 3;  /* row-start / col-start / row-end / col-end */

  /* Span */
  grid-column: span 2;    /* Span 2 columns */

  /* Self alignment */
  justify-self: center;
  align-self: center;
}
```

### Named Grid Areas
```css
.page-layout {
  display: grid;
  grid-template-areas:
    "header header header"
    "sidebar main main"
    "footer footer footer";
  grid-template-columns: 200px 1fr 1fr;
  grid-template-rows: auto 1fr auto;
  gap: 20px;
}

.header { grid-area: header; }
.sidebar { grid-area: sidebar; }
.main { grid-area: main; }
.footer { grid-area: footer; }
```

### Real-world Grid Examples

#### Photo Gallery
```css
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 10px;
}

.gallery img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* Feature first image */
.gallery img:first-child {
  grid-column: span 2;
  grid-row: span 2;
}
```

#### Dashboard Layout
```css
.dashboard {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 20px;
  padding: 20px;
}

.widget-small { grid-column: span 3; }
.widget-medium { grid-column: span 6; }
.widget-large { grid-column: span 9; }
.widget-full { grid-column: span 12; }
```

---

## 11. Responsive Design {#responsive}

### Media Queries
```css
/* Mobile First Approach */
.container {
  padding: 10px;
}

/* Tablet */
@media (min-width: 768px) {
  .container {
    padding: 20px;
    max-width: 750px;
    margin: 0 auto;
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .container {
    max-width: 1200px;
  }
}

/* Large Desktop */
@media (min-width: 1440px) {
  .container {
    max-width: 1400px;
  }
}
```

### Breakpoint Strategy
```css
/* Common Breakpoints */
:root {
  --breakpoint-xs: 0;
  --breakpoint-sm: 576px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 992px;
  --breakpoint-xl: 1200px;
  --breakpoint-xxl: 1400px;
}

/* Responsive Typography */
h1 {
  font-size: 1.5rem;
}

@media (min-width: 768px) {
  h1 { font-size: 2rem; }
}

@media (min-width: 1024px) {
  h1 { font-size: 2.5rem; }
}
```

### Responsive Units
```css
.responsive-units {
  /* Viewport units */
  width: 100vw;    /* 100% viewport width */
  height: 100vh;   /* 100% viewport height */
  font-size: 4vw;  /* 4% of viewport width */

  /* Relative units */
  font-size: 1rem;   /* Relative to root */
  padding: 1em;      /* Relative to font-size */
  width: 100%;       /* Percentage of parent */

  /* Clamp for responsive sizing */
  font-size: clamp(1rem, 2vw, 1.5rem);  /* min, preferred, max */
}
```

### Responsive Grid
```css
.responsive-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

/* Or with media queries */
.grid {
  display: grid;
  grid-template-columns: 1fr;
}

@media (min-width: 768px) {
  .grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 1024px) {
  .grid {
    grid-template-columns: repeat(3, 1fr);
  }
}
```

### Mobile Navigation Pattern
```css
/* Mobile Menu */
.nav-menu {
  position: fixed;
  left: -100%;
  top: 70px;
  flex-direction: column;
  background-color: white;
  width: 100%;
  text-align: center;
  transition: 0.3s;
  box-shadow: 0 10px 27px rgba(0,0,0,0.05);
}

.nav-menu.active {
  left: 0;
}

/* Desktop Menu */
@media (min-width: 768px) {
  .nav-menu {
    position: static;
    flex-direction: row;
    width: auto;
    background-color: transparent;
    box-shadow: none;
  }

  .hamburger {
    display: none;
  }
}
```

---

## 12. Animations & Transitions {#animations}

### Transitions
```css
.button {
  background-color: blue;
  color: white;
  padding: 10px 20px;
  transition: background-color 0.3s ease;
  /* property duration timing-function delay */
}

.button:hover {
  background-color: darkblue;
}

/* Multiple properties */
.card {
  transition: transform 0.3s, box-shadow 0.3s;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 20px rgba(0,0,0,0.2);
}

/* All properties */
.element {
  transition: all 0.3s ease-in-out;
}
```

### Timing Functions
```css
.timing-examples {
  transition-timing-function: linear;
  transition-timing-function: ease;        /* Default */
  transition-timing-function: ease-in;
  transition-timing-function: ease-out;
  transition-timing-function: ease-in-out;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}
```

### Keyframe Animations
```css
/* Define animation */
@keyframes slideIn {
  from {
    transform: translateX(-100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

/* Or with percentages */
@keyframes pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
  }
}

/* Apply animation */
.animated-element {
  animation: slideIn 0.5s ease-out;
  /* name duration timing-function delay iteration-count direction fill-mode */
}

.pulse-element {
  animation: pulse 2s ease-in-out infinite;
}
```

### Transform Properties
```css
.transform-examples {
  /* Translate */
  transform: translateX(50px);
  transform: translateY(-20px);
  transform: translate(50px, -20px);

  /* Scale */
  transform: scale(1.5);
  transform: scaleX(2);

  /* Rotate */
  transform: rotate(45deg);

  /* Skew */
  transform: skewX(20deg);

  /* Multiple transforms */
  transform: translate(50px, 100px) rotate(45deg) scale(1.5);

  /* 3D transforms */
  transform: rotateX(45deg);
  transform: rotateY(45deg);
  transform: translateZ(50px);
  transform: perspective(1000px) rotateY(45deg);
}
```

### Real-world Animation Examples

#### Loading Spinner
```css
.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
```

#### Fade In on Scroll
```css
.fade-in-section {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.6s ease-out, transform 0.6s ease-out;
}

.fade-in-section.is-visible {
  opacity: 1;
  transform: translateY(0);
}
```

#### Button Hover Effects
```css
.btn-3d {
  position: relative;
  padding: 12px 24px;
  background: #3498db;
  color: white;
  border: none;
  transition: all 0.3s;
  transform-style: preserve-3d;
}

.btn-3d::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: #2c7fb8;
  transform: translateZ(-4px);
  transition: all 0.3s;
}

.btn-3d:hover {
  transform: translateY(-2px);
}

.btn-3d:active {
  transform: translateY(0);
}
```

---

## 13. Advanced CSS Concepts {#advanced}

### CSS Variables (Custom Properties)
```css
:root {
  /* Color Palette */
  --primary-color: #3498db;
  --secondary-color: #2ecc71;
  --danger-color: #e74c3c;
  --dark-color: #2c3e50;
  --light-color: #ecf0f1;

  /* Spacing */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;

  /* Typography */
  --font-primary: 'Roboto', sans-serif;
  --font-secondary: 'Open Sans', sans-serif;
}

/* Usage */
.button {
  background-color: var(--primary-color);
  padding: var(--spacing-md);
  font-family: var(--font-primary);
}

/* Change variables with JavaScript */
/* document.documentElement.style.setProperty('--primary-color', '#ff0000'); */

/* Scoped variables */
.dark-theme {
  --primary-color: #1a1a2e;
  --text-color: #ffffff;
}
```

### CSS Filters
```css
.filter-examples {
  /* Blur */
  filter: blur(5px);

  /* Brightness */
  filter: brightness(150%);

  /* Contrast */
  filter: contrast(200%);

  /* Grayscale */
  filter: grayscale(100%);

  /* Sepia */
  filter: sepia(60%);

  /* Multiple filters */
  filter: grayscale(50%) contrast(120%) brightness(110%);

  /* Backdrop filter (for elements behind) */
  backdrop-filter: blur(10px);
}

/* Real-world: Image hover effect */
.image-card img {
  transition: filter 0.3s;
}

.image-card:hover img {
  filter: brightness(110%) saturate(120%);
}
```

### Blend Modes
```css
.blend-examples {
  /* Mix blend mode */
  mix-blend-mode: multiply;
  mix-blend-mode: screen;
  mix-blend-mode: overlay;

  /* Background blend mode */
  background-blend-mode: multiply;
}

/* Real-world: Text over image */
.hero-text {
  background: white;
  mix-blend-mode: screen;
  color: black;
  font-weight: bold;
}
```

### CSS Shapes
```css
/* Circle */
.circle {
  width: 100px;
  height: 100px;
  border-radius: 50%;
}

/* Triangle */
.triangle {
  width: 0;
  height: 0;
  border-left: 50px solid transparent;
  border-right: 50px solid transparent;
  border-bottom: 100px solid #3498db;
}

/* Heart */
.heart {
  position: relative;
  width: 100px;
  height: 90px;
}

.heart::before,
.heart::after {
  content: '';
  position: absolute;
  top: 0;
  width: 52px;
  height: 80px;
  background: red;
  border-radius: 50px 50px 0 0;
}

.heart::before {
  left: 50px;
  transform: rotate(-45deg);
  transform-origin: 0 100%;
}

.heart::after {
  left: 0;
  transform: rotate(45deg);
  transform-origin: 100% 100%;
}
```

### CSS Counters
```css
/* Automatic numbering */
body {
  counter-reset: section;
}

h2::before {
  counter-increment: section;
  content: "Section " counter(section) ": ";
}

/* Nested counters */
ol {
  counter-reset: item;
  list-style: none;
}

li::before {
  counter-increment: item;
  content: counters(item, ".") " ";
}
```

### Scroll Snap
```css
/* Container */
.scroll-container {
  scroll-snap-type: x mandatory;
  overflow-x: scroll;
  display: flex;
}

/* Items */
.scroll-item {
  scroll-snap-align: center;
  flex: 0 0 100%;
}

/* Vertical scroll snap */
.vertical-scroll {
  scroll-snap-type: y proximity;
  height: 100vh;
  overflow-y: scroll;
}

.section {
  scroll-snap-align: start;
  height: 100vh;
}
```

---

## 14. Real-World Scenarios {#scenarios}

### 1. E-commerce Product Card
```css
.product-card {
  position: relative;
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}

.product-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.product-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background: #e74c3c;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.product-details {
  padding: 16px;
}

.product-title {
  font-size: 18px;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-price {
  display: flex;
  align-items: center;
  gap: 8px;
}

.price-old {
  text-decoration: line-through;
  color: #999;
}

.price-new {
  font-size: 20px;
  font-weight: bold;
  color: #27ae60;
}

.add-to-cart {
  width: 100%;
  padding: 12px;
  background: var(--primary-color);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.3s;
}

.add-to-cart:hover {
  background: var(--primary-color-dark);
}
```

### 2. Responsive Navigation with Hamburger Menu
```css
/* Navigation Container */
.navbar {
  background: #2c3e50;
  padding: 0 20px;
  position: sticky;
  top: 0;
  z-index: 1000;
}

.nav-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
  height: 60px;
}

.nav-logo {
  color: white;
  font-size: 24px;
  font-weight: bold;
}

/* Desktop Menu */
.nav-menu {
  display: flex;
  list-style: none;
  gap: 30px;
}

.nav-link {
  color: white;
  text-decoration: none;
  position: relative;
  transition: color 0.3s;
}

.nav-link::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 0;
  height: 2px;
  background: #3498db;
  transition: width 0.3s;
}

.nav-link:hover::after {
  width: 100%;
}

/* Hamburger Menu */
.hamburger {
  display: none;
  flex-direction: column;
  cursor: pointer;
}

.hamburger span {
  width: 25px;
  height: 3px;
  background: white;
  margin: 3px 0;
  transition: 0.3s;
}

/* Mobile Styles */
@media (max-width: 768px) {
  .hamburger {
    display: flex;
  }

  .nav-menu {
    position: fixed;
    left: -100%;
    top: 60px;
    flex-direction: column;
    background: #2c3e50;
    width: 100%;
    text-align: center;
    transition: 0.3s;
    padding: 20px 0;
  }

  .nav-menu.active {
    left: 0;
  }

  /* Hamburger Animation */
  .hamburger.active span:nth-child(1) {
    transform: rotate(-45deg) translate(-5px, 6px);
  }

  .hamburger.active span:nth-child(2) {
    opacity: 0;
  }

  .hamburger.active span:nth-child(3) {
    transform: rotate(45deg) translate(-5px, -6px);
  }
}
```

### 3. Form with Validation Styles
```css
.form-container {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
}

.form-group {
  margin-bottom: 20px;
}

.form-label {
  display: block;
  margin-bottom: 5px;
  font-weight: 600;
  color: #333;
}

.form-label.required::after {
  content: ' *';
  color: #e74c3c;
}

.form-input {
  width: 100%;
  padding: 10px;
  border: 2px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
  transition: border-color 0.3s, box-shadow 0.3s;
}

.form-input:focus {
  outline: none;
  border-color: #3498db;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
}

/* Validation States */
.form-input.valid {
  border-color: #27ae60;
  background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20"><path fill="%2327ae60" d="M10 0C4.5 0 0 4.5 0 10s4.5 10 10 10 10-4.5 10-10S15.5 0 10 0zm-2 15l-5-5 1.4-1.4L8 12.2l7.6-7.6L17 6l-9 9z"/></svg>');
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 20px;
  padding-right: 40px;
}

.form-input.invalid {
  border-color: #e74c3c;
  background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20"><path fill="%23e74c3c" d="M10 0C4.5 0 0 4.5 0 10s4.5 10 10 10 10-4.5 10-10S15.5 0 10 0zm1 15H9v-2h2v2zm0-4H9V5h2v6z"/></svg>');
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 20px;
  padding-right: 40px;
}

.form-error {
  color: #e74c3c;
  font-size: 14px;
  margin-top: 5px;
  display: none;
}

.form-input.invalid ~ .form-error {
  display: block;
}

/* Submit Button */
.form-submit {
  width: 100%;
  padding: 12px;
  background: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.3s;
}

.form-submit:hover {
  background: #2980b9;
}

.form-submit:disabled {
  background: #95a5a6;
  cursor: not-allowed;
}
```

### 4. Pricing Table
```css
.pricing-container {
  display: flex;
  gap: 20px;
  justify-content: center;
  flex-wrap: wrap;
  padding: 40px 20px;
}

.pricing-card {
  background: white;
  border-radius: 8px;
  padding: 30px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  position: relative;
  flex: 1;
  min-width: 280px;
  max-width: 350px;
  transition: transform 0.3s, box-shadow 0.3s;
}

.pricing-card.featured {
  transform: scale(1.05);
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
}

.pricing-badge {
  position: absolute;
  top: -10px;
  right: 20px;
  background: #e74c3c;
  color: white;
  padding: 5px 15px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
  text-transform: uppercase;
}

.pricing-title {
  font-size: 24px;
  margin-bottom: 10px;
  color: #2c3e50;
}

.pricing-price {
  font-size: 48px;
  font-weight: bold;
  color: #3498db;
  margin-bottom: 20px;
}

.pricing-price span {
  font-size: 16px;
  color: #7f8c8d;
}

.pricing-features {
  list-style: none;
  padding: 0;
  margin-bottom: 30px;
}

.pricing-features li {
  padding: 10px 0;
  border-bottom: 1px solid #ecf0f1;
  position: relative;
  padding-left: 25px;
}

.pricing-features li::before {
  content: '✓';
  position: absolute;
  left: 0;
  color: #27ae60;
  font-weight: bold;
}

.pricing-features li.disabled {
  color: #95a5a6;
  text-decoration: line-through;
}

.pricing-features li.disabled::before {
  content: '✗';
  color: #e74c3c;
}

.pricing-button {
  width: 100%;
  padding: 12px;
  background: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s;
}

.pricing-card.featured .pricing-button {
  background: #e74c3c;
}

.pricing-button:hover {
  background: #2980b9;
}

.pricing-card.featured .pricing-button:hover {
  background: #c0392b;
}
```

---

## 15. Interview Questions {#interview}

### Basic Level

1. **What is the CSS Box Model?**
   - Content, Padding, Border, Margin
   - Difference between content-box and border-box

2. **What are the different ways to apply CSS?**
   - Inline, Internal, External
   - Which has priority?

3. **What is specificity in CSS?**
   - ID (100) > Class (10) > Element (1)
   - !important overrides all

4. **Difference between class and ID selectors?**
   - IDs are unique, classes are reusable
   - IDs have higher specificity

5. **What are pseudo-classes and pseudo-elements?**
   - Pseudo-classes: :hover, :focus, :nth-child
   - Pseudo-elements: ::before, ::after, ::first-letter

### Intermediate Level

6. **Explain Flexbox vs Grid**
   - Flexbox: 1D layout (row or column)
   - Grid: 2D layout (rows and columns)

7. **What is the difference between position relative and absolute?**
   - Relative: Positioned relative to normal position
   - Absolute: Positioned relative to nearest positioned parent

8. **How do you center a div?**
   ```css
   /* Flexbox method */
   .parent {
     display: flex;
     justify-content: center;
     align-items: center;
   }

   /* Position + Transform */
   .element {
     position: absolute;
     top: 50%;
     left: 50%;
     transform: translate(-50%, -50%);
   }

   /* Margin auto */
   .element {
     width: 200px;
     margin: 0 auto;
   }
   ```

9. **What are CSS variables?**
   - Custom properties defined with --
   - Used with var() function
   - Can be scoped and changed with JavaScript

10. **Explain z-index and stacking context**
    - Controls stack order of positioned elements
    - Only works with positioned elements
    - Creates new stacking context

### Advanced Level

11. **What is BEM methodology?**
    ```css
    /* Block__Element--Modifier */
    .card {}
    .card__title {}
    .card__title--large {}
    ```

12. **How do you optimize CSS performance?**
    - Minimize CSS files
    - Use efficient selectors
    - Avoid complex calculations
    - Use CSS containment
    - Critical CSS inline

13. **What is CSS-in-JS?**
    - Styling components with JavaScript
    - Examples: styled-components, emotion
    - Pros: Scoped styles, dynamic styling
    - Cons: Runtime overhead, learning curve

14. **Explain CSS Containment**
    ```css
    .container {
      contain: layout style paint;
    }
    ```
    - Improves performance by limiting scope of browser calculations

15. **What are CSS Logical Properties?**
    ```css
    /* Physical */
    margin-left: 20px;

    /* Logical */
    margin-inline-start: 20px;
    ```
    - Better for internationalization (RTL/LTR)

### Practical Problems

16. **Create a triangle with CSS**
    ```css
    .triangle {
      width: 0;
      height: 0;
      border-left: 50px solid transparent;
      border-right: 50px solid transparent;
      border-bottom: 100px solid red;
    }
    ```

17. **Implement a loading spinner**
    ```css
    .spinner {
      border: 4px solid #f3f3f3;
      border-top: 4px solid #3498db;
      border-radius: 50%;
      width: 40px;
      height: 40px;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    ```

18. **Create a tooltip**
    ```css
    .tooltip {
      position: relative;
    }

    .tooltip::after {
      content: attr(data-tooltip);
      position: absolute;
      bottom: 100%;
      left: 50%;
      transform: translateX(-50%);
      background: black;
      color: white;
      padding: 5px 10px;
      border-radius: 4px;
      white-space: nowrap;
      opacity: 0;
      pointer-events: none;
      transition: opacity 0.3s;
    }

    .tooltip:hover::after {
      opacity: 1;
    }
    ```

---

## 16. Practice Projects {#practice}

### Project 1: Personal Portfolio
**Skills**: Layout, Typography, Responsive Design
```css
/* Key concepts to implement:
- Sticky navigation
- Hero section with gradient
- Grid-based project gallery
- Contact form with validation styles
- Mobile-responsive design
- Smooth scrolling
- Animations on scroll
*/
```

### Project 2: E-commerce Product Page
**Skills**: Grid, Flexbox, Interactions
```css
/* Features to build:
- Product image gallery with zoom
- Size/color selectors
- Add to cart animations
- Review stars display
- Related products carousel
- Responsive product grid
*/
```

### Project 3: Dashboard Interface
**Skills**: Grid, Variables, Theming
```css
/* Components needed:
- Sidebar navigation
- Card-based widgets
- Data tables with hover states
- Charts and graphs styling
- Dark mode toggle
- Responsive layout
*/
```

### Project 4: Landing Page
**Skills**: Animations, Transitions, Marketing
```css
/* Elements to create:
- Animated hero section
- Feature cards with hover effects
- Pricing table
- Testimonial carousel
- Call-to-action buttons
- Footer with multiple columns
*/
```

### Project 5: Blog Theme
**Skills**: Typography, Layout, Readability
```css
/* Requirements:
- Article typography
- Code syntax highlighting
- Image galleries
- Comment section
- Author bio card
- Table of contents
- Reading progress bar
*/
```

---

## 17. Best Practices {#best-practices}

### 1. Organization
```css
/* Follow a consistent order */
.element {
  /* Positioning */
  position: relative;
  top: 0;

  /* Box Model */
  display: flex;
  width: 100%;
  padding: 20px;
  margin: 10px;

  /* Typography */
  font-family: Arial;
  font-size: 16px;
  line-height: 1.5;

  /* Visual */
  background: white;
  border: 1px solid #ddd;

  /* Misc */
  transition: all 0.3s;
  cursor: pointer;
}
```

### 2. Naming Conventions
```css
/* BEM (Block Element Modifier) */
.block {}
.block__element {}
.block--modifier {}

/* Example */
.nav {}
.nav__item {}
.nav__item--active {}

/* Utility Classes */
.u-text-center { text-align: center; }
.u-mt-20 { margin-top: 20px; }
```

### 3. Performance Tips
```css
/* Use efficient selectors */
/* Bad */
div > ul > li > a { }

/* Good */
.nav-link { }

/* Use transform for animations */
/* Bad */
.animate {
  left: 100px;
}

/* Good */
.animate {
  transform: translateX(100px);
}

/* Use will-change sparingly */
.will-animate {
  will-change: transform;
}
```

### 4. Accessibility
```css
/* Focus styles */
:focus {
  outline: 2px solid #3498db;
  outline-offset: 2px;
}

/* Skip to content */
.skip-link {
  position: absolute;
  left: -9999px;
}

.skip-link:focus {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 999;
}

/* Screen reader only */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0,0,0,0);
  border: 0;
}
```

### 5. Browser Compatibility
```css
/* Use vendor prefixes when needed */
.element {
  -webkit-transform: rotate(45deg);
  -moz-transform: rotate(45deg);
  -ms-transform: rotate(45deg);
  transform: rotate(45deg);
}

/* Feature detection */
@supports (display: grid) {
  .container {
    display: grid;
  }
}

/* Fallbacks */
.gradient {
  background: #3498db; /* Fallback */
  background: linear-gradient(to right, #3498db, #2ecc71);
}
```

### 6. Modern CSS Reset
```css
/* Modern CSS Reset */
*, *::before, *::after {
  box-sizing: border-box;
}

* {
  margin: 0;
  padding: 0;
}

html, body {
  height: 100%;
}

body {
  line-height: 1.5;
  -webkit-font-smoothing: antialiased;
}

img, picture, video, canvas, svg {
  display: block;
  max-width: 100%;
}

input, button, textarea, select {
  font: inherit;
}

p, h1, h2, h3, h4, h5, h6 {
  overflow-wrap: break-word;
}
```

### 7. CSS Architecture
```css
/* ITCSS (Inverted Triangle CSS) */
/* 1. Settings - Variables */
:root {
  --primary-color: #3498db;
}

/* 2. Tools - Mixins, Functions */

/* 3. Generic - Reset, Normalize */

/* 4. Elements - HTML elements */
h1 { }

/* 5. Objects - Design patterns */
.container { }

/* 6. Components - UI components */
.card { }

/* 7. Utilities - Helper classes */
.text-center { }
```

---

## Resources for Practice

### Online Playgrounds
1. **CodePen** - codepen.io
2. **JSFiddle** - jsfiddle.net
3. **CSS Tricks** - css-tricks.com
4. **CodeSandbox** - codesandbox.io

### Challenge Websites
1. **CSS Battle** - cssbattle.dev
2. **Frontend Mentor** - frontendmentor.io
3. **CSS Zen Garden** - csszengarden.com
4. **100 Days CSS** - 100dayscss.com

### Learning Resources
1. **MDN Web Docs** - Complete CSS reference
2. **W3Schools** - Tutorials and examples
3. **Flexbox Froggy** - Game to learn Flexbox
4. **Grid Garden** - Game to learn CSS Grid

### Tools
1. **Can I Use** - Browser compatibility
2. **CSS Validator** - Validate your CSS
3. **Autoprefixer** - Add vendor prefixes
4. **PurgeCSS** - Remove unused CSS

---

## Conclusion

CSS is a powerful tool for creating beautiful, responsive, and interactive web interfaces. Key takeaways:

1. **Master the fundamentals** - Box model, positioning, display
2. **Learn modern layout** - Flexbox and Grid
3. **Practice responsive design** - Mobile-first approach
4. **Understand performance** - Efficient selectors, optimized animations
5. **Follow best practices** - BEM, accessibility, browser compatibility
6. **Keep learning** - CSS is constantly evolving

Remember: The best way to learn CSS is by building projects. Start small, experiment, and gradually increase complexity. Every website you see is an opportunity to learn - use browser DevTools to inspect and understand how things are built.

Happy Coding! 🎨