USE STAGE ods;

-- USER

CREATE TABLE IF NOT EXISTS user(
	user_id             VARCHAR,
	name                VARCHAR,
	review_count        NUMBER,
	yelping_since       DATE,
	friends             VARIANT,
	useful              NUMBER,
	funny               NUMBER,
	cool                NUMBER,
	fans                NUMBER,
	elite               VARIANT,
	average_stars       FLOAT,
	compliment_hot      NUMBER,
	compliment_more     NUMBER,
	compliment_profile  NUMBER,
	compliment_cute     NUMBER,
	compliment_list     NUMBER,
	compliment_note     NUMBER,
	compliment_plain    NUMBER,
	compliment_cool     NUMBER,
	compliment_funny    NUMBER,
	compliment_writer   NUMBER,
	compliment_photos   NUMBER
);

INSERT INTO user (
    user_id,
    name,
    review_count,
    yelping_since,
    useful,
    funny,
    cool,
    elite,
    friends,
    fans,
    average_stars,
    compliment_hot,
    compliment_more,
    compliment_profile,
    compliment_cute,
    compliment_list,
    compliment_note,
    compliment_plain,
    compliment_cool,
    compliment_funny,
    compliment_writer,
    compliment_photos
)
SELECT
    parse_json($1):user_id,
    parse_json($1):name,
    parse_json($1):review_count,
    TO_DATE(parse_json($1):yelping_since),
    parse_json($1):useful,
    parse_json($1):funny,
    parse_json($1):cool,
    parse_json($1):elite,
    parse_json($1):friends,
    parse_json($1):fans,
    parse_json($1):average_stars,
    parse_json($1):compliment_hot,
    parse_json($1):compliment_more,
    parse_json($1):compliment_profile,
    parse_json($1):compliment_cute,
    parse_json($1):compliment_list,
    parse_json($1):compliment_note,
    parse_json($1):compliment_plain,
    parse_json($1):compliment_cool,
    parse_json($1):compliment_funny,
    parse_json($1):compliment_writer,
    parse_json($1):compliment_photos
FROM
    staging.staging_user;

-- REVIEW

CREATE TABLE IF NOT EXISTS review(
    review_id           VARCHAR,
	user_id             VARCHAR,
	business_id         VARCHAR,
	stars               NUMBER,
	date                DATE,
	text_field          TEXT,
	useful              NUMBER,
	funny               NUMBER,
	cool                NUMBER
);

INSERT INTO review (
    review_id,
    user_id,
    business_id,
    stars,
    date,
    text_field,
    useful,
    funny,
    cool
)
SELECT
    parse_json($1):review_id,
    parse_json($1):user_id,
    parse_json($1):business_id,
    parse_json($1):stars,
    TO_DATE(parse_json($1):date),
    parse_json($1):text_field,
    parse_json($1):useful,
    parse_json($1):funny,
    parse_json($1):cool
FROM
    staging.staging_review;

-- Business

CREATE TABLE IF NOT EXISTS business(
    business_id         VARCHAR,
	name                VARCHAR,
	address             VARCHAR,
	city                VARCHAR,
	state               VARCHAR,
	postal_code         VARCHAR,
	latitude            FLOAT,
	longitude           FLOAT,
	stars               FLOAT,
	review_count        NUMBER,
	is_open             NUMBER,
	attributes          VARIANT,
	categories          VARIANT,
	hours               VARIANT
);

INSERT INTO business(
    business_id,
    name,
    address,
    city,
    state,
    postal_code,
    latitude,
    longitude,
    stars,
    review_count,
    is_open,
    attributes,
    categories,
    hours
)
SELECT
    parse_json($1):business_id,
    parse_json($1):name,
    parse_json($1):address,
    parse_json($1):city,
    parse_json($1):state,
    parse_json($1):postal_code,
    parse_json($1):latitude,
    parse_json($1):longitude,
    parse_json($1):stars,
    parse_json($1):review_count,
    parse_json($1):is_open,
    parse_json($1):attributes,
    parse_json($1):categories,
    parse_json($1):hours
FROM
    staging.staging_business;

-- Checkin

CREATE TABLE IF NOT EXISTS checkin(
    business_id         VARCHAR,
	date                TEXT
);

INSERT INTO checkin(
    business_id,
    date
)
SELECT
    parse_json($1):business_id,
    parse_json($1):date
FROM
    staging.staging_checkin;

-- Covid

CREATE TABLE IF NOT EXISTS covid(
    business_id             VARCHAR,
	highlights              VARIANT,
	delivery_or_takeout     VARCHAR,
	grubhub_enabled         VARCHAR,
	call_to_action_enabled  VARCHAR,
	request_quote_enabled   VARCHAR,
	covid_banner            VARCHAR,
	temporary_closed_until  VARCHAR,
	virtual_services        VARCHAR
);

INSERT INTO covid (
    business_id,
    highlights,
    delivery_or_takeout,
    grubhub_enabled,
    call_to_action_enabled,
    request_quote_enabled,
    covid_banner,
    temporary_closed_until,
    virtual_services
)
SELECT
    parse_json($1):business_id,
    parse_json($1):highlights,
    parse_json($1):delivery_or_takeout,
    parse_json($1):Grubhub_enabled,
    parse_json($1):Call_To_Action_enabled,
    parse_json($1):Request_a_Quote_Enabled,
    parse_json($1):Covid_Banner,
    parse_json($1):Temporary_Closed_Until,
    parse_json($1):Virtual_Services_Offered
FROM
    staging.staging_covid;

-- TIP

CREATE TABLE IF NOT EXISTS tip(
    text                    VARCHAR,
	date                    DATE,
	compliment_count        NUMBER,
	business_id             VARCHAR,
	user_id                 VARCHAR
);

INSERT INTO tip (
    text,
    date,
    compliment_count,
    business_id,
    user_id
)
SELECT
    parse_json($1):text,
    TO_DATE(parse_json($1):date),
    parse_json($1):compliment_count,
    parse_json($1):business_id,
    parse_json($1):user_id
FROM
    staging.staging_tip;


-- PRECIPITATION

CREATE TABLE IF NOT EXISTS precipitation(
    precipitation_id        NUMBER AUTOINCREMENT,
    date                    DATE,
	precipitation           FLOAT,
	precipitation_normal    FLOAT
);

INSERT INTO precipitation (
    date,
    precipitation,
    precipitation_normal
)
SELECT
    TO_DATE(date, 'YYYYMMDD'),
    TRY_CAST(precipitation AS FLOAT),
    precipitation_normal
FROM
    staging.staging_precipitation;

-- TEMPERATURE

CREATE TABLE IF NOT EXISTS temperature(
    temperature_id  NUMBER AUTOINCREMENT,
    date            DATE,
	min             FLOAT,
	max             FLOAT,
	normal_min      FLOAT,
	normal_max      FLOAT
);

INSERT INTO temperature (
    date,
    min,
    max,
    normal_min,
    normal_max
)
SELECT
    TO_DATE(date, 'YYYYMMDD'),
    min,
    max,
    normal_min,
    normal_max
FROM
    staging.staging_temperature;
