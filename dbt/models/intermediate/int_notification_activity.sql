-- Standardise notification-derived activity for downstream analytical modelling.
-- Grain: one row per user.
-- Notification frequency represents notification exposure/delivery,
-- not notification interaction.

with analysis_date as (

    select
        max(created_at) as analysis_date
    from {{ ref('stg_transactions') }}

),

notification_activity as (

    select
        n.user_id,

        countif(
            n.status = 'SENT'
            and n.created_at >= timestamp_sub(
                a.analysis_date,
                interval 30 day
            )
            and n.created_at < a.analysis_date
        ) as notification_frequency_30d

    from {{ ref('stg_notifications') }} as n
    cross join analysis_date as a

    group by
        n.user_id

)

select
    user_id,
    notification_frequency_30d

from notification_activity
