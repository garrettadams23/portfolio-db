-- ============================================================
--  portfolio-db  |  queries/skills.sql
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


-- ============================================================
--  queries/experience.sql
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


-- ============================================================
--  queries/certifications.sql
-- ============================================================

-- ── 1. All active certifications ─────────────────────────────
SELECT name, issuer, issued_date, credential_url
FROM   certifications
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    is_active = TRUE
ORDER  BY sort_order;

-- ── 2. Expiring within 90 days ───────────────────────────────
SELECT name, issuer, expiry_date,
       (expiry_date - CURRENT_DATE) AS days_remaining
FROM   certifications
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    expiry_date IS NOT NULL
AND    expiry_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '90 days'
ORDER  BY expiry_date;

-- ── 3. Certifications by issuer ──────────────────────────────
SELECT issuer, COUNT(*) AS cert_count,
       ARRAY_AGG(name ORDER BY issued_date) AS certs
FROM   certifications
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    is_active = TRUE
GROUP  BY issuer
ORDER  BY cert_count DESC;


-- ============================================================
--  queries/testimonials.sql
-- ============================================================

-- ── 1. All approved testimonials (use view) ──────────────────
SELECT * FROM v_approved_testimonials;

-- ── 2. Average rating ────────────────────────────────────────
SELECT
    ROUND(AVG(rating), 2)       AS avg_rating,
    COUNT(*)                    AS total_reviews,
    COUNT(*) FILTER (WHERE rating = 5) AS five_star
FROM   testimonials
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    approved = TRUE;

-- ── 3. Pending approval ──────────────────────────────────────
SELECT id, author_name, body, rating, created_at
FROM   testimonials
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    approved = FALSE
ORDER  BY created_at DESC;

-- ── 4. Rating distribution ───────────────────────────────────
SELECT rating, COUNT(*) AS count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM   testimonials
WHERE  profile_id = '00000000-0000-0000-0000-000000000001'
AND    approved = TRUE
GROUP  BY rating
ORDER  BY rating DESC;


-- ============================================================
--  queries/contacts.sql
-- ============================================================

-- ── 1. All unread enquiries ───────────────────────────────────
SELECT id, name, email, company, service_type, submitted_at
FROM   contacts
WHERE  read = FALSE
ORDER  BY submitted_at DESC;

-- ── 2. Unreplied messages ─────────────────────────────────────
SELECT id, name, email, service_type, message, submitted_at
FROM   contacts
WHERE  replied = FALSE
AND    archived = FALSE
ORDER  BY submitted_at DESC;

-- ── 3. Enquiries by service type ─────────────────────────────
SELECT service_type::TEXT, COUNT(*) AS enquiry_count
FROM   contacts
GROUP  BY service_type
ORDER  BY enquiry_count DESC;

-- ── 4. This month's enquiries ────────────────────────────────
SELECT name, email, service_type, submitted_at
FROM   contacts
WHERE  submitted_at >= DATE_TRUNC('month', NOW())
ORDER  BY submitted_at DESC;

-- ── 5. Mark as read (template) ───────────────────────────────
-- UPDATE contacts SET read = TRUE WHERE id = $1;

-- ── 6. Mark as replied (template) ────────────────────────────
-- UPDATE contacts SET replied = TRUE, read = TRUE WHERE id = $1;


-- ============================================================
--  queries/analytics.sql
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
    COUNT(*)                          AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct,
    ARRAY_AGG(name ORDER BY name)     AS skills
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
    TO_CHAR(DATE_TRUNC('month', submitted_at), 'Mon YYYY') AS month,
    COUNT(*)                                                AS enquiries,
    COUNT(*) FILTER (WHERE replied = TRUE)                  AS replied
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
