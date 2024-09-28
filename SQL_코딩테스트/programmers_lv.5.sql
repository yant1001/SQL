-- 1. 상품을 구매한 회원 비율 구하기
WITH TEMP_USER_2021 AS (
SELECT *
FROM USER_INFO
WHERE YEAR(JOINED) = 2021  -- 2021년에 가입한 회원
),
TEMP_JOIN AS (
SELECT U.USER_ID
     , JOINED
     , SALES_DATE
FROM TEMP_USER_2021 U
JOIN ONLINE_SALE S
ON U.USER_ID = S.USER_ID   -- 2021년 가입 회원의 상품 구매일
)
SELECT YEAR(SALES_DATE) AS YEAR
     , MONTH(SALES_DATE) AS MONTH
     , COUNT(DISTINCT TEMP_JOIN.USER_ID) AS PURCHASED_USERS -- 상품을 구매한 회원수
     , ROUND(COUNT(DISTINCT TEMP_JOIN.USER_ID)
            /COUNT(DISTINCT TEMP_USER_2021.USER_ID), 1) AS PURCHASED_RATIO
FROM TEMP_JOIN, TEMP_USER_2021
GROUP BY 1, 2
ORDER BY 1, 2