-- ============================================================
-- USER RETENTION
-- ============================================================
--
-- Retention logic remains unchanged.
-- Activation acts as the lifecycle gate:
-- users who never activated cannot be Retained.
-- ============================================================

with analysis_date as (

    select
        max(created_at) as analysis_date
    from {{ ref('stg_transactions') }}

),

last_completed_month as (

    select
        date_trunc(
            date_sub(
                date(d.analysis_date),
                interval 1 month
            ),
            month
        ) as last_completed_month
    from analysis_date as d

),

monthly_activity as (

    select distinct
        s.user_id,
        s.transaction_month
    from {{ ref('int_successful_transaction_events') }} as s
    cross join last_completed_month as l
    where s.transaction_month <= l.last_completed_month

),

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

latest_retention_qualification as (

    select
        user_id,
        max(qualification_start_month)
            as qualification_start_month

    from retention_streaks
    group by user_id

),

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

),

retention as (

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

)

select
    r.user_id,

    case
        when not a.activation_flag then false
        else r.retention_flag
    end as retention_flag

from retention as r

left join {{ ref('int_activation') }} as a
    on r.user_id = a.user_id
