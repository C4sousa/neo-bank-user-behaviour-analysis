-- ============================================================
-- MART: RETENTION
-- ============================================================
-- Grain: 1 row per user
--
-- Purpose:
-- Analysis-ready dataset for Retention hypotheses.
-- ============================================================

{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

select
    r.user_id,
    r.retention_flag,

    -- Behavioural variables
    a.transaction_frequency_30d,
    a.notification_frequency_30d,

    -- Profile variables
    p.crypto_adoption,
    p.plan_segment

from {{ ref('int_retention') }} as r

left join {{ ref('int_user_activity') }} as a
    on r.user_id = a.user_id

left join {{ ref('int_user_profile') }} as p
    on r.user_id = p.user_id
