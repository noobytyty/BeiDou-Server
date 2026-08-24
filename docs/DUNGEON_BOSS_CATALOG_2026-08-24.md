# 当前副本与 Boss 盘点（2026-08-24）

> 本文按仓库中的事件脚本、Boss 战脚本和现有 NPC/命令入口整理。
> “存在脚本”不等同于“已完成实机验证”，奖励、人数限制、重置时间和难度应在游戏内逐项确认。

## 一、主要 Boss 战

| Boss/玩法 | 相关脚本 | 当前判断 |
|---|---|---|
| 扎昆 | `ZakumBattle.js`、`ZakumPQ.js`、GM `ZakumCommand` | 有完整战斗/PQ脚本，需验证入场和奖励 |
| 暗黑龙王 | `HorntailBattle.js`、`HorntailPQ.js`、GM `HorntailCommand` | 有完整战斗/PQ脚本，需验证多阶段流程 |
| 闹钟（帕普拉图斯） | `PapulatusBattle.js` | 有 Boss 战脚本 |
| 品克缤 | `PinkBeanBattle.js` | 有 Boss 战脚本，需重点验证地图和阶段机制 |
| 巴洛古 | `BalrogBattle.js`、`BalrogBattle_Easy.js`、`BalrogQuest.js` | 普通/简单难度均有脚本 |
| 蝙蝠魔/斯卡里恩 | `ScargaBattle.js` | 有 Boss 战脚本 |
| 拉图斯相关海盗 Boss | `LatanicaBattle.js` | 有 Boss 战脚本 |
| 昭和相关 Boss | `ShowaBattle.js` | 有 Boss 战脚本 |

## 二、区域 Boss

仓库中存在以下区域 Boss 事件脚本：

- Bamboo、Centipede、Deo、Dyle；
- Eliza、Faust、Kimera、King Clang、King Sage Cat；
- Leviathan、Mano、Nine-Tailed Fox、Seruf、Snack Bar；
- Stumpy、Tae Roon、Timer、Zeno。

这些玩法更适合作为普通地图的周期性挑战，而不是终局装备来源。需要确认：

- 刷新时间和公告是否正常；
- Boss 是否会被重复击杀或误判；
- 掉落是否接入词缀生成；
- 是否有适合当前等级的奖励。

## 三、当前副本/PQ 脚本

### 经典组队任务

- Kerning PQ：`KerningPQ.js`
- 废弃都市/玩具城相关 PQ：`LudiMazePQ.js`、`LudiPQ.js`
- 组队任务：`HenesysPQ.js`、`OrbisPQ.js`、`EllinPQ.js`
- 阿里安特/玛加提亚：`MagatiaPQ_A.js`、`MagatiaPQ_Z.js`
- 艾纳斯：`ElnathPQ.js`
- 海盗 PQ：`PiratePQ.js`
- 宝藏 PQ：`TreasurePQ.js`
- 假日/咖啡馆活动：`HolidayPQ_1.js`–`HolidayPQ_3.js`、`CafePQ_1.js`–`CafePQ_6.js`

### 高级或多人玩法

- CWK PQ：`CWKPQ.js`
- 公会任务：`GuildQuest.js`
- 阿摩利亚结婚任务：`AmoriaPQ.js`
- Boss Rush：`BossRushPQ.js`
- 元素战斗：`ElementalBattle.js`
- 救援/塔防类玩法：`RescueGaga.js`、`TD_Battle1.js`–`TD_Battle5.js`

### 非传统副本/事件玩法

- Doll House、Guardian Nex、King Pepe and Yetis；
- Subway、Trains、Cabin、Elevator；
- Wedding Chapel、Wedding Cathedral；
- Maha、Rock Spirit、DelliBattle 等任务型战斗。

## 四、当前内容梯度设计（暂不实施）

后续装备词缀内容梯度暂定为：

```text
普通刷怪
  → 基础属性、资源、防御词缀和低阶粉末

普通 PQ/副本
  → 稀有/史诗装备、职业属性和攻击词缀

高级 PQ
  → 史诗/传奇装备、高阶职业组合和较高阶粉末

普通 Boss
  → 传奇装备、少量特殊词缀

高级/终局 Boss
  → 远古/神话装备、Boss/无视防御/元素路线和高价值粉末
```

这套方案目前只保存为设计方向，尚未修改任何掉落、品质、词缀权重或 Boss 难度。

## 五、后续核验清单

## 五、已实施的单人/双人入口调整

以下内容的最低入场人数已调整为 1 人，最高人数保持不变：

- `BalrogBattle_Easy.js`；
- `KerningPQ.js`、`LudiMazePQ.js`、`LudiPQ.js`；
- `HenesysPQ.js`、`OrbisPQ.js`、`EllinPQ.js`；
- `PiratePQ.js`、`TreasurePQ.js`；
- `MagatiaPQ_A.js`、`MagatiaPQ_Z.js`；
- `GuildQuest.js`；
- `CafePQ_1.js`–`CafePQ_6.js`；
- `HolidayPQ_1.js`–`HolidayPQ_3.js`。

这一步只放宽了入场门槛，没有降低怪物血量、伤害、计时或关卡机制。现已为上述脚本加入按实际参与人数记录的 `soloMode`/`duoMode`：

- 单人/双人只使用实际进入副本的角色，不创建伪造玩家；
- 离队、掉线和死亡判定按当前可用人数收敛，避免仍按原多人门槛结束副本；
- Orbis 的全职业状态同步在单人/双人时不再阻塞流程，其他机关继续保留原奖励、掉落、计时和难度；
- 三人及以上仍使用原多人逻辑。

这属于机制兼容调整，不改变怪物数值、奖励、掉落或计时；仍需实机逐关确认站位机关和答题流程。

### Kerning PQ 的单人/双人机关处理

Kerning PQ 已单独增加单人/双人简化逻辑：

- 实际参与人数不超过 2 人时，第 1 阶段答题/通行证机关以及第 2～4 阶段的绳索、平台、木桶组合机关自动判定通过；
- 副本仍保留地图推进、战斗、时间限制和最终奖励；
- 三人及以上继续使用原本的多人答题和站位逻辑；
- 该处理不依赖全局 `use_enable_stage_skip` 配置，避免管理员开启全局开关后才生效。

### Ludi PQ 与 Ludi Maze PQ 的单人/双人处理

- Ludi PQ 第 8 阶段原本要求 5 名队员分别站在箱子上验证组合；实际参与人数不超过 2 人时，队长与 NPC 对话会直接完成该阶段；
- Ludi PQ 其他收集、战斗、传送和最终奖励流程保持不变；
- Ludi Maze PQ 的主要目标是收集 30 个任务道具，不存在必须同时站位的核心机关，因此仅使用单人/双人人数兼容逻辑，不额外跳过收集目标；
- 三人及以上继续使用 Ludi PQ 原本的五箱组合机制。

### Henesys PQ 的单人/双人处理

Henesys PQ 的种子种植、收集月兔蛋糕和保护月兔流程可以由单个角色依次完成，不存在必须多人同时站位的核心机关。因此本轮只保留既有的单人/双人人数兼容逻辑，并修正入口 NPC 的错误提示；收集目标、战斗、计时和奖励不变。

### Orbis PQ 的单人/双人处理

- 单人/双人不再要求完整职业组合；
- 第 4 阶段原本要求 3 名角色同时站在 3 个平台上，现改为自动通过；
- 雕像部件收集、第 6 阶段双拉杆组合、Boss 战、计时和奖励保持不变；
- 三人及以上继续使用原本的职业组合和平台站位逻辑。

### Magatia PQ A/Z 的单人/双人处理

Magatia PQ 两条路线的文件收集、机关触发、NPC 对话、护送状态和 Yulete/Frankenroid 战斗均可由单个角色依次完成，没有发现必须多人同时操作的核心阶段。因此本轮保留既有的人数兼容逻辑，不额外跳过目标、战斗或奖励。

### Pirate PQ 的单人/双人处理

Pirate PQ 的阶段怪物、勋章收集、钥匙/宝箱和船舱封印都可以由单个角色依次完成，没有发现必须多人同时站位的核心阶段。因此本轮保留既有的人数兼容逻辑，不额外跳过战斗、收集或机关目标，并保留原本的 4 分钟时限和奖励。

### Treasure PQ 的单人/双人处理

Treasure PQ 的入口地图战斗、机关推进和最终 Boss 均可由单个角色依次完成，没有发现必须多人同步的核心条件。因此本轮保留既有的人数兼容逻辑，不额外跳过战斗或机关目标，并保留原本的 45 分钟主时限、10 分钟奖励阶段和奖励流程。

### Cafe PQ 1～6 的单人/双人处理

Cafe PQ 各关卡的核心是怪物刷新和优惠券收集，没有发现必须多人同时操作的机关或同步条件。因此本轮保留既有的人数兼容逻辑，不额外跳过收集目标或战斗，并保留各关卡原本的 45 分钟时限和奖励。

### Holiday PQ 1～3 的单人/双人处理

Holiday PQ 1～3 的核心是单地图战斗、活动道具掉落收集和 Boss 处理，没有发现必须多人同步的核心条件。因此本轮保留既有的人数兼容逻辑，不额外跳过战斗或收集目标，并保留原本的 15 分钟时限和奖励。

### Elnath PQ 的单人/双人处理

Elnath PQ 只有单地图战斗流程，没有需要多人同时站位或同步操作的核心机关。本轮补齐 `soloMode`/`duoMode` 记录，并让离队、掉线、死亡和离图判定按实际参与人数收敛；不跳过战斗、计时或奖励。

## 六、后续核验清单

1. 逐个确认 Boss 的入场 NPC、人数限制、冷却和重置方式；
2. 记录每个副本的推荐等级、实际耗时和失败成本；
3. 盘点各玩法的装备、粉末、金币和特殊道具奖励；
4. 确认脚本奖励装备是否都经过 `EquipmentAffixGenerator`；
5. 检查 Boss 战的召唤物、反射、持续伤害和阶段转换；
6. 再据此实施普通掉落/PQ/Boss 的词缀和粉末梯度。
