# 근본 원인 역추적

## 개요

버그는 콜스택 깊은 곳에서 드러나는 일이 많다(잘못된 디렉터리에서 git init, 엉뚱한 위치에 파일 생성, 잘못된 경로로 DB 열기). 본능은 에러가 나타난 곳을 고치는 것이지만 그것은 증상 치료다.

**핵심 원칙**: 원 유발점을 찾을 때까지 호출 사슬을 거슬러 올라간 뒤 출처에서 고친다.

## 적용 대상

- 에러가 실행 깊은 곳에서 일어난다(진입점이 아니다)
- 스택 트레이스가 긴 호출 사슬을 보인다
- 잘못된 데이터가 어디서 비롯됐는지 불명확하다
- 어느 테스트·코드가 문제를 유발하는지 찾아야 한다

거슬러 올라갈 수 없는 막다른 지점이면 증상 지점에서 고치되 그 사실을 기록한다.

## 추적 절차

### 1. 증상을 관찰한다
```
Error: git init failed in ~/project/packages/core
```

### 2. 직접 원인을 찾는다
**어떤 코드가 이것을 직접 일으키는가**
```typescript
await execFileAsync('git', ['init'], { cwd: projectDir });
```

### 3. 묻는다. 무엇이 이것을 호출했나
```typescript
WorktreeManager.createSessionWorktree(projectDir, sessionId)
  → Session.initializeWorkspace()가 호출
  → Session.create()가 호출
  → Project.create()의 테스트가 호출
```

### 4. 계속 거슬러 올라간다
**어떤 값이 넘어왔나**
- `projectDir = ''`(빈 문자열)
- 빈 문자열이 `cwd`로 들어가면 `process.cwd()`로 해소된다
- 그것이 소스 코드 디렉터리다

### 5. 원 유발점을 찾는다
**빈 문자열은 어디서 왔나**
```typescript
const context = setupCoreTest(); // { tempDir: '' }를 반환
Project.create('name', context.tempDir); // beforeEach 전에 접근했다
```

## 스택 트레이스 추가

수동으로 추적할 수 없으면 계측을 넣는다.

```typescript
// 문제가 되는 연산 앞에
async function gitInit(directory: string) {
  const stack = new Error().stack;
  console.error('DEBUG git init:', {
    directory,
    cwd: process.cwd(),
    nodeEnv: process.env.NODE_ENV,
    stack,
  });

  await execFileAsync('git', ['init'], { cwd: directory });
}
```

**중요**: 테스트에서는 `console.error()`를 쓴다. 로거는 억제될 수 있다.

**돌리고 잡는다**
```bash
npm test 2>&1 | grep 'DEBUG git init'
```

**스택 트레이스를 분석한다**: 테스트 파일 이름을 찾고 호출을 유발한 줄 번호를 찾고 패턴을 식별한다(같은 테스트인가, 같은 파라미터인가).

## 어느 테스트가 오염시키는지 찾기

테스트 중에 무언가가 나타나는데 어느 테스트인지 모르면 이 디렉터리의 이분 탐색 스크립트를 쓴다.

```bash
./find-polluter.sh '.git' 'src/**/*.test.ts'
```

테스트를 하나씩 돌리고 첫 오염원에서 멈춘다. 사용법은 스크립트를 본다.

## 실제 사례: 빈 projectDir

**증상**: `.git`이 `packages/core/`(소스 코드)에 생성됐다

**추적 사슬**
1. `git init`이 `process.cwd()`에서 돈다(빈 cwd 파라미터)
2. WorktreeManager가 빈 projectDir로 호출됐다
3. `Session.create()`가 빈 문자열을 넘겼다
4. 테스트가 beforeEach 전에 `context.tempDir`에 접근했다
5. `setupCoreTest()`가 처음에 `{ tempDir: '' }`를 반환한다

**근본 원인**: 최상위 변수 초기화가 빈 값에 접근했다

**수정**: tempDir를 beforeEach 전에 접근하면 예외를 던지는 게터로 만들었다

**다층 방어도 추가했다**
- 층 1: `Project.create()`가 디렉터리를 검증
- 층 2: `WorkspaceManager`가 비어 있지 않음을 검증
- 층 3: NODE_ENV 가드가 tmpdir 밖 git init을 거부
- 층 4: git init 전에 스택 트레이스 로깅

## 핵심 원리

직접 원인을 찾았으면 한 단계 위로 올라갈 수 있는지 본다. 올라갈 수 있으면 거슬러 올라가고 거기가 출처인지 묻는다. 출처가 아니면 계속 올라간다. 출처면 거기서 고치고 각 층에 검증을 더한다. 그러면 버그가 불가능해진다.

**에러가 나타난 곳만 고치지 않는다.** 원 유발점까지 거슬러 올라간다.

## 스택 트레이스 요령

- **테스트에서**: 로거가 아니라 `console.error()`를 쓴다. 로거는 억제될 수 있다
- **연산 앞에서**: 실패한 뒤가 아니라 위험한 연산 전에 로깅한다
- **맥락을 담는다**: 디렉터리, cwd, 환경 변수, 타임스탬프
- **스택을 잡는다**: `new Error().stack`이 완전한 호출 사슬을 보인다

## 연계

출처를 찾은 뒤에는 [defense-in-depth.md](defense-in-depth.md)로 각 층에 검증을 더한다.
