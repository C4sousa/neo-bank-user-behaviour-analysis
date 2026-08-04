select

    reason,

    channel,

    status,

    user_id,

    created_date as created_at

from {{ source('neobank', 'notifications') }}
