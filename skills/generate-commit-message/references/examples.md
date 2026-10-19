# type 별 예시

결정된 type 의 섹션만 참고한다. BREAKING CHANGE 가 있으면 마지막 섹션도 함께 본다. 예시의 도메인은 가상이며 형식과 어조만 따른다.

## feat

```
feat: 주문 목록 API에 기간 필터 추가

- 요청 파라미터에 createdFrom, createdTo 추가
- Repository 조회 조건과 OpenAPI 명세에 기간 조건 반영
- 운영자가 특정 기간의 주문만 빠르게 조회할 수 있도록 검색 편의성 개선

Refs: #1234
```

```
feat: 예약 목록 화면에 기간 필터 추가

- 목록 상단에 시작일·종료일 선택 UI 추가
- 선택한 기간을 예약 조회 API query parameter 로 전달
- 원하는 기간의 예약만 확인할 수 있도록 검색 흐름 개선
```

## fix

```
fix: 회원 탈퇴 시 활성 세션이 남는 문제 수정

- 탈퇴 처리 후 Redis 세션 삭제 호출 추가
- 탈퇴한 계정으로 기존 토큰 요청이 통과하던 보안 결함 차단
- 세션 삭제 실패 시 탈퇴 트랜잭션을 롤백하도록 순서 조정
```

## refactor

```
refactor: 결제 승인 로직을 PaymentService 로 분리

- Controller 에 있던 승인·취소 분기와 검증을 Service 로 이동
- 승인 결과 매핑을 전용 Mapper 로 추출
- 결제 수단 추가 시 Controller 수정 없이 확장할 수 있도록 책임 정리
```

## chore

```
chore: 사용하지 않는 로컬 프로파일 설정 제거

- application-local-old.yml 과 관련 README 항목 삭제
- 신규 입사자가 어떤 프로파일을 써야 하는지 혼동하던 문제 해소
```

## test

```
test: 쿠폰 할인 계산 경계값 테스트 추가

- 최소 주문 금액과 동일한 금액, 1원 미달 케이스 추가
- 중복 쿠폰 적용 시 예외 발생 검증 추가
- 할인 계산 회귀를 CI 에서 바로 잡을 수 있도록 보강
```

## docs

```
docs: 로컬 개발 환경 설정 절차 최신화

- Docker Compose 로 DB 를 띄우는 절차로 README 교체
- 더 이상 쓰지 않는 수동 설치 안내 삭제
- 신규 합류자가 첫날 환경을 올릴 수 있도록 누락 단계 보완
```

## perf

```
perf: 상품 목록 조회의 N+1 쿼리 제거

- 카테고리·브랜드를 fetch join 으로 한 번에 조회
- 목록 100건 기준 쿼리 수 201회에서 1회로 감소
- 피크 시간대 상품 목록 응답 지연 완화가 목적
```

## build

```
build: Spring Boot 3.3 으로 업그레이드

- spring-boot-starter-parent 버전 상향
- 제거된 WebSecurityConfigurerAdapter 사용처를 SecurityFilterChain 으로 교체
- 보안 패치 지원이 끝나는 구버전 의존을 해소
```

## style

```
style: Spotless 포매팅 일괄 적용

- import 순서와 들여쓰기를 프로젝트 규칙에 맞게 정렬
- 기능 변경 커밋의 diff 에 포매팅 노이즈가 섞이지 않도록 선반영
```

## BREAKING CHANGE

type 은 일반 type(주로 `feat`, 필요하면 `fix`·`refactor`)을 그대로 쓰고, 본문 뒤에 `BREAKING CHANGE:` 줄을 둔다. `Refs` 가 있으면 그 다음 줄이다.

```
feat: 인증 헤더를 Authorization Bearer 방식으로 변경

- AuthFilter, OpenAPI 명세, 샘플 코드의 헤더 이름 일괄 교체
- RFC 6750 준수와 외부 SDK 호환성 확보가 목적

BREAKING CHANGE: 모든 클라이언트는 X-Auth-Token 대신 Authorization: Bearer <token> 헤더를 보내야 함
Refs: #5108
```
