---
name: termux-api
description: Взаимодействие с Android OS и аппаратными датчиками смартфона через Termux:API (батарея, уведомления, буфер обмена, вибрация, диалоги, сенсоры, TTS).
---

# Termux:API Integration Skill

Этот скилл содержит набор инструментов, утилит и регламентов для безопасного взаимодействия автономных ИИ-агентов (Antigravity CLI, OpenCode и др.) с операционной системой Android и аппаратными сенсорами через `Termux:API`.

## Требования и окружение

1. **CLI-пакет:** Установлен пакет `termux-api` (`pkg install -y termux-api`).
2. **Android Companion App:** Установлено приложение-компаньон `Termux:API` из F-Droid или GitHub Releases (версии Termux и Termux:API должны быть подписаны одним ключом).
3. **Разрешения Android:**
   - Доступ к уведомлениям;
   - Доступ к точной геолокации / камере / микрофону (если используются);
   - Отключение оптимизации батареи (Doze mode) для Termux и Termux:API.

## Доступные скрипты и утилиты

Все вспомогательные скрипты находятся в `scripts/`:

| Скрипт | Назначение | Вызов |
| :--- | :--- | :--- |
| `battery_check.sh` | Чтение уровня заряда, температуры и статуса батареи | `./scripts/battery_check.sh [--json]` |
| `notify.sh` | Отправка интерактивного системного Android Push-уведомления | `./scripts/notify.sh "Заголовок" "Текст" [id] [priority]` |
| `vibrate.sh` | Тактильный виброотклик (haptic feedback) | `./scripts/vibrate.sh [ms]` |
| `toast.sh` | Всплывающее системное уведомление на экране (Toast) | `./scripts/toast.sh "Сообщение"` |
| `clipboard.sh` | Безопасное чтение и запись системного буфера обмена Android | `./scripts/clipboard.sh [get\|set "текст"]` |
| `dialog.sh` | Интерактивные системные GUI-диалоги (подтверждение, ввод) | `./scripts/dialog.sh [confirm\|text] "Заголовок" "Подсказка"` |
| `sensor_read.sh` | Однократный опрос датчиков (освещенность, акселерометр) | `./scripts/sensor_read.sh [list\|sensor_name\|all]` |
| `tts_speak.sh` | Голосовое озвучивание статусов агента (Text-To-Speech) | `./scripts/tts_speak.sh "Текст"` |

## Правила безопасности и ограничения Android

1. **Android 14 (API 34) Storage SAF:**
   - Вызов `termux-storage-get` на Android 14 может молча возвращать 0 без вызова UI. Для чтения файлов используйте прямое обращение к `/sdcard/` или SAF-команды `termux-saf-*`.
2. **Фоновые тайм-ауты сенсоров:**
   - Не запускайте постоянный опрос сенсоров без указания лимита (`-n 1`). Неконтролируемый опрос датчиков приводит к быстрому разряду аккумулятора.
3. **Clipboard Sync:**
   - Для передачи кода пользователю используйте `termux-clipboard-set`, чтобы текст сразу попадал в буфер обмена Android без ручного выделения.
4. **Wakelock Management:**
   - Длительные фоновые расчеты должны удерживать `termux-wake-lock` и обязательно освобождать его (`termux-wake-unlock`) по завершении.

## Ссылки и экосистема

- **TecnicalBot/termux-mcp**: [https://github.com/TecnicalBot/termux-mcp](https://github.com/TecnicalBot/termux-mcp) — MCP-сервер для прямого подключения Termux:API к AI-агентам с политикой безопасности default-deny и аудитом.
- **ZH3KA11/Termux-Assistent-**: [https://github.com/ZH3KA11/Termux-Assistent-](https://github.com/ZH3KA11/Termux-Assistent-) — модульная 3-компонентная архитектура скиллов Termux (device, comms, system).
- **lobehub/android-shizuku-mcp**: [https://github.com/lobehub/android-shizuku-mcp](https://github.com/lobehub/android-shizuku-mcp) — расширенный мост Shizuku MCP для выполнения привилегированных системных операций Android без полного root.
- **wallentx/antigravity-cli-termux**: [https://github.com/wallentx/antigravity-cli-termux](https://github.com/wallentx/antigravity-cli-termux) — официальный апстрим ядра Antigravity CLI для Termux с поддержкой 39-bit VA и NDK Bionic бутстраппером.
- **Termux:API Upstream**: [https://github.com/termux/termux-api](https://github.com/termux/termux-api) — официальный репозиторий утилит Termux:API.
- **Документация Termux Wiki**: [https://wiki.termux.com/wiki/Termux:API](https://wiki.termux.com/wiki/Termux:API) — справочник всех команд API.
