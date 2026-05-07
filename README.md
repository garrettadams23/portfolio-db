<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,40:0f2027,100:0d1117&height=180&section=header&text=portfolio-db&fontSize=44&fontColor=38bdf8&fontAlignY=40&desc=PostgreSQL%20Schema%20%7C%20Neon%20Console%20%7C%20IT%20Portfolio%20Data%20Layer&descAlignY=60&descSize=15" width="100%"/>

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-316192?style=for-the-badge&logo=postgresql&logoColor=white)](#)
[![Neon](https://img.shields.io/badge/Neon_Console-Serverless_Postgres-00E5BC?style=for-the-badge)](#)
[![Status](https://img.shields.io/badge/Status-Active-22c55e?style=for-the-badge)](#)
[![Tables](https://img.shields.io/badge/Tables-9-38bdf8?style=for-the-badge)](#)
[![Views](https://img.shields.io/badge/Views-6-8b5cf6?style=for-the-badge)](#)

</div>

---

## 📐 What Is This?

The data layer for [myitguy.netlify.app](https://myitguy.netlify.app) — a fully normalized PostgreSQL schema hosted on [Neon Console](https://neon.tech) (serverless Postgres). This repo documents the schema, seed data, views, and a complete SELECT query library used by the portfolio application.

Built to showcase real-world relational database design: proper normalization, foreign key constraints, computed views, and a clean query library organized by concern.

---

## 🗂️ Schema Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        portfolio-db schema                          │
│                                                                     │
│  ┌──────────────┐      ┌───────────────────┐    ┌───────────────┐  │
│  │   profiles   │      │     projects      │    │    skills     │  │
│  │─────────────│      │───────────────────│    │───────────────│  │
│  │ id (PK)     │◄─┐   │ id (PK)           │    │ id (PK)       │  │
│  │ name        │  │   │ profile_id (FK) ──┘    │ profile_id(FK)│  │
│  │ title       │  │   │ title             │    │ name          │  │
│  │ bio         │  └───│ description       │    │ category      │  │
│  │ email       │      │ tech_stack        │    │ proficiency   │  │
│  │ location    │      │ github_url        │    └───────────────┘  │
│  │ avatar_url  │      │ live_url          │                       │
│  │ created_at  │      │ featured          │    ┌───────────────┐  │
│  └──────────────┘      │ status            │    │ certifications│  │
│                        │ sort_order        │    │───────────────│  │
│  ┌──────────────┐      └───────────────────┘    │ id (PK)       │  │
│  │  experience  │                               │ profile_id(FK)│  │
│  │─────────────│      ┌───────────────────┐    │ name          │  │
│  │ id (PK)     │      │  project_tags     │    │ issuer        │  │
│  │ profile_id  │      │───────────────────│    │ issued_date   │  │
│  │ company     │      │ project_id (FK)   │    │ credential_id │  │
│  │ role        │      │ tag               │    │ badge_url     │  │
│  │ start_date  │      └───────────────────┘    └───────────────┘  │
│  │ end_date    │                                                   │
│  │ description │      ┌───────────────────┐    ┌───────────────┐  │
│  │ is_current  │      │   testimonials    │    │   contacts    │  │
│  └──────────────┘      │───────────────────│    │───────────────│  │
│                        │ id (PK)           │    │ id (PK)       │  │
│                        │ profile_id (FK)   │    │ name          │  │
│                        │ author_name       │    │ email         │  │
│                        │ author_title      │    │ message       │  │
│                        │ body              │    │ service_type  │  │
│                        │ rating            │    │ submitted_at  │  │
│                        │ approved          │    │ read          │  │
│                        └───────────────────┘    └───────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Repository Structure

```
portfolio-db/
├── README.md
├── schema.sql           ← Full DDL — tables, constraints, indexes
├── seed.sql             ← Sample data for all tables
├── views.sql            ← 6 reusable views
└── queries/
    ├── profiles.sql     ← Profile queries
    ├── projects.sql     ← Project queries
    ├── skills.sql       ← Skills queries
    ├── experience.sql   ← Work history queries
    ├── certifications.sql
    ├── testimonials.sql
    ├── contacts.sql     ← Contact form queries
    └── analytics.sql    ← Cross-table analytics queries
```

---

## 🚀 Setup on Neon Console

```bash
# 1. Create a new Neon project at https://neon.tech
# 2. Copy your connection string (Settings → Connection Details)
# 3. Run in order:

psql $DATABASE_URL -f schema.sql
psql $DATABASE_URL -f seed.sql
psql $DATABASE_URL -f views.sql
```

Or run each file in the Neon SQL Editor directly.

---

## 📊 Views Available

| View | Description |
|------|-------------|
| `v_featured_projects` | Featured projects with their tag arrays |
| `v_full_profile` | Complete profile with aggregated skill count and project count |
| `v_project_summary` | All projects with tag arrays and status |
| `v_skills_by_category` | Skills grouped and aggregated by category |
| `v_career_timeline` | Experience sorted chronologically, current role flagged |
| `v_approved_testimonials` | Approved testimonials with rating |

---

## 🔢 Quick Stats

| Table | Seed Rows |
|-------|-----------|
| profiles | 1 |
| projects | 6 |
| project_tags | 18 |
| skills | 24 |
| experience | 4 |
| certifications | 3 |
| testimonials | 3 |
| contacts | 2 |

---

<div align="center">
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,40:0f2027,100:0d1117&height=80&section=footer" width="100%"/>

*PostgreSQL on Neon Console · Built by [Garrett Adams](https://myitguy.netlify.app)*
</div>
