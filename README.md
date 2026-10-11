# Cursor Agent Kit — ADP

Методология **Anchor → Delta → Prove**: рабочий дифф в проекте, не демо-урок.  
Документ: после установки — `.cursor/kits/cursor-tools/ADP.md` (в этом репо исходник [ADP.md](ADP.md)).

Репозиторий: https://github.com/andreev-sy/cursor-tools

## Установка из GitHub (в корень вашего проекта)

**Linux / macOS / Git Bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/andreev-sy/cursor-tools/main/install-remote.sh | bash
# или:
wget -qO- https://raw.githubusercontent.com/andreev-sy/cursor-tools/main/install-remote.sh | bash
# принудительно обновить:
curl -fsSL https://raw.githubusercontent.com/andreev-sy/cursor-tools/main/install-remote.sh | bash -s -- --force
```

**Windows (PowerShell):**

```powershell
Invoke-WebRequest "https://raw.githubusercontent.com/andreev-sy/cursor-tools/main/install-remote.ps1" -OutFile "$env:TEMP\adp-install-remote.ps1"
& "$env:TEMP\adp-install-remote.ps1" -Repo "andreev-sy/cursor-tools"
# обновить с перезаписью:
& "$env:TEMP\adp-install-remote.ps1" -Repo "andreev-sy/cursor-tools" -Force
```

Namespace по умолчанию: **`cursor-tools`** (имя репозитория).  
Переопределение: `KIT_NAME=my-kit` / `-Name my-kit`.

## Куда кладутся файлы (не смешиваются с проектом)

```text
your-project/
  .cursor/
    kits/
      cursor-tools/           ← всё содержимое kit
        ADP.md
        examples/
        templates/
        skills/
        ...
    skills/
      cursor-tools-adp/                 ← /cursor-tools-adp
      cursor-tools-project-bootstrap/   ← /cursor-tools-project-bootstrap
  AGENTS.md   ← только если вы сами прогоните bootstrap (это уже ваш файл проекта)
```

В корне проекта kit **не** создаёт `ADP.md` и прочие файлы методологии.

## Локальная установка (без сети)

```powershell
.\install.ps1 -Target "C:\path\to\project" -Force
.\install.ps1 -User -Force
```

```bash
./install.sh /path/to/project --force
./install.sh --user --force
./install.sh --name cursor-tools --force
```

## Кнут и сценарий

1. `/cursor-tools-project-bootstrap` — один раз, короткий корневой `AGENTS.md`.  
2. `/cursor-tools-adp` — задачи по ADP (якорь → дельта → оракул → код → стоп).  
3. Пример промпта: `.cursor/kits/cursor-tools/examples/prompt-adp.md`.

## Состав репозитория

```
ADP.md
kit.conf
install.sh / install.ps1
install-remote.sh / install-remote.ps1
skills/adp/
skills/project-bootstrap/
templates/
examples/
README.md
```
