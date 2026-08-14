-- ============================================================
-- LEVEL 2 — RETENTION FLAG SANITY TEST
-- ============================================================

select
    user_id

from {{ ref('int_retention') }}

where retention_flag is null
