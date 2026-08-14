-- ============================================================
-- MART — CHURN
-- ============================================================
--
-- Purpose:
--   Analysis-ready dataset for user-level Churn hypotheses.
--
-- Grain:
--   One row per user.
--
-- KPI logic is calculated in int_user_churn.
-- This Mart combines the Churn outcome with the
-- analytical variables required for downstream analysis.
--
-- ============================================================

select

    c.user_id,

    -- --------------------------------------------------------
    -- CHURN OUTCOME
    -- --------------------------------------------------------

    c.churn_flag,

    -- --------------------------------------------------------
    -- BEHAVIOURAL VARIABLES
    -- --------------------------------------------------------

    a.failed_declined_transactions_30d,

    -- --------------------------------------------------------
    -- USER PROFILE VARIABLES
    -- --------------------------------------------------------

    p.country

from {{ ref('int_user_churn') }} as c

left join {{ ref('int_user_activity') }} as a
    on c.user_id = a.user_id

left join {{ ref('int_user_profile') }} as p
    on c.user_id = p.user_id
