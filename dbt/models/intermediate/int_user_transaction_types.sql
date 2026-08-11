-- Builds the reusable transaction-type activity model.
--
-- Purpose:
-- Represent how the user transacts.
--
-- Grain:
-- One row per user × transaction type.
--
-- Transaction types are taken directly from the source
-- dataset without grouping or reclassification.
--
-- Only successful transactions are included.
--
-- The approved 30-day observation window is used.

with analysis_date as (

    select
        max(created_at) as analysis_date

    from {{ ref('stg_transactions') }}

),

transaction_type_activity as (

    select
        t.user_id,
        t.transaction_type,

        count(*) as transaction_count

    from {{ ref('stg_transactions') }} t

    cross join analysis_date a

    where t.transaction_state = 'COMPLETED'
        and t.transaction_type is not null
        and t.created_at >= timestamp_sub(
            a.analysis_date,
            interval 30 day
        )
        and t.created_at < a.analysis_date

    group by
        t.user_id,
        t.transaction_type

)

select
    user_id,

    transaction_type,

    transaction_count,

    safe_divide(
        transaction_count,
        sum(transaction_count) over (
            partition by user_id
        )
    ) as transaction_share

from transaction_type_activity
