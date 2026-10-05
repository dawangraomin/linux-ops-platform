#!/bin/bash
# deploy.sh - 一键部署脚本

echo "========================================="
echo "  开始部署服务"
echo "========================================="

cd /home/ops

# 1. 检查 docker compose
if ! docker compose version &> /dev/null; then
    echo "错误：docker compose 未安装"
    exit 1
fi

# 2. 停止旧容器
echo "[1/3] 停止旧容器..."
docker compose down 2>/dev/null || true

# 3. 启动新容器
echo "[2/3] 启动新容器..."
docker compose up -d

# 4. 等待并检查
echo "[3/3] 等待服务启动..."
sleep 10

echo ""
echo "容器状态："
docker compose ps

echo ""
echo "========================================="
echo "  部署完成！"
echo "  访问：http://$(hostname -I | awk '{print $1}')"
echo "========================================="
