# Сборка сайта: source/docs -> docs/
# Использование:  .\build.ps1           - просто собрать
#                 .\build.ps1 -Serve    - локальный сервер с авто-перезагрузкой
param(
    [switch]$Serve
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if ($Serve) {
    mkdocs serve
} else {
    mkdocs build --clean
    Write-Host "Готово. Сайт собран в .\docs" -ForegroundColor Green
}
