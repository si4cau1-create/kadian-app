<#
Push the local kadian-app repository to an existing GitHub repository.

Usage (from the kadian-app directory):

    powershell -ExecutionPolicy Bypass -File tools\push-github.ps1 `
        -RepoUrl https://github.com/<you>/<repo>.git

Optional:

    -Branch main                 branch to push (default: main)
    -Proxy  http://127.0.0.1:7897  route git over a local proxy
    -Force                       overwrite the remote branch when its
                                 history is unrelated to this repo

Token handling: the script asks for a Personal Access Token with hidden
input. The token is never written to disk, never placed on a command
line, and never stored in .git/config. It is passed to git through a
one-shot http.extraHeader environment variable.

Required token scope:
  classic PAT        -> repo
  fine-grained PAT   -> Contents: Read and write

Also uncomment/patch the default note: this script is ASCII-only on
purpose (the machine decodes scripts as GBK, non-ASCII breaks parsing).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$RepoUrl,

    [string]$Branch = 'main',

    [string]$Proxy = '',

    [switch]$Force
)

$ErrorActionPreference = 'Stop'

function Fail([string]$Message) {
    Write-Host ""
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

function Step([string]$Message) {
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

# ---------------------------------------------------------------- checks
Step 'Checking environment'

if (-not (Test-Path '.git')) {
    Fail 'Run this from the kadian-app directory (no .git found in the current folder).'
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail 'git is not on PATH.'
}
if ($RepoUrl -notmatch '^https://') {
    Fail 'RepoUrl must be an https:// URL. This machine has no SSH key, so git@github.com:... will not work.'
}
if ($RepoUrl -match '^https://[^/]+@') {
    Fail 'Remove the credentials from RepoUrl. Pass the token interactively instead, so it never lands in .git/config.'
}
if ($RepoUrl -notmatch '\.git$') {
    $RepoUrl = $RepoUrl.TrimEnd('/') + '.git'
}

$currentBranch = (git rev-parse --abbrev-ref HEAD).Trim()
if ($Branch -ne $currentBranch) {
    Write-Host "Note: you are on '$currentBranch', pushing it as '$Branch'." -ForegroundColor Yellow
}

# ------------------------------------------------------- commit leftovers
Step 'Staging uncommitted changes'

$dirty = git status --porcelain
if ($dirty) {
    git add -A
    git commit -q -m 'chore: sync before push'
    Write-Host 'Committed local changes.'
} else {
    Write-Host 'Working tree clean.'
}

# ------------------------------------------------------------- safety net
Step 'Checking that secrets are not tracked'

$tracked = git ls-files
$leaks = $tracked | Where-Object {
    $_ -match 'key\.properties$' -or $_ -match 'keystore/' -or $_ -match '\.jks$' -or $_ -match '\.env$'
}
if ($leaks) {
    Write-Host 'These files must never be pushed:' -ForegroundColor Red
    $leaks | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    Fail 'Remove them from the index first: git rm --cached <file>'
}
Write-Host 'No signing keys or secrets in the index.'

# ----------------------------------------------------------------- remote
Step 'Configuring remote'

$remotes = @(git remote)
if ($remotes -contains 'origin') {
    git remote set-url origin $RepoUrl
} else {
    git remote add origin $RepoUrl
}
Write-Host "origin -> $RepoUrl"

if ($Proxy) {
    git config http.proxy $Proxy
    Write-Host "git http.proxy -> $Proxy (repo-local only)"
}

# ------------------------------------------------------------------ token
Step 'Authenticating'

if ($env:KADIAN_GIT_TOKEN) {
    $token = $env:KADIAN_GIT_TOKEN
    Write-Host 'Using token from KADIAN_GIT_TOKEN.'
} else {
    $secure = Read-Host -AsSecureString -Prompt 'Paste a GitHub token (input is hidden)'
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try {
        $token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    } finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

if ([string]::IsNullOrWhiteSpace($token)) {
    Fail 'No token provided.'
}

# Hand the token to git without touching disk or the command line.
$pair = ':' + $token
$b64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($pair))
$env:GIT_CONFIG_COUNT = '1'
$env:GIT_CONFIG_KEY_0 = 'http.extraHeader'
$env:GIT_CONFIG_VALUE_0 = "Authorization: Basic $b64"
$token = $null
$b64 = $null
[GC]::Collect()

# --------------------------------------------------------- probe upstream
Step 'Contacting GitHub'

$probe = git ls-remote --heads origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Fail "Cannot read the repository. Check the URL, the token scope, and the network.`n$probe"
}

$remoteHasCommits = ($probe | Out-String).Trim().Length -gt 0

if (-not $remoteHasCommits) {
    Write-Host 'Remote repository is empty, pushing the first commit.'
    git push -u origin "${currentBranch}:$Branch"
    if ($LASTEXITCODE -ne 0) {
        Fail 'Push failed.'
    }
} else {
    Write-Host 'Remote already has commits, fetching to compare histories.'
    git fetch origin --quiet

    git rev-parse --verify --quiet "refs/remotes/origin/$Branch" > $null
    $branchExists = ($LASTEXITCODE -eq 0)

    if (-not $branchExists) {
        Write-Host "Remote has no '$Branch' branch, pushing as a new branch."
        git push -u origin "${currentBranch}:$Branch"
        if ($LASTEXITCODE -ne 0) {
            Fail 'Push failed.'
        }
    } else {
        git merge-base HEAD "origin/$Branch" > $null 2>&1
        $hasCommonAncestor = ($LASTEXITCODE -eq 0)

        if (-not $hasCommonAncestor) {
            if (-not $Force) {
                Fail "origin/$Branch has a history unrelated to this repo.`nIf you really want to overwrite it, re-run with -Force.`nOtherwise move the local repo elsewhere and clone the remote first."
            }
            Write-Host 'Overwriting unrelated remote history (-Force).' -ForegroundColor Yellow
            git push -u origin "${currentBranch}:$Branch" --force
            if ($LASTEXITCODE -ne 0) {
                Fail 'Force push failed.'
            }
        } else {
            Write-Host "Rebasing onto origin/$Branch before pushing."
            git pull --rebase origin $Branch
            if ($LASTEXITCODE -ne 0) {
                Fail 'Rebase failed. Resolve the conflict manually, then push again.'
            }
            git push -u origin "${currentBranch}:$Branch"
            if ($LASTEXITCODE -ne 0) {
                Fail 'Push failed.'
            }
        }
    }
}

# ------------------------------------------------------------------ done
Step 'Done'

$webUrl = $RepoUrl -replace '\.git$', ''
Write-Host "Repository: $webUrl" -ForegroundColor Green
Write-Host "Commit:     $((git log -1 --format='%h %s'))"
Write-Host ''
Write-Host 'Next (optional): tag the release and attach the APKs as release assets.'
Write-Host "  git tag -a v3.0.0 -m 'kadian 3.0.0'"
Write-Host '  git push origin v3.0.0'
Write-Host '  # then upload dist/*.apk on the GitHub release page'
