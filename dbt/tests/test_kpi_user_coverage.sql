-- ============================================================
-- KPI MODELS — USER COVERAGE TEST
-- ============================================================
--
-- Purpose:
--   Verify that every user in stg_users is represented in
--   each user-level KPI model.
--
-- Expected grain:
--   One row per user in:
--     int_engagement
--     int_retention
--     int_churn
--
-- A passing test returns zero rows.
-- ============================================================


with users as (

    select
        user_id

    from {{ ref('stg_users') }}

),


engagement as (

    select
        user_id

    from {{ ref('int_engagement') }}

),


retention as (

    select
        user_id

    from {{ ref('int_retention') }}

),


churn as (

    select
        user_id

    from {{ ref('int_churn') }}

)


select
    u.user_id,

    case
        when e.user_id is null
            then 'missing_from_engagement'

        when r.user_id is null
            then 'missing_from_retention'

        when c.user_id is null
            then 'missing_from_churn'

    end as coverage_issue

from users as u

left join engagement as e
    on u.user_id = e.user_id

left join retention as r
    on u.user_id = r.user_id

left join churn as c
    on u.user_id = c.user_id

where
    e.user_id is null
    or r.user_id is null
    or c.user_id is null
