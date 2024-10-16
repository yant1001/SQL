-- 1. 부모의 형질을 모두 가지는 대장균 찾기
-- 비트 연산자 &는 비트 AND 연산을 수행합니다.
-- 두 개의 숫자 간의 대응되는 비트를 배교하여 둘 다 1인 경우에만 1을 반환하는 연산입니다.
-- 예를 들어, 0101 & 0011의 경우에는 결과가 0001이고, 1101 & 1011의 경우에는 결과가 1001입니다.
SELECT A.ID,
       A.GENOTYPE,
       B.GENOTYPE AS PARENT_GENOTYPE
FROM ECOLI_DATA A
LEFT JOIN ECOLI_DATA B
ON A.PARENT_ID = B.ID
WHERE A.GENOTYPE & B.GENOTYPE = B.GENOTYPE   -- 자식 대장균(A)의 형질이 부모 대장균(B)의 형질을 모두 포함하고 있을 때 참
ORDER BY 1


-- 2. 연도별 대장균 크기의 편차 구하기
SELECT A.YEAR,
       (MAX_SIZE - SIZE_OF_COLONY) AS YEAR_DEV,
       ID
FROM (SELECT *, YEAR(DIFFERENTIATION_DATE) AS YEAR
      FROM ECOLI_DATA
      ) A
LEFT JOIN (SELECT YEAR(DIFFERENTIATION_DATE) AS YEAR,
                  MAX(SIZE_OF_COLONY) AS MAX_SIZE
           FROM ECOLI_DATA
           GROUP BY YEAR(DIFFERENTIATION_DATE)
           ) B
ON A.YEAR = B.YEAR
ORDER BY 1, 2

-- WINDOW 사용 풀이
-- WINDOW 함수의 구조: <집계함수> OVER (PARTITION BY <기준열> ORDER BY <정렬기준>)
--                  1. OVER는 윈도우 함수를 사용하기 위해 필요한 키워드입니다.
--                  2. PARTITION BY는 데이터를 <기준열>을 기준으로 그룹을 나눕니다.
--                  3. ORDER BY는 각 그룹 내에서의 정렬 기준을 정합니다.
-- `MAX(SIZE_OF_COLONY) OVER (PARTITION BY YEAR(DIFFERENTIATION_DATE))` 부분은 각 연도별로 사이즈 최댓값을 계산하여 해당 행에 추가하는 역할입니다.
-- 즉 아래 쿼리는 윈도우 함수를 이용하여, 각 연도별로 대장균 집락 크기의 최댓값을 계산하고 현재 행의 집락 크기와의 차이를 계산하여 YEAR_DEV 열에 담고 있습니다.
SELECT YEAR(DIFFERENTIATION_DATE) AS YEAR,
       MAX(SIZE_OF_COLONY) OVER (PARTITION BY YEAR(DIFFERENTIATION_DATE)) - SIZE_OF_COLONY AS YEAR_DEV,
       ID
FROM ECOLI_DATA
ORDER BY 1, 2


-- 3. 분기별 분화된 대장균의 개체 수 구하기
WITH TEMP_QUARTER AS (
SELECT *,
       CASE WHEN MONTH(DIFFERENTIATION_DATE) BETWEEN 1 AND 3 THEN '1Q'
            WHEN MONTH(DIFFERENTIATION_DATE) BETWEEN 4 AND 6 THEN '2Q'
            WHEN MONTH(DIFFERENTIATION_DATE) BETWEEN 7 AND 9 THEN '3Q'
            ELSE '4Q'
       END AS QUARTER
FROM ECOLI_DATA
)
SELECT QUARTER,
       COUNT(*) AS ECOLI_COUNT
FROM TEMP_QUARTER
GROUP BY 1
ORDER BY 1


-- 4. 자동차 평균 대여 기간 구하기
-- DATEDIFF 사용 시 +1을 해줘야 오류가 나지 않습니다.
SELECT CAR_ID,
       ROUND(AVG(DATEDIFF(END_DATE, START_DATE)+1), 1) AS AVERAGE_DURATION
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY 1
HAVING AVERAGE_DURATION >= 7
ORDER BY 2 DESC, 1 DESC


-- 5. 조건에 부합하는 중고거래 상태 조회하기
SELECT BOARD_ID,
       WRITER_ID,
       TITLE,
       PRICE,
       CASE WHEN STATUS = 'SALE' THEN '판매중'
            WHEN STATUS = 'RESERVED' THEN '예약중'
            ELSE '거래완료'
       END AS STATUS
FROM USED_GOODS_BOARD
WHERE CREATED_DATE LIKE '2022-10-05%'
ORDER BY 1 DESC


-- 6. ROOT 아이템 구하기
SELECT I.ITEM_ID,
       ITEM_NAME
FROM ITEM_INFO I
LEFT JOIN ITEM_TREE T
ON I.ITEM_ID = T.ITEM_ID
WHERE PARENT_ITEM_ID IS NULL
ORDER BY 1


-- 7. 연도별 평균 미세먼지 농도 조회하기
SELECT YEAR(YM) AS YEAR,
       ROUND(AVG(PM_VAL1), 2) AS 'PM10',
       ROUND(AVG(PM_VAL2), 2) AS 'PM2.5'
FROM AIR_POLLUTION
WHERE LOCATION2 LIKE '%수원%'
GROUP BY 1
ORDER BY 1


-- 8. 루시와 엘라 찾기
SELECT ANIMAL_ID,
       NAME,
       SEX_UPON_INTAKE
FROM ANIMAL_INS
WHERE NAME IN ('Lucy', 'Ella', 'Pickle', 'Rogan', 'Sabrina', 'Mitty')


-- 9. 중성화 여부 파악하기
SELECT ANIMAL_ID,
       NAME,
       CASE WHEN SEX_UPON_INTAKE LIKE '%Neutered%' OR SEX_UPON_INTAKE LIKE '%Spayed%' THEN 'O'
            ELSE 'X'
       END AS '중성화'
FROM ANIMAL_INS
ORDER BY 1


-- 10. DATETIME에서 DATE로 형 변환
SELECT ANIMAL_ID,
       NAME,
       DATE_FORMAT(DATETIME, '%Y-%m-%d') AS '날짜'
FROM ANIMAL_INS
ORDER BY 1  


-- 11. 카테고리별 상품 개수 구하기
SELECT LEFT(PRODUCT_CODE, 2) AS CATEGORY,
       COUNT(*) AS PRODUCTS
FROM PRODUCT
GROUP BY LEFT(PRODUCT_CODE, 2)
ORDER BY 1


-- 12. 조건에 맞는 아이템들의 가격의 총합 구하기
SELECT SUM(PRICE) AS TOTAL_PRICE
FROM ITEM_INFO
WHERE RARITY = 'LEGEND'


-- 13. 최솟값 구하기
SELECT MIN(DATETIME) AS '시간'
FROM ANIMAL_INS


-- 14. 이름에 el이 들어가는 동물 찾기
SELECT ANIMAL_ID,
       NAME
FROM ANIMAL_INS
WHERE NAME LIKE '%el%'
  and ANIMAL_TYPE = 'Dog'
ORDER BY 2


-- 15. 동물 수 구하기
SELECT COUNT(ANIMAL_ID) AS count
FROM ANIMAL_INS


-- 16. 중복 제거하기
SELECT COUNT(DISTINCT NAME) AS count
FROM ANIMAL_INS
WHERE NOT NAME IS NULL


-- 17. 가격이 제일 비싼 식품의 정보 출력하기
SELECT PRODUCT_ID,
       PRODUCT_NAME,
       PRODUCT_CD,
       CATEGORY,
       PRICE
FROM FOOD_PRODUCT
ORDER BY 5 DESC
LIMIT 1


-- 18. NULL 처리하기
SELECT ANIMAL_TYPE,
       CASE WHEN NAME IS NULL THEN 'No name'
            ELSE NAME
       END AS NAME,
       SEX_UPON_INTAKE
FROM ANIMAL_INS
ORDER BY ANIMAL_ID


-- 19. 조건에 맞는 개발자 찾기
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


-- 20. 