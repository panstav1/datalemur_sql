 -- Solution Thoughts
--    Advertiser table contains all existing customers, yet payments might include customer that paid
--    that are not in the former table. Thus, a full outer join is planned in the CTE. Then, coalesce the
--    IDs to get one ID either if same or Null and apply the logic as defined from the assignment


WITH payments
     -- Execute the full outer join to bring all customers
     -- (and the ones that paid but not in advertiser table)
     AS (SELECT advertiser.user_id user_id_advert,
                daily_pay.user_id  user_id_paid,
                advertiser.status  status,
                daily_pay.paid     paid
         FROM   advertiser
                FULL OUTER JOIN daily_pay
                             ON daily_pay.user_id = advertiser.user_id)
-- Coalesce the main ID to get one unified and cover Null Cases from full outer join
SELECT COALESCE(user_id_advert, user_id_paid) user_id,
       CASE
         -- in case of churn and paid, then you need to resurrect. this is the only outlier
         WHEN status = 'CHURN' AND paid IS NOT NULL THEN 'RESURRECT'
         -- status is NULL means no presence in advertiser but in paid
         WHEN status IS NULL THEN 'NEW'
         -- paid is NULL means did not paid
         WHEN paid IS NULL THEN 'CHURN'
         ELSE 'EXISTING'
       END
FROM   payments
ORDER  BY user_id  