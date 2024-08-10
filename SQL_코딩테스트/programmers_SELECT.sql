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


-- 21.Python 개발자 찾기
SELECT ID,
       EMAIL,
       FIRST_NAME,
       LAST_NAME
FROM DEVELOPER_INFOS
WHERE 'Python' IN (SKILL_1, SKILL_2, SKILL_3)
ORDER BY ID


-- 22. 잔챙이 잡은 수 구하기
SELECT COUNT(ID) AS FISH_COUNT
FROM FISH_INFO
WHERE LENGTH IS NULL


-- 23. 가장 큰 물고기 10마리 구하기
SELECT ID,
       LENGTH
FROM FISH_INFO
WHERE NOT LENGTH IS NULL
ORDER BY LENGTH DESC,
         ID
LIMIT 10


-- 24. 조건에 맞는 개발자 찾기
/*
비트 AND 연산자란? (&)
두 숫자를 2진수로 변환하여, 각 비트를 비교하고 둘 다 1일 때만 1을 반환한다.
그렇지 않으면 0을 반환한다.
예를 들어 `(D.SKILL_CODE & S.CODE) = S.CODE`일 때, `D.SKILL_CODE & S.CODE`가 0011 & 0001이라면 결과는 0001이 된다.
0011은 0010+0001의 결과이므로, 두 숫자 모두 0001을 가지고 있어서 0001을 반환하는 것.
이럴 경우 특정 비트가 정확히 해당 스킬을 나타내는지 확인할 수 있다.
*/
SELECT ID,
       EMAIL,
       FIRST_NAME,
       LAST_NAME
FROM DEVELOPERS D
WHERE EXISTS (SELECT *
              FROM SKILLCODES S
              WHERE S.NAME IN ('Python', 'C#')
                AND (D.SKILL_CODE & S.CODE) = S.CODE)
ORDER BY ID


-- 25. 특정 물고기를 잡은 총 수 구하기
SELECT COUNT(FISH_NAME) AS 'FISH_COUNT'
FROM FISH_INFO A
LEFT JOIN FISH_NAME_INFO B
ON A.FISH_TYPE = B.FISH_TYPE
WHERE FISH_NAME IN ('BASS', 'SNAPPER')


-- 26. 대장균들의 자식의 수 구하기
SELECT ID,
       (SELECT COUNT(ID)
        FROM ECOLI_DATA
        WHERE A.ID = PARENT_ID) AS CHILD_COUNT
FROM ECOLI_DATA A
GROUP BY ID
ORDER BY ID


-- 27. 대장균의 크기에 따라 분류하기 1
SELECT ID,
       CASE WHEN SIZE_OF_COLONY <= 100 THEN 'LOW'
            WHEN SIZE_OF_COLONY BETWEEN 100 AND 1000 THEN 'MEDIUM'
            ELSE 'HIGH'
            END AS SIZE
FROM ECOLI_DATA
ORDER BY ID


-- 28. 특이 형질을 가지는 대장균 찾기
-- 27. 대장균의 크기에 따라 분류하기 1
SELECT ID,
       CASE WHEN SIZE_OF_COLONY <= 100 THEN 'LOW'
            WHEN SIZE_OF_COLONY BETWEEN 100 AND 1000 THEN 'MEDIUM'
            ELSE 'HIGH'
            END AS SIZE
FROM ECOLI_DATA
ORDER BY ID


-- 28. 특정 형질을 가지는 대장균 찾기
SELECT COUNT(ID) AS COUNT
FROM ECOLI_DATA
WHERE GENOTYPE & 2 =0
  AND (GENOTYPE & 1 > 0 OR GENOTYPE & 4 > 0)