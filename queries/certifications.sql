-- ============================================================
--  portfolio-db  |  queries/certifications.sql
--  SELECT query library — certifications table
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
