# DROP vs DELETE
- DROP
  - 테이블 자체를 삭제하는 명령어이다.
  - 테이블의 모든 데이터와 스키마가 완전 삭제, 즉 DB에서 사라진다.
- DELETE
  - 테이블 내의 데이터를 삭제하는 명령어이다.
  - 테이블 스키마는 남겨두고 그 안의 모든 데이터를 삭제한다.


# ALTER vs INSERT INTO
- ALTER TABLE ADD COLUMN
  - 새로운 열을 기존 테이블에 추가한다.
  - 기존 테이블의 구조는 수정하는 경우에 간편하게 사용 가능하다.
- INSERT INTO
  - 새로운 데이터를 기존 테이블에 추가한다.
  - 기존 테이블의 구조를 수정하는 동시에 새로운 데이터를 입력해야 할 때 사용한다.
- DB 구조 변경이 필요할 경우에는 ALTER을 사용하고, 새로운 데이터를 입력하거나 기존 데이터에 추가적인 정보를 입력해야 할 경우에는 INSERT INTO를 사용한다.



# UNION vs JOIN
- UNION
  - 새로운 행으로 결합한다. (수직 결합)
- JOIN
  - 새로운 열로 결합한다. (수평 결합)



# VIEW vs WITH
- VIEW
  - 물리적으로 구현되지 않는 가상의 테이블이지만, DROP 할 때 까지 사라지지 않는다.
- WITH
  - WITH가 선언된 해당 쿼리의 세션이 종료되면 사라진다. (이후에 실행되지 않는다.)