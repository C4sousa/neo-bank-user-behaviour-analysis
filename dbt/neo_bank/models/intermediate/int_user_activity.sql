with transactions as (

    select *

    from {{ ref('stg_transactions') }}

),

notifications as (

    select *

    from {{ ref('stg_notifications') }}

),

transaction_summary as (

    select

        user_id,

        min(created_at) as first_transaction_at,

        max(created_at) as last_transaction_at,

        count(*) as total_transactions,

        countif(transaction_state = 'COMPLETED') as successful_transactions,

        countif(transaction_state in ('FAILED', 'DECLINED')) as failed_transactions,

        sum(amount_usd) as total_transaction_amount

    from transactions

    group by user_id

),

notification_summary as (

    select

        user_id,

        count(*) as total_notifications,

        countif(status = 'SENT') as successful_notifications,

        min(created_at) as first_notification_at,

        max(created_at) as last_notification_at

    from notifications

    group by user_id

)

select

    coalesce(t.user_id, n.user_id) as user_id,

    t.first_transaction_at,

    t.last_transaction_at,

    t.total_transactions,

    t.successful_transactions,

    t.failed_transactions,

    t.total_transaction_amount,

    n.first_notification_at,

    n.last_notification_at,

    n.total_notifications,

    n.successful_notifications

from transaction_summary t

full outer join notification_summary n

using (user_id)
