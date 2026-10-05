#!/bin/bash
# analyze.sh - Nginx 访问日志分析脚本

LOG_FILE="/home/ops/logs/access.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "日志文件不存在：$LOG_FILE"
    exit 1
fi

echo "========================================="
echo "  Nginx 访问日志分析"
echo "  分析时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

# 只保留标准 access log 行（以 IP 开头），过滤掉错误日志和启动信息
CLEAN_LOG=$(mktemp)
grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$LOG_FILE" > "$CLEAN_LOG"

echo ""
echo "【总请求数】"
wc -l < "$CLEAN_LOG"

echo ""
echo "【访问量 Top 10 IP】"
awk '{print $1}' "$CLEAN_LOG" | sort | uniq -c | sort -rn | head -10

echo ""
echo "【访问量 Top 10 URL】"
awk '{print $7}' "$CLEAN_LOG" | sort | uniq -c | sort -rn | head -10

echo ""
echo "【状态码统计】"
awk '{print $9}' "$CLEAN_LOG" | sort | uniq -c | sort -rn

echo ""
echo "【错误请求（4xx/5xx）Top 10】"
awk '$9 ~ /^[45]/ {print $1, $7, $9}' "$CLEAN_LOG" | head -10

echo ""
echo "【User-Agent Top 5】"
awk -F'"' '{print $6}' "$CLEAN_LOG" | sort | uniq -c | sort -rn | head -5

rm -f "$CLEAN_LOG"

echo ""
echo "========================================="
echo "  分析完成"
echo "========================================="
