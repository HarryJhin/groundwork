# Defense in depth

잘못된 데이터가 일으킨 버그를 고칠 때 한 곳에 검증을 넣으면 충분해 보인다.
그러나 그 단일 검사는 다른 코드 경로·리팩터링·목이 우회한다.

**핵심 원칙**: 데이터가 지나는 **모든** 층에서 검증한다.
그 버그를 구조적으로 불가능하게 만든다.

## Why there are several layers

검증이 하나면 "버그를 고쳤다"이고 여러 층이면 "버그를 불가능하게 만들었다"이다.

층마다 다른 경우를 잡는다.
진입 검증은 대부분의 버그를 잡는다.
비즈니스 로직은 엣지케이스를 잡는다.
환경 가드는 맥락 고유의 위험을 막는다.
디버그 로깅은 다른 층이 실패했을 때 돕는다.

## The four layers

층마다 막는 것과 막지 못하는 것이 다르다.

### Entry point validation

**목적**: API 경계에서 명백히 잘못된 입력을 거부한다

```typescript
function createProject(name: string, workingDirectory: string) {
  if (!workingDirectory || workingDirectory.trim() === '') {
    throw new Error('workingDirectory cannot be empty');
  }
  if (!existsSync(workingDirectory)) {
    throw new Error(`workingDirectory does not exist: ${workingDirectory}`);
  }
  if (!statSync(workingDirectory).isDirectory()) {
    throw new Error(`workingDirectory is not a directory: ${workingDirectory}`);
  }
  // ... 진행
}
```

### Business logic validation

**목적**: 데이터가 이 연산에 말이 되는지 확인한다

```typescript
function initializeWorkspace(projectDir: string, sessionId: string) {
  if (!projectDir) {
    throw new Error('projectDir required for workspace initialization');
  }
  // ... 진행
}
```

### Environment guard

**목적**: 특정 맥락에서 위험한 연산을 막는다

```typescript
async function gitInit(directory: string) {
  // 테스트에서는 임시 디렉터리 밖 git init을 거부한다
  if (process.env.NODE_ENV === 'test') {
    const normalized = normalize(resolve(directory));
    const tmpDir = normalize(resolve(tmpdir()));

    if (!normalized.startsWith(tmpDir)) {
      throw new Error(
        `Refusing git init outside temp dir during tests: ${directory}`
      );
    }
  }
  // ... 진행
}
```

### Debug instrumentation

**목적**: 사후 분석을 위한 맥락을 남긴다

```typescript
async function gitInit(directory: string) {
  const stack = new Error().stack;
  logger.debug('About to git init', {
    directory,
    cwd: process.cwd(),
    stack,
  });
  // ... 진행
}
```

## Applying the pattern

버그를 찾으면 이렇게 한다.

1. **데이터 흐름을 추적한다**: 나쁜 값이 어디서 비롯되고 어디서 쓰이는가
2. **모든 검문소를 지도로 만든다**: 데이터가 지나는 모든 지점을 나열한다
3. **층마다 검증을 넣는다**: 진입, 비즈니스, 환경, 디버그
4. **층마다 테스트한다**: 진입점 검증을 우회해 보고 비즈니스 로직 검증이 잡는지 확인한다

## Cases

버그: 빈 `projectDir`가 소스 코드에서 `git init`을 일으켰다

**데이터 흐름**
1. 테스트 셋업 → 빈 문자열
2. `Project.create(name, '')`
3. `WorkspaceManager.createWorkspace('')`
4. `git init`이 `process.cwd()`에서 돈다

**추가한 4개 층**
- 진입점 검증: `Project.create()`가 비어 있지 않음·존재·쓰기 가능을 검증
- 비즈니스 로직 검증: `WorkspaceManager`가 projectDir가 비어 있지 않음을 검증
- 환경 가드: `WorktreeManager`가 테스트 중 tmpdir 밖 git init을 거부
- 디버그 계측: git init 전에 스택 트레이스 로깅

**결과**: 전 테스트 통과, 버그 재현 불가

## Core insight

4개 층이 모두 필요했다.
테스트 중에 각 층이 다른 층이 놓친 버그를 잡았다.
다른 코드 경로가 진입 검증을 우회했고 목이 비즈니스 로직 검사를 우회했고 플랫폼별 엣지케이스에 환경 가드가 필요했고 디버그 로깅이 구조적 오용을 식별했다.

**검증 지점 하나에서 멈추지 않는다.**
모든 층에 검사를 넣는다.
