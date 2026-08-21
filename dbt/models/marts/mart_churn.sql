-- ============================================================
-- MART — CHURN
-- ============================================================
--
-- Purpose:
--   Analysis-ready user-level dataset for approved user-level
--   Churn hypotheses.
--
-- Grain:
--   One row per user.
--
-- Business outcome:
--   churn_flag is consumed from int_churn.
--
-- Analytical variables:
--   Failed/declined transaction behaviour is sourced from
--   int_user_activity.
--   Country is sourced from int_user_profile.
--
-- The Mart does not recreate Churn logic.
--
-- ============================================================

select

    p.user_id,

    -- Business outcome
    c.churn_flag,

    -- Analytical variables
    a.failed_declined_transactions,
    p.country

from {{ ref('int_user_profile') }} as p

left join {{ ref('int_user_activity') }} as a
    on p.user_id = a.user_id

left join {{ ref('int_churn') }} as c
    on p.user_id = c.user_id
