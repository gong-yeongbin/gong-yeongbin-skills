# create-issues baseline

> 프로젝트별로 매번 인터뷰하지 않을 항목을 정의하는 파일이다. 프로젝트의 `./.claude/skills/create-issues/baseline.md` 가 있으면 그것을 우선 읽고, 없으면 이 파일(스킬 폴더)을 읽는다.
>
> - 이 파일이 없거나 비어 있어도 스킬은 정상 동작한다 (인터뷰가 처음부터 묻는다).
> - 다른 프로젝트로 복제할 때는 이 파일만 갈아끼운다.
> - 여기 정의된 항목은 Stage 1·2 인터뷰에 올리지 않는다. 사용자가 바꾸고 싶다고 먼저 말할 때만 재논의한다.

---

## 핵심 원칙 (고정 문구) — 선택

> 있으면 이슈 본문에 `핵심 원칙 (고정)` 섹션으로 그대로 인용된다. 없으면 그 섹션 자체를 만들지 않는다.

---

## grill 제외 항목 — 선택

> 형식 `- {항목}: {결정값}`. 1줄 1항목.

---

## 이슈 라벨 default — 선택

> 비어 있으면 스킬 기본값을 쓴다. GitHub labels `enhancement`, Notion Status 는 DB 기본값, Notion Labels 구현 `feature` / TEST `TEST`.

- GitHub labels:
- Notion Status:
- Notion Labels (구현):
- Notion Labels (TEST):

---

## Notion 속성 매핑 — 선택 (notion 대상)

> 이슈 DB 의 속성명을 적는다. 비어 있으면 같은 이름의 속성이 DB 에 있을 때만 쓴다. DB 에 없는 속성은 무시한다. relation 두 줄이 비어 있거나 DB 에 없으면 구현↔TEST relation 단계를 건너뛴다.

- Title 속성명: Title
- Status 속성명: Status
- Labels 속성명: Labels
- 담당자 속성명:
- 선행 작업 relation 속성명:
- 후속 작업 relation 속성명:

---

## TEST 이슈 산출물 템플릿 — 선택

> TEST 이슈 `### 산출물` 의 기본 체크리스트. 비어 있으면 Stage 2 인터뷰 결정으로 채운다.

---

## 참조 문서 — 선택

> Stage 2 코드베이스 탐색에서 항상 읽을 프로젝트 문서 경로. 예 `CONTEXT.md`, `docs/adr/`.

---

## Java 프로젝트 기본 결정 — 조건부

> 저장소에 `build.gradle`·`build.gradle.kts`·`pom.xml` 이 있으면 아래 네 결정을 spec 에 **자동 포함** 한다. Implementation Decisions·Testing Decisions 에 `D<n>. … — 근거: baseline(Java 기본 결정)` 으로 적고, 이슈 체크리스트·TEST 산출물 항목이 그 `(D<n>)` 을 인용한다. 인터뷰에서 "할지 말지" 를 다시 묻지 않는다. 범위·깊이(어느 계층까지, 어떤 케이스)만 안건이다. 프로젝트 baseline 이 같은 항목을 더 구체적으로 정하면 그것이 우선한다.

- **TDD.** 테스트를 구현보다 먼저 쓴다(RED → GREEN). 테스트는 외부 행동(반환값·순서·예외·부수효과)만 검증한다. 결함은 실패하는 재현 테스트로 먼저 고정한다. → Testing Decisions 의 D. 구현 이슈 체크리스트에 "테스트 먼저(RED) → 구현(GREEN)" 단계가 `(D)` 로 들어간다.
- **쿼리.** DB 전용 함수·힌트와 네이티브 쿼리(`createNativeQuery`·`@Query(nativeQuery=true)`·`JdbcTemplate`)를 쓰지 않는다. JPQL/HQL/QueryDSL 만 쓴다. → Implementation Decisions 의 D. 구현 이슈 `### 핵심 결정 사항` 후보.
- **.http 테스트.** 로컬 프로파일(H2 등) `.http` 테스트를 작성하고 실제 실행한다. 시드는 시드 SQL 로 자체완결. → Testing Decisions 의 D. TEST 이슈 `### 산출물` 에 `.http` 케이스·시드 SQL·실행 결과가 `(D)` 로 들어간다.
- **품질 게이트.** 프로젝트 CLAUDE.md 가 정한 빌드·테스트·커버리지 명령 통과 (Stage 2 탐색 "품질 게이트" 영역에서 찾는다. 없으면 `./gradlew build` 또는 `mvn verify`). 코드 스타일 검사(spotless·checkstyle)는 빼지 않는다. → Testing Decisions "검증 게이트" 의 D. 구현 이슈 DoD 첫 항목이 이 `(D)` 를 인용한다.
