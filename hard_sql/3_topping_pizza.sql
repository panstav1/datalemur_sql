-- Solution Thoughts
--    Since all combinations are demanded, you are guided to use cross join. 
--	  Yet, mutual pizza toppings should not be present.
--    The solution below uses a smart way to play with this equation of assuming smaller in
--	  string as preceded in alphabetical order



SELECT 
  CONCAT(p1.topping_name, ',', p2.topping_name, ',', p3.topping_name) AS pizza,
  p1.ingredient_cost + p2.ingredient_cost + p3.ingredient_cost AS total_cost
FROM pizza_toppings AS p1
-- 1. Start from the cross join of getting the full combination landscape
CROSS JOIN
  pizza_toppings AS p2,
  pizza_toppings AS p3
-- 2. Assume that alphabetical order provides compare functionalities
WHERE p1.topping_name < p2.topping_name
  AND p2.topping_name < p3.topping_name
ORDER BY total_cost DESC, pizza;