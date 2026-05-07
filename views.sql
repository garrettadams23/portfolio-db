-- ============================================================
--  portfolio-db  |  views.sql
--  6 reusable views for the portfolio application
--  Run after schema.sql and seed.sql
-- ============================================================

-- ────────────────────────────────────────────────────────────
--  v_featured_projects
--  Featured projects with aggregated tag arrays
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW v_featured_projects AS
SELECT
    p.id,
    p.title,
    p.slug,
    p.description,
    p.tech_stack,
    p.github_url,
    p.live_url,
    p.thumbnail_url,
    p.status,
    p.sort_order,
    COALESCE(
        ARRAY_AGG(pt.tag ORDER BY pt.tag) FILTER (WHERE pt.tag IS NOT NULL),
        ARRAY[]::TEXT[]
    ) AS tags
FROM   projects p
LEFT JOIN project_tags pt ON pt.project_id = p.id
WHERE  p.featured = TRUE
AND    p.status != 'archived'
GROUP  BY p.id
ORDER  BY p.sort_order ASC;

-- ────────────────────────────────────────────────────────────
--  v_project_summary
--  All non-archived projects with tags, ordered for display
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW v_project_summary AS
SELECT
    p.id,
    p.title,
    p.slug,
    p.description,
    p.tech_stack,
    p.github_url,
    p.live_url,
    p.featured,
    p.status,
    p.sort_order,
    p.created_at,
    COALESCE(
        ARRAY_AGG(pt.tag ORDER BY pt.tag) FILTER (WHERE pt.tag IS NOT NULL),
        ARRAY[]::TEXT[]
    ) AS tags,
    ARRAY_LENGTH(p.tech_stack, 1) AS tech_count
FROM   projects p
LEFT JOIN project_tags pt ON pt.project_id = p.id
WHERE  p.status != 'archived'
GROUP  BY p.id
ORDER  BY p.featured DESC, p.sort_order ASC;

-- ────────────────────────────────────────────────────────────
--  v_full_profile
--  Complete profile with aggregated counts for the homepage
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW v_full_profile AS
SELECT
    pr.id,
    pr.name,
    pr.title,
    pr.bio,
    pr.email,
    pr.location,
    pr.avatar_url,
    pr.github_url,
    pr.linkedin_url,
    pr.portfolio_url,
    pr.open_to_work,
    pr.updated_at,
    (SELECT COUNT(*) FROM skills       s WHERE s.profile_id = pr.id)               AS skill_count,
    (SELECT COUNT(*) FROM projects     p WHERE p.profile_id = pr.id
                                           AND p.status != 'archived')             AS project_count,
    (SELECT COUNT(*) FROM certifications c WHERE c.profile_id = pr.id
                                             AND c.is_active = TRUE)               AS cert_count,
    (SELECT COUNT(*) FROM experience   e WHERE e.profile_id = pr.id
                                           AND e.is_current = TRUE)                AS current_roles,
    (SELECT COUNT(*) FROM testimonials t WHERE t.profile_id = pr.id
                                           AND t.approved = TRUE)                  AS testimonial_count
FROM profiles pr;

-- ────────────────────────────────────────────────────────────
--  v_skills_by_category
--  Skills grouped by category with aggregated names array
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW v_skills_by_category AS
SELECT
    profile_id,
    category::TEXT                                             AS category,
    COUNT(*)::INT                                              AS skill_count,
    ARRAY_AGG(name ORDER BY sort_order, name)                  AS skill_names,
    ARRAY_AGG(proficiency::TEXT ORDER BY sort_order, name)     AS proficiencies,
    ROUND(AVG(COALESCE(years_exp, 0)), 1)                      AS avg_years_exp
FROM   skills
GROUP  BY profile_id, category
ORDER  BY category;

-- ────────────────────────────────────────────────────────────
--  v_career_timeline
--  Work history sorted newest-first, with duration calculation
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW v_career_timeline AS
SELECT
    e.id,
    e.profile_id,
    e.company,
    e.role,
    e.location,
    e.employment_type,
    e.start_date,
    e.end_date,
    e.is_current,
    e.description,
    e.highlights,
    -- Formatted duration string
    CASE
        WHEN e.is_current THEN
            EXTRACT(YEAR FROM AGE(NOW(), e.start_date))::INT || 'y ' ||
            EXTRACT(MONTH FROM AGE(NOW(), e.start_date))::INT || 'm (current)'
        ELSE
            EXTRACT(YEAR FROM AGE(e.end_date, e.start_date))::INT || 'y ' ||
            EXTRACT(MONTH FROM AGE(e.end_date, e.start_date))::INT || 'm'
    END AS duration_label,
    -- Total months
    CASE
        WHEN e.is_current THEN
            EXTRACT(EPOCH FROM AGE(NOW(), e.start_date)) / 2592000
        ELSE
            EXTRACT(EPOCH FROM AGE(e.end_date, e.start_date)) / 2592000
    END::INT AS duration_months
FROM experience e
ORDER BY
    e.is_current DESC,
    e.start_date DESC;

-- ────────────────────────────────────────────────────────────
--  v_approved_testimonials
--  Approved testimonials with safe HTML-ready fields
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW v_approved_testimonials AS
SELECT
    t.id,
    t.author_name,
    t.author_title,
    t.author_company,
    t.author_avatar,
    t.body,
    t.rating,
    -- Star string for template rendering
    REPEAT('★', t.rating) || REPEAT('☆', 5 - t.rating) AS star_display,
    t.sort_order,
    t.created_at,
    -- Byline for display
    CONCAT_WS(', ',
        t.author_title,
        t.author_company
    ) AS byline
FROM testimonials t
WHERE t.approved = TRUE
ORDER BY t.sort_order ASC, t.rating DESC;
