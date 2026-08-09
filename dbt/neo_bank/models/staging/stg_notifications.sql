-- Standardise notification fields for downstream models.
-- Grain: one row per notification.

select
    reason,
    channel,
    status,
    user_id,
    created_date as created_at

from {{ source('neobank', 'notifications') }}
