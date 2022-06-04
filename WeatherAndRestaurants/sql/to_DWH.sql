USE SCHEMA dwh;

CREATE TABLE dimension_user CLONE ods.user;
CREATE TABLE dimension_business CLONE ods.business;

CREATE TABLE dimension_precipitation CLONE ods.precipitation;
ALTER TABLE dimension_precipitation DROP COLUMN date;

CREATE TABLE dimension_temperature CLONE ods.temperature;
ALTER TABLE dimension_temperature DROP COLUMN date;

CREATE TABLE dimension_date AS
SELECT
    date,
    YEAR(date) AS year,
    MONTH(date) AS month,
    DAY(date) AS day
FROM
    ods.review
GROUP BY date;

CREATE TABLE fact_review AS
SELECT
    review.review_id,
    review.user_id,
    review.business_id,
    review.date,
    precipitation_id,
    temperature_id,
    review.stars,
    review.useful,
    review.funny,
    review.cool
FROM
    ods.review
        LEFT JOIN
    ods.precipitation ON precipitation.date = review.date
        LEFT JOIN
    ods.temperature ON temperature.date = review.date;
