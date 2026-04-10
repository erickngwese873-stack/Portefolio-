-- ============================================================
-- DIGITAL ACQUISITION PERFORMANCE ANALYSIS — SQL QUERIES
-- Dataset: marketing_campaign_dataset (200K campaigns, 2021)
-- ============================================================

-- ┌──────────────────────────────────────────────────────┐
-- │  1. KPI OVERVIEW — CPC, CPA, ROAS, Conversion Rate  │
-- └──────────────────────────────────────────────────────┘

SELECT
    Channel_Used,
    COUNT(*)                                                    AS campaigns,
    ROUND(SUM(Acquisition_Cost) / SUM(Clicks), 2)              AS CPC,
    ROUND(SUM(Acquisition_Cost) / SUM(Clicks * Conversion_Rate), 2) AS CPA,
    ROUND(AVG(ROI), 2)                                         AS Avg_ROAS,
    ROUND(AVG(Conversion_Rate) * 100, 2)                       AS Avg_Conversion_Rate_Pct,
    ROUND(SUM(Clicks) * 1.0 / SUM(Impressions) * 100, 2)      AS CTR_Pct
FROM marketing_campaigns
GROUP BY Channel_Used
ORDER BY Avg_ROAS DESC;


-- ┌──────────────────────────────────────────────────────┐
-- │  2. PAID vs ORGANIC CHANNEL PERFORMANCE              │
-- └──────────────────────────────────────────────────────┘

SELECT
    CASE
        WHEN Channel_Used IN ('Google Ads','Facebook','Instagram','YouTube')
            THEN 'Paid'
        ELSE 'Organic'
    END                                                         AS Channel_Category,
    COUNT(*)                                                    AS campaigns,
    ROUND(SUM(Acquisition_Cost), 0)                             AS total_spend,
    ROUND(AVG(ROI), 2)                                         AS avg_roas,
    ROUND(AVG(Conversion_Rate) * 100, 2)                       AS avg_conversion_pct,
    ROUND(SUM(Acquisition_Cost) / SUM(Clicks), 2)              AS cpc,
    ROUND(SUM(Acquisition_Cost) / SUM(Clicks * Conversion_Rate), 2) AS cpa
FROM marketing_campaigns
GROUP BY Channel_Category;


-- ┌──────────────────────────────────────────────────────┐
-- │  3. CAMPAIGN TYPE PERFORMANCE                        │
-- └──────────────────────────────────────────────────────┘

SELECT
    Campaign_Type,
    COUNT(*)                                                    AS campaigns,
    ROUND(SUM(Acquisition_Cost), 0)                             AS total_spend,
    ROUND(AVG(ROI), 2)                                         AS avg_roas,
    ROUND(AVG(Conversion_Rate) * 100, 2)                       AS avg_conversion_pct,
    ROUND(SUM(Acquisition_Cost) / SUM(Clicks), 2)              AS cpc,
    ROUND(SUM(Acquisition_Cost) / SUM(Clicks * Conversion_Rate), 2) AS cpa
FROM marketing_campaigns
GROUP BY Campaign_Type
ORDER BY avg_roas DESC;


-- ┌──────────────────────────────────────────────────────┐
-- │  4. MONTHLY TRENDS                                   │
-- └──────────────────────────────────────────────────────┘

SELECT
    EXTRACT(MONTH FROM Date)                                    AS month_num,
    TO_CHAR(Date, 'Mon')                                       AS month_name,
    COUNT(*)                                                    AS campaigns,
    ROUND(SUM(Acquisition_Cost), 0)                             AS total_spend,
    ROUND(SUM(Acquisition_Cost * ROI), 0)                       AS total_revenue,
    ROUND(AVG(ROI), 2)                                         AS avg_roas,
    ROUND(AVG(Conversion_Rate) * 100, 2)                       AS avg_conversion_pct
FROM marketing_campaigns
GROUP BY month_num, month_name
ORDER BY month_num;


-- ┌──────────────────────────────────────────────────────┐
-- │  5. CHANNEL × CAMPAIGN TYPE ROI MATRIX               │
-- └──────────────────────────────────────────────────────┘

SELECT
    Campaign_Type,
    ROUND(AVG(CASE WHEN Channel_Used = 'Google Ads' THEN ROI END), 2)  AS Google_Ads,
    ROUND(AVG(CASE WHEN Channel_Used = 'Facebook'   THEN ROI END), 2)  AS Facebook,
    ROUND(AVG(CASE WHEN Channel_Used = 'Instagram'  THEN ROI END), 2)  AS Instagram,
    ROUND(AVG(CASE WHEN Channel_Used = 'YouTube'    THEN ROI END), 2)  AS YouTube,
    ROUND(AVG(CASE WHEN Channel_Used = 'Email'      THEN ROI END), 2)  AS Email,
    ROUND(AVG(CASE WHEN Channel_Used = 'Website'    THEN ROI END), 2)  AS Website
FROM marketing_campaigns
GROUP BY Campaign_Type
ORDER BY Campaign_Type;


-- ┌──────────────────────────────────────────────────────┐
-- │  6. TARGET AUDIENCE SEGMENTATION                     │
-- └──────────────────────────────────────────────────────┘

SELECT
    Target_Audience,
    COUNT(*)                                                    AS campaigns,
    ROUND(AVG(ROI), 2)                                         AS avg_roas,
    ROUND(AVG(Conversion_Rate) * 100, 2)                       AS avg_conversion_pct,
    ROUND(SUM(Acquisition_Cost) / SUM(Clicks * Conversion_Rate), 2) AS cpa,
    ROUND(AVG(Engagement_Score), 2)                            AS avg_engagement
FROM marketing_campaigns
GROUP BY Target_Audience
ORDER BY avg_roas DESC;


-- ┌──────────────────────────────────────────────────────┐
-- │  7. CUSTOMER SEGMENT PERFORMANCE                     │
-- └──────────────────────────────────────────────────────┘

SELECT
    Customer_Segment,
    COUNT(*)                                                    AS campaigns,
    ROUND(SUM(Acquisition_Cost), 0)                             AS total_spend,
    ROUND(SUM(Acquisition_Cost * ROI), 0)                       AS total_revenue,
    ROUND(AVG(ROI), 2)                                         AS avg_roas,
    ROUND(AVG(Conversion_Rate) * 100, 2)                       AS avg_conversion_pct,
    ROUND(SUM(Acquisition_Cost) / SUM(Clicks * Conversion_Rate), 2) AS cpa
FROM marketing_campaigns
GROUP BY Customer_Segment
ORDER BY avg_roas DESC;


-- ┌──────────────────────────────────────────────────────┐
-- │  8. BUDGET REALLOCATION — EFFICIENCY SCORING         │
-- └──────────────────────────────────────────────────────┘

WITH channel_kpis AS (
    SELECT
        Channel_Used,
        AVG(ROI)               AS avg_roi,
        AVG(Conversion_Rate)   AS avg_cvr,
        SUM(Acquisition_Cost) / NULLIF(SUM(Clicks * Conversion_Rate), 0) AS avg_cpa,
        SUM(Acquisition_Cost)  AS current_spend
    FROM marketing_campaigns
    GROUP BY Channel_Used
),
scores AS (
    SELECT *,
        -- composite: 40 % ROI + 30 % inverse CPA + 30 % CVR (normalised)
        (avg_roi / MAX(avg_roi) OVER ()) * 0.4
      + (1 - avg_cpa / MAX(avg_cpa) OVER ()) * 0.3
      + (avg_cvr / MAX(avg_cvr) OVER ()) * 0.3   AS efficiency_score
    FROM channel_kpis
)
SELECT
    Channel_Used,
    ROUND(avg_roi, 2)                                          AS avg_roas,
    ROUND(avg_cpa, 2)                                          AS avg_cpa,
    ROUND(avg_cvr * 100, 2)                                    AS avg_cvr_pct,
    ROUND(current_spend / SUM(current_spend) OVER () * 100, 2) AS current_alloc_pct,
    ROUND(efficiency_score / SUM(efficiency_score) OVER () * 100, 2) AS recommended_alloc_pct,
    ROUND(
        efficiency_score / SUM(efficiency_score) OVER () * 100
      - current_spend   / SUM(current_spend)     OVER () * 100
    , 2)                                                        AS delta_pct
FROM scores
ORDER BY recommended_alloc_pct DESC;


-- ┌──────────────────────────────────────────────────────┐
-- │  9. TOP 10 HIGHEST-ROI CAMPAIGNS                     │
-- └──────────────────────────────────────────────────────┘

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Target_Audience,
    ROUND(ROI, 2)              AS roi,
    ROUND(Conversion_Rate * 100, 2) AS conversion_pct,
    Acquisition_Cost           AS spend,
    Clicks,
    Impressions
FROM marketing_campaigns
ORDER BY ROI DESC
LIMIT 10;


-- ┌──────────────────────────────────────────────────────┐
-- │ 10. MONTHLY CHANNEL TREND (for line chart)           │
-- └──────────────────────────────────────────────────────┘

SELECT
    EXTRACT(MONTH FROM Date)                    AS month_num,
    TO_CHAR(Date, 'Mon')                        AS month_name,
    Channel_Used,
    ROUND(SUM(Acquisition_Cost), 0)             AS spend,
    ROUND(AVG(ROI), 2)                          AS avg_roas,
    SUM(Clicks)                                 AS clicks
FROM marketing_campaigns
GROUP BY month_num, month_name, Channel_Used
ORDER BY month_num, Channel_Used;
