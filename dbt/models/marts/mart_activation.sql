-- mart_activation
-- Purpose:
-- Exposes the approved Activation KPI as an analysis-ready Mart.
--
-- Grain:
-- One row per user.
--
-- Business logic:
-- Activation is calculated centrally in int_user_kpis.
-- This Mart does not recreate or modify the KPI definition.
--
-- Downstream use:
-- Supports activation-focused analysis and reporting.

{{ config(
    materialized='table'
) }}

select
    user_id,
    activation_flag

from {{ ref('int_user_kpis') }}
