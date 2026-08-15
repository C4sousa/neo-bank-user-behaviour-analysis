-- ============================================================
-- SUCCESSFUL TRANSACTION EVENTS
-- ============================================================
--
-- Purpose:
--   Represent successful transaction events in a reusable
--   event-level model for downstream business KPI logic.
--
-- Grain:
--   One row per successful transaction.
--
-- Successful transaction:
--   Transaction with transaction_state = 'COMPLETED'.
--
-- Temporal attributes:
--   transaction_date  = calendar date of the transaction
--   transaction_week  = Monday-based calendar week
--   transaction_month = calendar month
--
-- This model provides the reusable successful transaction
-- events required by Engagement, Retention and Churn.
--
-- ============================================================

select

    transaction_id,

    user_id,

    date(created_at) as transaction_date,

    date_trunc(
        date(created_at),
        week(monday)
    ) as transaction_week,

    date_trunc(
        date(created_at),
        month
    ) as transaction_month

from {{ ref('stg_transactions') }}

where transaction_state = 'COMPLETED'
