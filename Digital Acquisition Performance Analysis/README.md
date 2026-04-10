# Digital Acquisition Performance Analysis

> Multi-channel marketing campaign analysis across 200K campaigns, $2.5B total spend, full-year 2021.

![Dashboard Preview](dashboard_preview.png)

---

## Project Overview

This project delivers an end-to-end analysis of digital acquisition performance across **6 channels**, **5 campaign types**, and **5 audience segments**. It includes SQL queries for core KPIs, an interactive dashboard, and budget reallocation scenarios.

### Dataset

| Attribute | Value |
|-----------|-------|
| **Campaigns** | 200,000 |
| **Time Period** | Jan–Dec 2021 |
| **Total Spend** | $2.50B |
| **Est. Revenue** | $12.52B |
| **Channels** | Google Ads, Facebook, Instagram, YouTube, Website, Email |
| **Campaign Types** | Display, Email, Influencer, Search, Social Media |

---

## Key KPIs

| KPI | Value |
|-----|-------|
| Average ROAS | 5.00x |
| Average Conversion Rate | 8.01% |
| Average CPC | $32.01 |
| Average CPA | $635.33 |
| Total Clicks | 109.9M |
| Total Impressions | 1.10B |

---

## Analysis Breakdown

### 1. Multi-Channel Performance (Paid & Organic)

**Paid Channels** (Google Ads, Facebook, Instagram, YouTube):
- 66.5% of total spend ($1.66B)
- Avg ROAS: 5.00x | Avg CPC: $32.10 | Avg CPA: $636.95

**Organic Channels** (Website, Email):
- 33.5% of total spend ($837M)
- Avg ROAS: 5.01x | Avg CPC: $31.83 | Avg CPA: $632.12

**Insight:** Organic channels deliver marginally better cost-efficiency (lower CPC/CPA) despite receiving proportionally less budget.

### 2. Channel Rankings

| Channel | ROAS | CPC | CPA | CTR |
|---------|------|-----|-----|-----|
| Facebook | 5.02x | $32.13 | $633.81 | 14.05% |
| Website | 5.01x | $31.78 | $632.08 | 14.10% |
| Google Ads | 5.00x | $32.31 | $642.26 | 13.92% |
| Email | 5.00x | $31.88 | $632.16 | 14.05% |
| YouTube | 4.99x | $31.87 | $635.91 | 14.12% |
| Instagram | 4.99x | $32.08 | $635.75 | 14.00% |

### 3. Campaign Type Analysis

| Type | ROAS | CPA | Share of Spend |
|------|------|-----|----------------|
| Influencer | 5.01x | $631.67 | 20.1% |
| Search | 5.01x | $634.13 | 20.1% |
| Display | 5.01x | $642.06 | 20.0% |
| Email | 4.99x | $638.91 | 19.9% |
| Social Media | 4.99x | $629.89 | 19.9% |

### 4. Budget Reallocation Scenarios

Efficiency-weighted model (40% ROI, 30% inverse CPA, 30% Conversion Rate):

| Channel | Current % | Recommended % | Delta |
|---------|-----------|---------------|-------|
| Website | 16.66% | 16.73% | +0.08% |
| Facebook | 16.42% | 16.71% | **+0.29%** |
| Email | 16.83% | 16.71% | -0.12% |
| Google Ads | 16.75% | 16.60% | **-0.15%** |
| YouTube | 16.67% | 16.63% | -0.04% |
| Instagram | 16.68% | 16.62% | -0.06% |

**Impact:** ~$7.3M budget shift, projected +0.02x ROAS lift across portfolio.

---

## SQL Queries

The `sql_queries.sql` file includes 10 production-ready queries:

1. **KPI Overview** — CPC, CPA, ROAS, Conversion Rate by channel
2. **Paid vs Organic** — Split performance comparison
3. **Campaign Type** — Performance by campaign format
4. **Monthly Trends** — Spend & revenue seasonality
5. **ROI Heatmap** — Campaign Type × Channel matrix
6. **Audience Segmentation** — Target audience performance
7. **Customer Segments** — Vertical performance (Foodies, Tech, etc.)
8. **Budget Reallocation** — Efficiency-scored allocation model
9. **Top 10 Campaigns** — Highest-ROI individual campaigns
10. **Monthly Channel Trends** — Time-series by channel

---

## Dashboard

Interactive HTML dashboard with:
- 6 KPI summary cards
- 5 tabbed views (Overview, Channels, Campaigns, Audience, Budget)
- 12+ Chart.js visualizations (bar, line, radar, polar, doughnut)
- Performance comparison tables
- Budget scenario visualizer

**Open `dashboard.html` in any browser to explore.**

---

## Tech Stack

- **Python / Pandas** — Data cleaning, transformation, KPI computation
- **SQL** — Analytical queries (PostgreSQL-compatible)
- **HTML / CSS / Chart.js** — Interactive dashboard
- **Dataset** — 200K rows, 16 columns

---

## Key Findings & Recommendations

1. **Channel uniformity** — All 6 channels perform within a tight 4.99–5.02x ROAS band, suggesting balanced but undifferentiated allocation.

2. **Organic advantage** — Website and Email deliver 2-3% lower CPC/CPA than paid channels despite lower spend share.

3. **Influencer campaigns win** — Highest ROAS (5.01x) and lowest CPA ($631.67) across all campaign types.

4. **Men 25-34** are the top-performing audience (5.02x ROAS); **Men 18-24** have highest engagement but lowest ROI.

5. **Primary optimization lever** is at the campaign-type and audience level, not channel level — consider shifting more budget toward Influencer campaigns targeting Men 25-34 in the Tech Enthusiasts segment.

---

## File Structure

```
├── README.md                  # This file
├── dashboard.html             # Interactive analysis dashboard
├── sql_queries.sql            # 10 SQL analytical queries
└── marketing_campaign_dataset.csv  # Source data (200K rows)
```

---

*Analysis completed March 2026*
