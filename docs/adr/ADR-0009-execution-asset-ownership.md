# ADR-0009: Move ownership of execution assets to the default path

## Title

스크립트와 리뷰어 프롬프트를 `subagent-driven-development`에서 `executing-spec`으로, 모델 티어 문서를 `using-groundwork`로 옮긴다.
스크래치 디렉터리를 `.groundwork/sdd/`에서 `.groundwork/run/`으로 개명한다.

## Status

Accepted

`docs/adr/ADR-0008-collapsing-the-plan-stage.md`의 후속이다.
그 문서가 실행 기본 경로를 뒤집은 결과로 드러난 소유 불일치를 정리한다.
ADR-0008의 결정을 뒤집지 않고 그 결정이 남긴 잔여를 처리한다.

## Date

2026-08-16

## Context

용어를 먼저 정한다.

- **실행 자산**: 스펙 실행 중에 쓰는 보조 파일. 셸 스크립트 둘과 서브에이전트에 주입하는 프롬프트 템플릿을 가리킨다.
- **스크래치 디렉터리**: 커밋하지 않는 단명 산출물을 모으는 작업 트리 안 디렉터리. 자기 자신을 무시하는 `.gitignore`를 지녀 `git status`에 나타나지 않는다.
- **기본 경로**: 스펙 실행에서 먼저 고르는 스킬. ADR-0008 이후 `groundwork:executing-spec`이다.
- **조건부 경로**: 특정 조건을 전부 만족할 때만 고르는 스킬. `groundwork:subagent-driven-development`다.

ADR-0008이 실행 기본 경로를 `subagent-driven-development`에서 `executing-spec`으로 뒤집었다.
그러나 실행 자산은 옮기지 않았다.
그 결과 세 문제가 남았다.

**첫째, 기본 경로가 조건부 경로에 의존한다.**
`skills/executing-spec/SKILL.md`가 스크립트 둘, 태스크 리뷰어 프롬프트, 재리뷰 프롬프트, 모델 티어 문서를 전부 `../subagent-driven-development/`로 건너가서 참조했다.
조건부 경로를 들어내면 기본 경로가 함께 무너진다.
의존 방향이 뒤집혀 있었다.

**둘째, 이름이 소유를 잘못 가리킨다.**
스크래치 디렉터리가 `.groundwork/sdd/`이고 스크립트 이름이 `sdd-workspace`였다.
`sdd`는 `subagent-driven-development`의 약자인데 주 사용자는 기본 경로다.
이름이 실제 사용과 어긋나면 읽는 사람이 조건부 경로 전용이라고 오독한다.

**셋째, 모델 티어 문서의 소유가 실행 경로에 묶여 있었다.**
`choosing-model-tier.md`를 참조하는 스킬은 여덟이고 그중 `finding-unknowns`와 `spec-review`는 설계 단계 스킬이다.
설계 단계가 실행 경로 디렉터리의 문서를 읽어야 티어를 정하는 구조였다.

**넷째, 진행 기록 파일의 근거가 상속된 것이었다.**
`subagent-driven-development`가 진행 기록을 두는 근거는 관측된 실패다.
자기 위치를 잃은 컨트롤러가 완료된 태스크 묶음을 통째로 다시 디스패치한 사례를 그 문서가 "관측된 가장 비싼 실패"로 적었다.
그런데 ADR-0008이 그 실패에 인라인 실행에서는 발생 조건이 없다고 명시했다.
`executing-spec`은 그 서사를 뺀 일반 진술("컨텍스트 압축을 견디지 못한다")만 남겼고, 그래도 왜 파일이 필요한지는 새로 적지 않았다.
근거 없이 장치만 남은 상태였다.

## Decision

**실행 자산을 기본 경로로 옮긴다.**
`skills/executing-spec/scripts/`에 스크립트 둘을 두고, 같은 디렉터리에 `task-reviewer-prompt.md`와 `re-review-prompt.md`를 둔다.
`subagent-driven-development`는 자기 전용인 `implementer-prompt.md`만 소유하고 나머지는 `../executing-spec/`으로 건너와서 쓴다.
의존 방향이 조건부에서 기본으로 흐른다.

**모델 티어 문서를 부트스트랩으로 옮긴다.**
`choosing-model-tier.md`를 `skills/using-groundwork/`에 둔다.
모델 티어는 설계·리뷰·실행 어느 단계에도 걸리는 교차 규범이라 특정 실행 경로가 소유하지 않는다.
부트스트랩은 이미 자기 정본 표에서 이 문서를 지목하고 있었으므로 소유와 선언이 일치하게 된다.

**이름을 사용에 맞춘다.**
스크래치 디렉터리를 `.groundwork/run/`으로, 스크립트를 `spec-workspace`로 개명한다.
어느 실행 경로를 쓰든 같은 이름이 성립한다.

**진행 기록의 근거를 다시 쓴다.**
`executing-spec`에서 진행 기록 파일이 필요한 이유는 **판정의 보존**이다.
어느 태스크까지 끝났는지는 todo와 `git log`가 담는다.
파일이 아니면 남지 않는 것은 보류한 Minor, 상한에서 내린 판정과 그 근거, 막힘 사유 셋이고, 이 셋은 최종 리뷰가 읽어야 하는데 커밋에도 todo에도 들어가지 않는다.
분해 결과도 커밋되는 문서로 남지 않으므로 같은 이유로 여기 적는다.
상속받은 컨트롤러 표류 서사는 쓰지 않는다.

## Consequences

Positive:
- 기본 경로가 자기 자산을 소유해 조건부 경로를 들어내도 무너지지 않는다.
- 디렉터리 이름과 스크립트 이름이 실제 사용과 일치해 조건부 경로 전용이라는 오독이 사라진다.
- 설계 단계 스킬이 실행 경로 디렉터리를 읽지 않는다.
- 진행 기록 파일이 자기 근거를 지닌다.
  ADR-0008이 비판한 "아키텍처가 만든 문제를 되메우는 장치"가 근거 없이 남는 상태가 해소된다.

Negative:
- **조건부 경로가 기본 경로 디렉터리를 건너와서 읽는다.**
  방향만 뒤집었을 뿐 교차 참조 자체는 남는다.
  `skills/` 아래에 공유 디렉터리를 두는 방법이 있으나 스킬 디렉터리가 곧 스킬이라 `SKILL.md` 없는 디렉터리가 어떻게 취급되는지 확인하지 않았고, 확인 없이 도입하면 플러그인 로딩이 깨질 수 있어 택하지 않았다.
- **경로 문자열이 문서 여러 곳에 흩어져 있다.**
  이번에도 스킬 둘, `CONTRIBUTING.md`, 스크립트 주석을 각각 고쳐야 했다.
  다음 개명에서 같은 일이 반복된다.
- **이미 만들어진 `.groundwork/sdd/`는 자동으로 옮겨지지 않는다.**
  옛 이름의 디렉터리가 남은 워킹 트리에서는 진행 기록을 찾지 못해 처음부터 다시 시작한다.
  스크래치라 데이터 손실은 아니지만 진행 중이던 작업은 재개 지점을 잃는다.
- **ADR-0008의 Compliance 항목 일부가 낡는다.**
  그 문서가 `skills/subagent-driven-development/scripts/`를 전제로 적은 검증 항목이 이 결정 뒤에는 다른 경로를 봐야 한다.
  ADR은 수락 후 불변이므로 고치지 않고 이 문서가 그 사실을 적는다.
- **이 개정도 groundwork flow를 거치지 않았다.**
  `CLAUDE.local.md`가 이 리포를 flow에서 면제한다.

## Compliance

- `skills/subagent-driven-development/`에 `SKILL.md`와 `implementer-prompt.md`만 있다.
- `skills/executing-spec/scripts/`에 `spec-workspace`와 `review-package`가 있고 둘 다 `bash -n`을 통과한다.
- `skills/using-groundwork/`에 `choosing-model-tier.md`가 있다.
- `skills/`와 리포 문서 어디에도 `sdd-workspace`·`.groundwork/sdd`·`subagent-driven-development/scripts` 문자열이 없다.
- 모든 마크다운 상대 링크가 실재 파일로 해소된다.
- `skills/executing-spec/SKILL.md`의 진행 기록 절이 판정 보존을 근거로 적는다.

## Notes

- Author: jjh
- Version: 0.1
- Changelog:
  - 0.1: 최초 작성
