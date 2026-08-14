-- ============================================================
-- LEVEL 2 — RETENTION FLAG SANITY TEST
-- ============================================================

select
    user_id

from {{ ref('int_user_retention') }}

where retention_flag is null
