# 🏨 Hotel Revenue Analytics Dashboard

<p align="left">
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white" />
  <img src="https://img.shields.io/badge/Power_BI-DAX-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" />
  <img src="https://img.shields.io/badge/Star_Schema-Data_Model-blueviolet?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Records-1%2C34%2C590-green?style=for-the-badge" />
</p>

> **AtliQ Hotels** | 25 Properties | 4 Cities | 3 Months (May–Jul 2022)  
> End-to-end analytics pipeline — MySQL database design → Power BI 7-page interactive dashboard

---

## 📌 Table of Contents

- [Project Overview](#project-overview)
- [Key Business Insights](#key-business-insights)
- [Tech Stack](#tech-stack)
- [Data Model](#data-model-star-schema)
- [DAX Measures Built](#dax-measures-built)
- [Data Quality Notes](#data-quality-notes)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Connect](#connect)

---

## Project Overview

Built a **7-page interactive Power BI dashboard** for the AtliQ Hotels chain to help management understand revenue performance, booking trends, and cancellation patterns across their portfolio.

The project covers the **full analytics pipeline**:
1. Raw CSV data ingested into a **MySQL Star Schema** database
2. Data cleaned and modelled with proper FK relationships
3. **14 DAX measures** built in Power BI covering all hospitality KPIs
4. Interactive dashboard with slicers for city, property, room type, and week

**Dataset:** 1,34,590 real booking records across 25 properties in Delhi, Mumbai, Bangalore, and Hyderabad over 92 days.

---

## Key Business Insights

| KPI | Value |
|-----|-------|
| 💰 Total Revenue Realized | **Rs. 170.88 Crore** (3 months) |
| 🏙️ Top City by Revenue | **Mumbai — Rs. 66.86 Crore** |
| 🏆 Top Property | **Atliq Exotica — Rs. 32 Crore** |
| ⭐ Best Rated City | **Delhi — 3.78 avg rating** |
| ❌ Cancellation Rate | **24.8%** (1 in 4 bookings cancelled) |
| 👑 Luxury vs Business Split | **61.6% Luxury / 38.4% Business** |
| 📋 Ratings Coverage | Only 42.1% of checkouts left a rating |
| 🔁 No Show Rate | **5.0%** (6,759 bookings) |

### Revenue by Booking Platform

| Platform | Bookings |
|----------|----------|
| others | 55,066 |
| makeyourtrip | 26,898 |
| logtrip | 14,756 |
| direct online | 13,379 |
| tripster | 9,630 |
| journey | 8,106 |
| direct offline | 6,755 |

---

## Tech Stack

| Tool | Usage |
|------|-------|
| **MySQL 8.0** | Database creation, Star Schema design, `LOAD DATA INFILE`, FK relationships |
| **Power BI Desktop** | Data modelling, DAX measures, 7-page interactive dashboard |
| **DAX** | 14 custom measures — RevPAR, ADR, Occupancy %, WoW % changes |
| **Power Query** | Data type corrections, column cleanup |

---

## Data Model (Star Schema)

```
                    ┌─────────────┐
                    │  dim_hotels  │
                    │  25 rows     │
                    └──────┬──────┘
                           │ property_id
          ┌────────────────┼────────────────┐
          │                │                │
   ┌──────┴──────┐  ┌──────┴──────┐        │
   │fact_bookings│  │fact_agg_    │        │
   │ 1,34,590    │  │bookings     │        │
   │ rows        │  │ 9,200 rows  │        │
   └──────┬──────┘  └──────┬──────┘        │
          │                │               │
      check_in_date    check_in_date        │
          │                │               │
   ┌──────┴──────┐  ┌──────┴──────┐  ┌────┴──────┐
   │  dim_date   │  │  dim_date   │  │ dim_rooms │
   │  92 rows    │  │  (shared)   │  │  4 rows   │
   └─────────────┘  └─────────────┘  └───────────┘
```

### Table Descriptions

**`fact_bookings`** — 1,34,590 rows  
Primary transaction table. One row per individual booking with full details.

| Column | Type | Description |
|--------|------|-------------|
| booking_id | VARCHAR(50) PK | Unique booking identifier |
| property_id | INT FK | Links to dim_hotels |
| booking_date | DATE | When the booking was made |
| check_in_date | DATE FK | Links to dim_date |
| checkout_date | DATE | Departure date |
| no_guests | INT | Number of guests |
| room_category | VARCHAR FK | Links to dim_rooms (RT1–RT4) |
| booking_platform | VARCHAR | Channel used to book |
| ratings_given | DECIMAL(2,1) | Guest rating 1–5 (NULL if not given) |
| booking_status | VARCHAR | Checked Out / Cancelled / No Show |
| revenue_generated | INT | Total booking value |
| revenue_realized | INT | Actual revenue collected |

**`fact_aggregated_bookings`** — 9,200 rows  
Daily room capacity and occupancy summary by property and room type.

| Column | Type | Description |
|--------|------|-------------|
| property_id | INT FK | Links to dim_hotels |
| check_in_date | DATE FK | Links to dim_date |
| room_category | VARCHAR FK | Links to dim_rooms |
| successful_bookings | INT | Rooms booked that day |
| capacity | INT | Total available rooms |

**`dim_hotels`** — 25 rows  
| property_id | property_name | category | city |

**`dim_rooms`** — 4 rows  
| RT1: Standard | RT2: Elite | RT3: Premium | RT4: Presidential |

**`dim_date`** — 92 rows  
| date | mmm_yy | week_no | day_type (weekday/weekend) |

---

## DAX Measures Built

### Core Revenue Metrics
| Measure | Formula Logic |
|---------|--------------|
| **Revenue** | SUM of revenue_realized |
| **RevPAR** | Revenue ÷ Total Capacity (rooms sold per available room) |
| **ADR** | Revenue ÷ Total Rooms Booked (avg daily rate) |
| **Realisation %** | Revenue Realized ÷ Revenue Generated |

### Occupancy & Booking Metrics
| Measure | Formula Logic |
|---------|--------------|
| **Occupancy %** | Successful Bookings ÷ Total Capacity |
| **DSRN** | Daily Sellable Room Nights |
| **DBRN** | Daily Booked Room Nights |
| **DURN** | Daily Utilised Room Nights |

### Performance Metrics
| Measure | Formula Logic |
|---------|--------------|
| **Cancellation %** | Cancelled Bookings ÷ Total Bookings |
| **Average Rating** | AVG of ratings_given (excluding NULLs) |

### Week-over-Week Changes (WoW %)
RevPAR WoW% | ADR WoW% | Occupancy WoW% | Revenue WoW% | Realisation WoW% | Cancellation WoW%

---

## Data Quality Notes

The following issues were found during data audit and have been documented for transparency:

| Issue | File | Details | Status |
|-------|------|---------|--------|
| **Typo in day_type** | `dim_date.csv` | `"weekeday"` (65 rows) instead of `"weekday"` — breaks any weekday filter/DAX | ⚠️ Fix before loading |
| **CSV headers vs SQL column names** | `dim_date.csv` | Headers use spaces (`mmm yy`, `week no`) but SQL table uses underscores (`mmm_yy`, `week_no`) | ⚠️ Inconsistency |
| **57.9% null ratings** | `fact_bookings.csv` | All Cancelled (33,420) and No Show (6,759) rows have no rating — expected behaviour | ✅ Expected |
| **No Show revenue = 100%** | `fact_bookings.csv` | All 6,759 No Show bookings charged full revenue_realized — business rule | ✅ Intentional |
| **Cancelled revenue = 40%** | `fact_bookings.csv` | All 33,420 cancelled bookings retain 40% of revenue — cancellation policy | ✅ Intentional |

### Fix for the `weekeday` Typo (Step-by-step)

1. Open `dim_date.csv` in VS Code or Notepad++
2. Press `Ctrl + H` → Find: `weekeday` → Replace with: `weekday`
3. Click **Replace All** (fixes all 65 rows)
4. Save and re-run the MySQL LOAD DATA statement for dim_date

---

## Project Structure

```
hotel-analytics/
│
├── hotel_project_db.sql          # MySQL schema: CREATE tables + LOAD DATA
├── hotel_project_db.pbix         # Power BI dashboard (7 pages)
│
├── dim_date.csv                  # 92 rows — date dimension (May–Jul 2022)
├── dim_hotels.csv                # 25 rows — hotel/property master data
├── dim_rooms.csv                 # 4 rows  — room type master data
├── fact_aggregated_bookings.csv  # 9,200 rows — daily capacity & occupancy
└── fact_bookings.csv             # 1,34,590 rows — individual bookings
```

> **Note:** `fact_bookings.csv` (134K rows, ~15 MB) is included in this repo.  
> If GitHub restricts the file size, download it via the [Releases](../../releases) section.

---

## How to Run

### MySQL Setup

```sql
-- 1. Clone the repo and note the path to your CSV files

-- 2. Run the SQL file (update paths to match your machine)
-- In MySQL Workbench or CLI:
SOURCE /your/path/hotel_project_db.sql;

-- Or run manually:
CREATE DATABASE IF NOT EXISTS hotel_db;
USE hotel_db;

-- Then run each CREATE TABLE and LOAD DATA block from the .sql file
-- Make sure to update the INFILE paths to your local CSV locations
```

### Power BI Setup

1. Open `hotel_project_db.pbix` in **Power BI Desktop**
2. Go to **Transform Data → Data Source Settings**
3. Update the MySQL connection (server: `localhost`, database: `hotel_db`)
4. Click **Refresh** — all 7 pages should load with live data

### Requirements
- MySQL 8.0+ with `local_infile` enabled (`SET GLOBAL local_infile = ON;`)
- Power BI Desktop (free — [download here](https://powerbi.microsoft.com/desktop/))

---

## Connect

**Nikhilesh Chouhan** — Data Analyst  
📍 Jaipur, Rajasthan  
💼 [LinkedIn](https://linkedin.com/in/nikhilesh-chouhan)  
📧 nikhileshchouhan25p@gmail.com  
🐙 [GitHub](https://github.com/nikhileshh02)

> Open to **Data Analyst** roles (full-time & internship) — feel free to reach out!

---

*Built as part of a real-world analytics portfolio | AtliQ Hotels dataset*
