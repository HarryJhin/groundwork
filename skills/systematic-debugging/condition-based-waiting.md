# Condition-based waiting

불안정한 테스트는 임의의 지연으로 타이밍을 추측하는 일이 많다.
그러면 경쟁 조건이 생겨 빠른 기계에서는 통과하고 부하나 CI에서는 실패한다.

**핵심 원칙**: 얼마나 걸릴지 추측하지 말고 실제로 관심 있는 조건을 기다린다.

## Where it applies

**쓴다**:
- 테스트에 임의 지연이 있다(`setTimeout`, `sleep`, `time.sleep()`)
- 테스트가 불안정하다(가끔 통과하고 부하에서 실패한다)
- 병렬로 돌릴 때 테스트가 타임아웃한다
- 비동기 연산의 완료를 기다린다

**쓰지 않는다**:
- 실제 타이밍 동작을 검사한다(디바운스, 스로틀 간격)
- 임의 타임아웃을 쓸 때는 항상 **왜**인지 기록한다

## Base pattern

```typescript
// 전: 타이밍을 추측한다
await new Promise(r => setTimeout(r, 50));
const result = getResult();
expect(result).toBeDefined();

// 후: 조건을 기다린다
await waitFor(() => getResult() !== undefined);
const result = getResult();
expect(result).toBeDefined();
```

## Quick patterns

| 상황 | 패턴 |
|---|---|
| 이벤트 대기 | `waitFor(() => events.find(e => e.type === 'DONE'))` |
| 상태 대기 | `waitFor(() => machine.state === 'ready')` |
| 개수 대기 | `waitFor(() => items.length >= 5)` |
| 파일 대기 | `waitFor(() => fs.existsSync(path))` |
| 복합 조건 | `waitFor(() => obj.ready && obj.value > 10)` |

## Implementation

범용 폴링 함수다.

```typescript
async function waitFor<T>(
  condition: () => T | undefined | null | false,
  description: string,
  timeoutMs = 5000
): Promise<T> {
  const startTime = Date.now();

  while (true) {
    const result = condition();
    if (result) return result;

    if (Date.now() - startTime > timeoutMs) {
      throw new Error(`Timeout waiting for ${description} after ${timeoutMs}ms`);
    }

    await new Promise(r => setTimeout(r, 10)); // 10ms마다 폴링
  }
}
```

도메인 헬퍼(`waitForEvent`, `waitForEventCount`, `waitForEventMatch`)를 포함한 완전한 구현은 이 디렉터리의 `condition-based-waiting-example.ts`에 있다.

## Common mistakes

**너무 빠른 폴링**: `setTimeout(check, 1)`은 CPU를 낭비한다.
10ms마다 폴링한다.

**타임아웃 없음**: 조건이 끝내 만족되지 않으면 영원히 돈다.
항상 명확한 에러와 함께 타임아웃을 넣는다.

**낡은 데이터**: 루프 전에 상태를 캐시한다.
루프 안에서 게터를 호출해 신선한 데이터를 얻는다.

## When an arbitrary timeout is right

```typescript
// 도구가 100ms마다 틱한다. 부분 출력 검증에 2틱이 필요하다
await waitForEvent(manager, 'TOOL_STARTED'); // 먼저: 조건을 기다린다
await new Promise(r => setTimeout(r, 200));   // 그다음: 타이밍 동작을 기다린다
// 200ms = 100ms 간격 2틱. 기록됐고 정당하다
```

요건은 3가지다.
먼저 유발 조건을 기다린다.
추측이 아니라 이미 아는 타이밍에 근거한다.
왜인지 설명하는 주석을 단다.
