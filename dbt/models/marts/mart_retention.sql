{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

-- ============================================================
-- MART — RETENTION
-- ============================================================
--
-- Purpose:
--   Analysis-ready user-level dataset for approved Retention
--   hypotheses.
--
-- Grain:
--   One row per user.
--
-- Business outcome:
--   retention_flag is consumed from int_retention.
--
-- Analytical variables:
--   Transaction and notification activity are sourced from
--   int_user_activity.
--   Profile attributes are sourced from int_user_profile.
--
-- The Mart does not recreate Retention logic.
-- ============================================================

select
    r.user_id,

    -- Business outcome
    r.retention_flag,

    -- Analytical variables
    a.transaction_frequency,
    a.notification_frequency,

    p.crypto_adoption,
    p.plan_segment

from {{ ref('int_retention') }} as r

left join {{ ref('int_user_activity') }} as a
    on r.user_id = a.user_id

left join {{ ref('int_user_profile') }} as p
    on r.user_id = p.user_id
