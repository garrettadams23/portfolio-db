-- ============================================================
--  portfolio-db  |  seed.sql
--  Sample data for local dev and Neon Console testing
--  Run after schema.sql
-- ============================================================

-- ────────────────────────────────────────────────────────────
--  PROFILE
-- ────────────────────────────────────────────────────────────
INSERT INTO profiles (
    id, name, title, bio, email, phone, location,
    avatar_url, github_url, linkedin_url, portfolio_url, open_to_work
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Garrett Adams',
    'IT Professional & Cybersecurity Student',
    'CompTIA-certified IT professional with hands-on experience in server infrastructure, '
    'network administration, and cybersecurity. Currently pursuing advanced certifications '
    'while running an independent IT services business. I build things — from full-stack web '
    'apps to tiered server management services — and I automate everything I can.',
    'garrett@myitguy.netlify.app',
    NULL,
    'United States',
    'https://avatars.githubusercontent.com/garrettadams23',
    'https://github.com/garrettadams23',
    'https://linkedin.com/in/garrettadams23',
    'https://myitguy.netlify.app',
    TRUE
);

-- ────────────────────────────────────────────────────────────
--  SKILLS
-- ────────────────────────────────────────────────────────────
INSERT INTO skills (profile_id, name, category, proficiency, years_exp, sort_order) VALUES
-- Languages
('00000000-0000-0000-0000-000000000001', 'JavaScript',   'language',    'advanced',      3, 1),
('00000000-0000-0000-0000-000000000001', 'Python',        'language',    'intermediate',  2, 2),
('00000000-0000-0000-0000-000000000001', 'Bash/Shell',    'language',    'advanced',      4, 3),
('00000000-0000-0000-0000-000000000001', 'PowerShell',    'language',    'advanced',      4, 4),
('00000000-0000-0000-0000-000000000001', 'SQL',           'language',    'advanced',      3, 5),
('00000000-0000-0000-0000-000000000001', 'HTML/CSS',      'language',    'advanced',      4, 6),
-- Frameworks
('00000000-0000-0000-0000-000000000001', 'React',         'framework',   'advanced',      2, 10),
('00000000-0000-0000-0000-000000000001', 'Node.js',       'framework',   'intermediate',  2, 11),
('00000000-0000-0000-0000-000000000001', 'Tailwind CSS',  'framework',   'advanced',      2, 12),
-- Databases
('00000000-0000-0000-0000-000000000001', 'PostgreSQL',    'database',    'advanced',      3, 20),
('00000000-0000-0000-0000-000000000001', 'Neon Console',  'database',    'intermediate',  1, 21),
('00000000-0000-0000-0000-000000000001', 'SQLite',        'database',    'intermediate',  2, 22),
-- Cloud & Hosting
('00000000-0000-0000-0000-000000000001', 'Netlify',       'cloud',       'advanced',      2, 30),
('00000000-0000-0000-0000-000000000001', 'GitHub Actions','cloud',       'intermediate',  2, 31),
-- Tools
('00000000-0000-0000-0000-000000000001', 'Git',           'tool',        'advanced',      4, 40),
('00000000-0000-0000-0000-000000000001', 'Docker',        'tool',        'intermediate',  2, 41),
('00000000-0000-0000-0000-000000000001', 'VS Code',       'tool',        'expert',        5, 42),
-- Security
('00000000-0000-0000-0000-000000000001', 'Wireshark',     'security',    'intermediate',  2, 50),
('00000000-0000-0000-0000-000000000001', 'Nmap',          'security',    'intermediate',  2, 51),
('00000000-0000-0000-0000-000000000001', 'CIS Benchmarks','security',    'advanced',      3, 52),
-- Networking
('00000000-0000-0000-0000-000000000001', 'pfSense',       'networking',  'intermediate',  2, 60),
('00000000-0000-0000-0000-000000000001', 'TCP/IP',        'networking',  'advanced',      5, 61),
-- OS
('00000000-0000-0000-0000-000000000001', 'Linux (Ubuntu/Debian)', 'os', 'advanced',      4, 70),
('00000000-0000-0000-0000-000000000001', 'Windows Server','os',          'advanced',      4, 71);

-- ────────────────────────────────────────────────────────────
--  CERTIFICATIONS
-- ────────────────────────────────────────────────────────────
INSERT INTO certifications (profile_id, name, issuer, issued_date, is_active, sort_order) VALUES
('00000000-0000-0000-0000-000000000001', 'CompTIA A+',        'CompTIA', '2022-06-01', TRUE, 1),
('00000000-0000-0000-0000-000000000001', 'CompTIA Network+',  'CompTIA', '2023-01-01', TRUE, 2),
('00000000-0000-0000-0000-000000000001', 'CompTIA Security+', 'CompTIA', '2023-09-01', TRUE, 3);

-- ────────────────────────────────────────────────────────────
--  EXPERIENCE
-- ────────────────────────────────────────────────────────────
INSERT INTO experience (
    profile_id, company, role, location, employment_type,
    start_date, end_date, is_current, description, highlights, sort_order
) VALUES
(
    '00000000-0000-0000-0000-000000000001',
    'My IT Guy', 'Owner & IT Consultant', 'Remote', 'Freelance',
    '2022-01-01', NULL, TRUE,
    'Independent IT services business providing infrastructure management, cybersecurity, '
    'web development, and technical support to small businesses.',
    ARRAY[
        'Designed tiered server management service with profit-percentage pricing model',
        'Built and deployed client-facing portfolio site on Netlify',
        'Implemented CIS Benchmark hardening on client Windows Server and Linux systems',
        'Developed AI-powered client reporting portal using Anthropic API'
    ],
    1
),
(
    '00000000-0000-0000-0000-000000000001',
    'Self-Directed Study', 'Cybersecurity Student', 'Remote', 'Part-time',
    '2023-01-01', NULL, TRUE,
    'Pursuing advanced CompTIA certifications and hands-on cybersecurity training '
    'via TryHackMe, HackTheBox, and structured self-study.',
    ARRAY[
        'Completed Security+ certification',
        'Active TryHackMe labs — penetration testing and blue team tracks',
        'Studying CySA+ curriculum; CIS Benchmark and STIG implementation'
    ],
    2
),
(
    '00000000-0000-0000-0000-000000000001',
    'Previous Employer', 'IT Support Technician', 'On-site', 'Full-time',
    '2020-06-01', '2021-12-31', FALSE,
    'Tier 1/2 helpdesk and on-site technical support for a mid-size organization.',
    ARRAY[
        'Managed desktop imaging and deployment for 50+ workstations',
        'Handled ticketing system and escalation workflows',
        'Assisted with network troubleshooting and VLAN documentation'
    ],
    3
);

-- ────────────────────────────────────────────────────────────
--  PROJECTS
-- ────────────────────────────────────────────────────────────
INSERT INTO projects (
    id, profile_id, title, slug, description, long_description,
    tech_stack, github_url, live_url, featured, status, sort_order
) VALUES
(
    '10000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    'Nexus Dashboard',
    'nexus-dashboard',
    'Personal productivity command center integrating Gmail, Google Calendar, Google Tasks, '
    'and AI chat via the Anthropic API with MCP server connections.',
    'A full-featured personal productivity dashboard built in React. The AI assistant '
    'has live access to Gmail, Calendar, and Drive through MCP server connections. '
    'Features a morning briefing panel, multi-turn AI chat with context, Gmail inbox '
    'reader with AI summaries, calendar event viewer, and task management.',
    ARRAY['React','Anthropic API','MCP','Gmail MCP','Calendar MCP'],
    'https://github.com/garrettadams23/nexus-dashboard',
    NULL, TRUE, 'active', 1
),
(
    '10000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000001',
    'Server Management Service',
    'server-management-service',
    'Tiered IT server management service for small businesses with profit-percentage pricing.',
    'A fully documented IT service product with three tiers (Starter, Growth, Pro), '
    'each with a one-time setup fee and a monthly maintenance fee tied to a percentage '
    'of the client''s net profit. Includes pricing guide, scope of work, onboarding '
    'process, and service agreement template.',
    ARRAY['Documentation','GitHub','Markdown'],
    'https://github.com/garrettadams23/server-management-service',
    NULL, TRUE, 'active', 2
),
(
    '10000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000001',
    'Client Reporting Portal',
    'client-reporting-portal',
    'AI-powered monthly profit reporting portal for server management clients.',
    'A React app for clients to submit monthly net profit figures which auto-calculates '
    'their maintenance fee, generates an AI-written financial insight note, and produces '
    'an invoice preview. Features animated number transitions, tier selection, and full '
    'submission history.',
    ARRAY['React','Anthropic API','JavaScript'],
    'https://github.com/garrettadams23/server-management-service',
    NULL, TRUE, 'active', 3
),
(
    '10000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000001',
    'Portfolio DB',
    'portfolio-db',
    'Normalized PostgreSQL schema for the myitguy portfolio site, hosted on Neon Console.',
    'A fully normalized relational schema with 9 tables, 6 views, foreign key constraints, '
    'GIN full-text search indexes, custom ENUMs, and a complete SELECT query library '
    'organized by table. Demonstrates real-world database design patterns.',
    ARRAY['PostgreSQL','SQL','Neon Console'],
    'https://github.com/garrettadams23/portfolio-db',
    NULL, TRUE, 'active', 4
),
(
    '10000000-0000-0000-0000-000000000005',
    '00000000-0000-0000-0000-000000000001',
    'My IT Guy Portfolio Site',
    'myitguy-portfolio',
    'Personal IT portfolio and business landing page deployed on Netlify.',
    'The public-facing portfolio and business site for Garrett Adams IT. Built with '
    'HTML, CSS, and vanilla JavaScript. Showcases services, projects, certifications, '
    'and includes a contact form.',
    ARRAY['HTML','CSS','JavaScript','Netlify'],
    'https://github.com/garrettadams23/myitguy-portfolio',
    'https://myitguy.netlify.app', FALSE, 'active', 5
),
(
    '10000000-0000-0000-0000-000000000006',
    '00000000-0000-0000-0000-000000000001',
    'GitHub Profile',
    'github-profile',
    'Animated GitHub profile README with live stats, contribution snake, WakaTime, and CI/CD workflows.',
    'A fully automated GitHub profile README using capsule-render, typing SVG, '
    'github-readme-stats, streak stats, activity graph, and four GitHub Actions workflows '
    'for the contribution snake, activity feed, WakaTime coding stats, and metrics.',
    ARRAY['Markdown','GitHub Actions','YAML','SVG'],
    'https://github.com/garrettadams23/garrettadams23',
    'https://github.com/garrettadams23', FALSE, 'active', 6
);

-- ────────────────────────────────────────────────────────────
--  PROJECT TAGS
-- ────────────────────────────────────────────────────────────
INSERT INTO project_tags (project_id, tag) VALUES
('10000000-0000-0000-0000-000000000001', 'AI'),
('10000000-0000-0000-0000-000000000001', 'React'),
('10000000-0000-0000-0000-000000000001', 'MCP'),
('10000000-0000-0000-0000-000000000002', 'IT Services'),
('10000000-0000-0000-0000-000000000002', 'Documentation'),
('10000000-0000-0000-0000-000000000002', 'Business'),
('10000000-0000-0000-0000-000000000003', 'AI'),
('10000000-0000-0000-0000-000000000003', 'React'),
('10000000-0000-0000-0000-000000000003', 'Fintech'),
('10000000-0000-0000-0000-000000000004', 'PostgreSQL'),
('10000000-0000-0000-0000-000000000004', 'Database'),
('10000000-0000-0000-0000-000000000004', 'Neon'),
('10000000-0000-0000-0000-000000000005', 'Web'),
('10000000-0000-0000-0000-000000000005', 'Netlify'),
('10000000-0000-0000-0000-000000000005', 'Portfolio'),
('10000000-0000-0000-0000-000000000006', 'GitHub'),
('10000000-0000-0000-0000-000000000006', 'CI/CD'),
('10000000-0000-0000-0000-000000000006', 'Automation');

-- ────────────────────────────────────────────────────────────
--  TESTIMONIALS
-- ────────────────────────────────────────────────────────────
INSERT INTO testimonials (profile_id, author_name, author_title, author_company, body, rating, approved, sort_order)
VALUES
(
    '00000000-0000-0000-0000-000000000001',
    'Sarah M.', 'Small Business Owner', 'Maple Street Bakery',
    'Garrett set up our server and got our backups running properly for the first time. '
    'He explained everything clearly and we''ve had zero downtime since. Highly recommend.',
    5, TRUE, 1
),
(
    '00000000-0000-0000-0000-000000000001',
    'Tom R.', 'Operations Manager', 'RightWay Logistics',
    'We needed someone who could handle both the technical side and communicate with '
    'non-technical staff. Garrett nailed both. The server management service has been '
    'worth every penny.',
    5, TRUE, 2
),
(
    '00000000-0000-0000-0000-000000000001',
    'Dana K.', 'Freelance Designer', NULL,
    'Helped me set up a proper dev environment and sorted out my backup situation. '
    'Fast, clear, and didn''t talk down to me. Will use again.',
    4, TRUE, 3
);

-- ────────────────────────────────────────────────────────────
--  CONTACTS
-- ────────────────────────────────────────────────────────────
INSERT INTO contacts (name, email, company, service_type, message, read, replied)
VALUES
(
    'James T.', 'james@example.com', 'TechStart LLC',
    'server_management',
    'Hi Garrett, we have 3 servers and are looking for ongoing management. '
    'Can we set up a call to discuss the Growth tier?',
    TRUE, TRUE
),
(
    'Rachel B.', 'rachel@example.com', NULL,
    'web_development',
    'I''d like a quote for a portfolio website similar to yours. '
    'What does that typically run?',
    FALSE, FALSE
);
