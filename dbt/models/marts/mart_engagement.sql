{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

WITH engagement AS (

    SELECT
        user_id,
        engagement_flag
    FROM {{ ref('int_engagement') }}

),

activity AS (

    SELECT
        user_id,
        transaction_frequency_30d,
        notification_frequency_30d,
        merchant_spending_category,
        activity_period
    FROM {{ ref('int_user_activity') }}

),

profile AS (

    SELECT
        user_id,
        crypto_adoption,
        plan_segment,
        country
    FROM {{ ref('int_user_profile') }}

)

SELECT
    e.user_id,
    e.engagement_flag,
    a.transaction_frequency_30d,
    a.notification_frequency_30d,
    a.merchant_spending_category,
    a.activity_period,
    p.crypto_adoption,
    p.plan_segment,
    p.country

FROM engagement AS e

LEFT JOIN activity AS a
    ON e.user_id = a.user_id

LEFT JOIN profile AS p
    ON e.user_id = p.user_id
