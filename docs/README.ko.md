# Ulanzi Studio 플러그인 개발 - AI 컨텍스트

**한국어** | [English](../README.md) | [中文](README.zh.md) | [日本語](README.ja.md)

Ulanzi Studio 플러그인(D200H / D200 / D200X 스트림 컨트롤러)을 빌드하기 위한 AI 컨텍스트 파일입니다.

## 이게 뭔가요?

`SKILL.md`는 Ulanzi Studio 플러그인 개발에 필요한 모든 지식을 담은 레퍼런스 파일입니다:

- **AI 컨텍스트** - 어떤 AI 코딩 도구에든 로드하면 플러그인 생성 가능
- **개발자 가이드** - 사람이 직접 읽고 플러그인을 만들 때도 사용 가능

AI 어시스턴트에 로드하면, 한 줄 프롬프트만으로 설치 가능한 완전한 Ulanzi 플러그인을 생성할 수 있습니다.

## AI 도구별 설치 방법

### Claude Code

```bash
mkdir -p ~/.claude/skills
cp SKILL.md ~/.claude/skills/ulanzi-studio.md
```

### Cursor

```bash
cp .cursorrules /path/to/your/project/.cursorrules
```

또는 Cursor 설정 > Rules > User Rules에 내용을 붙여넣기.

### GitHub Copilot

```bash
mkdir -p /path/to/your/project/.github
cp .github/copilot-instructions.md /path/to/your/project/.github/copilot-instructions.md
```

### Windsurf

```bash
cp .windsurfrules /path/to/your/project/.windsurfrules
```

### Cline

```bash
cp .clinerules /path/to/your/project/.clinerules
```

### 기타 AI 도구

`SKILL.md`의 내용을 AI 어시스턴트의 시스템 프롬프트나 컨텍스트 윈도우에 붙여넣으세요.

## 포함 내용

- 플러그인 디렉터리 구조 및 `manifest.json` 스키마
- SDK API 전체 레퍼런스 (`$UD` 객체 - 모든 메서드와 이벤트)
- 플러그인 메인 서비스 패턴 (액션 생명주기 관리)
- 액션 클래스 패턴 (Canvas 렌더링, 아이콘 업데이트)
- Property Inspector 패턴 (설정 UI + 폼 동기화)
- CORS 제약 조건 (WebView에서 동작하는 API / 차단되는 API)
- 폰트 로딩 픽스 (Canvas 드로잉 전 비동기 폰트 대기)
- 다국어, 디버깅, 디바이스 스펙

## 사용 예시

설치 후 AI 어시스턴트에게:

> "Ulanzi D200H에 현재 시간을 표시하는 플러그인 만들어줘"

> "D200H LCD 키에 CPU 사용률을 보여주는 앱 만들어줘"

> "카운트다운 타이머 Ulanzi 플러그인 만들어줘"

## 기반 프로젝트

- [UlanziDeckPlugin-SDK](https://github.com/UlanziTechnology/UlanziDeckPlugin-SDK) (공식 SDK)
- [Ulanzi Studio](https://www.ulanzi.com/pages/downloads)

## 라이선스

MIT
