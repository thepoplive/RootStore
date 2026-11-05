# AGENTS.md

Правила для агента в этом репо. Контекст проекта — README.md.

## Что это

RootStore — альтернативный пакетный менеджер/стор (как Cydia) для джейлбрейкнутых
legacy-устройств iOS. Цель: **iOS 8.4.1, ARMv7 (iPhone 4s)**, пакет
`com.blxckfvde.rootstore`, дистрибуция — `.deb` в `/Applications`.
Язык: Objective-C + UIKit, ARC. Русскоязычный UI.

## Сборка

- **Локально НЕ собирать** (Termux-clang не умеет Mach-O для iOS). Сборка =
  GitHub Actions (`.github/workflows/build.yml`): macos-runner, `make package`,
  артефакт `build/*.deb`.
- Локальная верификация — статическая:
  - `./scripts/build.sh check` (запрещённые iOS9+ API),
  - `bash -n scripts/build.sh`,
  - баланс `@interface`/`@implementation`/`@end` в каждом файле,
  - сверка `Version:` в `Packaging/DEBIAN/control` ↔ `CFBundleShortVersionString`.
- Скрипт `scripts/build.sh` — единственная точка сборки (БЕЗ Theos):
  clang (armv7, min 8.4.1) → линковка против legacy `iPhoneOS10.3.sdk`
  (в новых SDK нет armv7 .tbd) → `ldid -S` → `.app` → `dpkg-deb`.

## Язык и API — жёстко

- **Только iOS 8-совместимые API**: `UIAlertController` ок; НЕТ `UIStackView`,
  `NSLayoutAnchor`, `WKWebView`, `layoutGuides`, SF Symbols (`systemImageNamed`).
  CI компилирует с `-Wunguarded-availability` — modern API не пройдут молча.
- Никаких SwiftUI/Flutter/WebView-UI.
- Технологии: Foundation, CoreGraphics, QuartzCore, CoreAnimation, Auto Layout
  (iOS 8-вариант: `NSLayoutConstraint`/Visual Format), NSURLSession,
  NSJSONSerialization, SQLite (`-lsqlite3`).
- UI-код и бизнес-логика раздельно: Core/ не импортирует UIKit-экраны.

## Структура

- `App/` — main.m, AppDelegate. `Core/` — менеджеры (репозитории, пакеты,
  сеть, БД, кэш, модели) без привязки к UI. `UI/Components` — переиспользуемые
  RSGlass-компоненты, `UI/DesignSystem` — тема/цвета/типографика,
  `UI/Screens` — экраны. `Packaging/DEBIAN` — control/postinst/postrm.
- Новый `.m` подхватывается автоматически (build.sh сам находит исходники),
  но не забудь импорт в потребляющих файлах.
- `Resources/` (большая R) — Info.plist, иконки. Иконки генерируются:
  `python3 Tools/gen_icon.py`.

## Запись файлов

- Пиши файлы осознанно и проверяй хвосты (`tail`) после записи. Никакого
  «разогревочного» кода, цепочек `stringByAppendingString:`, фейковых
  идентификаторов — прошлый агент так корраптил исходники (см. ilaucher/HANDOFF.md).
- Не создавай пустые классы «для вида». Нереализованное — явный `TODO`
  с номером фазы, не выдавать за рабочее.

## Фазы

Спека — в исходном ТЗ. Phase 1 (фундамент+deb) — сделано; дальше: 2 (дизайн-
система RSGlass), 3 (экраны), 4 (репозитории/APT), 5 (пакетный менеджер),
6 (тесты на устройстве и релиз). Коммитить логическими инкрементами;
CI должен быть зелёным после каждой вехи.
