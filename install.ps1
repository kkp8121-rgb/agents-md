# AGENTS.md 전역 설치 (Windows) — Codex + Claude Code + Grok Build 동시 적용
# 사용법: 레포 클론 후 레포 루트에서  powershell -ExecutionPolicy Bypass -File .\install.ps1
$ErrorActionPreference = 'Stop'

$src = Join-Path $PSScriptRoot 'AGENTS.md'
if (-not (Test-Path $src)) { throw "AGENTS.md를 찾을 수 없습니다: $src" }

# 1) Codex 전역 (실파일 = 단일 원본)
$codexDir = Join-Path $HOME '.codex'
New-Item -ItemType Directory -Force $codexDir | Out-Null
$codexFile = Join-Path $codexDir 'AGENTS.md'
if (Test-Path $codexFile) {
    $bak = "$codexFile.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
    Copy-Item $codexFile $bak
    Write-Host "기존 파일 백업: $bak"
}
Copy-Item $src $codexFile -Force
Write-Host "설치: $codexFile"

# 2) Claude Code 전역 (참조 한 줄, 기존 내용 보존)
$claudeDir = Join-Path $HOME '.claude'
New-Item -ItemType Directory -Force $claudeDir | Out-Null
$claudeFile = Join-Path $claudeDir 'CLAUDE.md'
$importLine = '@~/.codex/AGENTS.md'
if (Test-Path $claudeFile) {
    $content = Get-Content $claudeFile -Raw
    if ($content -notmatch [regex]::Escape($importLine)) {
        Set-Content $claudeFile ($importLine + "`n`n" + $content) -Encoding UTF8
        Write-Host "기존 CLAUDE.md 첫 줄에 참조 추가: $claudeFile"
    } else {
        Write-Host "참조 이미 존재: $claudeFile"
    }
} else {
    Set-Content $claudeFile $importLine -Encoding UTF8
    Write-Host "생성: $claudeFile"
}

# 3) Grok Build 전역 (~/.grok/rules/ 는 모든 프로젝트에 항상 로드됨)
$grokHome = if ($env:GROK_HOME) { $env:GROK_HOME } else { Join-Path $HOME '.grok' }
$grokRules = Join-Path $grokHome 'rules'
New-Item -ItemType Directory -Force $grokRules | Out-Null
Copy-Item $src (Join-Path $grokRules 'AGENTS.md') -Force
Write-Host "설치: $(Join-Path $grokRules 'AGENTS.md')"

Write-Host "`n완료. 새 세션부터 Claude Code·Codex·Grok Build 모두에 적용됩니다."
