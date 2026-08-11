-- ============================================================
-- USER KPI MODEL
-- ============================================================
--
-- Activation:
--   First successful transaction.
--
-- Engagement:
--   At least one successful transaction in 3 of the previous
--    4 weeks before the analysis date.
--
-- Retention:
--   3 consecutive completed calendar months -> Retained.
--   After qualification, every subsequent completed calendar
--   month must contain at least one successful transaction.
--   Missing a completed calendar month ends Retention.
--   A user who later returns can qualify again after another
--   3 consecutive active completed months.
--
-- Churn:
--   Independent of Engagement and Retention.
--   90 consecutive days without a successful transaction
--   results in Churn.
--   The 90-day observation period must exist.
--   Every successful transaction resets the 90-day clock.
--
-- ============================================================


with analysis_date as (

    select max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),


-- ============================================================
-- LAST COMPLETED CALENDAR MONTH
-- ============================================================
--
-- The current calendar month is incomplete and therefore
-- cannot be considered a missed month for Retention.
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

        date(t.created_at) as transaction_date,

        date_trunc(
            date(t.created_at),
            month
        ) as transaction_month

    from {{ ref('stg_transactions') }} as t

    where t.transaction_state = 'COMPLETED'

),


-- ============================================================
-- ACTIVATION
-- ============================================================

activation as (

    select
        user_id,

        min(transaction_date) as activation_date

    from successful_transactions

    group by
        user_id

),


-- ============================================================
-- ENGAGEMENT
-- ============================================================
--
-- At least one successful transaction in 3 of the previous
-- 4 weeks before the analysis date.
--
-- ============================================================

engagement as (

    select
        u.user_id,

        coalesce(count(
            distinct date_trunc(
                s.transaction_date,
                week (monday)
            )
        ) >= 3, false) as engagement_flag

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

    where s.transaction_month <= l.last_completed_month

),


-- ============================================================
-- RETENTION QUALIFICATION
-- ============================================================
--
-- Find every period containing 3 consecutive active
-- completed calendar months.
--
-- The current incomplete month cannot participate.
--
-- ============================================================

retention_streaks as (

    select
        m1.user_id,

        m1.transaction_month as qualification_start_month

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
-- We use the most recent completed 3-month qualification.
--
-- If a user loses Retention and later returns, they can
-- qualify again after another 3 consecutive active
-- completed months.
--
-- ============================================================

latest_retention_qualification as (

    select
        user_id,

        max(qualification_start_month)
            as qualification_start_month

    from retention_streaks

    group by
        user_id

),


-- ============================================================
-- RETENTION EVALUATION
-- ============================================================
--
-- The three qualification months are already known to be
-- active and are not re-evaluated.
--
-- From the month AFTER qualification:
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

    left join
        unnest(
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

),


-- ============================================================
-- LAST SUCCESSFUL ACTIVITY
-- ============================================================

last_successful_activity as (

    select
        user_id,

        max(transaction_date)
            as last_successful_transaction_date

    from successful_transactions

    group by
        user_id

),


-- ============================================================
-- CHURN
-- ============================================================
--
-- Churn is independent of Engagement and Retention.
--
-- Every successful transaction resets the 90-day clock.
--
-- If 90 days have passed since the user's most recent
-- successful transaction, the user is Churned.
--
-- ============================================================

churn as (

    select
        l.user_id,

        coalesce(date_diff(
            date(a.analysis_date),
            l.last_successful_transaction_date,
            day
        ) >= 90, false) as churn_flag

    from last_successful_activity as l

    cross join analysis_date as a

)


-- ============================================================
-- FINAL USER KPI MODEL
-- ============================================================

select

    u.user_id,

    -- --------------------------------------------------------
    -- ACTIVATION
    -- --------------------------------------------------------

    e.engagement_flag,

    -- --------------------------------------------------------
    -- ENGAGEMENT
    -- --------------------------------------------------------

    coalesce(act.activation_date is not null, false) as activation_flag,

    -- --------------------------------------------------------
    -- RETENTION
    -- --------------------------------------------------------

    coalesce(
        re.user_id is not null

        and re.active_completed_months
        = re.expected_completed_months, false
    ) as retention_flag,

    -- --------------------------------------------------------
    -- CHURN
    -- --------------------------------------------------------

    coalesce(
        c.churn_flag,
        false
    ) as churn_flag

from {{ ref('stg_users') }} as u

left join activation as act
    on u.user_id = act.user_id

left join engagement as e
    on u.user_id = e.user_id

left join retention_evaluation as re
    on u.user_id = re.user_id

left join churn as c
    on u.user_id = c.user_id
