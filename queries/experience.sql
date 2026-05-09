-- ============================================================
--  portfolio-db  |  queries/experience.sql
--  SELECT query library — experience table
-- ============================================================

-- ── 1. Full career timeline (use view) ───────────────────────
SELECT * FROM v_career_timeline
WHERE  profile_id = '00000000-0000-0000-0000-000000000001';

-- ── 2. Current roles only ────────────────────────────────────
SELECT company, role, start_date, duration_label
FROM   v_career_timeline
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    is_current = TRUE;

-- ── 3. Total years of professional experience ────────────────
SELECT ROUND(SUM(duration_months) / 12.0, 1) AS total_years
FROM   v_career_timeline
WHERE  profile_id = '00000000-0000-0000-0000-000000000001';

-- ── 4. Experience with highlights unpacked ───────────────────
SELECT company, role, UNNEST(highlights) AS highlight
FROM   experience
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
ORDER  BY start_date DESC;

-- ── 5. Freelance / contract roles ────────────────────────────
SELECT company, role, start_date, end_date, is_current
FROM   experience
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    employment_type IN ('Freelance','Contract')
ORDER  BY start_date DESC;
