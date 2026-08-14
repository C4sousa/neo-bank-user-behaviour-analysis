-- ============================================================
-- MART: ENGAGEMENT
-- ============================================================
-- Grain: 1 row per user
--
-- Purpose:
-- Analysis-ready dataset for Engagement hypotheses.
--
-- Contains:
--   - Engagement KPI
--   - Behavioural variables
--   - Profile variables
--   - Time / geographic dimensions
-- ============================================================

{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

select
    e.user_id,
    e.engagement_flag,

    -- Behavioural variables
    a.transaction_frequency_30d,
    a.notification_frequency_30d,
    a.merchant_spending_category,
    a.activity_period,

    -- Profile variables
    p.crypto_adoption,
    p.plan_segment,
    p.country

from {{ ref('int_engagement') }} as e

left join {{ ref('int_user_activity') }} as a
    on e.user_id = a.user_id

left join {{ ref('int_user_profile') }} as p
    on e.user_id = p.user_id
