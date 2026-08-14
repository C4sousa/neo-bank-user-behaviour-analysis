-- Standardise transaction-derived activity for downstream analytical modelling.
-- Grain: one row per user.
-- Business KPI logic is intentionally kept out of Level 0.

with analysis_date as (

    select
        max(created_at) as analysis_date
    from {{ ref('stg_transactions') }}

),

transaction_activity as (

    select
        t.user_id,

        countif(
            t.transaction_state = 'COMPLETED'
            and t.created_at >= timestamp_sub(
                a.analysis_date,
                interval 30 day
            )
            and t.created_at < a.analysis_date
        ) as transaction_frequency_30d,

        countif(
            t.transaction_state in ('FAILED', 'DECLINED')
            and t.created_at >= timestamp_sub(
                a.analysis_date,
                interval 30 day
            )
            and t.created_at < a.analysis_date
        ) as failed_declined_transactions_30d,

        max(
            case
                when t.transaction_state = 'COMPLETED'
                then date_trunc(date(t.created_at), week(monday))
            end
        ) as activity_period,

        max(
            case
                when t.transaction_state = 'COMPLETED'
                then date(t.created_at)
            end
        ) as last_successful_transaction_date

    from {{ ref('stg_transactions') }} as t
    cross join analysis_date as a

    group by
        t.user_id

)

select
    user_id,
    transaction_frequency_30d,
    failed_declined_transactions_30d,
    activity_period,
    last_successful_transaction_date

from transaction_activity
