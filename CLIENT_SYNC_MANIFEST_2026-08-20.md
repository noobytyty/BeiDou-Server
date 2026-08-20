# BeiDou Client Sync Manifest

日期：2026-08-20
仓库：`noobytyty/BeiDou-Server`
用途：供客户端迁移 AI、XML/IMG 补丁工具和人工验收使用。

## 1. 同步结论

- 服务端 Java 编译：通过。
- 服务端 WZ XML：新增装备 XML 已通过 Java XML parser 解析。
- 客户端当前没有源码，只有 XML 转换后的 `.img`。
- 本文件只描述客户端同步内容；Java、SQL、脚本不需要复制到客户端。
- 当前没有生成客户端 `.img` 补丁。

## 2. 必须同步：虚拟背包入口道具

服务端新增两个入口道具：

| Item ID | 名称 | 中文名称 | 用途 |
|---:|---|---|---|
| `2430011` | Scroll Satchel | 卷轴背包 | 打开虚拟卷轴背包 |
| `2430012` | Ore Satchel | 矿石背包 | 打开虚拟矿石背包 |

### 服务端源文件

- `gms-server/wz/Item.wz/Consume/0243.img.xml`
- `gms-server/wz/String.wz/Consume.img.xml`
- `gms-server/wz-zh-CN/String.wz/Consume.img.xml`

### 客户端目标

- `Data/Item/Consume/0243.img`
- `Data/String/Consume.img`
- `EN/Item/Consume/0243.img`（如果客户端 EN 层包含该文件）
- `EN/String/Consume.img`

### 验收要求

- 两个道具名称、描述、图标均不为空；
- Data 层显示中文名称；
- EN 层显示英文名称；
- 客户端可正常拾取、使用和显示道具；
- 客户端原生背包不需要新增分页，入口是普通消耗品。

## 3. 必须同步：装备等级要求和新装备

### 3.1 已修改等级要求

以下装备只修改了服务端 `reqLevel`，名称和外观资源已经存在：

| Item ID | 新等级要求 | 服务端 XML |
|---:|---:|---|
| `1003068` | 120 | `wz/Character.wz/Cap/01003068.img.xml` |
| `1003715–1003718` | 100 | `wz/Character.wz/Cap/01003715.img.xml` – `01003718.img.xml` |
| `1003719–1003722` | 140 | `wz/Character.wz/Cap/01003719.img.xml` – `01003722.img.xml` |
| `1003797–1003801` | 160 | `wz/Character.wz/Cap/01003797.img.xml` – `01003801.img.xml` |
| `1042254–1042258` | 160 | `wz/Character.wz/Coat/01042254.img.xml` – `01042258.img.xml` |

客户端目标目录：

```text
Data/Character/Cap/
Data/Character/Coat/
```

这些装备的客户端名称、图标和外观已存在，不要重复 ADD 名称节点；优先生成 MODIFY diff。

### 3.2 新增装备：Reinforced Chaos Zakum Helmet

| 字段 | 值 |
|---|---|
| Item ID | `1003113` |
| 名称 | Reinforced Chaos Zakum Helmet |
| 等级要求 | 120 |
| 全属性 | `+30` |
| 物防/魔防 | `+240/+240` |
| 升级次数 | 8 |
| 源 XML | `gms-server/wz/Character.wz/Cap/01003113.img.xml` |

该 XML 是从已有 `1003112 Chaos Zakum Helmet` 完整复制后调整属性，包含有效的 `icon`、`iconRaw`、外观和装备结构，不是空白装备。

客户端目标：

```text
Data/Character/Cap/01003113.img
```

名称源：

```text
gms-server/wz/String.wz/Eqp.img.xml
```

客户端目标：

```text
Data/String/Eqp.img
EN/String/Eqp.img
```

新增名称节点：

```text
1003113 = Reinforced Chaos Zakum Helmet
```

建议中文客户端名称：

```text
1003113 = 强化混沌扎昆头盔
```

### 3.3 当前已接入 Maker 的装备

以下装备已有服务端 Maker 配方：

```text
1003068
1003112
1003113
1003715–1003722
1003797–1003801
1042254–1042258
```

客户端只需要同步 WZ/IMG 数据，不需要同步 SQL 或 Java。

## 4. 不需要新增客户端资源：通用 Boss 锻造代币

通用锻造代币复用已有道具：

```text
4001083 Zakum Certificate
```

因此不需要新增 Item ID、图标或 String 节点。

新增服务端掉落的 Boss：

```text
8500002 Papulatus：1–2
8510000 Pianus：1–2
8520000 Pianus：1–2
8800002 Zakum：2–3
8810018 Horntail：3–4
```

客户端只需确认现有 `4001083` 的图标和名称正常。

## 5. 重要事实修正：Ravana

当前 WZ/脚本中没有 Ravana Boss：

- `8510000` 是 Pianus，不是 Ravana；
- 仓库没有 Ravana 怪物、地图或战斗脚本；
- `1003068 Ravana Helmet` 现在通过 Maker 获取；
- 错误的 `Pianus -> Ravana Helmet` 掉落由 `V1.11.21` 删除。

Ravana Helmet 配方迁移：

```text
gms-server/src/main/resources/db/migration/V1.11.22__add_ravana_helmet_maker_recipe.sql
```

## 6. 服务端专属变更，不同步客户端

以下内容只在服务端生效：

- 虚拟背包 Java 服务、角色存档和自动收纳；
- 虚拟背包 NPC/道具脚本；
- Maker 材料检查和虚拟背包扣除；
- Maker 装备品质和词条生成；
- Boss 代币掉落；
- 收藏系统统计；
- 怪物卡收集进度提示；
- Beauty/Bounty/MapleMap 等既有服务端修复；
- Flyway 数据库迁移。

## 7. Flyway 执行顺序和风险

相关迁移按以下顺序执行：

```text
V1.11.19__create_character_virtual_inventory.sql
V1.11.20__add_candidate_equipment_maker_recipes.sql
V1.11.21__add_boss_forge_token_drops.sql
V1.11.22__add_ravana_helmet_maker_recipe.sql
```

注意：

- `V1.11.20` 在本次工作中经过多次调整；
- 如果该迁移已经在数据库执行过，Flyway 可能出现 checksum mismatch；
- 正式部署前应查询 `flyway_schema_history`；
- 已执行的迁移不要直接改文件，应新增修正迁移；
- 本文件不代表数据库迁移已经在真实 MySQL 执行。

## 8. IMG 补丁操作要求

1. 先对服务端 XML 与客户端现有 IMG 做 dry-run；
2. `1003113` 是新节点，确认客户端对应 IMG 没有同名节点后再 ADD；
3. 已存在的装备等级修改使用 MODIFY，不要重复 ADD；
4. `String/Eqp.img` 的 `1003113` 在 Data 和 EN 层分别确认；
5. 虚拟背包入口道具使用已有 `0243.img`，避免覆盖其他消耗品节点；
6. 补丁后检查图标、名称、描述、装备属性和穿戴外观；
7. 不要把服务端 XML 文件直接复制给客户端，客户端需要转换后的 `.img`。

## 9. 尚未同步的后续候选

以下装备目前只有 WZ 候选或已有资源，尚未作为本次客户端必同步内容：

```text
1042365 Ruby Clover T-shirt
1042366 Sapphire Clover T-shirt
Timeless 武器系列
Timeless Earrings / Pendant
1142591–1142595 Cygnus Constellation
其他 120–155 级职业武器、防具和饰品
```

这些候选需要先确认数据库掉落、商店、任务和客户端 IMG 状态，再单独制作补丁。
