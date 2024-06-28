# Create: 행 인서트하기
## syntax
```sql
INSERT INTO product (상품 번호, 카테고리, 색상, 성별, 사이즈, 원가)
VALUES ('a003', '트레이닝', 'purple', 'f', 'xs', 80,000),
       ('a004', '라이프스타일', 'white', 'm', 'm', 60,000);
```


# Update: 데이터 갱신하기
## syntax
```sql
UPDATE product
SET 원가 = 70,000,
    카테고리 = '피트니스'
WHERE 상품 번호 = 'a002';
```

## Procedure
- 매크로처럼 반복되는 내용을 하나의 단위(procedure)로 생성할 수 있다.
- 반복하고자 하는 쿼리
    ```sql
    UPDATE product
    SET 원가 = (-1)*원가
    WHERE 취소 여부 = 'Y'
    AND 판매 일자 = CURDATE()-1;
    ```
- 해당 쿼리를 매일 특정 시점에 반복하게 하는 프로시저를 `sales_minus()`라는 프로시저 명으로 실행할 수 있다.
    ```SQL
    DELIMITER //
    CREATE PROCEDURE sales_minus()
    BEGIN
    UPDATE product
    SET 원가 = (-1)*원가
    WHERE 취소 여부 = 'Y'
    AND 판매 일자 = CURDATE()-1;
    END //
    DELIMITER;
    ```


# Read: 특정 조건으로 조회하기
- View를 이용하여, 실제 데이터를 담은 테이블을 생성하지 않고도 SELECT 문의 출력 결과를 보여줄 수 있다.
- 테이블을 생성하여 조회하는 방법
    ```sql
    SELECT 주문 번호
    FROM DB.SALES
    WHERE 취소 여부 'Y';
    ```
- View를 이용한 가상의 테이블을 조회하는 방법
    ```sql
    CREATE VIEW DB.cancel_prodno
    AS
    SELECT 주문 번호
    FROM DB.SALES
    WHERE 취소 여부 = 'Y';
    ```

# Delete: 행 삭제하기
## syntax
```sql
DELETE FROM PRODUCT
WHERE 상품 번호 = 'a003';
```


# 데이터 정합성
- 데이터들의 값이 일치함을 의미한다.
  - 매출을 계산할 때, 분기별 매출의 합이 전체 매출과 일치해야 함과 같다. (즉, 부분의 합은 전체와 일치해야 한다.)
  - 데이터의 신뢰성과 연결되는 부분이다.
- MECE하게 분석한다는 의미는, 서로 중복없이 누락된 것 없이 분석한다는 뜻이다.
  - MECE = Mutually Exclusive Collectively Exhaustive
  - 각 항목들이 상호 배타적이면서, 모였을 때 완전히 합쳐지는 것을 의미한다.
- 서비스 매출을 고객 세그먼트로 나눠 분석한다면, 각 세그먼트 간의 교집합이 발생하지 않도록 구분해 분석하는 것이 좋다.