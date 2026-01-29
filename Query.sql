 TASK ONE
SELECT
    airport_code AS airportCode,
    UPPER(TRIM(airport_name > 'en')) AS airportCleanedName,
    LOWER(city) AS cityCleaned,
    LENGTH(airport_name) AS nameLength
FROM airports
WHERE
    airport_name ILIKE '%international%'
    AND (city IS NULL OR TRIM(city) = '')
    AND LENGTH(airport_name) BETWEEN 10 AND 40
ORDER BY nameLength DESC
LIMIT 15; 
  
-- TASK TWO
SELECT
    CONCAT(departure_airport, '-', arrival_airport) AS route,
    COUNT(*) AS totalFlightsNumberOnTheRoute,
    AVG(CAST(flight_duration AS INTEGER)) AS averageFlightDuration
FROM flights
WHERE
    actual_departure IS NOT NULL
    AND departure_airport IN ('JFK', 'LAX', 'SFO')
GROUP BY
    departure_airport,
    arrival_airport
HAVING
    COUNT(*) >= 5
    AND AVG(CAST(flight_duration AS INTEGER)) <> 0
LIMIT 10;

-- TASK  THREE

SELECT
    UPPER(t.passenger_name) AS passengerName,
    COUNT(tf.flight_id) AS totalFlightsTaken,
    SUM(tf.amount) AS totalAmountSpend,
    ROUND(AVG(CAST(tf.amount AS NUMERIC)), 2) AS averageAmountPerFlight
FROM tickets t
JOIN ticket_flights tf
    ON t.ticket_no = tf.ticket_no
WHERE
    t.passenger_name IS NOT NULL
    AND t.passenger_name LIKE '% %'
    AND tf.amount BETWEEN 50 AND 5000
GROUP BY
    UPPER(t.passenger_name)
HAVING
    COUNT(tf.flight_id) > 1
LIMIT 100;

