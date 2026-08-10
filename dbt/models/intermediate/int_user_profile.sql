-- Builds the reusable user profile model.
-- Business logic is limited to the approved profile attributes.

select

    user_id,

    country,

    -- Convert the source Crypto flag to a binary integer:
    -- 0 = not enabled, 1 = enabled.
    cast(crypto_enabled as int64) as crypto_adoption,

    -- Group the approved Premium plan against all other plans.
    case
        when plan = 'PREMIUM' then 'PREMIUM'
        else 'STANDARD'
    end as plan_segment

from {{ ref('stg_users') }}
