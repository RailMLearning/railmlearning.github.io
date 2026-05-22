# Создаёт новую пустую страницу лабы и добавляет её в карточный список на /labs/
# Использование:  .\new-lab.ps1 11
param(
    [Parameter(Mandatory = $true)][int]$Number
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$labFile = "source/docs/labs/lab$Number.md"
if (Test-Path $labFile) {
    Write-Host "Файл $labFile уже существует — пропускаю создание." -ForegroundColor Yellow
} else {
    "# Лабораторная работа №$Number" | Set-Content -Path $labFile -Encoding UTF8
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

Write-Host ""
Write-Host "Готово. Теперь:" -ForegroundColor Cyan
Write-Host "  .\build.ps1 -Serve   # посмотреть локально"
Write-Host "  .\build.ps1          # пересобрать docs/"
