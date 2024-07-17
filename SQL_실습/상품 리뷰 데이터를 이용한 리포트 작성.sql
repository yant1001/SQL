USE mydata;
SELECT * FROM dataset2;

-- Division Name(상품이 속한 division)별 평균 평점
SELECT 'DIVISION NAME',
	   AVG(Rating) AS AVG_RATE
FROM mydata.dataset2
GROUP BY 1
ORDER BY 2 DESC;

-- Department(상품이 속한 department)별 평균 평점
SELECT 'DEPARTMENT NAME',
	   AVG(Rating) AS AVG_RATE
FROM mydata.dataset2
GROUP BY 1
ORDER BY 2 DESC;
