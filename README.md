# Cursor Agent Kit — ADP

Методология **Acceptance → Anchor → Delta → Prove**: полный дифф в пути проекта, не демо и не «зелёный lint при недоделке».  
После установки: `.cursor/kits/andreev-sy/cursor-tools/ADP.md`.

Репозиторий: https://github.com/andreev-sy/cursor-tools

## Установка (из корня вашего проекта)

**Linux / macOS / Git Bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/andreev-sy/cursor-tools/master/install-remote.sh | bash
# или:
wget -qO- https://raw.githubusercontent.com/andreev-sy/cursor-tools/master/install-remote.sh | bash
```

**Windows (PowerShell):**

```powershell
Invoke-WebRequest "https://raw.githubusercontent.com/andreev-sy/cursor-tools/master/install-remote.ps1" -OutFile "$env:TEMP\cursor-tools-install.ps1"
& "$env:TEMP\cursor-tools-install.ps1"
```

Переустанавливает namespace `andreev-sy/cursor-tools` (полная перезапись этих папок).

## Куда кладутся файлы

```text
your-project/
  .cursor/
    kits/andreev-sy/cursor-tools/     ← ADP.md, examples, templates, skills
    skills/
      andreev-sy-cursor-tools-adp/
      andreev-sy-cursor-tools-project-bootstrap/
  AGENTS.md   ← ссылка на project.md (создаётся или дополняется, не затирается)
```

Skills в Cursor без `/` в имени папки → `andreev-sy-cursor-tools-*`.  
Файлы kit — по полному пути репо: `andreev-sy/cursor-tools`.

## Как пользоваться

1. `/andreev-sy-cursor-tools-project-bootstrap` — пишет `.cursor/kits/andreev-sy/cursor-tools/project.md` и ссылку в `AGENTS.md`.  
2. `/andreev-sy-cursor-tools-adp` — пришлёт короткий блок полей (Need/Anchor/Prove/Нельзя); заполни и ответь. См. `examples/prompt-adp.md`.
