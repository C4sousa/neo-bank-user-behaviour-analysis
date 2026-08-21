{{ config(
    materialized='view'
) }}

WITH user_first_successful_transaction AS (

    SELECT
        user_id,
        MIN(transaction_date) AS first_successful_transaction_date

    FROM {{ ref('int_successful_transaction_events') }}

    GROUP BY user_id

)

SELECT
    u.user_id,

    CASE
        WHEN f.first_successful_transaction_date IS NOT NULL
            THEN TRUE
        ELSE FALSE
    END AS activation_flag

FROM {{ ref('stg_users') }} AS u

LEFT JOIN user_first_successful_transaction AS f
    ON u.user_id = f.user_id
