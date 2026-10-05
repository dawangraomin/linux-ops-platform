# Linux 服务器自动化运维平台

基于 CentOS Stream 10 + Docker 搭建的一套自动化运维解决方案，覆盖服务器初始化、容器化部署、自动备份、系统巡检、定时任务、服务化管理和日志分析。

## 项目架构

```
┌─────────────────────────────────────────────┐
│              宿主机 CentOS Stream 10          │
│                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Nginx   │  │  MySQL   │  │  Redis   │  │
│  │ (Docker) │  │ (Docker) │  │ (Docker) │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  │
│       │             │             │         │
│       └─────────────┼─────────────┘         │
│                     │                       │
│              ┌──────┴──────┐                │
│              │ Docker 网络  │                │
│              └──────┬──────┘                │
│                     │                       │
│  ┌──────────────────┼──────────────────┐    │
│  │          运维脚本体系                 │    │
│  │  deploy.sh  备份  巡检  监控          │    │
│  └──────────────────────────────────────┘    │
│                     │                       │
│              ┌──────┴──────┐                │
│              │  crontab    │                │
│              │  定时任务    │                │
│              └─────────────┘                │
└─────────────────────────────────────────────┘
```

## 功能模块

| 模块 | 脚本 | 功能 |
|------|------|------|
| 初始化 | `scripts/init.sh` | 系统检查、依赖安装、防火墙配置、目录规划 |
| 部署 | `scripts/deploy.sh` | Docker Compose 一键部署 Nginx + MySQL + Redis |
| 备份 | `scripts/backup.sh` | MySQL 全量备份、网站文件打包、7 天滚动清理 |
| 巡检 | `scripts/check.sh` | CPU/内存/磁盘/容器/端口巡检 + 阈值告警 |
| 日志分析 | `scripts/analyze.sh` | Top IP、Top URL、状态码统计、错误请求分析 |
| 定时任务 | `config/crontab.txt` | 备份、巡检、磁盘告警自动化 |
| 服务化 | `systemd/ops-deploy.service` | systemctl 统一管理，开机自启 |

## 技术栈

- **操作系统**：CentOS Stream 10
- **容器**：Docker 29.8.1、Docker Compose
- **服务**：Nginx 1.25、MySQL 8.0、Redis 7
- **脚本**：Bash Shell
- **调度**：crontab
- **服务管理**：systemd
- **防火墙**：firewalld

## 快速开始

### 1. 环境要求

- CentOS Stream 10（或其他 RHEL 系系统）
- Docker 已安装
- root 权限

### 2. 初始化服务器

```bash
bash scripts/init.sh
```

### 3. 部署服务

```bash
bash scripts/deploy.sh
```

部署完成后访问 `http://你的IP` 即可看到网站。

### 4. 配置定时任务

```bash
crontab config/crontab.txt
```

### 5. 启用 systemd 服务

```bash
sudo cp systemd/ops-deploy.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now ops-deploy.service
```

## 使用说明

### 手动备份

```bash
bash scripts/backup.sh
```

### 系统巡检

```bash
bash scripts/check.sh
```

### 日志分析

```bash
docker logs ops-nginx > logs/access.log 2>&1
bash scripts/analyze.sh
```

### 服务管理

```bash
systemctl start ops-deploy.service    # 启动
systemctl stop ops-deploy.service     # 停止
systemctl status ops-deploy.service   # 查看状态
```

## 项目截图

### 网站首页

![网站首页](screenshots/website.png)

### 系统巡检报告

![巡检报告](screenshots/check.png)

### 日志分析

![日志分析](screenshots/analyze.png)

### 容器状态

![容器状态](screenshots/docker-ps.png)

## 项目结构

```
linux-ops-platform/
├── README.md
├── config/                  # 配置文件
│   ├── crontab.txt
│   ├── docker-compose.yml
│   └── nginx.conf
├── scripts/                 # 运维脚本
│   ├── init.sh
│   ├── deploy.sh
│   ├── backup.sh
│   ├── check.sh
│   └── analyze.sh
├── systemd/                 # systemd 服务
│   └── ops-deploy.service
├── web/                     # 网站文件
│   └── index.html
└── screenshots/             # 项目截图
```

## 收获与总结

通过本项目实践，掌握了以下技能：

- Linux 命令行操作与 Shell 脚本编程
- Docker 容器化部署与 Docker Compose 编排
- systemd 服务管理与开机自启
- crontab 定时任务调度
- firewalld 防火墙配置
- Nginx 日志分析与文本处理（grep/awk/sort/uniq）
- 自动化运维思维：备份、巡检、告警

## License

MIT
