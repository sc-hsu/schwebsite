param(
    [Parameter(Mandatory=$false)]
    [string]$msg = "Site update $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

# 執行 git add
Write-Host "正在加入變更至暫存區 (git add)..." -ForegroundColor Cyan
git add .

# 檢查是否有變更需要提交
if ($(git status --porcelain)) {
    # 執行 git commit
    Write-Host "正在提交變更 (git commit)..." -ForegroundColor Cyan
    git commit -m "$msg"

    # 執行 git push
    Write-Host "正在推送至遠端 (git push)..." -ForegroundColor Cyan
    git push

    Write-Host "完成！" -ForegroundColor Green
} else {
    Write-Host "沒有偵測到需要提交的變更。" -ForegroundColor Yellow
}
