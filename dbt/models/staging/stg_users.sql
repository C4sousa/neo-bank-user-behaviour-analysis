-- Standardises the Users source for downstream analytical modelling.
-- Business logic is intentionally kept out of staging.

select

    user_id,

    birth_year,

    country,

    city,

    created_date as created_at,

    plan,

    num_contacts,

    num_referrals,

    num_successful_referrals,

    -- Convert source flag to a consistent numeric representation.
    cast(user_settings_crypto_unlocked as int64) as crypto_enabled,

    cast(attributes_notifications_marketing_push as int64)
        as marketing_push_enabled,

    cast(attributes_notifications_marketing_email as int64)
        as marketing_email_enabled

from {{ source('neobank', 'users') }}
