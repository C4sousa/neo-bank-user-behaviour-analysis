-- ============================================================
-- MART — RETENTION
-- ============================================================
--
-- Purpose:
--   Analysis-ready dataset for Retention hypotheses.
--
-- Grain:
--   One row per user.
--
-- KPI logic is calculated in int_user_retention.
-- This Mart combines the Retention outcome with the
-- analytical variables required for downstream analysis.
--
-- ============================================================

select

    r.user_id,

    -- --------------------------------------------------------
    -- RETENTION OUTCOME
    -- --------------------------------------------------------

    r.retention_flag,

    -- --------------------------------------------------------
    -- BEHAVIOURAL VARIABLES
    -- --------------------------------------------------------

    a.transaction_frequency_30d,

    a.notification_frequency_30d,

    -- --------------------------------------------------------
    -- USER PROFILE VARIABLES
    -- --------------------------------------------------------

    p.crypto_adoption,

    p.plan_segment,

    p.country

from {{ ref('int_user_retention') }} as r

left join {{ ref('int_user_activity') }} as a
    on r.user_id = a.user_id

left join {{ ref('int_user_profile') }} as p
    on r.user_id = p.user_id
