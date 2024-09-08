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


-- 2. 오랜 기간 보호한 동물(2)
SELECT O.ANIMAL_ID,
       O.NAME
FROM ANIMAL_OUTS O
JOIN ANIMAL_INS I
ON O.ANIMAL_ID = I.ANIMAL_ID
ORDER BY DATEDIFF(O.DATETIME, I.DATETIME) DESC
LIMIT 2


--3. 대여 기록이 존재하는 자동차 리스트 구하기
-- 코드를 입력하세요
SELECT *
FROM CAR_RENTAL_COMPANY_CAR C
RIGHT JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY H
ON C.CAR_ID = H.CAR_ID
WHERE CAR_TYPE = '세단'