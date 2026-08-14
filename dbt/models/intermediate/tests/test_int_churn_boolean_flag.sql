-- ============================================================
-- LEVEL 2 — CHURN FLAG SANITY TEST
-- ============================================================

select
    user_id

from {{ ref('int_churn') }}

where churn_flag is null
