# wz-patch-java（xml-img-patcher）

把服务端 XML 的 git unified diff 应用到客户端 `.img` 文件，**保留所有未触及的 PNG / Sound / Canvas / UOL / Vector 等二进制资源**（直接打开 .img 按 diff 改节点、原样写回，不重建文件）。

来源仓库：<https://github.com/SleepNap/orange-wz-cli>（MIT）
- 本目录下 `xml-img-patcher.exe`：从 Release v2 下载的 GraalVM native 独立 exe（Windows，约 27 MB，**免 JRE**）
- 如需重新构建/换版本：`git clone https://github.com/SleepNap/orange-wz-cli.git`，`mvn -DskipTests package` 出 fat jar（Java 21 + Maven 3.8+）；native exe 需 GraalVM JDK 21 + MSVC（见仓库 `build-native.bat`，注意脚本里硬编码了作者本机路径）

## 子命令

```
xml-img-patcher patch          <input.img> <diff> <output.img> [选项]
xml-img-patcher dump-xml       <input.img> <output.xml>        [选项]
xml-img-patcher batch          <img目录> <diff目录> <输出目录> [选项]
xml-img-patcher batch-dump-xml <img目录> <xml输出目录>         [选项]
xml-img-patcher verify         <patched.img> <diff> [full-xml或目录] [选项]
xml-img-patcher export         --from=<hash或datetime>        [选项]
xml-img-patcher sync           --client=<客户端根> --out=<输出根> [--repo/--server] [选项]
```

| 子命令 | 作用 |
|---|---|
| `patch` | 对一个 .img 应用一个 .diff，输出新 .img |
| `dump-xml` | 把 .img 转成服务端格式的 .xml（默认跳过二进制资源） |
| `batch` | 批量 patch，diff 目录 `a/b/Foo.img.xml.diff` 自动配对 img 目录 `a/b/Foo.img`，递归扫所有 `*.diff` |
| `batch-dump-xml` | 批量 dump-xml |
| `verify` | 校验 patched .img 是否落实 diff 每条变更，miss=0 即通过 |
| `export` | 从 git 仓库导出指定起点之后的 wz xml 与 diff（等价服务端 `ExportPatch.java`） |
| `sync` | 节点级三方对比（服务端 old/new + 客户端 img）直接同步，不走文本 diff |

## 关键选项

| 选项 | 说明 |
|---|---|
| `--full-xml <file>` / `--full-xml-dir <dir>` | 完整服务端 XML（diff `+++` 侧最终文件）。hunk 上下文不带外层 imgdir 时用它反查路径栈。**强烈推荐配** |
| `--iv <GMS\|EMS\|BMS\|CLASSIC>` | WZ 加密 IV，默认 `GMS` |
| `--dry-run` | 不写文件，模拟 |
| `--strict` | 任一条 change 失败立即中止（默认尽力做完） |
| `-v, --verbose` | 实时打印每条 change |
| `--indent <N>` / `--linux` | dump-xml 缩进/换行选项 |

## 退出码

0 全部成功 / 1 部分失败但已写出 / 2 参数或文件错误 / 3 diff 解析失败 / 4 img 解析失败 / 5 img 写入失败

## 典型用法

```bash
# 单文件 patch
xml-img-patcher patch \
  --full-xml=C:/upgrade/wz-zh-CN/Quest.wz/QuestInfo.img.xml \
  C:/client/Data/Quest/QuestInfo.img \
  C:/diff/wz-zh-CN/Quest.wz/QuestInfo.img.xml.diff \
  C:/out/Quest/QuestInfo.img

# 批量 patch
xml-img-patcher batch \
  --full-xml-dir=C:/upgrade/wz-zh-CN \
  C:/client/Data \
  C:/diff/wz-zh-CN \
  C:/out/Data

# 校验
xml-img-patcher verify \
  C:/out/Quest/QuestInfo.img \
  C:/diff/wz-zh-CN/Quest.wz/QuestInfo.img.xml.diff \
  C:/upgrade/wz-zh-CN

# sync：从服务端仓库直接同步到客户端（推荐，无文本 diff 中间环节）
# A. git 增量
xml-img-patcher sync --repo=<git根> --from=<hash或datetime> \
  --client=<客户端根> --out=<输出根> [--prefix] [--iv] [--strict] [--mode=review|trust] [--dry-run]
# B. 服务端 XML 目录全量（不需要 git）
xml-img-patcher sync --server=<xml目录> --client=<客户端根> --out=<输出根> [--iv] [--strict] [--dry-run]
```

## 映射与坑（patch 语义）

- 服务端 `wz/`（英文基础）↔ 客户端 `EN/`；`wz-zh-CN/`（中文覆盖）↔ 客户端 `Data/`（EN 不存在时 fallback `Data/`）。
- **`patch` 的 ADD 是合并/追加到目标 .img，不是覆盖**。若客户端 .img 已存在同名子树（典型：服务端新增的中文文件对应客户端已有的 mob img），ADD 会产生重复节点（脏数据）。只有 MODIFY 语义的 diff 能安全打到已存在 .img。打补丁前先用 `--dry-run` 看变更类型，ADD 整个子树的要确认客户端确实缺该子树。
- 已知限制：hunk 上下文极短且叶子名不唯一（如 `String.wz/Skill.img` 里 `desc` 600+ 次）时失败，**配 `--full-xml`/`--full-xml-dir` 解决**；不支持 Canvas/Sound/Convex 富媒体节点的 diff 修改。

## 参考

- 完整 README/设计文档/测试套件见仓库：<https://github.com/SleepNap/orange-wz-cli>
- 姊妹仓库（C#/MapleLib 实现，命令一致）：<https://github.com/SleepNap/MapleLib-cli>
