{{ config(
    tags = ['staging']
) }}

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

    case
        when user_settings_crypto_unlocked = 1 then true
        when user_settings_crypto_unlocked = 0 then false
    end as crypto_enabled,

    case
        when attributes_notifications_marketing_push = 1 then true
        when attributes_notifications_marketing_push = 0 then false
    end as marketing_push_enabled,

    case
        when attributes_notifications_marketing_email = 1 then true
        when attributes_notifications_marketing_email = 0 then false
    end as marketing_email_enabled

from {{ source('neobank', 'users') }}
