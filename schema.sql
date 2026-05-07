-- ============================================================
--  portfolio-db  |  schema.sql
--  Full DDL for myitguy.netlify.app data layer
--  PostgreSQL 16 / Neon Console compatible
-- ============================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";   -- for fuzzy text search

-- ────────────────────────────────────────────────────────────
--  PROFILES
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS profiles (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            VARCHAR(100) NOT NULL,
    title           VARCHAR(150) NOT NULL,
    bio             TEXT,
    email           VARCHAR(255) UNIQUE NOT NULL,
    phone           VARCHAR(30),
    location        VARCHAR(100),
    avatar_url      TEXT,
    github_url      TEXT,
    linkedin_url    TEXT,
    portfolio_url   TEXT,
    resume_url      TEXT,
    open_to_work    BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ────────────────────────────────────────────────────────────
--  SKILLS
-- ────────────────────────────────────────────────────────────
CREATE TYPE skill_category AS ENUM (
    'language',
    'framework',
    'database',
    'cloud',
    'tool',
    'security',
    'networking',
    'os'
);

CREATE TYPE proficiency_level AS ENUM (
    'beginner',
    'intermediate',
    'advanced',
    'expert'
);

CREATE TABLE IF NOT EXISTS skills (
    id              UUID             PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id      UUID             NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name            VARCHAR(100)     NOT NULL,
    category        skill_category   NOT NULL,
    proficiency     proficiency_level NOT NULL DEFAULT 'intermediate',
    years_exp       SMALLINT         CHECK (years_exp >= 0 AND years_exp <= 50),
    sort_order      SMALLINT         NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_skills_profile    ON skills(profile_id);
CREATE INDEX idx_skills_category   ON skills(category);

-- ────────────────────────────────────────────────────────────
--  CERTIFICATIONS
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS certifications (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id      UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name            VARCHAR(150) NOT NULL,
    issuer          VARCHAR(100) NOT NULL,
    issued_date     DATE,
    expiry_date     DATE,
    credential_id   VARCHAR(100),
    credential_url  TEXT,
    badge_url       TEXT,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    sort_order      SMALLINT    NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_certs_profile ON certifications(profile_id);

-- ────────────────────────────────────────────────────────────
--  EXPERIENCE  (work history)
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS experience (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id      UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    company         VARCHAR(150) NOT NULL,
    role            VARCHAR(150) NOT NULL,
    location        VARCHAR(100),
    employment_type VARCHAR(50) DEFAULT 'Full-time',  -- Full-time, Part-time, Contract, Freelance
    start_date      DATE        NOT NULL,
    end_date        DATE,                              -- NULL = current role
    is_current      BOOLEAN     NOT NULL DEFAULT FALSE,
    description     TEXT,
    highlights      TEXT[],                            -- array of bullet points
    sort_order      SMALLINT    NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE INDEX idx_exp_profile   ON experience(profile_id);
CREATE INDEX idx_exp_current   ON experience(is_current) WHERE is_current = TRUE;

-- ────────────────────────────────────────────────────────────
--  PROJECTS
-- ────────────────────────────────────────────────────────────
CREATE TYPE project_status AS ENUM (
    'active',
    'completed',
    'archived',
    'in_progress'
);

CREATE TABLE IF NOT EXISTS projects (
    id              UUID           PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id      UUID           NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title           VARCHAR(150)   NOT NULL,
    slug            VARCHAR(150)   UNIQUE NOT NULL,
    description     TEXT,
    long_description TEXT,
    tech_stack      TEXT[],        -- e.g. ARRAY['React','PostgreSQL','Netlify']
    github_url      TEXT,
    live_url        TEXT,
    thumbnail_url   TEXT,
    featured        BOOLEAN        NOT NULL DEFAULT FALSE,
    status          project_status NOT NULL DEFAULT 'active',
    sort_order      SMALLINT       NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_projects_profile  ON projects(profile_id);
CREATE INDEX idx_projects_featured ON projects(featured) WHERE featured = TRUE;
CREATE INDEX idx_projects_status   ON projects(status);
CREATE INDEX idx_projects_slug     ON projects(slug);

-- Full-text search on project title + description
CREATE INDEX idx_projects_fts ON projects
    USING GIN (to_tsvector('english', coalesce(title,'') || ' ' || coalesce(description,'')));

-- ────────────────────────────────────────────────────────────
--  PROJECT TAGS  (many-to-one normalised tags)
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS project_tags (
    project_id  UUID        NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    tag         VARCHAR(50) NOT NULL,
    PRIMARY KEY (project_id, tag)
);

CREATE INDEX idx_project_tags_tag ON project_tags(tag);

-- ────────────────────────────────────────────────────────────
--  TESTIMONIALS
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS testimonials (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id      UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    author_name     VARCHAR(100) NOT NULL,
    author_title    VARCHAR(150),
    author_company  VARCHAR(150),
    author_avatar   TEXT,
    body            TEXT        NOT NULL,
    rating          SMALLINT    CHECK (rating BETWEEN 1 AND 5),
    approved        BOOLEAN     NOT NULL DEFAULT FALSE,
    sort_order      SMALLINT    NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_testimonials_profile  ON testimonials(profile_id);
CREATE INDEX idx_testimonials_approved ON testimonials(approved) WHERE approved = TRUE;

-- ────────────────────────────────────────────────────────────
--  CONTACTS  (portfolio contact form submissions)
-- ────────────────────────────────────────────────────────────
CREATE TYPE service_interest AS ENUM (
    'it_support',
    'server_management',
    'web_development',
    'cybersecurity',
    'consulting',
    'other'
);

CREATE TABLE IF NOT EXISTS contacts (
    id              UUID             PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            VARCHAR(100)     NOT NULL,
    email           VARCHAR(255)     NOT NULL,
    company         VARCHAR(150),
    phone           VARCHAR(30),
    service_type    service_interest NOT NULL DEFAULT 'other',
    message         TEXT             NOT NULL,
    budget_range    VARCHAR(50),
    read            BOOLEAN          NOT NULL DEFAULT FALSE,
    replied         BOOLEAN          NOT NULL DEFAULT FALSE,
    archived        BOOLEAN          NOT NULL DEFAULT FALSE,
    ip_address      INET,
    submitted_at    TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_contacts_read     ON contacts(read)  WHERE read = FALSE;
CREATE INDEX idx_contacts_replied  ON contacts(replied) WHERE replied = FALSE;
CREATE INDEX idx_contacts_service  ON contacts(service_type);
CREATE INDEX idx_contacts_email    ON contacts(email);

-- ────────────────────────────────────────────────────────────
--  UPDATED_AT triggers
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_projects_updated_at
    BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
