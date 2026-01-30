-- TASK ONE

-- using the bookings.airports_data table
SELECT
    airport_code AS airportCode,
    UPPER(TRIM(airport_name ->> 'en')) AS airportCleanedName,
    LOWER(city ->> 'en') AS cityCleaned,
    LENGTH(airport_name ->> 'en') AS nameLength
FROM bookings.airports_data
WHERE
    airport_name ->> 'en' ILIKE '%international%'
    AND city IS NULL
    AND LENGTH(airport_name ->> 'en') BETWEEN 10 AND 40
ORDER BY nameLength DESC
LIMIT 15; 

-- using the bookings.airports view

SELECT
    airport_code AS airportCode,
    UPPER(TRIM(airport_name)) AS airportCleanedName,
    LOWER(city) AS cityCleaned,
    LENGTH(airport_name) AS nameLength
FROM bookings.airports
WHERE
    airport_name ILIKE '%international%'
    AND city IS NULL
    AND LENGTH(airport_name) BETWEEN 10 AND 40
ORDER BY nameLength DESC
LIMIT 15; 
  
-- TASK TWO
SELECT
    CONCAT(departure_airport, '-', arrival_airport) AS DepArr,
    COUNT(*) AS totalFlightsNumberOnTheRoute,
    AVG(EXTRACT(EPOCH FROM(actual_arrival - actual_departure))/60) AS averageFlightDuration
FROM bookings.flights
WHERE
    actual_departure IS NOT NULL
    AND departure_airport IN ('JFK', 'LAX', 'SFO')
GROUP BY
    departure_airport,
    arrival_airport
HAVING
    COUNT(*) >= 5
    AND AVG(EXTRACT(EPOCH FROM(actual_arrival - actual_departure))/60) <> 0
LIMIT 10;

-- TASK  THREE

SELECT
    UPPER(t.passenger_name) AS passengerName,
    COUNT(tf.flight_id) AS totalFlightsTaken,
    SUM(tf.amount) AS totalAmountSpend,
    ROUND(AVG(CAST(tf.amount AS NUMERIC)), 2) AS averageAmountPerFlight
FROM bookings.tickets t
JOIN bookings.ticket_flights tf
    ON t.ticket_no = tf.ticket_no
WHERE
    t.passenger_name IS NOT NULL
    AND t.passenger_name LIKE '% %'
    AND tf.amount BETWEEN 50 AND 5000
GROUP BY
    UPPER(t.passenger_name)
HAVING
    COUNT(t.passenger_id) > 1
LIMIT 100;
