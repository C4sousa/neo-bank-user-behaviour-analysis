-- ============================================================
-- USER CHURN
-- ============================================================
--
-- Churn logic remains unchanged.
-- Activation acts as the lifecycle gate:
-- users who never activated cannot be Churned.
-- ============================================================

with analysis_date as (

    select
        max(created_at) as analysis_date
    from {{ ref('stg_transactions') }}

),

last_successful_activity as (

    select
        user_id,
        max(transaction_date) as last_successful_transaction_date
    from {{ ref('int_successful_transaction_events') }}
    group by user_id

)

select
    u.user_id,

    case
        when not a.activation_flag then false
        else coalesce(
            date_diff(
                date(d.analysis_date),
                l.last_successful_transaction_date,
                day
            ) >= 90,
            false
        )
    end as churn_flag

from {{ ref('stg_users') }} as u

left join {{ ref('int_activation') }} as a
    on u.user_id = a.user_id

cross join analysis_date as d

left join last_successful_activity as l
    on u.user_id = l.user_id
