-- Builds the reusable user activity model.
-- Purpose: represent what the user has done.
-- Grain: one row per user.
--
-- Time-windowed behavioural metrics use the approved
-- 30-day window before the analysis date.
--
-- Activity period represents the calendar week associated
-- with the user's most recent successful transaction.
--
-- Last successful transaction date supports the approved
-- churn logic.

with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),

transaction_activity as (

    select
        t.user_id,

        -- Count successful transactions in the approved
        -- 30-day window.
        countif(
            t.transaction_state = 'COMPLETED'
            and t.created_at >= timestamp_sub(
                a.analysis_date,
                interval 30 day
            )
            and t.created_at < a.analysis_date
        ) as transaction_frequency_30d,

        -- Count failed and declined transactions in the
        -- approved 30-day window.
        countif(
            t.transaction_state in ('FAILED', 'DECLINED')
            and t.created_at >= timestamp_sub(
                a.analysis_date,
                interval 30 day
            )
            and t.created_at < a.analysis_date
        ) as failed_declined_transactions_30d,

        -- Calendar week associated with the user's most
        -- recent successful transaction.
        max(
            case
                when t.transaction_state = 'COMPLETED'
                then date_trunc(
                    date(t.created_at),
                    week(monday)
                )
            end
        ) as activity_period,

        -- Date of the user's most recent successful transaction.
        max(
            case
                when t.transaction_state = 'COMPLETED'
                then date(t.created_at)
            end
        ) as last_successful_transaction_date

    from {{ ref('stg_transactions') }} t

    cross join analysis_date a

    group by
        t.user_id

),

merchant_category as (

    select
        t.user_id,
        t.merchant_mcc,

        sum(t.amount_usd) as total_amount_usd

    from {{ ref('stg_transactions') }} t

    cross join analysis_date a

    where t.transaction_state = 'COMPLETED'
        and t.merchant_mcc is not null
        and t.created_at >= timestamp_sub(
            a.analysis_date,
            interval 30 day
        )
        and t.created_at < a.analysis_date

    group by
        t.user_id,
        t.merchant_mcc

),

top_merchant_category as (

    select
        user_id,
        merchant_mcc as merchant_spending_category

    from merchant_category

    qualify row_number() over (
        partition by user_id
        order by
            total_amount_usd desc,
            merchant_mcc
    ) = 1

),

notification_activity as (

    select
        n.user_id,

        -- Notification frequency represents successfully
        -- delivered notification exposure, not interaction.
        count(*) as notification_frequency_30d

    from {{ ref('stg_notifications') }} n

    cross join analysis_date a

    where n.status = 'SENT'
        and n.created_at >= timestamp_sub(
            a.analysis_date,
            interval 30 day
        )
        and n.created_at < a.analysis_date

    group by
        n.user_id

)

select
    u.user_id,

    coalesce(
        t.transaction_frequency_30d,
        0
    ) as transaction_frequency_30d,

    coalesce(
        n.notification_frequency_30d,
        0
    ) as notification_frequency_30d,

    coalesce(
        t.failed_declined_transactions_30d,
        0
    ) as failed_declined_transactions_30d,

    m.merchant_spending_category,

    t.activity_period,

    t.last_successful_transaction_date

from {{ ref('stg_users') }} u

left join transaction_activity t
    on u.user_id = t.user_id

left join notification_activity n
    on u.user_id = n.user_id

left join top_merchant_category m
    on u.user_id = m.user_id
