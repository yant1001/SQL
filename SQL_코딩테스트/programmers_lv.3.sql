-- 1. 조건별로 분류하여 주문상태 출력하기
SELECT ORDER_ID,
       PRODUCT_ID,
       DATE_FORMAT(OUT_DATE, '%Y-%m-%d'),
       CASE WHEN OUT_DATE <= '2022-05-01' THEN '출고완료'
            WHEN OUT_DATE > '2022-05-01' THEN '출고대기'
            ELSE '출고미정'
            END AS '출고여부'
FROM FOOD_ORDER
ORDER BY 1