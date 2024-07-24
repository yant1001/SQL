USE dummy_survey;
SELECT * FROM dummy_survey;

-- 테이블 전체 확인
SELECT *
FROM dummy_survey;
SELECT COUNT(*)
FROM dummy_survey;

-- id 컬럼값 추가
ALTER TABLE dummy_survey
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

-- 확인
SELECT * 
FROM dummy_survey;

-- HF 열 데이터를 행 데이터로 변환 (GROUP_CONCAT)
SELECT 
    id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
    GROUP_CONCAT(HF ORDER BY HF SEPARATOR ', ') AS HF
FROM (
    SELECT 
		id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        CASE WHEN HF01=1 THEN 'HF01' ELSE NULL END AS HF 
    FROM dummy_survey 
    WHERE HF01 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        CASE WHEN HF02=1 THEN 'HF02' ELSE NULL END AS HF 
    FROM dummy_survey 
    WHERE HF02 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        CASE WHEN HF03=1 THEN 'HF03' ELSE NULL END AS HF 
    FROM dummy_survey
    WHERE HF03 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        CASE WHEN HF04=1 THEN 'HF04' ELSE NULL END AS HF 
    FROM dummy_survey
    WHERE HF04 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        CASE WHEN HF05=1 THEN 'HF05' ELSE NULL END AS HF 
    FROM dummy_survey
    WHERE HF05 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        CASE WHEN HF06=1 THEN 'HF06' ELSE NULL END AS HF 
    FROM dummy_survey
    WHERE HF06 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF07' AS HF 
    FROM dummy_survey
    WHERE HF07 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF08' AS HF 
    FROM dummy_survey
    WHERE HF08 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF09' AS HF 
    FROM dummy_survey
    WHERE HF09 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF10' AS HF 
    FROM dummy_survey
    WHERE HF10 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF11' AS HF 
    FROM dummy_survey
    WHERE HF11 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF12' AS HF 
    FROM dummy_survey 
    WHERE HF12 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF13' AS HF 
    FROM dummy_survey 
    WHERE HF13 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF14' AS HF 
    FROM dummy_survey 
    WHERE HF14 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF15' AS HF 
    FROM dummy_survey 
    WHERE HF15 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF16' AS HF 
    FROM dummy_survey 
    WHERE HF16 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF17' AS HF 
    FROM dummy_survey 
    WHERE HF17 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF18' AS HF 
    FROM dummy_survey 
    WHERE HF18 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF19' AS HF 
    FROM dummy_survey 
    WHERE HF19 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF20' AS HF 
    FROM dummy_survey 
    WHERE HF20 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF21' AS HF 
    FROM dummy_survey 
    WHERE HF21 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF22' AS HF 
    FROM dummy_survey 
    WHERE HF22 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF23' AS HF 
    FROM dummy_survey 
    WHERE HF23 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF24' AS HF 
    FROM dummy_survey 
    WHERE HF24 = 1 
    UNION ALL
    SELECT 
        id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking,
        'HF25' AS HF 
    FROM dummy_survey 
    WHERE HF25 = 1 
) VAL
GROUP BY id, survey_age_group, survey_sex, survey_pregnancy, survey_operation, survey_alcohol, survey_smoking;

-- survey 테이블 분리
CREATE TABLE dummy_survey.survey AS
SELECT id,
	   survey_age_group,
       survey_sex,
       survey_pregnancy,
       survey_operation,
       survey_alcohol,
       survey_smoking
FROM dummy_survey
;





-- 건강 고민 문항 관련
-- HF 코드만 분리한 테이블 생성
CREATE TABLE HF_codes (
    id INT,
    HF_code VARCHAR(5),
    PRIMARY KEY (id, HF_code)
);
-- HF 코드 데이터 삽입
INSERT INTO HF_CODES (id, HF_CODE)
SELECT id, 'HF01' FROM dummy_survey WHERE HF01=1
UNION ALL SELECT id, 'HF02' FROM dummy_survey WHERE HF02=1
UNION ALL SELECT id, 'HF03' FROM dummy_survey WHERE HF03=1
UNION ALL SELECT id, 'HF04' FROM dummy_survey WHERE HF04=1
UNION ALL SELECT id, 'HF05' FROM dummy_survey WHERE HF05=1
UNION ALL SELECT id, 'HF06' FROM dummy_survey WHERE HF06=1
UNION ALL SELECT id, 'HF07' FROM dummy_survey WHERE HF07=1
UNION ALL SELECT id, 'HF08' FROM dummy_survey WHERE HF08=1
UNION ALL SELECT id, 'HF09' FROM dummy_survey WHERE HF09=1
UNION ALL SELECT id, 'HF10' FROM dummy_survey WHERE HF10=1
UNION ALL SELECT id, 'HF11' FROM dummy_survey WHERE HF11=1
UNION ALL SELECT id, 'HF12' FROM dummy_survey WHERE HF12=1
UNION ALL SELECT id, 'HF13' FROM dummy_survey WHERE HF13=1
UNION ALL SELECT id, 'HF14' FROM dummy_survey WHERE HF14=1
UNION ALL SELECT id, 'HF15' FROM dummy_survey WHERE HF15=1
UNION ALL SELECT id, 'HF16' FROM dummy_survey WHERE HF16=1
UNION ALL SELECT id, 'HF17' FROM dummy_survey WHERE HF17=1
UNION ALL SELECT id, 'HF18' FROM dummy_survey WHERE HF18=1
UNION ALL SELECT id, 'HF19' FROM dummy_survey WHERE HF19=1
UNION ALL SELECT id, 'HF20' FROM dummy_survey WHERE HF20=1
UNION ALL SELECT id, 'HF21' FROM dummy_survey WHERE HF21=1
UNION ALL SELECT id, 'HF22' FROM dummy_survey WHERE HF22=1
UNION ALL SELECT id, 'HF23' FROM dummy_survey WHERE HF23=1
UNION ALL SELECT id, 'HF24' FROM dummy_survey WHERE HF24=1
UNION ALL SELECT id, 'HF25' FROM dummy_survey WHERE HF25=1
;
SELECT * FROM HF_CODES;
-- HF 코드 리스트 형태 컬럼을 추가한 건강고민 테이블 분리
CREATE TABLE dummy_survey.HF_list AS
SELECT A.id,
	   GROUP_CONCAT(B.HF_CODE ORDER BY B.HF_CODE SEPARATOR ', ') AS HF_list,
	   HF01, HF02, HF03, HF04, HF05, HF06, HF07, HF08, HF09, HF10,
       HF11, HF12, HF13, HF14, HF15, HF16, HF17, HF18, HF19, HF20,
       HF21, HF22, HF23, HF24, HF25
FROM dummy_survey A
LEFT JOIN HF_CODES B
ON A.id = B.id
GROUP BY A.id,
  	     HF01, HF02, HF03, HF04, HF05, HF06, HF07, HF08, HF09, HF10,
         HF11, HF12, HF13, HF14, HF15, HF16, HF17, HF18, HF19, HF20,
         HF21, HF22, HF23, HF24, HF25
;
SELECT * FROM HF_list;





-- 알레르기 문항 관련
-- AL 코드만 분리한 테이블 생성
CREATE TABLE AL_codes (
    id INT,
    AL_code VARCHAR(5),
    PRIMARY KEY (id, AL_code)
);
-- AL 코드 데이터 삽입
INSERT INTO AL_codes (id, AL_code)
SELECT id, 'AL01' FROM dummy_survey WHERE AL01=1
UNION ALL SELECT id, 'AL02' FROM dummy_survey WHERE AL02=1
UNION ALL SELECT id, 'AL03' FROM dummy_survey WHERE AL03=1
UNION ALL SELECT id, 'AL04' FROM dummy_survey WHERE AL04=1
UNION ALL SELECT id, 'AL05' FROM dummy_survey WHERE AL05=1
UNION ALL SELECT id, 'AL06' FROM dummy_survey WHERE AL06=1
UNION ALL SELECT id, 'AL07' FROM dummy_survey WHERE AL07=1
UNION ALL SELECT id, 'AL08' FROM dummy_survey WHERE AL08=1
UNION ALL SELECT id, 'AL09' FROM dummy_survey WHERE AL09=1
UNION ALL SELECT id, 'AL10' FROM dummy_survey WHERE AL10=1
UNION ALL SELECT id, 'AL11' FROM dummy_survey WHERE AL11=1
UNION ALL SELECT id, 'AL12' FROM dummy_survey WHERE AL12=1
UNION ALL SELECT id, 'AL13' FROM dummy_survey WHERE AL13=1
UNION ALL SELECT id, 'AL14' FROM dummy_survey WHERE AL14=1
UNION ALL SELECT id, 'AL15' FROM dummy_survey WHERE AL15=1
UNION ALL SELECT id, 'AL16' FROM dummy_survey WHERE AL16=1
UNION ALL SELECT id, 'AL17' FROM dummy_survey WHERE AL17=1
UNION ALL SELECT id, 'AL18' FROM dummy_survey WHERE AL18=1
UNION ALL SELECT id, 'AL19' FROM dummy_survey WHERE AL19=1
UNION ALL SELECT id, 'AL20' FROM dummy_survey WHERE AL20=1
;
SELECT * FROM AL_CODES;
-- AL 코드 리스트 형태 컬럼을 추가한 알레르기 테이블 분리
CREATE TABLE dummy_survey.AL_list AS
SELECT A.id,
	   GROUP_CONCAT(B.AL_CODE ORDER BY B.AL_CODE SEPARATOR ', ') AS AL_list,
	   AL01, AL02, AL03, AL04, AL05, AL06, AL07, AL08, AL09, AL10,
       AL11, AL12, AL13, AL14, AL15, AL16, AL17, AL18, AL19, AL20
FROM dummy_survey A
LEFT JOIN AL_CODES B
ON A.id = B.id
GROUP BY A.id,
	     AL01, AL02, AL03, AL04, AL05, AL06, AL07, AL08, AL09, AL10,
         AL11, AL12, AL13, AL14, AL15, AL16, AL17, AL18, AL19, AL20
;
SELECT * FROM AL_list;





-- 기저질환 관련
-- DI 코드만 분리한 테이블 생성
CREATE TABLE DI_codes (
    id INT,
    DI_code VARCHAR(5),
    PRIMARY KEY (id, DI_code)
);
-- AL 코드 데이터 삽입
INSERT INTO DI_codes (id, DI_code)
SELECT id, 'DI01' FROM dummy_survey WHERE DI01=1
UNION ALL SELECT id, 'DI02' FROM dummy_survey WHERE DI02=1
UNION ALL SELECT id, 'DI03' FROM dummy_survey WHERE DI03=1
UNION ALL SELECT id, 'DI04' FROM dummy_survey WHERE DI04=1
UNION ALL SELECT id, 'DI05' FROM dummy_survey WHERE DI05=1
UNION ALL SELECT id, 'DI06' FROM dummy_survey WHERE DI06=1
UNION ALL SELECT id, 'DI07' FROM dummy_survey WHERE DI07=1
UNION ALL SELECT id, 'DI08' FROM dummy_survey WHERE DI08=1
UNION ALL SELECT id, 'DI09' FROM dummy_survey WHERE DI09=1
UNION ALL SELECT id, 'DI10' FROM dummy_survey WHERE DI10=1
UNION ALL SELECT id, 'DI11' FROM dummy_survey WHERE DI11=1
UNION ALL SELECT id, 'DI12' FROM dummy_survey WHERE DI12=1
UNION ALL SELECT id, 'DI13' FROM dummy_survey WHERE DI13=1
UNION ALL SELECT id, 'DI14' FROM dummy_survey WHERE DI14=1
UNION ALL SELECT id, 'DI15' FROM dummy_survey WHERE DI15=1
UNION ALL SELECT id, 'DI16' FROM dummy_survey WHERE DI16=1
UNION ALL SELECT id, 'DI17' FROM dummy_survey WHERE DI17=1
;
SELECT * FROM DI_CODES;
-- AL 코드 리스트 형태 컬럼을 추가한 알레르기 테이블 분리
CREATE TABLE dummy_survey.DI_list AS
SELECT A.id,
	   GROUP_CONCAT(B.DI_CODE ORDER BY B.DI_CODE SEPARATOR ', ') AS DI_list,
	   DI01, DI02, DI03, DI04, DI05, DI06, DI07, DI08, DI09, DI10,
       DI11, DI12, DI13, DI14, DI15, DI16, DI17
FROM dummy_survey A
LEFT JOIN DI_CODES B
ON A.id = B.id
GROUP BY A.id,
	     DI01, DI02, DI03, DI04, DI05, DI06, DI07, DI08, DI09, DI10,
         DI11, DI12, DI13, DI14, DI15, DI16, DI17
;
SELECT * FROM DI_list;

