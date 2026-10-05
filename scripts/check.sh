#!/bin/bash
# check.sh - 系统巡检脚本

echo "========================================="
echo "  系统巡检报告 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

# 1. 主机信息
echo ""
echo "【主机信息】"
echo "主机名：$(hostname)"
echo "IP 地址：$(hostname -I | awk '{print $1}')"
echo "系统版本：$(cat /etc/redhat-release)"
echo "运行时间：$(uptime -p)"

# 2. CPU 和负载
echo ""
echo "【CPU 与负载】"
uptime | awk -F'load average:' '{print "负载：" $2}'
echo "CPU 核心：$(nproc)"

# 3. 内存
echo ""
echo "【内存使用】"
free -h | awk 'NR==2{printf "已用：%s / 总共：%s (%.1f%%)\n", $3, $2, $3/$2*100}'

# 4. 磁盘
echo ""
echo "【磁盘使用】"
df -h | grep -E "^/dev" | awk '{printf "%s：已用 %s / 总共 %s (%s)\n", $6, $3, $2, $5}'

# 5. Docker 服务
echo ""
echo "【Docker 容器】"
if command -v docker &> /dev/null; then
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo "Docker 未安装"
fi

# 6. 关键端口
echo ""
echo "【关键端口监听】"
ss -tulnp | grep -E ":(80|8080|3306|6379)" || echo "无关键端口监听"

# 7. 告警检查
echo ""
echo "【告警检查】"
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "⚠️  警告：根分区使用率 ${DISK_USAGE}%，超过 80%"
else
    echo "✅ 磁盘正常（${DISK_USAGE}%）"
fi

MEM_USAGE=$(free | awk 'NR==2{printf "%.0f", $3/$2*100}')
if [ "$MEM_USAGE" -gt 80 ]; then
    echo "⚠️  警告：内存使用率 ${MEM_USAGE}%，超过 80%"
else
    echo "✅ 内存正常（${MEM_USAGE}%）"
fi

echo ""
echo "========================================="
echo "  巡检完成"
echo "========================================="
