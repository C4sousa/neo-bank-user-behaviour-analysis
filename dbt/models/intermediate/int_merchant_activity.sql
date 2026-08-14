-- Standardise merchant-derived activity for downstream analytical modelling.
-- Grain: one row per user.
-- Uses successful transactions and non-null MCC values only.

with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),

merchant_spend as (

    select
        t.user_id,
        t.merchant_mcc,
        sum(t.amount_usd) as total_successful_amount

    from {{ ref('stg_transactions') }} as t

    cross join analysis_date as a

    where t.transaction_state = 'COMPLETED'
      and t.merchant_mcc is not null
      and t.created_at >= timestamp_sub(
          a.analysis_date,
          interval 30 day
      )
      and t.created_at < a.analysis_date

    group by
        t.user_id,
        t.merchant_mcc

),

ranked_merchant_spend as (

    select
        user_id,
        merchant_mcc,
        total_successful_amount,

        row_number() over (
            partition by user_id
            order by
                total_successful_amount desc,
                merchant_mcc
        ) as merchant_rank

    from merchant_spend

)

select
    user_id,
    merchant_mcc as merchant_spending_category

from ranked_merchant_spend

where merchant_rank = 1
