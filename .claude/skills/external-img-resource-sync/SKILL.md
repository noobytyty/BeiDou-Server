# external-img-resource-sync（外部 IMG 资源接入）

把外部获得的 MapleStory v83 `.img` 资源安全接入 BeiDou-Server 与实际客户端的端到端流程。

适用于：

- 外部运行版客户端提供的完整 `Character`、`Npc`、`Map`、`String`、`Skill`、`Etc` 等 IMG；
- 服务端缺少某个装备外观、现金武器动作、披风/帽子动画或商城 String；
- 需要将外部 IMG 的结构同步到服务端 XML，并应用到实际客户端；
- 需要确认商城预览、装备外观、技能效果或 NPC 显示是否真正生效。

本 Skill 的核心原则：

> **完整二进制 IMG 是外部资源的事实来源；服务端 XML 是服务端数据来源；实际客户端 IMG 是玩家运行时显示的事实来源。三者必须分别验证，不能用其中一个代替另外两个。**

## 1. 必须先确认的输入

执行前必须明确以下路径：

```text
SERVER_ROOT = BeiDou-Server 仓库根目录
SERVER_WZ   = SERVER_ROOT/gms-server/wz
CLIENT_ROOT = 玩家实际运行的 BeiDou-Client 根目录
SOURCE_IMG  = 外部运行版客户端或资源包中的完整 .img
PATCHER     = xml-img-patcher.jar 或 xml-img-patcher.exe
WORK_ROOT   = 本次临时工作目录
BACKUP_ROOT = 客户端 Data/EN 备份目录
```

要求：

- `CLIENT_ROOT` 必须是玩家实际启动的客户端资源目录；
- 不要使用 `SERVER_ROOT/beiDOU/BeiDou-Client` 判断实际客户端状态；
- 外部 IMG 来源必须明确版本、语言层、客户端版本和是否经过二次修改；
- 写入正式客户端前必须备份对应 `Data/`、`EN/` 和目标 IMG；
- 外部二进制资源不得上传到第三方服务或不可信在线转换网站；
- 不要把外部完整 IMG 直接提交到服务端仓库，除非该仓库明确允许二进制资源。

## 2. 资源路径映射

### 2.1 服务端 XML 与客户端 IMG

```text
服务端 SERVER_WZ/Character.wz/Weapon/017xxxxx.img.xml
客户端 CLIENT_ROOT/Data/Character/Weapon/017xxxxx.img

服务端 SERVER_WZ/Character.wz/Cape/011xxxxx.img.xml
客户端 CLIENT_ROOT/Data/Character/Cape/011xxxxx.img

服务端 SERVER_WZ/Character.wz/Cap/010xxxxx.img.xml
客户端 CLIENT_ROOT/Data/Character/Cap/010xxxxx.img
```

Character 外观资源通常是语言无关资源，优先同步到客户端 `Data/Character/`。
不要因为存在 `EN/` 目录就把所有 Character IMG 复制一份到 `EN/`；本项目客户端约定
`EN/` 主要是文本覆盖层，最终以实际客户端加载规则为准。

### 2.2 文本资源

```text
服务端 SERVER_WZ/String.wz/*.img.xml
客户端 CLIENT_ROOT/EN/String/*.img

服务端 SERVER_WZ-zh-CN/String.wz/*.img.xml
客户端 CLIENT_ROOT/Data/String/*.img
```

中文覆盖层不完整时必须做节点级合并，不能用不完整中文文件替换客户端完整 String IMG。

### 2.3 常见 ItemId 到 Character 文件名

现金武器：

```text
ItemId 1702118 -> Character/Weapon/01702118.img
```

规则通常是：

```text
170xxxx -> 017xxxx
```

普通披风：

```text
ItemId 1102912 -> Character/Cape/01102912.img
```

普通帽子：

```text
ItemId 1002509 -> Character/Cap/01002509.img
```

实际文件名必须以外部客户端和现有目录为准，不要仅凭字符串拼接创建文件。

## 3. 先判断资源属于哪一种情况

### A. 客户端已有 IMG，服务端 XML 缺失或过旧

流程：

```text
客户端 IMG
  -> dump-xml
  -> 服务端 XML
  -> 按仓库约定整理/修改
  -> 服务端启动验证
```

适用于外部客户端已经拥有完整图片/动画，但服务端缺少 `islot`、`vslot`、动作根节点
或装备基础数据的情况。

### B. 服务端 XML 有，客户端 IMG 缺失

如果 XML 只包含 `imgdir`、`int`、`string`、`vector`，但没有完整 PNG/Canvas/Sound
数据，不能凭 XML 创建真实外观。

必须：

```text
从相同版本的运行版客户端取得完整 IMG
  -> 复制到客户端 Data 对应目录
  -> dump-xml 与服务端 XML 对照
  -> 用节点同步工具合并服务端需要的结构
```

### C. 服务端和客户端都有，但显示/预览不一致

必须分别检查：

1. Commodity `SN -> ItemId`；
2. String 名称/描述；
3. Character IMG 是否完整；
4. `info/cash`；
5. `info/islot`、`info/vslot`；
6. UOL 引用目标是否存在；
7. 实际客户端使用的是 `Data` 还是 `EN` 覆盖层；
8. 服务端发放的 ItemId 是否等于客户端预览的 ItemId。

## 4. 外部 IMG 接入流程

### 第一步：建立来源清单

每个外部资源必须记录：

```text
resource_type: Weapon / Cape / Cap / String / Skill / Npc / Map
item_id:
file_name:
source_client_version:
source_language_layer:
source_path:
target_client_path:
server_xml_path:
reason:
```

现金装备至少记录：

```text
SN
ItemId
装备类型
是否在售
需要支持的武器类型
客户端预览是否失败
实际装备是否失败
```

### 第二步：备份实际客户端

```text
BACKUP_ROOT/Data/
BACKUP_ROOT/EN/
```

至少备份：

- 目标 IMG；
- `String` 对应 IMG；
- `Etc/Commodity.img`；
- 任何可能被同步的关联 IMG。

备份目录必须带时间和来源标识，例如：

```text
backup/2026-09-09-before-halloween-img/
```

### 第三步：检查外部 IMG 完整性

不要只检查文件存在。必须确认：

- 文件可以被客户端 WZ 工具打开；
- 文件大小不是明显的空壳或占位文件；
- 具有真实 Canvas/PNG/Sound/UOL 数据；
- 根节点和目标 ItemId 对应；
- 没有损坏的 UOL、Vector 或引用路径；
- 与当前客户端 WZ 加密/版本兼容。

外部 IMG 如果只有 1×1 占位 Canvas、没有实际帧，不能用于正式客户端。

### 第四步：导出外部 IMG XML

```bash
java -jar "$PATCHER" dump-xml \
  "$SOURCE_IMG" \
  "$WORK_ROOT/source.xml"
```

如果只需要结构检查，优先使用跳过二进制资源的 XML。
如果需要保留完整外观，必须保留原始 IMG，不要用 dump 出来的 XML 重建 IMG。

### 第五步：对照服务端 XML

逐项比较：

```text
info/islot
info/vslot
info/cash
info/reqJob
info/reqLevel
动作根节点
动作帧编号
UOL 引用
String name/desc
```

## 5. 现金武器专项规则

现金武器 `170xxxx` 是外观物品，不是实际攻击武器。

客户端通过 `Character/Weapon/017xxxx.img` 的数字根节点决定兼容的真实武器类型。

常见根节点：

| 根节点 | 武器类型 |
|---:|---|
| `30` | 单手剑 |
| `31` | 单手斧 |
| `32` | 单手钝器 |
| `33` | 短刀 |
| `37` | 短杖 |
| `38` | 长杖 |
| `40` | 双手剑 |
| `41` | 双手斧 |
| `42` | 双手钝器 |
| `43` | 枪 |
| `44` | 矛 |
| `45` | 弓 |
| `46` | 弩 |
| `47` | 拳套 |
| `48` | 指虎 |
| `49` | 手枪 |

检查要求：

- 不要把 `info/islot=Wp` 或 `WpSi` 当作完整兼容证明；
- 必须按实际需要检查数字根节点；
- 只补缺失节点时，优先复制同一文件已有的对应动作结构；
- 不要把一个只适合弓的动作节点强行复制给所有武器；
- 新增动作节点后必须验证普通攻击、移动、跳跃、技能攻击和商城预览；
- 客户端实际缺完整 IMG 时，不能只加 XML 节点。

## 6. 披风、帽子和普通现金装备专项规则

披风、帽子等不是 `170xxxx` 现金武器，不能套用武器动作规则。

必须检查：

```text
Character/Cape/011xxxxx.img
Character/Cap/010xxxxx.img
info/cash = 1
info/islot
info/vslot
walk/stand/alert 等动作
```

常见问题：

- `islot/vslot` 不匹配导致装备后无外观；
- Character IMG 存在但 Canvas 帧缺失；
- Commodity ItemId 与 String/Eqp 节点不是同一物品；
- Data/EN 覆盖层把完整资源覆盖成了旧版本；
- 预览资源存在，但客户端实际运行的 WZ 目录不是同步目标目录。

## 7. Commodity、String 与实际发放一致性

每个商城装备必须同时验证：

```text
Commodity.SN
Commodity.ItemId
String/Eqp name
String/Eqp desc
Character 外观 IMG
```

服务端购买链路是：

```text
客户端发送 SN
  -> 服务端 Commodity 查 SN
  -> 取得 ItemId
  -> 创建/发放 ItemId
```

因此：

- 客户端展示的 Commodity 和服务端 Commodity 必须同版本；
- 服务端数据库覆盖字段不能把一个 SN 的 ItemId 改成另一个物品；
- `SN`、`ItemId`、String 和 Character 资源必须一起对照；
- 不能只修商品名称而不修实际发放 ItemId。

## 8. 同步工具选择

### 已有 IMG 节点修改：优先 `sync`

```bash
java -jar "$PATCHER" sync \
  --server="$SERVER_WZ" \
  --client="$CLIENT_ROOT" \
  --out="$WORK_ROOT/sync" \
  --dry-run
```

确认变更范围后：

```bash
java -jar "$PATCHER" sync \
  --server="$SERVER_WZ" \
  --client="$CLIENT_ROOT" \
  --out="$WORK_ROOT/sync"
```

### Git 增量同步：使用 `export + patch`

```bash
java -jar "$PATCHER" export \
  --repo="$SERVER_ROOT" \
  --from=<父提交或时间> \
  --out-diff="$WORK_ROOT/diff" \
  --out-xml="$WORK_ROOT/full-xml" \
  --context=2
```

然后：

```bash
java -jar "$PATCHER" batch \
  --full-xml-dir="$WORK_ROOT/full-xml" \
  <客户端img目录> \
  "$WORK_ROOT/diff" \
  "$WORK_ROOT/patched" \
  --dry-run
```

检查无误后再正式生成。

### 目标 IMG 不存在

```text
不要用 XML 凭空生成 IMG。
从同版本运行版客户端取得完整 IMG。
复制完整 IMG 后，再使用 sync 合并服务端结构。
```

## 9. ADD/MODIFY/重复节点安全规则

`patch` 的 `ADD` 是追加/合并，不是覆盖。

执行前必须：

1. 使用 `--dry-run`；
2. 检查目标 IMG 是否已有同名子树；
3. 如果已有同名节点，优先使用 `sync`；
4. 不要对已有根节点重复执行 ADD；
5. 不要把服务端 XML 直接复制为客户端 IMG；
6. 不要覆盖未涉及的 PNG、Canvas、Sound、UOL、Vector。

## 10. 服务端接入

### 外部 IMG 只用于客户端显示

如果服务端只需要显示名称/描述或读取基础属性：

```text
从 IMG dump 出服务端 XML
  -> 放入对应 SERVER_WZ 路径
  -> 保留 AGPL 文件头和仓库格式
  -> 重启服务端
```

### 外部 IMG 含完整外观

```text
客户端：放入实际 Data/Character 或 Data/String
服务端：只同步可读的 XML 数据
```

服务端不能从没有真实二进制 Canvas 的 XML 渲染客户端外观。

## 11. 验证清单

### 服务器侧

```bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"
mvn -pl gms-server -DskipTests compile
git diff --check
```

检查：

- XML 可以解析；
- 服务器重启后不报 WZ 加载错误；
- Commodity 的 SN/ItemId 不错位；
- 外观装备可以正常存档、交易、转移和删除；
- 不存在的资源不会被商城加载。

### 客户端资源侧

```bash
java -jar "$PATCHER" verify <patched.img> <diff> <full-xml-dir>
```

检查：

- `miss=0`；
- dump-xml 后节点与目标一致；
- 原始 IMG 的 PNG/Canvas/Sound/UOL 仍存在；
- Data/EN 只修改预期文件。

### 游戏内实测

每个资源类别至少抽测：

```text
商城打开商品详情
商品预览
购买
领取到角色背包
装备
移动/站立/攻击/跳跃
换频道
重新登录
卸下、交易、丢弃或删除
```

现金武器还要分别测试：

```text
单手剑、双手剑、单手斧、双手斧、短杖、长杖、弓、弩、枪、矛、拳套、指虎、手枪
```

## 12. 失败处理和停止条件

以下情况必须停止正式写入并保留备份：

- 外部 IMG 无法打开；
- 目标 IMG 不是同版本；
- `sync --dry-run` 显示大量非预期改动；
- 出现根节点重复；
- `verify` 有 miss；
- 客户端出现预览黑屏、装备不显示、闪退；
- Commodity SN/ItemId 对不上；
- 外部资源来源不明或疑似损坏。

遇到失败时保留：

```text
原始 IMG
dump XML
dry-run 日志
verify 日志
资源来源和版本信息
```

不要直接删除客户端原资源，也不要通过盲目补节点掩盖版本不一致。

## 13. 最终交付记录

每次资源接入完成后记录：

```text
资源名称:
资源类型:
ItemId/NpcId/SkillId:
来源客户端版本:
服务端 XML 路径:
实际客户端目标 IMG:
Data/EN 层:
是否使用 sync 或 patch:
dry-run 结果:
verify 结果:
服务端编译结果:
游戏内测试结果:
已知限制:
```
