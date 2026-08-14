-- Builds the reusable user activity model.
-- Purpose: represent what the user has done.
-- Grain: one row per user.
--
-- Activity metrics are inherited from the approved
-- Level 0 supporting activity models.
--
-- The model combines transaction, notification and
-- merchant activity into one reusable user-level model.

select
    u.user_id,

    t.transaction_frequency_30d,

    n.notification_frequency_30d,

    t.failed_declined_transactions_30d,

    m.merchant_spending_category,

    t.activity_period,

    t.last_successful_transaction_date

from {{ ref('stg_users') }} as u

left join {{ ref('int_transaction_activity') }} as t
    on u.user_id = t.user_id

left join {{ ref('int_notification_activity') }} as n
    on u.user_id = n.user_id

left join {{ ref('int_merchant_activity') }} as m
    on u.user_id = m.user_id
