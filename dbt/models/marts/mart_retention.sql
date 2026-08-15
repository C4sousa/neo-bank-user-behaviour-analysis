{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

WITH retention AS (

    SELECT
        user_id,
        retention_flag
    FROM {{ ref('int_retention') }}

),

activity AS (

    SELECT
        user_id,
        transaction_frequency_30d,
        notification_frequency_30d
    FROM {{ ref('int_user_activity') }}

),

profile AS (

    SELECT
        user_id,
        crypto_adoption,
        plan_segment
    FROM {{ ref('int_user_profile') }}

)

SELECT
    r.user_id,
    r.retention_flag,
    a.transaction_frequency_30d,
    a.notification_frequency_30d,
    p.crypto_adoption,
    p.plan_segment

FROM retention AS r

LEFT JOIN activity AS a
    ON r.user_id = a.user_id

LEFT JOIN profile AS p
    ON r.user_id = p.user_id
