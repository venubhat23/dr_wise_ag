# HTML Complete Guide - From Basics to Mastery

## Table of Contents
1. [Introduction to HTML](#introduction)
2. [HTML Document Structure](#document-structure)
3. [Text Elements](#text-elements)
4. [Links and Navigation](#links)
5. [Images and Media](#images-media)
6. [Lists](#lists)
7. [Tables](#tables)
8. [Forms](#forms)
9. [Semantic HTML](#semantic-html)
10. [HTML5 Features](#html5-features)
11. [Meta Tags and SEO](#meta-tags)
12. [Accessibility](#accessibility)
13. [Best Practices](#best-practices)
14. [Interview Questions](#interview-questions)
15. [Practice Projects](#practice-projects)

---

## 1. Introduction to HTML {#introduction}

### What is HTML?
HTML (HyperText Markup Language) is the standard markup language for creating web pages.

### Basic HTML Document
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My First Page</title>
</head>
<body>
    <h1>Hello World!</h1>
    <p>This is my first HTML page.</p>
</body>
</html>
```

**When to use:** Every web page starts with this basic structure.
**Real-world scenario:** Landing pages, blog posts, e-commerce sites.

---

## 2. HTML Document Structure {#document-structure}

### DOCTYPE Declaration
```html
<!DOCTYPE html>  <!-- Tells browser this is HTML5 -->
```

### HTML Element
```html
<html lang="en">  <!-- Root element with language attribute -->
    <!-- All content goes here -->
</html>
```

### Head Section
```html
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Page description">
    <meta name="keywords" content="html, web, tutorial">
    <meta name="author" content="John Doe">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Title</title>
    <link rel="stylesheet" href="styles.css">
    <script src="script.js"></script>
</head>
```

### Body Section
```html
<body>
    <!-- Visible content goes here -->
    <header>Header content</header>
    <main>Main content</main>
    <footer>Footer content</footer>
</body>
```

**Real-world example:** Every website follows this structure.

---

## 3. Text Elements {#text-elements}

### Headings
```html
<h1>Main Title (Only one per page)</h1>
<h2>Section Title</h2>
<h3>Subsection Title</h3>
<h4>Sub-subsection Title</h4>
<h5>Minor Heading</h5>
<h6>Smallest Heading</h6>
```

### Paragraphs and Text Formatting
```html
<p>This is a paragraph.</p>
<p>This has <strong>bold text</strong> for importance.</p>
<p>This has <em>italic text</em> for emphasis.</p>
<p>This has <mark>highlighted text</mark>.</p>
<p>This has <del>deleted text</del> and <ins>inserted text</ins>.</p>
<p>This has <small>small text</small>.</p>
<p>This has <sub>subscript</sub> and <sup>superscript</sup>.</p>
```

### Preformatted Text and Code
```html
<pre>
    This text
        preserves    spacing
    and line breaks
</pre>

<code>let x = 10;</code>  <!-- Inline code -->

<pre><code>
function hello() {
    console.log("Hello World");
}
</code></pre>  <!-- Code block -->
```

### Quotations
```html
<blockquote cite="https://example.com">
    This is a block quote from another source.
</blockquote>

<p>She said, <q>Hello World!</q></p>  <!-- Inline quote -->

<p><abbr title="World Wide Web">WWW</abbr></p>  <!-- Abbreviation -->
```

**Real-world use cases:**
- Blog posts
- News articles
- Documentation
- Academic papers

---

## 4. Links and Navigation {#links}

### Basic Links
```html
<!-- External link -->
<a href="https://www.google.com">Visit Google</a>

<!-- Internal link -->
<a href="/about.html">About Us</a>

<!-- Email link -->
<a href="mailto:someone@example.com">Send Email</a>

<!-- Phone link -->
<a href="tel:+1234567890">Call Us</a>

<!-- Download link -->
<a href="/files/document.pdf" download>Download PDF</a>

<!-- Open in new tab -->
<a href="https://example.com" target="_blank" rel="noopener">External Site</a>
```

### Anchor Links (Page Navigation)
```html
<!-- Link to section -->
<a href="#section1">Go to Section 1</a>

<!-- Target section -->
<h2 id="section1">Section 1</h2>
```

### Navigation Menu
```html
<nav>
    <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/products">Products</a></li>
        <li><a href="/services">Services</a></li>
        <li><a href="/contact">Contact</a></li>
    </ul>
</nav>
```

**Real-world scenarios:**
- Website navigation
- Table of contents
- Social media links
- Call-to-action buttons

---

## 5. Images and Media {#images-media}

### Images
```html
<!-- Basic image -->
<img src="image.jpg" alt="Description of image">

<!-- Image with dimensions -->
<img src="photo.jpg" alt="Photo" width="500" height="300">

<!-- Responsive image -->
<img src="image.jpg" alt="Description" style="max-width: 100%; height: auto;">

<!-- Image with multiple sources -->
<picture>
    <source media="(min-width: 768px)" srcset="large.jpg">
    <source media="(min-width: 480px)" srcset="medium.jpg">
    <img src="small.jpg" alt="Responsive image">
</picture>
```

### Figure with Caption
```html
<figure>
    <img src="chart.png" alt="Sales Chart">
    <figcaption>Q1 2024 Sales Performance</figcaption>
</figure>
```

### Video
```html
<video width="320" height="240" controls>
    <source src="movie.mp4" type="video/mp4">
    <source src="movie.ogg" type="video/ogg">
    Your browser does not support the video tag.
</video>

<!-- Video with poster -->
<video poster="thumbnail.jpg" controls>
    <source src="video.mp4" type="video/mp4">
</video>
```

### Audio
```html
<audio controls>
    <source src="audio.mp3" type="audio/mpeg">
    <source src="audio.ogg" type="audio/ogg">
    Your browser does not support the audio element.
</audio>
```

### Embedding Content
```html
<!-- YouTube video -->
<iframe width="560" height="315"
        src="https://www.youtube.com/embed/VIDEO_ID"
        frameborder="0"
        allowfullscreen>
</iframe>

<!-- Google Map -->
<iframe src="https://maps.google.com/maps?q=location"
        width="600"
        height="450"
        frameborder="0">
</iframe>
```

**Real-world uses:**
- Product galleries
- Video tutorials
- Podcasts
- Maps and locations

---

## 6. Lists {#lists}

### Unordered List
```html
<ul>
    <li>Apple</li>
    <li>Banana</li>
    <li>Orange</li>
</ul>
```

### Ordered List
```html
<ol>
    <li>First step</li>
    <li>Second step</li>
    <li>Third step</li>
</ol>

<!-- With different numbering -->
<ol type="A">  <!-- A, B, C -->
    <li>Item A</li>
    <li>Item B</li>
</ol>

<ol type="i">  <!-- i, ii, iii -->
    <li>Item i</li>
    <li>Item ii</li>
</ol>
```

### Nested Lists
```html
<ul>
    <li>Frontend
        <ul>
            <li>HTML</li>
            <li>CSS</li>
            <li>JavaScript</li>
        </ul>
    </li>
    <li>Backend
        <ul>
            <li>Node.js</li>
            <li>Python</li>
            <li>Ruby</li>
        </ul>
    </li>
</ul>
```

### Description List
```html
<dl>
    <dt>HTML</dt>
    <dd>HyperText Markup Language</dd>

    <dt>CSS</dt>
    <dd>Cascading Style Sheets</dd>

    <dt>JS</dt>
    <dd>JavaScript</dd>
</dl>
```

**Real-world uses:**
- Navigation menus
- Product features
- Step-by-step instructions
- Glossaries

---

## 7. Tables {#tables}

### Basic Table
```html
<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Age</th>
            <th>City</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>John</td>
            <td>30</td>
            <td>New York</td>
        </tr>
        <tr>
            <td>Jane</td>
            <td>25</td>
            <td>London</td>
        </tr>
    </tbody>
</table>
```

### Complex Table
```html
<table>
    <caption>Sales Report 2024</caption>
    <thead>
        <tr>
            <th rowspan="2">Product</th>
            <th colspan="4">Quarters</th>
            <th rowspan="2">Total</th>
        </tr>
        <tr>
            <th>Q1</th>
            <th>Q2</th>
            <th>Q3</th>
            <th>Q4</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Product A</td>
            <td>$10,000</td>
            <td>$12,000</td>
            <td>$15,000</td>
            <td>$18,000</td>
            <td>$55,000</td>
        </tr>
    </tbody>
    <tfoot>
        <tr>
            <td>Total</td>
            <td>$10,000</td>
            <td>$12,000</td>
            <td>$15,000</td>
            <td>$18,000</td>
            <td>$55,000</td>
        </tr>
    </tfoot>
</table>
```

**Real-world uses:**
- Data reports
- Pricing tables
- Schedules
- Comparison charts

---

## 8. Forms {#forms}

### Basic Form Structure
```html
<form action="/submit" method="POST">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>

    <button type="submit">Submit</button>
</form>
```

### Input Types
```html
<!-- Text inputs -->
<input type="text" placeholder="Enter text">
<input type="password" placeholder="Password">
<input type="email" placeholder="email@example.com">
<input type="tel" placeholder="123-456-7890">
<input type="url" placeholder="https://example.com">
<input type="search" placeholder="Search...">

<!-- Number inputs -->
<input type="number" min="0" max="100" step="5">
<input type="range" min="0" max="100" value="50">

<!-- Date and time -->
<input type="date">
<input type="time">
<input type="datetime-local">
<input type="month">
<input type="week">

<!-- Other inputs -->
<input type="color">
<input type="file" accept="image/*">
<input type="hidden" name="userId" value="123">
```

### Checkboxes and Radio Buttons
```html
<!-- Checkboxes -->
<label>
    <input type="checkbox" name="interests" value="coding"> Coding
</label>
<label>
    <input type="checkbox" name="interests" value="music"> Music
</label>

<!-- Radio buttons -->
<label>
    <input type="radio" name="gender" value="male"> Male
</label>
<label>
    <input type="radio" name="gender" value="female"> Female
</label>
```

### Select Dropdown
```html
<select name="country">
    <option value="">Select a country</option>
    <option value="us">United States</option>
    <option value="uk">United Kingdom</option>
    <option value="ca">Canada</option>
</select>

<!-- Multiple selection -->
<select name="skills" multiple size="4">
    <option value="html">HTML</option>
    <option value="css">CSS</option>
    <option value="js">JavaScript</option>
    <option value="react">React</option>
</select>
```

### Textarea
```html
<textarea name="message" rows="5" cols="30" placeholder="Enter your message..."></textarea>
```

### Fieldset and Legend
```html
<fieldset>
    <legend>Personal Information</legend>
    <label for="fname">First Name:</label>
    <input type="text" id="fname" name="fname">
    <label for="lname">Last Name:</label>
    <input type="text" id="lname" name="lname">
</fieldset>
```

### Complete Contact Form Example
```html
<form action="/contact" method="POST">
    <fieldset>
        <legend>Contact Us</legend>

        <div>
            <label for="name">Full Name:*</label>
            <input type="text" id="name" name="name" required>
        </div>

        <div>
            <label for="email">Email:*</label>
            <input type="email" id="email" name="email" required>
        </div>

        <div>
            <label for="phone">Phone:</label>
            <input type="tel" id="phone" name="phone" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}">
        </div>

        <div>
            <label for="subject">Subject:</label>
            <select id="subject" name="subject">
                <option value="general">General Inquiry</option>
                <option value="support">Technical Support</option>
                <option value="sales">Sales</option>
            </select>
        </div>

        <div>
            <label for="message">Message:*</label>
            <textarea id="message" name="message" rows="5" required></textarea>
        </div>

        <div>
            <label>
                <input type="checkbox" name="newsletter" value="yes">
                Subscribe to newsletter
            </label>
        </div>

        <button type="submit">Send Message</button>
        <button type="reset">Clear Form</button>
    </fieldset>
</form>
```

**Real-world uses:**
- Login/Registration
- Contact forms
- Surveys
- E-commerce checkout
- Search forms

---

## 9. Semantic HTML {#semantic-html}

### Page Structure Elements
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Semantic HTML Example</title>
</head>
<body>
    <header>
        <nav>
            <ul>
                <li><a href="/">Home</a></li>
                <li><a href="/about">About</a></li>
                <li><a href="/contact">Contact</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <article>
            <header>
                <h1>Article Title</h1>
                <p>By <author>John Doe</author> on <time datetime="2024-01-15">January 15, 2024</time></p>
            </header>

            <section>
                <h2>Introduction</h2>
                <p>Article introduction...</p>
            </section>

            <section>
                <h2>Main Content</h2>
                <p>Main content...</p>

                <aside>
                    <h3>Related Information</h3>
                    <p>Side note or related info...</p>
                </aside>
            </section>

            <footer>
                <p>Article footer with tags and share buttons</p>
            </footer>
        </article>
    </main>

    <aside>
        <h2>Sidebar</h2>
        <section>
            <h3>Recent Posts</h3>
            <ul>
                <li><a href="#">Post 1</a></li>
                <li><a href="#">Post 2</a></li>
            </ul>
        </section>
    </aside>

    <footer>
        <p>&copy; 2024 Company Name. All rights reserved.</p>
        <address>
            123 Main St<br>
            City, State 12345<br>
            <a href="mailto:info@company.com">info@company.com</a>
        </address>
    </footer>
</body>
</html>
```

### Semantic Elements Explained
- `<header>` - Page or section header
- `<nav>` - Navigation links
- `<main>` - Main content (only one per page)
- `<article>` - Self-contained content
- `<section>` - Thematic grouping
- `<aside>` - Side content
- `<footer>` - Page or section footer
- `<figure>` - Self-contained media
- `<figcaption>` - Caption for figure
- `<time>` - Date/time
- `<mark>` - Highlighted text
- `<details>` - Expandable details
- `<summary>` - Summary for details

### Details and Summary
```html
<details>
    <summary>Click to expand</summary>
    <p>Hidden content that appears when clicked.</p>
</details>
```

**Benefits of Semantic HTML:**
- Better SEO
- Improved accessibility
- Clearer code structure
- Easier maintenance

---

## 10. HTML5 Features {#html5-features}

### Canvas
```html
<canvas id="myCanvas" width="200" height="100"></canvas>
<script>
    const canvas = document.getElementById('myCanvas');
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = 'red';
    ctx.fillRect(10, 10, 50, 50);
</script>
```

### SVG
```html
<svg width="100" height="100">
    <circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" />
</svg>
```

### Data Attributes
```html
<div data-user-id="123" data-role="admin" data-status="active">
    User Information
</div>

<script>
    // Access in JavaScript
    const div = document.querySelector('div');
    console.log(div.dataset.userId);  // "123"
    console.log(div.dataset.role);    // "admin"
</script>
```

### Progress and Meter
```html
<!-- Progress bar -->
<progress value="32" max="100">32%</progress>

<!-- Meter -->
<meter value="6" min="0" max="10">6 out of 10</meter>
<meter value="0.6">60%</meter>
```

### Dialog
```html
<dialog id="myDialog">
    <h2>Dialog Title</h2>
    <p>This is a dialog box.</p>
    <button onclick="this.parentElement.close()">Close</button>
</dialog>

<button onclick="document.getElementById('myDialog').showModal()">
    Open Dialog
</button>
```

### Web Storage
```html
<script>
    // Local Storage (persists)
    localStorage.setItem('username', 'JohnDoe');
    const username = localStorage.getItem('username');

    // Session Storage (temporary)
    sessionStorage.setItem('tempData', 'value');
    const temp = sessionStorage.getItem('tempData');
</script>
```

---

## 11. Meta Tags and SEO {#meta-tags}

### Essential Meta Tags
```html
<head>
    <!-- Character encoding -->
    <meta charset="UTF-8">

    <!-- Viewport for responsive design -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Page description -->
    <meta name="description" content="Learn HTML from basics to advanced with examples">

    <!-- Keywords -->
    <meta name="keywords" content="HTML, web development, tutorial">

    <!-- Author -->
    <meta name="author" content="John Doe">

    <!-- Robots -->
    <meta name="robots" content="index, follow">

    <!-- Refresh page -->
    <meta http-equiv="refresh" content="30">
</head>
```

### Open Graph Tags (Social Media)
```html
<meta property="og:title" content="Page Title">
<meta property="og:description" content="Page description">
<meta property="og:image" content="https://example.com/image.jpg">
<meta property="og:url" content="https://example.com/page">
<meta property="og:type" content="website">
```

### Twitter Card Tags
```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Page Title">
<meta name="twitter:description" content="Page description">
<meta name="twitter:image" content="https://example.com/image.jpg">
```

### Favicon
```html
<link rel="icon" type="image/x-icon" href="/favicon.ico">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
```

---

## 12. Accessibility {#accessibility}

### ARIA Attributes
```html
<!-- Roles -->
<nav role="navigation">
<main role="main">
<aside role="complementary">

<!-- Labels and descriptions -->
<button aria-label="Close dialog">X</button>
<input aria-describedby="email-help">
<span id="email-help">Enter a valid email address</span>

<!-- States -->
<button aria-pressed="false">Toggle</button>
<div aria-hidden="true">Hidden from screen readers</div>
<nav aria-expanded="false">Menu</nav>

<!-- Live regions -->
<div aria-live="polite">Updates announced to screen readers</div>
<div aria-live="assertive">Urgent updates</div>
```

### Skip Links
```html
<a href="#main-content" class="skip-link">Skip to main content</a>
<nav><!-- Navigation --></nav>
<main id="main-content"><!-- Main content --></main>
```

### Form Accessibility
```html
<form>
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required aria-required="true">

    <fieldset>
        <legend>Choose your favorite color:</legend>
        <label>
            <input type="radio" name="color" value="red">
            Red
        </label>
        <label>
            <input type="radio" name="color" value="blue">
            Blue
        </label>
    </fieldset>
</form>
```

### Image Accessibility
```html
<!-- Informative image -->
<img src="chart.png" alt="Sales increased 50% in Q4 2024">

<!-- Decorative image -->
<img src="decoration.png" alt="" role="presentation">

<!-- Complex image -->
<figure>
    <img src="complex-diagram.png" alt="System Architecture" longdesc="architecture.html">
    <figcaption>
        Detailed system architecture showing all components and connections.
        <a href="architecture.html">Full description</a>
    </figcaption>
</figure>
```

---

## 13. Best Practices {#best-practices}

### 1. Use Semantic HTML
```html
<!-- Good -->
<nav>
    <ul>
        <li><a href="/">Home</a></li>
    </ul>
</nav>

<!-- Bad -->
<div class="navigation">
    <div class="nav-list">
        <div class="nav-item"><a href="/">Home</a></div>
    </div>
</div>
```

### 2. Always Include Alt Text
```html
<!-- Good -->
<img src="product.jpg" alt="Red leather handbag with gold buckle">

<!-- Bad -->
<img src="product.jpg">
```

### 3. Use Proper Heading Hierarchy
```html
<!-- Good -->
<h1>Main Title</h1>
    <h2>Section 1</h2>
        <h3>Subsection 1.1</h3>
    <h2>Section 2</h2>

<!-- Bad -->
<h1>Main Title</h1>
    <h3>Section 1</h3>  <!-- Skipped h2 -->
    <h2>Section 2</h2>
```

### 4. Validate Your HTML
- Use W3C Validator: https://validator.w3.org/
- Fix all errors and warnings

### 5. Optimize for Performance
```html
<!-- Load CSS in head -->
<head>
    <link rel="stylesheet" href="styles.css">
</head>

<!-- Load JS before closing body -->
<body>
    <!-- Content -->
    <script src="script.js"></script>
</body>

<!-- Use lazy loading for images -->
<img src="image.jpg" loading="lazy" alt="Description">
```

### 6. Mobile-First Approach
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Responsive images -->
<picture>
    <source media="(max-width: 600px)" srcset="small.jpg">
    <source media="(max-width: 1200px)" srcset="medium.jpg">
    <img src="large.jpg" alt="Responsive image">
</picture>
```

---

## 14. Interview Questions {#interview-questions}

### Basic Level

1. **What is HTML?**
   - HTML is HyperText Markup Language used to create web pages.

2. **What is the difference between HTML and HTML5?**
   - HTML5 includes new semantic elements, form controls, multimedia elements, and APIs.

3. **What are semantic elements?**
   - Elements that clearly describe their meaning (header, nav, article, section, footer).

4. **What is the difference between `<div>` and `<span>`?**
   - `<div>` is block-level, `<span>` is inline.

5. **What are void elements?**
   - Elements that don't have closing tags: `<br>`, `<img>`, `<input>`, `<hr>`, `<meta>`.

### Intermediate Level

6. **What is the difference between `id` and `class`?**
   - `id` is unique per page, `class` can be reused multiple times.

7. **What are data attributes?**
   - Custom attributes starting with `data-` to store extra information.

8. **Explain the difference between `<strong>` and `<b>`, `<em>` and `<i>`?**
   - `<strong>` and `<em>` have semantic meaning (importance/emphasis), `<b>` and `<i>` are just visual.

9. **What is the purpose of `<!DOCTYPE html>`?**
   - Tells the browser to render the page in standards mode using HTML5.

10. **How do you make a website accessible?**
    - Use semantic HTML, alt text, ARIA labels, proper heading structure, keyboard navigation.

### Advanced Level

11. **What are Web Components?**
    - Custom, reusable HTML elements with encapsulated functionality.

12. **Explain the difference between `localStorage` and `sessionStorage`?**
    - `localStorage` persists until cleared, `sessionStorage` clears when tab closes.

13. **What is the Shadow DOM?**
    - Encapsulated DOM tree attached to an element, isolated from main document.

14. **How do you optimize HTML for SEO?**
    - Use semantic HTML, meta tags, structured data, proper headings, alt text.

15. **What are microdata and structured data?**
    - Ways to add semantic information that search engines can understand.

### Coding Challenges

16. **Create a responsive navigation menu**
```html
<nav>
    <input type="checkbox" id="nav-toggle">
    <label for="nav-toggle" class="burger">☰</label>
    <ul class="nav-menu">
        <li><a href="/">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/services">Services</a></li>
        <li><a href="/contact">Contact</a></li>
    </ul>
</nav>
```

17. **Create an accessible form**
```html
<form role="form" aria-labelledby="form-title">
    <h2 id="form-title">Contact Form</h2>
    <label for="name">Name (required)</label>
    <input type="text" id="name" name="name" required aria-required="true">
    <label for="email">Email (required)</label>
    <input type="email" id="email" name="email" required aria-required="true">
    <button type="submit">Submit</button>
</form>
```

---

## 15. Practice Projects {#practice-projects}

### Project 1: Personal Portfolio (Beginner)
Create a personal portfolio with:
- Home page with introduction
- About section
- Skills list
- Project gallery
- Contact form
- Responsive design

**Skills practiced:** Basic HTML structure, semantic elements, forms, images

### Project 2: Restaurant Website (Intermediate)
Build a restaurant website with:
- Navigation menu
- Hero section with images
- Menu with prices (use tables)
- Reservation form
- Location with embedded map
- Customer reviews
- Photo gallery

**Skills practiced:** Tables, forms, media elements, semantic HTML

### Project 3: Blog Platform (Advanced)
Develop a blog platform with:
- Article listing page
- Individual article pages
- Comment section
- Search functionality
- Categories and tags
- Author profiles
- Social sharing buttons
- RSS feed structure

**Skills practiced:** Semantic HTML, microdata, accessibility, SEO

### Project 4: E-commerce Product Page (Advanced)
Create a product page with:
- Product images with zoom
- Product details
- Size/color selection
- Add to cart form
- Customer reviews
- Related products
- Breadcrumb navigation
- Structured data for rich snippets

**Skills practiced:** Forms, structured data, accessibility, complex layouts

---

## How to Practice

### Daily Practice Routine

1. **Morning (30 mins)**
   - Read one HTML concept
   - Try the examples
   - Modify and experiment

2. **Afternoon (1 hour)**
   - Build a small component
   - Focus on semantic HTML
   - Validate your code

3. **Evening (30 mins)**
   - Review what you learned
   - Answer 5 interview questions
   - Plan tomorrow's practice

### Weekly Goals

**Week 1-2: Basics**
- Master document structure
- Learn all text elements
- Practice with links and images

**Week 3-4: Interactive Elements**
- Master forms
- Learn tables
- Practice lists

**Week 5-6: Advanced Concepts**
- Semantic HTML
- Accessibility
- SEO optimization

**Week 7-8: Projects**
- Complete 2 practice projects
- Focus on best practices
- Get code reviews

### Resources for Practice

1. **Online Playgrounds**
   - CodePen (codepen.io)
   - JSFiddle (jsfiddle.net)
   - CodeSandbox (codesandbox.io)

2. **Validation Tools**
   - W3C Validator
   - WAVE (accessibility checker)
   - Lighthouse (Chrome DevTools)

3. **Learning Platforms**
   - freeCodeCamp
   - MDN Web Docs
   - W3Schools

4. **Challenge Sites**
   - Frontend Mentor
   - DevChallenges
   - CodeWars (HTML challenges)

### Tips for Mastery

1. **Write HTML by hand** - Don't rely on generators
2. **Validate regularly** - Use W3C validator
3. **Think semantic first** - Choose elements based on meaning
4. **Test accessibility** - Use screen readers
5. **Stay updated** - Follow web standards
6. **Review others' code** - Learn from examples
7. **Build real projects** - Practice with purpose

---

## Common Mistakes to Avoid

1. **Using deprecated elements** (`<center>`, `<font>`, `<marquee>`)
2. **Skipping alt text** on images
3. **Using tables for layout** (use CSS Grid/Flexbox)
4. **Not validating HTML**
5. **Ignoring accessibility**
6. **Using inline styles** excessively
7. **Not using semantic elements**
8. **Missing meta viewport** tag
9. **Not closing tags** properly
10. **Using wrong element** for the job

---

## HTML Cheat Sheet

### Essential Tags Quick Reference

```html
<!-- Structure -->
<!DOCTYPE html>, <html>, <head>, <body>

<!-- Head Elements -->
<title>, <meta>, <link>, <script>, <style>

<!-- Text -->
<h1>-<h6>, <p>, <span>, <div>, <br>, <hr>

<!-- Formatting -->
<strong>, <em>, <mark>, <del>, <ins>, <sub>, <sup>

<!-- Links -->
<a href="">, <link>

<!-- Lists -->
<ul>, <ol>, <li>, <dl>, <dt>, <dd>

<!-- Media -->
<img>, <video>, <audio>, <canvas>, <svg>, <picture>

<!-- Tables -->
<table>, <thead>, <tbody>, <tfoot>, <tr>, <th>, <td>

<!-- Forms -->
<form>, <input>, <textarea>, <select>, <option>, <button>

<!-- Semantic -->
<header>, <nav>, <main>, <article>, <section>, <aside>, <footer>

<!-- Interactive -->
<details>, <summary>, <dialog>, <menu>
```

---

## Conclusion

HTML is the foundation of web development. Master these concepts through consistent practice, build real projects, and always focus on:
- Semantic markup
- Accessibility
- Performance
- SEO
- Best practices

Remember: HTML is not just about making things appear on screen, it's about creating structured, meaningful, and accessible content for everyone.

**Next Steps:**
1. Practice daily with the exercises
2. Build the suggested projects
3. Learn CSS to style your HTML
4. Learn JavaScript to add interactivity
5. Keep building and learning!

---

*Last updated: January 2024*
*Keep this guide handy for reference and practice!*