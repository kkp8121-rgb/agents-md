# agents-md — 개인용 전역 에이전트 규칙

Claude Code·Codex CLI·Grok Build를 **동시에 사용하는 PC에 전역 적용**하는 단일 규칙 파일.
클린 PC에 클론 → 스크립트 1회 실행이면 세 에이전트 모두에 같은 규율이 적용된다.

## 구조

```
~/.codex/AGENTS.md          ← 실파일 (단일 원본, Codex가 네이티브로 읽음)
~/.claude/CLAUDE.md         ← "@~/.codex/AGENTS.md" 참조 한 줄 (Claude Code)
~/.grok/rules/AGENTS.md     ← 복사본 (Grok Build 전역 규칙 — 모든 프로젝트 상시 로드)
```

Codex는 import 문법이 없으므로 실파일을 Codex 쪽에 두고, import를 지원하는 Claude가 참조한다.
Grok Build는 `~/.grok/rules/*.md`를 전역 규칙으로 상시 로드하므로 복사본을 둔다(갱신은 install 재실행으로 동기화).
심링크 불필요(관리자 권한 불필요).

> Grok Build는 Claude 호환 모드(기본 ON)로 `~/.claude/CLAUDE.md`도 함께 스캔하지만, 그 파일은 참조 한 줄뿐이라 실질 중복은 없다. 중복 로드를 원천 차단하려면 Grok 설정에서 `compat.claude`를 끄면 된다.

## 설치 (클린 PC)

```powershell
# Windows
git clone https://github.com/kkp8121-rgb/agents-md
cd agents-md
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

```bash
# macOS / Linux
git clone https://github.com/kkp8121-rgb/agents-md
cd agents-md
sh install.sh
```

기존 `~/.codex/AGENTS.md`는 타임스탬프 백업 후 교체, 기존 `~/.claude/CLAUDE.md`는 내용 보존 + 첫 줄에 참조만 추가된다.

## 갱신

이 레포에서 `AGENTS.md` 수정 → 커밋 → 각 PC에서 `git pull && install.ps1(.sh)` 재실행.

## 운용 규칙

- **전역 파일 = 행동 규율만.** 스택·빌드 명령·금지 구역 등 리포별 사실은 각 리포의 `AGENTS.md`에 쓴다 (양쪽 에이전트 모두 전역+리포를 병합 로드).
- **Learnings 섹션은 살아있는 섹션.** 에이전트가 정정받으면 한 줄 규칙으로 축적하고, 몇 주마다 가지치기한다. 150줄 이내 유지 — 비대해진 규칙 파일은 통째로 무시된다.
- 측정은 `npx ccusage` (Claude·Codex 통합 집계).

## 원본 대비 커스터마이즈 내역

| 변경 | 이유 |
|---|---|
| 섹션 10(프로젝트 TODO 템플릿 35줄) 제거 | 전역 배치 시 죽은 무게 — 리포별 AGENTS.md로 이관 |
| "Token and context discipline" 섹션 신설 | 재Read 금지·추론 깊게 출력 간결히 (token-efficient 발췌) + 서브에이전트 위임 |
| 완료 주장 시 fresh 검증 증거 의무화 | 증거 없는 완료 선언 금지 원칙 |
| 사용자 대면 텍스트 존댓말 한국어 | 개인 선호 (코드·커밋은 리포 관례) |
| Co-Authored-By 금지 조항 → 리포 관례 따름 | 일부 프로젝트는 attribution 필수라 충돌 |
| git push 매번 승인 명시 | push=배포 트리거 브랜치 사고 예방 |

## 출처·라이선스

MIT. 다음 두 MIT 프로젝트의 파생·병합본:

- [FerroxLabs/agents-md](https://github.com/FerroxLabs/agents-md) (Sean Donahoe) — Karpathy 4원칙 + Boris Cherny 워크플로 기반 AGENTS.md
- [drona23/claude-token-efficient](https://github.com/drona23/claude-token-efficient) — 출력 간결화 규칙
