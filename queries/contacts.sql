-- ============================================================
--  portfolio-db  |  queries/contacts.sql
--  SELECT query library — contacts table
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
