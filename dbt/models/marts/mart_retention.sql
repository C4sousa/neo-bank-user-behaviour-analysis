-- mart_retention
-- Purpose:
-- Exposes the approved Retention KPI as an analysis-ready Mart.
--
-- Grain:
-- One row per user.
--
-- Business logic:
-- Retention is calculated centrally in int_user_kpis.
-- This Mart does not recreate or modify the KPI definition.
--
-- Downstream use:
-- Supports retention-focused analysis and reporting.

{{ config(
    materialized='table'
) }}

select
    user_id,
    retention_flag

from {{ ref('int_user_kpis') }}
