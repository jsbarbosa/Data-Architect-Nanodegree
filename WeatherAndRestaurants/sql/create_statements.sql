-- Create database if not exists
CREATE DATABASE IF NOT EXISTS udacity;
USE DATABASE udacity;

-- Create schema if not exists
CREATE SCHEMA IF NOT EXISTS staging;

-- Create schema if not exists
CREATE SCHEMA IF NOT EXISTS ods;


-- Create schema if not exists
CREATE SCHEMA IF NOT EXISTS dwh;


-- Create a JSON file format
CREATE OR REPLACE FILE FORMAT myjsonformat type='JSON' strip_outer_array=true;
