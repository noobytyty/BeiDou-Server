# 装备词缀 T1–T12 完整配置

更新时间：2026-08-21

本文记录当前装备词缀系统的实际效果、数值范围、等级限制和抽取规则。

> 说明：本文中的数值和抽取规则对应当前服务端代码及 `V1.11.24`–`V1.11.50` 迁移。词缀展示名称由服务端 i18n 提供，阶级前缀按 `affix_code + affix_tier` 独立配置。

## 1. 词缀效果

### 1.1 基础属性

| 词缀代码 | 效果 | 属性类型 |
| --- | --- | --- |
| `STR` | 力量 | 固定值 |
| `DEX` | 敏捷 | 固定值 |
| `INT` | 智力 | 固定值 |
| `LUK` | 运气 | 固定值 |
| `HP` | 最大 HP | 固定值 |
| `MP` | 最大 MP | 固定值 |
| `WATK` | 武器攻击力 | 固定值 |
| `MATK` | 魔法攻击力 | 固定值 |
| `WDEF` | 物理防御 | 固定值 |
| `MDEF` | 魔法防御 | 固定值 |
| `ACC` | 命中率 | 固定值 |
| `AVOID` | 回避率 | 固定值 |
| `SPEED` | 移动速度 | 固定值 |
| `JUMP` | 跳跃力 | 固定值 |

### 1.2 特殊效果

| 词缀代码 | 效果 | 属性类型 |
| --- | --- | --- |
| `BOSS_DAMAGE` | 对 Boss 伤害 | 百分比 |
| `IGNORE_DEFENSE` | 无视防御 | 百分比 |
| `DROP_RATE` | 掉落率 | 百分比 |
| `EXP_RATE` | 经验率 | 百分比 |
| `MESO_RATE` | 金币率 | 百分比 |
| `BOSS_DAMAGE_REDUCTION` | Boss 伤害减免 | 百分比 |
| `FIRE_DAMAGE` | 火属性技能伤害 | 百分比 |
| `ICE_DAMAGE` | 冰属性技能伤害 | 百分比 |
| `LIGHTNING_DAMAGE` | 雷属性技能伤害 | 百分比 |
| `HOLY_DAMAGE` | 圣属性技能伤害 | 百分比 |

### 1.3 混合词缀

| 词缀代码 | 效果 | 运行时贡献 |
| --- | --- | --- |
| `ALL_STAT` | 全属性 | 同时贡献 STR/DEX/INT/LUK |
| `STR_WATK` | 力量/攻击力 | 同时贡献 STR 和 WATK |
| `DEX_WATK` | 敏捷/攻击力 | 同时贡献 DEX 和 WATK |
| `LUK_WATK` | 运气/攻击力 | 同时贡献 LUK 和 WATK |
| `INT_MATK` | 智力/魔法攻击力 | 同时贡献 INT 和 MATK |
| `HP_MP` | 最大 HP/最大 MP | 同时贡献 HP 和 MP |
| `ACC_AVOID` | 命中率/回避率 | 同时贡献 ACC 和 AVOID |
| `SPEED_JUMP` | 移动速度/跳跃力 | 同时贡献 SPEED 和 JUMP |
| `WDEF_MDEF` | 物理防御/魔法防御 | 同时贡献 WDEF 和 MDEF |
| `BOSS_DAMAGE_IGNORE_DEFENSE` | Boss伤害/无视防御 | 同时贡献 Boss伤害和无视防御 |
| `DROP_EXP` | 掉落率/经验率 | 同时贡献掉落率和经验率 |
| `EXP_MESO` | 经验率/金币率 | 同时贡献经验率和金币率 |
| `DROP_MESO` | 掉落率/金币率 | 同时贡献掉落率和金币率 |
| `STR_ACC` | 力量/命中率 | STR 全值，ACC 按 60% 贡献 |
| `DEX_SPEED` | 敏捷/移动速度 | DEX 全值，SPEED 按 50% 贡献 |
| `INT_MP` | 智力/最大 MP | INT 全值，MP 按 65% 贡献 |
| `LUK_AVOID` | 运气/回避率 | LUK 全值，AVOID 按 50% 贡献 |
| `WATK_ACC` | 攻击力/命中率 | WATK 全值，ACC 按 60% 贡献 |
| `MATK_MP` | 魔法攻击力/最大 MP | MATK 全值，MP 按 65% 贡献 |
| `STR_HP` | 力量/最大 HP | STR 全值，HP 按 65% 贡献 |
| `DEX_JUMP` | 敏捷/跳跃力 | DEX 全值，JUMP 按 50% 贡献 |
| `INT_MDEF` | 智力/魔法防御 | INT 全值，MDEF 按 50% 贡献 |
| `LUK_SPEED` | 运气/移动速度 | LUK 全值，SPEED 按 50% 贡献 |
| `WATK_SPEED` | 攻击力/移动速度 | WATK 全值，SPEED 按 50% 贡献 |
| `MATK_MDEF` | 魔法攻击力/魔法防御 | MATK 全值，MDEF 按 50% 贡献 |
| `STR_MP` | 力量/最大 MP | STR 全值，MP 按 65% 贡献 |
| `DEX_HP` | 敏捷/最大 HP | DEX 全值，HP 按 65% 贡献 |
| `INT_HP` | 智力/最大 HP | INT 全值，HP 按 65% 贡献 |
| `LUK_MP` | 运气/最大 MP | LUK 全值，MP 按 65% 贡献 |
| `HP_MDEF` | 最大 HP/魔法防御 | HP 全值，MDEF 按 50% 贡献 |
| `MP_MDEF` | 最大 MP/魔法防御 | MP 全值，MDEF 按 50% 贡献 |
| `HP_ACC` | 最大 HP/命中率 | HP 全值，ACC 按 60% 贡献 |
| `MP_ACC` | 最大 MP/命中率 | MP 全值，ACC 按 60% 贡献 |

混合词缀作为一条词缀实例保存和展示，但不会把贡献重复写入装备本体属性。

### 1.4 当前词缀展示名称

基础词缀使用直观名称；混合词缀和元素词缀采用类似主流 ARPG 的短称号，
优先表达战斗风格、属性方向或元素主题，少量保留传说意象。下表是当前中文
展示名，英文客户端使用对应的英文称号。

| 词缀代码 | 当前名称 | 设计意象 |
| --- | --- | --- |
| `STR_DEX` | 强健 | 力量与敏捷 |
| `INT_LUK` | 秘仪 | 智力与运气 |
| `WATK_MATK` | 神威 | 物攻与魔攻（历史兼容） |
| `STR_WATK` | 猛攻 | 力量与物攻 |
| `DEX_WATK` | 精准 | 敏捷与物攻 |
| `LUK_WATK` | 诡刃 | 运气与物攻 |
| `INT_MATK` | 奥术 | 智力与魔攻 |
| `HP_MP` | 丰饶 | HP 与 MP |
| `ACC_AVOID` | 灵巧 | 命中与回避 |
| `SPEED_JUMP` | 疾行 | 移速与跳跃 |
| `WDEF_MDEF` | 守护 | 双防御 |
| `BOSS_DAMAGE_IGNORE_DEFENSE` | 屠戮 | Boss 伤害与无视防御 |
| `DROP_EXP` | 丰收 | 掉落与经验 |
| `EXP_MESO` | 富足 | 经验与金币 |
| `DROP_MESO` | 聚财 | 掉落与金币 |
| `STR_ACC` | 碾压 | 力量与命中 |
| `DEX_SPEED` | 迅捷 | 敏捷与移速 |
| `INT_MP` | 聚能 | 智力与 MP |
| `LUK_AVOID` | 诡步 | 运气与回避 |
| `WATK_ACC` | 穿刺 | 物攻与命中 |
| `MATK_MP` | 奥能 | 魔攻与 MP |
| `STR_HP` | 坚韧 | 力量与 HP |
| `DEX_JUMP` | 腾跃 | 敏捷与跳跃 |
| `INT_MDEF` | 魔御 | 智力与魔防 |
| `LUK_SPEED` | 影行 | 运气与移速 |
| `WATK_SPEED` | 迅击 | 物攻与移速 |
| `MATK_MDEF` | 秘法壁垒 | 魔攻与魔防 |
| `STR_MP` | 蓄力 | 力量与 MP |
| `DEX_HP` | 活力 | 敏捷与 HP |
| `INT_HP` | 灵魂 | 智力与 HP |
| `LUK_MP` | 凝神 | 运气与 MP |
| `HP_MDEF` | 坚壁 | HP 与魔防 |
| `MP_MDEF` | 法障 | MP 与魔防 |
| `HP_ACC` | 洞察 | HP 与命中 |
| `MP_ACC` | 感知 | MP 与命中 |
| `FIRE_DAMAGE` | 炽炎 | 火属性技能伤害 |
| `ICE_DAMAGE` | 霜寒 | 冰属性技能伤害 |
| `LIGHTNING_DAMAGE` | 雷霆 | 雷属性技能伤害 |
| `HOLY_DAMAGE` | 圣辉 | 圣属性技能伤害 |

每个可生成词缀均有 T1–T12 独立前缀，例如
`equipment.prefix.fire_damage.t1`；不得只按阶级共用一个名称，也不得在缺少翻译时显示数据库键。
当前已停用新生成、但仍保留历史实例兼容的跨职业混合词缀为
`STR_DEX`、`INT_LUK`、`STR_INT`、`DEX_LUK`、`WATK_MATK`、`WDEF_MDEF`。

## 2. T1–T12 数值范围

区间两端均包含，实际生成时在区间内随机取值。

### 2.1 基础属性

下列词缀共用对应数值表：

- `STR`、`DEX`、`INT`、`LUK`
- `ACC`、`AVOID`

| 阶级 | 数值 |
| --- | ---: |
| T1 | 1–2 |
| T2 | 2–4 |
| T3 | 4–7 |
| T4 | 7–12 |
| T5 | 12–19 |
| T6 | 19–28 |
| T7 | 28–40 |
| T8 | 40–56 |
| T9 | 44–61 |
| T10 | 47–66 |
| T11 | 51–71 |
| T12 | 55–77 |

`HP`、`MP`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 16–36 |
| T2 | 36–80 |
| T3 | 80–160 |
| T4 | 160–300 |
| T5 | 300–520 |
| T6 | 520–840 |
| T7 | 840–1300 |
| T8 | 1300–1900 |
| T9 | 1404–2052 |
| T10 | 1517–2217 |
| T11 | 1638–2394 |
| T12 | 1769–2585 |

`WATK`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 1–1 |
| T2 | 2–2 |
| T3 | 4–4 |
| T4 | 6–6 |
| T5 | 9–9 |
| T6 | 13–13 |
| T7 | 13–18 |
| T8 | 18–25 |
| T9 | 20–27 |
| T10 | 21–30 |
| T11 | 23–32 |
| T12 | 25–35 |

`MATK`：

魔法攻击词缀采用对应 `WATK` 区间的 2 倍，体现约 2 点魔攻等效 1 点攻击力。

| 阶级 | 数值 |
| --- | ---: |
| T1 | 2–2 |
| T2 | 4–4 |
| T3 | 8–8 |
| T4 | 12–12 |
| T5 | 18–18 |
| T6 | 26–26 |
| T7 | 26–36 |
| T8 | 36–50 |
| T9 | 40–54 |
| T10 | 42–60 |
| T11 | 46–64 |
| T12 | 50–70 |

`WDEF`、`MDEF`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 3–8 |
| T2 | 8–18 |
| T3 | 18–36 |
| T4 | 36–64 |
| T5 | 64–104 |
| T6 | 104–160 |
| T7 | 160–240 |
| T8 | 240–340 |
| T9 | 260–368 |
| T10 | 280–397 |
| T11 | 303–429 |
| T12 | 327–463 |

`SPEED`、`JUMP`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 1–1 |
| T2 | 1–2 |
| T3 | 2–2 |
| T4 | 3–3 |
| T5 | 4–4 |
| T6 | 4–5 |
| T7 | 5–6 |
| T8 | 6–6 |
| T9 | 6–7 |
| T10 | 6–7 |
| T11 | 7–8 |
| T12 | 7–9 |

### 2.2 特殊效果

以下数值均为百分比：

装备生效时，Boss 伤害总和封顶 70%；掉落率、经验率和金币率分别封顶 60%；无视防御封顶 60%，Boss 减伤封顶 70%。元素伤害每种元素封顶 25%。

| 阶级 | `BOSS_DAMAGE` | `IGNORE_DEFENSE` | `DROP_RATE`/`EXP_RATE`/`MESO_RATE` | `BOSS_DAMAGE_REDUCTION` |
| --- | ---: | ---: | ---: | ---: |
| T1 | 1–1 | 1–1 | 1–2 | 1–1 |
| T2 | 1–2 | 1–2 | 2–3 | 1–2 |
| T3 | 2–3 | 2–3 | 3–6 | 2–3 |
| T4 | 3–5 | 3–5 | 6–9 | 3–5 |
| T5 | 5–7 | 5–6 | 9–13 | 5–6 |
| T6 | 7–9 | 6–8 | 13–18 | 6–8 |
| T7 | 9–11 | 8–10 | 18–23 | 8–10 |
| T8 | 11–13 | 10–13 | 23–30 | 10–12 |
| T9 | 12–15 | 11–15 | 25–33 | 11–13 |
| T10 | 13–16 | 12–16 | 27–35 | 12–14 |
| T11 | 14–17 | 13–17 | 29–38 | 13–16 |
| T12 | 15–18 | 14–18 | 32–41 | 14–17 |

### 2.3 混合词缀

`STR_DEX`、`INT_LUK`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 1–2 |
| T2 | 2–3 |
| T3 | 3–6 |
| T4 | 5–9 |
| T5 | 9–15 |
| T6 | 14–21 |
| T7 | 21–30 |
| T8 | 30–42 |
| T9 | 33–46 |
| T10 | 36–50 |
| T11 | 38–54 |
| T12 | 42–58 |

上述双属性词缀的每个属性约为对应单属性词缀的 75%。

`STR_WATK`、`DEX_WATK`、`LUK_WATK`、`INT_MATK`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 1–1 |
| T2 | 2–2 |
| T3 | 3–3 |
| T4 | 5–5 |
| T5 | 7–7 |
| T6 | 10–10 |
| T7 | 10–14 |
| T8 | 14–19 |
| T9 | 15–21 |
| T10 | 16–23 |
| T11 | 17–24 |
| T12 | 19–27 |

这四类词缀使用一个共享词缀值，同时贡献给对应的主属性和 WATK/MATK。`STR_WATK`、`DEX_WATK`、`LUK_WATK` 按共享值贡献；`INT_MATK` 按共享值贡献 INT，并按 2 倍贡献 MATK。

`HP_MP`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 12–27 |
| T2 | 27–60 |
| T3 | 60–120 |
| T4 | 120–225 |
| T5 | 225–390 |
| T6 | 390–630 |
| T7 | 630–975 |
| T8 | 975–1425 |
| T9 | 1053–1539 |
| T10 | 1137–1663 |
| T11 | 1228–1796 |
| T12 | 1326–1939 |

`ACC_AVOID`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 1–2 |
| T2 | 2–3 |
| T3 | 3–6 |
| T4 | 5–9 |
| T5 | 9–15 |
| T6 | 14–21 |
| T7 | 21–30 |
| T8 | 30–42 |
| T9 | 33–46 |
| T10 | 36–50 |
| T11 | 38–54 |
| T12 | 42–58 |

`ALL_STAT`：

`ALL_STAT` 每项属性约为基础单属性词缀的 40%：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 1–1 |
| T2 | 1–2 |
| T3 | 1–3 |
| T4 | 2–5 |
| T5 | 4–8 |
| T6 | 7–12 |
| T7 | 11–16 |
| T8 | 16–23 |
| T9 | 17–25 |
| T10 | 18–27 |
| T11 | 20–29 |
| T12 | 22–31 |

`SPEED_JUMP`：

| 阶级 | 数值 |
| --- | ---: |
| T1 | 1–1 |
| T2 | 1–2 |
| T3 | 2–2 |
| T4 | 2–3 |
| T5 | 3–3 |
| T6 | 3–4 |
| T7 | 3–5 |
| T8 | 5–5 |
| T9 | 5–6 |
| T10 | 5–6 |
| T11 | 6–6 |
| T12 | 6–7 |

`STR_ACC`、`DEX_SPEED`、`INT_MP`、`LUK_AVOID`、`WATK_ACC`、`MATK_MP`、
`STR_HP`、`DEX_JUMP`、`INT_MDEF`、`LUK_SPEED`、`WATK_SPEED`、`MATK_MDEF`、
`STR_MP`、`DEX_HP`、`INT_HP`、`LUK_MP`、`HP_MDEF`、`MP_MDEF`、`HP_ACC`、
`MP_ACC` 使用对应主属性的基础区间作为共享值；辅助属性按运行时折算比例贡献。
例如 `STR_HP` 使用基础属性区间随机一个值，再分别贡献 STR 全值和 HP 的 65%。

`BOSS_DAMAGE_IGNORE_DEFENSE`、`DROP_EXP`、`EXP_MESO`、`DROP_MESO` 使用
百分比特殊词缀区间；同一条共享值分别贡献两个百分比效果。元素词缀
`FIRE_DAMAGE`、`ICE_DAMAGE`、`LIGHTNING_DAMAGE`、`HOLY_DAMAGE` 复制
`BOSS_DAMAGE` 的 T1–T12 百分比区间，最终受元素伤害总上限 25% 约束。

### 2.4 逐词缀 T1–T12 数值明细

下面不是数值族摘要，而是每个词缀代码的独立明细。每个 `T1` 至 `T12`
单元格都是该词缀在对应阶级的实际随机范围；同一数值被多个混合词缀
使用时仍然逐条列出，方便策划和运营直接查表。

| 词缀 | T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | T11 | T12 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `STR` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `DEX` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `INT` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `LUK` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `HP` | 16–36 | 36–80 | 80–160 | 160–300 | 300–520 | 520–840 | 840–1300 | 1300–1900 | 1404–2052 | 1517–2217 | 1638–2394 | 1769–2585 |
| `MP` | 16–36 | 36–80 | 80–160 | 160–300 | 300–520 | 520–840 | 840–1300 | 1300–1900 | 1404–2052 | 1517–2217 | 1638–2394 | 1769–2585 |
| `WATK` | 1–1 | 2–2 | 4–4 | 6–6 | 9–9 | 13–13 | 13–18 | 18–25 | 20–27 | 21–30 | 23–32 | 25–35 |
| `MATK` | 2–2 | 4–4 | 8–8 | 12–12 | 18–18 | 26–26 | 26–36 | 36–50 | 40–54 | 42–60 | 46–64 | 50–70 |
| `WDEF` | 3–8 | 8–18 | 18–36 | 36–64 | 64–104 | 104–160 | 160–240 | 240–340 | 260–368 | 280–397 | 303–429 | 327–463 |
| `MDEF` | 3–8 | 8–18 | 18–36 | 36–64 | 64–104 | 104–160 | 160–240 | 240–340 | 260–368 | 280–397 | 303–429 | 327–463 |
| `ACC` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `AVOID` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `SPEED` | 1–1 | 1–2 | 2–2 | 3–3 | 4–4 | 4–5 | 5–6 | 6–6 | 6–7 | 6–7 | 7–8 | 7–9 |
| `JUMP` | 1–1 | 1–2 | 2–2 | 3–3 | 4–4 | 4–5 | 5–6 | 6–6 | 6–7 | 6–7 | 7–8 | 7–9 |
| `BOSS_DAMAGE` | 1–1% | 1–2% | 2–3% | 3–5% | 5–7% | 7–9% | 9–11% | 11–13% | 12–15% | 13–16% | 14–17% | 15–18% |
| `IGNORE_DEFENSE` | 1–1% | 1–2% | 2–3% | 3–5% | 5–6% | 6–8% | 8–10% | 10–13% | 11–15% | 12–16% | 13–17% | 14–18% |
| `DROP_RATE` | 1–2% | 2–3% | 3–6% | 6–9% | 9–13% | 13–18% | 18–23% | 23–30% | 25–33% | 27–35% | 29–38% | 32–41% |
| `EXP_RATE` | 1–2% | 2–3% | 3–6% | 6–9% | 9–13% | 13–18% | 18–23% | 23–30% | 25–33% | 27–35% | 29–38% | 32–41% |
| `MESO_RATE` | 1–2% | 2–3% | 3–6% | 6–9% | 9–13% | 13–18% | 18–23% | 23–30% | 25–33% | 27–35% | 29–38% | 32–41% |
| `BOSS_DAMAGE_REDUCTION` | 1–1% | 1–2% | 2–3% | 3–5% | 5–6% | 6–8% | 8–10% | 10–12% | 11–13% | 12–14% | 13–16% | 14–17% |
| `ALL_STAT` | 1–1 | 1–2 | 1–3 | 2–5 | 4–8 | 7–12 | 11–16 | 16–23 | 17–25 | 18–27 | 20–29 | 22–31 |
| `STR_DEX` | 1–2 | 2–3 | 3–6 | 5–9 | 9–15 | 14–21 | 21–30 | 30–42 | 33–46 | 36–50 | 38–54 | 42–58 |
| `INT_LUK` | 1–2 | 2–3 | 3–6 | 5–9 | 9–15 | 14–21 | 21–30 | 30–42 | 33–46 | 36–50 | 38–54 | 42–58 |
| `STR_INT` | 1–2 | 2–3 | 3–6 | 5–9 | 9–15 | 14–21 | 21–30 | 30–42 | 33–46 | 36–50 | 38–54 | 42–58 |
| `DEX_LUK` | 1–2 | 2–3 | 3–6 | 5–9 | 9–15 | 14–21 | 21–30 | 30–42 | 33–46 | 36–50 | 38–54 | 42–58 |
| `WATK_MATK` | 1–1 | 2–2 | 3–3 | 5–5 | 7–7 | 10–10 | 10–14 | 14–19 | 15–21 | 16–23 | 17–24 | 19–27 |
| `STR_WATK` | 1–1 | 2–2 | 3–3 | 5–5 | 7–7 | 10–10 | 10–14 | 14–19 | 15–21 | 16–23 | 17–24 | 19–27 |
| `DEX_WATK` | 1–1 | 2–2 | 3–3 | 5–5 | 7–7 | 10–10 | 10–14 | 14–19 | 15–21 | 16–23 | 17–24 | 19–27 |
| `LUK_WATK` | 1–1 | 2–2 | 3–3 | 5–5 | 7–7 | 10–10 | 10–14 | 14–19 | 15–21 | 16–23 | 17–24 | 19–27 |
| `INT_MATK` | 1–1 | 2–2 | 3–3 | 5–5 | 7–7 | 10–10 | 10–14 | 14–19 | 15–21 | 16–23 | 17–24 | 19–27 |
| `HP_MP` | 12–27 | 27–60 | 60–120 | 120–225 | 225–390 | 390–630 | 630–975 | 975–1425 | 1053–1539 | 1137–1663 | 1228–1796 | 1326–1939 |
| `ACC_AVOID` | 1–2 | 2–3 | 3–6 | 5–9 | 9–15 | 14–21 | 21–30 | 30–42 | 33–46 | 36–50 | 38–54 | 42–58 |
| `SPEED_JUMP` | 1–1 | 1–2 | 2–2 | 2–3 | 3–3 | 3–4 | 3–5 | 5–5 | 5–6 | 5–6 | 6–6 | 6–7 |
| `WDEF_MDEF` | 3–8 | 8–18 | 18–36 | 36–64 | 64–104 | 104–160 | 160–240 | 240–340 | 260–368 | 280–397 | 303–429 | 327–463 |
| `BOSS_DAMAGE_IGNORE_DEFENSE` | 1–1% | 1–2% | 2–3% | 3–5% | 5–7% | 7–9% | 9–11% | 11–13% | 12–15% | 13–16% | 14–17% | 15–18% |
| `DROP_EXP` | 1–2% | 2–3% | 3–6% | 6–9% | 9–13% | 13–18% | 18–23% | 23–30% | 25–33% | 27–35% | 29–38% | 32–41% |
| `EXP_MESO` | 1–2% | 2–3% | 3–6% | 6–9% | 9–13% | 13–18% | 18–23% | 23–30% | 25–33% | 27–35% | 29–38% | 32–41% |
| `DROP_MESO` | 1–2% | 2–3% | 3–6% | 6–9% | 9–13% | 13–18% | 18–23% | 23–30% | 25–33% | 27–35% | 29–38% | 32–41% |
| `STR_ACC` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `DEX_SPEED` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `INT_MP` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `LUK_AVOID` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `WATK_ACC` | 1–1 | 2–2 | 4–4 | 6–6 | 9–9 | 13–13 | 13–18 | 18–25 | 20–27 | 21–30 | 23–32 | 25–35 |
| `MATK_MP` | 2–2 | 4–4 | 8–8 | 12–12 | 18–18 | 26–26 | 26–36 | 36–50 | 40–54 | 42–60 | 46–64 | 50–70 |
| `STR_HP` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `DEX_JUMP` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `INT_MDEF` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `LUK_SPEED` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `WATK_SPEED` | 1–1 | 2–2 | 4–4 | 6–6 | 9–9 | 13–13 | 13–18 | 18–25 | 20–27 | 21–30 | 23–32 | 25–35 |
| `MATK_MDEF` | 2–2 | 4–4 | 8–8 | 12–12 | 18–18 | 26–26 | 26–36 | 36–50 | 40–54 | 42–60 | 46–64 | 50–70 |
| `STR_MP` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `DEX_HP` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `INT_HP` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `LUK_MP` | 1–2 | 2–4 | 4–7 | 7–12 | 12–19 | 19–28 | 28–40 | 40–56 | 44–61 | 47–66 | 51–71 | 55–77 |
| `HP_MDEF` | 16–36 | 36–80 | 80–160 | 160–300 | 300–520 | 520–840 | 840–1300 | 1300–1900 | 1404–2052 | 1517–2217 | 1638–2394 | 1769–2585 |
| `MP_MDEF` | 16–36 | 36–80 | 80–160 | 160–300 | 300–520 | 520–840 | 840–1300 | 1300–1900 | 1404–2052 | 1517–2217 | 1638–2394 | 1769–2585 |
| `HP_ACC` | 16–36 | 36–80 | 80–160 | 160–300 | 300–520 | 520–840 | 840–1300 | 1300–1900 | 1404–2052 | 1517–2217 | 1638–2394 | 1769–2585 |
| `MP_ACC` | 16–36 | 36–80 | 80–160 | 160–300 | 300–520 | 520–840 | 840–1300 | 1300–1900 | 1404–2052 | 1517–2217 | 1638–2394 | 1769–2585 |
| `FIRE_DAMAGE` | 1–1% | 1–2% | 2–3% | 3–5% | 5–7% | 7–9% | 9–11% | 11–13% | 12–15% | 13–16% | 14–17% | 15–18% |
| `ICE_DAMAGE` | 1–1% | 1–2% | 2–3% | 3–5% | 5–7% | 7–9% | 9–11% | 11–13% | 12–15% | 13–16% | 14–17% | 15–18% |
| `LIGHTNING_DAMAGE` | 1–1% | 1–2% | 2–3% | 3–5% | 5–7% | 7–9% | 9–11% | 11–13% | 12–15% | 13–16% | 14–17% | 15–18% |
| `HOLY_DAMAGE` | 1–1% | 1–2% | 2–3% | 3–5% | 5–7% | 7–9% | 9–11% | 11–13% | 12–15% | 13–16% | 14–17% | 15–18% |

### 2.5 词缀命名

当前运行时**不再使用统一的“阶级前缀 + 主题名”命名**。每个词缀在
T1–T12 都有自己的名称，完整表见 2.6；数据库命名键严格按
`affix_code + affix_tier` 配置，例如：

```text
equipment.prefix.str_watk.t1
equipment.prefix.str_watk.t2
...
equipment.prefix.str_watk.t12
```

中文和英文客户端都读取对应的独立命名键。

以下主题名仅用于索引和搜索，不会覆盖 2.6 的逐阶名称：

| 代码 | 中文主题名 | 英文主题名 |
| --- | --- | --- |
| `STR` | 力量 | Strength |
| `DEX` | 敏捷 | Dexterity |
| `INT` | 智力 | Intelligence |
| `LUK` | 运气 | Luck |
| `HP` | 最大生命 | Vitality |
| `MP` | 最大魔力 | Mana |
| `WATK` | 武器攻击 | Weapon Attack |
| `MATK` | 魔法攻击 | Magic Attack |
| `WDEF` | 物理防御 | Armor |
| `MDEF` | 魔法防御 | Spell Resistance |
| `ACC` | 命中 | Accuracy |
| `AVOID` | 回避 | Evasion |
| `SPEED` | 迅捷 | Swiftness |
| `JUMP` | 腾跃 | Leaping |
| `BOSS_DAMAGE` | 猎杀 | Slaying |
| `IGNORE_DEFENSE` | 破甲 | Armorbreak |
| `DROP_RATE` | 掉落 | Fortune |
| `EXP_RATE` | 经验 | Learning |
| `MESO_RATE` | 金币 | Prosperity |
| `BOSS_DAMAGE_REDUCTION` | 坚守 | Bulwark |
| `ALL_STAT` | 全能 | Omnipotent |
| `STR_DEX` | 强健 | Fortified |
| `INT_LUK` | 秘仪 | Esoteric |
| `WATK_MATK` | 神威 | Might |
| `STR_WATK` | 猛攻 | Onslaught |
| `DEX_WATK` | 精准 | Precise |
| `LUK_WATK` | 诡刃 | Cunning |
| `INT_MATK` | 奥术 | Arcane |
| `HP_MP` | 丰饶 | Bountiful |
| `ACC_AVOID` | 灵巧 | Nimble |
| `SPEED_JUMP` | 疾行 | Fleet |
| `WDEF_MDEF` | 守护 | Guarded |
| `BOSS_DAMAGE_IGNORE_DEFENSE` | 屠戮 | Slaughter |
| `DROP_EXP` | 丰收 | Bounty |
| `EXP_MESO` | 富足 | Prosperity |
| `DROP_MESO` | 聚财 | Greed |
| `STR_ACC` | 碾压 | Overpowering |
| `DEX_SPEED` | 迅捷 | Swift |
| `INT_MP` | 聚能 | Conduit |
| `LUK_AVOID` | 诡步 | Elusive |
| `WATK_ACC` | 穿刺 | Penetrating |
| `MATK_MP` | 奥能 | Aether |
| `STR_HP` | 坚韧 | Stalwart |
| `DEX_JUMP` | 腾跃 | Vaulting |
| `INT_MDEF` | 魔御 | Spellward |
| `LUK_SPEED` | 影行 | Shadowstep |
| `WATK_SPEED` | 迅击 | Rapid |
| `MATK_MDEF` | 秘法壁垒 | Arcane Bulwark |
| `STR_MP` | 蓄力 | Reserves |
| `DEX_HP` | 活力 | Vitality |
| `INT_HP` | 灵魂 | Soulbound |
| `LUK_MP` | 凝神 | Focused |
| `HP_MDEF` | 坚壁 | Bulwark |
| `MP_MDEF` | 法障 | Manaward |
| `HP_ACC` | 洞察 | Insight |
| `MP_ACC` | 感知 | Perception |
| `FIRE_DAMAGE` | 炽炎 | Ember |
| `ICE_DAMAGE` | 霜寒 | Frost |
| `LIGHTNING_DAMAGE` | 雷霆 | Storm |
| `HOLY_DAMAGE` | 圣辉 | Radiant |

### 2.6 每个词缀的专属 T1–T12 名称

上一节的“阶级前缀 + 主题名”仅用于解释旧版兼容格式，**不作为当前
中文命名方案**。当前中文完整设计采用下表的逐词缀专属名称；同一词缀
从 T1 成长到 T12 时，名称会随效果强度和风格变化。英文资源当前采用
对应词缀主题名与英文阶级词的组合，键仍然按每个 `affix_code + tier`
独立保存。

| 代码 | T1 → T4 | T5 → T8 | T9 → T12 |
| --- | --- | --- | --- |
| `STR` | 初力、强筋、锻体、勇力 | 狂力、霸力、战意、刚魂 | 战魄、天力、神力、力之极 |
| `DEX` | 轻身、灵步、巧手、迅身 | 追风、疾影、幻步、无踪 | 风行、瞬影、天迅、极意 |
| `INT` | 启智、慧心、灵思、通识 | 奥悟、秘学、贤者、睿智 | 星智、真知、神识、至理 |
| `LUK` | 机运、巧运、暗运、偏财 | 玄机、诡运、天眷、奇门 | 命轮、星佑、神运、极幸 |
| `HP` | 充沛、健壮、坚实、厚血 | 强韧、巨躯、钢心、不屈 | 战体、龙血、不灭、永生 |
| `MP` | 聚气、灵泉、蓄能、深池 | 魔源、灵脉、法潮、星泉 | 奥海、虚空、神源、无尽 |
| `WATK` | 磨刃、锐锋、利刃、强击 | 破势、猛击、重斩、狂锋 | 屠杀号、灭杀号、天戮、终焉刃 |
| `MATK` | 魔纹、咒力、灵光、法印 | 奥术、秘法、星咏、魔潮 | 天启、虚术、神谕、终极奥义 |
| `WDEF` | 皮甲、硬革、铁铠、坚甲 | 重铠、壁垒、磐石、不破 | 城垣、天壁、神铠、绝对守御 |
| `MDEF` | 抗魔、宁神、护法、净念 | 镇魂、结界、法障、圣御 | 灵域、天幕、神壁、无相御法 |
| `ACC` | 可靠、稳准、瞄准、精准 | 老练、专注、洞察、百发 | 猎杀号、穿云、必中、天眼 |
| `AVOID` | 机警、警觉、轻身、灵动 | 巧捷、难捉、无踪、飘忽 | 幻行、虚步、残影、不可触及 |
| `SPEED` | 轻便、迅速、轻盈、快行 | 疾行、飞快、追风、无影 | 风驰、闪步、瞬行、超越 |
| `JUMP` | 弹跃、轻跳、高跃、灵跃 | 腾挪、飞跃、凌空、登云 | 破空、踏月、御风、天穹跃 |
| `BOSS_DAMAGE` | 试炼、猎手、斩首、克敌 | 猛士、屠夫、征服、毁灭 | 灭界、弑王、终结、末日猎杀 |
| `IGNORE_DEFENSE` | 破绽、裂甲、穿甲、破阵 | 贯穿、无隙、碎盾、破城 | 真破、绝穿、裂界、无视万法 |
| `DROP_RATE` | 搜寻、拾遗、丰收、宝藏 | 财源、聚宝、富矿、宝库 | 金潮、天赐、无尽宝藏、财富主宰 |
| `EXP_RATE` | 求知、历练、成长、精进 | 博学、悟道、传承、登峰 | 真理、天启、超凡、经验圣典 |
| `MESO_RATE` | 节俭、省心、有利、收益 | 富足、丰厚、富裕、聚财 | 金脉、财王、聚金、点石成金 |
| `BOSS_DAMAGE_REDUCTION` | 避战、坚守、抗击、守势 | 镇定、坚毅、磐守、不屈 | 铁壁、王座、神佑、不可撼动 |
| `ALL_STAT` | 均衡、协调、全能、精通 | 卓越、完美、贤者、统御 | 万象、天命、神格、全知全能 |
| `STR_DEX` | 健行、武步、强敏、迅猛 | 战步、猎势、狂驰、破风 | 战神步、天狩、神速、极境（历史） |
| `INT_LUK` | 灵机、巧思、秘运、慧运 | 奥机、星运、玄机、天机 | 命理、星谕、神机、至运（历史） |
| `WATK_MATK` | 双锋、战法、刃咒、攻心 | 武道、魔武、神锋、战术 | 万刃、天威、神裁、终极武装（历史） |
| `STR_WATK` | 破阵、猛击、强袭、重斩 | 狂战、霸击、战魂、灭杀号 | 战神、天戮、神威、毁灭之力 |
| `DEX_WATK` | 瞄杀、疾射、连矢、穿心 | 猎杀号、鹰眼、贯星、追命 | 弑杀号、天弓、神射、必中终章 |
| `LUK_WATK` | 暗袭、背刺、巧杀、诡锋 | 影刃、毒牙、致命、无声 | 死影、夜杀号、神隐、终焉之刃 |
| `INT_MATK` | 咒火、灵弹、法潮、奥击 | 星术、秘法、天咏、魔导师 | 禁术、虚空法、神谕、终焉奥术 |
| `HP_MP` | 血泉、灵池、双息、厚源 | 生命潮、魔血、丰源、永续 | 不灭源、龙脉、神泉、无尽生机 |
| `ACC_AVOID` | 机敏、灵巧、巧闪、预判 | 猎觉、幻视、无踪、先知 | 天眼、虚影、洞悉、不可捉摸 |
| `SPEED_JUMP` | 轻跃、快步、灵跃、疾行 | 飞步、追风、腾空、掠影 | 瞬步、破空、凌霄、空间跃迁 |
| `WDEF_MDEF` | 双甲、护体、坚壁、结界 | 铁壁、法壁、壁垒、磐守 | 天垒、神铠、绝壁、万法不侵（历史） |
| `BOSS_DAMAGE_IGNORE_DEFENSE` | 猎杀号、破绽、斩甲、克敌 | 屠杀号、破阵、征服、处刑 | 弑王、灭界、终结、末日审判 |
| `DROP_EXP` | 搜寻、历练、拾遗、成长 | 丰收、求知、宝藏、精进 | 宝库、天启、金潮、财富与真理 |
| `EXP_MESO` | 节俭、求知、收益、成长 | 富足、博学、聚财、传承 | 金脉、登峰、财王、黄金时代 |
| `DROP_MESO` | 拾遗、收益、寻宝、聚金 | 宝藏、财源、聚宝、富矿 | 宝库、金潮、天赐、聚宝天命 |
| `STR_ACC` | 重拳、稳手、强击、压制 | 猛攻、破势、碾压、战意 | 战魄、必中、天威、绝对强袭 |
| `DEX_SPEED` | 轻快、灵步、迅身、追风 | 疾驰、飞影、闪行、无踪 | 风暴、瞬影、天迅、超速领域 |
| `INT_MP` | 聚气、灵泉、启智、蓄能 | 魔源、灵脉、奥海、星泉 | 虚空、神源、无尽、永恒法力 |
| `LUK_AVOID` | 机运、巧步、暗行、灵闪 | 诡运、幻步、影遁、无踪 | 命轮、虚影、神隐、不可命中 |
| `WATK_ACC` | 磨刃、稳击、瞄杀、穿刺 | 破势、贯穿、猎杀号、破阵 | 天眼、必中、灭界、终焉穿刺 |
| `MATK_MP` | 魔纹、聚能、法印、灵潮 | 奥能、星泉、秘源、魔海 | 虚空、天启、神源、无尽奥能 |
| `STR_HP` | 健体、厚甲、强韧、坚心 | 不屈、战体、巨躯、钢魂 | 龙血、神躯、不灭、永生战体 |
| `DEX_JUMP` | 轻跃、灵步、高跳、腾挪 | 飞跃、凌空、踏风、破空 | 登云、天穹、御风、无限跃迁 |
| `INT_MDEF` | 启智、护法、净念、结界 | 镇魂、法障、灵域、圣御 | 天幕、神壁、无相、绝对魔御 |
| `LUK_SPEED` | 巧运、轻身、灵步、影行 | 诡步、追风、幻影、无踪 | 命轮、瞬影、神隐、虚空行者 |
| `WATK_SPEED` | 快刃、迅击、连斩、追风 | 狂锋、疾杀号、闪击、无影 | 风暴、瞬杀、天戮、超越极限 |
| `MATK_MDEF` | 魔纹、护法、法壁、结界 | 奥术、秘法、灵域、星障 | 天启、神壁、虚空御法、万法归一 |
| `STR_MP` | 蓄力、聚气、强源、战息 | 狂力、魔血、战魂、灵脉 | 龙脉、神源、不灭战息、无尽力量 |
| `DEX_HP` | 健行、轻身、活力、坚韧 | 迅体、猎心、强生、不屈 | 天行、战体、神躯、永恒活力 |
| `INT_HP` | 灵思、聚魂、护体、凝神 | 奥悟、灵魂、贤者、圣躯 | 星魂、天启、神格、不灭灵体 |
| `LUK_MP` | 巧运、聚气、灵泉、暗息 | 玄机、魔源、天眷、星脉 | 命轮、虚空、神运、无尽秘能 |
| `HP_MDEF` | 厚血、护体、抗魔、坚壁 | 生命墙、法障、镇魂、磐守 | 不灭、天幕、神壁、绝对守御 |
| `MP_MDEF` | 灵泉、聚气、护法、结界 | 魔源、法障、星障、圣御 | 奥海、天幕、神壁、万法不侵 |
| `HP_ACC` | 健体、稳手、厚血、洞察 | 强生、猎觉、不屈、百发 | 战体、天眼、神躯、必中领域 |
| `MP_ACC` | 聚能、瞄准、法印、灵视 | 奥能、星眼、秘源、洞悉 | 天启、虚空之眼、神谕、全知感知 |
| `FIRE_DAMAGE` | 火花、灼热、炎流、焚烧 | 烈焰、熔火、炎魔、天火 | 炽界、太阳焰、神火、末日炎狱 |
| `ICE_DAMAGE` | 寒气、凝霜、冰流、冻伤 | 冰封、霜华、极寒、冰狱 | 绝对零度、冰川、神霜、永冬领域 |
| `LIGHTNING_DAMAGE` | 电弧、震鸣、雷光、闪击 | 雷暴、轰雷、天雷、雷狱 | 风暴核心、苍穹雷、神罚、灭世雷霆 |
| `HOLY_DAMAGE` | 微光、圣印、祷言、辉耀 | 圣裁、神恩、圣域、天佑 | 神圣领域、天启、神谕、永恒圣辉 |

## 3. 等级限制

装备根据 `reqLevel` 进入每 10 级一个等级池：

```text
0–9、10–19、20–29 …… 250–255
```

### 3.1 词缀等级均值与抽取窗口

| 装备需求等级 | 词缀均值 | 抽取范围 |
| --- | ---: | --- |
| 1–9 | T1 | T1–T4 |
| 10–19 | T2 | T1–T5 |
| 20–29 | T3 | T1–T6 |
| 30–39 | T4 | T1–T7 |
| 40–49 | T5 | T2–T8 |
| 50–59 | T6 | T3–T9 |
| 60–69 | T7 | T4–T10 |
| 70–79 | T8 | T5–T11 |
| 80–89 | T9 | T5–T12 |
| 90–99 | T10 | T6–T12 |
| 100–109 | T11 | T7–T12 |
| 110–119 | T12 | T8–T12 |
| 120+ | T12 | T7–T12 |

实际窗口在 80 级前为均值 ±3，80–119 级为均值 ±4，120 级以上为均值 ±5，并限制在 T1–T12 内；装备品质不再限制词缀阶级。

80 级以下如果抽到高于装备均值的词缀阶级，每超出 1 阶，最终数值乘以 85%，最低保留 1；80 级及以上不应用该折扣。

阶级抽取权重按与均值的距离计算：

| 距离均值 | 80级以下 | 80–119级 | 120级以上 |
| ---: | ---: | ---: | ---: |
| 0 | 100 | 100 | 100 |
| 1 | 90 | 90 | 90 |
| 2 | 50 | 50 | 50 |
| 3 | 5 | 15 | 20 |
| 4 | — | 5 | 8 |
| 5 | — | — | 2 |

### 3.2 特殊词缀开放等级

| 词缀 | 最低需求等级 |
| --- | ---: |
| `SPEED_JUMP` | 20 |
| `STR_DEX`、`INT_LUK`、`HP_MP` | 40 |
| `ACC_AVOID` | 50 |
| `STR_WATK`、`DEX_WATK`、`LUK_WATK`、`INT_MATK` | 80 |
| `ALL_STAT` | 100 |
| Boss/无视防御/掉落/经验/金币/Boss 减伤 | 60 |

60 级以下装备不会抽取 Boss、无视防御、掉落率、经验率、金币率和 Boss 减伤词缀。

### 3.3 主词缀与副词缀

词缀分为两个独立抽取池：

- 主词缀池：基础属性、HP/MP、防御、攻击、全属性和职业定向攻击；
- 副词缀池：命中/回避、速度/跳跃、Boss/无视防御、掉落/经验/金币和 Boss 减伤等功能效果。
- 副词缀池以较低权重额外加入 `STR`、`DEX`、`INT`、`LUK`、`WATK`、`MATK` 六类核心词缀，制造极品双词条的低概率可能。
- 低价值跨职业组合保留历史实例兼容，但已关闭新生成；功能混合词缀和跨维度辅助词缀统一降为低权重，避免稀释核心词缀。

部位定位：

- 上衣/裤子：以 HP、MP、WDEF、MDEF 为主，低权重加入四项基础属性；
- 帽子：保留属性路线，并允许低权重 HP、MP、防御副词缀；
- 项链：以 HP、MP、防御为主，低权重加入四项基础属性；
- 戒指：偏向基础属性、HP/MP 以及掉落、经验、金币；
- 耳环：作为主要掉落饰品，保留掉落、经验、金币经济倍率词缀；
- 其他饰品：偏向 Boss 伤害、无视防御和基础属性，不再承担经济倍率词缀。

主词缀组内不允许重复，副词缀组内不允许重复；两个组使用独立的重复记录，因此同一词缀如果同时配置到两个池中可以重复出现。

## 4. 装备品质和词缀数量

| 品质 | 主词缀 | 副词缀 | 总数 |
| --- | ---: | ---: | ---: |
| 普通 | 0 | 0 | 0 |
| 精良 | 1 | 0 | 1 |
| 稀有 | 2 | 0 | 2 |
| 史诗 | 2 | 1 | 3 |
| 传奇 | 3 | 1 | 4 |
| 远古 | 3 | 2 | 5 |
| 神话 | 3 | 3 | 6 |

装备需求等级唯一决定词缀均值和 ±3 抽取窗口；装备品质只决定词缀数量和主/副词缀分配。

## 5. 抽取流程

1. 根据掉落来源抽取装备品质；
2. 根据装备 `reqLevel` 选择 10 级等级池；
3. 根据装备类型筛选候选词缀；
4. 排除等级未开放或没有有效数值区间的词缀；
5. 按词缀权重随机选择词缀；
6. 主词缀组和副词缀组分别禁止重复，跨组允许重复；
7. 在允许的 T 阶范围内按区间权重选择阶数；
8. 在该阶数的最小值和最大值之间随机生成最终数值。

新掉落和 `@reroll` 重铸使用同一套流程。已有装备不会自动重抽，只有重铸后才使用最新等级池和阶数规则。

## 6. 装备类型池

| 装备类型 | 主要词缀 |
| --- | --- |
| 武器 | WATK、MATK、Boss 伤害、无视防御、基础属性、职业定向攻击 |
| 帽子 | HP、MP、WDEF、MDEF、基础属性、全属性 |
| 上衣/裤子 | HP、MP、WDEF、MDEF、Boss 减伤、基础属性 |
| 鞋子 | SPEED、JUMP、HP、MP、基础属性、SPEED_JUMP |
| 手套 | WATK、MATK、基础属性、Boss 伤害、ACC、AVOID、ACC_AVOID、职业定向攻击 |
| 披风 | HP、MP、WATK、MATK、Boss 伤害、无视防御、SPEED_JUMP、职业定向攻击 |
| 戒指 | 基础属性、HP、MP、Boss 伤害、掉落率、经验率、混合属性 |
| 项链 | HP、MP、WDEF、MDEF、Boss 伤害、无视防御、Boss 减伤 |
| 耳环 | 掉落率、经验率、金币率 |
| 其他饰品 | Boss 伤害、无视防御、基础属性 |

## 7. T1–T12 全量词缀索引

本节把每个词缀逐条列出。`数值族`列对应第 2 节中已经展开的完整 T1–T12
区间，因此同一数值族的词缀不会重复抄写 12 行相同数据；`命名键`中的
`.t1` 至 `.t12` 分别对应 T1 至 T12 的实际中文/英文名称。

| 代码 | 当前名称 | 数值族（T1–T12） | 命名键 | 适用装备 |
| --- | --- | --- | --- | --- |
| `STR` | 力量 | 基础属性 | `equipment.prefix.str.t1`–`.t12` | 帽子、上衣、下衣、全身、鞋子、手套、披风、戒指、项链、耳环及其他饰品 |
| `DEX` | 敏捷 | 基础属性 | `equipment.prefix.dex.t1`–`.t12` | 同上 |
| `INT` | 智力 | 基础属性 | `equipment.prefix.int.t1`–`.t12` | 同上 |
| `LUK` | 运气 | 基础属性 | `equipment.prefix.luk.t1`–`.t12` | 同上 |
| `HP` | 最大 HP | HP/MP | `equipment.prefix.hp.t1`–`.t12` | 帽子、护甲、全身、鞋子、披风、手套、戒指、项链、耳环及其他饰品 |
| `MP` | 最大 MP | HP/MP | `equipment.prefix.mp.t1`–`.t12` | 帽子、护甲、全身、鞋子、披风、手套、戒指、项链、耳环及其他饰品 |
| `WATK` | 武器攻击力 | WATK | `equipment.prefix.watk.t1`–`.t12` | 武器、手套、披风及攻击路线饰品 |
| `MATK` | 魔法攻击力 | MATK | `equipment.prefix.matk.t1`–`.t12` | 武器、手套、披风及攻击路线饰品 |
| `WDEF` | 物理防御 | 防御 | `equipment.prefix.wdef.t1`–`.t12` | 帽子、上衣、下衣、全身、项链及防御路线饰品 |
| `MDEF` | 魔法防御 | 防御 | `equipment.prefix.mdef.t1`–`.t12` | 帽子、上衣、下衣、全身、项链及防御路线饰品 |
| `ACC` | 命中率 | 基础属性/命中回避 | `equipment.prefix.acc.t1`–`.t12` | 手套、鞋子及命中路线饰品 |
| `AVOID` | 回避率 | 基础属性/命中回避 | `equipment.prefix.avoid.t1`–`.t12` | 手套、鞋子及回避路线饰品 |
| `SPEED` | 移动速度 | 速度跳跃 | `equipment.prefix.speed.t1`–`.t12` | 鞋子、披风、手套及速度路线饰品 |
| `JUMP` | 跳跃力 | 速度跳跃 | `equipment.prefix.jump.t1`–`.t12` | 鞋子、披风及跳跃路线饰品 |
| `BOSS_DAMAGE` | Boss伤害 | 特殊百分比 | `equipment.prefix.boss_damage.t1`–`.t12` | 武器、手套、披风、戒指、项链及其他饰品 |
| `IGNORE_DEFENSE` | 无视防御 | 特殊百分比 | `equipment.prefix.ignore_defense.t1`–`.t12` | 武器、披风、项链及其他饰品 |
| `DROP_RATE` | 掉落率 | 特殊百分比 | `equipment.prefix.drop_rate.t1`–`.t12` | 戒指、耳环 |
| `EXP_RATE` | 经验率 | 特殊百分比 | `equipment.prefix.exp_rate.t1`–`.t12` | 戒指、耳环 |
| `MESO_RATE` | 金币率 | 特殊百分比 | `equipment.prefix.meso_rate.t1`–`.t12` | 戒指、耳环 |
| `BOSS_DAMAGE_REDUCTION` | Boss减伤 | 特殊百分比 | `equipment.prefix.boss_damage_reduction.t1`–`.t12` | 上衣、下衣、全身、项链 |
| `FIRE_DAMAGE` | 炽炎 | 元素百分比 | `equipment.prefix.fire_damage.t1`–`.t12` | 短杖、法杖；元素火杖/火法杖权重提高 |
| `ICE_DAMAGE` | 霜寒 | 元素百分比 | `equipment.prefix.ice_damage.t1`–`.t12` | 短杖、法杖；元素冰杖/冰法杖权重提高 |
| `LIGHTNING_DAMAGE` | 雷霆 | 元素百分比 | `equipment.prefix.lightning_damage.t1`–`.t12` | 短杖、法杖；元素雷杖/雷法杖权重提高 |
| `HOLY_DAMAGE` | 圣辉 | 元素百分比 | `equipment.prefix.holy_damage.t1`–`.t12` | 短杖、法杖；元素圣杖/圣法杖权重提高 |
| `ALL_STAT` | 全属性 | 全属性 | `equipment.prefix.all_stat.t1`–`.t12` | 帽子、护甲、全身、鞋子、手套、披风、戒指及饰品 |
| `STR_WATK` | 猛攻 | 职业攻击组合 | `equipment.prefix.str_watk.t1`–`.t12` | 战士系武器、手套、披风及力量路线装备 |
| `DEX_WATK` | 精准 | 职业攻击组合 | `equipment.prefix.dex_watk.t1`–`.t12` | 弓手/弩手/海盗武器、手套、披风及敏捷路线装备 |
| `LUK_WATK` | 诡刃 | 职业攻击组合 | `equipment.prefix.luk_watk.t1`–`.t12` | 飞侠武器、手套、披风及运气路线装备 |
| `INT_MATK` | 奥术 | 职业攻击组合 | `equipment.prefix.int_matk.t1`–`.t12` | 法师武器、手套、披风及智力路线装备 |
| `HP_MP` | 丰饶 | HP/MP 混合 | `equipment.prefix.hp_mp.t1`–`.t12` | 帽子、护甲、全身、鞋子、披风、戒指、项链、耳环 |
| `ACC_AVOID` | 灵巧 | 命中回避混合 | `equipment.prefix.acc_avoid.t1`–`.t12` | 手套、鞋子及命中/回避路线饰品 |
| `SPEED_JUMP` | 疾行 | 速度跳跃混合 | `equipment.prefix.speed_jump.t1`–`.t12` | 鞋子、披风及速度/跳跃路线饰品 |
| `WDEF_MDEF` | 守护 | 防御混合（历史兼容） | `equipment.prefix.wdef_mdef.t1`–`.t12` | 帽子、护甲、全身、项链及防御路线饰品 |
| `BOSS_DAMAGE_IGNORE_DEFENSE` | 屠戮 | 特殊百分比 | `equipment.prefix.boss_damage_ignore_defense.t1`–`.t12` | 武器、手套、披风、项链及其他饰品 |
| `DROP_EXP` | 丰收 | 特殊百分比 | `equipment.prefix.drop_exp.t1`–`.t12` | 戒指、耳环 |
| `EXP_MESO` | 富足 | 特殊百分比 | `equipment.prefix.exp_meso.t1`–`.t12` | 戒指、耳环 |
| `DROP_MESO` | 聚财 | 特殊百分比 | `equipment.prefix.drop_meso.t1`–`.t12` | 戒指、耳环 |
| `STR_ACC` | 碾压 | STR 数值族 | `equipment.prefix.str_acc.t1`–`.t12` | 力量路线护甲、手套、鞋子、饰品 |
| `DEX_SPEED` | 迅捷 | DEX 数值族 | `equipment.prefix.dex_speed.t1`–`.t12` | 敏捷路线护甲、鞋子、披风、饰品 |
| `INT_MP` | 聚能 | INT 数值族 | `equipment.prefix.int_mp.t1`–`.t12` | 智力路线护甲、披风、戒指、项链、耳环 |
| `LUK_AVOID` | 诡步 | LUK 数值族 | `equipment.prefix.luk_avoid.t1`–`.t12` | 运气路线护甲、鞋子、手套、饰品 |
| `WATK_ACC` | 穿刺 | WATK 数值族 | `equipment.prefix.watk_acc.t1`–`.t12` | 武器、手套、披风及攻击路线饰品 |
| `MATK_MP` | 奥能 | MATK 数值族 | `equipment.prefix.matk_mp.t1`–`.t12` | 武器、手套、披风及魔法路线饰品 |
| `STR_HP` | 坚韧 | STR 数值族 | `equipment.prefix.str_hp.t1`–`.t12` | 力量路线护甲、全身、披风、戒指、项链 |
| `DEX_JUMP` | 腾跃 | DEX 数值族 | `equipment.prefix.dex_jump.t1`–`.t12` | 敏捷路线鞋子、披风及饰品 |
| `INT_MDEF` | 魔御 | INT 数值族 | `equipment.prefix.int_mdef.t1`–`.t12` | 智力路线帽子、护甲、全身、项链 |
| `LUK_SPEED` | 影行 | LUK 数值族 | `equipment.prefix.luk_speed.t1`–`.t12` | 运气路线鞋子、披风及饰品 |
| `WATK_SPEED` | 迅击 | WATK 数值族 | `equipment.prefix.watk_speed.t1`–`.t12` | 武器、手套、披风及攻击路线饰品 |
| `MATK_MDEF` | 秘法壁垒 | MATK 数值族 | `equipment.prefix.matk_mdef.t1`–`.t12` | 武器、手套、披风及魔法路线防具 |
| `STR_MP` | 蓄力 | STR 数值族 | `equipment.prefix.str_mp.t1`–`.t12` | 力量路线护甲、全身、披风、戒指、项链 |
| `DEX_HP` | 活力 | DEX 数值族 | `equipment.prefix.dex_hp.t1`–`.t12` | 敏捷路线护甲、全身、披风、戒指、项链 |
| `INT_HP` | 灵魂 | INT 数值族 | `equipment.prefix.int_hp.t1`–`.t12` | 智力路线护甲、全身、披风、戒指、项链 |
| `LUK_MP` | 凝神 | LUK 数值族 | `equipment.prefix.luk_mp.t1`–`.t12` | 运气路线护甲、全身、披风、戒指、项链 |
| `HP_MDEF` | 坚壁 | HP 数值族 | `equipment.prefix.hp_mdef.t1`–`.t12` | 帽子、护甲、全身、项链及防御路线饰品 |
| `MP_MDEF` | 法障 | MP 数值族 | `equipment.prefix.mp_mdef.t1`–`.t12` | 帽子、护甲、全身、项链及防御路线饰品 |
| `HP_ACC` | 洞察 | HP 数值族 | `equipment.prefix.hp_acc.t1`–`.t12` | 手套、鞋子、戒指、耳环及其他饰品 |
| `MP_ACC` | 感知 | MP 数值族 | `equipment.prefix.mp_acc.t1`–`.t12` | 手套、鞋子、戒指、耳环及其他饰品 |

历史实例仍可能出现 `STR_INT`、`DEX_LUK`；两者使用基础双属性数值族，
但已经关闭新生成。所有混合词缀的辅助属性折算规则见第 1.3 节。

## 8. 配置和代码入口

- 等级词缀池：[V1.11.24__add_level_based_affix_pools.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.24__add_level_based_affix_pools.sql)
- 混合词缀：[V1.11.25__add_mixed_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.25__add_mixed_affixes.sql)
- 扩展混合词缀：[V1.11.40__add_extended_mixed_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.40__add_extended_mixed_affixes.sql)
- 职业适配调整：[V1.11.41__disable_cross_class_primary_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.41__disable_cross_class_primary_affixes.sql)
- 功能混合词缀：[V1.11.42__add_functional_mixed_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.42__add_functional_mixed_affixes.sql)
- 职业功能组合：[V1.11.43__add_class_utility_mixed_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.43__add_class_utility_mixed_affixes.sql)
- 跨维度组合：[V1.11.44__add_cross_dimension_mixed_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.44__add_cross_dimension_mixed_affixes.sql)
- 资源与防御组合：[V1.11.45__add_resource_defense_mixed_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.45__add_resource_defense_mixed_affixes.sql)
- T9–T12 区间：[V1.11.26__extend_affix_tiers_to_12.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.26__extend_affix_tiers_to_12.sql)
- 抽取逻辑：[EquipmentAffixGenerator.java](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/java/org/gms/client/inventory/EquipmentAffixGenerator.java)
- 运行时属性贡献：[Equip.java](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/java/org/gms/client/inventory/Equip.java)
- 配置加载：[EquipmentAffixConfigLoader.java](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/java/org/gms/client/inventory/EquipmentAffixConfigLoader.java)
- 职业限制与权重：[V1.11.46__rebalance_mixed_affix_weights.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.46__rebalance_mixed_affix_weights.sql)
- 耳环经济定位：[V1.11.47__rebalance_earring_economy_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.47__rebalance_earring_economy_affixes.sql)
- 全身装备词缀池：[V1.11.48__add_overall_affix_pool.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.48__add_overall_affix_pool.sql)
- 部位权重与属性折算：[V1.11.49__rebalance_slot_specific_affix_weights.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.49__rebalance_slot_specific_affix_weights.sql)
- 元素伤害词缀：[V1.11.50__add_elemental_damage_affixes.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.50__add_elemental_damage_affixes.sql)
- 词缀池收敛与百分比上限：[V1.11.51__compress_affix_pools_and_cap_percentages.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.51__compress_affix_pools_and_cap_percentages.sql)
- 低价值混合词缀降权：[V1.11.52__lower_low_value_mixed_affix_weights.sql](/home/qtf8184/ms/BeiDou-Server.worktrees/check-compile/gms-server/src/main/resources/db/migration/V1.11.52__lower_low_value_mixed_affix_weights.sql)

有职业要求的装备会按 `reqJob` 过滤职业不匹配的主属性、攻击属性及其混合词缀；无职业要求的装备不做该限制。单属性和职业定向攻击组合权重高于跨维度辅助组合，保证后者用于丰富词条而不是取代核心词条。

耳环单独偏向掉落、经验、金币及 HP/MP 资源词缀，攻击、Boss 伤害和无视防御词缀仅作为低权重补充。

全身装备（105 类）使用独立的 `OVERALL` 词缀池，初始沿用上衣的防御和基础属性路线；由于全身装备替代上衣和下衣两个部位，生成时额外增加 1 个主词缀，不提高单条词缀数值。上衣（104 类）与下衣（106 类）仍分别使用 `TOP`、`BOTTOM` 词缀池。

混合词缀的辅助属性不再统一按 50% 计算：HP/MP 按 65%，命中按 60%，速度/跳跃/魔法防御按 50% 折算；主属性或攻击属性仍按 100% 计算。功能百分比混合词缀的第二效果按 50% 贡献：
`BOSS_DAMAGE_IGNORE_DEFENSE` 的无视防御、`DROP_EXP` 的经验、
`EXP_MESO` 的金币和 `DROP_MESO` 的金币均按此规则计算。

## 9. P0/P1 收敛后的运行时规则

- 中文和英文资源均包含每个词缀 T1–T12 的独立命名键，共覆盖当前词缀及历史兼容词缀。
- `@inspect <栏位>` 和 `@affix <栏位>` 显示词缀名称、原始词缀值、T 阶，
  并对混合词缀追加每个实际属性贡献值；功能百分比组合的第二效果也按
  50% 实际贡献展示。
- 百分比效果上限：Boss 伤害 70%、无视防御 60%、掉落/经验/金币各 60%、
  Boss 减伤 70%、每种元素伤害 25%。
- `STR_DEX`、`INT_LUK`、`STR_INT`、`DEX_LUK`、`WATK_MATK` 仅保留历史实例，
 迁移后关闭新生成；功能混合和跨维度辅助词缀的生成权重最高为 12。
- `STR_MP`、`LUK_MP`、`INT_MP`、`DEX_HP`、`INT_HP`、`HP_ACC`、`MP_ACC`、
 `WATK_SPEED`、`MATK_MDEF`、`INT_MDEF`、`LUK_SPEED`、`DEX_JUMP` 等低价值
 混合词缀降为权重 4，仅作为低概率补充，不与职业攻击词缀竞争主要生成机会。
- 元素伤害当前统一接入普通技能伤害计算入口；只有装备元素词缀与技能元素
  匹配时生效，NEUTRAL 技能不获得元素词缀加成。
- 已修复历史迁移中的等级池索引名和部位权重 SQL 语法问题；迁移顺序仍需
  在真实 MySQL 环境执行一次完整升级验证。
