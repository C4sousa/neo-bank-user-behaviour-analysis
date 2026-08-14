-- ============================================================
-- MART: CHURN
-- ============================================================
-- Grain: 1 row per user
--
-- Purpose:
-- Analysis-ready dataset for user-level Churn hypotheses.
-- ============================================================

{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

select
    c.user_id,
    c.churn_flag,

    -- Behavioural variable
    a.failed_declined_transactions_30d,

    -- Profile variable
    p.country

from {{ ref('int_churn') }} as c

left join {{ ref('int_user_activity') }} as a
    on c.user_id = a.user_id

left join {{ ref('int_user_profile') }} as p
    on c.user_id = p.user_id
