# VPS Pilot

多台 VPS 的本地统一控制工具。

- 版本：`v0.0.1`
- 作者：`markyal`
- 主命令：`vps`

`VPS Pilot` 面向需要在本机统一管理多台 VPS 的场景，提供服务器列表管理、批量命令执行、基础巡检、容器查看、容器内批量命令会话等能力。项目以单文件脚本为核心，尽量降低依赖，适合个人运维、小规模节点管理和日常巡检使用。

---

## 项目说明

本项目定位为本地命令行工具，主要解决以下问题：

- 统一管理多台 VPS 的连接信息
- 通过一个入口完成登录、巡检、批量执行、容器查看等常见操作
- 减少重复输入长 SSH 命令与 Docker 命令的负担
- 提供适合中文使用习惯的交互提示与菜单入口

本项目默认运行在本地终端环境，所有操作均基于 SSH 到目标主机执行，请在确认目标主机、用户和权限配置正确后使用。

---

## 主要特性

### 核心能力

- 多台 VPS 统一纳管
- SSH 登录与基础连接封装
- 批量命令执行与结果汇总
- 状态查看与基础巡检
- 容器列表查看
- 容器内批量命令会话

### 运维增强

- 支持串行与并发执行
- 批量任务失败不中断，并在结束后输出汇总结果
- SSH 默认带连接超时与保活配置
- 公钥分发支持自动去重
- 配置文件支持合法性校验

### 交互体验

- 中文说明与提示信息
- 菜单入口与直接命令并存
- 批量命令会话支持历史记录、快捷词、命令重跑
- 容器会话支持容器列表选择，减少记忆容器名的负担

---

## 快速开始

### 1. 克隆项目

```bash
git clone <your-repo-url> vps-pilot
cd vps-pilot
```

### 2. 准备配置文件

复制示例配置：

```bash
cp "./servers.example.conf" "./servers.conf"
```

编辑 `servers.conf`，填入你的服务器信息：

```text
名称|用户|主机/IP|端口|私钥路径
oc1|root|192.168.1.10|22|~/.ssh/id_ed25519
oc2|root|192.168.1.11|22|-
```

字段说明：

- `名称`：本地识别名，后续通过 `vps ssh <name>` 等命令使用
- `用户`：SSH 登录用户
- `主机/IP`：公网 IP、内网 IP 或域名
- `端口`：SSH 端口，默认一般为 `22`
- `私钥路径`：SSH 私钥路径；若暂时未知，可填写 `-`

### 3. 给予执行权限

macOS / Linux：

```bash
chmod +x "./vps" "./vpsctl"
```

说明：

- 这一步主要用于让脚本可以直接作为可执行文件运行
- 在 macOS 和大多数 Linux 环境中，这样写是正常的

Windows：

- 推荐通过 `Git Bash` 或 `WSL` 使用本项目
- 在 `Git Bash` / `WSL` 中，可以执行上面的 `chmod +x`
- 项目已内置 Windows 包装器：
  - `vps.cmd`
  - `vps.ps1`
- 在 `cmd` / `PowerShell` 中运行时，它们会自动尝试调用 `bash`
- 如果只想临时运行，也可以直接使用：

```bash
bash ./vps
```

### 4. 开始使用

如果当前目录就是项目目录，可以直接运行：

```bash
vps
vps list
vps validate
```

如果你的环境还没有把 `vps` 加入 `PATH`，也可以这样运行：

```bash
./vps
./vps list
./vps validate
```

### 5. 在任意目录运行

是否可以在任意目录直接输入 `vps`，取决于 `vps` 是否已经加入当前系统的 `PATH`。

macOS / Linux：

```bash
mkdir -p "$HOME/.local/bin"
ln -sfn "$(pwd)/vps" "$HOME/.local/bin/vps"
```

前提：

- `~/.local/bin` 已经在你的 `PATH` 中
- 如果项目目录被移动了，需要重新建立链接

Windows：

- 如果你通过 `WSL` 使用，可以按 Linux 方式处理
- 如果你通过 `Git Bash` 使用，通常可以直接在项目目录执行 `./vps` 或 `bash ./vps`
- 如果你通过原生 `cmd` / `PowerShell` 使用，可以配合项目自带的 `vps.cmd` / `vps.ps1`
- 若要在 Windows 任意目录直接输入 `vps`，需要把项目目录加入 `PATH`，或者把包装器放到已在 `PATH` 的目录中

---

## 命令总览

### 常用命令

```bash
vps list
vps ssh <name>
vps status [name|all] [--parallel]
vps check [name|all] [--parallel]
vps batch <name|all> [--parallel]
vps containers <name>
vps cbatch <name> [container]
vps run <name|all> [--parallel] -- <command>
vps update [name|all] [--parallel]
vps upgrade [name|all] [--parallel]
vps reboot [name|all]
vps copy-key <name>
vps validate
vps version
vps help
```

### 命令说明

- `list`：查看服务器列表
- `ssh`：登录指定服务器
- `status`：查看服务器状态，包括时间、磁盘、内存、负载、服务状态与公网 IP
- `check`：执行基础巡检，检查磁盘、内存、服务等明显异常
- `batch`：进入批量命令会话，连续执行多条命令
- `containers`：列出指定服务器上的容器
- `cbatch`：进入容器批量命令会话
- `run`：执行单条批量命令
- `update`：刷新软件包索引
- `upgrade`：升级系统软件包
- `reboot`：重启主机
- `copy-key`：将本机公钥写入远程主机
- `validate`：校验配置文件
- `version`：查看版本与作者信息

---

## 配置说明

### 配置文件

默认配置文件路径：

```bash
./servers.conf
```

如需指定其它配置文件，可通过环境变量覆盖：

```bash
VPSCTL_CONFIG=/path/to/servers.conf vps list
```

### 示例配置

项目自带示例文件：

- [servers.example.conf](./servers.example.conf)

真实配置文件：

- [servers.conf](./servers.conf)

注意：真实 `servers.conf` 已被 `.gitignore` 忽略，默认不会进入仓库。

---

## 使用示例

### 查看服务器列表

```bash
vps list
```

### 登录某一台服务器

```bash
vps ssh oc1
```

### 查看所有服务器状态

```bash
vps status
```

并发查看：

```bash
vps status --parallel
```

### 执行基础巡检

```bash
vps check
```

### 批量执行命令

```bash
vps run all -- docker ps
```

并发执行：

```bash
vps run all --parallel -- docker ps
```

### 刷新与升级系统包

```bash
vps update
vps upgrade
```

### 分发公钥

```bash
vps copy-key oc1
```

---

## 批量命令会话

批量命令会话适合连续执行多条命令，而不是每次都重复输入 `vps run`。

进入会话：

```bash
vps batch all
```

会话中可连续执行：

```bash
docker ps
systemctl status nginx --no-pager
cd /opt/app && git pull && docker compose up -d
```

### 会话辅助命令

```bash
:history
:shortcuts
!!
!3
:q
```

说明如下：

- `:history`：查看当前会话历史
- `:shortcuts`：查看快捷词
- `!!`：重跑上一条命令
- `!3`：重跑第 3 条命令
- `:q`：退出会话

### 宿主机会话快捷词

```bash
ps
nginx
docker
disk
mem
ports
restart-nginx
restart-docker
```

---

## 容器批量命令会话

容器会话用于在指定服务器的某个容器内部，连续执行命令。

### 方式一：已知容器名

```bash
vps cbatch oc1 myapp
```

### 方式二：忘记容器名

先查看容器：

```bash
vps containers oc1
```

或者直接：

```bash
vps cbatch oc1
```

此时脚本会先列出容器，支持输入：

- 容器序号
- 容器名

### 容器会话执行方式

容器会话中的每一条命令，都会自动包装为：

```bash
docker exec <container> sh -lc '<你的命令>'
```

例如：

```bash
pwd
ls
env
ps
```

### 容器会话快捷词

```bash
ps
ls
env
pwd
ports
restart
```

---

## 菜单模式

直接输入：

```bash
vps
```

即可进入菜单模式。

菜单适合以下场景：

- 不想记完整命令
- 只想快速查看状态、容器列表、执行常见操作
- 需要通过交互方式选择服务器或容器

查看类菜单项输出完成后，按任意键即可返回菜单。

---

## 版本信息

查看当前版本：

```bash
vps version
```

当前版本信息：

- 项目名：`VPS Pilot`
- 版本：`v0.0.1`
- 作者：`markyal`

---

## 项目结构

当前核心文件如下：

- [vps](./vps)：主脚本
- [vpsctl](./vpsctl)：兼容入口
- [README.md](./README.md)：项目说明
- [servers.example.conf](./servers.example.conf)：示例配置
- [servers.conf](./servers.conf)：本地实际配置
- [.gitignore](./.gitignore)：仓库忽略规则

---

## 发布说明

仓库建议提交以下文件：

- `vps`
- `vpsctl`
- `vps.cmd`
- `vps.ps1`
- `README.md`
- `LICENSE`
- `CHANGELOG.md`
- `servers.example.conf`
- `.gitignore`

不建议提交：

- `servers.conf`
- `.vps_batch_history`

这样可以避免将真实服务器信息、本地操作历史等内容带入公开仓库。

---

## 安全提示

- 请确认目标主机、SSH 用户和密钥来源可信
- 批量执行命令前，建议先对单台主机验证结果
- `upgrade`、`reboot` 等命令具有实际影响，请谨慎使用
- 若使用公开仓库，请勿提交真实 IP、私钥路径及敏感运维习惯配置
