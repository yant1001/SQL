-- 1. 평균 일일 대여 요금 구하기
SELECT ROUND(AVG(DAILY_FEE), 0) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE = 'SUV'


-- 2. 재구매가 일어난 상품과 회원 리스트 구하기
SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY 1, 2
HAVING COUNT(*) >= 2
ORDER BY 1, 2 DESC


-- 3. 흉부외과 또는 일반외과 의사 목록 출력하기
SELECT DR_NAME, 
       DR_ID, 
       MCDP_CD, 
       DATE_FORMAT(HIRE_YMD, '%Y-%m-%d') as HIRE_YMD
FROM DOCTOR
WHERE MCDP_CD = 'CS' OR MCDP_CD = 'GS'
ORDER BY 4 DESC, 1


-- 4. 역순 정렬하기
SELECT NAME,
       DATETIME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID DESC


-- 5. 아픈 동물 찾기
SELECT ANIMAL_ID,
       NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION = 'Sick'
ORDER BY ANIMAL_ID


-- 6. 어린 동물 찾기
SELECT ANIMAL_ID,
       NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION != 'Aged'
ORDER BY ANIMAL_ID


-- 7. 과일로 만든 아이스크림 고르기
SELECT A.FLAVOR
FROM FIRST_HALF A
LEFT JOIN ICECREAM_INFO B
ON A.FLAVOR = B.FLAVOR
WHERE TOTAL_ORDER > 3000
  AND INGREDIENT_TYPE = 'fruit_based'
ORDER BY TOTAL_ORDER DESC


-- 8. 동물의 아이디와 이름
SELECT ANIMAL_ID,
       NAME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID


-- 9. 여러 기준으로 정렬하기
SELECT ANIMAL_ID,
       NAME,
       DATETIME
FROM ANIMAL_INS
ORDER BY NAME, DATETIME DESC


-- 10. 상위 n개 레코드
SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME
LIMIT 1


-- 11. 조건에 맞는 회원수 구하기
SELECT COUNT(USER_ID)
FROM USER_INFO
WHERE YEAR(JOINED) = 2021
  AND AGE BETWEEN 20 AND 29


-- 12. 3월에 태어난 여성 회원 목록 출력하기
SELECT MEMBER_ID, 
       MEMBER_NAME, 
       GENDER, 
       DATE_FORMAT(DATE_OF_BIRTH, '%Y-%m-%d')
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = 3
  AND NOT TLNO IS NULL
  AND GENDER = 'W'
ORDER BY MEMBER_ID


--13. 서울에 위치한 식당 목록 출력하기
SELECT *
FROM (
SELECT A.REST_ID,
       REST_NAME,
       FOOD_TYPE,
       FAVORITES,
       ADDRESS,
       ROUND(AVG(REVIEW_SCORE), 2) AS SCORE
FROM REST_INFO A
LEFT JOIN REST_REVIEW B
ON A.REST_ID = B.REST_ID
WHERE ADDRESS LIKE '서울%'
GROUP BY 1, 2, 3, 4, 5
ORDER BY 6 DESC,
         4 DESC
) A
WHERE NOT SCORE IS NULL


-- 13. 조건에 부합하는 중고거래 댓글 조회하기
SELECT A.TITLE,
       A.BOARD_ID,
       B.REPLY_ID,
       B.WRITER_ID,
       B.CONTENTS,
       DATE_FORMAT(B.CREATED_DATE, '%Y-%m-%d')
FROM USED_GOODS_BOARD A
RIGHT JOIN USED_GOODS_REPLY B
ON A.BOARD_ID = B.BOARD_ID
WHERE YEAR(A.CREATED_DATE) = 2022
  AND MONTH(A.CREATED_DATE) = 10
ORDER BY B.CREATED_DATE,
         TITLE


-- 14. 인기있는 아이스크림
SELECT FLAVOR
FROM FIRST_HALF
ORDER BY TOTAL_ORDER DESC,
         SHIPMENT_ID


-- 15. 강원도에 위치한 생산공장 목록 출력하기
SELECT FACTORY_ID, 
       FACTORY_NAME, 
       ADDRESS
FROM FOOD_FACTORY
WHERE ADDRESS LIKE '%강원도%'
ORDER BY FACTORY_ID 


-- 16. 12세 이하인 여자 환자 목록 출력하기
SELECT PT_NAME,
       PT_NO,
       GEND_CD,
       AGE,
       CASE WHEN NOT TLNO IS NULL 
            THEN TLNO 
            ELSE 'NONE' 
            END AS TLNO 
FROM PATIENT
WHERE GEND_CD = 'W'
  AND AGE <= 12
ORDER BY AGE DESC,
         PT_NAME


-- 17. 조건에 맞는 도서 리스트 출력하기
SELECT BOOK_ID,
       DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d')
FROM BOOK
WHERE YEAR(PUBLISHED_DATE) = 2021
  AND CATEGORY = '인문'
ORDER BY PUBLISHED_DATE


-- 18. 모든 레코드 조회하기
SELECT  *
FROM ANIMAL_INS
ORDER BY ANIMAL_ID


-- 19. 오프라인/온라인 판매 데이터 통합하기
SELECT DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
       PRODUCT_ID,
       USER_ID,
       SALES_AMOUNT
FROM ONLINE_SALE
WHERE SALES_DATE LIKE '2022-03%'
UNION
SELECT DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
       PRODUCT_ID,
       NULL,
       SALES_AMOUNT
FROM OFFLINE_SALE
WHERE SALES_DATE LIKE '2022-03%'
ORDER BY SALES_DATE,
         PRODUCT_ID,
         USER_ID


-- 20. 업그레이드 된 아이템 구하기
SELECT A.ITEM_ID,
       ITEM_NAME,
       RARITY
FROM ITEM_TREE A
LEFT JOIN ITEM_INFO B
ON A.ITEM_ID = B.ITEM_ID
WHERE PARENT_ITEM_ID IN (SELECT DISTINCT(ITEM_ID)
                         FROM ITEM_INFO
                         WHERE RARITY = 'RARE'
                         )
ORDER BY ITEM_ID DESC