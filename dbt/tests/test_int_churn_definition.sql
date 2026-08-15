-- ============================================================
-- LEVEL 2 — CHURN DEFINITION TEST
-- ============================================================
--
-- Business definition:
--   A user is classified as churned when 90 consecutive days
--   have passed since their most recent successful transaction,
--   provided the dataset has reached that date.
--
--   Each subsequent successful transaction resets the
--   90-day inactivity clock.
--
--   Users without a successful transaction are not classified
--   as churned because there is no last successful transaction
--   date from which to calculate inactivity.
--
-- A passing test returns zero rows.
-- ============================================================


with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),


last_successful_transaction as (

    select
        user_id,
        max(date(created_at)) as last_successful_transaction_date

    from {{ ref('stg_transactions') }}

    where transaction_state = 'COMPLETED'

    group by
        user_id

),


expected_churn as (

    select
        u.user_id,

        case
            when l.last_successful_transaction_date is null
                then false

            when date_diff(
                date(a.analysis_date),
                l.last_successful_transaction_date,
                day
            ) >= 90
                then true

            else false

        end as expected_churn_flag

    from {{ ref('stg_users') }} as u

    cross join analysis_date as a

    left join last_successful_transaction as l
        on u.user_id = l.user_id

),


model_output as (

    select
        user_id,
        churn_flag

    from {{ ref('int_churn') }}

)


select
    e.user_id,
    e.expected_churn_flag,
    m.churn_flag

from expected_churn as e

inner join model_output as m
    on e.user_id = m.user_id

where
    e.expected_churn_flag != m.churn_flag
