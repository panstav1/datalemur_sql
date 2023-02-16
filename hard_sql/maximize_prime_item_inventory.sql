-- Solution Thoughts
--    Aggregate on the two types, get the aggregated data and make the necessary calculations.
--    Yet, one solution would be to do this in a main table for each type
--    In this solution, it is kept simple by getting the operations in the two different types
--    and combine them (union) after.

-- Notes:
-- 1. It would be good to set variables when numbers are hardcoded (like inventory max square feet)
WITH agg_data
     AS (
        -- create a table that includes the number of items and the corresponding square feet per item_type
        -- in aggregated mode
        SELECT item_type,
               COUNT(square_footage) AS count_items,
               SUM(square_footage) AS   sqft_sum
         FROM   inventory
         GROUP  BY item_type),
     prime_items
     AS (
        -- create a table to work on the prime_eligible aggregated data (agg_data)
        -- start with division to find the combination of the prime_eligible items
        -- and the item count in them
        SELECT item_type,
               sqft_sum,
               TRUNC(500000 / sqft_sum, 0)               AS prime_item_combo,
               TRUNC(500000 / sqft_sum, 0) * count_items AS prime_item_count
         FROM   agg_data
         WHERE  item_type = 'prime_eligible'),
     non_prime
     AS (
        -- calculate what is left from prime eligible to the not prime eligible
        SELECT item_type,
               TRUNC(( 500000 - (SELECT prime_item_combo * sqft_sum
                                 FROM   prime_items) ) / sqft_sum, 0) *count_items AS not_prime_item_count
         FROM   agg_data
         WHERE  item_type = 'not_prime')
-- Connect these two results from the CTEs above
SELECT item_type,
       prime_item_count
FROM   prime_items
UNION ALL
SELECT item_type,
       not_prime_item_count
FROM   non_prime  