# handbook 资料梳理

更新时间：2026-08-21 11:43:14 +08:00

这份文档用于后续修改游戏系统时快速定位 handbook、玩法代码、脚本和数据库入口。

## 总入口

- [handbook/](./handbook)
- `!id` 命令读取入口：[`IdCommand`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/command/commands/gm2/IdCommand.java)

当前 `!id` 已接入的类型：

- `map`
- `etc`
- `npc`
- `use`
- `weapon`

## 修改导航表

| 系统 | handbook | 玩法入口 | 数据入口 | 脚本入口 | DB |
| --- | --- | --- | --- | --- | --- |
| 地图 / 场景 | [Map.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Map.txt) | [`MapleMap`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/maps/MapleMap.java), [`MapFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/maps/MapFactory.java), [`ChangeMapHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ChangeMapHandler.java) | [`MapId`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/constants/id/MapId.java) | [`MapScriptManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/map/MapScriptManager.java), [`MapScriptMethods`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/map/MapScriptMethods.java) | 主要看 WZ / 地图脚本，通常不依赖独立业务表 |
| 怪物 | [Mob.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Mob.txt) | [`MobSkillFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/life/MobSkillFactory.java), [`MobAttackInfoFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/life/MobAttackInfoFactory.java), [`MobDamageMobHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/MobDamageMobHandler.java), [`MobBanishPlayerHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/MobBanishPlayerHandler.java) | [`MobId`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/constants/id/MobId.java), [`MonsterbookDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/MonsterbookDO.java) | 主要是怪物行为数据，通常不靠单独脚本 | [`drop_data`]、[`drop_data_global`]、[`monsterbook`] |
| NPC | [NPC.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/NPC.txt) | [`NpcService`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/service/NpcService.java), [`NPCTalkHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/NPCTalkHandler.java), [`NPCMoreTalkHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/NPCMoreTalkHandler.java), [`NPCShopHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/NPCShopHandler.java) | [`NpcId`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/constants/id/NpcId.java) | [`NPCScriptManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/npc/NPCScriptManager.java), [`NPCConversationManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/npc/NPCConversationManager.java) | [`shops`]、[`shopitems`]、[`playernpcs`]、[`playernpcs_equip`]、[`playernpcs_field`] |
| 任务 | [Quest.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Quest.txt) | [`QuestService`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/service/QuestService.java), [`QuestActionHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/QuestActionHandler.java) | [`QueststatusDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/QueststatusDO.java), [`QuestactionsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/QuestactionsDO.java), [`QuestrequirementsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/QuestrequirementsDO.java), [`QuestprogressDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/QuestprogressDO.java) | [`QuestScriptManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/quest/QuestScriptManager.java), [`QuestActionManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/quest/QuestActionManager.java) | [`queststatus`]、[`questactions`]、[`questrequirements`]、[`questprogress`] |
| 技能 | [Skill.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Skill.txt) | [`SkillFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/SkillFactory.java), [`Skill`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/Skill.java), [`SkillBookHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/SkillBookHandler.java), [`SkillEffectHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/SkillEffectHandler.java), [`SkillMacroHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/SkillMacroHandler.java) | [`SkillsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/SkillsDO.java), [`SkillmacrosDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/SkillmacrosDO.java) | 主要看 WZ / 技能数据，通常不靠单独脚本 | [`skills`]、[`skillmacros`]、[`cooldowns`]、[`keymap`] |
| 宠物 | [Pet.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Pet.txt) | [`PetDataFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/PetDataFactory.java), [`Pet`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/Pet.java), [`PetCommandHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/PetCommandHandler.java), [`PetFoodHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/PetFoodHandler.java), [`PetLootHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/PetLootHandler.java) | [`PetsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/PetsDO.java), [`PetignoresDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/PetignoresDO.java) | 主要看宠物数据，通常不靠单独脚本 | [`pets`]、[`petignores`] |
| 道具 - 消耗 / 杂项 / 点券 / 摆设 | [Use.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Use.txt), [Etc.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Etc.txt), [Cash.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Cash.txt), [Setup.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Setup.txt) | [`ItemFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/ItemFactory.java), [`Inventory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/Inventory.java), [`Item`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/Item.java), [`UseItemHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/UseItemHandler.java), [`UseCashItemHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/UseCashItemHandler.java), [`ItemPickupHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ItemPickupHandler.java), [`ItemMoveHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ItemMoveHandler.java), [`ScrollHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ScrollHandler.java), [`ScriptedItemHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ScriptedItemHandler.java), [`ItemRewardHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ItemRewardHandler.java) | [`InventoryitemsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/InventoryitemsDO.java), [`InventoryequipmentDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/InventoryequipmentDO.java), [`ShopsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/ShopsDO.java), [`ShopitemsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/ShopitemsDO.java), [`SpecialcashitemsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/SpecialcashitemsDO.java), [`ModifiedCashItemDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/ModifiedCashItemDO.java), [`GiftsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/GiftsDO.java), [`NxcodeItemsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/NxcodeItemsDO.java), [`DueypackagesDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/DueypackagesDO.java), [`DueyitemsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/DueyitemsDO.java) | [`ItemScriptManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/item/ItemScriptManager.java), [`ItemScriptMethods`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/item/ItemScriptMethods.java) | 主要看 WZ、掉落、脚本与背包流转，DB 主要是背包、商店、点券、赠礼、收件箱 |
| 装备 | [Equip/Weapon.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Weapon.txt), [Equip/Accessory.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Accessory.txt), [Equip/Cap.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Cap.txt), [Equip/Cape.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Cape.txt), [Equip/Coat.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Coat.txt), [Equip/Face.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Face.txt), [Equip/Glove.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Glove.txt), [Equip/Hair.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Hair.txt), [Equip/Longcoat.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Longcoat.txt), [Equip/Pants.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Pants.txt), [Equip/PetEquip.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/PetEquip.txt), [Equip/Ring.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Ring.txt), [Equip/Shield.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Shield.txt), [Equip/Shoes.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Shoes.txt), [Equip/Taming.txt](/home/qtf8184/ms/BeiDou-Server/gms-server/handbook/Equip/Taming.txt) | [`Equip`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/Equip.java), [`EquipSlot`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/constants/inventory/EquipSlot.java), [`EquipType`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/constants/inventory/EquipType.java), [`InventoryMergeHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/InventoryMergeHandler.java), [`InventorySortHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/InventorySortHandler.java) | [`InventoryequipmentDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/InventoryequipmentDO.java), [`InventoryitemsDO`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/dao/entity/InventoryitemsDO.java) | 主要看 WZ 与背包数据，独立脚本通常较少 |

## 补充说明

- `DB` 一栏写的是常见入口，不是完整表清单。
- `handbook` 只负责索引，真正规则通常在玩法代码、脚本和数据库里。
- 如果后续你要改某个系统，我可以直接按这张表继续拆成“改动点清单”。

## 改动清单

| 系统 | 常改文件 | 相关表 | 风险点 |
| --- | --- | --- | --- |
| 地图 / 场景 | [`MapleMap`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/maps/MapleMap.java), [`MapFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/maps/MapFactory.java), [`ChangeMapHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ChangeMapHandler.java), [`MapScriptManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/map/MapScriptManager.java) | 无固定主表 | 地图脚本和地图数据分离，改切图逻辑时要同时看脚本和地图加载 |
| 怪物 | [`MobSkillFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/life/MobSkillFactory.java), [`MobAttackInfoFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/life/MobAttackInfoFactory.java), [`MobDamageMobHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/MobDamageMobHandler.java) | [`drop_data`]、[`drop_data_global`]、[`monsterbook`] | 掉落、图鉴、技能行为常常彼此联动，改一处容易漏另一处 |
| NPC | [`NpcService`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/service/NpcService.java), [`NPCTalkHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/NPCTalkHandler.java), [`NPCShopHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/NPCShopHandler.java), [`NPCScriptManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/npc/NPCScriptManager.java) | [`shops`]、[`shopitems`]、[`playernpcs`]、[`playernpcs_equip`]、[`playernpcs_field`] | 对话、商店、玩家商人是三条链路，改动前先确认是脚本还是服务逻辑 |
| 任务 | [`QuestService`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/service/QuestService.java), [`QuestActionHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/QuestActionHandler.java), [`QuestScriptManager`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/scripting/quest/QuestScriptManager.java) | [`queststatus`]、[`questactions`]、[`questrequirements`]、[`questprogress`] | 任务状态机最容易漏状态回写，改奖励和完成条件时要核对持久化 |
| 技能 | [`SkillFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/SkillFactory.java), [`SkillEffectHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/SkillEffectHandler.java), [`SkillMacroHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/SkillMacroHandler.java) | [`skills`]、[`skillmacros`]、[`keymap`]、[`cooldowns`] | 技能效果、快捷键和冷却常常互相影响，改数值后要一起验 |
| 宠物 | [`PetDataFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/PetDataFactory.java), [`PetFoodHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/PetFoodHandler.java), [`PetLootHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/PetLootHandler.java) | [`pets`]、[`petignores`] | 自动拾取、喂养、指令都可能影响玩家体验，改动要注意默认行为 |
| 道具 / 背包 | [`ItemFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/ItemFactory.java), [`Inventory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/Inventory.java), [`ItemPickupHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ItemPickupHandler.java), [`UseItemHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/UseItemHandler.java), [`ItemRewardHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ItemRewardHandler.java) | [`inventoryitems`]、[`inventoryequipment`]、[`shops`]、[`shopitems`]、[`specialcashitems`]、[`modified_cash_item`]、[`gifts`]、[`dueypackages`]、[`dueyitems`] | 背包、商店、点券、收件箱是多入口共用，改动时要防止类型分支不一致 |
| 装备 | [`Equip`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/Equip.java), [`EquipSlot`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/constants/inventory/EquipSlot.java), [`ScrollHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/ScrollHandler.java), [`InventoryMergeHandler`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/net/server/channel/handlers/InventoryMergeHandler.java) | [`inventoryequipment`]、[`inventoryitems`] | 强化、穿戴、整理都共享装备实例，改属性逻辑时要防止复制/持久化不同步 |

## 快速查找顺序

1. 先查 [handbook/](./handbook) 定位 ID。
2. 再查对应系统的玩法入口和 handler。
3. 如果涉及数据存储，再看 DB 表和 DAO。
4. 如果涉及对话、任务、地图、道具脚本，再查 `scripting/`。

## 改动优先级清单

如果你要先开刀一个系统，建议按这个顺序：

1. **NPC / 商店 / 对话**
   - 入口最集中，脚本和服务边界清晰
   - 适合先熟悉对话流、商店流、脚本流
2. **道具 / 背包**
   - 改动频率高，覆盖面大
   - 适合先确认背包、掉落、商店、点券的共用链路
3. **任务**
   - 逻辑清晰，但状态回写多
   - 适合系统性梳理状态机与脚本联动
4. **技能**
   - 数值和效果影响面广
   - 适合在熟悉角色/战斗流程后再动
5. **地图 / 怪物**
   - 和 WZ、脚本、战斗逻辑耦合较强
   - 适合最后做大范围联动调整
6. **宠物 / 装备**
   - 细分逻辑多，依赖背包和掉落系统
   - 适合在前面几类打通后一起收口

## 系统改动模板

每次改一个系统时，可以按这个模板推进：

### 1. 先定位资料

- 查 handbook 里的 ID / 名称
- 明确要改的是哪一类对象
- 记录关联对象：NPC、地图、任务、道具、技能、怪物

### 2. 再定位入口

- 找玩法入口：`service` / `server` / `client`
- 找网络入口：`net/server/channel/handlers`
- 找脚本入口：`scripting/*`

### 3. 再定位数据

- 查对应的 `dao/entity`
- 查相关 `mapper`
- 查是否有缓存、工厂类、单例类

### 4. 再确认联动点

- 是否会影响其他系统
- 是否会影响 DB 持久化
- 是否会影响脚本调用
- 是否会影响客户端显示或提示

### 5. 最后验证

- 本地编译是否通过
- 相关流程是否能跑通
- 是否需要补 handbook 或脚本说明

## 装备词条系统（第一阶段）

- 数据迁移：[`V1.11.6__create_equipment_affix.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.6__create_equipment_affix.sql)
- 装备运行时词条：[`EquipmentAffix`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/EquipmentAffix.java)
- 配置读取：[`EquipmentAffixConfigLoader`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/EquipmentAffixConfigLoader.java)
- 装备持久化：[`ItemFactory`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/ItemFactory.java)

当前已支持装备品质和词条实例的数据库读写，以及怪物/反应堆装备掉落的品质和词条生成；Boss 伤害和无视防御已在 [`MapleMap.damageMonster`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/maps/MapleMap.java) 的统一伤害入口应用，经验率、金币率、掉落率和 Boss 减伤已接入角色倍率/受击流程。

词条系统现在区分：

- 装备品质：保存在 `inventoryequipment.rarity`，只决定主/副词条数量。
- 词条类型：保存在 `inventory_equipment_affix.affix_code`，表示属性或特殊效果。
- 词条品质：保存在 `inventory_equipment_affix.affix_tier`，独立决定该条词条的数值区间。
- T5–T8 数值区间由 [`V1.11.13__add_affix_tier_5_to_8.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.13__add_affix_tier_5_to_8.sql) 补齐；词条 T 阶由装备需求等级均值和钟形波动决定。
- 对应迁移：[`V1.11.7__split_affix_tier.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.7__split_affix_tier.sql)
- 词条命名：[`V1.11.8__create_affix_names.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.8__create_affix_names.sql)，按词条类型和 T1–T8 分别配置名称键。
- 玩家查看：装备拾取成功后会通过聊天提示显示词条；普通玩家可使用 `@inspect` 列出装备栏，使用 `@inspect <装备栏位>` 查看完整词条，也可使用 `@affix` 别名。命令由 [`V1.11.9__add_inspect_command.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.9__add_inspect_command.sql) 和 [`V1.11.10__add_affix_command_alias.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.10__add_affix_command_alias.sql) 注册。
- 固定属性词条与混沌值已在运行时分离：`Equip` 的原始属性保存装备本体/卷轴变化，词条贡献根据 `inventory_equipment_affix` 动态叠加到对外属性；数据库兼容加载旧装备时会从已保存总值中扣除词条贡献，混沌卷轴通过现有 getter/setter 只改变本体值。
- 词条生命周期：[`V1.11.11__add_affix_lock.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.11__add_affix_lock.sql) 增加锁定状态；[`V1.11.12__add_affix_lifecycle_commands.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.12__add_affix_lifecycle_commands.sql) 注册 `@reroll <栏位>`、`@lockaffix <栏位> <词条序号>` 和 `@salvage <栏位>`。重铸费用按装备品质以 1.8 倍指数增长，按锁定词条数量再乘以 1.6 的指数倍率；重铸保留已锁定词条，锁定状态持久化，分解装备返还金币。
- 词条工匠 NPC：复用已有 `9977777` NPC 外观，在自由市场 `910000000` 增加一个 NPC 位置；脚本在该地图显示词条服务菜单，在其他地图保留原开发者 NPC 功能。配置位于 [`910000000.img.xml`](/home/qtf8184/ms/BeiDou-Server/gms-server/wz/Map.wz/Map/Map9/910000000.img.xml) 和 [`9977777.js`](/home/qtf8184/ms/BeiDou-Server/gms-server/scripts/npc/9977777.js)。
- 分解金币由 [`EquipmentValueCalculator.java`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/EquipmentValueCalculator.java) 统一计算：WZ/NPC 基础售价按 60%计入，再乘装备品质倍率并叠加词条 T 等阶溢价；强化属性和混沌变化不计入，结果按百位取整并限制在金币上限内。

### 当前状态（2026-08-18）

- **已完成并可试玩**：装备品质随机生成、20 种词条类型、T1–T8 命名和数值区间、词条持久化、词条贡献与装备本体属性分离、拾取提示、`@inspect`/`@affix`、重铸、锁定、分解，以及自由市场词条工匠 NPC。
- **词条生效范围**：词条属于具体装备实例，数据通过 `inventoryitemid` 关联；属性词条叠加到装备属性，经验/掉落/金币、Boss 增伤、Boss 减伤和无视防御只统计 `InventoryType.EQUIPPED` 中已穿戴的装备，背包装备不会提供角色效果。
- **无视防御实现**：由于 v83 客户端提交的是已计算伤害，服务端在 [`MapleMap.damageMonster`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/server/maps/MapleMap.java) 使用怪物防御计算有限的伤害补偿；装备无视率封顶 80%，该效果造成的最终伤害最多为原伤害的 2 倍，不直接修改怪物防御属性。
- **数据库更新**：服务端启动时由 Flyway 自动执行未完成迁移；T5–T8 区间由 [`V1.11.13__add_affix_tier_5_to_8.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.13__add_affix_tier_5_to_8.sql) 补齐。
- **掉落来源概率**：[`V1.11.14__add_equipment_drop_source_weights.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.14__add_equipment_drop_source_weights.sql) 增加普通掉落、Boss 掉落、副本掉落和百宝箱四套品质权重；普通怪物沿用原概率，Boss 与副本概率已按需求对调，百宝箱装备使用独立的 GACHAPON 权重。生成入口由 [`EquipmentDropSource`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/client/inventory/EquipmentDropSource.java) 标识。
- **百宝箱装备**：[`GachaponService`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/java/org/gms/service/GachaponService.java) 抽到装备时会先随机基础属性，再生成品质和词条后放入背包；非装备奖励仍沿用原有百宝箱奖池流程。
- **收藏卡片统计**：收藏家腰带按账号下所有角色的怪物卡数量累计，并按卡片 ID 在账号范围内封顶 5 张；每 25 张累计卡片提供一次全属性加成，不要求先完成整套图鉴。在线角色使用内存进度、离线角色使用数据库，避免等待自动保存后才生效。
- **收藏属性展示**：`@collection`/`@collect`、收藏家 NPC 和收藏里程碑提示共用实时摘要，显示账号卡片/任务进度、腰带等级（卡片档位+任务档位）、已解锁档位、下一档距离、腰带装备状态和实际加成；装备或卸下收藏家腰带时会主动提示。
- **虚拟背包客户端同步**：卷轴背包 `2430011` 和矿石背包 `2430012` 当前复用 NPC `9010000` 的图标资源，并在服务端 WZ 中配置名称、描述和物品脚本；发布时需同步客户端对应的 `Consume.wz` 资源，确认客户端显示正确。
- **锻造与虚拟背包**：Maker 制作材料统计现在包含虚拟背包中的卷轴/矿石，扣除材料仍复用现有库存操作；锻造装备在催化剂、强化宝石和随机属性最终确定后，会按普通来源生成装备品质与词条。
- **候选装备等级重分层（2026-08-20）**：针对首批非现金、非套装候选装备，已将不适合当前 v83 进度的 `225/265/275` 级要求调整为四档：普通四王帽为 `100` 级，Ravana Helmet 为 `120` 级（当前仅有装备资源，尚未接入 Ravana Boss），混沌四王帽为 `140` 级，Highness 与 Eagle Eye 系列为 `160` 级；Chaos Zakum Helmet 原本为 `100` 级，保持不变。实际装备数据已同步修改到 `Character.wz`，客户端发布时需同步对应 WZ。
- **候选装备获取方式（2026-08-20）**：[`V1.11.20__add_candidate_equipment_maker_recipes.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.20__add_candidate_equipment_maker_recipes.sql) 将 Chaos Zakum、普通/混沌四王帽、Highness 与 Eagle Eye 系列接入 Maker；Chaos Zakum Helmet 制作需要 `1002357 Zakum Helmet`；Ravana Helmet 通过 [`V1.11.22__add_ravana_helmet_maker_recipe.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.22__add_ravana_helmet_maker_recipe.sql) 接入 Maker，不依赖不存在的 Ravana Boss。当前 v83 Maker 技能最高为 3 级，新增配方统一要求 Maker 3，通过玩家等级、底材、材料和金币消耗区分装备档次。
- **候选装备材料门槛（2026-08-20）**：新增配方额外需要现有 Boss 证明材料：`4001083 Zakum Certificate`、`4001084 Papulatus Certificate` 和 `4001085 Pianus Certificate`。普通四王帽需要少量证明材料，混沌四王帽、Highness 与 Eagle Eye 按档次递增，避免只依赖普通矿石和怪物结晶即可制作。
- **Boss 证明材料数量调整（2026-08-20）**：按每次 Boss 通常只获得 1 枚证明材料重新下调配方数量；强化 Chaos Zakum Helmet 现在需要 Zakum `4`、Papulatus `2`、Pianus `2` 枚，其他装备也按普通、混沌和高阶三个阶段递增，避免单件装备需要数十次重复 Boss。
- **通用 Boss 锻造代币（2026-08-20）**：复用已有 `4001083 Zakum Certificate` 作为通用锻造代币，不新增客户端物品资源；Papulatus、Pianus、Zakum 和 Horntail 终阶段 Boss 会固定掉落 1–4 枚，现有配方中对 `4001083` 的需求因此可以由多个中高等级 Boss 提供。另已纠正旧配置：当前 `8510000` 是 Pianus，仓库没有 Ravana Boss 数据，移除错误的 Ravana Helmet 掉落配置。
- **首件强化装备（2026-08-20）**：新增服务端装备 `1003113 Reinforced Chaos Zakum Helmet`，由 `1003112 Chaos Zakum Helmet`、Boss 证明材料、高级怪物结晶和 Rock of Time 锻造；装备 WZ 资源复制自现有 Chaos Zakum Helmet 并调整为全属性 `+30`、物防/魔防 `+240`、等级要求 `120`、升级次数 `8`，避免生成缺少图标或属性的空白装备。客户端发布时仍需将该资源转换并补丁到对应 `.img`。
- **暂缓事项**：装备词条系统暂不继续扩展新词条。后续如重新开发，优先处理重铸/分解事务与并发保护、交易和商店状态校验、NPC 服务层抽取，以及基于实战数据的 T5–T8 数值平衡。

### 待排查：自由市场 NPC 坐标重叠（2026-08-20）

- 现象：自由市场 `910000000` 中新增的 `9977777`、`9977778`、`9977779` 三个 NPC 实际显示时挤在一起；客户端小地图显示它们应位于右上方并分开站立。
- 已定位的配置：WZ 地图文件 [`910000000.img.xml`](/home/qtf8184/ms/BeiDou-Server/gms-server/wz/Map.wz/Map/Map9/910000000.img.xml) 中三者坐标分别为 `x=450/490/530`、`y=-179`，且共用 `fh=31`。
- 重点怀疑项：
  1. `MapFactory` 会先从 WZ 的 `life` 节点加载 NPC，再从数据库 `plife` 表加载同地图、同世界的 NPC；数据库记录可能覆盖或额外生成了错误坐标。
  2. 服务端读取的是当前生效的 `wz/` 数据；若只修改了语言覆盖目录、客户端 WZ/IMG 或未重启地图缓存，服务端与小地图显示可能来自不同版本的数据。
  3. 地图实例缓存会保留已加载的 NPC 对象，修改 WZ 或 `plife` 后需要重启服务端（至少重建该频道地图实例）才能验证。
- 待处理：查询 `plife` 中 `map=910000000` 且 `life IN (9977777,9977778,9977779)` 的记录，确认是否存在重复/错误坐标；再核对服务端实际加载目录与客户端小地图数据，最后重启后复测。

### 会话交接记录（2026-08-21）

- 当前工作已提交并推送到 `agents/check-compile`，提交 `22e048787`。
- 客户端同步清单见 [`CLIENT_SYNC_MANIFEST_2026-08-20.md`](/home/qtf8184/ms/BeiDou-Server/CLIENT_SYNC_MANIFEST_2026-08-20.md)。
- 下一阶段优先事项：制作客户端 XML→IMG 补丁；补齐 Timeless 武器/饰品及 120–155 级职业装备；完善装备分解、材料转换和锻造订单。
- 客户端没有源码，只有转换后的 `.img`；新增装备 `1003113` 必须写入客户端 `Character/Cap` 和 `String/Eqp`，已有装备等级修改应使用 MODIFY，不要重复 ADD。
- 数据库迁移需先检查 `flyway_schema_history`；若 `V1.11.20` 已执行，不要修改旧迁移，后续修正使用新版本迁移。
- **120–155 级职业装备扩展（2026-08-21）**：新增 [`V1.11.23__add_level_120_to_155_equipment_maker_recipes.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.23__add_level_120_to_155_equipment_maker_recipes.sql)，接入 WZ 中已有资源但原 Maker 数据未覆盖的 VIP 战士/法师/弓手盾牌、VIP 项链/腰带/戒指、两件 120 级披风，以及三件 130 级 Elemental Wand。所有新增产物均已核对 `Character.wz` 的 `info` 节点和 `reqLevel`，没有创建空白装备；材料使用现有怪物结晶、时间之石和 Boss 证明/通用代币。
- **等级词条池与全属性词条（2026-08-21）**：新增 [`V1.11.24__add_level_based_affix_pools.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.24__add_level_based_affix_pools.sql)，按装备需求等级每 10 级建立独立词条池，低等级装备屏蔽 Boss/掉落/经验等特殊词条，高等级装备提高攻击、魔攻和特殊词条权重；100 级以上装备新增 `ALL_STAT` 全属性词条，运行时会分别贡献到 STR/DEX/INT/LUK，不会写入装备本体。新装备生成和已有装备重铸共用该等级池。
- **混合词缀扩展（2026-08-21）**：新增 [`V1.11.25__add_mixed_affixes.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.25__add_mixed_affixes.sql)，加入 `STR_DEX`、`INT_LUK`、`WATK_MATK`、`HP_MP`、`ACC_AVOID`、`SPEED_JUMP` 六类混合词缀。混合词缀仍以一个实例词缀保存和展示，但运行时拆分贡献到对应的两个基础属性；按等级段和装备类型限制出现范围，避免低等级装备直接抽到高阶混合效果。
- **词缀阶数扩展（2026-08-21）**：新增 [`V1.11.26__extend_affix_tiers_to_12.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.26__extend_affix_tiers_to_12.sql)，将词缀阶数从 T1–T8 扩展到 T1–T12。T9–T12 基于各词缀 T8 区间按倍率递增生成，品质最高阶同步调整为：精良 T2、稀有 T4、史诗 T6、传奇 T8、远古 T10、神话 T12；同时按装备需求等级限制最高阶数（100 级开放 T9、120 级开放 T10、140 级开放 T11、160 级开放 T12），显示层增加 T9–T12 的中英文降级名称。
- **魔法攻击词缀平衡（2026-08-21）**：新增 [`V1.11.27__double_matk_affix_ranges.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.27__double_matk_affix_ranges.sql)，将独立 `MATK` 词缀各阶数值调整为对应 `WATK` 范围的 2 倍；`WATK_MATK` 混合词缀仍使用共享值，同时贡献给两种属性。
- **高阶词缀区分度调整（2026-08-21）**：新增 [`V1.11.28__rebalance_affix_tier_9_to_12.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.28__rebalance_affix_tier_9_to_12.sql)，将 T9–T12 统一调整为对应 T8 区间的 1.15、1.40、1.75、2.20 倍，在控制数值膨胀的同时拉开高阶词缀区分度。
- **恢复保守高阶词缀倍率（2026-08-21）**：新增 [`V1.11.29__restore_conservative_affix_tier_progression.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.29__restore_conservative_affix_tier_progression.sql)，将 T9–T12 恢复为 T8 的 1.15、1.35、1.60、1.90 倍；该版本的独立 `MATK` 倍率随后由 `V1.11.30` 的最终克制区间覆盖。
- **克制词缀数值方案（2026-08-21）**：新增 [`V1.11.30__apply_conservative_affix_ranges.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.30__apply_conservative_affix_ranges.sql)，将固定属性压缩至原配置约 20%，百分比效果压缩至约 15%，并将独立 `MATK` 与 `WATK` 统一纳入克制区间；混合词缀同步降低，所有最小值不低于 1。
- **混合词缀再平衡（2026-08-21）**：新增 [`V1.11.31__rebalance_mixed_affix_ranges.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.31__rebalance_mixed_affix_ranges.sql)，双属性混合词缀的每个属性按对应单属性约 75% 配置，`ALL_STAT` 每项按基础属性约 40% 配置，并修正 `ACC_AVOID`、`SPEED_JUMP` 的独立区间。
- **职业定向攻击词缀（2026-08-21）**：新增 [`V1.11.32__replace_watk_matk_hybrid_affix.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.32__replace_watk_matk_hybrid_affix.sql)，停止新装备生成 `WATK_MATK`，改为 `STR_WATK`、`DEX_WATK`、`LUK_WATK`、`INT_MATK` 四类定向词缀；历史 `WATK_MATK` 实例仍可加载和生效。
- **主副词缀分组（2026-08-21）**：新增 [`V1.11.33__split_primary_secondary_affix_pools.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.33__split_primary_secondary_affix_pools.sql)，按品质分配最多 3 个主词缀和 3 个副词缀。主词缀组内、副词缀组内分别禁止重复，两个组使用独立重复集合；主池包含基础战斗属性，副池包含命中/移动/倍率等功能效果。
- **副池核心词缀低权重混入（2026-08-21）**：新增 [`V1.11.34__add_core_affixes_to_secondary_pool.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.34__add_core_affixes_to_secondary_pool.sql)，将 `STR`、`DEX`、`INT`、`LUK`、`WATK`、`MATK` 以约 10% 的主池权重复制到副池；同一核心词缀可以同时出现在主、副词缀组，形成低概率极品双词条。
- **词缀等级平滑成长（2026-08-21）**：装备需求等级每提升 10 级，最高可抽取词缀等级提升 1 阶：1–9 级为 T1，10–19 级为 T2，依次递进，110 级及以上封顶 T12；最终仍受装备品质最高阶限制。
- **词缀阶级钟形抽取（2026-08-21）**：词缀等级以装备阶段对应阶级为均值；80 级前在均值 ±3 阶内抽取，80–119 级扩大到 ±4 阶，120 级以上扩大到 ±5 阶。品质只决定词缀数量和主/副词缀分配，不再限制词缀阶级；高等级距离均值较远的词条仍使用较低权重。
- **百分比词缀收益上限（2026-08-21）**：装备提供的 Boss 伤害、掉落率、经验率和金币率分别按总和封顶 100%；无视防御继续封顶 80%，Boss 减伤继续封顶 70%，避免多件装备叠加后失控。
- **装备类型候选池补齐（2026-08-21）**：新增 [`V1.11.35__fill_affix_pool_slot_candidates.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.35__fill_affix_pool_slot_candidates.sql)，为鞋子和手套补充合理的基础属性主词缀，为防具补充低权重 HP/MP/防御副词缀，避免高品质装备因候选不足而无法填满已配置槽位。
- **魔攻物攻价值校准（2026-08-21）**：新增 [`V1.11.36__normalize_matk_affix_ranges.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.36__normalize_matk_affix_ranges.sql)，将独立 `MATK` 区间调整为对应 `WATK` 的 2 倍；`INT_MATK` 混合词缀运行时按 `INT + 2×MATK` 贡献。
- **低等级高阶词缀软折扣（2026-08-21）**：80 级以下抽到高于装备均值的词缀时，每高出 1 阶将最终数值乘以 85%，最低保留 1，保留稀有高阶结果但避免低级装备数值跳跃过大。
- **移除废弃品质阶级上限（2026-08-21）**：新增 [`V1.11.37__remove_unused_rarity_tier_cap.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.37__remove_unused_rarity_tier_cap.sql)，删除不再参与抽取的 `equipment_rarity_config.max_affix_tier` 字段，避免品质配置与运行时规则产生歧义。
- **部位词缀池多样化（2026-08-21）**：新增 [`V1.11.38__diversify_equipment_affix_pools.sql`](/home/qtf8184/ms/BeiDou-Server/gms-server/src/main/resources/db/migration/V1.11.38__diversify_equipment_affix_pools.sql)，为上衣/裤子和项链增加低权重基础属性主词缀，保留帽子生存副词缀，并将戒指的功能定位为掉落/经验/金币、其他饰品定位为 Boss/无视防御。

## 项目改动总览（截至 2026-08-31）

本节记录当前仓库已经落地的主要功能改动，作为后续开发和客户端同步的总索引。版本迁移以 `V1.11.x` 为准；服务端 WZ、语言覆盖层和脚本必须成对检查。

### 1. 装备词条、收藏与装备成长

- **装备词条系统**：支持装备品质、T1–T8 词条、属性/倍率/条件效果、词条持久化、拾取提示、`@inspect`/`@affix` 查看、锁定、重铸和分解。
- **词条计算链路**：`Equip` 原始属性与词条贡献分离；穿戴中的装备才提供经验、金币、掉落、Boss 增伤/减伤和无视防御效果；混沌卷轴只修改装备本体值。
- **收藏系统**：账号共享卡片/任务进度，怪物卡按卡片 ID 在账号范围内封顶 5 张；每累计 25 张提供收藏家腰带属性，任务按不同任务 ID统计；腰带等级为卡片奖励档位与任务奖励档位之和；在线角色使用内存快照、离线角色使用数据库；支持 `@collection`/`@collect`、NPC `9977779` 和里程碑提示。
- **装备等级重分层**：普通四王帽 100 级、Ravana Helmet 120 级、混沌四王帽 140 级、Highness/Eagle Eye 160 级；当前没有 Ravana Boss，`1003068` 通过 Maker 获取。
- **首件强化装备**：新增 `1003113 Reinforced Chaos Zakum Helmet`，从 `1003112` 锻造，WZ 资源完整复制并调整为全属性 +30、物防/魔防 +240、120 级、8 次升级，避免空白装备。

### 2. 锻造、Boss 材料和虚拟背包

- **Maker 改造**：新增首批非现金装备配方，Maker 统一要求 3 级；配方通过玩家等级、底材、普通材料、Boss 证明、金币和前置装备区分档次。
- **Timeless/Reverse 覆盖**：原有 Maker 数据已覆盖主要 Timeless/Reverse 武器、防具和盾牌；新增迁移继续补齐 WZ 中真实存在但原数据遗漏的 120–155 级装备。
- **2026-08-21 新增配方**：`V1.11.23` 接入 `1092074/1092079/1092084` VIP 盾牌、`1122085` VIP 项链、`1132040` VIP 腰带、`1112439` VIP 戒指、`1102194/1102207` 披风和 `1372039/1372041/1372042` Elemental Wand。
- **通用 Boss 锻造代币**：复用 `4001083 Zakum Certificate`；Papulatus、Pianus、Zakum、Horntail 终阶段 Boss 固定掉落 1–4 枚。`8510000` 已确认是 Pianus，不是 Ravana，并移除错误的 Ravana 掉落。
- **虚拟卷轴/矿石背包**：入口道具为 `2430011`、`2430012`，支持登录补发、新角色创建入包、双击打开、自动收纳、堆叠、查看、取出、持久化，以及 Maker 材料统计和扣除。
- **虚拟背包脚本**：`VirtualScrollSatchel.js`、`VirtualOreSatchel.js` 同步维护英文和中文脚本；脚本通过 `ItemScriptMethods` 与 `NPCConversationManager` 提供对话能力。

### 3. 美容、随机头脸和自定义 NPC

- **美容 NPC**：`9977778` 已关闭直接选择指定发型/脸型/肤色及对应分页入口，保留三类存档管理、槽位购买和试衣间预览；随机美容盒和其他原版美容 NPC 保留。
- **美容存档**：继续使用 `beauty_slots` 表和 `BeautySlotService`；发型、脸型、肤色按账号分别保存，默认各 5 个槽位，可付费扩展，应用存档时仍可预览并确认。
- **随机美容券**：初始道具 `2438000`，全局掉落并随机更换发型、脸型和肤色；后改为复用已有神秘盒子 `2430029` 的图标和显示资源，避免新增空白客户端图标。随机池独立维护，不依赖 `9977778`。
- **随机资源安全限制**：随机美容脚本只使用客户端真实存在的颜色变体，剔除缺失变体，避免客户端闪退；`9977778` 已不再提供自选外观池。
- **自由市场 NPC**：词条工匠 `9977777`、美容师 `9977778`、收藏家 `9977779` 放置于 `910000000` 中层平台；位置为约 `x=500/800/1100, y=-266`，并使用正确的全局 foothold 编号 `fh=53/44/45`，解决画面重叠和悬空问题。
- **自定义 NPC 交互**：词条工匠的锁定/解锁使用可点击词条列表，重铸/分解取消后回到装备选择；美容师显示当前造型并在覆盖存档前确认；收藏家显示腰带状态和进度，详情页可返回主菜单。英文基础脚本与中文覆盖脚本分别使用对应语言。
- **NPC 外观与语言**：补齐三个自定义 NPC 的客户端形象、中英文名称；帮助 NPC 菜单已收缩为资料查询和自由市场传送。

### 4. 商城与道具资源

- **商城商品分类**：商城新增装备按帽子、上衣、裤子、鞋子、手套、披风、武器等 12 个类型页面重新分配 SN，避免新增商品落入错误分类。
- **商城语言合并**：`DataProviderFactory` 和 `CashShop` 同时读取英文基础商城与语言覆盖层，按 SN 合并覆盖，修复中文/英文资源中新增商城商品无法购买的问题。
- **商城资源要求**：新增商城道具必须同时检查 `Etc.wz/Commodity.img.xml`、英文/中文 String/WZ、SN 唯一性和 Cash Shop 商品加载逻辑；不能只修改显示文本。
- **入口道具显示**：虚拟背包和随机美容相关道具复用已有客户端图标时，服务端 WZ 的名称、描述和脚本仍需同步；发布前必须制作客户端 `.img` 补丁。`9977778` 美容师停用文案变更还需同步 `String/Npc.img`。

### 5. 赏金、掉落和背包

- **赏金猎人系统**：通缉怪 `9900000–9900004`，定时从 39 张非主城打怪地图中随机选择地图，30 分钟一轮，全服公告，击杀奖励 200 万金币及 `2430029`。
- **赏金判定修复**：击杀校验同时使用怪物 OID 和地图，避免不同地图 OID 相同导致误判。
- **背包容量**：普通背包上限由 96 格扩展至 127 格，相关客户端同步需确认 UI 是否支持。
- **掉落调整**：通缉怪赏金及掉落、随机美容券全局掉落、Boss 锻造代币掉落均已通过独立 Flyway 迁移配置。

### 6. 技能和战斗平衡

- **武器倍率**：全面提高武器倍率，斧/钝器与单手武器额外加强。
- **精准/精通**：熟练度满级提高到 70；剑/枪/拳增加移动，矛增加攻击，弓/弩/短刀增加闪避；补齐精准斧缺失的客户端攻击属性。
- **圣箭术**：改为 3 段、每段 3 目标，满级每段 60% 魔攻。
- **法师主攻技能**：火焰箭、末日烈焰、火毒合击、冰冻术、冰咆哮、落雷枪、冰雷合击、圣光的伤害、目标数量、范围和延迟已按当前方案调整。
- **技能一览**：新增技能清单 Markdown/HTML，解析 `Skill.wz` 和 `String.wz`，包含技能帧数与总延迟；生成脚本为 `.tools/scripts/export_skills.js`。
- **客户端约束**：v83 客户端提交已计算伤害，技能数值和动画延迟改动必须同步客户端 `Skill.wz`，服务端单独修改不会完整生效。

### 7. 项目文档、迁移和验证

- 已创建 [`docs/CURRENT_STATE.md`](/home/qtf8184/ms/BeiDou-Server/docs/CURRENT_STATE.md) 作为新会话恢复入口。
- 已创建 [`CLIENT_SYNC_MANIFEST_2026-08-20.md`](/home/qtf8184/ms/BeiDou-Server/CLIENT_SYNC_MANIFEST_2026-08-20.md)，记录服务端 XML 到客户端 IMG 的同步路径和 ADD/MODIFY 规则。
- 已新增 `V1.11.16` 随机美容券、`V1.11.17` 美容槽位、`V1.11.18` 美容券图标切换、`V1.11.19` 虚拟背包、`V1.11.20–V1.11.23` 锻造/装备相关迁移；`V1.11.54` 增加肤色存档槽位上限。
- 数据库迁移不得修改已执行版本；若 `flyway_schema_history` 已存在旧版本，修正必须新增更高版本迁移。
- 已验证：Java 21 执行 `mvn -pl gms-server -DskipTests compile` 通过，`git diff --check` 通过。

### 8. 当前未完成或需要客户端配合

- 客户端 `.img` 补丁尚未在本仓库制作：虚拟背包入口、随机美容/神秘盒子、装备等级变更、新增 `1003113`、新增 120–155 级装备和商城资源都需按客户端仓库实际内容制作。
- `V1.11.23` 尚未提交；部署前检查 `flyway_schema_history` 和全新数据库升级顺序。
- 装备词条后续重点仍是重铸/分解并发保护、交易/商店状态校验、NPC 服务层抽取和 T5–T8 数值平衡。
- 自由市场 NPC 若再次移动，必须同时核对 WZ `life`、数据库 `plife`、服务端地图缓存和客户端地图数据。
