-- ============================================================
-- LEVEL 2 — ENGAGEMENT DEFINITION TEST
-- ============================================================
--
-- Business definition:
--   User completes at least one successful transaction
--   in 3 of the previous 4 weeks before the analysis date.
--
-- This test independently recalculates the approved
-- 3-of-4-week rule and compares it with the model output.
--
-- A passing test returns zero rows.
--
-- ============================================================


with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),


successful_transactions as (

    select
        user_id,

        date(created_at) as transaction_date

    from {{ ref('stg_transactions') }}

    where transaction_state = 'COMPLETED'

),


expected_engagement as (

    select
        u.user_id,

        count(
            distinct date_trunc(
                s.transaction_date,
                week (monday)
            )
        ) >= 3 as expected_engagement_flag

    from {{ ref('stg_users') }} as u

    cross join analysis_date as a

    left join successful_transactions as s
        on
            u.user_id = s.user_id

            and date_trunc(
                s.transaction_date,
                week (monday)
            ) between
                date_sub(
                    date_trunc(
                        date(a.analysis_date),
                        week (monday)
                    ),
                    interval 4 week
                )

                and date_sub(
                    date_trunc(
                        date(a.analysis_date),
                        week (monday)
                    ),
                    interval 1 week
                )

    group by
        u.user_id

),


model_output as (

    select
        user_id,
        engagement_flag

    from {{ ref('int_user_engagement') }}

)


select
    e.user_id,
    e.expected_engagement_flag,
    m.engagement_flag

from expected_engagement as e

inner join model_output as m
    on e.user_id = m.user_id

where
    e.expected_engagement_flag != m.engagement_flag
