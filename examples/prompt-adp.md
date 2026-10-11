# Как запускать ADP

1. `/andreev-sy-cursor-tools-adp`
2. Агент пришлёт **code block** с полями (каждое с новой строки) — отредактируй и отправь.
3. Дальше Acceptance → работа (или уточнения, если Need размыт).

## Как должен выглядеть блок

```text
Need:
Anchor: найди в репо
Prove: project.md
Нельзя: новый framework, one-off скрипт, rewrite подсистемы, обход слоя якоря
```

## Пример заполненного ответа

```text
Need: экспорт пользователей в CSV как у инвойсов
Anchor: InvoiceExport / export-модуль
Prove: project.md
Нельзя: новый framework, one-off скрипт, обход слоя якоря
```
