<#
.SYNOPSIS
  卡点 3.0 一键出包：analyze → test → Android APK/AAB → Windows EXE/MSIX → dist/ + 校验和

.DESCRIPTION
  默认全量；用 -AndroidOnly / -WindowsOnly 裁剪。
  签名材料不入库：
    Android — android/key.properties + android/keystore/*.jks
    Windows — MSIX 证书（可选），未签名会触发 SmartScreen，内测可接受。

.EXAMPLE
  pwsh tools/release.ps1
  pwsh tools/release.ps1 -AndroidOnly -SkipTests
#>
param(
  [switch]$SkipTests,
  [switch]$AndroidOnly,
  [switch]$WindowsOnly
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

function Step($text) { Write-Host "`n=== $text ===" -ForegroundColor Cyan }
function Fail($text) { Write-Host "[FAIL] $text" -ForegroundColor Red; exit 1 }

# 版本一致性：pubspec 与 lib/core/app_info.dart 必须同版本
Step '检查版本一致性'
$pubspec = Get-Content 'pubspec.yaml' -Raw
$versionMatch = [regex]::Match($pubspec, '(?m)^version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)')
if (-not $versionMatch.Success) { Fail 'pubspec.yaml 里找不到 version: x.y.z+n' }
$appVersion = $versionMatch.Groups[1].Value
$buildNumber = $versionMatch.Groups[2].Value
$info = Get-Content 'lib/core/app_info.dart' -Raw
if ($info -notmatch "kAppVersion = '$appVersion'") {
  Fail "app_info.dart 的 kAppVersion 与 pubspec ($appVersion) 不一致"
}
Write-Host "版本 $appVersion+$buildNumber" -ForegroundColor Green

if (-not $SkipTests) {
  Step 'flutter analyze'
  flutter analyze
  if ($LASTEXITCODE -ne 0) { Fail '静态分析未通过' }

  Step 'flutter test'
  flutter test
  if ($LASTEXITCODE -ne 0) { Fail '单元测试未通过' }

  Step '后端测试（如已安装依赖）'
  Push-Location server
  try {
    python -m pytest -q
    if ($LASTEXITCODE -ne 0) { Write-Host '[warn] 后端测试跳过或失败（本地可能未装 pytest）' -ForegroundColor Yellow }
  } catch {
    Write-Host '[warn] 未安装 pytest，跳过后端测试' -ForegroundColor Yellow
  } finally {
    Pop-Location
  }
}

$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force -Path $dist | Out-Null

if (-not $WindowsOnly) {
  Step 'Android: release APK'
  flutter build apk --release
  if ($LASTEXITCODE -ne 0) { Fail 'APK 构建失败' }

  Step 'Android: release AAB'
  flutter build appbundle --release
  if ($LASTEXITCODE -ne 0) { Fail 'AAB 构建失败' }

  Copy-Item "build/app/outputs/flutter-apk/app-release.apk" (Join-Path $dist "kadian-$appVersion.apk") -Force
  $aab = Get-ChildItem "build/app/outputs/bundle/release/*.aab" | Select-Object -First 1
  if ($aab) { Copy-Item $aab.FullName (Join-Path $dist "kadian-$appVersion.aab") -Force }
}

if (-not $AndroidOnly) {
  Step 'Windows: 检查 C++ 工具链'
  $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
  $hasVs = $false
  if (Test-Path $vswhere) {
    $install = & $vswhere -latest -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    $hasVs = [bool]$install
  }
  if (-not $hasVs) {
    Write-Host '[SKIP] 未检测到 Visual Studio C++ 桌面工作负载，跳过 Windows 构建。' -ForegroundColor Yellow
    Write-Host '       安装后重跑：winget install Microsoft.VisualStudio.2022.BuildTools --override "--quiet --add Microsoft.VisualStudio.Workload.VCTools"' -ForegroundColor Yellow
  } else {
    Step 'Windows: release 目录'
    flutter build windows --release
    if ($LASTEXITCODE -ne 0) { Fail 'Windows 构建失败' }

    Step 'Windows: MSIX 打包'
    dart run msix:create
    $msix = Get-ChildItem "build/windows/x64/runner/Release/*.msix" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($msix) { Copy-Item $msix.FullName (Join-Path $dist "kadian-$appVersion.msix") -Force }

    Step 'Windows: 免安装目录打包（备用分发）'
    Compress-Archive -Path "build/windows/x64/runner/Release/*" `
      -DestinationPath (Join-Path $dist "kadian-$appVersion-windows-x64.zip") -Force
  }
}

Step '生成校验和'
$lines = foreach ($file in Get-ChildItem $dist -File | Where-Object { $_.Name -notlike 'checksums*' }) {
  $hash = (Get-FileHash $file.FullName -Algorithm SHA256).Hash.ToLower()
  "$hash  $($file.Name)"
}
$lines | Set-Content (Join-Path $dist 'checksums-sha256.txt') -Encoding utf8
$lines | ForEach-Object { Write-Host "  $_" }

Step '完成'
Get-ChildItem $dist -File | Select-Object Name, @{n = 'MB'; e = { [math]::Round($_.Length / 1MB, 2) } } | Format-Table
