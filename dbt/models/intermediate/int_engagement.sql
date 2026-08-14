-- ============================================================
-- USER ENGAGEMENT
-- ============================================================
--
-- Purpose:
-- Represent whether the user meets the approved Engagement
-- definition.
--
-- Grain:
-- One row per user.
--
-- Business logic:
-- At least one successful transaction in 3 of the previous
-- 4 completed calendar weeks before the analysis date.
--
-- ============================================================


with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),


-- ============================================================
-- SUCCESSFUL TRANSACTIONS
-- ============================================================

successful_transactions as (

    select
        t.user_id,

        date(t.created_at) as transaction_date

    from {{ ref('stg_transactions') }} as t

    where
        t.transaction_state = 'COMPLETED'

),


-- ============================================================
-- ENGAGEMENT
-- ============================================================
--
-- A user is Engaged when they have at least one successful
-- transaction in 3 of the previous 4 completed calendar weeks
-- before the analysis date.
--
-- ============================================================

engagement as (

    select
        u.user_id,

        count(
            distinct date_trunc(
                s.transaction_date,
                week (monday)
            )
        ) >= 3 as engagement_flag

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

)


-- ============================================================
-- FINAL USER ENGAGEMENT MODEL
-- ============================================================

select

    user_id,

    engagement_flag

from engagement
