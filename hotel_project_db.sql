create database hotel_db;
use hotel_db;


create table dim_rooms
(
	room_id		varchar(50) primary key,
	room_class	varchar(50)

);

SET global local_infile = ON;

LOAD DATA LOCAL INFILE 'N:/data_powerbi&sqldata/data/dim_rooms.csv'
into table dim_rooms
fields terminated by ','
OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
ignore 1 rows;



create table dim_hotels
(
	property_id		int primary key,
	property_name	varchar(50),
	category	    varchar(50),
	city 			varchar(50)

);

SET global local_infile = ON;

LOAD DATA LOCAL INFILE 'N:/data_powerbi&sqldata/data/dim_hotels.csv'
into table dim_hotels
fields terminated by ','
OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
ignore 1 rows;



create table dim_date
(
	`date` 		DATE primary key,
	mmm_yy  	VARCHAR(20),
	week_no		VARCHAR(10),
	day_type 	VARCHAR(20)

);



SET global local_infile = ON;

LOAD DATA LOCAL INFILE 'N:/data_powerbi&sqldata/data/dim_date.csv'
into table dim_date
fields terminated by ','
OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
ignore 1 rows;



CREATE TABLE fact_bookings
(  
	booking_id 			varchar(50) primary key,
	property_id			int,
    booking_date		date,
    check_in_date		date,
    checkout_date		date,
    no_guests			int,
    room_category		varchar(50),
    booking_platform	varchar(50),
    ratings_given		decimal(2,1),
    booking_status		varchar(30),
    revenue_generated	int,
    revenue_realized	int,
    
    foreign key (property_id) references dim_hotels(property_id),
    foreign key (room_category) references dim_rooms(room_id),
    foreign key (check_in_date) references dim_date(`date`)
 
);

SET global local_infile = ON;

LOAD DATA LOCAL INFILE 'N:/data_powerbi&sqldata/data/fact_bookings.csv'
into table fact_bookings
fields terminated by ','
OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
ignore 1 rows;



create table fact_aggregated_bookings
(
	property_id				int,
	check_in_date			date,
	room_category			varchar(50),
	successful_bookings 	int,
	capacity 				int,
	
    primary key (property_id, check_in_date, room_category),
	foreign key (property_id) references dim_hotels(property_id),
    foreign key (check_in_date) references dim_date(`date`),
    foreign key (room_category) references dim_rooms(room_id)
);

SET global local_infile = ON;

LOAD DATA LOCAL INFILE 'N:/data_powerbi&sqldata/data/fact_aggregated_bookings.csv'
into table fact_aggregated_bookings
fields terminated by ','
OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
ignore 1 rows;







