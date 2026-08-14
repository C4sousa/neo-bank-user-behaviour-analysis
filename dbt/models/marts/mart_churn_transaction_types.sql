-- ============================================================
-- MART — CHURN BY TRANSACTION TYPE
-- ============================================================
--
-- Purpose:
--   Analysis-ready dataset for Churn by transaction type.
--
-- Grain:
--   One row per user × transaction type.
--
-- Transaction-type behaviour is sourced from
-- int_user_transaction_types.
--
-- Churn is sourced from int_user_churn.
--
-- ============================================================

select

    t.user_id,

    t.transaction_type,

    t.transaction_count,

    t.transaction_share,

    -- --------------------------------------------------------
    -- CHURN OUTCOME
    -- --------------------------------------------------------

    c.churn_flag

from {{ ref('int_user_transaction_types') }} as t

left join {{ ref('int_user_churn') }} as c
    on t.user_id = c.user_id
