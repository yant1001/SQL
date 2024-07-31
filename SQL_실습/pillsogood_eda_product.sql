USE PillSoGood;

-- 건강기능별 영양제 개수
-- JSON 키 값 추출
SELECT product_id,
       JSON_EXTRACT(product_function_code, '$.HF00') AS HF00,
       JSON_EXTRACT(product_function_code, '$.HF01') AS HF01,
       JSON_EXTRACT(product_function_code, '$.HF02') AS HF02,
       JSON_EXTRACT(product_function_code, '$.HF03') AS HF03,
       JSON_EXTRACT(product_function_code, '$.HF04') AS HF04,
       JSON_EXTRACT(product_function_code, '$.HF05') AS HF05,
       JSON_EXTRACT(product_function_code, '$.HF06') AS HF06,
       JSON_EXTRACT(product_function_code, '$.HF07') AS HF07,
       JSON_EXTRACT(product_function_code, '$.HF08') AS HF08,
       JSON_EXTRACT(product_function_code, '$.HF09') AS HF09,
       JSON_EXTRACT(product_function_code, '$.HF10') AS HF10,
       JSON_EXTRACT(product_function_code, '$.HF11') AS HF11,
       JSON_EXTRACT(product_function_code, '$.HF12') AS HF12,
       JSON_EXTRACT(product_function_code, '$.HF13') AS HF13,
       JSON_EXTRACT(product_function_code, '$.HF14') AS HF14,
       JSON_EXTRACT(product_function_code, '$.HF15') AS HF15,
       JSON_EXTRACT(product_function_code, '$.HF16') AS HF16,
       JSON_EXTRACT(product_function_code, '$.HF17') AS HF17,
       JSON_EXTRACT(product_function_code, '$.HF18') AS HF18,
       JSON_EXTRACT(product_function_code, '$.HF19') AS HF19,
       JSON_EXTRACT(product_function_code, '$.HF20') AS HF20,
       JSON_EXTRACT(product_function_code, '$.HF21') AS HF21,
       JSON_EXTRACT(product_function_code, '$.HF22') AS HF22,
       JSON_EXTRACT(product_function_code, '$.HF23') AS HF23,
       JSON_EXTRACT(product_function_code, '$.HF24') AS HF24,
       JSON_EXTRACT(product_function_code, '$.HF25') AS HF25,
       JSON_EXTRACT(product_function_code, '$.HF26') AS HF26       
FROM product;
-- 컬럼명인 것들은 집계가 불가능하다. 로우 값으로 변환해주기 
WITH TEMP_HF AS (
SELECT product_id,
       JSON_EXTRACT(product_function_code, '$.HF00') AS HF00,
       JSON_EXTRACT(product_function_code, '$.HF01') AS HF01,
       JSON_EXTRACT(product_function_code, '$.HF02') AS HF02,
       JSON_EXTRACT(product_function_code, '$.HF03') AS HF03,
       JSON_EXTRACT(product_function_code, '$.HF04') AS HF04,
       JSON_EXTRACT(product_function_code, '$.HF05') AS HF05,
       JSON_EXTRACT(product_function_code, '$.HF06') AS HF06,
       JSON_EXTRACT(product_function_code, '$.HF07') AS HF07,
       JSON_EXTRACT(product_function_code, '$.HF08') AS HF08,
       JSON_EXTRACT(product_function_code, '$.HF09') AS HF09,
       JSON_EXTRACT(product_function_code, '$.HF10') AS HF10,
       JSON_EXTRACT(product_function_code, '$.HF11') AS HF11,
       JSON_EXTRACT(product_function_code, '$.HF12') AS HF12,
       JSON_EXTRACT(product_function_code, '$.HF13') AS HF13,
       JSON_EXTRACT(product_function_code, '$.HF14') AS HF14,
       JSON_EXTRACT(product_function_code, '$.HF15') AS HF15,
       JSON_EXTRACT(product_function_code, '$.HF16') AS HF16,
       JSON_EXTRACT(product_function_code, '$.HF17') AS HF17,
       JSON_EXTRACT(product_function_code, '$.HF18') AS HF18,
       JSON_EXTRACT(product_function_code, '$.HF19') AS HF19,
       JSON_EXTRACT(product_function_code, '$.HF20') AS HF20,
       JSON_EXTRACT(product_function_code, '$.HF21') AS HF21,
       JSON_EXTRACT(product_function_code, '$.HF22') AS HF22,
       JSON_EXTRACT(product_function_code, '$.HF23') AS HF23,
       JSON_EXTRACT(product_function_code, '$.HF24') AS HF24,
       JSON_EXTRACT(product_function_code, '$.HF25') AS HF25,
       JSON_EXTRACT(product_function_code, '$.HF26') AS HF26       
FROM product
)
SELECT HF00,
	   COUNT(product_id)
FROM TEMP_HF
GROUP BY 1;

-- 영양제 형태(product_dispos) 분포
SELECT product_dispos,
	   COUNT(product_dispos)
FROM product
GROUP BY 1;


-- 주의사항 카테고리별 (예: 기저질환, 알레르기, 연령 등등) 영양제/영양성분 개수
SELECT product_caution_code LIKE '%HF%'
FROM product;
SELECT * FROM product;


/* 코드 보관
SELECT product_id,
	   IF(HF00=1, 'HF00', NULL) AS HF00,
	   IF(HF01=1, 'HF01', NULL) AS HF01,
	   IF(HF02=1, 'HF02', NULL) AS HF02,
	   IF(HF03=1, 'HF03', NULL) AS HF03,
	   IF(HF04=1, 'HF04', NULL) AS HF04,
	   IF(HF05=1, 'HF05', NULL) AS HF05,
	   IF(HF06=1, 'HF06', NULL) AS HF06,
	   IF(HF07=1, 'HF07', NULL) AS HF07,
	   IF(HF08=1, 'HF08', NULL) AS HF08,
	   IF(HF09=1, 'HF09', NULL) AS HF09,
	   IF(HF10=1, 'HF10', NULL) AS HF10,
	   IF(HF11=1, 'HF11', NULL) AS HF11,
	   IF(HF12=1, 'HF12', NULL) AS HF12,
	   IF(HF13=1, 'HF13', NULL) AS HF13,
	   IF(HF14=1, 'HF14', NULL) AS HF14,
	   IF(HF15=1, 'HF15', NULL) AS HF15,
	   IF(HF16=1, 'HF16', NULL) AS HF16,
	   IF(HF17=1, 'HF17', NULL) AS HF17,
	   IF(HF18=1, 'HF18', NULL) AS HF18,
	   IF(HF19=1, 'HF19', NULL) AS HF19,
	   IF(HF20=1, 'HF20', NULL) AS HF20,
	   IF(HF21=1, 'HF21', NULL) AS HF21,
	   IF(HF22=1, 'HF22', NULL) AS HF22,
	   IF(HF23=1, 'HF23', NULL) AS HF23,
	   IF(HF24=1, 'HF24', NULL) AS HF24,
	   IF(HF25=1, 'HF25', NULL) AS HF25,
       IF(HF26=1, 'HF26', NULL) AS HF26
FROM TEMP_HF;
*/
