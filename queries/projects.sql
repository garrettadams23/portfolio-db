-- ============================================================
--  portfolio-db  |  queries/projects.sql
--  SELECT query library — projects table
-- ============================================================

-- ── 1. All featured projects (use view) ──────────────────────
SELECT * FROM v_featured_projects;

-- ── 2. All non-archived projects with tags ───────────────────
SELECT * FROM v_project_summary;

-- ── 3. Single project by slug ────────────────────────────────
SELECT
    p.*,
    COALESCE(
        ARRAY_AGG(pt.tag ORDER BY pt.tag) FILTER (WHERE pt.tag IS NOT NULL),
        ARRAY[]::TEXT[]
    ) AS tags
FROM   projects p
LEFT JOIN project_tags pt ON pt.project_id = p.id
WHERE  p.slug = 'nexus-dashboard'
GROUP  BY p.id;

-- ── 4. Projects by tech stack item ───────────────────────────
SELECT id, title, slug, tech_stack
FROM   projects
WHERE  'React' = ANY(tech_stack)
AND    status != 'archived'
ORDER  BY sort_order;

-- ── 5. Full-text search on title + description ───────────────
SELECT id, title, slug,
       ts_rank(
           to_tsvector('english', coalesce(title,'') || ' ' || coalesce(description,'')),
           plainto_tsquery('english', 'AI dashboard')
       ) AS rank
FROM   projects
WHERE  to_tsvector('english', coalesce(title,'') || ' ' || coalesce(description,''))
       @@ plainto_tsquery('english', 'AI dashboard')
ORDER  BY rank DESC;

-- ── 6. Projects by tag ───────────────────────────────────────
SELECT p.id, p.title, p.slug
FROM   projects p
JOIN   project_tags pt ON pt.project_id = p.id
WHERE  pt.tag = 'AI'
AND    p.status != 'archived'
ORDER  BY p.sort_order;

-- ── 7. All unique tags (for filter UI) ───────────────────────
SELECT DISTINCT tag
FROM   project_tags
ORDER  BY tag;

-- ── 8. Tag frequency ─────────────────────────────────────────
SELECT tag, COUNT(*) AS project_count
FROM   project_tags
GROUP  BY tag
ORDER  BY project_count DESC, tag;

-- ── 9. Projects with live URL ────────────────────────────────
SELECT id, title, slug, live_url
FROM   projects
WHERE  live_url IS NOT NULL
AND    status = 'active'
ORDER  BY sort_order;

-- ── 10. Recently updated projects ────────────────────────────
SELECT id, title, slug, updated_at
FROM   projects
WHERE  status != 'archived'
ORDER  BY updated_at DESC
LIMIT  5;
