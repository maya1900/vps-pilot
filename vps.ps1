$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bash = $null

if (Get-Command bash -ErrorAction SilentlyContinue) {
    $bash = "bash"
}

if (-not $bash) {
    $gitBash = Join-Path ${env:ProgramFiles} "Git\bin\bash.exe"
    if (Test-Path $gitBash) {
        $bash = $gitBash
    }
}

if (-not $bash -and $env:ProgramFiles -and $env:"ProgramFiles(x86)") {
    $gitBashX86 = Join-Path ${env:ProgramFiles(x86)} "Git\bin\bash.exe"
    if (Test-Path $gitBashX86) {
        $bash = $gitBashX86
    }
}

if (-not $bash) {
    Write-Host "[VPS Pilot] 未找到 bash。"
    Write-Host "请先安装 Git for Windows 或启用 WSL。"
    exit 1
}

& $bash (Join-Path $ScriptDir "vps") @args
