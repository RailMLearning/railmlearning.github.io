# Моё портфолио

Статический сайт-портфолио на MkDocs с двумя независимыми сценариями CI/CD:
публикация на **GitHub Pages** и на **SourceCraft Sites** из одного локального репозитория.

## Структура

- `source/docs/` — исходники сайта (Markdown, ассеты).
- `mkdocs.yml` — конфигурация MkDocs (тема `dracula`, `docs_dir: source/docs`, `site_dir: docs`).
- `docs/` — собранный сайт (для локального просмотра).
- `.sourcecraft/ci.yaml` — пайплайн SourceCraft: сборка → деплой в ветку `release`.
- `.github/workflows/deploy.yml` — GitHub Actions: сборка → деплой через `peaceiris/actions-gh-pages` в ветку `gh-pages`.
- `build.ps1`, `new-lab.ps1` — локальные хелперы.

## Отчёт по лабораторной работе №3

### Цель

Настроить автоматический деплой одного и того же статического сайта на двух платформах
(SourceCraft Sites и GitHub Pages) из одного локального git-репозитория с двумя удалёнными remote.

### Что сделано

1. В локальном репозитории подключены два удалённых репозитория:
   - `origin` → GitHub (`https://github.com/RailMLearning/railmlearning.github.io.git`)
   - `sourcecraft` → SourceCraft (`https://git.sourcecraft.dev/nuriahmetoffrail/portfolio.git`)
2. Написан пайплайн `.sourcecraft/ci.yaml`: на push в `main` собирает сайт MkDocs
   (с темой Dracula и mkdocs-material) и force-push'ит готовые HTML в ветку `release`.
   SourceCraft Sites раздаёт содержимое этой ветки.
3. Написан workflow `.github/workflows/deploy.yml`: на push в `main` собирает сайт
   и публикует через marketplace-action [peaceiris/actions-gh-pages](https://github.com/marketplace/actions/github-pages-action)
   в ветку `gh-pages`, откуда GitHub Pages раздаёт сайт.

### Настройки в SourceCraft

1. Сгенерировать персональный токен (PAT) с правами Maintainer:
   `Settings → Personal access tokens` (см. https://sourcecraft.dev/portal/docs/ru/sourcecraft/security/pat).
2. В настройках репозитория включить **Sites**: указать ветку `release`, корневой каталог `/`.
3. CI запустится автоматически при push в `main` (файл `.sourcecraft/ci.yaml` распознаётся платформой).

### Настройки в GitHub

1. В `Settings → Pages` выбрать источник **Deploy from a branch → `gh-pages` / `(root)`**.
   Ветка `gh-pages` создастся автоматически при первом успешном прогоне Action.
2. Action использует встроенный `GITHUB_TOKEN` — дополнительные секреты не нужны.

### Команды деплоя

```bash
# Один раз — добавить второй remote
git remote add sourcecraft https://<user>:<PAT>@git.sourcecraft.dev/<user>/<repo>.git

# Проверка списка remote
git remote -v

# Деплой — просто пуш в каждый remote
git push origin main         # → GitHub Actions → ветка gh-pages
git push sourcecraft main    # → SourceCraft CI → ветка release
```

### Ссылки (заполнить после деплоя)

- Сайт SourceCraft: `https://<yandex_username>.sourcecraft.site/<repo_name>/`
- Репозиторий SourceCraft: `https://sourcecraft.dev/<yandex_username>/<repo_name>`
- Сайт GitHub Pages: `https://<username>.github.io`
- Репозиторий GitHub: `https://github.com/<username>/<username>.github.io`

## Локальный запуск и сборка

```bash
mkdocs serve    # локальный сервер
mkdocs build    # сборка в ./docs
```

Или PowerShell-хелперы:

```powershell
.\build.ps1 -Serve
.\build.ps1
.\new-lab.ps1 11
```
