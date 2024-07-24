USE PillSoGood;

-- 가입 기간에 따른 홈페이지 활동량 (ex. 찜, 댓글 수)
SELECT DATEDIFF(CURRENT_DATE(), date_joined) AS DATE_DIFF 
FROM user;

-- 찜한 영양제의 영양성분 카테고리 인기순
SELECT * FROM product_like;
SELECT * FROM product;
SELECT * FROM product_ingredient;
SELECT * FROM ingredient;
SELECT * FROM ingredient_com_code;

SELECT ingredient_grp_name,
       COUNT(ingredient_grp_name) AS pop_ingredient_in_product_like
FROM product_like A
LEFT JOIN product_ingredient B
ON A.product_id = B.product_id
LEFT JOIN ingredient C
ON B.ingredient_id = C.ingredient_id
GROUP BY 1
ORDER BY 2 DESC;

-- 유저들에게 가장 많이 추천한 영양제 인기순
SELECT * FROM recom;
SELECT * FROM recom_ingredient;
SELECT * FROM recom_survey_product;
SELECT product_name,
	   COUNT(product_name) AS pop_recom_product
FROM recom A
LEFT JOIN recom_survey_product B
ON A.recom_id = B.recom_id
LEFT JOIN product C
ON B.product_id = C.product_id
GROUP BY 1;


-- 같은 계정 내 프로필들(가족들)이 공통으로 찜한 영양제 인기순
-- 설문에 기입한 건강기능과 관련된 영양제를 실제로 관심있어 하는가?
-- 어떤 건강기능과 관련된 영양제에 관심을 갖고 있는가?