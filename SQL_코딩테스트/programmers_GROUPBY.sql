-- 1. 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
SELECT CAR_TYPE,
       COUNT(CAR_TYPE) AS CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%통풍시트%'
    OR OPTIONS LIKE '%열선시트%'
    OR OPTIONS LIKE '%가죽시트%'
GROUP BY 1
ORDER BY 1


-- 2.성분으로 구분한 아이스크림 총 주문량