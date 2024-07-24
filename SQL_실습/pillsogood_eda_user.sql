USE PillSoGood;

-- 연령별 성별 분포
WITH TEMP_SE_CNT AS (
SELECT survey_age_group,
	   survey_sex,
	   CASE WHEN survey_sex = 'm' THEN COUNT(survey_sex) ELSE 0 END AS MALE_CNT,
	   CASE WHEN survey_sex = 'f' THEN COUNT(survey_sex) ELSE 0 END AS FEMALE_CNT
FROM survey
WHERE survey_sex IN ('f', 'm')
GROUP BY 1, 2
),
TEMP_PIVOT_SE_CNT AS (
SELECT survey_age_group,
	   MAX(MALE_CNT) AS MALE_CNT,
       MAX(FEMALE_CNT) AS FEMALE_CNT
FROM TEMP_SE_CNT
GROUP BY 1
)
SELECT survey_age_group AS '연령대',
	   CONCAT(ROUND(MALE_CNT / (MALE_CNT+FEMALE_CNT) * 100, 0), '%') AS '남성수 비율',
       CONCAT(ROUND(FEMALE_CNT / (MALE_CNT+FEMALE_CNT) * 100, 0), '%') AS '여성수 비율'
FROM TEMP_PIVOT_SE_CNT;


-- 연령별 성별 특정 건강고민/기저질환/알레르기 비율 (코드 매개변수 사용)
SELECT * FROM survey_com_code WHERE com_code LIKE '%DI%';
SELECT * FROM survey_com_code WHERE com_code LIKE '%HF%';
SELECT * FROM survey_com_code WHERE com_code LIKE '%AL%';
-- 건강고민
SELECT A.survey_age_group,
	   A.survey_sex,
	   B.com_code
FROM survey A
LEFT JOIN survey_com_code B
ON A.survey_id = B.survey_id
WHERE B.com_code_grp='FUNCTION';
-- 기저질환
SELECT A.survey_age_group,
	   A.survey_sex,
	   B.com_code
FROM survey A
LEFT JOIN survey_com_code B
ON A.survey_id = B.survey_id
WHERE B.com_code_grp='DISEASE';
-- 알레르기
SELECT A.survey_age_group,
	   A.survey_sex,
	   B.com_code
FROM survey A
LEFT JOIN survey_com_code B
ON A.survey_id = B.survey_id
WHERE B.com_code_grp='ALLERGY';


-- 연령별 성별 음주 비율
-- A0: 거의 마시지 않음, A1: 주 1회, A2: 주 2~3회, A3: 주 4회 이상, 1: 선택하지 않음
-- 1단계
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_alcohol_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2;
-- 2단계
WITH TEMP_ALCOHOL AS (
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_alcohol_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2
)
SELECT survey_age_group,
       CASE WHEN survey_sex='m' THEN ALCOHOL_CNT ELSE 0 END AS ALCOHOL_MALE_CNT,
       CASE WHEN survey_sex='f' THEN ALCOHOL_CNT ELSE 0 END AS ALCOHOL_FEMALE_CNT
FROM TEMP_ALCOHOL;
-- 3단계
WITH TEMP_ALCOHOL AS (
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_alcohol_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2
),
TEMP_ALCOHOL_CNT AS (
SELECT survey_age_group,
       CASE WHEN survey_sex='m' THEN ALCOHOL_CNT ELSE 0 END AS ALCOHOL_MALE_CNT,
       CASE WHEN survey_sex='f' THEN ALCOHOL_CNT ELSE 0 END AS ALCOHOL_FEMALE_CNT
FROM TEMP_ALCOHOL
)
SELECT survey_age_group,
	   MAX(ALCOHOL_MALE_CNT) AS ALCOHOL_MALE_CNT,
       MAX(ALCOHOL_FEMALE_CNT) AS ALCOHOL_FEMALE_CNT
FROM TEMP_ALCOHOL_CNT
GROUP BY 1;
-- 4단계
WITH TEMP_ALCOHOL AS (
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_alcohol_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2
),
TEMP_ALCOHOL_CNT AS (
SELECT survey_age_group,
       CASE WHEN survey_sex='m' THEN ALCOHOL_CNT ELSE 0 END AS ALCOHOL_MALE_CNT,
       CASE WHEN survey_sex='f' THEN ALCOHOL_CNT ELSE 0 END AS ALCOHOL_FEMALE_CNT
FROM TEMP_ALCOHOL
),
TEMP_PIVOT_ALCOHOL_CNT AS (
SELECT survey_age_group,
	   MAX(ALCOHOL_MALE_CNT) AS ALCOHOL_MALE_CNT,
       MAX(ALCOHOL_FEMALE_CNT) AS ALCOHOL_FEMALE_CNT
FROM TEMP_ALCOHOL_CNT
GROUP BY 1
)
SELECT survey_age_group AS '연령대',
	   CONCAT(ROUND(ALCOHOL_MALE_CNT / (SELECT COUNT(*)
										FROM survey
										WHERE survey_sex='m' 
										AND survey_age_group=TEMP_PIVOT_ALCOHOL_CNT.survey_age_group
										) *100, 2), '%') AS '동일 연령대 남성수 대비 음주 비율',
		CONCAT(ROUND(ALCOHOL_FEMALE_CNT / (SELECT COUNT(*)
										   FROM survey
										   WHERE survey_sex='f' 
										   AND survey_age_group=TEMP_PIVOT_ALCOHOL_CNT.survey_age_group
										   ) *100, 2), '%') AS '동일 연령대 여성수 대비 음주 비율',
	    CONCAT(ROUND(ALCOHOL_MALE_CNT / (SELECT COUNT(*) 
										 FROM survey 
										 WHERE survey_sex='m'
										 ) *100, 2), '%') AS '전체 남성수 대비 음주 비율',
	    CONCAT(ROUND(ALCOHOL_FEMALE_CNT / (SELECT COUNT(*) 
										   FROM survey 
										   WHERE survey_sex='f'
										   ) *100, 2), '%') AS '전체 여성수 대비 음주 비율'
FROM TEMP_PIVOT_ALCOHOL_CNT
;

-- 연령별 성별 흡연 비율
-- S0: 해당사항없음, S1: 흡연중, S9: 선택하지않음
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_smoking_code) AS SMOKING_CNT
FROM survey
WHERE survey_smoking_code = 'S1'
GROUP BY 1, 2;
select * from survey;

WITH TEMP_SMOKING AS (
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_smoking_code) AS SMOKING_CNT
FROM survey
WHERE survey_smoking_code = 'S1'
GROUP BY 1, 2
),
TEMP_SMOKING_CNT AS (
SELECT survey_age_group,
       CASE WHEN survey_sex='m' THEN SMOKING_CNT ELSE 0 END AS SMOKING_MALE_CNT,
       CASE WHEN survey_sex='f' THEN SMOKING_CNT ELSE 0 END AS SMOKING_FEMALE_CNT
FROM TEMP_SMOKING
),
TEMP_PIVOT_SMOKING_CNT AS (
SELECT survey_age_group,
	   MAX(SMOKING_MALE_CNT) AS SMOKING_MALE_CNT,
       MAX(SMOKING_FEMALE_CNT) AS SMOKING_FEMALE_CNT
FROM TEMP_SMOKING_CNT
GROUP BY 1
)
SELECT survey_age_group AS '연령대',
	   CONCAT(ROUND(SMOKING_MALE_CNT / (SELECT COUNT(*)
										FROM survey
										WHERE survey_sex='m' 
										AND survey_age_group=TEMP_PIVOT_SMOKING_CNT.survey_age_group
										) *100, 2), '%') AS '동일 연령대 남성수 대비 흡연 비율',
		CONCAT(ROUND(SMOKING_FEMALE_CNT / (SELECT COUNT(*)
										   FROM survey
										   WHERE survey_sex='f' 
										   AND survey_age_group=TEMP_PIVOT_SMOKING_CNT.survey_age_group
										   ) *100, 2), '%') AS '동일 연령대 여성수 대비 흡연 비율',
	    CONCAT(ROUND(SMOKING_MALE_CNT / (SELECT COUNT(*) 
										 FROM survey 
										 WHERE survey_sex='m'
										 ) *100, 2), '%') AS '전체 남성수 대비 흡연 비율',
	    CONCAT(ROUND(SMOKING_FEMALE_CNT / (SELECT COUNT(*) 
										   FROM survey 
										   WHERE survey_sex='f'
										   ) *100, 2), '%') AS '전체 여성수 대비 흡연 비율'
FROM TEMP_PIVOT_SMOKING_CNT
;

-- (여성수 한정) 임신/비임신 인구간 건강고민, 기저질환, 알레르기, 음주, 흡연 등의 비율

-- (여성수 한정) 임신/비임신 인구간 음주 비율
-- P0: 해당 사항 없음, P1: 임신 계획 있음, P2: 수유 중, P3: 임신 중, 1: 선택하지 않음
-- A0: 거의 마시지 않음, A1: 주 1회, A2: 주 2~3회, A3: 주 4회 이상, 1: 선택하지 않음

-- 여성 임산 인구(임신 계획 있거나, 수유 중이거나, 임신 중) 중 음주 응답한 인원
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_pregnancy_code IN ('P1', 'P2', 'P3')
  AND survey_alcohol_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2;

-- 1단계
SELECT survey_age_group,
	   survey_sex,
       survey_pregnancy_code,
       survey_alcohol_code,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_alcohol_code IN ('A1', 'A2', 'A3')
  AND survey_pregnancy_code IN ('P1', 'P2', 'P3')
GROUP BY 1, 2, 3, 4;
-- 2단계
WITH TEMP_PREG_ALCOHOL AS (
SELECT survey_age_group,
	   survey_sex,
       survey_pregnancy_code,
       survey_alcohol_code,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_alcohol_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2, 3, 4
)
SELECT survey_age_group,
       survey_sex,
       survey_pregnancy_code,
       survey_alcohol_code,
       CASE WHEN survey_pregnancy_code IN ('P1', 'P2', 'P3') THEN SUM(ALCOHOL_CNT) ELSE 0 END AS PREG_ALCOHOL_CNT,
       CASE WHEN survey_pregnancy_code NOT IN ('P1', 'P2', 'P3') THEN SUM(ALCOHOL_CNT) ELSE 0 END AS NON_PREG_ALCOHOL_CNT
FROM TEMP_PREG_ALCOHOL
GROUP BY 1, 2, 3, 4;
-- 3단계
WITH TEMP_PREG_ALCOHOL AS (
SELECT survey_age_group,
	   survey_sex,
       survey_pregnancy_code,
       survey_alcohol_code,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_alcohol_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2, 3, 4
),
TEMP_PREG_ALCOHOL_CNT AS (
SELECT survey_age_group,
       survey_sex,
       survey_pregnancy_code,
       survey_alcohol_code,
       CASE WHEN survey_pregnancy_code IN ('P1', 'P2', 'P3') THEN SUM(ALCOHOL_CNT) ELSE 0 END AS PREG_ALCOHOL_CNT,
       CASE WHEN survey_pregnancy_code NOT IN ('P1', 'P2', 'P3') THEN SUM(ALCOHOL_CNT) ELSE 0 END AS NON_PREG_ALCOHOL_CNT
FROM TEMP_PREG_ALCOHOL
GROUP BY 1, 2, 3, 4
)
SELECT survey_age_group,
	   SUM(PREG_ALCOHOL_CNT) AS PREG_ALCOHOL_CNT,
       SUM(NON_PREG_ALCOHOL_CNT) AS NON_PREG_ALCOHOL_CNT
FROM TEMP_PREG_ALCOHOL_CNT
GROUP BY 1;
-- 4단계
WITH TEMP_PREG_ALCOHOL AS (
SELECT survey_age_group,
	   survey_sex,
       survey_pregnancy_code,
       survey_alcohol_code,
       COUNT(survey_alcohol_code) AS ALCOHOL_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_alcohol_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2, 3, 4
),
TEMP_PREG_ALCOHOL_CNT AS (
SELECT survey_age_group,
       survey_sex,
       survey_pregnancy_code,
       survey_alcohol_code,
       CASE WHEN survey_pregnancy_code IN ('P1', 'P2', 'P3') THEN SUM(ALCOHOL_CNT) ELSE 0 END AS PREG_ALCOHOL_CNT,
       CASE WHEN survey_pregnancy_code NOT IN ('P1', 'P2', 'P3') THEN SUM(ALCOHOL_CNT) ELSE 0 END AS NON_PREG_ALCOHOL_CNT
FROM TEMP_PREG_ALCOHOL
GROUP BY 1, 2, 3, 4
),
TEMP_PIVOT_PREG_ALCOHOL_CNT AS (
SELECT survey_age_group,
	   SUM(PREG_ALCOHOL_CNT) AS PREG_ALCOHOL_CNT,
       SUM(NON_PREG_ALCOHOL_CNT) AS NON_PREG_ALCOHOL_CNT
FROM TEMP_PREG_ALCOHOL_CNT
GROUP BY 1
)
SELECT survey_age_group AS '연령대',
	   CONCAT(ROUND(PREG_ALCOHOL_CNT / (SELECT COUNT(*) 
										FROM survey 
										WHERE survey_sex='f'
										) *100, 2), '%') AS '전체 여성수 대비 임신 인구의 음주 비율',
	   CONCAT(ROUND(NON_PREG_ALCOHOL_CNT / (SELECT COUNT(*) 
										  FROM survey 
										  WHERE survey_sex='f'
										  ) *100, 2), '%') AS '전체 여성수 대비 비임신 인구의 음주 비율'
FROM TEMP_PIVOT_PREG_ALCOHOL_CNT;
;

-- 여성 임산부 중 흡연 응답한 인원 X
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_smoking_code) AS SMOKING_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_pregnancy_code IN ('P1', 'P2', 'P3')
  AND survey_smoking_code IN ('A1', 'A2', 'A3')
GROUP BY 1, 2;

-- 연령별 성별 관심있는 제품 TOP5
SELECT * FROM product;
SELECT * FROM product_like;
SELECT * FROM survey;

WITH TEMP_PRODUCT_LIKE AS (
SELECT A.product_name,
       C.survey_sex,
       C.survey_age_group,
       COUNT(B.product_like_id) AS product_like,
       DENSE_RANK() OVER(PARTITION BY survey_sex, survey_age_group ORDER BY COUNT(B.product_like_id) DESC) AS LIKE_RANK
FROM product A
LEFT JOIN product_like B
ON A.product_id = B.product_id
LEFT JOIN survey C
ON B.profile_id = C.profile_id
WHERE NOT survey_sex IS NULL
GROUP BY 1, 2, 3
)
SELECT *
FROM TEMP_PRODUCT_LIKE
WHERE LIKE_RANK <= 5
;

-- 연령별 성별 가장 많이 조회한 영양제 TOP5
select * from product_view;
SELECT * FROM product;
select * from survey;

WITH TEMP_PRODUCT_VIEW AS (
SELECT A.product_name,
       C.survey_sex,
       C.survey_age_group,
       COUNT(B.product_view_id) AS product_view,
       DENSE_RANK() OVER(PARTITION BY survey_sex, survey_age_group ORDER BY COUNT(B.product_view_id) DESC) AS VIEW_RANK
FROM product A
LEFT JOIN product_view B
ON A.product_id = B.product_id
LEFT JOIN survey C
ON B.profile_id = C.profile_id
WHERE NOT survey_sex IS NULL
GROUP BY 1, 2, 3
)
SELECT *
FROM TEMP_PRODUCT_VIEW
WHERE VIEW_RANK <= 5
;

-- 단일 프로필로 서비스 이용 vs 멀티프로필로 서비스 이용 고객군 파악
-- survey는 profile을 만드려면 있어야 하는 거니까 profile 테이블 안써도 될듯

SELECT * FROM user;
SELECT * FROM survey;

SELECT A.user_id,
	   profile_id,
       survey_sex,
       survey_age_group,
       number_of_family
FROM survey A
LEFT JOIN (
			SELECT user_id,
				   COUNT(user_id) AS number_of_family
			FROM survey
			GROUP BY 1
) B
ON A.user_id = B.user_id
;

SELECT A.user_id,
	   profile_id,
       survey_sex,
       survey_age_group,
       number_of_family
FROM survey A
LEFT JOIN (
			SELECT user_id,
				   COUNT(user_id) AS number_of_family
			FROM survey
			GROUP BY 1
) B
ON A.user_id = B.user_id
;