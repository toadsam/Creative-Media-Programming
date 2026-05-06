# Creative-Media-Programming

Godot 기반 크리에이티브 미디어 프로그래밍 실습 저장소입니다. `beatascendia` 프로젝트를 중심으로 2D 액션/플랫폼 게임의 씬, 캐릭터, 적, 오브젝트 상호작용을 구현합니다.

## 프로젝트 개요

`Creative-Media-Programming`은 여러 실습 결과물을 Godot 프로젝트 안에 모아둔 저장소입니다. 플레이어, 적, 폭탄 적, 은신 적, 시간 반전, 이동 오브젝트, 레버, 사운드/UI 등 다양한 게임 메커니즘을 장면과 스크립트로 구성합니다.

## 주요 구현 영역

- Godot 씬(`.tscn`) 기반 레벨 구성
- GDScript 기반 플레이어 이동과 상호작용
- 일반 적, 폭탄 적, 은신 적 로직
- 레버와 이동 오브젝트 기믹
- 배경, 카메라, 데드존, 목적지 처리
- UI, 음악, 걷기/점프 사운드 구성

## 기술 스택

- Godot
- GDScript
- 2D 게임 씬 구성
- 픽셀 아트 에셋

## 폴더 구조

```text
.
├── README.md
└── beatascendia/
    ├── project.godot
    ├── Main.tscn
    ├── JJH/
    ├── KBW/
    ├── Parkjiheon/
    └── SoHyeongBeen/
```

## 실행 방법

1. Godot 에디터를 실행합니다.
2. `beatascendia/project.godot` 파일을 프로젝트로 엽니다.
3. `Main.tscn` 또는 실습별 씬을 열어 실행합니다.

## 학습 포인트

- Godot 씬과 스크립트를 연결하는 방법
- 플레이어, 적, 장애물 로직을 GDScript로 분리하는 방법
- 여러 팀원/파트별 작업물을 하나의 프로젝트에 통합하는 방법
- 2D 플랫폼 게임에서 레버, 이동 발판, 데드존 같은 기믹을 구성하는 방법

## 개선 아이디어

- Godot 버전 명시
- 메인 씬과 조작법 정리
- 팀원별 구현 기능 표 추가
- 플레이 영상 또는 스크린샷 추가
