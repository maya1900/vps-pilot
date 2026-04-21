# VPS Pilot 开发文档

## 1. 目标

`VPS Pilot` 当前的核心定位，是把多台 VPS 的连接、巡检、批量执行、容器操作统一收口到本地命令行里。

下一阶段重点补两条工作流：

1. 远程文件工作流
2. 本机诊断与 AI 运维工作流

## 2. 一期范围

一期先落地三个命令：

1. `vps ssh-config sync`
2. `vps code <name> [path]`
3. `vps backup <name> <path>`
4. `vps doctor <name> [service|container]`

### 2.1 `ssh-config sync`

目标：

- 根据 `servers.conf` 自动生成本机 `~/.ssh/config` 的托管区块
- 让 `oc1`、`oc2` 这样的别名可直接被 SSH 和 VS Code Remote-SSH 识别
- 保留用户自己的其它 SSH 配置，不覆盖非托管内容

实现策略：

- 采用标记块写入：
  - `# >>> VPS Pilot managed hosts >>>`
  - `# <<< VPS Pilot managed hosts <<<`
- 每次同步先移除旧托管块，再生成新块
- 默认写入 `~/.ssh/config`
- 支持环境变量 `VPSCTL_SSH_CONFIG_FILE` 覆盖输出路径，方便测试

### 2.2 `code`

目标：

- 在本机直接打开远程机器目录
- 优先兼容 VS Code Remote-SSH，而不是自己重复造 SFTP 编辑器

实现策略：

- 命令形态：
  - `vps code oc1`
  - `vps code oc1 /opt/app`
  - `vps code oc1 /etc/nginx --backup`
- 执行前自动同步托管 SSH 配置
- 自动解析远程登录用户家目录
- 支持常见目录短写，如 `home`、`etc`、`opt`
- 最终调用：

```bash
code --remote "ssh-remote+<host_alias>" "<remote_path>"
```

补充：

- 如果 `code` 不在 `PATH`，脚本会尝试常见 macOS 安装路径
- 也支持通过 `VPSCTL_CODE_BIN` 指定实际路径

### 2.3 `backup`

目标：

- 在编辑高风险目录前，先保存一个可回滚的快照
- 避免 Remote-SSH “一保存就改远程” 带来的回退困难

实现策略：

- 命令形态：
  - `vps backup oc1 /etc/nginx`
  - `vps backup oc1 /opt/app/.env`
- 文件使用 `cp -a`
- 目录使用 `tar.gz`
- 备份落到远程 `~/.vps-pilot/backups/`

### 2.4 `doctor`

目标：

- 快速抓取一台机器上的系统状态、最近报错、服务状态、容器日志
- 在本地先给出规则诊断
- 如果用户配置了 AI，再补一层中文分析与修复建议

实现策略：

- 采集内容：
  - 基础系统信息
  - 磁盘、内存、负载
  - 失败服务
  - 最近错误日志
  - 端口监听
  - Docker 容器概览
  - 指定服务的 `systemctl status` / `journalctl`
  - 指定容器的 `docker inspect` / `docker logs`
- 分析分两层：
  - 本地规则分析
  - 可选 AI 分析

环境变量：

- `VPSCTL_AI_API_KEY`
- `VPSCTL_AI_MODEL`
- `VPSCTL_AI_API_URL`

## 3. 为什么一期不直接做 SFTP

一期先选 `Remote-SSH` 而不是自己维护同步逻辑，原因如下：

1. VS Code Remote-SSH 已经能覆盖“打开目录、编辑、搜索、终端”的主要需求
2. SFTP 双向同步、权限处理、冲突策略更容易做烂
3. 先把最常用路径打通，比一开始就做重功能更稳

后续如果确实需要“像本地挂载一样拖文件”，再补 `sshfs` / `mount` 方案。

## 4. 二期方向

### 4.1 对话式运维助手

规划命令：

```bash
vps chat <name>
```

目标：

- 像对话一样问机器问题
- 自动补上下文，不用每次手动执行一堆命令

### 4.2 远程挂载

规划命令：

```bash
vps mount <name> <remote_path>
vps unmount <name|mount_path>
```

候选实现：

- macOS / Linux：`sshfs`
- Windows：`SSHFS-Win` / `WinFsp`

### 4.3 诊断报告导出

规划命令：

```bash
vps doctor <name> --save
```

目标：

- 保存本次诊断原始信息
- 保存 AI 诊断结果
- 方便复盘和再次提问

## 5. 当前实现约束

1. 一期 `doctor` 只支持单机，不做多机联合诊断
2. 一期 `code` 只接 VS Code，不扩展到 Cursor、Windsurf 等编辑器
3. AI 接口先采用 OpenAI 兼容 `chat/completions`，不在一期引入复杂 SDK
4. 尽量保持 Bash 单文件实现，减少安装负担
