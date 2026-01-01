param (
    [datetime]$StartDate = "2026-04-01",
    [datetime]$EndDate = "2026-10-19",
    [int]$MinDaysPerWeek = 3,
    [int]$MaxDaysPerWeek = 4,
    [int]$MinCommits = 1,
    [int]$MaxCommits = 10
)

Write-Host "=== Tao commit tu nhien tu $StartDate den $EndDate ===" -ForegroundColor Cyan
Write-Host "Moi tuan chon tu $MinDaysPerWeek den $MaxDaysPerWeek ngay active, moi ngay $MinCommits den $MaxCommits commit." -ForegroundColor Cyan

# Gom cac ngay theo tung tuan
$currentDate = $StartDate.Date
$allDays = @()
while ($currentDate -le $EndDate.Date) {
    $allDays += $currentDate
    $currentDate = $currentDate.AddDays(1)
}

# Group cac ngay theo ISO Week hoac chu ky 7 ngay bat dau tu thu 2
$weeks = $allDays | Group-Object {
    # Tuan bat dau tu thu Hai
    $diff = [int]$_.DayOfWeek - [int][DayOfWeek]::Monday
    if ($diff -lt 0) { $diff += 7 }
    $_.AddDays(-$diff).ToString("yyyy-MM-dd")
}

$totalCommits = 0
$totalActiveDays = 0

foreach ($week in $weeks) {
    $daysInWeek = $week.Group
    # So ngay active trong tuan nay (3 hoac 4)
    $targetActive = Get-Random -Minimum $MinDaysPerWeek -Maximum ($MaxDaysPerWeek + 1)
    if ($targetActive -gt $daysInWeek.Count) {
        $targetActive = $daysInWeek.Count
    }
    
    # Chon ngau nhien cac ngay trong tuan
    $activeDays = $daysInWeek | Get-Random -Count $targetActive | Sort-Object
    
    foreach ($day in $activeDays) {
        $totalActiveDays++
        # So commit trong ngay (tu 1 den 10)
        $commitsToday = Get-Random -Minimum $MinCommits -Maximum ($MaxCommits + 1)
        
        for ($c = 1; $c -le $commitsToday; $c++) {
            # Phan bo thoi gian ngau nhien tu 08:30 sang den 22:30 toi
            $hour = Get-Random -Minimum 8 -Maximum 23
            $minute = Get-Random -Minimum 0 -Maximum 60
            $second = Get-Random -Minimum 0 -Maximum 60
            $timestamp = $day.AddHours($hour).AddMinutes($minute).AddSeconds($second).ToString("yyyy-MM-dd HH:mm:ss")
            
            $env:GIT_AUTHOR_DATE = "$timestamp"
            $env:GIT_COMMITTER_DATE = "$timestamp"
            git commit --allow-empty -m "chore(activity): update on $timestamp (#$c)" --quiet
            $totalCommits++
        }
    }
}

Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue

Write-Host "`n[OK] Hoan thanh!" -ForegroundColor Green
Write-Host "Tong so ngay active: $totalActiveDays ngay tren $($weeks.Count) tuan" -ForegroundColor Green
Write-Host "Tong so commit da tao: $totalCommits commit" -ForegroundColor Green
