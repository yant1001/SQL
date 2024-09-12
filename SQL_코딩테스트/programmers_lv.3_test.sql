-- 1. 카테고리별 도서 판매량 집계하기
-- 0911 7분 30초
SELECT CATEGORY,
       SUM(SALES) AS TOTAL_SALES
FROM (SELECT *
      FROM BOOK_SALES
      WHERE SALES_DATE LIKE '2022-01%') S
LEFT JOIN BOOK B
ON S.BOOK_ID = B.BOOK_ID
GROUP BY CATEGORY
ORDER BY 1


-- 2. 조건별로 분류하여 주문상태 출력하기
-- 0911 5분
SELECT ORDER_ID
     , PRODUCT_ID
     , DATE_FORMAT(OUT_DATE, '%Y-%m-%d')
     , CASE WHEN OUT_DATE <= '2022-05-01' THEN '출고완료'
            WHEN OUT_DATE > '2022-05-01' THEN '출고대기'
            ELSE '출고미정'
       END AS '출고여부'
FROM FOOD_ORDER
ORDER BY ORDER_ID


-- 3. 오랜 기간 보호한 동물(1)
SELECT I.NAME,
       I.DATETIME
FROM ANIMAL_INS I
LEFT JOIN ANIMAL_OUTS O
ON I.ANIMAL_ID = O.ANIMAL_ID
WHERE O.ANIMAL_ID IS NULL
ORDER BY 2
LIMIT 3


-- 4. 있었는데요 없었습니다
-- 0911 6분 30초
SELECT I.ANIMAL_ID
     , I.NAME
FROM ANIMAL_INS I
LEFT JOIN ANIMAL_OUTS O
ON I.ANIMAL_ID = O.ANIMAL_ID
WHERE I.DATETIME > O.DATETIME
ORDER BY I.DATETIME


-- 5. 오랜 기간 보호한 동물(2)
-- 0911 3분
SELECT I.ANIMAL_ID
     , I.NAME
FROM ANIMAL_INS I
JOIN ANIMAL_OUTS O
ON I.ANIMAL_ID = O.ANIMAL_ID
ORDER BY DATEDIFF(O.DATETIME, I.DATETIME) DESC
LIMIT 2


-- 6. 대여 기록이 존재하는 자동차 리스트 구하기
-- 0911 2분 47초
SELECT DISTINCT H.CAR_ID
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
LEFT JOIN CAR_RENTAL_COMPANY_CAR C
ON H.CAR_ID = C.CAR_ID
WHERE CAR_TYPE = '세단'
  AND MONTH(START_DATE) = 10
ORDER BY H.CAR_ID DESC


-- 7. 조건에 맞는 사용자와 총 거래금액 조회하기
-- 0911 7분 37초
WITH TEMP_BOARD AS (
SELECT WRITER_ID
     , SUM(PRICE) AS TOTAL_SALES
FROM (SELECT *
      FROM USED_GOODS_BOARD
      WHERE STATUS = 'DONE') B
GROUP BY WRITER_ID
HAVING SUM(PRICE) >= 700000
)
SELECT USER_ID
     , NICKNAME
     , TOTAL_SALES
FROM TEMP_BOARD B
LEFT JOIN USED_GOODS_USER U
ON B.WRITER_ID = U.USER_ID
ORDER BY 3


-- 8. 즐겨찾기가 가장 많은 식당 정보 출력하기
-- 0911 5분 15초
SELECT FOOD_TYPE
     , REST_ID
     , REST_NAME
     , FAVORITES
FROM REST_INFO
WHERE (FOOD_TYPE, FAVORITES)
   IN (SELECT FOOD_TYPE
            , MAX(FAVORITES)
       FROM REST_INFO
       GROUP BY FOOD_TYPE)
ORDER BY FOOD_TYPE DESC


-- 9. 없어진 기록 찾기
-- 0911 2분 14초
SELECT O.ANIMAL_ID
     , O.NAME
FROM ANIMAL_OUTS O
LEFT JOIN ANIMAL_INS I
ON O.ANIMAL_ID = I.ANIMAL_ID
WHERE I.ANIMAL_ID IS NULL
ORDER BY 1


-- 10. 조건에 맞는 사용자 정보 조회하기
-- 0911 6분 45초
SELECT USER_ID
     , NICKNAME
     , CONCAT(CITY, ' ', STREET_ADDRESS1, ' ', STREET_ADDRESS2) AS '전체주소'
     , CONCAT('010-', SUBSTRING(TLNO, 4, 4), '-', RIGHT(TLNO, 4)) AS '전화번호'
FROM (SELECT WRITER_ID
      FROM USED_GOODS_BOARD
      GROUP BY WRITER_ID
      HAVING COUNT(*) >= 3) B
LEFT JOIN USED_GOODS_USER U
ON B.WRITER_ID = U.USER_ID
ORDER BY 1 DESC


-- 11. 부서별 평균 연봉 조회하기
-- 0911 5분 23초
SELECT E.DEPT_ID
     , DEPT_NAME_EN
     , AVG_SAL
FROM (SELECT DEPT_ID
           , ROUND(AVG(SAL), 0) AS AVG_SAL
      FROM HR_EMPLOYEES
      GROUP BY DEPT_ID) E
LEFT JOIN HR_DEPARTMENT D
ON E.DEPT_ID = D.DEPT_ID
ORDER BY 3 DESC


-- 12. 대장균의 크기에 따라 분류하기 1
-- 0911 2분 4초
SELECT ID
     , CASE WHEN SIZE_OF_COLONY > 1000 THEN 'HIGH'
            WHEN SIZE_OF_COLONY > 100 THEN 'MEDIUM'
            ELSE 'LOW'
       END AS SIZE
FROM ECOLI_DATA
ORDER BY 1


-- 13. 자동차 대여 기록에서 대여중/대여 가능 여부 구분하기
-- 0911 15분 2초
WITH TEMP_HISTORY AS (
SELECT *
     , IF((END_DATE >= '2022-10-16' AND START_DATE <= '2022-10-16'), '대여중', '대여 가능') AS AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
)
SELECT CAR_ID
     , MAX(AVAILABILITY) AS AVAILABILITY
FROM TEMP_HISTORY
GROUP BY CAR_ID
ORDER BY CAR_ID DESC


-- 14. 조회수가 가장 많은 중고거래 게시판의 첨부파일 조회하기
-- 0911 13분 34초
SELECT CONCAT('/home/grep/src/', BOARD_ID, '/', FILE_ID, FILE_NAME, FILE_EXT) AS FILE_PATH
FROM USED_GOODS_FILE
WHERE BOARD_ID =
      (SELECT BOARD_ID
       FROM USED_GOODS_BOARD
       ORDER BY VIEWS DESC
       LIMIT 1)
ORDER BY FILE_ID DESC


-- 15. 헤비 유저가 소유한 장소
-- 0911 6분 29초
SELECT ID
     , NAME
     , A.HOST_ID
FROM (SELECT HOST_ID
      FROM PLACES
      GROUP BY HOST_ID
      HAVING COUNT(*) >= 2) A
JOIN PLACES B
ON A.HOST_ID = B.HOST_ID
ORDER BY ID


-- 16. 대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기
-- 0911 12분 33초
WITH TEMP_CAR AS (
SELECT CAR_ID
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE MONTH(START_DATE) BETWEEN 8 AND 10
GROUP BY CAR_ID
HAVING COUNT(*) >= 5
)
SELECT MONTH(START_DATE)
     , CAR_ID
     , COUNT(*) AS RECORDS
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE MONTH(START_DATE) BETWEEN 8 AND 10
  AND CAR_ID IN (SELECT *
                 FROM TEMP_CAR)
GROUP BY 1, 2
ORDER BY 1, 2 DESC


-- 17. 특정 조건을 만족하는 물고기별 수와 최대 길이 구하기
-- 0911 16분 11초
SELECT COUNT(ID) AS FISH_COUNT
     , MAX(LENGTH) AS MAX_LENGTH
     , FISH_TYPE
FROM (SELECT ID
           , FISH_TYPE
           , IF(LENGTH IS NULL, 10, LENGTH) AS LENGTH
      FROM FISH_INFO) I
GROUP BY FISH_TYPE
HAVING AVG(LENGTH) >= 33
ORDER BY 3


-- 18. 대장균들의 자식의 수 구하기
-- 0911 37분 47초
SELECT A.ID
     , IF(CHILD_COUNT IS NULL, 0, CHILD_COUNT) AS CHILD_COUNT
FROM ECOLI_DATA A
LEFT JOIN (SELECT PARENT_ID
                , COUNT(*) AS CHILD_COUNT
           FROM ECOLI_DATA
           GROUP BY PARENT_ID) B
ON A.ID = B.PARENT_ID
ORDER BY ID


-- 19. 업그레이드 할 수 없는 아이템 구하기
-- 0911 9분 4초
SELECT I.ITEM_ID
     , ITEM_NAME
     , RARITY
FROM ITEM_INFO I
LEFT JOIN ITEM_TREE T
ON I.ITEM_ID = T.PARENT_ITEM_ID
WHERE PARENT_ITEM_ID IS NULL
ORDER BY 1 DESC


-- 20. 물고기 종류별 대어 찾기
-- 0911 11분 58초
SELECT ID
     , FISH_NAME
     , LENGTH
FROM FISH_INFO I
LEFT JOIN FISH_NAME_INFO N
ON I.FISH_TYPE = N.FISH_TYPE
WHERE (I.FISH_TYPE, LENGTH)
   IN (SELECT FISH_TYPE
            , MAX(LENGTH) AS LENGTH
       FROM FISH_INFO
       GROUP BY FISH_TYPE)
ORDER BY 1


-- 21. 대장균의 크기에 따라 분류하기 2
-- 0912 10분 22초
WITH TEMP_COLONY AS (
SELECT *
     , PERCENT_RANK() OVER (ORDER BY SIZE_OF_COLONY DESC) AS COLONY_NAME
FROM ECOLI_DATA
)
SELECT ID
     , CASE WHEN COLONY_NAME <= 0.25 THEN 'CRITICAL'
            WHEN COLONY_NAME <= 0.50 THEN 'HIGH'
            WHEN COLONY_NAME <= 0.75 THEN 'MEDIUM'
            ELSE 'LOW'
       END AS COLONY_NAME
FROM TEMP_COLONY
ORDER BY 1