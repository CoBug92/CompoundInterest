# Swift File Style Guide

Документ фиксирует базовый стиль Swift-файлов в проекте. Требования к `// MARK: -` секциям и их смысл описаны в `docs/project-guidelines.md`.

## File header

Файлы не должны начинаться с copyright/header-комментариев. Первая непустая строка должна быть `import`, декларацией типа, extension или другим кодом.

Не используем:

```swift
// Copyright ...
// Created by ...
```

## MARK Format

SwiftLint отвечает только за корректный синтаксис `MARK`-комментариев: используем формат `// MARK: - Section name`.

Список допустимых секций, их порядок и правила применения хранятся в `docs/project-guidelines.md`.
