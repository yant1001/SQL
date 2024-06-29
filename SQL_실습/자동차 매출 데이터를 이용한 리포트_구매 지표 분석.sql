-- 1. 매출액 조회
-- 1.1 일별 매출액 조회
USE classicmodels;
SELECT * FROM orders;
SELECT * FROM orderdetails;
-- 일자별 그루핑 전
SELECT A.ORDERDATE, 
	   PRICEEACH*QUANTITYORDERED
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER;
-- 일자별 그루핑 후
SELECT A.ORDERDATE, 
	   SUM(PRICEEACH*QUANTITYORDERED) AS SALES
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP BY 1	-- SELECT절 중 1번째 위치한 기준으로 그루핑하겠다는 의미 (ORDER BY도 동일)
ORDER BY 1;

-- 1.2 월별 매출액 조회
-- 문자열에서 원하는 부분만 호출하는 SUBSTR(컬럼, 위치, 길이) 함수 사용
SELECT SUBSTR(A.ORDERDATE, 1, 7) AS ORDER_MONTH,
	   SUM(PRICEEACH*QUANTITYORDERED) AS SALES
FROM ORDERS A
LEFT JOIN ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP BY 1
ORDER BY 1;

-- 1.3 연도별 매출액 조회
SELECT SUBSTR(A.ORDERDATE, 1, 4) AS ORDER_YEAR,
	   SUM(PRICEEACH*QUANTITYORDERED) AS SALES
FROM ORDERS A
LEFT JOIN ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP BY 1
ORDER BY 1;


-- 2. 구매자 수, 구매 건수 조회
-- 2.1 구매자 수 조회
-- 구매자 수를 셀 때는 중복 카운트되지 않도록 COUNT(DISCTINCT 컬럼)을 사용해야 한다.
SELECT COUNT(customerNumber) AS N_purchaser,
	   COUNT(DISTINCT customerNumber) AS N_purchaser_distinct
FROM ORDERS
ORDER BY customerNumber ASC;

-- 2.2 구매 건수 조회
SELECT COUNT(customerNumber) AS N_purchaser,
	   COUNT(DISTINCT customerNumber) AS N_purchaser_distinct,
       COUNT(orderNumber) AS N_order,
	   COUNT(DISTINCT orderNumber) AS N_order_distinct
FROM ORDERS;

-- 2.3 월별 구매자 수
SELECT SUBSTR(orderdate, 1, 7) AS Order_Month,
	   COUNT(customerNumber) AS N_purchaser,
	   COUNT(DISTINCT customerNumber) AS N_purchaser_distinct
FROM ORDERS
GROUP BY 1
ORDER BY 1;

-- 2.4 연도별 구매자 수
SELECT SUBSTR(orderdate, 1, 4) Order_Year,
	   COUNT(customerNumber) AS N_purchaser,
	   COUNT(DISTINCT customerNumber) AS N_purchaser_distinct
FROM ORDERS
GROUP BY 1
ORDER BY 1;


-- 3. 인당 연도별 매출액
SELECT SUBSTR(orderdate, 1, 4) Order_Year,
	   COUNT(DISTINCT customerNumber) AS N_purchaser_distinct,
       ROUND(SUM(PRICEEACH*QUANTITYORDERED), 0) AS SALES,
       ROUND(SUM(PRICEEACH*QUANTITYORDERED) / COUNT(DISTINCT customerNumber), 0) AS Average_Member_Value
FROM ORDERS A
LEFT JOIN ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP BY 1
ORDER BY 1;


-- 4. 건당 연도별 구매 금액
SELECT SUBSTR(orderdate, 1, 4) Order_Year,
	   COUNT(DISTINCT A.orderNumber) AS N_order_distinct,
       ROUND(SUM(PRICEEACH*QUANTITYORDERED), 0) AS SALES,
       ROUND(SUM(PRICEEACH*QUANTITYORDERED) / COUNT(DISTINCT A.orderNumber), 0) AS Average_Transaction_Value
FROM ORDERS A
LEFT JOIN ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
GROUP BY 1
ORDER BY 1;