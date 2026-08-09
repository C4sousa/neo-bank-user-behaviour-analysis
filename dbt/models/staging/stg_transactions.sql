-- Standardise transaction fields for downstream analytical models.
-- Grain: one row per transaction.

select
    transaction_id,
    user_id,
    transactions_type as transaction_type,
    transactions_currency as transaction_currency,
    amount_usd,
    transactions_state as transaction_state,
    ea_cardholderpresence as cardholder_presence,
    cast(ea_merchant_mcc as int64) as merchant_mcc,
    ea_merchant_city as merchant_city,
    ea_merchant_country as merchant_country,
    direction,
    created_date as created_at

from {{ source('neobank', 'transactions') }}
