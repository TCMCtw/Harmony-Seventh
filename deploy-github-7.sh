#!/usr/bin/env bash
# 一鍵部署到 GitHub Pages
# 自動從 ~/Downloads 抓「最新下載」的 index*.html（不管檔名是 index.html、
# index_2.html、index_4.html...瀏覽器自動加的編號都不影響，只看誰是最新下載的）
set -e

DOWNLOADS="$HOME/Downloads"

# 這個 repo 資料夾＝這支 deploy-github.sh 所在的資料夾
cd "$(dirname "$0")"

# 在 Downloads 裡找所有 index*.html，依修改時間排序，取最新的一個
LATEST_FILE=$(ls -t "$DOWNLOADS"/index*.html 2>/dev/null | head -n 1)

if [ -z "$LATEST_FILE" ]; then
  echo "❌ 在 $DOWNLOADS 裡找不到任何 index*.html 檔案。"
  echo "   請先把 Claude 給的新檔案下載下來，再重新執行這支腳本。"
  exit 1
fi

echo "找到最新下載的檔案：$LATEST_FILE"
echo "（修改時間：$(date -r "$LATEST_FILE" '+%Y-%m-%d %H:%M:%S')）"
echo ""
cp "$LATEST_FILE" ./index.html

git add index.html

if git diff --cached --quiet; then
  echo "內容跟上次一樣，沒有變更，略過 commit。"
  echo ""
  echo "⚠️  如果你確定有新版本，可能是 Downloads 裡抓到的不是最新那個檔案，"
  echo "   可以打開 Downloads 資料夾手動確認一下檔名/時間。"
else
  git commit -m "Update index.html $(date '+%Y-%m-%d %H:%M')"
  git push
  echo ""
  echo "✅ 已推送到 GitHub！"
  echo "   GitHub Pages 大約 1–2 分鐘後會自動更新完成，網址不會變。"
fi