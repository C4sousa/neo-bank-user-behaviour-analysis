-- ============================================================
-- USER ENGAGEMENT
-- ============================================================
--
-- Purpose:
--   Represent whether the user meets the approved Engagement
--   business definition.
--
-- Grain:
--   One row per user.
--
-- Engagement:
--   At least one successful transaction in 3 of the previous
--   4 completed calendar weeks before the analysis date.
--
-- Successful transaction event logic is provided by:
--   int_successful_transaction_events
--
-- ============================================================


with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),


-- ============================================================
-- ENGAGEMENT
-- ============================================================
--
-- A user is Engaged when they have at least one successful
-- transaction in 3 of the previous 4 completed calendar weeks
-- before the analysis date.
--
-- transaction_week is supplied by the reusable successful
-- transaction events model and represents a Monday-based
-- calendar week.
--
-- ============================================================

engagement as (

    select
        u.user_id,

        count(
            distinct s.transaction_week
        ) >= 3 as engagement_flag

    from {{ ref('stg_users') }} as u

    cross join analysis_date as a

    left join {{ ref('int_successful_transaction_events') }} as s
        on
            u.user_id = s.user_id

            and s.transaction_week between
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
