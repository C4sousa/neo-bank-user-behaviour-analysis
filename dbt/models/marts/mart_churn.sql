-- mart_churn
-- Purpose:
-- Exposes the approved Churn KPI as an analysis-ready Mart.
--
-- Grain:
-- One row per user.
--
-- Business logic:
-- Churn is calculated centrally in int_user_kpis.
-- This Mart does not recreate or modify the KPI definition.
--
-- Downstream use:
-- Supports churn-focused analysis and reporting.

{{ config(
    materialized='table'
) }}

select
    user_id,
    churn_flag

from {{ ref('int_user_kpis') }}
