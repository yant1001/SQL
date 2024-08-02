USE dummy_survey;
SELECT * FROM survey;
SELECT * FROM hf_list;
SELECT * FROM al_list;
SELECT * FROM di_list;

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
SELECT CONCAT(survey_age_group, '대') AS '연령대',
	   CONCAT(ROUND(MALE_CNT / (MALE_CNT+FEMALE_CNT) * 100, 0), '%') AS '남성수 비율',
       CONCAT(ROUND(FEMALE_CNT / (MALE_CNT+FEMALE_CNT) * 100, 0), '%') AS '여성수 비율'
FROM TEMP_PIVOT_SE_CNT;


-- 연령별 성별 특정 건강고민 비율 (코드만 수정해서 조회 가능)
SELECT * FROM hf_list WHERE hf_list LIKE '%HF21%';   -- SELECT * FROM hf_list WHERE HF21 = 1; 와 동일한 결과 (소요시간 동일)

WITH TEMP_HF AS (
SELECT A.survey_age_group,
	   A.survey_sex,
       COUNT(hf_list) AS HF_CNT
FROM survey A
LEFT JOIN hf_list B
ON A.id = B.id 
WHERE hf_list LIKE '%HF21%'
GROUP BY 1, 2
),
TEMP_HF_CNT AS (
SELECT survey_age_group,
       CASE WHEN survey_sex='m' THEN HF_CNT ELSE 0 END AS HF_MALE_CNT,
       CASE WHEN survey_sex='f' THEN HF_CNT ELSE 0 END AS HF_FEMALE_CNT
FROM TEMP_HF
),
TEMP_PIVOT_HF_CNT AS (
SELECT survey_age_group,
	   MAX(HF_MALE_CNT) AS HF_MALE_CNT,
       MAX(HF_FEMALE_CNT) AS HF_FEMALE_CNT
FROM TEMP_HF_CNT
GROUP BY 1
)
SELECT CONCAT(survey_age_group, '대') AS '연령대',
	   CONCAT(ROUND(HF_MALE_CNT / (SELECT COUNT(*) 
									 FROM survey 
                                     WHERE survey_sex='m' 
                                     AND survey_age_group=TEMP_PIVOT_HF_CNT.survey_age_group
                                     ) *100, 2), '%') AS '동일 연령대 남성수 대비 건강 고민 비율',
	   CONCAT(ROUND(HF_FEMALE_CNT / (SELECT COUNT(*) 
								     FROM survey 
                                     WHERE survey_sex='f' 
                                     AND survey_age_group=TEMP_PIVOT_HF_CNT.survey_age_group
                                     ) *100, 2), '%') AS '동일 연령대 여성수 대비 건강 고민 비율',
	   CONCAT(ROUND(HF_MALE_CNT / (SELECT COUNT(*) 
								   FROM survey 
                                   WHERE survey_sex='m'
                                   ) *100, 2), '%') AS '전체 남성수 대비 건강 고민 비율',
	   CONCAT(ROUND(HF_FEMALE_CNT / (SELECT COUNT(*) 
									 FROM survey 
                                     WHERE survey_sex='f'
                                     ) *100, 2), '%') AS '전체 여성수 대비 건강 고민 비율'
FROM TEMP_PIVOT_HF_CNT
;

-- 연령별 성별 특정 알레르기 비율 (코드만 수정해서 조회 가능)
WITH TEMP_AL AS (
SELECT A.survey_age_group,
	   A.survey_sex,
       COUNT(al_list) AS AL_CNT
FROM survey A
LEFT JOIN al_list B
ON A.id = B.id 
WHERE al_list LIKE '%AL20%'
GROUP BY 1, 2
),
TEMP_AL_CNT AS (
SELECT survey_age_group,
       CASE WHEN survey_sex='m' THEN AL_CNT ELSE 0 END AS AL_MALE_CNT,
       CASE WHEN survey_sex='f' THEN AL_CNT ELSE 0 END AS AL_FEMALE_CNT
FROM TEMP_AL
),
TEMP_PIVOT_AL_CNT AS (
SELECT survey_age_group,
	   MAX(AL_MALE_CNT) AS AL_MALE_CNT,
       MAX(AL_FEMALE_CNT) AS AL_FEMALE_CNT
FROM TEMP_AL_CNT
GROUP BY 1
)
SELECT CONCAT(survey_age_group, '대') AS '연령대',
	   CONCAT(ROUND(AL_MALE_CNT / (SELECT COUNT(*) 
									 FROM survey 
                                     WHERE survey_sex='m' 
                                     AND survey_age_group=TEMP_PIVOT_AL_CNT.survey_age_group
                                     ) *100, 2), '%') AS '동일 연령대 남성수 대비 알레르기 비율',
	   CONCAT(ROUND(AL_FEMALE_CNT / (SELECT COUNT(*) 
								     FROM survey 
                                     WHERE survey_sex='f' 
                                     AND survey_age_group=TEMP_PIVOT_AL_CNT.survey_age_group
                                     ) *100, 2), '%') AS '동일 연령대 여성수 대비 알레르기 비율',
	   CONCAT(ROUND(AL_MALE_CNT / (SELECT COUNT(*) 
								   FROM survey 
                                   WHERE survey_sex='m'
                                   ) *100, 2), '%') AS '전체 남성수 대비 알레르기 비율',
	   CONCAT(ROUND(AL_FEMALE_CNT / (SELECT COUNT(*) 
									 FROM survey 
                                     WHERE survey_sex='f'
                                     ) *100, 2), '%') AS '전체 여성수 대비 알레르기 비율'
FROM TEMP_PIVOT_AL_CNT
;

-- 연령별 성별 특정 기저질환 비율
WITH TEMP_DI AS (
SELECT A.survey_age_group,
	   A.survey_sex,
       COUNT(di_list) AS DI_CNT
FROM survey A
LEFT JOIN di_list B
ON A.id = B.id 
WHERE di_list LIKE '%DI17%'
GROUP BY 1, 2
),
TEMP_DI_CNT AS (
SELECT survey_age_group,
       CASE WHEN survey_sex='m' THEN DI_CNT ELSE 0 END AS DI_MALE_CNT,
       CASE WHEN survey_sex='f' THEN DI_CNT ELSE 0 END AS DI_FEMALE_CNT
FROM TEMP_DI
),
TEMP_PIVOT_DI_CNT AS (
SELECT survey_age_group,
	   MAX(DI_MALE_CNT) AS DI_MALE_CNT,
       MAX(DI_FEMALE_CNT) AS DI_FEMALE_CNT
FROM TEMP_DI_CNT
GROUP BY 1
)
SELECT CONCAT(survey_age_group, '대') AS '연령대',
	   CONCAT(ROUND(DI_MALE_CNT / (SELECT COUNT(*) 
									 FROM survey 
                                     WHERE survey_sex='m' 
                                     AND survey_age_group=TEMP_PIVOT_DI_CNT.survey_age_group
                                     ) *100, 2), '%') AS '동일 연령대 남성수 대비 기저질환 비율',
	   CONCAT(ROUND(DI_FEMALE_CNT / (SELECT COUNT(*) 
								     FROM survey 
                                     WHERE survey_sex='f' 
                                     AND survey_age_group=TEMP_PIVOT_DI_CNT.survey_age_group
                                     ) *100, 2), '%') AS '동일 연령대 여성수 대비 기저질환 비율',
	   CONCAT(ROUND(DI_MALE_CNT / (SELECT COUNT(*) 
								   FROM survey 
                                   WHERE survey_sex='m'
                                   ) *100, 2), '%') AS '전체 남성수 대비 기저질환 비율',
	   CONCAT(ROUND(DI_FEMALE_CNT / (SELECT COUNT(*) 
									 FROM survey 
                                     WHERE survey_sex='f'
                                     ) *100, 2), '%') AS '전체 여성수 대비 기저질환 비율'
FROM TEMP_PIVOT_DI_CNT
;

-- 연령별 성별 음주 비율
-- A0: 거의 마시지 않음, A1: 주 1회, A2: 주 2~3회, A3: 주 4회 이상, 1: 선택하지 않음
WITH TEMP_ALCOHOL AS (
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_alcohol) AS ALCOHOL_CNT
FROM survey
WHERE survey_alcohol IN ('A1', 'A2', 'A3')
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
SELECT CONCAT(survey_age_group, '대') AS '연령대',
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
-- y: 흡연, n: 비흡연
WITH TEMP_SMOKING AS (
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_smoking) AS SMOKING_CNT
FROM survey
WHERE survey_smoking = 'y'
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
SELECT CONCAT(survey_age_group, '대') AS '연령대',
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
-- 더미 데이터 상에는 P1, P2는 없음

-- 여성 임산부 중 음주 응답한 인원 X
SELECT survey_age_group,
	   survey_sex,
       COUNT(survey_alcohol) AS ALCOHOL_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_pregnancy IN ('P1', 'P2', 'P3')
  AND survey_alcohol IN ('A1', 'A2', 'A3')
GROUP BY 1, 2;

-- 그래도 시각화 시킬 수 있게 쿼리 구현
WITH TEMP_PREG_ALCOHOL AS (
SELECT survey_age_group,
       survey_pregnancy,
       COUNT(survey_alcohol) AS ALCOHOL_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_alcohol IN ('A1', 'A2', 'A3')
GROUP BY 1, 2
),
TEMP_PREG_ALCOHOL_CNT AS (
SELECT survey_age_group,
       survey_pregnancy,
       CASE WHEN survey_pregnancy IN ('P1', 'P2', 'P3') THEN SUM(ALCOHOL_CNT) ELSE 0 END AS PREG_ALCOHOL_CNT,
       CASE WHEN survey_pregnancy NOT IN ('P1', 'P2', 'P3') THEN SUM(ALCOHOL_CNT) ELSE 0 END AS NON_PREG_ALCOHOL_CNT
FROM TEMP_PREG_ALCOHOL
GROUP BY 1, 2
),
TEMP_PIVOT_PREG_ALCOHOL_CNT AS (
SELECT survey_age_group,
	   SUM(PREG_ALCOHOL_CNT) AS PREG_ALCOHOL_CNT,
       SUM(NON_PREG_ALCOHOL_CNT) AS NON_PREG_ALCOHOL_CNT
FROM TEMP_PREG_ALCOHOL_CNT
GROUP BY 1
)
SELECT CONCAT(survey_age_group, '대') AS '연령대',
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
       COUNT(survey_smoking) AS SMOKING_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_pregnancy IN ('P1', 'P2', 'P3')
  AND survey_smoking IN ('A1', 'A2', 'A3')
GROUP BY 1, 2;

WITH TEMP_PREG_SMOKING AS (
SELECT survey_age_group,
       survey_pregnancy,
       COUNT(survey_smoking) AS SMOKING_CNT
FROM survey
WHERE survey_sex='f'
  AND survey_smoking = 'y'
GROUP BY 1, 2
),
TEMP_PREG_SMOKING_CNT AS (
SELECT survey_age_group,
       survey_pregnancy,
       CASE WHEN survey_pregnancy IN ('P1', 'P2', 'P3') THEN SUM(SMOKING_CNT) ELSE 0 END AS PREG_SMOKING_CNT,
       CASE WHEN survey_pregnancy NOT IN ('P1', 'P2', 'P3') THEN SUM(SMOKING_CNT) ELSE 0 END AS NON_PREG_SMOKING_CNT
FROM TEMP_PREG_SMOKING
GROUP BY 1, 2
),
TEMP_PIVOT_PREG_SMOKING_CNT AS (
SELECT survey_age_group,
	   SUM(PREG_SMOKING_CNT) AS PREG_SMOKING_CNT,
       SUM(NON_PREG_SMOKING_CNT) AS NON_PREG_SMOKING_CNT
FROM TEMP_PREG_SMOKING_CNT
GROUP BY 1
)
SELECT CONCAT(survey_age_group, '대') AS '연령대',
	   CONCAT(ROUND(PREG_SMOKING_CNT / (SELECT COUNT(*) 
										FROM survey 
										WHERE survey_sex='f'
										) *100, 2), '%') AS '전체 여성수 대비 임신 인구의 흡연 비율',
	   CONCAT(ROUND(NON_PREG_SMOKING_CNT / (SELECT COUNT(*) 
										  FROM survey 
										  WHERE survey_sex='f'
										  ) *100, 2), '%') AS '전체 여성수 대비 비임신 인구의 흡연 비율'
FROM TEMP_PIVOT_PREG_SMOKING_CNT;
;
