-- Standardise notification-derived activity for downstream analytical modelling.
-- Grain: one row per user.
-- Notification frequency represents notification exposure/delivery,
-- not notification interaction.

with notification_activity as (

    select
        n.user_id,

        countif(
            n.status = 'SENT'
        ) as notification_frequency

    from {{ ref('stg_notifications') }} as n

    group by
        n.user_id

)

select
    user_id,
    notification_frequency

from notification_activity
