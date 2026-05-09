-- ============================================================
--  portfolio-db  |  queries/testimonials.sql
--  SELECT query library — testimonials table
-- ============================================================

-- ── 1. All approved testimonials (use view) ──────────────────
SELECT * FROM v_approved_testimonials;

-- ── 2. Average rating ────────────────────────────────────────
SELECT
    ROUND(AVG(rating), 2)                          AS avg_rating,
    COUNT(*)                                        AS total_reviews,
    COUNT(*) FILTER (WHERE rating = 5)             AS five_star
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
