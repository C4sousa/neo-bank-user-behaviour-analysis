-- ============================================================
-- USER ENGAGEMENT
-- ============================================================
--
-- Engagement logic remains unchanged.
-- Activation acts as the lifecycle gate:
-- users who never activated cannot be Engaged.
-- ============================================================

with analysis_date as (

    select
        max(created_at) as analysis_date
    from {{ ref('stg_transactions') }}

),

engagement as (

    select
        u.user_id,

        count(
            distinct s.transaction_week
        ) >= 3 as engagement_flag

    from {{ ref('stg_users') }} as u

    cross join analysis_date as d

    left join {{ ref('int_successful_transaction_events') }} as s
        on
            u.user_id = s.user_id

            and s.transaction_week between
                date_sub(
                    date_trunc(
                        date(d.analysis_date),
                        week (monday)
                    ),
                    interval 4 week
                )

                and date_sub(
                    date_trunc(
                        date(d.analysis_date),
                        week (monday)
                    ),
                    interval 1 week
                )

    group by u.user_id

)

select
    e.user_id,

    case
        when not a.activation_flag then false
        else e.engagement_flag
    end as engagement_flag

from engagement as e

left join {{ ref('int_activation') }} as a
    on e.user_id = a.user_id
