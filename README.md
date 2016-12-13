
CREATE DATABASE trainstations;
\c trainstations;

CREATE TABLE train (id serial PRIMARY KEY, route varchar);


CREATE TABLE city (id serial PRIMARY KEY, name varchar);

CREATE TABLE train_city (id SERIAL PRIMARY KEY, train_id int, city_id int, stop_time time, price int);

\c Guest

CREATE DATABASE trainstations_test WITH TEMPLATE trainstations;


<!-- USER TABLE -->

CREATE TABLE users (id serial PRIMARY KEY, username varchar, password_hash varchar, last_signin timestamp)

<!--https://sideprojectsoftware.com/blog/2015/02/22/sinatra-authentication.html  -->
