# beidou-devops（北斗私服开发运维）

北斗 v83 私服（BeiDou-Server，Cosmic/HeavenMS 分支）日常开发运维的**完整操作手册**：从服务端改数据 → 同步客户端 → 编译重启 → 验证的端到端流程，以及本次实战中踩过的**关键坑**。

适用于：新增/修改 NPC、技能、装备、道具；改地图站位；发放入口道具；服务端系统开发。

## 环境速查

| 项 | 位置 |
|---|---|
| 服务端仓库 | `F:\beidou\BeiDou-Server`（git 分支 `agents/check-compile`） |
| 客户端 | `F:\beidou\BeiDou-Client`（Data=中文基础，EN=英文覆盖，config.ini SwitchChinese=true → 只读 Data） |
| 服务端 wz | `gms-server/wz/`（英文基础）+ `gms-server/wz-zh-CN/`（中文覆盖，优先加载） |
| 服务端脚本 | `gms-server/scripts/` + `gms-server/scripts-zh-CN/`（按语言加载，zh-CN 优先） |
| 编译 | `$env:Path` 前置 Maven 3.9.16（`.tools\maven\apache-maven-3.9.16\bin`），`mvn -pl gms-server -DskipTests package` |
| 启动 | `java '-Dspring.config.location=application.yml' -jar target\BeiDou.jar`（workdir=gms-server，后台运行） |
| WZ 补丁工具 | `.tools\orange-wz-cli\target\xml-img-patcher.jar`（fat jar，免 exe；360 会删 exe，jar 稳） |
| MySQL | `F:\mysql-8.0.39-winx64\NapMysqlTool\mysql-8.0.39-winx64\bin\mysql.exe -uroot -proot beidou` |
| 脚本解析 | Node（`node --check` 可验证 .js 语法） |

## 关键架构事实（决定改动方式）

- **伤害由客户端计算**：服务端只做上限校验（`calcDmgMax`）。改伤害/熟练度/命中要改**客户端 Skill.wz**（`Data/Skill/*.img`），服务端 `wz/Skill.wz/*.img.xml` 同步保持一致。
- **NPC 渲染位置 = 服务端 spawn 封包**（`SPAWN_NPC` 发 x/cy/fh/rx0/rx1），客户端用 **fh（foothold 全局段编号）找地面吸附 NPC**。小地图用 x 原始值、渲染用 fh → 两者会不一致。
- **NPC 外观数据只在客户端**：服务端 `wz/Npc.wz/*.img.xml` 只是占位（无 PNG），客户端 `Data/Npc/*.img` 才是真实外观。服务端只读 `String.wz/Npc.img` 里的名字。
- **服务端启动读外部 wz 目录**（不是 jar 内）：改 `gms-server/wz/` 下 XML 后重启服务端即生效，无需重新打包（但改了 Java 代码必须重打包）。
- **脚本每次点击重新编译**：改 `scripts/npc/*.js` 后玩家重新点 NPC 即生效，无需重启服务端。
- **wz 加载分层**：`wz/`（英文）↔ 客户端 `EN/`；`wz-zh-CN/`（中文）↔ 客户端 `Data/`。改中文显示改 wz-zh-CN + Data。

## 标准流程 1：改服务端数据 → 同步客户端

服务端 XML 是源，客户端 img 靠 xml-img-patcher 同步（**不直接复制 XML**）。

```powershell
# 1. 改服务端 XML（gms-server/wz 或 wz-zh-CN）
# 2. 提交 git（export 基于 git diff）
git add ...; git commit -m "..."
# 3. 导出该提交的 diff + full-xml
java -jar ".tools\orange-wz-cli\target\xml-img-patcher.jar" export `
  --repo="F:\beidou\BeiDou-Server" --from=<父commit> `
  --prefix="gms-server/wz" --prefix="gms-server/wz-zh-CN" `
  --out-diff="...\diff" --out-xml="...\xml"
# 4. 打客户端（中文 diff → Data，英文 diff → EN）
java -jar "...\xml-img-patcher.jar" patch `
  "F:\beidou\BeiDou-Client\Data\...\xxx.img" `
  "...\diff\wz-zh-CN\...\xxx.img.xml.diff" "...\out\xxx.img" `
  --full-xml="...\xml\wz-zh-CN\...\xxx.img.xml"
# 5. 覆盖回客户端 + 验证（dump-xml 检查）
```

**⚠️ 最重要的坑（踩过）**：`export` 默认 `--context=30` 会让 hunk 从文件头开始，DiffParser 把根 `<imgdir name="X.img">` 压栈 → 路径带根前缀 → ADD 产生**重复根节点**（客户端 img 损坏）。**必须 `--context=2` 导出**，hunk 从文件内部开始才安全。

**单行 XML 的坑**：部分装备 XML 是单行压缩格式（git diff 整行替换），DiffParser 无法解析出 MODIFY → patch 报"0 changes"。这类文件改用 **sync 节点级对比**（见下）或**手工构造带上下文的 MODIFY diff**。

**sync（节点级，最可靠）**：
```powershell
java -jar "...\xml-img-patcher.jar" sync --repo="F:\beidou\BeiDou-Server" `
  --ref=HEAD --prefix="gms-server/wz/技能相关路径" `
  --client="F:\beidou\BeiDou-Client" --out="...\sync_out" --mode=trust --dry-run
```
- 先 `--dry-run -v` 看改动范围；`ok` 数量少说明差异小
- sync 全量会同步所有差异（可能 2 万+处），**用 `--prefix` 限定目录**，或只对必要文件处理
- `--mode=trust` 消除 third-default review 噪音

## 标准流程 2：改装备数值（reqLevel/属性）——手工 MODIFY diff

装备 XML 是单行格式，文本 diff 打不了。**手工构造 MODIFY diff**（参照 `fix_reqlevel.js` 模式）：

```js
// 1. dump 客户端 img 拿 reqLevel 行号和上下文
// 2. 构造 unified diff：hunk 带 reqLevel 前后 2 行上下文，-旧行 +新行
// 3. patch 到客户端 img
```
已验证可行的脚本模式在 `.tools\scripts\fix_reqlevel.js`（改 reqLevel 用）、`.tools\scripts\buff_mastery.js`（批量改技能 mastery 用）。**核心**：每个字段一个 hunk、带上下文、按行号操作，别一次塞太多 hunk（patch 解析会失败）。

## 标准流程 3：新增/修复自定义 NPC

自定义 NPC 完整链路（踩过"进自由市场无效指针崩溃"和"NPC 渲染重叠"两个大坑）：

1. **外观 img**（客户端 `Data/Npc/<id>.img`）：必须**完整有效**（有真实 PNG 动画帧）。残缺（1×1 占位 canvas）会让客户端崩溃。最稳做法：**复制一个正常 NPC 的 img**（如 9030000 仓库管理员，36KB 有完整帧）。
2. **名称**（服务端 `wz/String.wz/Npc.img.xml` + `wz-zh-CN`，客户端 `Data/String/Npc.img`）：必须有 `name` 字段，缺失会崩溃/显示 MISSINGNO。中英文都要。
3. **站位**（服务端 `wz/Map.wz/Map/Map9/<map>.img.xml` 的 life 节点 + 客户端同步）：x/y/cy/fh/rx0/rx1。
4. **⚠️ fh 是关键**：fh 是**foothold 全局段编号**（整个地图所有 seg 从 1 计数），不是 layer/line。**fh 指向错误地面 → 客户端把 NPC 吸附到错误段 → 多个 NPC 渲染重叠**（小地图分散但画面挤一起）。算 fh 的方法：dump 客户端地图 img，遍历 foothold 数全局 seg 序号，找目标 x/y 所在段的序号。
5. **脚本**（`scripts/npc/<id>.js` + zh-CN）：必须有标准 `start()` 和 `action(mode, type, selection)`。
6. **脚本菜单坑**：菜单状态变量（如 beautyMode）初始 -1 时，`action` 里若用 `if (state >= 0)` 门槛会**挡住首次点击**（第一次选择直接 dispose 没反应）。入口应无条件转发到 action 处理函数。

## 标准流程 4：道具自动发放（登录补发 + 创建入包）

双通道发放，保证老角色和新角色都有：

```java
// 登录补发（PlayerLoggedinHandler，参照 CollectionService.COLLECTOR_BELT 模式）
if (!player.haveItem(道具ID)) {
    if (InventoryManipulator.addById(c, 道具ID, (short) 1)) {
        player.dropMessage(5, I18nUtil.getMessage("PlayerLoggedinHandler.message.xxx"));
    }
}

// 创建入包（CharacterFactory.createNewCharacter，insertNewChar 前）
Item item = new Item(道具ID, (short) 0, (short) 1);
newCharacter.getInventory(InventoryType.USE).addItem(item); // 消耗品→USE，装备→EQUIP，其它→ETC
```
- 装备用 `ii.getEquipById(id)`；普通消耗品/其它用 `new Item(id, (short)0, (short)1)`（**别用 getEquipById 做非装备**）
- i18n 消息：`src/main/resources/i18n/message_zh_CN.properties` + `message_en_US.properties` 各加一条

## 标准流程 5：服务端系统开发

- **登录补发/发放**：PlayerLoggedinHandler（改完重打包重启）
- **动态属性加成**（如收藏家腰带）：Character.reapplyLocalStats 里按装备判断
- **服务类**：`org.gms.server.*Service` 单例 + DB 直连（DatabaseConnection），脚本用 `Java.type("...").getInstance()` 调用
- **数据库迁移**：`src/main/resources/db/migration/V1.11.x__*.sql`，改已发布迁移会 checksum mismatch，**新需求用新版本号**
- **改 Java 必须**：停服务端（jar 锁定）→ `mvn package` → 重启

## 常用验证

```powershell
# 客户端 img 内容检查
java -jar ".tools\orange-wz-cli\target\xml-img-patcher.jar" dump-xml "客户端.img" "out.xml"
# 服务端加载坐标确认（临时在 MapFactory.loadLifeRaw 加 println，重启看日志，用完删）
# 脚本语法
node --check "gms-server\scripts\npc\xxx.js"
# 数据库
mysql -uroot -proot beidou -e "SELECT ..."
```

## git 工作流

- 分支 `agents/check-compile`，推送需先配代理：`git config --global http.proxy http://127.0.0.1:6382`（系统代理端口，网络不通 GitHub 时）
- push 前 `git fetch origin` + `git rebase origin/agents/check-compile`（若远程有新提交）
- gms-ui 的 `.yarn/`、`.yarnrc.yml`、`package.json`、`yarn.lock` 是环境噪音，**不提交**

## 本次实战中沉淀的脚本（.tools\scripts\）

| 脚本 | 用途 |
|---|---|
| `export_skills.js` / `md2html.js` | 技能清单生成（解析 Skill.wz + String.wz → md/html） |
| `buff_mastery.js` | 批量改技能 mastery 值（每 2 级 +7 模式） |
| `buff_extra.js` | 给技能加 speed/pad/eva 字段（安全版：行号倒序插入） |
| `fix_reqlevel.js` | 装备 reqLevel 批量修改（手工 MODIFY diff） |
| `check_client*.js` / `verify_*.js` | 客户端数据核对脚本（根节点数、字段值） |
