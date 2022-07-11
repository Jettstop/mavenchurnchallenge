SELECT 
    gender,married,internet_service,customer_status,churn_reason
FROM
    churn.challenge
WHERE
    gender = 'male' AND married = 'no'
        AND internet_service = 'yes'
        AND customer_status = 'churned';

-- 

SELECT 
    gender,married,age,tenure_in_months,internet_service,customer_status,churn_reason
FROM
    churn.challenge
WHERE
    gender = 'male' AND married = 'no'
        AND internet_service = 'yes'
        AND customer_status = 'churned'
HAVING age BETWEEN '19' AND '40'
    AND tenure_in_months BETWEEN '10' AND '20'
ORDER BY tenure_in_months DESC;

-- The below Query is to see about our loyalty program

SELECT 
    customer_status,number_of_referrals,
    CASE
        WHEN number_of_referrals > 0 THEN 'Send Loyalty Reward'
        WHEN number_of_referrals = 0 THEN 'Send Loyalty Offer'
        ELSE 'uhoh'
    END what_to_send
FROM
    churn.challenge
WHERE
    customer_status IN ('stayed' , 'joined')
ORDER BY number_of_referrals DESC
;

-- THe below query is to see the age groups. I split them up into pre-adulthood, early adulthood, early middle age, late middle age, late adult hood
-- THe first query is for pre-adutlhood who stayed and joined. The return was 310 out of 5174 who either stayed or joined. 

SELECT 
    age,customer_status,
    CASE
        WHEN age >= 65 THEN 'Late Adulthood'
        WHEN age >= 45 THEN 'Late Middle Age'
        WHEN age >= 35 THEN 'Early Middle Age'
        WHEN age >= 22 THEN 'Early Adulthood'
        WHEN age >= 0 THEN 'Pre- Adulthood'
        ELSE 'uhoh'
    END Age_Group
FROM
    churn.challenge
WHERE
    customer_status IN ('stayed' , 'joined')
        AND age < 22
ORDER BY age DESC;

-- THe Second  query is for early adulthood who stayed and joined. The return was 1257 out of 5174 who either stayed or joined. 

SELECT 
    age,customer_status,
    CASE
        WHEN age >= 65 THEN 'Late Adulthood'
        WHEN age >= 45 THEN 'Late Middle Age'
        WHEN age >= 35 THEN 'Early Middle Age'
        WHEN age >= 22 THEN 'Early Adulthood'
        WHEN age >= 0 THEN 'Pre- Adulthood'
        ELSE 'uhoh'
    END Age_Group
FROM
    churn.challenge
WHERE
    customer_status IN ('stayed' , 'joined')
        AND age BETWEEN 22 AND 34
ORDER BY age DESC;

-- THe Second  query is for early middle age who stayed and joined. The return was 998 out of 5174 who either stayed or joined. 

SELECT 
    age,customer_status,
    CASE
        WHEN age >= 65 THEN 'Late Adulthood'
        WHEN age >= 45 THEN 'Late Middle Age'
        WHEN age >= 35 THEN 'Early Middle Age'
        WHEN age >= 22 THEN 'Early Adulthood'
        WHEN age >= 0 THEN 'Pre- Adulthood'
        ELSE 'uhoh'
    END Age_Group
FROM
    churn.challenge
WHERE
    customer_status IN ('stayed' , 'joined')
        AND age BETWEEN 35 AND 44
ORDER BY age DESC;

-- THe Second  query is for late middle age who stayed and joined. The return was 1943 out of 5174 who either stayed or joined. 

SELECT 
    age,customer_status,
    CASE
        WHEN age >= 65 THEN 'Late Adulthood'
        WHEN age >= 45 THEN 'Late Middle Age'
        WHEN age >= 35 THEN 'Early Middle Age'
        WHEN age >= 22 THEN 'Early Adulthood'
        WHEN age >= 0 THEN 'Pre- Adulthood'
        ELSE 'uhoh'
    END Age_Group
FROM
    churn.challenge
WHERE
    customer_status IN ('stayed' , 'joined')
        AND age BETWEEN 45 AND 64
ORDER BY age DESC;

-- THe Second  query is for late middle age who stayed and joined. The return was 666 out of 5174 who either stayed or joined. 

SELECT 
    age,customer_status,
    CASE
        WHEN age >= 65 THEN 'Late Adulthood'
        WHEN age >= 45 THEN 'Late Middle Age'
        WHEN age >= 35 THEN 'Early Middle Age'
        WHEN age >= 22 THEN 'Early Adulthood'
        WHEN age >= 0 THEN 'Pre- Adulthood'
        ELSE 'uhoh'
    END Age_Group
FROM
    churn.challenge
WHERE
    customer_status IN ('stayed' , 'joined')
        AND age >= 65
ORDER BY age DESC;

-- Now that we know where our age groups stand. lets keep digging in
-- I am going to see married couples and then compare them to married couples with dependants and married couples without dependants. 

SELECT 
    married,customer_status,
    CASE
        WHEN number_of_dependents > 0 THEN 'Have Dependents'
        WHEN number_of_dependents = 0 THEN 'Zero Dependents'
        ELSE 'uhoh'
    END Dependents
FROM
    churn.challenge
WHERE
    number_of_dependents > 1
        AND customer_status IN ('stayed' , 'joined');

-- This is a real problem. Less than 20% of our customers have dependents. We need a better family plan

SELECT 
    married,customer_status,multiple_lines,
    CASE
        WHEN number_of_dependents > 0 THEN 'Have Dependents'
        WHEN number_of_dependents = 0 THEN 'Zero Dependents'
        ELSE 'uhoh'
    END Dependents
FROM
    churn.challenge
WHERE
    number_of_dependents > 1
        AND phone_service = 'yes'
        AND customer_status IN ('stayed' , 'joined');

-- this is an even bigger problem. of the people 1006 people with dependents that use our service, only 399 have multiple lines. 

SELECT 
    married,customer_status,multiple_lines,contract,
    CASE
        WHEN number_of_dependents > 0 THEN 'Have Dependents'
        WHEN number_of_dependents = 0 THEN 'Zero Dependents'
        ELSE 'uhoh'
    END Dependents
FROM
    churn.challenge
WHERE
    number_of_dependents > 1
        AND multiple_lines = 'yes'
        AND customer_status IN ('stayed' , 'joined');

-- So we know that we may need a better family plan, we need a loyalty plan, and what age groups use our products the most. 
-- is there a way to see how service is in different areas?

SELECT 
    COUNT(DISTINCT (city))
FROM
    churn.challenge;

-- THERE are 1106 distinct citys.

SELECT 
    city, zip_code, customer_status, churn_reason
FROM
    churn.challenge
WHERE
    customer_status = 'churned'
        AND churn_reason IN ('Competitor had better devices' , 'Competitor offered higher download speeds',
        'Lack of affordable download/upload speed',
        'Limited range of services',
        'Product dissatisfaction',
        'Service dissatisfaction',
        'Network reliability')
GROUP BY city
ORDER BY zip_code;

-- The following query is to see which product is the issue 

SELECT 
    internet_type, customer_status, churn_reason
FROM
    churn.challenge
WHERE
    customer_status = 'churned'
        AND churn_reason IN ('Competitor had better devices' , 'Competitor offered higher download speeds',
        'Lack of affordable download/upload speed',
        'Product dissatisfaction',
        'Service dissatisfaction',
        'Network reliability');

-- There are 655 people returned for the following reasons. I chose these reasons because they COULD relate to internet type being an issue
-- I am starting with cable below

SELECT 
    internet_type, customer_status, churn_reason
FROM
    churn.challenge
WHERE
    customer_status = 'churned'
        AND churn_reason IN ('Competitor had better devices' , 'Competitor offered higher download speeds',
        'Lack of affordable download/upload speed',
        'Product dissatisfaction',
        'Service dissatisfaction',
        'Network reliability')
        AND internet_type = 'cable';


-- That returned 88. Next is DSL

SELECT 
    internet_type, customer_status, churn_reason
FROM
    churn.challenge
WHERE
    customer_status = 'churned'
        AND churn_reason IN ('Competitor had better devices' , 'Competitor offered higher download speeds',
        'Lack of affordable download/upload speed',
        'Product dissatisfaction',
        'Service dissatisfaction',
        'Network reliability')
        AND internet_type = 'DSL';

-- That returend 120. NExt is fiber optic

SELECT 
    internet_type, customer_status, churn_reason
FROM
    churn.challenge
WHERE
    customer_status = 'churned'
        AND churn_reason IN ('Competitor had better devices' , 'Competitor offered higher download speeds',
        'Lack of affordable download/upload speed',
        'Product dissatisfaction',
        'Service dissatisfaction',
        'Network reliability')
        AND internet_type = 'fiber optic';

-- That returned 442. 5 people left it blank. so fiberoptic internet type COULD be the reason for 442 people leave. This makes up 67%....

SELECT 
    internet_type, customer_status, churn_reason
FROM
    churn.challenge
WHERE
    customer_status = 'churned'
        AND churn_reason IN ('Competitor had better devices' , 'Competitor offered higher download speeds',
        'Lack of affordable download/upload speed',
        'Product dissatisfaction',
        'Service dissatisfaction',
        'Network reliability')
        AND internet_type = 'fiber optic';

-- I separated my excel into more table to play with some joins haha
-- lets see 

SELECT 
    gender, age, dependents, married, contract, payment_method
FROM
    churn.personal
        LEFT JOIN
    churn.payment ON churn.personal.customer_id = churn.payment.customer_id
WHERE
    dependents = 'dependents'
        AND contract NOT IN ('two year' , 'one year');
        

-- Im going to play with the count and case method to see if i can recreate a pivot table
-- I am going to start off easy and using churn status and dependents

SELECT 
    dependents,
    COUNT(CASE
        WHEN customer_status NOT IN ('churned') THEN customer_status
        ELSE NULL
    END) AS active_customer,
    COUNT(CASE
        WHEN customer_status IN ('churned') THEN customer_status
        ELSE NULL
    END) AS not_active_customer
FROM
    churn.personal
        LEFT JOIN
    churn.status ON churn.personal.customer_id = churn.status.customer_id
GROUP BY dependents;

-- time to see which churned customers are high priority. These customers just bring us too much revenue

SELECT 
    customer_id, total_revenue, customer_status
FROM
    churn.challenge
WHERE
    total_revenue > 5000
        AND customer_status = 'churned'
ORDER BY customer_id
