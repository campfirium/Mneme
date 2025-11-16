# Anki Storage 调试记录

## 当前需求总结

- **SessionStorage 为主**：所有平台都必须依赖 `window.sessionStorage` 管理 OneMoreTurn 计数、4:00 重置、去重逻辑与激励触发。
- **AnkiStorage 仅作校准**：在 Android/AnkiDroid 上连得上 anki-storage 时，读取远端计数作为基线，并在本地增加后再回写，以跨重启保留进度；连不上时主流程不能受影响。
- **前端面板可视化**：在卡片正面展示 Session 与 Anki 两套计数、连接状态与最近日志，让桌面/移动两端都能直接看到同步链路。
- **无调试开关依赖**：即使 `mneme_hit_motivation` 或 `mneme_debug_mode` 关闭，也要继续维护计数与日志，避免逻辑被提前 `return`。

## 尝试与结果

| 尝试 | 目标 | 实际结果 / 问题 |
|------|------|-----------------|
| `0807d9a feat: use session storage for front template` | 移除 anki-storage，所有平台统一使用 sessionStorage，验证纯本地方案 | 逻辑简化但 Android 无法跨重启；也缺少可视化面板，后续无法观察远端状态 |
| `2b69256 feat: embed storage diagnostics on card face` | 把调试面板移入卡面并记录日志，同时保留 session+anki 协同策略 | 面板可用，但后续修改中多次破坏了“session 主、anki 校准”的约定 |
| `fdd87f7 fix: init anki storage regardless of motivation toggle` | 防止 `hitMotivation` 关闭时提前 `return`，保障 Android 依旧初始化 anki-storage | 逻辑正确，但未解决 Android 上“日志只到初始化”的现象 |
| `0c0c317 fix: keep counter active and surface anki storage state` | 清理调试依赖、强制计数持续运行，并让面板显示连接状态 | 桌面端正常，Android 仍只显示“已连接”而没有“Session 计数更新”，因为后续 commit 覆盖了 sessionStorage 行为 |
| `e218075 fix: persist counter state across cards` | 尝试用 `localStorage` 解决“翻卡后计数归零”问题 | 结果破坏了 session-only 约定；不同平台行为分裂，Android 端面板/计数仍失效 |
| `56b8360 refactor: restore anki-storage backed counter` | 为了保留远端持久化，直接把 Android 切成 anki-storage 主存 | 完全违背“session 为主”的需求，导致 PC/Android 逻辑再次分叉 |
| `fc56f29 fix: simplify session-led counter and remote sync`（已丢弃） | 引入 pending 队列、试图重写同步链路 | 代码复杂但仍未修好“Android 日志缺失”问题，最终被放弃 |
| `13c9b29 fix: restore session-led counter with anki calibration` | 在多次回滚后恢复到 session 主导 + 远端校准的思路 | 行为接近目标，但 Android 端仍因为脚本异常没有触发计数，面板只看到“初始化/已连接” |

## 未解决的核心症状

- **Android 日志只剩两条**：`初始化完成` 与 `anki-storage 已连接`，但没有 `Session 计数更新` 或 `重复单词`，说明脚本在进入计数逻辑前就退出。桌面端没有此问题。
- **远端标记始终“未连接”或“同步中”**：即便 anki-storage 已加载，因计数未推进，面板无法显示实时数值。

## 后续建议

1. **定向插桩**：在 Android 上加入 try/catch，把 `isRecentWord`、`getCount`、`addRecentWord` 等关键调用的异常写入日志，确认脚本究竟在哪一步退出。
2. **最小化差异**：从 `0807d9a` 的纯 session 版本出发，只加入“远端读取/写入”两个函数，避免再次引入 pending 队列等复杂结构。
3. **真实设备验证**：由于 AnkiDroid 无浏览器控制台，需要用 `appendLog` 或在字段上直接渲染调试文本来观察脚本执行路径。
