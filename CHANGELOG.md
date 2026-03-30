# 更新日志

## 2026-03-30

### 修复

- 修复 Cloudflare Workers + D1 部署场景下，注册新账号时偶发出现 `D1_ERROR: UNIQUE constraint failed: user.email` 的问题。
- 修复后台新增用户时，同样可能因 `user` 表与 `account` 表数据不一致而导致创建失败的问题。
- 修复数据库唯一索引异常直接暴露给前端的问题，统一改为业务提示“邮箱已注册”。
- 修复旧版本升级后未执行数据库迁移时，因 `account.sort`、`account.name`、`account.all_receive` 等字段缺失导致登录、注册异常的问题。

### 优化

- 优化注册流程与后台新增用户流程，创建账号前会同时检查 `user` 表和 `account` 表。
- 当检测到 `user` 表已有用户、但 `account` 表缺少对应主账号记录时，系统会自动补齐缺失的主账号数据。
- 新增 D1 数据修复脚本 `mail-worker/sql/repair_orphan_users.sql`，用于修复历史遗留的孤儿用户数据。

### 升级说明

- 部署新版本 Worker 后，请执行一次 `/api/init/{jwt_secret}` 完成 D1 数据库迁移。
- 如果历史数据中存在 `user` 表有记录但 `account` 表缺少对应主账号的情况，可执行 `mail-worker/sql/repair_orphan_users.sql` 进行修复。
