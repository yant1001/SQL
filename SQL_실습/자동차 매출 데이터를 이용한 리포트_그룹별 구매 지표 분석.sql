-- 1. 국가별, 도시별 매출액
-- 주문 발생 국가, 도시를 알기 위해서는 customers, orders, orderdetails 총 3개 테이블을 사용해야 한다.
USE classicmodels;
SELECT country,
	   city,
	   ROUND(SUM(quantityOrdered*priceEach), 0) AS sales
FROM customers A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
LEFT JOIN orderdetails C
ON B.orderNumber = C.orderNumber
GROUP BY 1, 2
ORDER BY 1, 2;

-- 2. 특정 지역을 조건으로 매출액 추출 (북미 vs 비북미)
-- CASE WHEN THEN 조건절 사용해서 국가 구분
SELECT 
    CASE
        WHEN country IN ('USA' , 'Canada') THEN 'North America'
        ELSE 'Others'
    END Country_GRP
FROM
    customers;
-- 위 쿼리를 사용해서 북비 vs 비북미 매출액 비교
SELECT
    CASE
        WHEN A.country IN ('USA' , 'Canada') THEN 'North America'
        ELSE 'Others'
    END AS Country_GRP,
    ROUND(SUM(C.quantityOrdered*C.priceEach), 0) AS Sales
FROM customers A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
LEFT JOIN orderdetails C
ON B.orderNumber = C.orderNumber
GROUP BY 1
ORDER BY 2 DESC;

-- 3. 매출 Top5 국가 및 매출
-- 3.1 서브쿼리 미사용ver
-- Rank, Dense Rank, Row Number을 사용한다. (동률을 반영하는 방식 차이에 주의)
SELECT A.country,
       ROUND(SUM(priceEach*quantityOrdered), 0) AS sales
FROM customers A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
LEFT JOIN orderdetails C
ON B.orderNumber = C.orderNumber
GROUP BY 1
ORDER BY 2 DESC;
-- 위 쿼리를 사용해서 테이블을 새로 생성한다.
CREATE TABLE classicmodels.STAT AS
SELECT A.country,
       ROUND(SUM(priceEach*quantityOrdered), 0) AS sales
FROM customers A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
LEFT JOIN orderdetails C
ON B.orderNumber = C.orderNumber
GROUP BY 1
ORDER BY 2 DESC;
-- STAT 테이블 조회
SELECT * 
FROM STAT;
-- 등수 매기기
SELECT country,
	   sales,
       DENSE_RANK() OVER(ORDER BY sales DESC) AS country_rank
FROM STAT;
-- 위 쿼리를 사용해서 테이블을 새로 생성한다.
CREATE TABLE STAT_RNK AS
SELECT country,
	   sales,
       DENSE_RANK() OVER(ORDER BY sales DESC) AS country_rank
FROM STAT;
-- STAT_RNK 테이블 조회
SELECT * 
FROM STAT_RNK;
-- STAT_RANK 테이블에서 매출 상위 5개 국가 조회
SELECT *
FROM STAT_RNK
WHERE country_rank <= 5;

-- 3.2 서브쿼리 사용ver
-- 서브쿼리는 다른 하나의 SQL 문장의 절에 포함된 "SELECT 문장"을 의미한다.
-- 서브쿼리를 FROM이나 JOIN에 사용하는 경우에는 쿼리 마지막에 AS 별칭 문자를 입력해줘야 오류가 나지 않는다.
SELECT *
FROM (
	SELECT country,
		   sales,
		   DENSE_RANK() OVER(ORDER BY sales DESC) AS RNK
	FROM (SELECT country,
			     ROUND(SUM(priceEach*quantityOrdered), 0) AS sales
		  FROM customers A
		  LEFT JOIN orders B
		  ON A.customerNumber = B.customerNumber
		  LEFT JOIN orderdetails C
		  ON B.orderNumber = C.orderNumber
		  GROUP BY 1) AS country_sales
        ) AS country_rnk
WHERE RNK BETWEEN 1 AND 5;	-- WHERE절은 FROM절에 위치한 테이블에서만 조건을 걸 수 있다.