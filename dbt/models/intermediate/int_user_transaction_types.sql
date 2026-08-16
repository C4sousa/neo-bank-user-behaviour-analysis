-- ============================================================
-- USER TRANSACTION TYPES
-- ============================================================
--
-- Purpose:
--   Represent how the user transacts for H12 analysis.
--
-- Grain:
--   One row per user × transaction type.
--
-- Transaction types:
--   Taken directly from the source dataset without grouping
--   or reclassification.
--
-- Successful transactions:
--   Only transactions with transaction_state = 'COMPLETED'
--   are included.
--
-- Time:
--   No analytical observation window is imposed here.
--   The model preserves the available successful transaction
--   history so downstream analysis can apply the appropriate
--   observation period for the hypothesis being investigated.
--
-- ============================================================

with transaction_type_activity as (

    select
        user_id,
        transaction_type,

        count(*) as transaction_count

    from {{ ref('int_successful_transaction_events') }}

    where transaction_type is not null

    group by
        user_id,
        transaction_type

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
