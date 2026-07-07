# chenni

## 本地安装可灵 MCP + CLI

在本机终端执行以下命令，一次性完成 **Cursor MCP** 与 **官方 Kling CLI** 安装：

```bash
bash scripts/setup-kling-local.sh
```

国内站账号请使用：

```bash
bash scripts/setup-kling-local.sh cn
```

### 脚本会做什么

1. 全局安装官方 CLI（`@klingai/cli-global` 或 `@klingai/cli-cn`）
2. 写入 `~/.cursor/mcp.json`，注册远程 MCP：`https://klingai.com/mcp`
3. 可选：立即运行 `kling login` 完成 CLI 授权

### 授权（需手动完成）

| 组件 | 授权方式 |
| --- | --- |
| Cursor MCP | Cursor Settings → MCP → 找到 `kling` → 点击 **Connect** → 浏览器登录可灵账号 |
| Kling CLI | 终端运行 `kling login`，在浏览器中授权 |

### 验证

```bash
kling --version
kling who_am_i
kling tool_list
```

在 Cursor 中确认 MCP 服务器 `kling` 显示为已连接（绿色）。

### 手动安装（可选）

**MCP** — 编辑 `~/.cursor/mcp.json`：

```json
{
  "mcpServers": {
    "kling": {
      "url": "https://klingai.com/mcp"
    }
  }
}
```

**CLI**：

```bash
# 海外站
npm i -g @klingai/cli-global

# 国内站
npm i -g @klingai/cli-cn
```
