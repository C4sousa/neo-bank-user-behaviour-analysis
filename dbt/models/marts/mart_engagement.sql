-- ============================================================
-- MART — ENGAGEMENT
-- ============================================================
--
-- Purpose:
-- Present the approved Engagement KPI for BI consumption.
--
-- KPI logic is calculated in int_user_engagement.
--
-- Grain:
-- One row per user.
--
-- ============================================================

select

    user_id,

    engagement_flag

from {{ ref('int_user_engagement') }}
