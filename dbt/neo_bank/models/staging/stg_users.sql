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

    cast(user_settings_crypto_unlocked as int64)
        as crypto_enabled,

    cast(attributes_notifications_marketing_push as int64)
        as marketing_push_enabled,

    cast(attributes_notifications_marketing_email as int64)
        as marketing_email_enabled

from {{ source('neobank', 'users') }}
