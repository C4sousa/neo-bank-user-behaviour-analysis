-- ============================================================
-- MART: CHURN BY TRANSACTION TYPE
-- ============================================================
-- Grain: 1 row per user x transaction_type
--
-- Purpose:
-- Analysis-ready dataset for Transaction Type -> Churn.
--
-- churn_flag is a user-level outcome repeated across the
-- user's transaction-type rows.
-- ============================================================

{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

select
    t.user_id,
    t.transaction_type,
    t.transaction_count,
    t.transaction_share,
    c.churn_flag

from {{ ref('int_user_transaction_types') }} as t

left join {{ ref('int_churn') }} as c
    on t.user_id = c.user_id
