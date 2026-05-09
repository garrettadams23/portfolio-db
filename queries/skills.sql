-- ============================================================
--  portfolio-db  |  queries/skills.sql
--  SELECT query library — skills table
-- ============================================================

-- ── 1. All skills grouped by category (use view) ─────────────
SELECT * FROM v_skills_by_category
WHERE  profile_id = '00000000-0000-0000-0000-000000000001';

-- ── 2. All skills ordered for display ────────────────────────
SELECT name, category, proficiency, years_exp
FROM   skills
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
ORDER  BY sort_order;

-- ── 3. Top skills by proficiency ─────────────────────────────
SELECT name, category, proficiency, years_exp
FROM   skills
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    proficiency IN ('expert','advanced')
ORDER  BY
    CASE proficiency WHEN 'expert' THEN 1 WHEN 'advanced' THEN 2 END,
    years_exp DESC;

-- ── 4. Skills count per category ─────────────────────────────
SELECT category::TEXT, COUNT(*) AS count
FROM   skills
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
GROUP  BY category
ORDER  BY count DESC;

-- ── 5. Security-specific skills ──────────────────────────────
SELECT name, proficiency, years_exp
FROM   skills
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    category = 'security'
ORDER  BY sort_order;
