#!/bin/bash
# init.sh - 服务器初始化脚本
# 用法：bash init.sh

#set -e

echo "========================================="
echo "  服务器初始化开始"
echo "========================================="

# 1. 检查是否为 root
if [ "$(id -u)" -ne 0 ]; then
    echo "错误：请用 root 或 sudo 执行"
    exit 1
fi

# 2. 检查系统版本
echo "[1/6] 检查系统版本..."
cat /etc/redhat-release

# 3. 安装常用工具
echo "[2/6] 安装常用工具..."
for pkg in vim wget curl git net-tools lsof tree htop tar gzip; do
    dnf install -y $pkg || echo "警告：$pkg 安装失败，跳过"
done

# 4. 创建项目目录
echo "[3/6] 创建项目目录..."
mkdir -p /home/ops/{scripts,logs,backup,web}

# 5. 配置防火墙
echo "[4/6] 配置防火墙..."
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --reload
echo "已开放端口：80, 8080, 3306"

# 6. 检查 Docker
echo "[5/6] 检查 Docker..."
if command -v docker &> /dev/null; then
    docker --version
    systemctl enable docker
    systemctl start docker
else
    echo "警告：Docker 未安装，请先安装 Docker"
fi

# 7. 完成
echo "[6/6] 初始化完成！"
echo "========================================="
echo "  项目目录：/home/ops"
echo "  脚本目录：/home/ops/scripts"
echo "  日志目录：/home/ops/logs"
echo "  备份目录：/home/ops/backup"
echo "========================================="
