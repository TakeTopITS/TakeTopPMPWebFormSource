---
name: text-to-sql-report
description: 将自然语言查询转换为 SQL 语句，执行查询并生成报表
---

# Text-to-SQL 报表生成器

## 功能
将用户的自然语言查询（如"现在有多少项目"）转换为 SQL 语句，执行查询并生成格式化报表。

## 数据库信息

### 连接配置
- **数据库**: PostgreSQL 16
- **数据库名**: `taketopdecmpendb`
- **主机**: `127.0.0.1:5432`
- **用户**: `postgres`
- **密码**: `zxckkllzly`
- **连接字符串**: `Server=127.0.0.1;Port=5432;User Id=postgres;Password=zxckkllzly;Database=taketopdecmpendb;`

### 核心表结构

#### 用户与组织
| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `T_ProjectMember` | 用户表 | `UserCode`(PK), `UserName`, `Password`, `Gender`, `Duty`, `JobTitle`, `MobilePhone`, `EMail`, `DepartCode`, `Status`, `UserType` |
| `T_Department` | 部门表 | `DepartCode`(PK), `DepartName`, `ParentCode`, `Authority`, `WorkAddress` |

#### 项目管理
| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `T_Project` | 项目表 | `ProjectID`(PK), `ProjectCode`, `ProjectName`, `ProjectType`, `PMCode`, `PMName`, `BeginDate`, `EndDate`, `ProjectAmount`, `Budget`, `CurrencyType`, `Status`, `Priority` |
| `T_ProjectPlan` | 项目计划 | 关联项目 |
| `T_ProjectTask` | 项目任务 | 关联项目 |

#### 合同管理
| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `T_Constract` | 合同表 | `ConstractID`(PK), `ConstractCode`, `ConstractName`, `Amount`, `Currency`, `SignDate`, `StartDate`, `EndDate`, `Status`, `PartA`, `PartB` |
| `T_ConstractPayable` | 应付账款 | 关联合同 |
| `T_ConstractReceivables` | 应收账款 | 关联合同 |

#### 物资采购 (WZ 前缀)
| 表名 | 说明 |
|------|------|
| `T_WZPurchase` | 采购单 |
| `T_WZPurchaseDetail` | 采购明细 |
| `T_WZSupplier` | 供应商 |
| `T_WZStock` | 库存 |
| `T_WZStore` | 仓库 |
| `T_WZPay` | 付款 |
| `T_WZObject` | 物资对象 |
| `T_WZRequest` | 请购单 |

#### 工作流
| 表名 | 说明 |
|------|------|
| `T_WorkFlow` | 工作流实例 |
| `T_WorkFlowTemplate` | 工作流模板 |
| `T_WorkFlowStep` | 工作流步骤 |

#### 质量管理 (QM/WPQM 前缀)
| 表名 | 说明 |
|------|------|
| `T_WPQMWeldingRecord` | 焊接记录 |
| `T_QM*` | 质量管理相关表 |

#### 其他模块
| 前缀 | 模块 |
|------|------|
| `BM*` | 招标管理 |
| `GD*` | 管道/工程设计 |
| `HSE*` | 健康安全环境 |
| `RCJ*` | 项目成本/结算 |

### 命名约定
- 表名前缀: `T_`
- 主键: `*ID` (自增) 或 `*Code` (字符串)
- 状态字段: `Status` (常见值: 'YES'/'NO', 'Active'/'Inactive', 'Completed' 等)
- 日期字段: `*Date`, `*Time`, `CreatedAt`, `UpdatedAt`

## 执行流程

### 1. 解析用户意图
识别查询类型：
- **计数查询**: "有多少"、"数量"、"统计"
- **列表查询**: "列出"、"显示"、"查看"
- **汇总查询**: "总计"、"合计"、"平均"
- **条件查询**: "某条件的项目/用户/合同"

### 2. 生成 SQL
根据意图和表结构生成 PostgreSQL 兼容的 SQL：

```sql
-- 示例：现在有多少项目
SELECT COUNT(*) AS TotalProjects, 
       Status,
       COUNT(*) FILTER (WHERE Status = 'Active') AS ActiveProjects
FROM T_Project;

-- 示例：列出所有进行中的项目
SELECT ProjectCode, ProjectName, PMName, BeginDate, EndDate, ProjectAmount
FROM T_Project
WHERE Status = 'Active' OR Status = 'InProgress'
ORDER BY BeginDate DESC;

-- 示例：各部门项目数量统计
SELECT d.DepartName, COUNT(p.ProjectID) AS ProjectCount
FROM T_Department d
LEFT JOIN T_ProjectMember pm ON d.DepartCode = pm.DepartCode
LEFT JOIN T_Project p ON pm.UserCode = p.PMCode
GROUP BY d.DepartName
ORDER BY ProjectCount DESC;
```

### 3. 执行 SQL
使用以下命令执行查询：

```bash
# 方式 1: 使用 psql 命令行
psql -h 127.0.0.1 -p 5432 -U postgres -d taketopdecmpendb -c "YOUR_SQL_HERE"

# 方式 2: 使用 psql 交互模式
PGPASSWORD=zxckkllzly psql -h 127.0.0.1 -p 5432 -U postgres -d taketopdecmpendb
```

### 4. 格式化输出
将查询结果格式化为 Markdown 表格：

```markdown
## 查询结果

| 字段1 | 字段2 | 字段3 |
|-------|-------|-------|
| 值1   | 值2   | 值3   |

**统计**: 共 X 条记录
```

## 常用查询模板

### 项目相关
```sql
-- 项目总数
SELECT COUNT(*) FROM T_Project;

-- 按状态统计项目
SELECT Status, COUNT(*) AS Count FROM T_Project GROUP BY Status;

-- 按类型统计项目
SELECT ProjectType, COUNT(*) AS Count FROM T_Project GROUP BY ProjectType;

-- 项目经理的项目数量
SELECT PMName, COUNT(*) AS ProjectCount FROM T_Project GROUP BY PMName ORDER BY ProjectCount DESC;
```

### 用户相关
```sql
-- 用户总数
SELECT COUNT(*) FROM T_ProjectMember;

-- 按部门统计用户
SELECT DepartCode, COUNT(*) AS Count FROM T_ProjectMember GROUP BY DepartCode;

-- 按用户类型统计
SELECT UserType, COUNT(*) AS Count FROM T_ProjectMember GROUP BY UserType;
```

### 合同相关
```sql
-- 合同总数和总金额
SELECT COUNT(*) AS TotalContracts, SUM(Amount) AS TotalAmount FROM T_Constract;

-- 按状态统计合同
SELECT Status, COUNT(*) AS Count, SUM(Amount) AS TotalAmount FROM T_Constract GROUP BY Status;
```

## 安全注意事项
- 只执行 SELECT 查询，禁止 UPDATE/DELETE/INSERT/DROP
- 避免 SQL 注入，对用户输入进行验证
- 查询超时设置为 30 秒

## 示例对话

**用户**: 现在有多少项目？

**助手**:
```sql
SELECT COUNT(*) AS TotalProjects FROM T_Project;
```
执行结果：
| TotalProjects |
|---------------|
| 156           |

**当前系统共有 156 个项目。**

---

**用户**: 列出所有进行中的项目

**助手**:
```sql
SELECT ProjectCode, ProjectName, PMName, BeginDate, EndDate, Status
FROM T_Project
WHERE Status IN ('Active', 'InProgress')
ORDER BY BeginDate DESC
LIMIT 20;
```
执行结果：
| ProjectCode | ProjectName | PMName | BeginDate | EndDate | Status |
|-------------|-------------|--------|-----------|---------|--------|
| PRJ001 | XXX项目 | 张三 | 2024-01-15 | 2024-12-31 | Active |
| ... | ... | ... | ... | ... | ... |

共返回 20 条记录。
