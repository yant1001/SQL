# SQL 문법
## 1. SELECT
### 1.1 컬럼 조회
- 필요한 컬럼만 호출하는 역할을 한다.
- 컴마`,`를 추가해서 여러 개의 컬럼을 출력할 수 있다.
  ```SQL
  SELECT 컬럼명1, 컬럼명2
  FROM DB명.테이블명;
  ```
### 1.2 집계 함수
- 집계 함수(COUNT, SUM, AVG 등)를 사용하여 해당 테이블을 특정 기준으로 계산할 수 있다.
  ```SQL
  SELECT 집계 함수
  FROM DB명.테이블명;
  ```
### 1.3 모든 결과 조회(*)
- `*` 연산자를 이용하여 해당 테이블의 모든 컬럼을 출력할 수 있다.
  ```SQL
  SELECT *
  FROM DB명.테이블명;
  ```
- **Tip**. 빅데이터에서는 `LIMIT`을 써서 데이터를 일부만 불러오는 것이 효율 및 시간 측면에서 거의 강제화되어 있다.
### 1.4 AS
- `AS`로 특정 컬럼명을 변경하여 조회할 수 있다.
- `AS`는 생락도 가능하다.
  ```SQL
  SELECT 컬럼명 AS 변경 컬럼명
  FROM DB명.테이블명;
  ```
### 1.5 DISTINCT
- 중복을 제외한 데이터를 조회할 수 있다.
  ```SQL
  SELECT DISTINCT 컬럼명
  FROM DB명.테이블명;
  ```
- 데이터의 양이 많아지면 속도가 느려진다는 단점이 있다.
- 하나의 기준만 가지고 중복 제거하면 너무 많은 데이터가 소실되며, 실제로는 다른 데이터라고 하더라도 기준 하나가 같다는 이유만으로 제거될 위험이 있기 때문에 반드시 2개 이상의 기준을 사용하여 중복 제거해야 한다.
### 1.6 ISNULL
- 지정한 컬럼값이 NULL이면 1 (TRUE)
- 지정한 컬럼값이 NULL이 아니면 0 (FALSE)
### 1.7 IFNULL
- 지정한 컬럼값이 NULL이라면, 대체값을 부여해서 대체 가능하다.
- 파이썬의 fillna()와 유사한 문법이다.
### 1.8 IF (조건, true일때 값, false일때 값)
- True 혹은 False의 경우만 존재한다. 파이썬의 Elif와 같은 경우의 수는 존재하지 않는다.
  - ex. IF(address='경기도', '수도권', '지방')


## 2. FROM
- 특정 정보를 호출하기 위해 필요한 테이블명을 지정할 수 있다.
- `USE DB명;`을 최상단에 작성 후 `FROM` 절 뒤에는 테이블명만 작성 가능하다.
  ```SQL
  SELECT 계산식 또는 컬럼명
  FROM DB명.테이블명;
  ```


## 3. WHERE
- 해당 컬럼에서 필요한 데이터의 조건을 추가하여 데이터를 조회할 수 있다.
  ```SQL
  SELECT 컬럼명
  FROM DB명.테이블명
  WHERE 조건식;
  ```
### 조건절에서 자주 사용되는 연산자
#### (1) BETWEEN
- 특정 컬럼의 값이 시작점~끝점인 데이터만 출력할 수 있는 조건을 만든다.
  ```SQL
  SELECT *
  FROM DB명.테이블명
  WHERE 컬럼 BETWEEN 시작점 AND 끝점;
  ```

#### (2) 대소 관계 표현
- `=`, `>`, `>=`, `<`, `<=`, `<>` 같은 대소 관계 연산자를 이용한다.
  - `<>`: 같지 않음을 의미.

#### (3) IN
- 해당 테이블에서 컬럼값이 값1 또는 값2인 데이터가 출력된다.
- 문자형 값을 입력하는 경우 `''`로 감싸줘야 한다.
  ```SQL
  SELECT 컬럼명
  FROM DB명.테이블명
  WHERE 컬럼명 IN (값1, 값2);
  ```

#### NOT IN
- 특정 값을 포함하지 않는 데이터가 출력된다.
  ```SQL
  SELECT 컬럼명
  FROM DB명.테이블명
  WHERE 컬럼명 NOT IN (값1, 값2);

#### IS NULL
- NULL이란 0이 아닌, 값 자체가 비어있는 미지의 값이라는 의미이다.
- `IS NULL` 연산자를 사용하여 NULL 데이터를 출력할 수 있다.
- `IS NOT NULL` 연산자를 사용하면 NULL이 아닌 데이터만 출력할 수 있다.
  ```SQL
  SELECT 컬럼명 또는 계산식
  FROM DB명.테이블명
  WHERE 컬럼 IS NULL;
  ```

#### LIKE '%TEXT%'
- 특정 필드에 어떤 단어가 포함된 데이터를 조회할 수 있다.
- `%`는 어떤 문자가 와도 상관없다는 의미이다.
  ```SQL
  SELECT *
  FROM DB명.테이블명
  WHERE 주소 LIKE '%부산%';
  ```


## 4. GROUP BY
- 컬럼의 값을 그룹화해서 각 값들의 평균 값, 개수 등을 계산할 때 이용한다.
- 주로 `AVG`, `SUM`, `COUNT` 등의 집계 함수와 같이 사용한다.
- 일반적으로 그룹별 수치를 구하려는 목적으로 사용한다.
  ```SQL
  SELECT 제조 국가, AVG(가격)
  FROM DB명.cars
  GROUP BY 제조 국가;


## 5. JOIN
- 여러 테이블에 나누어 담긴 정보를 조합하기 위해 사용하는 테이블 결합 함수이다.
- 일대일, 일대다, 다대다 등 관계가 복잡해질 우려가 있으므로 무조건 ERD를 만들어두고 시작해야 한다.
### 5.1 LEFT JOIN (LEFT OUTER JOIN)
- 가장 많이 사용되는 JOIN 방법이다.
- `FROM` 절의 테이블울 기준으로, `LEFT JOIN` 절 테이블의 정보가 매칭된다.해당 테이블을 기준으로 매칭되는 정보를 호출한다.
-  `FROM` 절의 테이블 정보는 모두 출력되고, `LEFT JOIN`절의 데이터 중 `FROM` 절과 동일한 키값으로 매칭되는 컬럼만 결합된다.
- `ON`은 어떤 키값으로 데이터를 결합할지 지정한다.
  ```SQL
  SELECT * 
  FROM TABLE_A
  LEFT JOIN TABLE_B
  ON TABLE_A.Column 1 = TABLE_B.Column 2
  ```
### 5.2 INNER JOIN
- 두 가지 테이블에 공통으로 존재하는 정보만 출력된다.
- 파이썬의 merge와 동일하게 작동한다.
- `FROM` 절에 위치한 테이블이 LEFT TABLE이며, 해당 테이블에는 PK가 존재한다.
  ```SQL
  SELECT * 
  FROM TABLE_A
  INNER JOIN TABLE_B
  ON TABLE_A.Column 1 = TABLE_B.Column 2
  ```
### 5.3 FULL JOIN
- 두 가지 테이블에 존재하는 모든 정보를 출력한다.
- 조회 데이터의 볼륨이 커지므로 유의해야 한다.
  ```SQL
  SELECT *
  FROM TABLE_A
  FULL JOIN TABLE_B
  ON TABLE_A.Column 1 = TABLE_B.Column 2
  ```
### 5.4 CROSS JOIN ⭐
- **Tip**. 웹개발자에겐 필요없고, 오히려 피해야하는 기능이지만 데이터분석가에겐 꼭 필요한 기능이다.
- N개의 테이블과 M개의 테이블을 크로스 조인 => N*M개 데이터가 나온다.
- 테이블이 가지고 있는 모든 행의 조합이 다 출력된다.
- WHERE 조건절을 사용한다.
- 사용하는 경우
  - 서울시 교통데이터의 경우, 컬럼별로 성별과 연령이 나와있어서 조회하는 건 쉽지만 데이터를 집계하는 것은 어렵다.
  - 이처럼 컬럼에 집계 기준이 들어있는 경우에는 집계가 불가능하다. (~별이라는 기준이 컬럼에 있는 경우)
  - 이럴 경우 기준 정보를 로우에 데이터로써 존재하게 만들면 집계가 가능해진다.
  - 데이터x성별x나이대 => CROSS JOIN => 경우의 수가 4개 => 각 성별과 나이대에 맞는 데이터 셀렉(CASE-WHEN-THEN 구문 활용)


## 6. CASE WHEN
- 조건에 따른 결과값을 다르게 출력하고 싶을 경우 사용된다.
  ```SQL
  SELECT CASE WHEN 조건 1 THEN 결과 1
              WHEN 조건 2 THEN 결과 2
              ELSE 결과 3
              END
  FROM DB명.테이블명
  ```
- 집계 함수 내부에 해당 구문을 사용하여 필요한 조건만 집계할 수 있다.
- `SELECT` 절에서 `CASE WHEN` 구문을 사용했을 때, `GROUP BY`에서 그룹핑의 기준이 되는 컬럼명을 숫자로 대체하여 지정할 수 있다.
  ```SQL
  SELECT CASE WHEN COUNTRY IN ('USA', 'Canada') THEN 'North America'
              ELSE 'Others'
              END AS region,
         COUNT(CUSTOMERNUMBER) N_CUSTOMERS
  FROM CLASSICMODELS.CUSTOMERS
  GROUP BY 1
  ```


## 7. RANK, DENSE_RANK, ROW_NUMBER
- 데이터에 순위를 매기는데 사용된다.
### 7.1 RANK
- 동점인 경우, 동점 데이터를 모두 등수 하나를 건너뛴 다음 등수로 매긴다.
### 7.2 DENSE_RANK
- 동점인 경우, 동점 데이터를 모두 바로 다음 등수로 매긴다.
### 7.3 ROW_NUMBER
- 동점인 경우, 서로 다른 등수로 계산한다.
### 예시
- 구매 금액을 기준으로 다음과 같이 순위를 매길 수 있다.
- ORDER BY는 기본값이 오름차순이다. (내림차순: DESC)
  ```SQL
  SELECT * 
  ROW_NUMBER() OVER(ORDER BY 구매 금액) ROW_NUMBER,
  RANK() OVER(ORDER BY 구매 금액) RANK,
  DENSE_RANK() OVER(ORDER BY 구매 금액) DENSE_RANK
  FROM TABLE
  ```
- **고객 번호 내**에서는 다음과 같이 순위를 매길 수 있다.
  ```SQL
  SELECT * 
  ROW_NUMBER() OVER(PARTITION BY 고객 번호 ORDER BY 구매 금액) ROW_NUMBER,
  RANK() OVER(PARTITION BY 고객 번호 ORDER BY 구매 금액) RANK,
  DENSE_RANK() OVER(PARTITION BY 고객 번호 ORDER BY 구매 금액) DENSE_RANK
  FROM TABLE
  ```
  
## 8. SUBQUERY
- `IN`, `FROM`, `JOIN` 연산자 이후 `()` 내에 위치하는 쿼리를 서브 쿼리라고 한다.
- `FROM`이나 `JOIN` 절에 서브 쿼리를 사용하면, 서브 쿼리의 실행 결과가 하나의 테이블로 사용된다. 이때 항상 서브 쿼리 마지막에 `A`와 같은 문자열을 입력해 주어야 쿼리 내부에서 해당 명칭으로 사용할 수 있다.
  ```SQL
  -- WHERE 절에 서브 쿼리가 오는 경우
  SELECT ordernumber
  FROM classicmodels.orders
  WHERE customernumber IN (SELECT customernumber
                           FROM classicmodels.customers
                           WHERE city='NYC')

  -- FROM 절에 서브 쿼리가 오는 경우
  SELECT customernumber
  FROM (SELECT customernumber
        FROM classicmodels.customers
        WHERE city='NYC') A
  ```

<br>
<br>
<br>

# 문자열 함수
### SUBSTRING ⭐
- 전처리에 이용한다.
- 나열되어 있다 == 인덱스, 순서가 있다 (양수&음수 인덱스)
- (파이썬과 달리 SQL은 인덱스가 1부터 시작함에 유의한다.)
- SUBSTRING('hologram', 4, 3) => 출력값: org
  - 4번째부터 문자열 3개를 잘라낸다.
  - 시작인덱스(ex. 4)는 음수인덱스가 가능하지만, 범위인덱스(ex. 3)는 음수가 불가능하다.
  - 범위인덱스를 넣지 않으면 문자열이 끝까지 출력된다.
### LENGTH
- 영어와 한글의 길이(용량)가 달라진다.
- 한글은 초성/중성/종성이 각각 1바이트를 차지하기 때문에, 1글자가 3바이트가 된다. 
### CHAR_LENGTH
- 문자열의 길이를 구할 때는 CHAR_LENGTH를 사용한다.
### TRIM
- 특정 문자열 앞뒤의 공백 문자를 제거
- 전처리에 많이 사용한다.
- 파이썬의 strip()함수와 유사하다.
- 옵션: LEADING FROM, BOTH FROM, TRAILING FROM

<br>
<br>
<br>

# 데이터 입력
### NULL이란?
- 0도 아닌 미지의 값을 의미한다.
- NULL 컬럼에 `True`가 온다면 NULL을 허용하는 것을 의미한다.
### NULL 값의 입력을 허용하지 않으려면?
- 강력한 제약조건(=NOT NULL)을 적용해야 한다.
- 기본값(Default)을 지정했다고 해서 NULL이 안 들어가지는 않는다.
### 같은 내용이 입력된 인스턴스를 구분하기 위해서는?
- 각 인스턴스에 고유한 값을 정의하면 된다.
- Primary Key, Unique Key 등
### Primary Key (PK)
- Primary Key(이하 PK)는 중복이 없고 NOT NULL이라는 특징을 갖는다.
- PK의 AUTO INCREMENT 옵션을 사용하면 PK값이 1씩 자동 증가한다.
- **Tip**. PK는 무조건 넣어놓는 것이 좋다.
- PK에 존재하는 값만 FK에 들어갈 수 있다.
  - 한명이 여러개 집합 가능 (PK 집합레벨1, FK 집합레벨N)

<br>
<br>
<br>

# 데이터 유형
### CHAR - 가변길이 문자형
- CHAR(3)은 1글자만 입력해도 나머지 공간 2개는 공백으로 자리가 차지되어 저장된다.
- 용량을 일정 부분 차지하기 때문에, 크기가 고정된 문자열 저장에 유리하다.
### VARCHAR - 고정길이 문자형
- VARCHAR(255)는 255가 최대 길이이다.
- 미리 공간을 만들어두지 않는다.
### INT, TINYINT, BIGINT
- 타입별 표현할 수 있는 최대 크기
- 1byte = 8bit
- 8칸을 이진법 숫자로 표현할 때 가능한 수 = 2^8개
- INT = 4byte = 32bit (2^32개의 숫자로 표현 가능)
- 정수 타입별 byte수(용량)만 기억하기
  - TINYINT = 1bytes
  - SMALLINT = 2bytes
  - MEDIUMINT = 3bytes
  - INT = 4bytes
  - BIGINT = 8bytes
### UNSIGNED
- 상기 정수형 데이터의 표현 범위는 음수에서 양수까지 존재한다.
- UNSIGNED 옵션을 이용하면 음수를 포기하고, 포기한 만큼 양수 표현 범위를 늘릴 수 있다.
### DECIMAL(모든 자릿수 개수, 소수점 자릿수 개수)
- 실수형을 가장 정확하게 표현하는 방법이다.
- DECIMAL(5, 2)일 때, 5개 중 2개는 소수부이고 3개만 정수부임에 유의해야 한다.
- 정수부는 한 자리만 넘어가도 에러가 난다.
- 소수부는 자릿수가 넘어가도 입력은 되지만, 노란색 경고창이 뜬다. (warning = 실행은 되나 문제 있을 수 있다라는 의미)
- DECIMAL은 정확한 표현이 가능하나 공간차지가 크기 때문에, 정확도가 떨어지는 대신 속도가 빠르고 공간을 적게 차지하는 FLOAT, DOUBLE을 사용한다.
- FLOAT, DOUBLE
  - FLOAT: 정수, 소수점 자리를 포함하여 총 6자리 표현
  - DOUBLE: 정수, 소수점 자리를 포함하여 총 15자리 표현
  - 0.12344로 입력할때, 0은 개수에 포함되지 않는다.
  - FLOAT는 1234567.89로 입력할때, 12345670으로 출력되는 오류가 발생한다. 데이터 분석 시에는 소수에 민감해지는 경우가 발생하는데, 이처럼 FLOAT는 값이 틀어지는 경우가 많기 때문에 속도가 정확성보다 중요할 때는 FLOAT보다 **DOUBLE** 추천
### DATE, TIME, DATETIME
- 시계열 분석에 중요하다.
- 타입에 맞지 않게 데이터를 삽입해도 다른 타입은 알아서 사라진다. (EX. DATE에 DATE와 TIME을 모두 넣어도 DATE만 나타난다.)
### CURDATE(), CURTIME(), NOW()
- 현재 시간과 날짜
### 날짜와 시간 데이터
- 데이터 분석할 때는 날짜와 시간 데이터는 필수적인 요소이기 때문에 관련 함수를 외우는 게 가장 좋다.
- DAYOFWEEK
- WEEK
- DAYOFYEAR
- MONTHNAME
- YEAR
- MONTH
- DAY (DAYOFMONTH)
- HOUR
- MINUTE
- SECOND
- DATE
- TIME
- 날짜 양식 바꾸기
  - 전처리에 아주 많이 사용된다.
  - 모두 외울 필요는 없으며, 필요할 때마다 찾아보는 게 낫다.
- TIMESTAMP
  - 실시간 로그를 빠르게 쌓을 때 유리하다. 
  - 밀리 세컨드까지 저장 가능하다.

# 집계
- 집계란 데이터를 요약하기 위한 필수 과정이다.
- 데이터를 1개로 요약하여 줄이기 때문에 이 과정을 Reduction이라고 한다. (reduce~줄이다)
- 줄여주는 작업 = reduction
- 이 작업의 전체 = aggregation
- GROUP BY
  - 그룹바이를 중복제거라고 인지하면 안된다.
  - 특정 기준에 따라 그루핑된 그룹명을 출력, 즉 기준별로 묶었다는 개념으로 이해해야 한다.
  - GROUP BY를 쓸 경우에는, GROUP BY에 쓴 컬럼만 SELECT절에 올 수 있다.
- 다중 GROUP BY
  - A와 B 기준의 합작으로 그룹이 만들어지는 경우이다.
  - A는 상위, B는 하위 그룹 기준
- WHERE
  - 집계 전 컬ㄻ에 대한 범위 조건
- HAVING
  - 그룹바이에 의한 집계 결과의 새로운 조건
- VIEW
  - 데이터를 단순히 보기만 할 목적으로 만든 것
- ROLLUP
  - 그룹바이가 특정 기준의 세부항목 집계라면, ROLLUP은 이보다 상위 개념 즉 테이블에 대한 전체 집계이다.
  - 종류에 대한 구분이 없다.
  - 김밥 마는 것처럼, 상위 개념에 대한 요약 통계 결과를 주는 것과 같다.
  - 그룹바이 기준이 2개라면, 그룹기준별 통계와 전체 그룹별 통계가 따로따로 모두 나온다.

# WINDOW FUNCTIONS
- 데이터 분석의 꽃 🌼
- Analystic SQL이라고도 한다.
- 여러 행에서 집계 연산을 수행한다 == Reduction 과정이 없다 == 데이터의 수가 줄어들지 않는다
- 그룹바이는 reduction이 일어나고, 데이터가 줄어든다.
- 반면 window function은 reduction이 일어나지 않고, 데이터가 그대로 유지된다.
- OVER()
  - 모든 행의, 라는 의미
  - OVER는 집계한 데이터를 추가할 범위를 의미한다.
  - OVER()를 붙이면 처음부터 끝까지 모든 집계를 출력한다.
  - PARTITION BY를 붙이면 그 기준대로 묶어서, 안 붙이면 전체 범위만큼 수행한다.
  - OVER 내부 함수는 옵션처럼 사용된다.
    - PARTITION BY, ORDER BY(윈도우 내에서 정렬 기능을 수행하며 누적집계연산도 가능) 등
- PARTITION BY
  - 그룹바이와 유사한 기능을 갖는다.
  - 다만 그룹바이와 달리, 데이터를 모아 합치지는 않고 기준별로 데이터를 모아 파티션 나누듯 분리만 해주는 역할을 수행한다.
  - 기준별 집계(ex 평균)값을 계산하여, 새로운 컬럼을 만든 후 기준이 같은 모든 로우에 동일한 집계값을 넣어준다.
  - 파티션에 의해 나누어진 같은 그룹끼리를 window라고 한다.
  - 그룹(합치는것)이 아니라, 윈도우라는 단위로 모아놓은 것이다.
- WINDOW 내에서만 사용할 수 있는 함수
  - RANK(): 동일값은 순위 중복, 중복 순번은 건너뜀
    - RANK OVER(PARTITION BY A ORDER BY B) => A별로 B의 순위를 매길 수 있다.
  - DENSE_RANK(): 동일값은 순위 중복, 중복 순번은 안 건너뜀
  - ROW_NUMBER(): 행번호


