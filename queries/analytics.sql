-- ============================================================
--  portfolio-db  |  queries/analytics.sql
--  Cross-table aggregation queries for admin dashboard
-- ============================================================

-- ── 1. Full portfolio summary dashboard ──────────────────────
SELECT
    (SELECT COUNT(*) FROM projects     WHERE status != 'archived')  AS active_projects,
    (SELECT COUNT(*) FROM projects     WHERE featured = TRUE)        AS featured_projects,
    (SELECT COUNT(*) FROM skills)                                    AS total_skills,
    (SELECT COUNT(*) FROM certifications WHERE is_active = TRUE)    AS active_certs,
    (SELECT COUNT(*) FROM testimonials   WHERE approved = TRUE)     AS approved_testimonials,
    (SELECT ROUND(AVG(rating),2)
     FROM testimonials WHERE approved = TRUE)                        AS avg_rating,
    (SELECT COUNT(*) FROM contacts WHERE read = FALSE)              AS unread_contacts,
    (SELECT COUNT(*) FROM contacts WHERE replied = FALSE
                                    AND archived = FALSE)           AS pending_replies;

-- ── 2. Tech stack frequency across all projects ──────────────
SELECT tech, COUNT(*) AS usage_count
FROM   projects, UNNEST(tech_stack) AS tech
WHERE  status != 'archived'
GROUP  BY tech
ORDER  BY usage_count DESC, tech;

-- ── 3. Most used tags ────────────────────────────────────────
SELECT pt.tag, COUNT(*) AS project_count
FROM   project_tags pt
JOIN   projects p ON p.id = pt.project_id
WHERE  p.status != 'archived'
GROUP  BY pt.tag
ORDER  BY project_count DESC
LIMIT  10;

-- ── 4. Skills proficiency breakdown ──────────────────────────
SELECT
    proficiency::TEXT,
    COUNT(*)                                                    AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1)          AS pct,
    ARRAY_AGG(name ORDER BY name)                               AS skills
FROM   skills
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
GROUP  BY proficiency
ORDER  BY
    CASE proficiency
        WHEN 'expert'       THEN 1
        WHEN 'advanced'     THEN 2
        WHEN 'intermediate' THEN 3
        WHEN 'beginner'     THEN 4
    END;

-- ── 5. Contact volume by month ───────────────────────────────
SELECT
    TO_CHAR(DATE_TRUNC('month', submitted_at), 'Mon YYYY')     AS month,
    COUNT(*)                                                    AS enquiries,
    COUNT(*) FILTER (WHERE replied = TRUE)                      AS replied
FROM   contacts
GROUP  BY DATE_TRUNC('month', submitted_at)
ORDER  BY DATE_TRUNC('month', submitted_at) DESC
LIMIT  12;

-- ── 6. Projects per status ───────────────────────────────────
SELECT status::TEXT, COUNT(*) AS count
FROM   projects
GROUP  BY status
ORDER  BY count DESC;

-- ── 7. Skill coverage by category for radar chart ────────────
SELECT
    category::TEXT,
    COUNT(*)                AS skill_count,
    MAX(years_exp)          AS max_years,
    ROUND(AVG(
        CASE proficiency
            WHEN 'expert'       THEN 4
            WHEN 'advanced'     THEN 3
            WHEN 'intermediate' THEN 2
            WHEN 'beginner'     THEN 1
        END
    ), 2)                   AS avg_proficiency_score
FROM   skills
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
GROUP  BY category
ORDER  BY avg_proficiency_score DESC;
