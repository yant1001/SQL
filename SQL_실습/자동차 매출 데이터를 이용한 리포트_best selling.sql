-- 미국의 Top 5 차량 모델 조회
USE classicmodels;

SELECT A.city,
	   SUBSTR(B.orderDate, 1, 4),
	   D.productName,
       
FROM customers A
LEFT JOIN orders B
ON A.customerNumber = B.customerNumber
LEFT JOIN orderdetails C
ON B.orderNumber = C.orderNumber
LEFT JOIN products D
ON C.productCode = D.productCode
GROUP BY 1
ORDER BY 1;
