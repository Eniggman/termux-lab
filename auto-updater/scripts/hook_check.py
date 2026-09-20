#!/data/data/com.termux/files/usr/bin/env python3
import json
import os
import sys
import time
from pathlib import Path

INTERVAL = 86400

DEFAULT_SKILL_DIR = Path.home() / ".agents/skills/auto-updater"
SKILL_DIR = Path(os.environ.get("AUTO_UPDATER_DIR", str(DEFAULT_SKILL_DIR)))
if not SKILL_DIR.exists():
    SKILL_DIR = Path(__file__).resolve().parent.parent

LAST_UPDATE_FILE = SKILL_DIR / "last_update.timestamp"
LAST_PROMPT_FILE = SKILL_DIR / "last_prompt.timestamp"

MIRROR_DIR = Path(os.environ.get("AUTO_UPDATER_MIRROR_DIR", "/sdcard/.EasyCode/skills/auto-updater"))
MIRROR_UPDATE_FILE = MIRROR_DIR / "last_update.timestamp"
MIRROR_PROMPT_FILE = MIRROR_DIR / "last_prompt.timestamp"

TRIGGER_MESSAGE = (
    "[Auto-Updater Trigger]: Прошло более 24 часов с момента обновления Termux. "
    "АВТОМАТИЧЕСКИЙ РЕЖИМ: Немедленно запусти субагента для выполнения скилла auto-updater в фоновом режиме. "
    "Кратко упомяни пользователю в ответе, что запущен фоновый автоапдейт. Не прерывай основной диалог. "
    "Когда субагент вернет результат, покажи пользователю сжатый отчёт. "
    "Если возникнут вопросы или конфликты версий — запроси решение у пользователя."
)


def read_timestamp(filepath: Path) -> int:
    try:
        if filepath.is_file():
            content = filepath.read_text(encoding="utf-8").strip()
            val = int(float(content))
            return val if val > 0 else 0
    except Exception:
        pass
    return 0


def get_latest_timestamp(primary: Path, mirror: Path) -> int:
    ts_primary = read_timestamp(primary)
    ts_mirror = read_timestamp(mirror)
    return max(ts_primary, ts_mirror)


def write_timestamp(filepath: Path, ts: int) -> None:
    try:
        filepath.parent.mkdir(parents=True, exist_ok=True)
        filepath.write_text(f"{ts}\n", encoding="utf-8")
    except Exception:
        pass


def record_prompt(ts: int) -> None:
    write_timestamp(LAST_PROMPT_FILE, ts)
    if MIRROR_DIR.exists():
        write_timestamp(MIRROR_PROMPT_FILE, ts)


def main():
    if hasattr(sys.stdout, "reconfigure"):
        try:
            sys.stdout.reconfigure(encoding="utf-8")
        except Exception:
            pass

    if "--status" in sys.argv:
        now = int(time.time())
        lu = get_latest_timestamp(LAST_UPDATE_FILE, MIRROR_UPDATE_FILE)
        lp = get_latest_timestamp(LAST_PROMPT_FILE, MIRROR_PROMPT_FILE)
        diff_u = now - lu if lu > 0 else None
        diff_p = now - lp if lp > 0 else None
        ready_u = (lu == 0) or (diff_u >= INTERVAL)
        ready_p = (lp == 0) or (diff_p >= INTERVAL)
        should_trigger = ready_u and ready_p
        print(f"Current time  : {now} ({time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(now))})")
        print(f"Last update   : {lu} (diff: {diff_u}s / {INTERVAL}s, ready: {ready_u})")
        print(f"Last prompt   : {lp} (diff: {diff_p}s / {INTERVAL}s, ready: {ready_p})")
        print(f"Should trigger: {should_trigger}")
        return

    force = "--force" in sys.argv
    dry_run = "--test" in sys.argv or "--dry-run" in sys.argv

    payload = {}
    if not sys.stdin.isatty():
        try:
            raw = sys.stdin.read()
            if raw.strip():
                parsed = json.loads(raw)
                if isinstance(parsed, dict):
                    payload = parsed
        except Exception:
            payload = {}

    inv_num = payload.get("invocationNum", payload.get("invocation_num"))
    # Only triggers on invocationNum == 1 (first invocation of session/turn)
    # Reject boolean True (since in Python True == 1) and non-1 values.
    if not force and (isinstance(inv_num, bool) or (inv_num != 1 and str(inv_num).strip() != "1")):
        print(json.dumps({}))
        return

    now = int(time.time())
    last_update = get_latest_timestamp(LAST_UPDATE_FILE, MIRROR_UPDATE_FILE)
    last_prompt = get_latest_timestamp(LAST_PROMPT_FILE, MIRROR_PROMPT_FILE)

    if force or ((now - last_update >= INTERVAL) and (now - last_prompt >= INTERVAL)):
        if not dry_run:
            record_prompt(now)

        output = {
            "injectSteps": [
                {
                    "ephemeralMessage": TRIGGER_MESSAGE
                }
            ]
        }
        print(json.dumps(output, ensure_ascii=False))
    else:
        print(json.dumps({}))


if __name__ == "__main__":
    main()
