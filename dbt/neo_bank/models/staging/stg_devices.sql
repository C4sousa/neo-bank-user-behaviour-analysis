select

    string_field_0 as device_platform,

    string_field_1 as user_id

from {{ source('neobank', 'devices') }}

where string_field_1 != 'user_id'
