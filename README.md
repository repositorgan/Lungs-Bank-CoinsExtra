# Lungs-Bank-CoinsExtra

CoinsExtra is a unified digital wallet that consolidates cash, credit, investments, identity documents, and insurance into a single, secure platform. 

## Guide 

> Lungs-Bank-CoinsExtra/MVP

>> Lungs-Bank-CoinsExtra/MVP/apps

>>> Lungs-Bank-CoinsExtra/MVP/apps/web

>>>> Lungs-Bank-CoinsExtra/MVP/apps/web/src

>>>> Lungs-Bank-CoinsExtra/MVP/apps/web/index.html

>>> Lungs-Bank-CoinsExtra/MVP/apps/api

>>>> Lungs-Bank-CoinsExtra/MVP/apps/api/src

>>>>> Lungs-Bank-CoinsExtra/MVP/apps/api/src/index.ts

>>>> Lungs-Bank-CoinsExtra/MVP/apps/api/wrangler.toml

>> Lungs-Bank-CoinsExtra/MVP/packages

>>> Lungs-Bank-CoinsExtra/MVP/packages/db-schema  # SQL + migrations

>>> Lungs-Bank-CoinsExtra/MVP/packages/shared-types # Shared TS types

>> Lungs-Bank-CoinsExtra/MVP/docs

> Lungs-Bank-CoinsExtra/README.md

**Pardon my dust**

Lungs-Bank-CoinsExtra/MVP/README.md
      ├── apps/
      │   ├── web/                # Frontend (Cloudflare Pages)
      │   │   ├── src/
      │   │   │   ├── pages/
      │   │   │   ├── components/
      │   │   │   ├── services/   # API calls
      │   │   │   └── state/
      │   │   └── index.html
      │   │
      │   └── api/                # Backend (Cloudflare Workers)
      │       ├── src/
      │       │   ├── routes/
      │       │   ├── middleware/
      │       │   ├── db/
      │       │   └── index.ts
      │       └── wrangler.toml
      │
      ├── packages/
      │   ├── db-schema/          # SQL + migrations
      │   └── shared-types/       # Shared TS types
      │
      ├── docs/
      │   ├── pitch.md
      │   ├── erd.md
      │   └── api-spec.md
      │
      └── README.md

## Roadmap

> Phase 1: Data & Auth First

>> Step 1: Implement your database in Cloudflare D1

>> Step 2: Backend API (Workers) Create minimal, boring endpoints.

> Phase 2: Frontend Screens

> Phase 3: Tech Coins Logic

> Phase 4: Market Data
