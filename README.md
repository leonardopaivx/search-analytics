# Search Analytics

A lightweight Rails 8 application that tracks what users type in a realtime search box, compresses those keystrokes into meaningful **search terms**, and presents an **analytics dashboard** with top terms and anonymized visitor rankings.

> **Stack**: Rails 8 (no Hotwire), Importmap + vanilla JS, Tailwind CSS, PostgreSQL, RSpec.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)

  - [Domain Models](#domain-models)
  - [Search Flow](#search-flow)
  - [Analytics Dashboard](#analytics-dashboard)

- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)

  - [Requirements](#requirements)
  - [Local Setup (Ruby/Rails)](#local-setup-rubyrails)
  - [Assets / Tailwind](#assets--tailwind)

- [Testing](#testing)
- [Deployment](#deployment)
- [API/Endpoints](#apiendpoints)
- [Security Notes](#security-notes)
- [Roadmap / Ideas](#roadmap--ideas)

---

## Features

- **Realtime search** with debounce (vanilla JS + `navigator.sendBeacon` fallback to `fetch`).
- **Event ingestion/compression**: raw key events are stored only when marked as `final`; then compressed into unique `SearchTerm` rows with occurrence counters.
- **Analytics dashboard** (desktop-first) showing:

  - Top search terms (table + chart)
  - Top visitors by volume and diversity of terms
  - Terms most searched per visitor

- **Anon visitors**: each `VisitorSession` gets a random, human-readable `display_name` (e.g., "Blue Fox").
- **Rails 8 + Importmap**: no bundler, no Hotwire, just vanilla ES modules.
- **TailwindCSS** styling, responsive grid, scrollable tables with sticky headers.
- **RSpec test suite** with FactoryBot.

---

## Architecture

### Domain Models

| Model            | Purpose                                                      |
| ---------------- | ------------------------------------------------------------ |
| `VisitorSession` | Anonymous session identified by cookie; holds `display_name` |
| `SearchEvent`    | A keystroke snapshot (`query`, `typed_at`, `final`)          |
| `SearchTerm`     | Compressed term with `occurences`, timestamps                |
| `Article`        | Example searchable resource (title/content)                  |

### Search Flow

1. User types in the search input.
2. JS sends lightweight events:

   - immediate `final: false` (low cost) via `sendBeacon`/`fetch`.
   - after debounce, a `final: true` event.

3. The service `SearchEvents::Ingest` persists only final events and calls `SearchTermCompressor`.
4. `SearchTermCompressor` finds the **longest query** in a short idle window and upserts a `SearchTerm` (incrementing occurrence if it exists).

### Analytics Dashboard

- Service aggregates with SQL (`GROUP BY`, `SUM`) over the last selected period (24h/7d/30d).
- Chart.js renders a bar chart of top terms.
- Tables are scrollable with fixed heights; desktop grid (12 cols) distributes cards side-by-side.

---

## Tech Stack

- **Ruby/Rails**: Rails 8.0.2, Ruby 3.4.x
- **DB**: PostgreSQL
- **Front-end**: Tailwind CSS (via `tailwindcss-rails`), vanilla JS modules + Importmap
- **Charts**: Chart.js (pinned via importmap)
- **Testing**: RSpec, FactoryBot

---

## Getting Started

### Requirements

- Ruby 3.4+
- PostgreSQL 13+
- Node _not required_ (Importmap)

### Local Setup (Ruby/Rails)

```bash
git clone https://github.com/leonardopaivx/search-analytics.git
cd search-analytics
bundle install
bin/rails db:setup # creates, migrates, seeds
bin/rails s
```

Visit: `http://localhost:3000`

### Assets / Tailwind

During development, run the Tailwind watcher:

```bash
bin/rails tailwind:watch
```

Or use `./bin/dev` if you rely on Procfile.dev (foreman/overmind).

---

## Testing

```bash
bundle exec rspec
```

- Factories live in `spec/factories`.

---

## Deployment

The app is live on Heroku: https://search-analytics-prod-cfb31f9c3526.herokuapp.com/

---

## API/Endpoints

| Method | Path                    | Purpose                         |
| ------ | ----------------------- | ------------------------------- |
| GET    | `/search`               | Return JSON results for query   |
| POST   | `/search_events`        | Ingest search event (JSON body) |
| GET    | `/analytics/terms`      | Dashboard HTML                  |
| GET    | `/analytics/terms.json` | JSON for charts/tables          |
| GET    | `/articles/:id`         | Show article                    |

Payload example for `/search_events`:

```json
{
  "query": "hello world",
  "final": true
}
```

---

## Security Notes

- CSRF: for `sendBeacon`, we skip CSRF check on `create` or rely on JSON authenticity token header when using `fetch`.
- Data minimization: only final queries are persisted (avoid DB pollution).
- Visitor anonymity: random `display_name` avoids storing PII.

---

## Roadmap / Ideas

- Implement a proper relevance ranking algorithm for document search (e.g., TF-IDF, Okapi BM25, cosine similarity over TF-IDF vectors, embedding-based retrieval with ANN indexes such as FAISS/pgvector/Elasticsearch).
- Pagination / filters in dashboard (by visitor, by term).
- Export analytics as CSV.
- Add authentication for the dashboard.
- Rate limit or debounce server-side.
- Optional GeoIP (country/city) if privacy policy allows.
