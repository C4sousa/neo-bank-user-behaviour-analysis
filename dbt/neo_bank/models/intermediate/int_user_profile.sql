select

    u.user_id,
    u.birth_year,
    u.country,
    u.city,
    u.created_at,
    u.plan,

    case
        when u.crypto_enabled = 1 then true
        else false
    end as crypto_enabled,

    case
        when u.marketing_push_enabled = 1 then true
        else false
    end as marketing_push_enabled,

    case
        when u.marketing_email_enabled = 1 then true
        else false
    end as marketing_email_enabled,

    u.num_contacts,
    u.num_referrals,
    u.num_successful_referrals,

    case
        when u.num_successful_referrals > 0 then true
        else false
    end as referred_flag,

    d.device_platform

from {{ ref('stg_users') }} u

left join {{ ref('stg_devices') }} d
    on u.user_id = d.user_id
