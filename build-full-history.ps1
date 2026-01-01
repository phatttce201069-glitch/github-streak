param (
    [int]$MaxCommitsStage2 = 2,
    [switch]$Push
)

Write-Host "=== Tao toan bo lich su tu Jan 2026 den Oct 2026 (Toi da $MaxCommitsStage2 commit/ngay) ===" -ForegroundColor Cyan

# -------------------------------------------------------------
# Giai doan 1: Jan 1, 2026 -> Mar 31, 2026 (Giai doan moi lam quen Git)
# Quy tac: Moi tuan chi 2 den 3 commit, moi ngay it hon 3 commit (1-2 commit)
# -------------------------------------------------------------
Write-Host "`n[*] Giai doan 1 (Jan - Mar 2026): Tap lam quen Git (2-3 commit/tuan, it hon 3 commit/ngay)..." -ForegroundColor Yellow

$beginnerMessages = @(
    "docs: update readme",
    "feat: first test commit",
    "fix: fix typo in document",
    "chore: learning git commands",
    "docs: add note about git workflow",
    "test: testing git push",
    "chore: practice branching",
    "refactor: small clean up",
    "feat: add sample script",
    "docs: update learning notes",
    "fix: simple bug fix",
    "chore: save progress",
    "docs: markdown formatting practice",
    "feat: initial setup logic"
)

$startJan = Get-Date "2026-01-01"
$endMar = Get-Date "2026-03-31"

$daysJanMar = @()
$curr = $startJan.Date
while ($curr -le $endMar.Date) {
    $daysJanMar += $curr
    $curr = $curr.AddDays(1)
}

$weeksJanMar = $daysJanMar | Group-Object {
    $diff = [int]$_.DayOfWeek - [int][DayOfWeek]::Monday
    if ($diff -lt 0) { $diff += 7 }
    $_.AddDays(-$diff).ToString("yyyy-MM-dd")
}

$janMarCommits = 0
foreach ($week in $weeksJanMar) {
    $daysInWeek = $week.Group
    # Moi tuan 2 den 3 commit
    $commitsThisWeek = Get-Random -Minimum 2 -Maximum 4
    
    # Chon ngau nhien so ngay tuong ung (2 hoac 3 ngay rieng biet)
    $activeDays = $daysInWeek | Get-Random -Count $commitsThisWeek | Sort-Object
    
    foreach ($day in $activeDays) {
        # So commit it hon 3: 1 hoac 2 commit/ngay
        $commitsToday = Get-Random -Minimum 1 -Maximum 3
        for ($c = 1; $c -le $commitsToday; $c++) {
            $hour = Get-Random -Minimum 9 -Maximum 21
            $minute = Get-Random -Minimum 0 -Maximum 60
            $second = Get-Random -Minimum 0 -Maximum 60
            $timestamp = $day.AddHours($hour).AddMinutes($minute).AddSeconds($second).ToString("yyyy-MM-dd HH:mm:ss")
            
            $msg = $beginnerMessages | Get-Random
            $env:GIT_AUTHOR_DATE = "$timestamp"
            $env:GIT_COMMITTER_DATE = "$timestamp"
            git commit --allow-empty -m "$msg" --quiet
            $janMarCommits++
        }
    }
}
Write-Host "[OK] Da tao $janMarCommits commit cho giai doan Jan - Mar 2026." -ForegroundColor Green

# -------------------------------------------------------------
# Giai doan 2: Apr 1, 2026 -> Oct 23, 2026 (Giai doan commit tu nhien deu dan)
# Quy tac: Moi tuan 3 den 4 ngay, moi ngay toi da $MaxCommitsStage2 commit (1 den $MaxCommitsStage2)
# -------------------------------------------------------------
Write-Host "`n[*] Giai doan 2 (Apr - Oct 2026): Hoat dong deu dan (1 tuan 3-4 ngay, 1-$MaxCommitsStage2 commit/ngay)..." -ForegroundColor Yellow

$startApr = Get-Date "2026-04-01"
$endOct = Get-Date "2026-10-23"

$daysAprOct = @()
$curr = $startApr.Date
while ($curr -le $endOct.Date) {
    $daysAprOct += $curr
    $curr = $curr.AddDays(1)
}

$weeksAprOct = $daysAprOct | Group-Object {
    $diff = [int]$_.DayOfWeek - [int][DayOfWeek]::Monday
    if ($diff -lt 0) { $diff += 7 }
    $_.AddDays(-$diff).ToString("yyyy-MM-dd")
}

$aprOctCommits = 0
$aprOctActiveDays = 0

foreach ($week in $weeksAprOct) {
    $daysInWeek = $week.Group
    $targetActive = Get-Random -Minimum 3 -Maximum 5
    if ($targetActive -gt $daysInWeek.Count) {
        $targetActive = $daysInWeek.Count
    }
    
    $activeDays = $daysInWeek | Get-Random -Count $targetActive | Sort-Object
    
    foreach ($day in $activeDays) {
        $aprOctActiveDays++
        # Moi ngay toi da $MaxCommitsStage2 (1 hoac 2 commit)
        $commitsToday = Get-Random -Minimum 1 -Maximum ($MaxCommitsStage2 + 1)
        for ($c = 1; $c -le $commitsToday; $c++) {
            $hour = Get-Random -Minimum 8 -Maximum 23
            $minute = Get-Random -Minimum 0 -Maximum 60
            $second = Get-Random -Minimum 0 -Maximum 60
            $timestamp = $day.AddHours($hour).AddMinutes($minute).AddSeconds($second).ToString("yyyy-MM-dd HH:mm:ss")
            
            $env:GIT_AUTHOR_DATE = "$timestamp"
            $env:GIT_COMMITTER_DATE = "$timestamp"
            git commit --allow-empty -m "chore(activity): update on $timestamp (#$c)" --quiet
            $aprOctCommits++
        }
    }
}

Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue

Write-Host "[OK] Da tao $aprOctCommits commit cho giai doan Apr - Oct 2026 ($aprOctActiveDays ngay active, toi da $MaxCommitsStage2 commit/ngay)." -ForegroundColor Green
Write-Host "`n[TONG CONG] $($janMarCommits + $aprOctCommits) commit da san sang!" -ForegroundColor Cyan

if ($Push) {
    Write-Host "`n[*] Dang day len GitHub (force push de dong bo theo thu tu thoi gian chuan)..." -ForegroundColor Yellow
    git push origin main --force
    Write-Host "[OK] Da push thanh cong len GitHub!" -ForegroundColor Green
}
