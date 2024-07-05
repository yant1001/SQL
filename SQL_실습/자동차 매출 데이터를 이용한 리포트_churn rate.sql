USE classicmodels;

/*
churn rate: 활동 고객 중 얼마나 많은 고객이 비활동 고객으로 전환되었는지 의미하는 지표
고객 한명을 획득하는 비용(Acquisition Cost)이 헛되지 않게, 한번 획득한 고객을 활동 고객으로 유지하는 것은 매우 중요하다.
이탈 고객을 예측하고, 예측 결과를 바탕으로 적절한 마케팅 전략을 취하려고 하는 이유도 같은 맥락

Churn: 마지막 구매 혹은 접속일 이후 일정 기간(기업마다 상이) 구매, 접속하지 않은 상태
Churn Rate: 전체 고객 중에 Churn에 해당하는 고객의 비중
*/

-- orders 테이블의 마지막 구매일
SELECT MAX(orderdate) AS MX_ORDER
FROM orders;

-- orders 테이블의 각 고객별 마지막 구매일
SELECT customerNumber,
	   MAX(orderdate) AS MX_ORDER
FROM orders
GROUP BY 1;

-- DateDiff(A, B): 두 날짜값의 차이를 int로 반환하는 함수 (A-B)
SELECT customerNumber,
	   MAX_ORDER,
	   DATEDIFF('2005-06-01', MAX_ORDER) AS 'Date Diff from 2005-06-01'
FROM (SELECT customerNumber,
			 MAX(orderdate) AS MAX_ORDER
	  FROM orders
      GROUP BY 1) A
;

-- 날짜값 차이가 90일 이상일 경우를 Churn으로 가정
SELECT *,
	   CASE WHEN DIFF >= 90 
			THEN 'Churn' 
            ELSE 'Non-Churn'
	   END Churn_Type
FROM (SELECT customerNumber,
	   MAX_ORDER,
	   DATEDIFF('2005-06-01', MAX_ORDER) AS DIFF   -- 작은 따옴표를 이용해 문자열로 표현 가능하지만, 나중에 변수명으로 호출 불가능해진다.
	  FROM (SELECT customerNumber,
				   MAX(orderdate) AS MAX_ORDER
		    FROM orders
		    GROUP BY 1) A) B
;

-- Churn Rate 구하기
SELECT CASE WHEN DIFF >= 90
		    THEN 'Churn'
            ELSE 'Non-Churn'
            END Churn_Type,
	   COUNT(DISTINCT customerNumber) customer_Num
FROM (SELECT customerNumber,
		     MAX_ORDER,
             '2005-06-01' AS END_Point,
             DATEDIFF('2005-06-01', MAX_ORDER) AS DIFF
	  FROM (SELECT customerNumber,
				   MAX(orderdate) AS MAX_ORDER
			FROM orders
            GROUP BY 1) A) A
GROUP BY 1;
-- 이탈률은 69/(69+29) = 약 70%

-- 이탈 고객 특성 파악하기 > 이탈 고객이 가장 많이 구매한 Productline 제품군은?
CREATE TABLE churn_list AS
SELECT CASE WHEN DIFF >= 90
		    THEN 'Churn'
            ELSE 'Non-Churn'
            END Churn_Type,
	   customerNumber
FROM (SELECT customerNumber,
		     MAX_ORDER,
             '2005-06-01' AS END_Point,
             DATEDIFF('2005-06-01', MAX_ORDER) AS DIFF
	  FROM (SELECT customerNumber,
				   MAX(orderdate) AS MAX_ORDER
			FROM orders
            GROUP BY 1) A) A
;

SELECT *
FROM churn_list;

SELECT B.productline,
	   COUNT(DISTINCT C.customerNumber) AS NUM
FROM orderdetails A						-- 3개의 테이블을 연결할 때 그 중간 테이블을 A 테이블로 두는게 더 알아보기 쉬운 듯
LEFT JOIN products B
ON A.productCode = B.productCode
LEFT JOIN orders C
ON A.orderNumber = C.orderNumber
GROUP BY 1
ORDER BY 2 DESC;

SELECT *
FROM orderdetails A	
LEFT JOIN products B
ON A.productCode = B.productCode
LEFT JOIN orders C
ON A.orderNumber = C.orderNumber
LEFT JOIN churn_list D
ON C.customerNumber = D.customerNumber
; -- orderdetails, orders, products 테이블을 모두 병합하고, 각 고객번호별 이탈 상태를 매칭시킨 churn_list 테이블까지 병합한 상태

SELECT D.Churn_Type,
	   B.productline,
	   COUNT(DISTINCT C.customerNumber) AS NUM
FROM orderdetails A						-- 3개의 테이블을 연결할 때 그 중간 테이블을 A 테이블로 두는게 더 알아보기 쉬운 듯
LEFT JOIN products B
ON A.productCode = B.productCode
LEFT JOIN orders C
ON A.orderNumber = C.orderNumber
LEFT JOIN churn_list D
ON C.customerNumber = D.customerNumber
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
-- 이탈 상태와 제품군 사이 특별한 관계 없는 것으로 판단 가능