USE STAGE staging;

-- Create Staging tables
CREATE TABLE IF NOT EXISTS staging_user(data VARIANT);
CREATE TABLE IF NOT EXISTS staging_checkin(data VARIANT);
CREATE TABLE IF NOT EXISTS staging_covid(data VARIANT);
CREATE TABLE IF NOT EXISTS staging_review(data VARIANT);
CREATE TABLE IF NOT EXISTS staging_tip(data VARIANT);
CREATE TABLE IF NOT EXISTS staging_business(data VARIANT);

-- To upload data from your local computer to the Staging Area
PUT file:///home/juan/Documents/DataArchitect/WeatherAndRestaurants/data/yelp/yelp_academic_dataset_user.json @my_json_stage auto_compress=true parallel=4;
PUT file:///home/juan/Documents/DataArchitect/WeatherAndRestaurants/data/yelp/yelp_academic_dataset_checkin.json @my_json_stage auto_compress=true parallel=4;
PUT file:///home/juan/Documents/DataArchitect/WeatherAndRestaurants/data/yelp/yelp_academic_dataset_covid_features.json @my_json_stage auto_compress=true parallel=4;
PUT file:///home/juan/Documents/DataArchitect/WeatherAndRestaurants/data/yelp/yelp_academic_dataset_review.json @my_json_stage auto_compress=true parallel=4;
PUT file:///home/juan/Documents/DataArchitect/WeatherAndRestaurants/data/yelp/yelp_academic_dataset_tip.json @my_json_stage auto_compress=true parallel=4;
PUT file:///home/juan/Documents/DataArchitect/WeatherAndRestaurants/data/yelp/yelp_academic_dataset_business.json @my_json_stage auto_compress=true parallel=4;

COPY INTO staging_user FROM @my_json_stage/yelp_academic_dataset_user.json.gz;
COPY INTO staging_checkin FROM @my_json_stage/yelp_academic_dataset_checkin.json.gz;
COPY INTO staging_covid FROM @my_json_stage/yelp_academic_dataset_covid_features.json.gz;
COPY INTO staging_review FROM @my_json_stage/yelp_academic_dataset_review.json.gz;
COPY INTO staging_tip FROM @my_json_stage/yelp_academic_dataset_tip.json.gz;
COPY INTO staging_business FROM @my_json_stage/yelp_academic_dataset_business.json.gz;
