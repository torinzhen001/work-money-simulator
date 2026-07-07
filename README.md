# 上班收钱模拟器

一个哄自己每天开心上班的小工具：点上班开始按分钟入账，可暂停、摸鱼，记录历史、按月统计，支持多设备云同步。

## 在线地址
https://torinzhen001.github.io/work-money-simulator/

- 任意电脑：浏览器打开上面网址即可用。
- 手机：打开网址，浏览器菜单选「添加到主屏幕」当 App 用。
- 微信：把链接发到聊天/收藏，点开即用。

## 唯一真源
本仓库的 `index.html` 是唯一真源。**只在这里编辑**，不要再改其它地方的副本。

## 在任何电脑上修改

### 方式 A：GitHub 网页直接改（零安装）
1. 打开仓库 → 点开 `index.html` → 右上角铅笔图标编辑
2. 底部 Commit changes
3. 几分钟后网站自动更新

### 方式 B：克隆到本地改
```powershell
git clone https://github.com/torinzhen001/work-money-simulator.git
cd work-money-simulator
# 编辑 index.html ……
./publish.ps1 "这次改了什么"
```
`publish.ps1` 会自动先拉取最新，再提交并推送，避免多台电脑冲突。

## 云同步（多设备共享同一份数据）
- 后端：Supabase（免费）。建库脚本见 `supabase-setup.sql`（只需运行一次）。
- 用法：在应用「设置与记录 → 云同步」里点「生成同步码并开启」，把同步码记好；在其它设备粘贴同步码点「连接并下载」即可同步。
- 安全：数据靠同步码保护，请勿把同步码写进代码或公开分享。

## 文件说明
- `index.html` — 应用本体（单文件，含界面 + 逻辑 + 云同步）
- `publish.ps1` — 一键发布脚本
- `supabase-setup.sql` — 云同步建库脚本（一次性）
