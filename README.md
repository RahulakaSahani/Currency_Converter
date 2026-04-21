# Currency Exchange Studio

A polished Java Servlet + JSP currency converter project built with an industry-style structure:
- presentation layer (`CurrencyServlet`, `index.jsp`)
- service layer (`CurrencyService`)
- API client abstraction (`CurrencyApiClient`)
- unit tests (`CurrencyServiceTest`)

## Final Experience

When you open the app, you get:
- a modern hero section with animated gradient background
- a responsive glassmorphism conversion panel
- real-time form validation feedback
- conversion output with direct exchange-rate detail
- a rate dashboard that displays all supported currencies

This turns a simple assignment into a portfolio-friendly app.

## Features

- Web form conversion: `/convert`
- REST-style API endpoint: `/api/convert?amount=100&from=USD&to=INR`
- Validation for empty, invalid, negative, and unsupported inputs
- Unit tests with JUnit 5

## Run Locally

### Quick Start (No External Tomcat)

Run the app directly with the embedded main class:

```bash
mvn clean compile exec:java
```

Then open:

```text
http://localhost:8080/
```

1. Build project:

```bash
mvn clean package
```

2. Deploy generated WAR from:

```text
target/currency-exchange-app.war
```

3. Open app:

```text
http://localhost:8080/currency-exchange-app/
```

4. Test API endpoint:

```text
http://localhost:8080/currency-exchange-app/api/convert?amount=100&from=USD&to=INR
```

## Resume-ready Talking Points

- Designed and implemented multi-layer Java web application using Servlet/JSP architecture.
- Built currency conversion business logic with input validation and deterministic rate processing.
- Implemented REST-style endpoint for programmatic conversion support.
- Added unit tests to verify conversion logic and validation behavior.

## Publish to GitHub

1. Install Git.
2. Create an empty repository in GitHub (for example: `currency-exchange-studio`).
3. Run these commands from the project folder:

```bash
git init
git add .
git commit -m "Initial portfolio-ready currency exchange project"
git branch -M main
git remote add origin https://github.com/<your-username>/currency-exchange-studio.git
git push -u origin main
```

## Deploy Free on Render (Manual)

This project includes `render.yaml` for easy setup.

1. Push this project to GitHub.
2. Sign in to Render and click **New +** -> **Blueprint**.
3. Connect your GitHub account and select this repository.
4. Render detects `render.yaml` and creates a Docker-based web service.
5. Click **Apply** to create the service.
6. After deploy finishes, open the generated Render URL.

Notes:
- The app auto-reads Render's `PORT` environment variable.
- The service root directory is already configured as `currency-exchange-app`.
- For Docker runtime, Render uses `CMD` from `Dockerfile` (no separate Start Command needed).
