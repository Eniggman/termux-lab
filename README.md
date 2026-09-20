v1.0 [20.09.26]

<div align="center">

# 🧪 Termux Lab: Core Tooling & Integration Hub

### *Essential Automation, Hardware Sensor Bridges, and Safe Updaters for Android Termux*

[![Termux](https://img.shields.io/badge/Termux-Android-000000?style=for-the-badge&logo=termux&logoColor=white)](https://termux.dev/)
[![Bash](https://img.shields.io/badge/Bash-Automation-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Antigravity Termux Upstream](https://img.shields.io/badge/Upstream-wallentx%2Fantigravity--cli--termux-orange?style=for-the-badge&logo=github)](https://github.com/wallentx/antigravity-cli-termux)

<br/>

Центральный репозиторий инструментов, утилит и сервисных модулей лаборатории **[Enigman Termux Lab](https://github.com/Enigman-Termux-lab)**, расширяющий возможности автономных AI-агентов на Android.

---

</div>

## 📌 Содержимое репозитория

В репозитории собраны ключевые модули для стабильной, автономной работы CLI-агентов в Termux:

```text
termux-lab/
├── auto-updater/              # Модуль безопасного автоматического обновления
│   ├── SKILL.md               # Документация и регламент обновления
│   └── scripts/
│       ├── hook_check.py      # Автономный PreInvocation хук для Antigravity CLI
│       └── update_all.sh      # Скрипт проверки и обновления пакетов/менеджеров
├── termux-api/                # Аппаратный мост к Android OS и датчикам
│   ├── SKILL.md               # Руководство по интеграции с Termux:API
│   └── scripts/
│       ├── battery_check.sh   # Мониторинг заряда, здоровья и температуры
│       ├── notify.sh          # Системные интерактивные Push-уведомления
│       ├── vibrate.sh         # Тактильный виброотклик (haptic feedback)
│       ├── toast.sh           # Системные всплывающие Toast-сообщения
│       ├── clipboard.sh       # Синхронизация системного буфера обмена
│       ├── dialog.sh          # Нативные диалоговые GUI-окна
│       ├── sensor_read.sh     # Однократный опрос аппаратных датчиков
│       └── tts_speak.sh       # Синтез речи (Text-to-Speech)
├── LICENSE                    # Лицензия MIT
└── README.md                  # Полная документация
```

---

## ⚡ 1. Модуль Auto-Updater (`auto-updater/`)

Универсальный безопасный механизм проверки и обновления установленного ПО в среде Android Termux.

### Особенности:
- **Termux-First Architecture:** Учитывает специфику Android Bionic и не пытается накатывать стандартные Linux glibc пакеты вслепую.
- **Мульти-менеджеры:** Поддержка нативных пакетов `pkg`/`apt`, глобальных NPM-модулей, `pip` и `uv tools`.
- **Исключения безопасности:** Пакет `@anthropic-ai/claude-code` строго изолирован и исключен из автоапдейтов.
- **Интеграция с `termux-fix-path`:** Автоматическая проверка и нормализация shebang (`termux-fix-shebang`) для всех CLI-скриптов в `$(npm prefix -g)/bin`.
- **Автономный PreInvocation хук и кулдаун:** Ежедневный цикл (24ч) через PreInvocation хук Antigravity CLI (`scripts/hook_check.py`), безопасные флаги `--auto`/`--yes`/`-y` и кулдаун через `last_update.timestamp`.

### Использование:
```bash
# Ручной интерактивный запуск
bash auto-updater/scripts/update_all.sh

# Автоматический режим (для агентов и хуков)
bash auto-updater/scripts/update_all.sh --auto
```

---

## 📱 2. Модуль Termux:API (`termux-api/`)

Обеспечивает прямое взаимодействие агентов с аппаратной платформой смартфона.

### Требования:
1. Пакет в Termux:
   ```bash
   pkg install -y termux-api
   ```
2. Установленное приложение **Termux:API** (из F-Droid или GitHub Releases, подписанное тем же ключом, что и основной Termux).

### Возможности:
- **Контроль батареи:** Защита устройства от критического разряда при автономной работе (`./scripts/battery_check.sh`).
- **Уведомления и вибрация:** Оповещение пользователя о завершении генерации или ошибках через шторку Android (`./scripts/notify.sh`, `./scripts/vibrate.sh`).
- **Буфер обмена (Clipboard Sync):** Мгновенная передача кода в системный буфер Android (`./scripts/clipboard.sh set "текст"`).
- **Интерактивные диалоги:** Запрос подтверждения или ввода данных через нативные окна Android (`./scripts/dialog.sh`).
- **Датчики и TTS:** Опрос аппаратных сенсоров (`./scripts/sensor_read.sh`) и голосовой синтез (`./scripts/tts_speak.sh`).

### Связанные MCP-мосты и архитектурные решения:
- 🔌 **[TecnicalBot/termux-mcp](https://github.com/TecnicalBot/termux-mcp)** — Безопасный MCP-сервер для прямого подключения Termux:API к LLM-агентам с политикой default-deny и аудитом каждого вызова.
- 🧩 **[ZH3KA11/Termux-Assistent-](https://github.com/ZH3KA11/Termux-Assistent-)** — Модульная трёхкомпонентная архитектура скиллов для Termux (разделение на `device`, `comms`, `system`).
- ⚡ **[lobehub/android-shizuku-mcp](https://github.com/lobehub/android-shizuku-mcp)** — Shizuku MCP мост для выполнения привилегированных Android системных API без рут-доступа.
- 🚀 **[wallentx/antigravity-cli-termux](https://github.com/wallentx/antigravity-cli-termux)** — Главный апстрим автономного ядра Antigravity CLI для Termux с поддержкой 39-bit VA space.

---

## 🔗 3. Главный апстрим ядра Termux: `wallentx/antigravity-cli-termux`

Ключевым звеном всей экосистемы автономных ИИ-агентов в Termux является официальный порт **Antigravity CLI**:

👉 **[wallentx/antigravity-cli-termux](https://github.com/wallentx/antigravity-cli-termux)**

### Архитектура ядра:
1. **`agy` (NDK C Bootstrapper):**
   - Скомпилирован под нативный Android Bionic ELF;
   - Автоматически рассчитывает пути, сбрасывает конфликтующие переменные (`LD_PRELOAD`, `LD_LIBRARY_PATH`), конфигурирует CA-сертификаты и DNS (`GODEBUG=netdns=cgo`);
   - Обеспечивает прозрачный запуск движка с проверкой LSE (ARMv8.1-A atomics).
2. **`agy.va39` (Patched glibc Engine):**
   - Бинарник движка под Linux glibc, пропатченный под 39-битное виртуальное адресное пространство (VA39);
   - Устраняет критические краши Google TCMalloc (`MmapAligned() failed` / SIGSEGV) на ядрах Android с ограничением 39-bit VA space;
   - Корректирует системный вызов `faccessat2`.

### Установка / обновление апстрима:
```bash
curl -fsSL https://raw.githubusercontent.com/wallentx/antigravity-cli-termux/dev/install.sh | bash
```

---

## 🛡️ Правила безопасности и предохранители

1. **Shebang:** Всегда используйте нативный shebang `#!/data/data/com.termux/files/usr/bin/bash` или запускайте утилиту `termux-fix-shebang`. В Termux путь `/bin/bash` или `/usr/bin/bash` отсутствует.
2. **Bionic vs glibc:** Бинарники под glibc не запускаются напрямую без загрузчика `glibc-runner` и специальной адаптации.
3. **Согласование внешних действий:** Все изменения, влияющие на окружение (обновление пакетов, push в репозитории), требуют явного подтверждения.

---

## 👤 Автор и экосистема

- **Организация:** [Enigman Termux Lab](https://github.com/Enigman-Termux-lab)
- **Мейнтейнер:** [@Eniggman](https://github.com/Eniggman)
- **Лицензия:** [MIT](LICENSE)
