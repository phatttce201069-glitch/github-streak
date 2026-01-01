param (
    [int]$DaysBack = 0,
    [int]$CountToday = 0,
    [int]$MinPerDay = 12,
    [int]$MaxPerDay = 15,
    [switch]$Push
)

Write-Host "=== GitHub Commit Farming Tool (Zero Storage) ===" -ForegroundColor Cyan

if ($DaysBack -gt 0) {
    Write-Host "[*] Dang tao commit tu 12 den 15 commit/ngay cho $DaysBack ngay qua..." -ForegroundColor Yellow
    $totalCommits = 0
    for ($d = $DaysBack; $d -ge 0; $d--) {
        $baseDate = (Get-Date).AddDays(-$d).Date
        $commitsCount = Get-Random -Minimum $MinPerDay -Maximum ($MaxPerDay + 1)
        for ($c = 1; $c -le $commitsCount; $c++) {
            # Phan bo thoi gian tu 08:00 den 22:00
            $hour = 8 + [math]::Floor(($c / $commitsCount) * 14)
            $minute = Get-Random -Minimum 0 -Maximum 60
            $second = Get-Random -Minimum 0 -Maximum 60
            $dateStr = $baseDate.AddHours($hour).AddMinutes($minute).AddSeconds($second).ToString("yyyy-MM-dd HH:mm:ss")
            
            $env:GIT_AUTHOR_DATE = "$dateStr"
            $env:GIT_COMMITTER_DATE = "$dateStr"
            git commit --allow-empty -m "chore(activity): activity on $dateStr (#$c)" --quiet
            $totalCommits++
        }
    }
    Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
    Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
    Write-Host "[OK] Da tao tong cong $totalCommits commit cho $DaysBack ngay qua!" -ForegroundColor Green
}

if ($CountToday -gt 0) {
    Write-Host "[*] Dang tao $CountToday commit cho ngay hom nay..." -ForegroundColor Yellow
    for ($i = 1; $i -le $CountToday; $i++) {
        git commit --allow-empty -m "chore(activity): ping #$i" --quiet
    }
    Write-Host "[OK] Hoan thanh tao $CountToday commit!" -ForegroundColor Green
}

if ($Push) {
    Write-Host "[*] Dang day commit len GitHub..." -ForegroundColor Yellow
    git push origin main
    Write-Host "[OK] Da push thanh cong len GitHub!" -ForegroundColor Green
}
if (-not $Push) {
    Write-Host "`n[*] Tip: Chay 'git push origin main' de cap nhat len GitHub." -ForegroundColor Gray
}
