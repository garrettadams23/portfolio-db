-- ============================================================
--  portfolio-db  |  queries/profiles.sql
--  SELECT query library — profiles table
-- ============================================================

-- ── 1. Get full profile by email ─────────────────────────────
SELECT * FROM profiles
WHERE  email = 'garrett@myitguy.netlify.app';

-- ── 2. Get profile with all counts (use view) ────────────────
SELECT * FROM v_full_profile;

-- ── 3. Check open to work status ─────────────────────────────
SELECT id, name, open_to_work
FROM   profiles
WHERE  open_to_work = TRUE;

-- ── 4. Get social links only ─────────────────────────────────
SELECT name, github_url, linkedin_url, portfolio_url
FROM   profiles
WHERE  id = '00000000-0000-0000-0000-000000000001';
