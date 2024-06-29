USE classicmodels;

-- 재구매율이란, 특정 A 기간의 구매자 중 특정 B 기간에 연달아 구매한 구매자의 비중을 의미한다.
-- 1. 연도별 재구매율
SELECT year,
	   COUNT(DISTINCT this_year_customer)/COUNT(DISTINCT last_year_customer)*100 AS '재구매율(%)'
FROM (SELECT A.customerNumber AS last_year_customer,
			 B.customerNumber AS this_year_customer,
			 A.orderdate AS '전년도 구매일자',
			 B.orderdate AS '이번년도 구매일자',
			 SUBSTR(A.orderdate, 1, 4) AS year,
             C.country
	  FROM orders A
	  LEFT JOIN orders B
	  ON A.customerNumber = B.customerNumber
	  AND SUBSTR(A.orderdate, 1, 4) = SUBSTR(B.orderdate, 1, 4)-1
      LEFT JOIN customers C
      ON B.customerNumber = C.customerNumber
   	  ) A
GROUP BY 1;

-- 2. 국가별 연도별 재구매율
SELECT C.country,
	   SUBSTR(A.orderdate, 1, 4) AS year,
       COUNT(DISTINCT A.customerNumber) AS 'customer_NUM1',
	   COUNT(DISTINCT B.customerNumber) AS 'customer_NUM2',
	   COUNT(DISTINCT B.customerNumber)/COUNT(DISTINCT A.customerNumber)*100 AS '재구매율(%)'
FROM orders A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
AND SUBSTR(A.orderdate, 1, 4) = SUBSTR(B.orderdate, 1, 4)-1
LEFT JOIN customers C
ON A.customerNumber = C.customerNumber
GROUP BY 1, 2;