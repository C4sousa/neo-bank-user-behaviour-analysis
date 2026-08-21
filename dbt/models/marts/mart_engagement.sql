{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

-- ============================================================
-- MART — ENGAGEMENT
-- ============================================================
--
-- Purpose:
--   Analysis-ready user-level dataset for approved Engagement
--   hypotheses.
--
-- Grain:
--   One row per user.
--
-- Business outcome:
--   engagement_flag is consumed from int_engagement.
--
-- Analytical variables:
--   Transaction, notification and merchant activity are sourced
--   from int_user_activity.
--   Profile attributes are sourced from int_user_profile.
--
-- The Mart does not recreate Engagement logic.
-- ============================================================

select
    e.user_id,

    -- Business outcome
    e.engagement_flag,

    -- Analytical variables
    a.transaction_frequency,
    a.notification_frequency,
    a.merchant_spending_category,
    a.activity_period,

    p.crypto_adoption,
    p.plan_segment,
    p.country

from {{ ref('int_engagement') }} as e

left join {{ ref('int_user_activity') }} as a
    on e.user_id = a.user_id

left join {{ ref('int_user_profile') }} as p
    on e.user_id = p.user_id
