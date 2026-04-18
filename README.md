# Hotel Revenue Analytics Dashboard
## MySQL + Power BI | AtliQ Hotels | Hospitality KPIs

## Project Overview
Built a 7-page interactive Power BI dashboard for AtliQ Hotels chain
analyzing 1,34,590 real booking records across 25 properties in 4 Indian cities.

## Key Findings
- Total Revenue Realized: Rs. 170.88 Crore (3 months)
- Cancellation Rate: 24.8% (1 in 4 bookings cancelled)
- Top City: Mumbai (Rs. 66.86 Crore)
- Luxury segment: 61.6% of total revenue
- Best rated city: Delhi (3.78 avg rating)
- Top Property: Atliq Exotica (Rs. 32 Crore)

## Tech Stack
- MySQL — LOAD DATA INFILE, Star Schema design, FK relationships
- Power BI — DAX measures, Star Schema model, 7-page dashboard

## DAX Measures Built
Revenue | RevPAR | ADR | Occupancy % | Realisation % | DSRN | DBRN | DURN
Cancellation % | Average Rating | WoW % change for all 6 KPIs

## Data Model (Star Schema)
- fact_bookings (1,34,590 rows)
- fact_aggregated_bookings (9,200 rows)
- dim_hotels (25 properties)
- dim_rooms (4 room types)
- dim_date (92 days)

## Files
- hotel_project_db.sql — MySQL database setup and queries
- hotel_project_db.pbix — Power BI dashboard file
- dim_hotels.csv, dim_rooms.csv, dim_date.csv — dimension data
- Note: fact_bookings.csv (134K rows) available on request
