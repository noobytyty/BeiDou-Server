# 北斗私服 · 当前项目状态（2026-08-21）

> 本文件是**新会话恢复上下文**的入口。新会话先读本文件，再按需读 `beidou-devops` skill 和具体文件。
> 维护：每次开发会话结束时更新本文件。

## 1. 环境速查

| 项 | 值 |
|---|---|
| 服务端仓库 | `F:\beidou\BeiDou-Server`，git 分支 `agents/check-compile`（已配代理推送） |
| 客户端 | `F:\beidou\BeiDou-Client`（Data=中文基础，SwitchChinese=true 只读 Data） |
| 服务端 wz | `gms-server/wz/`（英文）+ `gms-server/wz-zh-CN/`（中文覆盖，优先） |
| 脚本 | `gms-server/scripts/` + `gms-server/scripts-zh-CN/`（zh-CN 优先） |
| 编译 | Maven 3.9.16（`.tools\maven\...`），`mvn -pl gms-server -DskipTests package` |
| 启动 | `java '-Dspring.config.location=application.yml' -jar target\BeiDou.jar`（workdir=gms-server） |
| WZ 工具 | `.tools\orange-wz-cli\target\xml-img-patcher.jar` |
| 数据库 | `beidou`（root/root），Flyway 迁移 V1.11.x，当前 v1.11.22 |
| 服务端运行 | 后台任务，端口 8484/7575-77/8686 |

## 2. 自定义系统（已实现）

| 系统 | 关键点 |
|---|---|
| **收藏系统** | 怪物卡(25张/全属性+1) + 任务(50个/全属性+1攻+1HP/MP+100)，戴**收藏家腰带 1132991** 生效；成就勋章 1142992-98。NPC 9977779 |
| **词条系统** | 装备词条查看/重铸/锁定/分解。NPC 9977777（脚本已重写为纯词条，`start/action` 标准结构） |
| **美容系统** | 发型/脸型选择分页 + 存档槽位（**账号级**，beauty_slots 表）+ 试衣间预览 + 购买槽位。NPC 9977778 |
| **赏金系统** | 通缉怪 9900000-9900004，39 张打怪图，30 分钟一轮，赏金 200 万 + 2430029。**oid+map 双重校验**（防误判） |
| **虚拟背包** | 卷轴(204xxx)矿石(401/402xxx)自动收纳，入口道具 2430011/2430012（登录补发+创建入包），双击打开。**im 绑定 ItemScriptMethods 继承 NPCConversationManager** |
| **锻造/装备** | 虚拟卷轴矿石背包 + Maker 配方 + Boss 锻造代币（4001083）+ 新装备 1003113 强化混沌扎昆头盔 |

## 3. 自定义 NPC（自由市场 910000000）

| NPC | id | 位置 | 外观 | 说明 |
|---|---|---|---|---|
| 词条工匠 | 9977777 | x=500, y=-266, **fh=53** | 9200000(Cody) | 词条服务 |
| 美容师 | 9977778 | x=800, y=-266, **fh=44** | 9010001(Tia) | 美容+存档 |
| 收藏家 | 9977779 | x=1100, y=-266, **fh=45** | 9010000(Admin) | 收藏图鉴 |

**⚠️ fh 是 foothold 全局段编号**（非 layer/line），指向错误会渲染重叠（小地图分散但画面挤一起）。玩家从低层跳/梯子到中层平台 y=-266。

## 4. 技能平衡改动（近几轮）

**武器倍率**（WeaponType.java，已提交）：全员上涨，斧/钝器+单手额外加强。

**精准/精通技能**（mastery 满级 70，speed/pad/eva 附加）：
- 剑/枪/拳 +speed(20)，矛 +pad(20)，弓弩/短刀 +eva(40)
- 1100001 精准斧 pad 补齐（客户端原本缺）

**法师系 2/3 转主攻**（本次最新）：
| 技能 | mad | 目标 | 范围 | 延迟 |
|---|---|---|---|---|
| 圣箭术 | 60×3段(共180) | 3 | — | 700 |
| 火焰箭 | 180 | 单体 | — | 1000 |
| 冰冻术 | 170 | 单体 | — | 280 |
| 末日烈焰 | 190 | 6 | 加大 | 900 |
| 火毒合击 | 300 | 单体 | — | 900 |
| 冰咆哮 | 170 | 6 | 大幅加大 | 800 |
| 落雷枪 | 210 | 3 | — | 900 |
| 冰雷合击 | 300 | 单体 | — | 900 |
| 圣光 | 180 | 6 | 加大 | 800 |

**技能一览文档**：`docs/技能一览.md` + `.html`（含延迟列），脚本 `.tools/scripts/export_skills.js`。

## 5. 已知问题 / 待办

- [ ] **美容师存档槽位为账号级**（用户确认 OK，暂不改）
- [ ] 虚拟背包**入口道具图标**（用户已自行用 HaRepacker 处理）
- [ ] 4 转技能查看过（未调整，用户可能后续要平衡）
- [ ] 钓鱼增强（自定义鱼获池等）——用户提过兴趣，未做
- [ ] PQ 人数放宽（minPlayers→2）——提过，未做
- [ ] 结婚系统验证（2 人玩，未确认可用性）

## 6. 关键坑（快速避雷）

1. **xml-img-patcher 打客户端**：`export` 必须 `--context=2`（否则 hunk 从文件头开始 → 重复根节点损坏 img）
2. **单行 XML**（部分装备）：文本 diff 打不了，用 sync 或手工 MODIFY diff
3. **canvas 子节点 delay**：文本 diff 需完整 imgdir 上下文（`skill/xxx/effect/N/delay`），配 `--full-xml`
4. **NPC 渲染**：位置看服务端 spawn 封包；fh 必须对（全局段编号）
5. **伤害由客户端算**：改数值必须同步客户端 Skill.wz
6. **脚本每次点击重载**：改 .js 无需重启服务端；改 Java 必须停服→mvn package→重启
7. **推送需代理**：`git config --global http.proxy http://127.0.0.1:6382`
8. **gms-ui 的 yarn 改动**是环境噪音，不提交
9. **gms-ui 账号美容存档**：beauty_slots 表 account_id 级

## 7. 最近提交（未推送的）

```
169cfa8ba 修复美容师选发型/脸型无反应：补 beautyShowPage/beautyCurrentList
5eb24d3a4 修复虚拟背包道具脚本：im 绑定 ItemScriptMethods 继承 NPCConversationManager
7ed65766a 法师技能延迟调整
b0a763358 法师系技能强化
c4825d695 技能一览增加延迟列
8a14d6289 圣箭术强化
c9905b5a9 新增 beidou-devops skill
fea65998b 虚拟背包入口道具自动发放 + 美容师菜单修复
db04192fb 自由市场NPC fh 修复
...（更早的已推送）
```

## 8. 待确认事项（等用户）

- 圣箭术/法师系改动是否进游戏验证 OK
- 美容师分页修复后是否正常
- 是否 push 最近提交
