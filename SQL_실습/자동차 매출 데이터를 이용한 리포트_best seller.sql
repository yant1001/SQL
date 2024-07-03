-- 미국의 연도별 Top 5 차량 모델 조회
USE classicmodels;

SELECT SUBSTR(B.orderDate, 1, 4) AS YY,
	   D.productName,
	   SUM(C.quantityOrdered*C.priceEach) AS SALES,		-- 집계값을 select 하게 되면 반드시 group by가 들어가야 한다.
       ROW_NUMBER() OVER(ORDER BY SUM(C.quantityOrdered*C.priceEach) DESC) AS RNK
FROM customers A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
LEFT JOIN orderdetails C
ON B.orderNumber = C.orderNumber
LEFT JOIN products D
ON C.productCode = D.productCode
WHERE A.country = 'USA'
GROUP BY 1, 2
ORDER BY 1, 2;


-- 책 풀이 (연도 컬럼 적용이 안되어 있다.)
CREATE TABLE classicmodels.product_sales AS
SELECT D.productname,
	   SUM(quantityOrdered*priceEach) SALES
FROM orders A
LEFT JOIN customers B
ON A.customerNumber = B.customerNumber
LEFT JOIN orderDetails C
ON A.orderNumber = C.orderNumber
LEFT JOIN products D
ON C.productCode = D.productCode
WHERE B.country = 'USA'
GROUP BY 1;

SELECT * 
FROM 
	(SELECT *,
		    ROW_NUMBER() OVER(ORDER BY SALES DESC) RNK
	 FROM classicmodels.product_sales
     ) A
WHERE RNK <= 5
ORDER BY RNK;

