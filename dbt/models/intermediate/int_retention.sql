-- ============================================================
-- USER RETENTION MODEL
-- ============================================================
--
-- Purpose:
--   Represent the approved business definition of Retention.
--
-- Grain:
--   One row per user.
--
-- Retention:
--   A user qualifies after 3 consecutive completed calendar
--   months with at least one successful transaction.
--
--   After qualification, every subsequent completed calendar
--   month must contain at least one successful transaction.
--
--   Missing a completed calendar month ends Retention.
--
--   A user who later returns can qualify again after another
--   3 consecutive active completed calendar months.
--
-- The Retention definition is calculated independently from
-- the other KPI models.
--
-- ============================================================


with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),


-- ============================================================
-- LAST COMPLETED CALENDAR MONTH
-- ============================================================
--
-- The current calendar month is incomplete and therefore
-- cannot be evaluated for Retention.
--
-- ============================================================

last_completed_month as (

    select
        date_trunc(
            date_sub(
                date(a.analysis_date),
                interval 1 month
            ),
            month
        ) as last_completed_month

    from analysis_date as a

),


-- ============================================================
-- SUCCESSFUL TRANSACTIONS
-- ============================================================

successful_transactions as (

    select
        t.user_id,

        date_trunc(
            date(t.created_at),
            month
        ) as transaction_month

    from {{ ref('stg_transactions') }} as t

    where
        t.transaction_state = 'COMPLETED'

),


-- ============================================================
-- MONTHLY ACTIVITY
-- ============================================================
--
-- Only completed calendar months are eligible for
-- Retention evaluation.
--
-- ============================================================

monthly_activity as (

    select distinct
        s.user_id,
        s.transaction_month

    from successful_transactions as s

    cross join last_completed_month as l

    where
        s.transaction_month <= l.last_completed_month

),


-- ============================================================
-- RETENTION QUALIFICATION
-- ============================================================
--
-- Find every period containing 3 consecutive active
-- completed calendar months.
--
-- ============================================================

retention_streaks as (

    select
        m1.user_id,

        m1.transaction_month
            as qualification_start_month

    from monthly_activity as m1

    inner join monthly_activity as m2
        on
            m1.user_id = m2.user_id

            and m2.transaction_month = date_add(
                m1.transaction_month,
                interval 1 month
            )

    inner join monthly_activity as m3
        on
            m1.user_id = m3.user_id

            and m3.transaction_month = date_add(
                m1.transaction_month,
                interval 2 month
            )

),


-- ============================================================
-- LATEST RETENTION QUALIFICATION
-- ============================================================
--
-- If a user loses Retention and later returns, the latest
-- qualifying 3-month streak becomes the new qualification.
--
-- ============================================================

latest_retention_qualification as (

    select
        user_id,

        max(
            qualification_start_month
        ) as qualification_start_month

    from retention_streaks

    group by
        user_id

),


-- ============================================================
-- RETENTION EVALUATION
-- ============================================================
--
-- The three qualification months are already known to be
-- active.
--
-- From the month after qualification:
--
--   active completed month -> remains Retained
--   missed completed month -> Retention ends
--
-- ============================================================

retention_evaluation as (

    select
        q.user_id,

        q.qualification_start_month,

        count(
            distinct expected_month
        ) as expected_completed_months,

        count(
            distinct case
                when m.transaction_month is not null
                    then expected_month
            end
        ) as active_completed_months

    from latest_retention_qualification as q

    cross join last_completed_month as l

    left join unnest(
        generate_date_array(
            date_add(
                q.qualification_start_month,
                interval 3 month
            ),
            l.last_completed_month,
            interval 1 month
        )
    ) as expected_month

    left join monthly_activity as m
        on
            q.user_id = m.user_id

            and m.transaction_month = expected_month

    group by
        q.user_id,
        q.qualification_start_month

)


-- ============================================================
-- FINAL USER RETENTION MODEL
-- ============================================================

select
    u.user_id,

    coalesce(
        r.user_id is not null
        and r.active_completed_months
            = r.expected_completed_months,
        false
    ) as retention_flag

from {{ ref('stg_users') }} as u

left join retention_evaluation as r
    on u.user_id = r.user_id
