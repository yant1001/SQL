-- 보호소에서 중성화한 동물
SELECT O.ANIMAL_ID
     , O.ANIMAL_TYPE
     , O.NAME
FROM (SELECT *
      FROM ANIMAL_INS
      WHERE SEX_UPON_INTAKE LIKE 'Intact%') I
JOIN (SELECT *
      FROM ANIMAL_OUTS
      WHERE SEX_UPON_OUTCOME LIKE 'Spayed%' 
         OR SEX_UPON_OUTCOME LIKE 'Neutered%') O
ON I.ANIMAL_ID = O.ANIMAL_ID
ORDER BY 1


-- 식품분류별 가장 비싼 식품의 정보 조회하기
-- 1009 15분
SELECT CATEGORY
     , PRICE
     , PRODUCT_NAME
FROM FOOD_PRODUCT
WHERE (CATEGORY, PRICE) IN (SELECT CATEGORY, MAX(PRICE)
                            FROM FOOD_PRODUCT
                            WHERE CATEGORY IN ('과자', '국', '김치', '식용유')
                            GROUP BY CATEGORY)
ORDER BY 2 DESC
