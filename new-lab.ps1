# Создаёт новую страницу лабы и добавляет её в nav в mkdocs.yml
# Использование:  .\new-lab.ps1 6
#                 .\new-lab.ps1 6 -Title "Веб-сервер"
param(
    [Parameter(Mandatory = $true)][int]$Number,
    [string]$Title
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$labFile = "source/docs/labs/lab$Number.md"
if (Test-Path $labFile) {
    Write-Host "Файл $labFile уже существует — пропускаю создание." -ForegroundColor Yellow
} else {
    $heading = if ($Title) { "# Лабораторная работа №${Number}. $Title" } else { "# Лабораторная работа №$Number" }
    @"
$heading

## Цель

_..._

## Задание

_..._

## Ход работы

_..._

## Код

``````python
# ...
``````

## Выводы

_..._

## Ссылки

- [Репозиторий](https://github.com/RailMLearning/...)
"@ | Set-Content -Path $labFile -Encoding UTF8
    Write-Host "Создан $labFile" -ForegroundColor Green
}

# Добавляем в карточный список labs.md, если ещё нет
$labsIndex = "source/docs/labs.md"
$content = Get-Content $labsIndex -Raw
$itemMarker = "href=""lab$Number/"""
if ($content -notmatch [regex]::Escape($itemMarker)) {
    $entry = "  <li><a href=""lab$Number/"">Лабораторная работа №$Number</a></li>"
    $updated = $content -replace '(?m)^</ul>', "$entry`r`n</ul>"
    Set-Content -Path $labsIndex -Value $updated -Encoding UTF8 -NoNewline
    Write-Host "Добавлено в labs.md" -ForegroundColor Green
}

# Добавляем в nav в mkdocs.yml перед закрытием раздела
$mkdocsPath = "mkdocs.yml"
$yml = Get-Content $mkdocsPath -Raw
$navEntry = "      - Лаба ${Number}: labs/lab$Number.md"
if ($yml -notmatch [regex]::Escape("labs/lab$Number.md")) {
    # Вставляем после последней строки '      - Лаба N: ...'
    $lines = Get-Content $mkdocsPath
    $lastLabIdx = -1
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match '^\s+- Лаба \d+:') { $lastLabIdx = $i }
    }
    if ($lastLabIdx -ge 0) {
        $new = @()
        $new += $lines[0..$lastLabIdx]
        $new += $navEntry
        if ($lastLabIdx -lt $lines.Length - 1) {
            $new += $lines[($lastLabIdx + 1)..($lines.Length - 1)]
        }
        $new | Set-Content -Path $mkdocsPath -Encoding UTF8
        Write-Host "Добавлено в nav (mkdocs.yml)" -ForegroundColor Green
    } else {
        Write-Host "Не нашёл маркер '- Лаба N:' в mkdocs.yml — добавь вручную: $navEntry" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Готово. Теперь:" -ForegroundColor Cyan
Write-Host "  .\build.ps1 -Serve   # посмотреть локально"
Write-Host "  .\build.ps1          # пересобрать docs/"
