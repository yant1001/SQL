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
SELECT DISTINCT H.CAR_ID
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
LEFT JOIN CAR_RENTAL_COMPANY_CAR C
ON H.CAR_ID = C.CAR_ID
WHERE CAR_TYPE = '세단'
  AND MONTH(START_DATE) = 10
ORDER BY 1 DESC


-- 4. 조건에 맞는 사용자 정보 조회하기
-- SUBSTRING(COL, A, B): COL 컬럼의 A번째 문자부터 B개 추출
SELECT U.USER_ID,
       NICKNAME,
       CONCAT(CITY, " ", STREET_ADDRESS1, " ", STREET_ADDRESS2) AS '전체주소',
       CONCAT('010-', SUBSTRING(TLNO, 4, 4), '-', RIGHT(TLNO, 4)) AS '전화번호'
FROM USED_GOODS_USER U
LEFT JOIN USED_GOODS_BOARD B
ON U.USER_ID = B.WRITER_ID
GROUP BY U.USER_ID
HAVING COUNT(*) >= 3
ORDER BY 1 DESC


-- 5. 조회수가 가장 많은 중고거래 게시판의 첨부파일 조회하기
SELECT CONCAT('/home/grep/src', '/', B.BOARD_ID, '/', FILE_ID, FILE_NAME, FILE_EXT) AS FILE_PATH
FROM USED_GOODS_BOARD B
JOIN USED_GOODS_FILE F
ON B.BOARD_ID = F.BOARD_ID
WHERE B.BOARD_ID = (SELECT B.BOARD_ID
                    FROM USED_GOODS_BOARD B
                    JOIN USED_GOODS_FILE F
                    ON B.BOARD_ID = F.BOARD_ID
                    GROUP BY FILE_ID
                    ORDER BY VIEWS DESC
                    LIMIT 1) 
ORDER BY FILE_ID DESC


-- 6. 헤비 유저가 소유한 장소
SELECT *
FROM PLACES
WHERE HOST_ID IN (SELECT HOST_ID
                  FROM PLACES
                  GROUP BY HOST_ID
                  HAVING COUNT(*) >= 2)
ORDER BY ID


-- 7. 업그레이드 할 수 없는 아이템 구하기
-- ITEM_ID가 PARENT_ID에 없는 것
-- null을 없애야 true 결과값을 얻을 수 있어요.
SELECT ITEM_ID,
       ITEM_NAME,
       RARITY
FROM ITEM_INFO I
WHERE ITEM_ID NOT IN (SELECT PARENT_ITEM_ID
                      FROM ITEM_TREE
                      WHERE PARENT_ITEM_ID IS NOT NULL)
ORDER BY 1 DESC


-- 8. 물고기 종류별 대어 찾기
SELECT ID,
       FISH_NAME,
       LENGTH
FROM (SELECT ID,
             FISH_NAME,
             LENGTH,
             DENSE_RANK() OVER (PARTITION BY FISH_NAME ORDER BY LENGTH DESC) AS RNK
      FROM FISH_INFO I
      JOIN FISH_NAME_INFO N
      ON I.FISH_TYPE = N.FISH_TYPE) RNK
WHERE RNK = 1
ORDER BY 1 


-- 9. 대장균의 크기에 따라 분류하기
WITH TEMP_RNK AS (
SELECT *,
       PERCENT_RANK() OVER (ORDER BY SIZE_OF_COLONY DESC) AS RNK
FROM ECOLI_DATA
ORDER BY SIZE_OF_COLONY DESC
)
SELECT ID,
       CASE WHEN RNK <= 0.25 THEN 'CRITICAL'
            WHEN RNK <= 0.5 THEN 'HIGH'
            WHEN RNK <= 0.75 THEN 'MEDIUM'
            ELSE 'LOW'
       END AS COLONY_NAME
FROM TEMP_RNK
ORDER BY 1