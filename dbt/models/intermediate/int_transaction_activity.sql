-- Standardise transaction-derived activity for downstream analytical modelling.
-- Grain: one row per user.
-- Business KPI logic is intentionally kept out of Level 0.

with transaction_activity as (

    select
        t.user_id,

        countif(
            t.transaction_state = 'COMPLETED'
        ) as transaction_frequency,

        countif(
            t.transaction_state in ('FAILED', 'DECLINED')
        ) as failed_declined_transactions,

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

    group by
        t.user_id

)

select
    user_id,
    transaction_frequency,
    failed_declined_transactions,
    activity_period,
    last_successful_transaction_date

from transaction_activity
