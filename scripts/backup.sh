#!/bin/bash
# backup.sh - 自动备份脚本

BACKUP_DIR="/home/ops/backup"
DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/home/ops/logs/backup.log"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始备份" >> $LOG_FILE

# 1. 备份 MySQL
echo "备份 MySQL..."
docker exec ops-mysql mysqldump -uroot -proot123456 --all-databases > \
    $BACKUP_DIR/mysql_$DATE.sql 2>> $LOG_FILE
echo "MySQL 备份完成：mysql_$DATE.sql"

# 2. 备份网站文件
echo "备份网站文件..."
tar -czf $BACKUP_DIR/web_$DATE.tar.gz -C /home/ops web/ 2>> $LOG_FILE
echo "网站备份完成：web_$DATE.tar.gz"

# 3. 备份配置文件
echo "备份配置文件..."
tar -czf $BACKUP_DIR/config_$DATE.tar.gz \
    /home/ops/docker-compose.yml \
    /home/ops/nginx.conf 2>> $LOG_FILE
echo "配置备份完成：config_$DATE.tar.gz"

# 4. 删除 7 天前的备份
echo "清理旧备份..."
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

# 5. 统计
TOTAL=$(du -sh $BACKUP_DIR | awk '{print $1}')
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 备份完成，总大小：$TOTAL" >> $LOG_FILE
echo ""
echo "备份完成，总大小：$TOTAL"
