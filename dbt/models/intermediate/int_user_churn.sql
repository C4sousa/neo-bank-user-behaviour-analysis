-- ============================================================
-- USER CHURN
-- ============================================================
--
-- Purpose:
--   Represent the user's approved Churn business outcome.
--
-- Grain:
--   One row per user.
--
-- Churn:
--   90 consecutive days without a successful transaction
--   results in Churn.
--
--   The 90-day observation period must exist.
--
--   Every successful transaction resets the 90-day clock.
--
-- The KPI is calculated independently from the other
-- Level 2 business logic models.
--
-- ============================================================

with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),

last_successful_activity as (

    select
        user_id,

        max(
            date(created_at)
        ) as last_successful_transaction_date

    from {{ ref('stg_transactions') }}

    where transaction_state = 'COMPLETED'

    group by
        user_id

)

select
    u.user_id,

    coalesce(
        date_diff(
            date(a.analysis_date),
            l.last_successful_transaction_date,
            day
        ) >= 90,
        false
    ) as churn_flag

from {{ ref('stg_users') }} as u

cross join analysis_date as a

left join last_successful_activity as l
    on u.user_id = l.user_id
