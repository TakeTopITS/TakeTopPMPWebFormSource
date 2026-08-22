# 数据库表结构文档

> AI Agent 数据字典 — 用于智能助手理解数据库结构，支持自然语言操作
>
> 生成时间：2026-06-21 21:57:42
> 更新时间：2026-06-22
> 总表数：740

---

## 目录

1. [用户与组织架构](#一用户与组织架构)
2. [项目管理](#二项目管理)
3. [任务管理](#三任务管理)
4. [合同管理](#四合同管理)
5. [资产管理](#五资产管理)
6. [需求管理](#六需求管理)
7. [缺陷管理](#七缺陷管理)
8. [会议管理](#八会议管理)
9. [客户管理](#九客户管理)
10. [供应商管理](#十供应商管理)
11. [物品/供应链管理](#十一物品供应链管理)
12. [个人计划管理](#十二个人计划管理)
13. [项目计划管理](#十三项目计划管理)
14. [工作流审批](#十四工作流审批)
15. [模块权限](#十五模块权限)
16. [KPI绩效管理](#十六kpi绩效管理)
17. [财务会计](#十七财务会计)
18. [报表与统计](#十八报表与统计)
19. [系统配置](#十九系统配置)

---

## 一、用户与组织架构

### T_ProjectMember（用户主表 / 项目成员表）

> 系统核心用户信息表，所有模块的用户数据源

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| UserCode | varchar | 用户编号 | 唯一标识，主键，如 U001 |
| UserName | varchar | 用户姓名 | 显示名称 |
| Gender | varchar | 性别 | Male/Female |
| Password | varchar | 密码(MD5) | MD5加密存储 |
| Age | integer | 年龄 | 年龄字段 |
| Duty | varchar | 职务 | 关联T_UserDuty表 |
| JobTitle | varchar | 职称/岗位 | 职位名称 |
| DepartCode | varchar | 部门编号 | 关联T_Department表 |
| DepartName | varchar | 部门名称 | 冗余存储 |
| MobilePhone | varchar | 手机号码 | 手机号码字段 |
| OfficePhone | varchar | 办公电话 | 办公电话字段 |
| EMail | varchar | 电子邮箱 | 电子邮箱 |
| WorkScope | text | 工作范围 | 岗位职责描述 |
| JoinDate | date | 入职日期 | 入职日期 |
| Status | varchar | 状态 | Employed/Resigned/Stop |
| EnglishName | varchar | 英文名 | 英文名称 |
| Nationality | varchar | 国籍 | 国籍 |
| NativePlace | varchar | 籍贯 | 籍贯 |
| Address | text | 详细地址 | 联系地址 |
| BirthDay | date | 出生日期 | 出生日期字段 |
| MaritalStatus | varchar | 婚姻状况 | 婚姻状况字段 |
| Degree | varchar | 学历 | 学历 |
| Major | varchar | 专业 | 专业 |
| GraduateSchool | varchar | 毕业院校 | 毕业院校 |
| IDCard | varchar | 身份证号 | 身份证号码 |
| LangCode | varchar | 语言代码 | zh-CN/en-US |
| UserType | varchar | 用户类型 | INNER/OUTER |
| CssDirectory | varchar | CSS样式目录 | 个性化界面 |
| HourlySalary | numeric | 时薪 | 计费相关 |
| MonthlySalary | numeric | 月薪 | 计费相关 |
| RefUserCode | varchar | 推荐人编号 | 推荐人编号字段 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |
| PhotoURL | varchar | 照片URL | 员工照片路径 |
| WeChatOpenID | varchar | 微信OpenID | 微信登录 |
| CreatorCode | varchar | 创建者编号 | 创建者编号字段 |
| PMCode | varchar | 项目经理编码 | 项目中担任经理角色 |
| PMName | varchar | 项目经理姓名 | 项目经理姓名 |
| ProjectID | integer | 项目ID | 所属项目 |
| AllowDevice | varchar | 允许登录设备 | ALL/PC/MOBILE |
| ContractEndTime | date | 合同到期时间 | 合同到期日期 |
| UrgencyPerson | varchar | 紧急联系人 | 紧急联系人姓名 |
| UrgencyCall | varchar | 紧急联系电话 | 紧急联系电话 |

---

> **注意**：T_UserInformation 表在数据库中不存在，员工信息请使用 T_ProjectMember 表（本文件第一张表）。

---

### T_Department（部门表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| DepartCode | varchar | 部门编码 | 唯一标识 |
| DepartName | varchar | 部门名称 | 显示名称 |
| ParentCode | varchar | 上级部门编码 | 构建部门树结构 |
| Authority | varchar | 权限类型 | All=全部可见，Part=部分可见 |
| ContactPerson | varchar | 联系人 | 联系人字段 |
| OfficeAddress | varchar | 办公地址 | 办公地址字段 |
| Longitude | numeric | 经度 | GPS定位 |
| Latitude | numeric | 纬度 | GPS定位 |

---

### T_DepartmentUser（部门用户表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| UserCode | varchar | 用户编码 | 用户编码，登录账号 |
| DepartCode | varchar | 部门编码 | 该用户被授权查看的部门 |

---

### T_MemberLevel（成员层级表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| UserCode | varchar | 上级用户编码 | 管理者 |
| UnderCode | varchar | 下属编码 | 被管理者 |
| AgencyStatus | integer | 代理状态 | 1=Acting |
| KPIVisible | varchar | KPI可见性 | YES=可查看下属KPI |
| ProjectVisible | varchar | 项目可见性 | YES=可查看下属项目 |

---

## 二、项目管理

### T_Project（项目主表）

> 系统核心表，存储项目基本信息

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ProjectID | integer | 项目ID | 自增主键 |
| ProjectCode | varchar | 项目编号 | 自动生成，如 PJ202606210001 |
| ProjectName | varchar | 项目名称 | 项目名称 |
| ProjectClass | varchar | 项目分类 | NormalProject/TemplateProject |
| ProjectType | varchar | 项目类型 | 关联T_ProjectType |
| PMCode | varchar | 项目经理编码 | 关联T_ProjectMember.UserCode |
| PMName | varchar | 项目经理姓名 | 项目经理姓名 |
| BeginDate | date | 开始日期 | 计划开始日期 |
| EndDate | date | 结束日期 | 计划结束日期 |
| ProjectAmount | numeric | 项目金额 | 合同金额 |
| Budget | numeric | 预算 | 预算金额 |
| CustomerPMName | varchar | 客户经理 | 客户方项目经理 |
| BelongDepartCode | varchar | 所属部门编码 | 所属部门编码字段 |
| BelongDepartName | varchar | 所属部门名称 | 所属部门名称字段 |
| ProjectDetail | text | 项目详情 | 富文本 |
| AcceptStandard | text | 验收标准 | 验收标准字段 |
| ManHour | numeric | 工时(天) | 预估总工时 |
| ManNumber | integer | 人力(人) | 需要投入人数 |
| CurrencyType | varchar | 结算币别 | 关联T_CurrencyType |
| ImportanceLevel | varchar | 重要程度 | 高/中/低 |
| UrgencyLevel | varchar | 紧急程度 | 高/中/低 |
| Priority | varchar | 优先级 | COMMON/Normal |
| FinishPercent | numeric | 完成百分比 | 0-100 |
| Status | varchar | 状态 | New/InProgress/Accepted/Rejected/Deleted/Archived/Pause/Stop |
| CreaterCode | varchar | 创建人编码 | 创建人编码字段 |
| CreateDate | timestamp | 创建日期 | 记录创建时间 |
| InUse | varchar | 是否在用 | YES/NO |
| ParentID | integer | 父项目ID | 项目层级树结构 |
| UserCode | varchar | 创建人编码 | 用户编码，登录账号 |
| UserName | varchar | 创建人姓名 | 用户姓名 |

---

---

### T_ProjectBudget（项目预算表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 预算记录ID | 自增主键 |
| ProjectID | integer | 项目ID | 关联T_Project |
| AccountCode | varchar | 科目编码 | 关联T_Account |
| Account | varchar | 科目名称 | 如"人力成本"、"差旅费" |
| Amount | numeric | 预算金额 | 金额 |
| CurrencyType | varchar | 币种类型 | 币种类型，如人民币/美元 |
| Description | text | 描述/备注 | 详细描述信息 |
| CreatorCode | varchar | 创建人编码 | 创建人编码字段 |
| CreateTime | timestamp | 创建时间 | 创建时间 |

---

### T_ProjectBudgetChangeLog（预算变更日志表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| BudgetID | integer | 预算ID | 关联T_ProjectBudget |
| ProjectID | integer | 项目ID | 关联T_Project表，标识所属项目 |
| Amount | numeric | 变更前金额 | 金额 |
| UpdateTime | timestamp | 更新时间 | 变更操作时间 |
| UpdaterCode | varchar | 更新人编码 | 更新人编码字段 |

---

### T_ProExpense（项目费用表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| Account | varchar | 科目名称 | 会计科目 |
| Description | varchar | 描述 | 详细描述信息 |
| Amount | numeric | 费用金额 | 金额 |
| ConfirmAmount | numeric | 确认金额 | 审批确认后金额 |
| EffectDate | date | 生效日期 | 生效日期 |
| ProjectID | integer | 项目ID | 关联T_Project表，标识所属项目 |
| TaskID | integer | 任务ID | 关联T_ProjectTask表，标识所属任务 |
| RecordID | integer | 记录ID | 关联记录ID |
| UserCode | varchar | 用户编码 | 费用申请人 |
| UserName | varchar | 用户姓名 | 用户姓名 |
| RegisterDate | timestamp | 登记日期 | 登记日期字段 |
| ConstractPayID | integer | 合同支付ID | 合同支付ID字段 |
| AccountCode | varchar | 科目编码 | 会计科目编码 |
| CurrencyType | varchar | 币种类型 | 币种类型，如人民币/美元 |

---

### T_ProjectType（项目类型配置表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| type | varchar | 类型名称 | 项目类型取值 |

---

### T_CurrencyType（币种类型配置表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| type | varchar | 币种名称 | 如人民币、美元 |

---

## 三、任务管理

> **注意**：T_Task 表在数据库中不存在，AI Agent任务功能已改用 T_ProjectTask 表。

### T_ProjectTask（项目任务表）- 主要任务表

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| TaskID | integer | 任务ID | 自增主键 |
| ProjectID | integer | 项目ID | 关联T_Project |
| PlanID | integer | 计划ID | 关联T_ImplePlan |
| Type | varchar | 任务类型 | Plan/Task |
| Task | varchar | 任务名称 | 任务名称字段 |
| Priority | varchar | 优先级 | Normal/High |
| Status | varchar | 状态 | ToHandle/InProgress/Completed/Closed |
| BeginDate | date | 开始日期 | 计划开始日期 |
| EndDate | date | 结束日期 | 计划结束日期 |
| Budget | numeric | 任务预算 | 预算金额 |
| Expense | numeric | 任务费用 | 实际花费 |
| ManHour | numeric | 计划工时 | 计划工时（小时） |
| RealManHour | numeric | 实际工时 | 实际工时（小时） |
| FinishPercent | numeric | 完成百分比 | 0-100 |
| MakeManCode | varchar | 创建人编码 | 创建人编码字段 |
| MakeManName | varchar | 创建人姓名 | 创建人姓名字段 |
| MakeDate | timestamp | 创建日期 | 记录创建时间 |
| MeetingID | integer | 会议ID | 关联会议 |
| CollaborationID | integer | 协作ID | 关联协作 |
| GoodsSN | varchar | 物料序列号 | 关联物料 |
| DefectID | integer | 缺陷ID | 关联缺陷 |
| IsPlanMainTask | varchar | 是否计划主任务 | YES/NO |

---

### T_TaskAssignRecord（任务分配记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| TaskID | integer | 任务ID | 关联T_ProjectTask |
| OperatorCode | varchar | 操作人编码 | 接收任务的用户 |
| OperatorName | varchar | 操作人姓名 | 操作人姓名 |
| Status | varchar | 状态 | Plan/Accepted/InProgress/ToHandle |
| PriorID | integer | 前置记录ID | 前一个流转步骤 |
| BeginDate | date | 开始日期 | 计划开始日期 |
| EndDate | date | 结束日期 | 计划结束日期 |
| AssignManCode | varchar | 分派人编码 | 任务分配人编码 |
| AssignManName | varchar | 分派人姓名 | 任务分配人姓名 |
| Operation | text | 操作内容 | 富文本 |
| RouteNumber | integer | 路由编号 | 操作顺序 |
| ManHour | numeric | 工时 | 投入工时 |
| FinishPercent | numeric | 完成百分比 | 完成百分比，0-100 |

---

## 四、合同管理

### T_Constract（合同表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ConstractID | bigint | 记录ID | 自增主键 |
| ConstractCode | varchar | 合同编号 | 如 HT202606210001 |
| ConstractName | varchar | 合同名称 | 合同名称 |
| Type | varchar | 合同类型 | 购销合同/加工承揽等 |
| Amount | numeric | 合同金额 | 合同金额 |
| CustomerName | varchar | 客户名称 | 客户名称 |
| SignDate | timestamp | 签订日期 | 签订日期 |
| StartDate | timestamp | 开始日期 | 合同开始日期 |
| EndDate | timestamp | 结束日期 | 合同结束日期 |
| Status | varchar | 状态 | InProgress/Completed/Archived/Cancel/Deleted |
| DepartCode | varchar | 部门编码 | 部门编码 |
| PartA | varchar | 甲方 | 甲方 |
| PartB | varchar | 乙方 | 乙方 |

---

### T_ConstractReceivables（合同应收账款表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ConstractCode | varchar | 合同编号 | 关联合同 |
| ReceivablesTime | date | 应收账款日期 | 预计收款日期 |
| ReceiverAccount | numeric | 应收金额 | 应收金额字段 |
| UNReceiveAmount | numeric | 未收金额 | 未收金额字段 |
| Payer | varchar | 付款方 | 付款方字段 |
| PreDays | integer | 提前天数 | 提前几天提醒 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |
| IsSecrecy | varchar | 是否保密 | YES/NO |

---

### T_ConstractPayable（合同应付账款表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ConstractCode | varchar | 合同编号 | 关联合同 |
| PayableTime | date | 应付日期 | 预计付款日期 |
| PayableAccount | numeric | 应付金额 | 应付金额字段 |
| OutOfPocketAccount | numeric | 实付金额 | 实付金额字段 |
| UNPayAmount | numeric | 未付金额 | 未付金额字段 |
| Receiver | varchar | 收款方 | 收款方字段 |
| PreDays | integer | 提前天数 | 提前天数字段 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |

---

### T_ConstractRelatedGoods（合同关联商品表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ConstractCode | varchar | 合同编码 | 合同编号 |
| GoodsCode | varchar | 商品编码 | 物品编码 |
| GoodsName | varchar | 商品名称 | 物品名称 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Brand | varchar | 品牌 | 品牌字段 |
| Number | numeric | 数量 | 数量字段 |
| Unit | varchar | 单位 | 计量单位 |
| Price | numeric | 单价 | 单价 |
| Amount | numeric | 金额 | 金额 |
| SaleOrderNumber | numeric | 销售订单数量 | 销售订单数量字段 |
| PurchaseOrderNumber | numeric | 采购订单数量 | 采购订单数量字段 |

---

### T_ConstractRelatedUser（合同关联用户表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ConstractCode | varchar | 合同编码 | 合同编号 |
| UserCode | varchar | 用户编码 | 用户编码，登录账号 |
| UserName | varchar | 用户名称 | 用户姓名 |
| Authority | varchar | 权限 | 权限字段 |

---

## 五、资产管理

### T_Asset（资产表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| AssetCode | varchar | 资产编号 | 如 ZC202606210001 |
| AssetName | varchar | 资产名称 | 资产名称 |
| AssetType | varchar | 资产类型 | 硬件/软件/设备 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Status | varchar | 状态 | InUse/Idle/Scrapped |
| CurrentPrice | numeric | 当前价值 | 当前价值字段 |
| UnitName | varchar | 单位名称 | 单位名称 |
| Number | numeric | 数量 | 数量字段 |
| Price | numeric | 单价 | 单价 |
| Amount | numeric | 金额 | 金额 |
| Manufacturer | varchar | 生产厂家 | 生产厂家字段 |
| OwnerCode | varchar | 使用人编码 | 使用人编码字段 |
| OwnerName | varchar | 使用人名称 | 使用人名称字段 |
| Position | varchar | 存放位置 | 存放位置字段 |
| BuyTime | date | 购买时间 | 购买时间字段 |
| AssetDescription | text | 资产描述 | 资产描述字段 |
| CreaterCode | varchar | 创建人编码 | 创建人编码字段 |
| CreateDate | timestamp | 创建日期 | 记录创建时间 |
| InUse | varchar | 是否在用 | YES |
| CurrencyType | varchar | 币种类型 | 币种类型，如人民币/美元 |
| FinancialCode | varchar | 财务编码 | 财务编码字段 |

---

### T_AssetPurchaseOrder（资产采购订单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| POID | integer | 采购订单ID | 主键 |
| POName | varchar | 采购订单名称 | 采购订单名称字段 |
| Amount | numeric | 金额 | 金额 |
| PurTime | date | 采购时间 | 采购时间字段 |
| PurManCode | varchar | 采购人编码 | 采购人编码字段 |
| PurManName | varchar | 采购人名称 | 采购人名称字段 |
| ArrivalTime | date | 到达时间 | 到达时间字段 |
| CurrencyType | varchar | 币种类型 | 币种类型，如人民币/美元 |
| Comment | text | 备注 | 备注说明 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |
| RelatedType | varchar | 关联类型 | 关联业务类型 |
| RelatedID | integer | 关联ID | 关联业务ID |

---

### T_AssetPurRecord（资产采购记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| POID | integer | 采购订单ID | 关联T_AssetPurchaseOrder |
| AssetCode | varchar | 资产编码 | 资产编号 |
| AssetName | varchar | 资产名称 | 资产名称 |
| Type | varchar | 资产类型 | 类型分类 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Number | numeric | 数量 | 数量字段 |
| Unit | varchar | 单位 | 计量单位 |
| Price | numeric | 单价 | 单价 |
| Supplier | varchar | 供应商 | 供应商字段 |
| SupplierPhone | varchar | 供应商电话 | 供应商电话字段 |
| PurReason | varchar | 采购原因 | 采购原因字段 |

---

### T_AssetScrape（资产报废表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| AssetCode | varchar | 资产编码 | 资产编号 |
| AssetName | varchar | 资产名称 | 资产名称 |
| Type | varchar | 资产类型 | 类型分类 |
| OldUserCode | varchar | 原使用人编码 | 原使用人编码字段 |
| OldUserName | varchar | 原使用人名称 | 原使用人名称字段 |
| OperatorCode | varchar | 操作人编码 | 操作人编码 |
| OperatorName | varchar | 操作人名称 | 操作人姓名 |
| ScrapeNumber | numeric | 报废数量 | 报废数量字段 |
| GetAmount | numeric | 回收金额 | 回收金额字段 |
| ScrapeReason | text | 报废原因 | 报废原因字段 |
| AfterScrapeUse | text | 报废后用途 | 报废后用途字段 |
| ScrapeTime | timestamp | 报废时间 | 报废时间字段 |

---

## 六、需求管理

### T_Requirement（需求表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ReqCode | varchar | 需求编号 | 如 XQ202606210001 |
| ReqName | varchar | 需求名称 | 需求名称 |
| ReqType | varchar | 需求类型 | 功能需求/性能需求 |
| ProjectCode | varchar | 所属项目编号 | 项目编号，如PJ202606210001 |
| ReqDetail | text | 需求详情 | 富文本 |
| AcceptStandard | text | 验收标准 | 验收标准字段 |
| ReqFinishedDate | date | 要求完成时间 | 要求完成时间字段 |
| ApplicantCode | varchar | 申请人编码 | 申请人编码 |
| ApplicantName | varchar | 申请人姓名 | 申请人姓名 |
| MakeDate | timestamp | 创建日期 | 记录创建时间 |
| InUse | varchar | 是否在用 | YES |
| Status | varchar | 状态 | Plan/InProgress/Closed/Rejected/Suspended/Cancel/Hided/Deleted/Archived |
| RouteNumber | integer | 路由编号 | 跟踪分派轮次 |
| Priority | varchar | 优先级 | Normal/High/Low/Urgent |

---

### T_ReqAssignRecord（需求分配记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ReqID | integer | 需求ID | 关联T_Requirement |
| OperatorCode | varchar | 操作人编码 | 操作人编码 |
| OperatorName | varchar | 操作人名称 | 操作人姓名 |
| Status | varchar | 状态 | ToHandle/InProgress/Completed/Assigned/Rejected/Suspended/Cancel |
| PriorID | integer | 前置记录ID | 前一记录ID，用于链表结构 |
| BeginDate | date | 开始日期 | 计划开始日期 |
| EndDate | date | 结束日期 | 计划结束日期 |
| AssignManCode | varchar | 分派人编码 | 任务分配人编码 |
| AssignManName | varchar | 分派人名称 | 任务分配人姓名 |
| Operation | text | 工作要求 | 富文本 |
| RouteNumber | integer | 路由编号 | 路由序号，用于工作流步骤排序 |
| MakeDate | timestamp | 创建日期 | 记录创建时间 |
| MoveTime | timestamp | 移动时间 | Status change time |

---

## 七、缺陷管理

### T_Defectment（缺陷表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| DefectCode | varchar | 缺陷编号 | 如 QX202606210001 |
| DefectName | varchar | 缺陷名称 | 缺陷名称 |
| DefectType | varchar | 缺陷类型 | 功能缺陷/界面缺陷 |
| ProjectCode | varchar | 所属项目编号 | 项目编号，如PJ202606210001 |
| DefectDetail | text | 缺陷详情 | 含复现步骤 |
| AcceptStandard | text | 验收标准 | 验收标准字段 |
| DefectFinishedDate | date | 要求完成时间 | 要求完成时间字段 |
| ApplicantCode | varchar | 申请人编码 | 申请人编码 |
| ApplicantName | varchar | 申请人姓名 | 申请人姓名 |
| MakeDate | timestamp | 创建日期 | 记录创建时间 |
| InUse | varchar | 是否在用 | YES |
| Status | varchar | 状态 | Plan/InProgress/Closed/Hided/Deleted/Archived |
| RouteNumber | integer | 路由编号 | 路由序号，用于工作流步骤排序 |
| Priority | varchar | 优先级 | 优先级，如Normal/High/Low |

---

### T_DefectAssignRecord（缺陷分配记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| DefectID | integer | 缺陷ID | 关联T_Defectment |
| OperatorCode | varchar | 操作人编码 | 操作人编码 |
| OperatorName | varchar | 操作人名称 | 操作人姓名 |
| Status | varchar | 状态 | ToHandle/InProgress/Completed/Assigned/Rejected/Suspended/Cancel |
| PriorID | integer | 前置记录ID | 前一记录ID，用于链表结构 |
| BeginDate | date | 开始日期 | 计划开始日期 |
| EndDate | date | 结束日期 | 计划结束日期 |
| AssignManCode | varchar | 分派人编码 | 任务分配人编码 |
| AssignManName | varchar | 分派人名称 | 任务分配人姓名 |
| Operation | text | 工作要求 | 富文本 |
| RouteNumber | integer | 路由编号 | 路由序号，用于工作流步骤排序 |
| MakeDate | timestamp | 创建日期 | 记录创建时间 |
| MoveTime | timestamp | 移动时间 | Status change time |

---

## 八、会议管理

### T_Meeting（会议表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 会议ID | 自增主键 |
| MeetingCode | varchar | 会议编号 | 会议编号字段 |
| MeetingName | varchar | 会议名称 | 会议名称 |
| MeetingType | varchar | 会议类型 | 周会/评审会/启动会 |
| BeginDate | date | 开始时间 | 计划开始日期 |
| EndDate | date | 结束时间 | 计划结束日期 |
| MeetingRoom | varchar | 会议室 | 会议室字段 |
| MeetingDetail | text | 会议详情 | 议程内容 |
| Host | varchar | 主持人 | 主持人字段 |
| Organizer | varchar | 召集人 | 召集人字段 |
| Recorder | varchar | 记录人 | 记录人字段 |
| CreaterCode | varchar | 创建人编码 | 创建人编码字段 |
| CreateDate | timestamp | 创建日期 | 记录创建时间 |
| InUse | varchar | 是否在用 | YES |
| Status | varchar | 状态 | Normal/Cancel |
| RelatedType | varchar | 关联类型 | 关联业务类型 |
| RelatedID | integer | 关联ID | 关联业务ID |

---

### T_MeetingAttendant（会议出席人员表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| MeetingID | integer | 会议ID | 关联T_Meeting |
| UserCode | varchar | 用户编码 | 参会人员 |
| UserName | varchar | 用户名称 | 用户姓名 |

---

### T_MeetingRoom（会议室表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 编号 | 主键 |
| RoomName | varchar | 会议室名称 | 会议室名称字段 |
| BelongDepartCode | varchar | 所属部门代码 | 所属部门代码字段 |

---

## 九、客户管理

### T_Customer（客户表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| CustomerCode | varchar | 客户编号 | 客户编号 |
| CustomerName | varchar | 客户名称 | 客户名称 |
| SimpleName | varchar | 简称 | 简称字段 |
| CustomerEnglishName | varchar | 客户英文名 | 客户英文名字段 |
| Type | varchar | 客户类型 | 企业/政府/个人 |
| ContactName | varchar | 联系人 | 联系人字段 |
| SalesPerson | varchar | 业务员 | 业务员字段 |
| Tel1 | varchar | 电话1 | 电话1字段 |
| Tel2 | varchar | 电话2 | 电话2字段 |
| Fax | varchar | 传真 | 传真号码 |
| Website | varchar | 网址 | 网址字段 |
| InvoiceAddress | varchar | 发票地址 | 发票地址字段 |
| Bank | varchar | 开户银行 | 开户银行字段 |
| BankAccount | varchar | 银行账号 | 银行账号 |
| Currency | varchar | 币种 | 币种 |
| Country | varchar | 国家 | 国家字段 |
| State | varchar | 省份 | 省份字段 |
| City | varchar | 城市 | 城市字段 |
| AreaAddress | varchar | 详细地址 | 详细地址字段 |
| PostalCode | varchar | 邮政编码 | 邮政编码字段 |
| BelongDepartCode | varchar | 归属部门编码 | 归属部门编码字段 |
| BelongDepartName | varchar | 归属部门名称 | 归属部门名称字段 |
| BelongAgencyCode | varchar | 归属代理商编码 | 归属代理商编码字段 |
| Discount | numeric | 折扣率 | 折扣率字段 |
| CreditRate | varchar | 信用等级 | 信用等级字段 |
| Comment | text | 备注 | 备注说明 |
| CreaterCode | varchar | 创建人编码 | 创建人编码字段 |
| CreateDate | timestamp | 创建日期 | 记录创建时间 |
| InUse | varchar | 是否在用 | YES |
| ReviewStatus | varchar | ReviewStatus | ReviewStatus字段 |

---

## 十、供应商管理

### T_Vendor（供应商表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| VendorCode | varchar | 供应商编号 | 供应商编号 |
| VendorName | varchar | 供应商名称 | 供应商名称 |
| VendorType | varchar | 供应商类型 | 软件/硬件/服务 |
| ContactPerson | varchar | 联系人 | 联系人字段 |
| Phone | varchar | 联系电话 | 联系电话 |
| Address | varchar | 地址 | 联系地址 |
| VendorDetail | text | 供应商详情 | 供应商详情字段 |
| CreaterCode | varchar | 创建人编码 | 创建人编码字段 |
| CreateDate | timestamp | 创建日期 | 记录创建时间 |
| InUse | varchar | 是否在用 | YES |

---

## 十一、物品/供应链管理

### T_Goods（物品/料品表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| GoodsCode | varchar | 物品编号 | 物品编码 |
| GoodsName | varchar | 物品名称 | 物品名称 |
| Type | varchar | 物品类型 | 原材料/半成品/成品 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Manufacturer | varchar | 品牌/制造商 | 品牌/制造商字段 |
| Number | numeric | 数量 | 当前库存数量 |
| Price | numeric | 单价 | 单价 |
| UnitName | varchar | 单位 | 计量单位 |
| Position | varchar | 所在仓库 | 所在仓库字段 |
| WHPosition | varchar | 仓位/库位 | 仓位/库位字段 |
| SN | varchar | 序列号 | 唯一序列号/条码 |
| Supplier | varchar | 供应商 | 供应商字段 |
| WarrantyPeriod | integer | 保修期(天) | 保修期(天)字段 |
| Memo | text | 备注 | 备注字段 |
| OwnerCode | varchar | 保管人代码 | 保管人代码字段 |
| OwnerName | varchar | 保管人姓名 | 保管人姓名字段 |
| BatchNumber | varchar | 批号 | 生产批次号 |
| ProductionDate | date | 生产日期 | 生产日期字段 |
| ExpiryDate | date | 失效日期 | 保质期截止 |
| CurrencyType | varchar | 币种 | 币种类型，如人民币/美元 |
| IsTaxPrice | varchar | 是否含税 | YES/NO |
| BuyTime | date | 购入时间 | 购入时间字段 |
| Status | varchar | 状态 | InUse |
| PhotoURL | varchar | 照片URL | 照片文件路径 |
| GoodsType | varchar | 物品类型 | 办公设备/耗材 |
| Unit | varchar | 单位 | 台/个/套 |
| Quantity | integer | 数量 | 数量 |
| UnitPrice | numeric | 单价 | 单价字段 |
| GoodsDetail | text | 物品详情 | 物品详情字段 |

---

### T_GoodsType（物品类型表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 类型名称 | 原材料、标准件、办公用品等 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_GoodsCheckInOrder（入库单主表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| CheckInID | integer | 入库单号 | 主键 |
| GCIOName | varchar | 入库单编号 | 如 RK20260101001 |
| CheckInType | varchar | 入库类型 | PurchaseIn/ProductionIn/ReturnIn |
| Warehouse | varchar | 入库仓库 | 目标仓库 |
| CurrencyType | varchar | 币种 | 币种类型，如人民币/美元 |
| VendorName | varchar | 供应商名称 | 供应商名称 |
| VendorCode | varchar | 供应商代码 | 供应商编号 |
| CheckInDate | date | 入库日期 | 入库日期字段 |
| Amount | numeric | 金额 | 入库总金额 |
| RelatedType | varchar | 关联类型 | Project/MRPPlan/SaleOrder/Contract |
| RelatedID | integer | 关联ID | 关联业务单据 |
| OperatorCode | varchar | 操作员代码 | 操作人编码 |
| OperatorName | varchar | 操作员姓名 | 操作人姓名 |
| PayStatus | varchar | 付款状态 | New/Paid |
| Status | varchar | DocumentStatus | 状态，记录当前处理阶段 |

---

### T_GoodsCheckInOrderDetail（入库单明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| CheckInID | integer | 入库单号 | 关联主表 |
| GoodsCode | varchar | 料品代码 | 物品编码 |
| GoodsName | varchar | 料品名称 | 物品名称 |
| Type | varchar | 料品类型 | 类型分类 |
| Manufacturer | varchar | 品牌 | 品牌字段 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| CheckInNumber | numeric | 入库数量 | 入库数量字段 |
| UnitName | varchar | 单位 | 单位名称 |
| Price | numeric | 单价 | 单价 |
| IsTaxPrice | varchar | 是否含税价 | YES/NO |
| BuyTime | date | 购入时间 | 购入时间字段 |
| BatchNumber | varchar | 批号 | 批号字段 |
| ProductionDate | date | 生产日期 | 生产日期字段 |
| ExpiryDate | date | 失效日期 | 失效日期字段 |
| SN | varchar | 序列号 | 序列号字段 |
| Supplier | varchar | 供应商 | 供应商字段 |
| WarrantyPeriod | integer | 保修期(天) | 保修期(天)字段 |
| Memo | text | 备注 | 备注字段 |
| WHPosition | varchar | 仓位 | 仓位字段 |
| SourceType | varchar | 来源类型 | 采购单/生产单 |
| SourceID | integer | 来源ID | 来源ID字段 |
| OperatorCode | varchar | 操作员代码 | 操作人编码 |
| OperatorName | varchar | 操作员姓名 | 操作人姓名 |

---

### T_GoodsPurchaseOrder（采购订单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| POID | integer | 采购单号 | 主键 |
| GPOName | varchar | 采购单编号 | 采购单编号字段 |
| PurTime | date | 采购时间 | 采购时间字段 |
| ArrivalTime | date | 到货时间 | 到货时间字段 |
| Amount | numeric | 金额 | 采购总金额 |
| CurrencyType | varchar | 币种 | 币种类型，如人民币/美元 |
| Supplier | varchar | 供应商 | 供应商字段 |
| SupplierPhone | varchar | 供应商电话 | 供应商电话字段 |
| SupplierContacts | varchar | 供应商联系人 | 供应商联系人字段 |
| ClearingForm | varchar | 结算方式 | 结算方式字段 |
| TaxRate | numeric | 税率 | 税率字段 |
| RelatedType | varchar | 关联类型 | 关联业务类型 |
| RelatedID | integer | 关联ID | 关联业务ID |
| Comment | text | 备注 | 备注说明 |
| Status | varchar | 状态 | New/InProgress/Completed |
| OperatorCode | varchar | 操作员代码 | 操作人编码 |
| OperatorName | varchar | 操作员姓名 | 操作人姓名 |

---

### T_GoodsPurRecord（采购明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| POID | integer | 采购单号 | 关联主表 |
| GoodsCode | varchar | 料品代码 | 物品编码 |
| GoodsName | varchar | 料品名称 | 物品名称 |
| Type | varchar | 料品类型 | 类型分类 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Brand | varchar | 品牌 | 品牌字段 |
| Price | numeric | 单价 | 单价 |
| TaxPrice | numeric | 含税价 | 含税价字段 |
| Number | numeric | 数量 | 数量字段 |
| Unit | varchar | 单位 | 计量单位 |
| PurReason | varchar | 采购原因 | 采购原因字段 |
| PurTime | date | 采购时间 | 采购时间字段 |
| ApplicantCode | varchar | 申请人代码 | 申请人编码 |
| ApplicantName | varchar | 申请人姓名 | 申请人姓名 |
| Supplier | varchar | 供应商 | 供应商字段 |
| CheckInNumber | numeric | 已入库数量 | 已入库数量字段 |
| SupplyNumber | numeric | 已供货数量 | 已供货数量字段 |
| ReturnNumber | numeric | 退货数量 | 退货数量字段 |
| SourceType | varchar | 来源类型 | 来源类型字段 |
| SourceID | integer | 来源ID | 来源ID字段 |

---

### T_GoodsShipmentOrder（出库单主表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ShipmentNo | integer | 出库单号 | 主键 |
| GSHOName | varchar | 出库单编号 | 出库单编号字段 |
| ShipmentType | varchar | 出库类型 | SaleOut/ProductionPick |
| Applicant | varchar | 申请人 | 申请人字段 |
| CurrencyType | varchar | 币种 | 币种类型，如人民币/美元 |
| CustomerCode | varchar | 客户代码 | 客户编号 |
| CustomerName | varchar | 客户名称 | 客户名称 |
| Warehouse | varchar | 出库仓库 | 出库仓库字段 |
| ShipTime | date | 出库时间 | 出库时间字段 |
| ApplicationReason | text | 出库原因 | 出库原因字段 |
| RelatedType | varchar | 关联类型 | 关联业务类型 |
| RelatedID | integer | 关联ID | 关联业务ID |
| OperatorCode | varchar | 操作员代码 | 操作人编码 |
| OperatorName | varchar | 操作员姓名 | 操作人姓名 |

---

### T_GoodsShipmentDetail（出库明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| ShipmentNo | integer | 出库单号 | 关联主表 |
| GoodsCode | varchar | 料品代码 | 物品编码 |
| GoodsName | varchar | 料品名称 | 物品名称 |
| Type | varchar | 料品类型 | 类型分类 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Manufacturer | varchar | 品牌 | 品牌字段 |
| Number | numeric | 数量 | 出库数量 |
| Price | numeric | 单价 | 单价 |
| Amount | numeric | 金额 | 金额 |
| UnitName | varchar | 单位 | 单位名称 |
| SN | varchar | 序列号 | 序列号字段 |
| FromPosition | varchar | 出库位置 | 出库位置字段 |
| WarrantyPeriod | integer | 保修期 | 保修期字段 |
| RecordSourceType | varchar | 来源类型 | 来源类型字段 |
| RecordSourceID | integer | 来源ID | 来源ID字段 |

---

### T_GoodsReturnOrder（退货单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ROID | integer | 退货单号 | 主键 |
| ReturnName | varchar | 退货单编号 | 退货单编号字段 |
| Type | varchar | 退货类型 | PURCHASE/SALE/PRODUCTION/BORROW |
| ReturnTime | date | 退货时间 | 退货时间字段 |
| Applicant | varchar | 申请人 | 申请人字段 |
| Vendor | varchar | 供应商 | 供应商字段 |
| CustomerCode | varchar | 客户代码 | 客户编号 |
| Amount | numeric | 金额 | 退货总金额 |
| CurrencyType | varchar | 币种 | 币种类型，如人民币/美元 |
| ReturnReason | text | 退货原因 | 退货原因字段 |
| Status | varchar | 状态 | New/InProgress/Completed |
| OperatorCode | varchar | 操作员代码 | 操作人编码 |
| OperatorName | varchar | 操作员姓名 | 操作人姓名 |

---

### T_GoodsReturnDetail（退货明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| ROID | integer | 退货单号 | 关联主表 |
| GoodsCode | varchar | 料品代码 | 物品编码 |
| GoodsName | varchar | 料品名称 | 物品名称 |
| Type | varchar | 料品类型 | 类型分类 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Brand | varchar | 品牌 | 品牌字段 |
| Number | numeric | 数量 | 退货数量 |
| Price | numeric | 单价 | 单价 |
| Amount | numeric | 金额 | 金额 |
| UnitName | varchar | 单位 | 单位名称 |
| SN | varchar | 序列号 | 序列号字段 |
| ReturnReason | text | 退货原因 | 退货原因字段 |
| WarrantyPeriod | integer | 保修期 | 保修期字段 |
| RecordSourceType | varchar | 来源类型 | 来源类型字段 |
| RecordSourceID | integer | 来源ID | 来源ID字段 |

---

### T_GoodsApplication（领料申请单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| AAID | integer | 申请单号 | 主键 |
| GAANaMe | varchar | 申请单编号 | 申请单编号字段 |
| Type | varchar | 申请类型 | ProductionPick/SalePick |
| ApplyTime | date | 申请时间 | 申请时间字段 |
| FinishTime | date | 完成时间 | 完成时间 |
| ApplyReason | text | 申请原因 | 申请原因字段 |
| RelatedType | varchar | 关联类型 | 关联业务类型 |
| RelatedID | integer | 关联ID | 关联业务ID |
| ApplicantCode | varchar | 申请人代码 | 申请人编码 |
| ApplicantName | varchar | 申请人姓名 | 申请人姓名 |
| Status | varchar | 状态 | New/InProgress/Completed |
| CurrencyType | varchar | 币种 | 币种类型，如人民币/美元 |
| Amount | numeric | 金额 | 金额 |

---

### T_GoodsApplicationDetail（领料申请明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| AAID | integer | 申请单号 | 关联主表 |
| GoodsCode | varchar | 料品代码 | 物品编码 |
| GoodsName | varchar | 料品名称 | 物品名称 |
| Type | varchar | 料品类型 | 类型分类 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Brand | varchar | 品牌 | 品牌字段 |
| Number | numeric | 数量 | 申请数量 |
| CheckoutNumber | numeric | 已出库数量 | 已出库数量字段 |
| Unit | varchar | 单位 | 计量单位 |
| RecordSourceType | varchar | 来源类型 | 来源类型字段 |
| RecordSourceID | integer | 来源ID | 来源ID字段 |

---

### T_GoodsSupplyOrder（供货单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| SUID | integer | 供货单号 | 主键 |
| SUName | varchar | 供货单编号 | 供货单编号字段 |
| CurrencyType | varchar | 币种 | 币种类型，如人民币/美元 |
| Supplier | varchar | 供应商 | 供应商字段 |
| SupplierPhone | varchar | 供应商电话 | 供应商电话字段 |
| SupplyTime | date | 供货时间 | 供货时间字段 |
| Amount | numeric | 金额 | 金额 |
| Comment | text | 备注 | 备注说明 |
| Status | varchar | 状态 | New/InProgress/Completed |
| SourceType | varchar | 来源类型 | 来源类型字段 |
| SourceID | integer | 来源ID | 来源ID字段 |
| OperatorCode | varchar | 操作员代码 | 操作人编码 |
| OperatorName | varchar | 操作员姓名 | 操作人姓名 |

---

### T_GoodsSupplyOrderDetail（供货明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| SUID | integer | 供货单号 | 关联主表 |
| Type | varchar | 料品类型 | 类型分类 |
| GoodsCode | varchar | 料品代码 | 物品编码 |
| GoodsName | varchar | 料品名称 | 物品名称 |
| Number | numeric | 数量 | 供货数量 |
| Unit | varchar | 单位 | 计量单位 |
| Price | numeric | 单价 | 单价 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Brand | varchar | 品牌 | 品牌字段 |
| PurTime | date | 采购时间 | 采购时间字段 |
| PurManCode | varchar | 采购员代码 | 采购员代码字段 |
| PurManName | varchar | 采购员姓名 | 采购员姓名字段 |
| ApplicantCode | varchar | 申请人代码 | 申请人编码 |
| ApplicantName | varchar | 申请人姓名 | 申请人姓名 |
| SupplyNumber | numeric | 供货数量 | 实际供货数量 |
| DefectiveNumber | numeric | 不良品数量 | 不良品数量字段 |
| QCResult | varchar | 质检结果 | 合格/不合格 |
| SourceType | varchar | 来源类型 | 来源类型字段 |
| SourceID | integer | 来源ID | 来源ID字段 |

---

### T_WareHouse（仓库表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| WHName | varchar | 仓库名称 | 所属仓库名称 |
| ParentWH | varchar | 上级仓库 | 支持多级 |
| BelongDepartCode | varchar | 所属部门代码 | 所属部门代码字段 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_WarehousePositions（仓位表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| PositionName | varchar | 仓位名称 | 仓位名称 |
| WHName | varchar | 所属仓库 | 所属仓库名称 |
| Comment | varchar | 备注 | 备注说明 |

---

## 十二、个人计划管理

### T_Plan（计划表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| PlanID | integer | 计划ID | 自增主键 |
| PlanName | varchar | 计划名称 | 计划名称 |
| PlanType | varchar | 计划类型 | 关联T_Plan_Type |
| PlanDetail | text | 计划详情 | 计划详情字段 |
| StartTime | date | 开始时间 | 开始时间 |
| EndTime | date | 结束时间 | 结束时间字段 |
| Progress | integer | 进度 | 0-100 |
| ScoringBySelf | integer | 自评分 | 员工自评分 |
| ScoringByLeader | integer | 领导评分 | 领导评分 |
| UserCode | varchar | 用户编码 | 计划所属用户 |
| UserName | varchar | 用户姓名 | 用户姓名 |
| CreatorCode | varchar | 创建人编码 | 创建人编码字段 |
| CreatorName | varchar | 创建人姓名 | 创建人姓名字段 |
| Status | varchar | 状态 | New/InProgress/Completed/Deleted/Archived |
| SubmitTime | timestamp | 提交时间 | 提交时间字段 |
| RelatedType | varchar | 关联类型 | 如项目 |
| RelatedID | integer | 关联ID | 关联业务ID |
| ParentID | integer | 父计划ID | 父级记录ID，用于构建层级结构 |

---

### T_Plan_Target（计划目标表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 目标ID | 自增主键 |
| PlanID | integer | 所属计划ID | 关联T_Plan |
| Target | text | 目标内容 | 目标内容字段 |
| Progress | integer | 进度 | 0-100 |

---

### T_Plan_WorkLog（计划工作日志表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 日志ID | 自增主键 |
| PlanID | integer | 所属计划ID | 关联T_Plan表，标识所属计划 |
| LogDetail | text | 日志详情 | 日志详情字段 |
| Progress | integer | 进度 | 进度百分比 |
| WorkTime | timestamp | 工作时间 | 工作时间字段 |
| UserCode | varchar | 记录人编码 | 用户编码，登录账号 |
| UserName | varchar | 记录人姓名 | 用户姓名 |
| ScheduleEventID | integer | 日程事件ID | 关联日程 |

---

### T_Plan_LeaderReview（计划领导评核表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 评审记录ID | 自增主键 |
| PlanID | integer | 所属计划ID | 关联T_Plan表，标识所属计划 |
| LeaderCode | varchar | 领导编码 | 领导编码字段 |
| LeaderName | varchar | 领导姓名 | 领导姓名字段 |
| Review | text | 评审意见 | 评审意见字段 |
| Scoring | integer | 评分 | 评分字段 |
| ReviewTime | timestamp | 评审时间 | 评审时间字段 |

---

### T_Plan_RelatedLeader（计划关联领导表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| PlanID | integer | 所属计划ID | 关联T_Plan表，标识所属计划 |
| LeaderCode | varchar | 领导编码 | 领导编码字段 |
| LeaderName | varchar | 领导姓名 | 领导姓名字段 |
| JoinTime | timestamp | 加入时间 | 加入时间字段 |
| Actor | varchar | 操作角色 | 操作角色字段 |
| Status | varchar | 状态 | New/Approved/Completed |

---

### T_Plan_Type（计划类型配置表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 计划类型 | 类型分类 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

## 十三、项目计划管理

### T_ProjectPlanVersion（项目计划版本表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| VerID | integer | 版本ID | 版本ID字段 |
| ProjectID | integer | 项目ID | 关联T_Project |
| Type | varchar | 版本类型 | InUse/Baseline/Backup/Deleted |
| CreatorCode | varchar | 创建人编码 | 创建人编码字段 |
| CreateTime | timestamp | 创建时间 | 创建时间 |

---

### T_ImplePlan（实施计划表 / 甘特图计划表）

> 项目管理模块的核心计划表，支持树形结构和多版本

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 计划编号 | 主键 |
| ProjectID | integer | 项目ID | 关联T_Project |
| VerID | integer | 版本ID | 计划版本 |
| Name | varchar | 计划名称 | 名称 |
| ParentID | integer | 父计划编号 | 树形结构，0=根节点 |
| Start_Date | date | 开始日期 | 开始日期字段 |
| End_Date | date | 结束日期 | 结束日期字段 |
| Percent_Done | numeric | 完成百分比 | 0-100 |
| Budget | numeric | 预算 | 预算金额 |
| ManHour | numeric | 工时 | 计划工时（小时） |
| ActualHour | numeric | 实际工时 | 实际工时字段 |
| Expense | numeric | 费用 | 实际费用 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |
| LeaderCode | varchar | 负责人编码 | 负责人编码字段 |
| Leader | varchar | 负责人姓名 | 负责人姓名字段 |
| CreatorCode | varchar | 创建人编码 | 创建人编码字段 |
| BelongDepartCode | varchar | 归属部门编码 | 归属部门编码字段 |
| BelongDepartName | varchar | 归属部门名称 | 归属部门名称字段 |
| Remark | text | 备注 | 备注说明 |
| LockStatus | varchar | 锁定状态 | YES/NO |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

## 十四、工作流审批

### T_WorkFlow（工作流实例表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| WLID | integer | 工作流ID | 自增主键 |
| WLName | varchar | 工作流名称 | 工作流名称字段 |
| WLType | varchar | 工作流类型 | 关联T_WLType |
| TemName | varchar | 模板名称 | 关联T_WorkFlowTemplate |
| CreatorCode | varchar | 创建者编码 | 创建者编码字段 |
| CreatorName | varchar | 创建者姓名 | 创建者姓名字段 |
| CreateTime | timestamp | 创建时间 | 创建时间 |
| Status | varchar | 状态 | New/InProgress/Passed/CaseClosed |
| RelatedType | varchar | 关联类型 | Project/Document/Plan |
| RelatedID | integer | 关联ID | 关联业务ID |
| Description | text | 描述 | 详细描述信息 |
| XMLFile | varchar | XML文件 | 表单数据XML |
| ReceiveSMS | varchar | 接收短信 | YES/NO |
| ReceiveEMail | varchar | 接收邮件 | YES/NO |
| DIYNextStep | varchar | DIY下一步骤 | YES/NO |
| IsPlanMainWorkflow | varchar | 是否计划主流程 | YES/NO |

---

### T_WorkFlowTemplate（工作流模板表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| TemName | varchar | 模板名称 | 主键 |
| Type | varchar | 工作流类型 | 关联T_WLType |
| CreatorCode | varchar | 创建者编码 | 创建者编码字段 |
| Status | varchar | 状态 | InUse |
| Authority | varchar | 权限范围 | All/Part |
| WFDefinition | text | 流程定义 | JSON/XML |
| EnableEdit | varchar | 允许编辑 | YES/NO |
| BelongDepartCode | varchar | 所属部门编号 | 所属部门编号字段 |
| OverTimeAutoAgree | varchar | 超时自动同意 | YES/NO |
| OverTimeHourNumber | integer | 超时小时数 | 默认24 |
| IdentifyString | varchar | 识别字符串 | 唯一ID |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_WorkFlowTStep（工作流模板步骤表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| StepID | integer | 步骤ID | 主键 |
| TemName | varchar | 模板名称 | 关联T_WorkFlowTemplate |
| StepName | varchar | 步骤名称 | 如"部门经理审批" |
| SortNumber | integer | 排序号 | 步骤顺序 |
| LimitedTime | integer | 限定时间(小时) | 审批时限 |
| NextSortNumber | integer | 下一步骤排序号 | 流转方向 |
| SelfReview | varchar | 自审标记 | YES/NO |
| OperatorSelect | varchar | 操作者选择 | YES/NO |

---

### T_WorkFlowTStepOperator（工作流步骤操作者表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 主键 | 主键，自增 |
| StepID | integer | 步骤ID | 关联T_WorkFlowTStep |
| TemName | varchar | 模板名称 | 模板名称字段 |
| Actor | varchar | 操作者 | 用户编号 |
| WorkDetail | text | 工作说明 | 审批要求描述 |
| Requisite | varchar | 是否必须 | YES/NO |

---

### T_WorkFlowStep（工作流实例步骤表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| StepID | integer | 步骤ID | 主键 |
| WLID | integer | 工作流ID | 关联T_WorkFlow |
| StepName | varchar | 步骤名称 | 步骤名称 |
| ActiveTime | timestamp | 激活时间 | 激活时间字段 |
| Status | varchar | 状态 | InProgress/Approved/Rejected |
| LimitedTime | integer | 限定时间 | 限定时间字段 |
| LimitedOperator | varchar | 限定操作者 | 限定操作者字段 |

---

### T_WorkFlowStepDetail（工作流步骤明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 主键 |
| StepID | integer | 步骤ID | 工作流步骤ID |
| WLID | integer | 工作流ID | 工作流ID字段 |
| OperatorCode | varchar | 操作者编号 | 审批人 |
| OperatorName | varchar | 操作者姓名 | 操作人姓名 |
| Operation | text | 操作内容 | 审批意见 |
| CheckingTime | timestamp | 审批时间 | 审批时间字段 |
| Status | varchar | 状态 | InProgress/Approved/Rejected |
| WorkDetail | text | 工作说明 | 工作说明字段 |
| IsOperator | varchar | 是否操作者 | YES/NO |
| FinishedTime | timestamp | 完成时间 | 完成时间字段 |
| ManHour | numeric | 工时 | 计划工时（小时） |
| Expense | numeric | 费用 | 实际费用 |

---

### T_WLType（工作流类型字典表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 类型编码 | 主键 |
| HomeName | varchar | 显示名称 | 本地化名称 |
| LangCode | varchar | 语言代码 | 语言代码，如zh-CN/en-US |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

## 十五、模块权限

### T_ProModuleLevel（模块定义表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 模块ID | 自增主键 |
| ModuleName | varchar | 模块名称 | 唯一标识，如 ProjectManagement |
| HomeModuleName | varchar | 模块显示名称 | 中文名，如"项目管理" |
| PageName | varchar | 页面名称 | 关联的Blazor页面 |
| ModuleType | varchar | 模块类型 | APP/DIYAPP/SITE |
| UserType | varchar | 用户类型 | INNER/OUTER |
| ParentModule | varchar | 父模块 | 模块层级关系 |
| LangCode | varchar | 语言代码 | zh-CN/en-US |
| Visible | varchar | 是否可见 | YES/NO |
| IsDeleted | varchar | 是否已删除 | YES/NO |
| ModuleDefinition | text | 模块定义 | 流程图JSON |

---

### T_ProModule（用户模块权限表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ModuleName | varchar | 模块名称 | 关联T_ProModuleLevel |
| ModuleType | varchar | 模块类型 | 模块类型字段 |
| UserCode | varchar | 用户编号 | 关联T_ProjectMember |
| UserType | varchar | 用户类型 | 用户类型字段 |
| Visible | varchar | 是否可见 | YES/NO |
| IsDeleted | varchar | 是否已删除 | YES/NO |

---

## 十六、KPI绩效管理

### T_KPITemplateForDepartPosition（KPI模板表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| DepartCode | varchar | 部门编码 | 部门编码，关联T_Department表 |
| Position | varchar | 职位 | 职位字段 |
| KPI | text | KPI指标 | 模板内容 |

---

### T_UserKPICheck（用户KPI考核表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| KPICheckID | integer | KPI考核ID | 自增主键 |
| KPICheckName | varchar | KPI考核名称 | 考核批次名称 |
| UserCode | varchar | 用户编码 | 被考核人 |
| UserName | varchar | 用户姓名 | 用户姓名 |
| TotalSelfPoint | numeric | 自评总分 | 自评总分字段 |
| TotalLeaderPoint | numeric | 领导评总分 | 领导评总分字段 |
| TotalThirdPartPoint | numeric | 第三方评总分 | 第三方评总分字段 |
| TotalSqlPoint | numeric | SQL系统评分总分 | SQL系统评分总分字段 |
| TotalHRPoint | numeric | HR评分总分 | HR评分总分字段 |
| TotalPoint | numeric | 总分 | 总分字段 |
| Status | varchar | 状态 | Active/Closed |
| StartTime | timestamp | 开始时间 | 考核周期开始 |
| EndTime | timestamp | 结束时间 | 考核周期结束 |

---

### T_UserKPICheckDetail（用户KPI考核明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| KPICheckID | integer | 考核ID | 关联主表 |
| KPI | varchar | KPI指标 | KPI指标字段 |
| Definition | text | 定义 | 指标定义/说明 |
| Target | varchar | 目标 | 目标值 |
| Formula | varchar | 公式 | 计算公式 |
| Weight | numeric | 权重 | 该项权重 |
| SelfPoint | numeric | 自评分 | 自评分字段 |
| SelfComment | text | 自评说明 | 自评说明字段 |
| LeaderPoint | numeric | 领导评分 | 领导评分字段 |
| ThirdPartPoint | numeric | 第三方评分 | 第三方评分字段 |
| SqlPoint | numeric | SQL系统评分 | SQL系统评分字段 |
| HRPoint | numeric | HR评分 | HR评分字段 |
| Point | numeric | 综合得分 | 综合得分字段 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

## 十七、财务会计

### T_AccountFinancialSet（财务帐套设置表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| FinancialCode | varchar | 财务编码 | 主键 |
| FinancialName | varchar | 帐套名称 | 帐套名称字段 |
| Industry | varchar | 行业 | 行业字段 |
| DepartCode | varchar | 部门编码 | 部门编码，关联T_Department表 |
| DepartName | varchar | 部门名称 | 部门名称 |
| CurrencyType | varchar | 本位币 | 币种类型，如人民币/美元 |
| Status | varchar | 状态 | OPEN/CLOSE |
| StartTime | timestamp | 开始时间 | 开始时间 |
| EndTime | timestamp | 结束时间 | 结束时间字段 |
| ExchangeRate | numeric | 汇率 | 汇率 |

---

### T_Account（会计科目表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| AccountCode | varchar | 科目代码 | 主键 |
| AccountName | varchar | 科目名称 | 会计科目名称 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |
| AccountType | varchar | 科目类型 | 资产/负债/成本/权益/损益 |

---

### T_AccountGeneralLedger（总分类账表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| FinancialCode | varchar | 财务编码 | 财务编码字段 |
| IntervalCode | varchar | 区间编码 | 区间编码字段 |
| AccountCode | varchar | 科目编码 | 会计科目编码 |
| TotalMoney | numeric | 总金额 | 总金额字段 |
| BeforeMoney | numeric | 期初金额 | 期初金额字段 |
| HappenMoney | numeric | 发生金额 | 发生金额字段 |
| ReceivablesRecordID | integer | 应收记录ID | 应收记录ID字段 |
| PayableRecordID | integer | 应付记录ID | 应付记录ID字段 |
| Currency | varchar | 币种 | 币种 |
| Operator | varchar | 操作人 | 操作人字段 |
| CreateTime | timestamp | 创建时间 | 创建时间 |

---

### T_ConstractPayableRecord（应付记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| PayableID | integer | 应付ID | 关联T_ConstractPayable |
| ConstractCode | varchar | 合同编码 | 合同编号 |
| OutOfPocketAccount | numeric | 实付金额 | 实付金额字段 |
| OutOfPocketTime | date | 实付日期 | 实付日期字段 |
| ReAndPayType | varchar | 收付方式 | 收付方式字段 |
| Receiver | varchar | 收款人 | 收款人字段 |
| Currency | varchar | 币种 | 币种 |
| Bank | varchar | 银行 | 银行字段 |
| ExchangeRate | numeric | 汇率 | 汇率 |
| InvoiceAccount | numeric | 开票金额 | 开票金额字段 |
| VoucherCode | varchar | 凭证编号 | 凭证编号字段 |
| Comment | text | 备注 | 备注说明 |
| OperatorCode | varchar | 操作人编码 | 操作人编码 |
| OperatorName | varchar | 操作人名称 | 操作人姓名 |
| OperateTime | timestamp | 操作时间 | 操作时间字段 |

---

### T_ConstractReceivablesRecord（应收记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ReceivablesID | integer | 应收ID | 关联T_ConstractReceivables |
| ConstractCode | varchar | 合同编码 | 合同编号 |
| ReceiverAccount | numeric | 实收金额 | 实收金额字段 |
| ReceiverTime | date | 实收日期 | 实收日期字段 |
| ReAndPayType | varchar | 收付方式 | 收付方式字段 |
| Currency | varchar | 币种 | 币种 |
| Bank | varchar | 银行 | 银行字段 |
| ExchangeRate | numeric | 汇率 | 汇率 |
| InvoiceAccount | numeric | 开票金额 | 开票金额字段 |
| Payer | varchar | 付款人 | 付款人字段 |
| OperatorCode | varchar | 操作人编码 | 操作人编码 |
| OperatorName | varchar | 操作人名称 | 操作人姓名 |
| OperateTime | timestamp | 操作时间 | 操作时间字段 |

---

## 十八、报表与统计

### T_Report（报表表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 报表编号 | 主键 |
| ReportName | varchar | 报表名称 | 报表名称字段 |
| ReportType | varchar | 报表类型 | 关联T_ReportType |
| Category | varchar | 分类 | 分类字段 |
| Description | text | 描述 | 详细描述信息 |
| TemName | varchar | 模板名称 | 关联T_ReportTemplate |
| ReportURL | varchar | 报表URL | 报表HTML文件路径 |
| CreatorCode | varchar | 创建人编码 | 创建人编码字段 |
| CreatorName | varchar | 创建人姓名 | 创建人姓名字段 |
| CreateTime | timestamp | 创建时间 | 创建时间 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_ReportTemplate（报表模板表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 模板编号 | 主键 |
| ReportType | varchar | 报表类型 | 关联T_ReportType |
| TemName | varchar | 模板名称 | 模板名称字段 |
| TemComment | text | 模板描述 | 模板描述字段 |
| TemDefinition | text | 模板定义 | jsreport模板定义 |
| CreatorCode | varchar | 创建者编码 | 创建者编码字段 |
| CreatorName | varchar | 创建者名称 | 创建者名称字段 |
| CreateTime | timestamp | 创建时间 | 创建时间 |
| BelongDepartCode | varchar | 所属部门代码 | 所属部门代码字段 |
| BelongDepartName | varchar | 所属部门名称 | 所属部门名称字段 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_ReportType（报表类型表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 分析类型 | 报表分类类型名称 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_Document（文档表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| DocID | integer | 文档编号 | 主键 |
| RelatedType | varchar | 关联类型 | Plan/Document/Workflow |
| RelatedID | integer | 关联ID | 关联业务ID |
| DocName | varchar | 文档名称 | 文档名称字段 |
| DocType | varchar | 文档类型 | 文档类型字段 |
| Address | text | 文件地址 | 存储路径 |
| Author | varchar | 作者 | 作者字段 |
| UploadManCode | varchar | 上传人编码 | 上传人编码字段 |
| UploadManName | varchar | 上传人姓名 | 上传人姓名字段 |
| UploadTime | timestamp | 上传时间 | 上传时间字段 |
| Status | varchar | 状态 | InProgress/Deleted |

---

## 十九、系统配置

### T_AIInterface（AI接口配置表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| AIType | varchar | AI类型 | Outer=外部AI，Inner=内部AI |
| URL | varchar | 接口地址 | AI API的URL |
| AIKey | varchar | API密钥 | API密钥字段 |
| Model | varchar | 模型名称 | 模型名称字段 |
| InUse | varchar | 是否启用 | YES |

---

### T_SystemLanguage（系统语言表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| LangCode | varchar | 语言代码 | 如 zh-CN, en-US |
| Language | varchar | 语言名称 | 显示名称 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_LogonLog（登录日志表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| UserCode | varchar | 用户编码 | 用户编码，登录账号 |
| UserName | varchar | 用户姓名 | 用户姓名 |
| LogonTime | timestamp | 登录时间 | 登录时间字段 |
| LastestTime | timestamp | 最近活跃时间 | 用于在线统计 |

---

### T_NewsType（新闻类型表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 类型编码 | 类型分类 |
| HomeName | varchar | 显示名称 | 显示名称（多语言） |
| LangCode | varchar | 语言代码 | 语言代码，如zh-CN/en-US |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_Headline（新闻/公告信息表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| Title | varchar | 标题 | 标题 |
| Content | text | 内容 | 内容详情 |
| PublisherCode | varchar | 发布人编码 | 发布人编码 |
| PublisherName | varchar | 发布人姓名 | 发布人姓名 |
| PublishTime | timestamp | 发布时间 | 发布时间 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |
| RelatedDepartCode | varchar | 关联部门编码 | 关联部门编码 |
| RelatedDepartName | varchar | 关联部门名称 | 关联部门名称 |
| Type | varchar | 类型 | 类型分类 |
| LangCode | varchar | 语言代码 | 语言代码，如zh-CN/en-US |
| IsHead | varchar | 是否置顶 | YES/NO |
| NewsType | varchar | 新闻类型 | 新闻类型字段 |
| ContentDocUrl | varchar | 文档URL | 文档URL字段 |

---

### T_FunInforDialBox（预警配置表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| InforName | varchar | 信息名称 | 预警类型标识 |
| HomeName | varchar | 显示名称 | 显示名称（多语言） |
| SQLCode | text | SQL代码 | 动态SQL统计待办 |
| LinkAddress | varchar | 链接地址 | 点击跳转页面 |
| LangCode | varchar | 语言代码 | 语言代码，如zh-CN/en-US |

---

### T_DataBaseUpgrate（数据库升级记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 升级条目ID | 对应XML中的编号 |
| SQLText | text | SQL文本 | 执行的SQL语句 |
| IsSucess | varchar | 是否成功 | YES/NO |
| UpdateTime | timestamp | 更新时间 | 执行时间 |

---

### T_DBReadOnlyUserInfor（数据库只读用户信息表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| DBUserID | varchar | 数据库用户ID | 只读用户的数据库用户名 |
| Password | varchar | 密码 | 只读用户密码 |

---

### T_LicenseVerification（授权验证表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ServerName | varchar | 服务器名称 | 服务器标识 |
| VerificationString | varchar | 验证字符串 | DES加密的授权信息 |

---

## 附录：表关系图

```
T_ProjectMember (用户主表)
├── T_Project (项目) [PMCode/UserCode]
├── T_ProModule (模块权限) [UserCode]
├── T_Plan (个人计划) [UserCode]
└── T_UserKPICheck (KPI考核) [UserCode]

T_Project (项目)
├── T_ProjectMember (项目成员) [ProjectID]
├── T_ProjectBudget (预算) [ProjectID]
├── T_ProExpense (费用) [ProjectID]
├── T_ProjectTask (任务) [ProjectID]
├── T_ImplePlan (实施计划) [ProjectID]
├── T_RelatedUser (关联用户) [ProjectID]
└── T_ProjectCustomer (客户关联) [ProjectID]

T_ProModuleLevel (模块定义)
└── T_ProModule (用户权限) [ModuleName]

T_WorkFlowTemplate (工作流模板)
├── T_WorkFlowTStep (模板步骤) [TemName]
├── T_WorkFlowTStepOperator (步骤操作者) [TemName+StepID]
└── T_WorkFlow (工作流实例) [TemName]

T_Plan (个人计划)
├── T_Plan_Target (计划目标) [PlanID]
├── T_Plan_WorkLog (工作日志) [PlanID]
├── T_Plan_LeaderReview (领导评核) [PlanID]
└── T_Plan_RelatedLeader (关联领导) [PlanID]

T_Goods (物品/料品)
├── T_GoodsCheckInOrder (入库单) [GoodsCode]
├── T_GoodsShipmentOrder (出库单) [GoodsCode]
├── T_GoodsReturnOrder (退货单) [GoodsCode]
├── T_GoodsPurchaseOrder (采购订单) [GoodsCode]
└── T_GoodsSupplyOrder (供货单) [GoodsCode]

T_Constract (合同)
├── T_ConstractReceivables (应收账款) [ConstractCode]
├── T_ConstractPayable (应付账款) [ConstractCode]
├── T_ConstractRelatedGoods (关联商品) [ConstractCode]
└── T_ConstractRelatedUser (关联用户) [ConstractCode]

T_Asset (资产)
├── T_AssetPurchaseOrder (采购订单) [AssetCode]
├── T_AssetPurRecord (采购记录) [AssetCode]
├── T_AssetScrape (报废记录) [AssetCode]
└── T_AssetShipmentOrder (发货单) [AssetCode]
```

---

## 附录：字段值约定

| 字段 | 可能的值 | 说明 |
|------|---------|------|
| InUse | YES / NO | 记录是否有效 |
| Visible | YES / NO | 是否可见 |
| IsDeleted | YES / NO | 是否已删除 |
| Status（项目） | New/InProgress/Accepted/Rejected/Deleted/Archived/Pause/Stop | 项目状态 |
| Status（任务） | ToHandle/InProgress/Completed/Closed | 任务状态 |
| Status（合同） | InProgress/Completed/Archived/Cancel/Deleted | 合同状态 |
| Status（资产） | InUse/Idle/Scrapped | 资产状态 |
| Status（需求） | Plan/InProgress/Closed/Rejected/Suspended/Cancel/Hided/Deleted/Archived | 需求状态 |
| Status（缺陷） | Plan/InProgress/Closed/Hided/Deleted/Archived | 缺陷状态 |
| Status（会议） | Normal/Cancel | 会议状态 |
| Status（工作流） | New/InProgress/Passed/CaseClosed | 工作流状态 |
| Priority | 高/中/低/COMMON/Normal/High/Low/Urgent | 优先级 |
| IsSuper | YES / NO | 是否超级管理员 |

---

## 附录：编号规则

| 表名 | 编号字段 | 格式 | 示例 |
|------|---------|------|------|
| T_Project | ProjectCode | PJ{yyyyMMdd}{seq:4} | PJ202606210001 |
| T_Task | TaskCode | TK{yyyyMMdd}{seq:4} | TK202606210001 |
| T_Constract | ConstractCode | HT{yyyyMMdd}{seq:4} | HT202606210001 |
| T_Asset | AssetCode | ZC{yyyyMMdd}{seq:4} | ZC202606210001 |
| T_Requirement | ReqCode | XQ{yyyyMMdd}{seq:4} | XQ202606210001 |
| T_Defectment | DefectCode | QX{yyyyMMdd}{seq:4} | QX202606210001 |

---

## 附录：旧版分析补充的表和字段

> 以下内容基于旧版ASP.NET WebForms页面分析补充

### T_DailyWork（日报表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| WorkID | integer | 工作ID | 主键 |
| ProjectID | integer | 项目ID | 关联T_Project |
| UserCode | varchar | 用户代码 | 用户编码，登录账号 |
| UserName | varchar | 用户名称 | 用户姓名 |
| WorkDate | date | 工作日期 | 工作日期字段 |
| DailySummary | text | 每日总结 | 每日总结字段 |
| Achievement | text | 成果 | 成果字段 |
| Address | varchar | 工作地址 | 联系地址 |
| FinishPercent | numeric | 完成百分比 | 完成百分比，0-100 |
| Charge | numeric | 费用 | 费用字段 |
| ManHour | numeric | 工时 | 计划工时（小时） |
| Authority | varchar | 权限 | 权限字段 |

---

### T_ProjectMemberExtend（项目成员扩展表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| UserCode | varchar | 用户代码 | 用户编码，登录账号 |
| TopDepartName | varchar | 一级部门名称 | 一级部门名称字段 |
| EntryTotalYearMonth | varchar | 入职总年月 | 入职总年月字段 |
| OfficeAddress | varchar | 办公地址 | 办公地址字段 |
| UserTypeExtend | varchar | 员工类型(扩展) | 员工类型(扩展)字段 |
| UserState | varchar | 员工状态 | 员工状态字段 |
| ProbationPeriod | varchar | 试用期 | 试用期字段 |
| TurnOfficialDate | date | 实际转正日期 | 实际转正日期字段 |
| HouseRegisterType | varchar | 户籍类型 | 户籍类型字段 |
| PoliticalOutlook | varchar | 政治面貌 | 政治面貌字段 |
| ContractType | varchar | 合同类型 | 合同类型字段 |
| ContractCompany | varchar | 合同公司 | 合同公司字段 |
| FirstContractStartTime | date | 首次合同起始日 | 首次合同起始日字段 |
| FirstContractEndTime | date | 首次合同到期日 | 首次合同到期日字段 |
| FirstContractYears | integer | 首次合同期限 | 首次合同期限字段 |
| SignContractCount | integer | 已签次数 | 已签次数字段 |
| ContractStartTime | date | 现合同起始日 | 现合同起始日字段 |
| ContractYears | integer | 现合同期限 | 现合同期限字段 |

---

### T_ProjectRelatedItem（项目关联物料表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ProjectID | integer | 项目ID | 关联T_Project |
| ItemCode | varchar | 物料代码 | 关联T_Item |
| FirstDirectory | varchar | 一级目录 | 一级目录字段 |

---

### T_ConstractSales（合同销售表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ConstractCode | varchar | 合同编码 | 合同编号 |
| SalesName | varchar | 业务员 | 业务员字段 |
| Duty | varchar | 职责 | 职责字段 |
| Commission | numeric | 佣金 | 佣金字段 |
| GiveTime | date | 发放时间 | 发放时间字段 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |
| Comment | text | 备注 | 备注说明 |

---

### T_ConstractRelatedInvoice（合同关联发票表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ConstractCode | varchar | 合同编码 | 合同编号 |
| ReceiveOpen | varchar | 收票类型 | 收票类型字段 |
| TaxType | varchar | 税票类型 | 税票类型字段 |
| InvoiceCode | varchar | 发票号码 | 发票号码字段 |
| Amount | numeric | 金额 | 金额 |
| TaxRate | numeric | 税率 | 税率字段 |
| OpenDate | date | 开票日期 | 开票日期字段 |

---

### T_ConstractGoodsReceiptPlan（合同货物接收计划表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| ReceiptedNumber | numeric | 已收货数量 | 已收货数量字段 |
| UNReceiptedNumber | numeric | 未收货数量 | 未收货数量字段 |
| PreDay | integer | 提前日期 | 提前日期字段 |

---

### T_ConstractGoodsDeliveryPlan（合同货物交付计划表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| DeliveredNumber | numeric | 已发货数量 | 已发货数量字段 |
| UNDeliveredNumber | numeric | 未发货数量 | 未发货数量字段 |
| PreDay | integer | 提前日期 | 提前日期字段 |

---

### T_ConstractRelatedEntryOrder（合同关联入库单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| EntryCode | varchar | 报关单号 | 报关单号字段 |
| PreEntryCode | varchar | 预申报号 | 预申报号字段 |
| EntryName | varchar | 名称 | 名称字段 |
| Amount | numeric | 金额 | 金额 |
| Currency | varchar | 币种 | 币种 |
| ExchangeRate | numeric | 汇率 | 汇率 |
| EntryTax | numeric | 关税 | 关税字段 |
| AddedValueTax | numeric | 增值税 | 增值税字段 |
| Customs | varchar | 口岸 | 口岸字段 |
| ImportDate | date | 进口日期 | 进口日期字段 |
| ReportDate | date | 申报日期 | 申报日期字段 |

---

### T_AssetUserRecord（资产使用记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| AssetID | integer | 资产ID | 关联T_Asset |

---

### T_AssetCheckInOrder（资产入库单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| CheckInID | integer | 入库单ID | 主键 |

---

### T_AssetCheckInOrderDetail（资产入库明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| CheckInID | integer | 入库单ID | 关联主表 |

---

### T_AssetReturnOrder（资产归还单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ReturnID | integer | 归还单ID | 主键 |

---

### T_AssetReturnDetail（资产归还明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 明细ID | 自增主键 |
| ReturnID | integer | 归还单ID | 关联主表 |

---

### T_AssetMTRecord（资产维护记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| AssetID | integer | 资产ID | 关联T_Asset |
| Type | varchar | 维修类型 | 类型分类 |
| Description | text | 描述 | 详细描述信息 |
| MTManCode | varchar | 维修人编码 | 维修人编码字段 |
| MTManName | varchar | 维修人名称 | 维修人名称字段 |
| MTTime | timestamp | 维修时间 | 维修时间字段 |
| Cost | numeric | 维修费用 | 成本 |

---

### T_AssetAdjustRecord（资产调整记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| AssetID | integer | 资产ID | 关联T_Asset |

---

### T_GoodsBorrowOrder（借用单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| BorrowID | integer | 借用单号 | 主键 |
| BorrowName | varchar | 借用单编号 | 借用单编号字段 |
| Applicant | varchar | 申请人 | 申请人字段 |
| BorrowTime | date | 借用时间 | 借用时间字段 |
| ReturnTime | date | 归还时间 | 归还时间字段 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |

---

### T_GoodsSaleOrder（销售订单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| SOID | integer | 销售单号 | 主键 |
| SOName | varchar | 销售单编号 | 销售单编号字段 |
| CustomerCode | varchar | 客户代码 | 客户编号 |
| CustomerName | varchar | 客户名称 | 客户名称 |
| SalesCode | varchar | 业务员代码 | 业务员代码字段 |
| SalesName | varchar | 业务员名称 | 业务员名称字段 |
| Amount | numeric | 金额 | 金额 |
| CurrencyType | varchar | 币种 | 币种类型，如人民币/美元 |
| SaleTime | date | 销售时间 | 销售时间字段 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |

---

### T_GoodsProductionOrder（生产订单表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| PDID | integer | 生产单号 | 主键 |
| PDName | varchar | 生产单编号 | 生产单编号字段 |
| ProductionDate | date | 生产日期 | 生产日期字段 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |

---

### T_VendorRelatedGoodsInfor（供应商关联物资信息表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 记录ID | 自增主键 |
| VendorCode | varchar | 供应商编号 | 供应商编号 |
| Type | varchar | 类型 | 类型分类 |
| GoodsCode | varchar | 物资编号 | 物品编码 |
| GoodsName | varchar | 物资名称 | 物品名称 |
| ModelNumber | varchar | 型号 | 型号字段 |
| Spec | varchar | 规格 | 规格字段 |
| Brand | varchar | 品牌 | 品牌字段 |
| Number | numeric | 数量 | 数量字段 |
| Unit | varchar | 单位 | 计量单位 |
| Price | numeric | 价格 | 单价 |

---

### T_CustomerRelatedUser（客户关联用户表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| CustomerCode | varchar | 客户编码 | 客户编号 |
| UserCode | varchar | 用户编码 | 用户编码，登录账号 |
| UserName | varchar | 用户名称 | 用户姓名 |

---

### T_CustomerQuestion（客户问题表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 问题ID | 主键 |
| CustomerCode | varchar | 客户编码 | 客户编号 |
| Question | text | 问题内容 | 问题内容字段 |
| CreateDate | date | 创建日期 | 记录创建时间 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |

---

### T_IndustryType（行业类型表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 类型名称 | 类型分类 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_ScheduleEvent（日程事件表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 事件ID | 主键 |
| Name | varchar | 事件名称 | 名称 |
| EventContent | text | 事件内容 | 事件内容字段 |
| EventStart | timestamp | 开始时间 | 开始时间字段 |
| EventEnd | timestamp | 结束时间 | 结束时间字段 |
| UserCode | varchar | 用户代码 | 用户编码，登录账号 |
| UserName | varchar | 用户名称 | 用户姓名 |

---

### T_UserSchedule（用户排班表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 排班ID | 主键 |
| ScheduleName | varchar | 排班名称 | 排班名称字段 |
| CheckInStart | time | 签到开始 | 签到开始字段 |
| CheckInEnd | time | 签到结束 | 签到结束字段 |
| OfficeLongitude | numeric | 办公室经度 | 办公室经度字段 |
| OfficeLatitude | numeric | 办公室纬度 | 办公室纬度字段 |
| LargestDistance | numeric | 最大距离 | 最大距离字段 |

---

### T_AttendanceRule（全局考勤规则表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| MCheckInStart | time | 上午签到开始 | 上午签到开始字段 |
| MCheckInEnd | time | 上午签到结束 | 上午签到结束字段 |
| MCheckOutStart | time | 上午签退开始 | 上午签退开始字段 |
| MCheckOutEnd | time | 上午签退结束 | 上午签退结束字段 |
| ACheckInStart | time | 下午签到开始 | 下午签到开始字段 |
| ACheckInEnd | time | 下午签到结束 | 下午签到结束字段 |
| ACheckOutStart | time | 下午签退开始 | 下午签退开始字段 |
| ACheckOutEnd | time | 下午签退结束 | 下午签退结束字段 |
| NCheckInStart | time | 夜班签到开始 | 夜班签到开始字段 |
| NCheckInEnd | time | 夜班签到结束 | 夜班签到结束字段 |
| NCheckOutStart | time | 夜班签退开始 | 夜班签退开始字段 |
| NCheckOutEnd | time | 夜班签退结束 | 夜班签退结束字段 |
| OCheckInStart | time | 加班签到开始 | 加班签到开始字段 |
| OCheckInEnd | time | 加班签到结束 | 加班签到结束字段 |
| OCheckOutStart | time | 加班签退开始 | 加班签退开始字段 |
| OCheckOutEnd | time | 加班签退结束 | 加班签退结束字段 |
| MCheckInIsMust | varchar | 上午签到必须 | YES/NO |
| MCheckOutIsMust | varchar | 上午签退必须 | YES/NO |
| LargestDistance | numeric | 最大距离 | 允许签到最大距离(米) |
| OfficeLongitude | numeric | 办公室经度 | 办公室经度字段 |
| OfficeLatitude | numeric | 办公室纬度 | 办公室纬度字段 |
| Address | varchar | 地址 | 联系地址 |

---

---

### T_MailBoxAuthority（邮箱权限表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| UserCode | varchar | 用户代码 | 用户编码，登录账号 |
| PasswordSet | varchar | 密码设置 | 密码设置字段 |
| DeleteOperate | varchar | 删除操作权限 | 删除操作权限字段 |

---

### T_SystemActiveUser（系统活跃用户表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| UserCode | varchar | 用户代码 | 用户编码，登录账号 |

---

> **注意**：T_Req 表在数据库中不存在，需求功能请使用 T_Requirement 表（本文件上方已定义）。

---

### T_RelatedReq（关联需求表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ReqID | integer | 需求编号 | 关联T_Requirement表，标识所属需求 |
| ProjectID | integer | 项目编号 | 关联T_Project表，标识所属项目 |

---

### T_ProjectVendor（项目供应商关联表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ProjectID | integer | 项目ID | 关联T_Project表，标识所属项目 |
| VendorCode | varchar | 供应商编码 | 供应商编号 |

---

### T_ReceivePayWay（收付方式表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 方式名称 | 类型分类 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_Bank（银行表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| BankName | varchar | 银行名称 | 开户银行名称 |

---

### T_InvoiceType（发票类型表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 类型名称 | 类型分类 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### T_ProStatusChange（项目状态变更表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ProjectID | integer | 项目ID | 关联T_Project表，标识所属项目 |
| OldStatus | varchar | 原状态 | 原状态字段 |
| NewStatus | varchar | 新状态 | 新状态字段 |
| ChangeTime | timestamp | 变更时间 | 变更时间字段 |
| OperatorCode | varchar | 操作人编码 | 操作人编码 |

---

*文档由 AI Agent 自动生成，基于740张表的数据库结构分析，结合新旧版本所有页面的UI元素和SQL查询语义分析*
*旧版分析补充了：日报表、成员扩展、合同销售/发票/收发货计划、资产使用/入库/归还/维护/调整、借用/销售/生产订单、供应商物资、客户问题、日程事件、排班、考勤规则、登录日志等表*
*Exclude目录分析补充了：DW成本核算、GD管道工程、WPQM焊接工艺、WZ物资管理、学生信息等模块*

---

## 附录：Exclude目录分析补充的表和字段

### TTDW模块 - 产品成本核算与客户价值管理

#### T_DWProductType（产品类型表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| ProductType | varchar | 产品类型 | 如PVC、PE、缠绕膜等 |
| ProductDesc | varchar | 产品描述 | 产品类型说明 |

#### T_DWMatchType（原料类型表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| MatchType | varchar | 原料类型 | 原料分类名称 |
| MatchDesc | varchar | 原料描述 | 原料类型说明 |

#### T_DWMatch（原料表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| MatchName | varchar | 原料名称 | 原料名称字段 |
| MatchType | integer | 原料类型ID | 关联T_DWMatchType |
| MaterialPrice | numeric | 原料价格 | 采购单价 |

#### T_DWProduct（产品表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| ProductCode | varchar | 产品编号 | 收款口径号 |
| ProductName | varchar | 产品名称/牌号 | 产品名称/牌号字段 |
| TypeID | integer | 类型ID | 关联T_DWProductType |

#### T_DWProMatch（产品配方表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| MatchID | integer | 原料ID | 关联T_DWMatch |
| ProductID | integer | 产品ID | 关联T_DWProduct |
| ProductPrice | numeric | 配比用量 | 配方中该原料的用量 |

#### T_DWMakeCost（制造成本表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| MakeType | varchar | 制造类型 | 关联产品类型 |
| Cost | numeric | 制造成本 | 元/吨 |
| TonCost | numeric | 吨耗 | 吨耗系数 |
| YearMonth | varchar | 年月 | 格式YYYYMM |

#### T_DWLineTransport（线路运输费用表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| CustomName | varchar | 客户名称 | 客户名称字段 |
| Amount | numeric | 数量 | 运输数量 |
| Cost | numeric | 费用 | 运输费用 |
| YearMonth | varchar | 年月 | 格式YYYYMM |

#### T_DWQualityCost（质量成本表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| CustomName | varchar | 客户名称 | 客户名称字段 |
| PayMoney | numeric | 配料综合费用 | 质量赔付费用 |
| YearMonth | varchar | 年月 | 格式YYYYMM |
| Workshop | varchar | 车间 | 车间字段 |

#### T_DWCustomImport（客户导入数据表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| SaleTime | date | 日期 | 销售日期 |
| CustomName | varchar | 收款单位 | 客户名称 |
| ProductType | varchar | 产品类型 | 产品类型字段 |
| ProductName | varchar | 产品名称 | 产品名称字段 |
| ProductCode | varchar | 收款口径号 | 收款口径号字段 |
| SaleNumber | numeric | 数量 | 销售数量(千克) |
| SalePrice | numeric | 含税单价 | 含税单价字段 |
| SaleMoney | numeric | 销售额 | 销售额字段 |
| AccountCost | numeric | 财务费用率 | 财务费用率字段 |
| YearMonth | varchar | 年月 | 年月字段 |

#### T_DWCustomValue（客户价值表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| CustomName | varchar | 客户名称 | 客户名称字段 |
| ProductName | varchar | 产品名称 | 产品名称字段 |
| ProductCode | varchar | 收款口径号 | 收款口径号字段 |
| ProductType | varchar | 产品类型 | 产品类型字段 |
| SaleTime | date | 日期 | 日期字段 |
| SaleNumber | numeric | 销售数量 | 销售数量字段 |
| SalePrice | numeric | 含税单价 | 含税单价字段 |
| SaleMoney | numeric | 销售额 | 销售额字段 |
| ProductCost | numeric | 产品成本 | 产品成本字段 |
| MakeCost | numeric | 制造费用分摊 | 制造费用分摊字段 |
| TonCost | numeric | 吨耗 | 吨耗字段 |
| PickCost | numeric | 包装费用 | 包装费用字段 |
| QualityCost | numeric | 质量损失 | 质量损失字段 |
| TransportCost | numeric | 线路运输费 | 线路运输费字段 |
| AccountCost | numeric | 财务费用 | 财务费用字段 |
| ServeCost | numeric | 业务招待费 | 业务招待费字段 |
| TravelCost | numeric | 差旅费 | 差旅费字段 |
| SurplusValue | numeric | 剩余价值 | 核心指标 |
| YearMonth | varchar | 年月 | 年月字段 |

#### T_DWMatchHistory（原料历史价格表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| MatchName | varchar | 原料名称 | 原料名称字段 |
| MatchType | integer | 原料类型ID | 原料类型ID字段 |
| MatchID | integer | 原料ID | 原料ID字段 |
| MaterialPrice | numeric | 原料价格 | 原料价格字段 |
| CreateTime | timestamp | 创建时间 | 创建时间 |
| Remark | text | 备注 | 备注说明 |

---

### TTGD模块 - 管道工程管理

#### T_GDProject（管道项目表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| ProjectCode | varchar | 项目号 | 项目编号，如PJ202606210001 |
| ProjectName | varchar | 项目名称 | 项目名称 |
| ProjectAddress | varchar | 地点 | 地点字段 |
| CreateDate | date | 创建日期 | 记录创建时间 |
| IsMark | integer | 标记 | 标记字段 |
| UserCode | varchar | 用户代码 | 用户编码，登录账号 |

#### T_GDArea（区域表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| Place | varchar | 地点 | 地点字段 |
| MainArea | varchar | 主区域 | 主区域字段 |
| Area | varchar | 区域 | 区域字段 |
| Subcontractor | varchar | 分包商 | 分包商字段 |
| AreaDescription | varchar | 区域描述 | 区域描述字段 |
| TheSystem | varchar | 系统 | 系统字段 |
| UnitCode | varchar | 单位工程编号 | 单位工程编号字段 |
| UnitName | varchar | 单位工程名称 | 单位名称 |
| ProjectCode | varchar | 项目编号 | 项目编号，如PJ202606210001 |

#### T_GDPressure（试压包表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| PressureCode | varchar | 试压包号 | 试压包号字段 |
| OrderNumber | integer | 序列号 | 序列号字段 |
| PublicTime | date | 发布日期 | 发布日期字段 |
| PressureMedium | varchar | 试压介质 | 试压介质字段 |
| PressureTest | varchar | 压力试验 | 压力试验字段 |
| MainArea | varchar | 主区域 | 主区域字段 |
| PointArea | varchar | 分区域 | 分区域字段 |
| PressureUser | varchar | 用途 | 用途字段 |
| SystemCode | varchar | 系统号 | 系统号字段 |
| Medium | varchar | 介质 | 介质字段 |
| PipelineCheck | varchar | 管线检查 | 管线检查字段 |
| HistoryRecord | varchar | 历史记录 | 历史记录字段 |
| PressureTime | date | 试压日期 | 试压日期字段 |
| ProjectCode | varchar | 项目编号 | 项目编号，如PJ202606210001 |

#### T_GDLineWeld（管道焊接线表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| PipelineLevel | varchar | 管道等级 | 管道等级字段 |
| Area | varchar | 区域 | 区域字段 |
| LineNumber | varchar | 管线号 | 管线号字段 |
| OrderNumber | integer | 序号 | 序号字段 |
| LineLevel | varchar | 管线级别 | 管线级别字段 |
| MediumCode | varchar | 介质代号 | 介质代号字段 |
| Isom_no | varchar | 等轴图号 | 等轴图号字段 |
| PipelineRule | varchar | 管道规格 | 管道规格字段 |
| Edition | varchar | 版本 | 版本字段 |
| PublicTime | date | 发布日期 | 发布日期字段 |
| PressurePack1 | varchar | 试压包1 | 试压包1字段 |
| PressureMpa | numeric | 设计压力MPa | 设计压力MPa字段 |
| DesignTemperature | numeric | 设计温度 | 设计温度字段 |
| ProjectCode | varchar | 项目编号 | 项目编号，如PJ202606210001 |

#### T_GDIsomJoint（等轴图接头表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| JointNo | varchar | 焊口号 | 焊口号字段 |
| Rev | varchar | 版本 | 版本字段 |
| Size | varchar | 尺寸 | 尺寸字段 |
| Mold | varchar | 类型 | BW/非BW |
| SF | varchar | 单双面焊 | 单双面焊字段 |
| MediumCode | varchar | 介质代号 | 介质代号字段 |
| Pipefittings | varchar | 管件 | 管件字段 |
| InstallationTime | timestamp | 安装时间 | 安装时间字段 |
| RanderWelder1 | varchar | 打底焊工1 | 打底焊工1字段 |
| RanderWelder2 | varchar | 打底焊工2 | 打底焊工2字段 |
| CoveringWelder1 | varchar | 盖面焊工1 | 盖面焊工1字段 |
| CoveringWelder2 | varchar | 盖面焊工2 | 盖面焊工2字段 |
| WPSNo | varchar | WPS号 | WPS号字段 |
| PressurePackNo | varchar | 试压包号 | 试压包号字段 |
| FRI1 | varchar | 无损检测编号1 | 无损检测编号1字段 |
| FRI2 | varchar | 无损检测编号2 | 无损检测编号2字段 |
| FRI3 | varchar | 无损检测编号3 | 无损检测编号3字段 |
| FRI4 | varchar | 无损检测编号4 | 无损检测编号4字段 |
| FitUp | varchar | 组对 | 组对字段 |
| Visual | varchar | 目视检验 | 目视检验字段 |
| RT | varchar | 射线检测 | 射线检测字段 |
| PT | varchar | 渗透检测 | 渗透检测字段 |
| PWHT | varchar | 焊后热处理 | 焊后热处理字段 |
| PMI | varchar | 材料识别 | 材料识别字段 |
| MT | varchar | 磁粉检测 | 磁粉检测字段 |
| Isom_no | varchar | 等轴图号 | 等轴图号字段 |

#### T_GDWelders（焊工表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Welders | varchar | 焊工号 | 焊工号字段 |
| PublicTime | date | 发布日期 | 发布日期字段 |
| Status | varchar | 状态 | 状态，记录当前处理阶段 |
| WelderName | varchar | 焊工名称 | 焊工名称字段 |
| RequestCode | varchar | 申请号 | 申请号字段 |
| CompanyName | varchar | 公司名称 | 公司名称字段 |
| Qualification | varchar | 资质 | C/S,C/G等 |
| WeldPosition1 | varchar | 焊接位置1 | 焊接位置1字段 |
| WeldPosition2 | varchar | 焊接位置2 | 焊接位置2字段 |

#### T_GDPipingClass（管道等级分类表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| LevelClass | varchar | 等级 | 等级字段 |
| LineLevel | varchar | 管线级别 | 管线级别字段 |
| MediumCode | varchar | 介质代号 | 介质代号字段 |
| SinceNumber | varchar | 编号 | 编号字段 |
| PNo | varchar | P号 | P号字段 |
| RT | varchar | 射线检测 | 射线检测字段 |
| Docking | varchar | 对接 | 对接字段 |
| Branch | varchar | 支管 | 支管字段 |
| Splice | varchar | 拼接 | 拼接字段 |
| HotHandler | varchar | 热处理 | 热处理字段 |
| PMIMaterial | varchar | PMI管材 | PMI管材字段 |
| Material | varchar | 材质 | 材质字段 |
| WeldingMaterial | varchar | 焊接材料 | 焊接材料字段 |

---

### TTWPQM模块 - 焊接工艺评定管理

#### T_WPQMWeldProQua（焊接工艺评定记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| Code | varchar | 评定编号 | 自动生成PE+年月+序号 |
| ApplicableCategories | varchar | 适用类别 | 适用类别字段 |
| MaterialNo | varchar | 母材钢号 | 母材钢号字段 |
| MaterialSpecification | varchar | 母材规格 | 母材规格字段 |
| WeldmentThickness | varchar | 焊件厚度 | 焊件厚度字段 |
| BaseClass | varchar | 母材类别 | 母材类别字段 |
| GroupForm | varchar | 组合形式 | 组合形式字段 |
| WeldMaterialCategory | varchar | 焊材类别 | 焊材类别字段 |
| WeldingMethod | varchar | 焊接方法 | 焊接方法字段 |
| WeldingPosition | varchar | 焊接位置 | 焊接位置字段 |
| PreheatingTemperature | varchar | 预热温度 | 预热温度字段 |
| LayerTemperature | varchar | 层间温度 | 层间温度字段 |
| AfterWeldingTem | varchar | 焊后温度 | 焊后温度字段 |
| WeldingCurrent | varchar | 焊接电流 | 焊接电流字段 |
| WeldingVoltage | varchar | 焊接电压 | 焊接电压字段 |
| WeldingSpeed | varchar | 焊接速度 | 焊接速度字段 |
| LineEnergy | varchar | 线能量 | 线能量字段 |
| ProtectiveGas | varchar | 保护气体 | 保护气体字段 |
| ProGasMixRatio | varchar | 保护气体混合比 | 保护气体混合比字段 |
| ShieldingGasFlowRate | varchar | 保护气流量 | 保护气流量字段 |
| wireTypeBrandSpe | varchar | 焊丝型号-品牌-规格 | 焊丝型号-品牌-规格字段 |
| ElecTypeBrandSpe | varchar | 焊条型号-品牌-规格 | 焊条型号-品牌-规格字段 |
| FluxTypeBrandSpe | varchar | 焊剂型号-品牌-规格 | 焊剂型号-品牌-规格字段 |
| AfterHot | varchar | 焊后热处理方式 | 焊后热处理方式字段 |
| AfterWeldingClass | varchar | 焊后热处理类别 | 焊后热处理类别字段 |
| EvaluationProject | varchar | 评定项目 | 评定项目字段 |
| MechanicalPerReq | varchar | 力学性能要求 | 力学性能要求字段 |
| OtherPerReq | varchar | 其他性能要求 | 其他性能要求字段 |
| NumberSpecimens | integer | 试件数量 | 试件数量字段 |
| EnterCode | varchar | 录入人编号 | 录入人编号字段 |

#### T_WPQMAllData（工艺评定基础数据表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| Code | varchar | 数据编码 | 编码，唯一标识 |
| Type | varchar | 数据类型 | 焊丝型号/焊条型号/焊接方法等 |
| Description | varchar | 数据描述 | 详细描述信息 |
| EnterCode | varchar | 录入人编号 | 录入人编号字段 |

#### T_WPQMWeldingRecord（焊接记录表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| WeldProCode | varchar | 焊接工艺评定编号 | 焊接工艺评定编号字段 |
| MaterialNo | varchar | 母材钢号 | 母材钢号字段 |
| MaterialSpecification | varchar | 母材规格 | 母材规格字段 |
| WeldingMethod | varchar | 焊接方法 | 焊接方法字段 |
| WeldingDirection | varchar | 焊接方向 | 焊接方向字段 |
| HeatingMode | varchar | 加热方式 | 加热方式字段 |
| CategoryGroups | varchar | 类别组号 | 类别组号字段 |
| WeldMaterialCategory | varchar | 焊材类别 | 焊材类别字段 |
| WeldingCurrent | varchar | 焊接电流 | 焊接电流字段 |
| WeldingVoltage | varchar | 焊接电压 | 焊接电压字段 |
| WeldingSpeed | varchar | 焊接速度 | 焊接速度字段 |
| LineEnergy | varchar | 线能量 | 线能量字段 |
| ProtectiveGas | varchar | 保护气体 | 保护气体字段 |
| PreheatingTemperature | varchar | 预热温度 | 预热温度字段 |
| LayerTemperature | varchar | 层间温度 | 层间温度字段 |
| AfterHotTemp | varchar | 焊后热处理温度 | 焊后热处理温度字段 |
| AfterHotTime | varchar | 焊后热处理时间 | 焊后热处理时间字段 |
| EnvironmentTemperature | varchar | 环境温度 | 环境温度字段 |
| RelativeHumidity | varchar | 相对湿度 | 相对湿度字段 |
| EnterCode | varchar | 录入人编号 | 录入人编号字段 |

---

### TTWZ模块 - 物资管理

#### T_WZPurchase（采购文件表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| PurchaseCode | varchar | 采购编号 | 采购编号字段 |
| PurchaseName | varchar | 采购名称 | 采购名称字段 |
| ProjectCode | varchar | 项目编号 | 项目编号，如PJ202606210001 |
| PurchaseEngineer | varchar | 采购工程师 | 采购工程师字段 |
| UpLeader | varchar | 上级领导 | 上级领导字段 |
| PurchaseManager | varchar | 采购经理 | 采购经理字段 |
| DisciplinarySupervision | varchar | 纪检监察 | 纪检监察字段 |
| ControlMoney | varchar | 控制金额人 | 控制金额人字段 |
| TenderCompetent | varchar | 招标负责人 | 招标负责人字段 |
| Decision | varchar | 决策人 | 决策人字段 |
| PlanMoney | numeric | 计划金额 | 计划金额字段 |
| Progress | varchar | 进度 | 录入/提交/审批/评标/报价/核销/合同 |
| IsMark | integer | 标记 | -1启用,0未启用 |
| ExpertCode1 | varchar | 专家编号1 | 专家编号1字段 |
| ExpertCode2 | varchar | 专家编号2 | 专家编号2字段 |
| ExpertCode3 | varchar | 专家编号3 | 专家编号3字段 |
| SupplierCode1 | varchar | 供应商编号1 | 供应商编号1字段 |
| SupplierCode2 | varchar | 供应商编号2 | 供应商编号2字段 |
| SupplierCode3 | varchar | 供应商编号3 | 供应商编号3字段 |
| MarkTime | timestamp | 标记时间 | 标记时间字段 |

#### T_WZPurchaseDetail（采购明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| PurchaseCode | varchar | 采购编号 | 采购编号字段 |
| PlanDetailID | integer | 计划明细ID | 计划明细ID字段 |
| Progress | varchar | 进度 | 进度百分比 |

#### T_WZStock（库存/库房表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| StockCode | varchar | 库房编码 | 库房编码字段 |
| StockDesc | varchar | 库房描述 | 库房描述字段 |
| Safekeep | varchar | 保管员 | 保管员字段 |
| Checker | varchar | 核查员 | 核查员字段 |
| IsMark | integer | 标记 | -1启用 |
| IsCancel | integer | 是否取消 | 是否取消字段 |

#### T_WZSupplier（供应商表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| SupplierCode | varchar | 供应商编码 | 供应商编码字段 |
| SupplierName | varchar | 供应商名称 | 供应商名称字段 |
| Auditor | varchar | 审核人 | 审核人字段 |
| QualityEngineer | varchar | 质量工程师 | 质量工程师字段 |
| PushPerson | varchar | 推送人 | 推送人字段 |
| Progress | varchar | 进度 | 录入/提交 |

#### T_WZExpert（专家表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 序号 | 主键 |
| ExpertCode | varchar | 专家代码 | 专家代码字段 |
| Name | varchar | 姓名 | 名称 |
| WorkUnit | varchar | 工作单位 | 工作单位字段 |
| Job | varchar | 职务 | 职务字段 |
| JobTitle | varchar | 职称 | 职称字段 |
| Phone | varchar | 移动电话 | 联系电话 |
| ExpertType | varchar | 专业范围一 | 专业范围一字段 |
| ExpertType2 | varchar | 专业范围二 | 专业范围二字段 |
| Type | varchar | 专家类型 | 物资/工程/其他招标 |
| WorkingPoint | varchar | 工作地点 | 工作地点字段 |
| ProcurementCategory | varchar | 是否采购专家 | 是否采购专家字段 |
| EngagedCategory | varchar | 从事专家类别 | 从事专家类别字段 |
| LaborExpertise | text | 本职专业特长 | 本职专业特长字段 |
| NotLaborExpertise | text | 非本职专业特长 | 非本职专业特长字段 |
| ActionOutstanding | text | 操作类突出技能 | 操作类突出技能字段 |
| GoodPerformance | text | 优良业绩 | 优良业绩字段 |
| SuccessfulCasePro | text | 成功处理案例 | 成功处理案例字段 |
| LiteratureWorks | text | 论著文献 | 论著文献字段 |
| PatentInvention | text | 发明专利 | 发明专利字段 |
| ScientificAchieve | text | 科研成果 | 科研成果字段 |
| ManagementInnovation | text | 管理创新 | 管理创新字段 |
| BadTrackRecord | text | 不良表现记录 | 不良表现记录字段 |

#### T_WZCompact（合同表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| CompactCode | varchar | 合同编号 | 合同编号字段 |
| Progress | varchar | 进度 | 核销/合同 |

#### T_WZCompactDetail（合同明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| CompactCode | varchar | 合同编号 | 合同编号字段 |
| PurchaseDetailID | integer | 采购明细ID | 采购明细ID字段 |

#### T_WZPickingPlan（领料计划表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| PlanCode | varchar | 计划编号 | 计划编号字段 |
| Progress | varchar | 进度 | 核销/合同 |

#### T_WZPickingPlanDetail（领料计划明细表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| PlanCode | varchar | 计划编号 | 计划编号字段 |
| ID | integer | 明细ID | 主键，自增 |

#### T_WZProject（物资项目表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ProjectCode | varchar | 项目编号 | 项目编号，如PJ202606210001 |
| StoreRoom | varchar | 库房编码 | 库房编码字段 |
| Checker | varchar | 核查员 | 核查员字段 |
| Safekeep | varchar | 保管员 | 保管员字段 |

#### T_WZNeedObject（需求对象表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 编号 | 主键 |
| IsMark | integer | 标记 | 标记字段 |

#### T_BMBidType（招标类型表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| Type | varchar | 招标类型 | 物资/工程/其他招标 |
| SortNumber | integer | 排序号 | 排序号，数字越小越靠前 |

---

### TTUserInfor_Student模块 - 学生信息管理

#### T_ProjectMemberStudent（学生信息表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| UserCode | varchar | 学生编号 | 用户编码，登录账号 |
| UserName | varchar | 学生姓名 | 用户姓名 |
| Gender | varchar | 性别 | 性别字段 |
| BirthDay | date | 出生日期 | 出生日期字段 |
| NativePlace | varchar | 籍贯 | 籍贯 |
| HuKou | varchar | 户口 | 户口字段 |
| ClassID | integer | 班级ID | 关联T_ProjectMemberClass |
| StudentClass | varchar | 学生班级 | 学生班级字段 |
| Residency | varchar | 住址 | 住址字段 |
| UrgencyPerson | varchar | 紧急联系人 | 紧急联系人姓名 |
| UrgencyCall | varchar | 紧急联系电话 | 紧急联系电话 |
| JoinDate | date | 入学日期 | 入职日期 |
| FatherName | varchar | 父亲姓名 | 父亲姓名字段 |
| FatherUnit | varchar | 父亲单位 | 父亲单位字段 |
| FatherPhone | varchar | 父亲电话 | 父亲电话字段 |
| MonthName | varchar | 母亲姓名 | 母亲姓名字段 |
| MonthUnit | varchar | 母亲单位 | 母亲单位字段 |
| MonthPhone | varchar | 母亲电话 | 母亲电话字段 |
| AdmissionDate | date | 入院日期 | 入院日期字段 |
| IsAllergy | integer | 是否过敏 | 0/1 |
| IsAsthma | integer | 是否哮喘 | 0/1 |
| IsInheritedillnesses | integer | 是否遗传病 | 0/1 |
| IsMedicalAllergy | integer | 是否药物过敏 | 0/1 |
| IsForbiddenillness | integer | 是否禁忌症 | 0/1 |
| IsSurgery | integer | 是否手术 | 0/1 |
| IsMajordiseases | integer | 是否重大疾病 | 0/1 |
| OtherRemark | text | 其他备注 | 其他备注字段 |
| WangFeePerSemester | numeric | 每学期网费 | 每学期网费字段 |
| Meals | numeric | 餐费 | 餐费字段 |
| ActivityCost | numeric | 活动费用 | 活动费用字段 |
| CustodyAfterClass | numeric | 课后托管费 | 课后托管费字段 |
| ReplaceCosts | numeric | 代收费 | 代收费字段 |
| PhotoURL | varchar | 照片路径 | 照片文件路径 |
| CreatUserCode | varchar | 创建人编号 | 创建人编号字段 |

#### T_ProjectMemberClass（班级表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 班级ID | 主键 |
| ClassName | varchar | 班级名称 | 班级名称字段 |
| GradeID | integer | 年级ID | 关联T_ProjectMemberGrade |
| UserCode | varchar | 用户编号 | 用户编码，登录账号 |

#### T_ProjectMemberGrade（年级表）

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| ID | integer | 年级ID | 主键 |
| DepartCode | varchar | 部门编号 | 部门编码，关联T_Department表 |

---

### 采购工作流状态机

```
录入 → 提交(PlanMoney>=30万时需选招标负责人) → 审批 → 评标 → 报价 → 核销 → 合同
```

**状态说明：**
- 录入：初始创建状态，可编辑/删除
- 提交：需选择招标负责人（金额>=30万）
- 审批：需已选择供应商和专家
- 评标：评标完成后进入
- 报价：报价完成后进入
- 核销：可取消回录入，需检查合同和领料计划状态
- 合同：终态，生成合同

### allchildplanid

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| childplanid | bigint | YES | YES字段 |
 |
| level | bigint | YES | YES字段 |
 |

### assignment

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('assignment_id_seq'::r |
 |
| task_id | bigint | YES | YES字段 |
 |
| resource_id | bigint | YES | YES字段 |
 |
| units_val | bigint | YES | YES字段 |
 |
| resourceid | bigint | YES | YES字段 |
 |
| unitsval | bigint | YES | YES字段 |
 |

### avbcws

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| numeric | numeric | YES | YES字段 |
 |

### charwltype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| rtrim | text | YES | YES字段 |
 |

### chradminemail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| email | character varying | YES | 电子邮箱 |
 |

### chrmailsend

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| ?column? | text | YES | YES字段 |
 |

### chrpmdepartcode

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| departcode | character | YES | 部门编码，关联T_Department表 |
 |

### departcodelevel

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| parentdepartcode | character | YES | YES字段 |
 |
| level | bigint | YES | YES字段 |
 |

### dependency

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('dependency_id_seq'::r |
 |
| pid | bigint | YES | YES字段 |
 |
| from_id | bigint | NO | NO字段 |
 |
| to_id | bigint | NO | NO字段 |
 |
| type | character varying | NO | 类型分类 |
 |

### dt_begin

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| ?column? | timestamp without time zone | YES | YES字段 |
 |

### parentdepartcodestring

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| rtxcode | character | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| departnamestring | character varying | YES | YES字段 |
 |
| rtxnumber | character | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| mbphonenumber | character varying | YES | YES字段 |
 |

### pbcatcol

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| pbc_tnam | character | YES | YES字段 |
 |
| pbc_tid | bigint | YES | YES字段 |
 |
| pbc_ownr | character | YES | YES字段 |
 |
| pbc_cnam | character | YES | YES字段 |
 |
| pbc_cid | smallint | YES | YES字段 |
 |
| pbc_labl | character varying | YES | YES字段 |
 |
| pbc_lpos | smallint | YES | YES字段 |
 |
| pbc_hdr | character varying | YES | YES字段 |
 |
| pbc_hpos | smallint | YES | YES字段 |
 |
| pbc_jtfy | smallint | YES | YES字段 |
 |
| pbc_mask | character varying | YES | YES字段 |
 |
| pbc_case | smallint | YES | YES字段 |
 |
| pbc_hght | smallint | YES | YES字段 |
 |
| pbc_wdth | smallint | YES | YES字段 |
 |
| pbc_ptrn | character varying | YES | YES字段 |
 |
| pbc_bmap | character | YES | YES字段 |
 |
| pbc_init | character varying | YES | YES字段 |
 |
| pbc_cmnt | character varying | YES | YES字段 |
 |
| pbc_edit | character varying | YES | YES字段 |
 |
| pbc_tag | character varying | YES | YES字段 |
 |

### pbcatedt

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| pbe_name | character varying | NO | NO字段 |
 |
| pbe_edit | character varying | YES | YES字段 |
 |
| pbe_type | smallint | NO | NO字段 |
 |
| pbe_cntr | bigint | YES | YES字段 |
 |
| pbe_seqn | smallint | NO | NO字段 |
 |
| pbe_flag | bigint | YES | YES字段 |
 |
| pbe_work | character | YES | YES字段 |
 |

### pbcatfmt

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| pbf_name | character varying | NO | NO字段 |
 |
| pbf_frmt | character varying | NO | NO字段 |
 |
| pbf_type | character varying | NO | NO字段 |
 |
| pbf_cntr | bigint | YES | YES字段 |
 |

### pbcattbl

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| pbt_tnam | character | YES | YES字段 |
 |
| pbt_tid | bigint | YES | YES字段 |
 |
| pbt_ownr | character | YES | YES字段 |
 |
| pbd_fhgt | smallint | YES | YES字段 |
 |
| pbd_fwgt | smallint | YES | YES字段 |
 |
| pbd_fitl | character | YES | YES字段 |
 |
| pbd_funl | character | YES | YES字段 |
 |
| pbd_fchr | smallint | YES | YES字段 |
 |
| pbd_fptc | smallint | YES | YES字段 |
 |
| pbd_ffce | character | YES | YES字段 |
 |
| pbh_fhgt | smallint | YES | YES字段 |
 |
| pbh_fwgt | smallint | YES | YES字段 |
 |
| pbh_fitl | character | YES | YES字段 |
 |
| pbh_funl | character | YES | YES字段 |
 |
| pbh_fchr | smallint | YES | YES字段 |
 |
| pbh_fptc | smallint | YES | YES字段 |
 |
| pbh_ffce | character | YES | YES字段 |
 |
| pbl_fhgt | smallint | YES | YES字段 |
 |
| pbl_fwgt | smallint | YES | YES字段 |
 |
| pbl_fitl | character | YES | YES字段 |
 |
| pbl_funl | character | YES | YES字段 |
 |
| pbl_fchr | smallint | YES | YES字段 |
 |
| pbl_fptc | smallint | YES | YES字段 |
 |
| pbl_ffce | character | YES | YES字段 |
 |
| pbt_cmnt | character varying | YES | YES字段 |
 |

### pbcatvld

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| pbv_name | character varying | NO | NO字段 |
 |
| pbv_vald | character varying | NO | NO字段 |
 |
| pbv_type | smallint | NO | NO字段 |
 |
| pbv_cntr | bigint | YES | YES字段 |
 |
| pbv_msg | character varying | YES | YES字段 |
 |

### product

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('product_id_seq'::regc |
 |
| name | character varying | YES | 名称 |
 |
| cateory | character varying | YES | YES字段 |
 |
| discontinued | bigint | YES | YES字段 |
 |

### projects

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('projects_id_seq'::reg |
 |
| name | character varying | YES | 名称 |
 |
| content | character varying | YES | 内容详情 |
 |

### resources

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| name | character varying | YES | 名称 |
 |

### sms_accept

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('sms_accept_id_seq'::r |
 |
| mobile | character varying | YES | 手机号码 |
 |
| msg | character varying | YES | YES字段 |
 |
| arrivetime | timestamp without time zone | YES | YES字段 |
 |
| readed | bigint | YES | 0 |
 |

### sms_send

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('sms_send_id_seq'::reg |
 |
| mobile | character varying | YES | 手机号码 |
 |
| msg | character varying | YES | ''::character varying |
 |
| state | bigint | YES | 0 |
 |
| sendyorn | bigint | YES | 0 |
 |
| sendtime | timestamp without time zone | YES | now() |
 |
| commport | character varying | YES | ''::character varying |
 |
| userrtxcode | character varying | YES | ''::character varying |
 |
| rtxstate | bigint | YES | 0 |
 |
| usercode | character | YES | ''::bpchar |
 |

### t_aaprompttranslate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_aaprompttranslate_i |
 |
| prompt | text | YES | YES字段 |
 |
| keyword | character | YES | YES字段 |
 |

### t_accessory

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_accessory_id_seq':: |
 |
| type | character varying | YES | 类型分类 |
 |
| accessory | character varying | YES | YES字段 |
 |
| spec | character varying | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| buytime | timestamp without time zone | YES | YES字段 |
 |
| memo | character varying | YES | YES字段 |
 |

### t_accountingintervalset

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_accountingintervals |
 |
| intervalname | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| starttime | timestamp without time zone | YES | 开始时间 |
 |
| endtime | timestamp without time zone | YES | YES字段 |
 |
| creatercode | character varying | YES | YES字段 |
 |
| intervalcode | character varying | YES | ''::character varying |
 |
| financialcode | character varying | YES | ''::character varying |
 |

### t_actorgroup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_actorgroup_id_seq': |
 |
| groupname | character varying | YES | 分组名称 |
 |
| makeusercode | character | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| identifystring | character varying | YES | YES字段 |
 |
| belongdepartcode | character | YES | ''::bpchar |
 |
| belongdepartname | character varying | YES | ''::character varying |
 |
| langcode | character | YES | 'zh-CN'::bpchar |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| maketype | character varying | YES | ''::bpchar |
 |
| sortnumber | bigint | YES | 0 |
 |

### t_actorgroupdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| groupid | bigint | NO | nextval('t_actorgroupdetail_gr |
 |
| groupname | character | YES | 分组名称 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| actor | character | YES | YES字段 |
 |
| workdetail | character varying | YES | YES字段 |
 |

### t_actorgrouptype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_admin

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| usercode | character | NO | 用户编码，登录账号 |
 |
| password | character varying | YES | YES字段 |
 |

### t_applicationhardware_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_applicationhardware |
 |
| name | character varying | YES | 名称 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_applicationsystem_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_applicationsystem_y |
 |
| name | character varying | YES | 名称 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_approveflow

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_approveflow_id_seq' |
 |
| type | character varying | YES | 类型分类 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| relatedname | character varying | YES | YES字段 |
 |
| stepid | bigint | YES | 0 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| operation | character varying | YES | 操作内容描述 |
 |
| assigntime | timestamp without time zone | YES | now() |
 |
| content | character varying | YES | 内容详情 |
 |
| approvetime | timestamp without time zone | YES | now() |
 |
| receivercode | character | YES | YES字段 |
 |
| priorid | bigint | YES | 0 |
 |
| username | character | YES | 用户姓名 |
 |
| receivername | character | YES | YES字段 |
 |
| routenumber | bigint | YES | 0 |
 |

### t_approveflowbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| type | character varying | YES | 类型分类 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| relatedname | character varying | YES | YES字段 |
 |
| stepid | bigint | YES | 工作流步骤ID |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| operation | character | YES | 操作内容描述 |
 |
| assigntime | timestamp without time zone | YES | YES字段 |
 |
| content | character varying | YES | 内容详情 |
 |
| approvetime | timestamp without time zone | YES | YES字段 |
 |
| receivercode | character | YES | YES字段 |
 |
| priorid | bigint | YES | 前一记录ID，用于链表结构 |
 |
| username | character | YES | 用户姓名 |
 |
| receivername | character | YES | YES字段 |
 |
| routenumber | bigint | YES | 路由序号，用于工作流步骤排序 |
 |

### t_assetapplication

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| aaid | bigint | NO | nextval('t_assetapplication_aa |
 |
| aaname | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| applicantcode | character | YES | 申请人编码 |
 |
| applicantname | character varying | NO | 申请人姓名 |
 |
| applytime | timestamp without time zone | NO | NO字段 |
 |
| finishtime | timestamp without time zone | NO | 完成时间 |
 |
| applyreason | character varying | YES | YES字段 |
 |
| status | character varying | NO | 状态，记录当前处理阶段 |
 |
| relatedtype | character varying | YES | '其它'::bpchar |
 |
| relatedid | bigint | YES | 0 |
 |

### t_assetapplicationdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_assetapplicationdet |
 |
| aaid | bigint | NO | NO字段 |
 |
| assetcode | character | YES | ''::bpchar |
 |
| assetname | character varying | NO | 资产名称 |
 |
| spec | character varying | YES | YES字段 |
 |
| number | numeric | NO | NO字段 |
 |
| unit | character | NO | 计量单位 |
 |
| relatedtype | character varying | YES | '其它'::bpchar |
 |
| relatedid | bigint | YES | 0 |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| manufacturer | character varying | YES | ''::character varying |
 |
| ip | character | YES | ''::bpchar |
 |

### t_assetshipmentdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_assetshipmentdetail |
 |
| shipmentno | bigint | YES | YES字段 |
 |
| assetcode | character | YES | 资产编号 |
 |
| assetname | character | YES | 资产名称 |
 |
| spec | character varying | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| unitname | character | YES | 单位名称 |
 |
| fromposition | character varying | YES | YES字段 |
 |
| fromassetid | bigint | YES | YES字段 |
 |
| toposition | character varying | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| manufacturer | character varying | YES | ''::character varying |
 |

### t_assetshipmentorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| shipmentno | bigint | NO | nextval('t_assetshipmentorder_ |
 |
| shiptime | timestamp without time zone | YES | now() |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| operatorname | character varying | YES | 操作人姓名 |
 |
| applicant | character varying | YES | YES字段 |
 |
| applicationreason | character varying | YES | YES字段 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| warehouse | character varying | YES | ''::character varying |
 |
| sourcetype | character varying | YES | ''::bpchar |
 |
| sourceid | bigint | YES | 0 |
 |

### t_assettype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_backdblog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_backdblog_id_seq':: |
 |
| backtime | timestamp without time zone | YES | YES字段 |
 |
| backdburl | character varying | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| issucc | bigint | YES | YES字段 |
 |

### t_backdbprame

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_backdbprame_id_seq' |
 |
| backdburl | character varying | YES | YES字段 |
 |
| backperiodday | bigint | YES | YES字段 |
 |

### t_backdoclog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_backdoclog_id_seq': |
 |
| backtime | timestamp without time zone | YES | YES字段 |
 |
| backdocurl | character varying | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| issucc | bigint | YES | YES字段 |
 |

### t_backdocprame

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_backdocprame_id_seq |
 |
| backdocurl | character varying | YES | YES字段 |
 |
| backperiodday | bigint | YES | YES字段 |
 |

### t_bartype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |

### t_bdbasedata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bdbasedata_id_seq': |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| accountname | character varying | YES | 会计科目名称 |
 |
| yearnum | bigint | YES | YES字段 |
 |
| monthnum | bigint | YES | YES字段 |
 |
| moneynum | numeric | YES | 0 |
 |
| entercode | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| projectcostid | bigint | YES | 0 |
 |
| accountcode | character varying | YES | ''::character varying |
 |

### t_bdbasedatarecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bdbasedatarecord_id |
 |
| bdbasedataid | bigint | YES | YES字段 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| accountname | character varying | YES | 会计科目名称 |
 |
| yearnum | bigint | YES | YES字段 |
 |
| monthnum | bigint | YES | YES字段 |
 |
| moneynum | numeric | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| operationtype | character varying | YES | YES字段 |
 |
| accountcode | character varying | YES | ''::character varying |
 |

### t_bmannclafile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmannclafile_id_seq |
 |
| type | character varying | YES | 类型分类 |
 |
| bidplanid | bigint | YES | YES字段 |
 |
| bidplanname | character varying | YES | YES字段 |
 |
| sentdate | timestamp without time zone | YES | YES字段 |
 |
| replydate | timestamp without time zone | YES | YES字段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| sendcontent | text | YES | YES字段 |
 |
| replycontent | text | YES | YES字段 |
 |
| enterper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_bmanninvitation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmanninvitation_id_ |
 |
| name | character varying | YES | 名称 |
 |
| enterper | character varying | YES | YES字段 |
 |
| enterunit | character varying | YES | YES字段 |
 |
| enterdate | timestamp without time zone | YES | YES字段 |
 |
| bidway | character varying | YES | YES字段 |
 |
| bidplanid | bigint | YES | YES字段 |
 |
| bidplanname | character varying | YES | YES字段 |
 |
| bidobjects | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |
| phonelist | text | YES | YES字段 |
 |
| phoneremark | text | YES | YES字段 |
 |
| emailremark | text | YES | YES字段 |
 |
| resremark | text | YES | YES字段 |
 |

### t_bmanninvitrelatedproject

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmanninvitrelatedpr |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| bmanninid | bigint | YES | YES字段 |
 |

### t_bmassessbidrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmassessbidrecord_i |
 |
| name | character varying | YES | 名称 |
 |
| budgetprice | numeric | YES | YES字段 |
 |
| reserveprice | numeric | YES | YES字段 |
 |
| assessbidder | character varying | YES | YES字段 |
 |
| assessbiddate | timestamp without time zone | YES | YES字段 |
 |
| bidway | character varying | YES | YES字段 |
 |
| assessbidfactors | character varying | YES | YES字段 |
 |
| assessbidcontent | text | YES | YES字段 |
 |
| openbidrecordid | bigint | YES | YES字段 |
 |
| openbidrecordname | character varying | YES | YES字段 |
 |

### t_bmassessbidreport

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmassessbidreport_i |
 |
| assessbidrecordid | bigint | YES | YES字段 |
 |
| assessbidrecordname | character varying | YES | YES字段 |
 |
| assessspeaker | character varying | YES | YES字段 |
 |
| assessreportdate | timestamp without time zone | YES | YES字段 |
 |
| assessreportcontent | text | YES | YES字段 |
 |
| reviewer | character varying | YES | YES字段 |
 |
| reviewdate | timestamp without time zone | YES | YES字段 |
 |
| reviewresult | text | YES | YES字段 |
 |

### t_bmbidaddendum

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmbidaddendum_id_se |
 |
| bidplanid | bigint | YES | YES字段 |
 |
| bidplanname | character varying | YES | YES字段 |
 |
| addendumer | character varying | YES | YES字段 |
 |
| addendumdate | timestamp without time zone | YES | YES字段 |
 |
| addendumcontent | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_bmbidfile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmbidfile_id_seq':: |
 |
| filename | character varying | YES | 文件名称 |
 |
| filepath | character varying | YES | YES字段 |
 |
| bidplanid | bigint | YES | YES字段 |
 |
| bidplanname | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_bmbidnoticecontent

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmbidnoticecontent_ |
 |
| bidplanid | bigint | YES | YES字段 |
 |
| bidplanname | character varying | YES | YES字段 |
 |
| noticedate | timestamp without time zone | YES | YES字段 |
 |
| bidwincontent | text | YES | YES字段 |
 |
| nobidwincontent | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_bmbidnoticecontentfile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmbidnoticecontentf |
 |
| filename | character varying | YES | 文件名称 |
 |
| filepath | character varying | YES | YES字段 |
 |
| bidnoticecontentid | bigint | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_bmbidplan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmbidplan_id_seq':: |
 |
| name | character varying | YES | 名称 |
 |
| bidtype | character varying | YES | YES字段 |
 |
| bidway | character varying | YES | YES字段 |
 |
| purchaseappid | bigint | YES | YES字段 |
 |
| purchaseappname | character varying | YES | YES字段 |
 |
| enterper | character varying | YES | YES字段 |
 |
| enterdate | timestamp without time zone | YES | YES字段 |
 |
| bidstartdate | timestamp without time zone | YES | YES字段 |
 |
| bidenddate | timestamp without time zone | YES | YES字段 |
 |
| bidaddress | character varying | YES | YES字段 |
 |
| enterdepart | character varying | YES | YES字段 |
 |
| bidremark | text | YES | YES字段 |
 |
| usercodelist | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| purchaseappcode | character varying | YES | YES字段 |
 |
| addusercodelist | character varying | YES | YES字段 |
 |
| suppliertype | character varying | YES | ''::character varying |
 |
| enginerringsupplier | character varying | YES | 'NO'::character varying |
 |
| internationsupplier | character varying | YES | 'NO'::character varying |
 |
| retailsupplier | character varying | YES | 'NO'::character varying |
 |
| storesupplier | character | YES | 'NO'::bpchar |
 |
| suppliertype1 | character varying | YES | ''::character varying |
 |
| bidlimitedprice | numeric | YES | 0 |
 |

### t_bmbidtemplatefile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmbidtemplatefile_i |
 |
| filename | character varying | YES | 文件名称 |
 |
| filepath | character varying | YES | YES字段 |
 |
| bidplanid | bigint | YES | YES字段 |
 |
| bidplanname | character varying | YES | YES字段 |
 |
| suppliertype | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_bmbidtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_bmcontractdiscuss

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmcontractdiscuss_i |
 |
| name | character varying | YES | 名称 |
 |
| discussfilename | character varying | YES | YES字段 |
 |
| discussfilepath | character varying | YES | YES字段 |
 |
| pointsummary | text | YES | YES字段 |
 |
| enterper | character varying | YES | YES字段 |
 |
| enterdate | timestamp without time zone | YES | YES字段 |
 |
| enterunit | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| suppliername | character varying | YES | YES字段 |
 |
| contractprice | numeric | YES | YES字段 |
 |
| reviewer | character varying | YES | YES字段 |
 |
| reviewdate | timestamp without time zone | YES | YES字段 |
 |
| reviewresult | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| constractid | bigint | YES | 0 |
 |

### t_bmcontractpreparation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmcontractpreparati |
 |
| name | character varying | YES | 名称 |
 |
| partya | character varying | YES | YES字段 |
 |
| partyaname | character varying | YES | YES字段 |
 |
| partyb | character varying | YES | YES字段 |
 |
| partybname | character varying | YES | YES字段 |
 |
| signdate | timestamp without time zone | YES | YES字段 |
 |
| effectivedate | timestamp without time zone | YES | YES字段 |
 |
| contractdiscussid | bigint | YES | YES字段 |
 |
| contractdiscussname | character varying | YES | YES字段 |
 |
| relatedconstractcode | character varying | YES | ''::character varying |
 |
| relatedconstractname | character varying | YES | ''::character varying |
 |

### t_bmopenbidrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmopenbidrecord_id_ |
 |
| name | character varying | YES | 名称 |
 |
| bidplanid | bigint | YES | YES字段 |
 |
| bidplanname | character varying | YES | YES字段 |
 |
| openbidder | character varying | YES | YES字段 |
 |
| openbiddate | timestamp without time zone | YES | YES字段 |
 |
| openbidremark | text | YES | YES字段 |
 |

### t_bmperformanceevaluation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmperformanceevalua |
 |
| bidplanid | bigint | YES | YES字段 |
 |
| bidplanname | character varying | YES | YES字段 |
 |
| expertid | bigint | YES | YES字段 |
 |
| cooperatedegree | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_bmpurchaseapplication

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmpurchaseapplicati |
 |
| code | character varying | YES | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| application | character varying | YES | YES字段 |
 |
| applicationdate | timestamp without time zone | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |
| departname | character varying | YES | 部门名称 |
 |
| engineeringaddress | character varying | YES | ''::character varying |
 |
| engineeringnumber | numeric | YES | 0 |
 |
| engineeringunitname | character | YES | ''::bpchar |
 |
| planstarttime | timestamp without time zone | YES | now() |
 |
| totalduration | numeric | YES | 0 |
 |
| devicenumber | numeric | YES | 0 |
 |
| deviceunitname | character | YES | YES字段 |
 |
| sitecondition | character varying | YES | ''::character varying |
 |
| manhour | numeric | YES | 0 |
 |
| othercomment | character varying | YES | ''::character varying |
 |
| expectedamount | numeric | YES | 0 |
 |
| actualmanhour | numeric | YES | 0 |
 |
| unitprice | numeric | YES | 0 |
 |
| actualamount | numeric | YES | 0 |
 |
| status | character varying | YES | '计划'::bpchar |
 |
| suppliercode | character varying | YES | ''::character varying |
 |
| suppliername | character varying | YES | ''::character varying |
 |
| projectid | bigint | YES | 1 |
 |
| outcontractpayamount | numeric | YES | 0 |
 |
| deductedamount | numeric | YES | 0 |
 |
| totalpayamount | numeric | YES | 0 |
 |
| accountcode | character varying | YES | ''::character varying |
 |
| accountname | character varying | YES | ''::character varying |
 |
| currencytype | character varying | YES | ''::character varying |
 |
| comment | character varying | YES | ''::character varying |
 |

### t_bmsupbidbyexp

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupbidbyexp_id_se |
 |
| supplierbidid | bigint | YES | YES字段 |
 |
| biddingcontent | text | YES | YES字段 |
 |
| exportresult | text | YES | YES字段 |
 |
| exportcode | character varying | YES | YES字段 |
 |

### t_bmsupplieranaly

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupplieranaly_id_ |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| point | numeric | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| creatercode | character varying | YES | YES字段 |
 |
| creatername | character varying | YES | YES字段 |
 |
| evaluateproject | character varying | YES | YES字段 |
 |
| starttime | timestamp without time zone | YES | 开始时间 |
 |
| endtime | timestamp without time zone | YES | YES字段 |
 |
| basepoint | numeric | YES | YES字段 |
 |

### t_bmsupplierbid

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupplierbid_id_se |
 |
| anninvitationid | bigint | YES | YES字段 |
 |
| anninvitationname | character varying | YES | YES字段 |
 |
| suppliercode | bigint | YES | YES字段 |
 |
| biddingcontent | text | YES | YES字段 |
 |
| bidstatus | character varying | YES | 'W'::character varying |
 |
| noticecontent | text | YES | YES字段 |
 |
| biddingdate | timestamp without time zone | YES | YES字段 |
 |
| exportresult | text | YES | YES字段 |
 |

### t_bmsupplierbidrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupplierbidrecord |
 |
| supplierbidid | bigint | YES | YES字段 |
 |
| anninvitationid | bigint | YES | YES字段 |
 |
| suppliercode | bigint | YES | YES字段 |
 |
| biddingcontent | text | YES | YES字段 |
 |
| operationtype | character varying | YES | YES字段 |
 |
| operationdate | timestamp without time zone | YES | YES字段 |
 |

### t_bmsupplierbidrecordfile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupplierbidrecord |
 |
| filename | character varying | YES | 文件名称 |
 |
| filepath | character varying | YES | YES字段 |
 |
| supplierbidrecordid | bigint | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_bmsupplierbigtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_bmsuppliercertification

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsuppliercertifica |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| certificatenum | character varying | YES | YES字段 |
 |
| certificatename | character varying | YES | YES字段 |
 |
| licenseagency | character varying | YES | YES字段 |
 |
| releasetime | timestamp without time zone | YES | YES字段 |
 |
| attach | character varying | YES | YES字段 |
 |

### t_bmsupplierinfo

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupplierinfo_id_s |
 |
| code | character varying | YES | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| password | character varying | YES | YES字段 |
 |
| companyfor | character varying | YES | YES字段 |
 |
| companytype | character varying | YES | YES字段 |
 |
| address | character varying | YES | 联系地址 |
 |
| phonenum | character varying | YES | YES字段 |
 |
| zipcode | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| fax | character varying | YES | 传真号码 |
 |
| weburl | character varying | YES | YES字段 |
 |
| supplyscope | text | YES | YES字段 |
 |
| bank | character varying | YES | YES字段 |
 |
| bankno | character varying | YES | YES字段 |
 |
| einno | character varying | YES | YES字段 |
 |
| qualification | text | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| reviewer | character varying | YES | YES字段 |
 |
| reviewdate | timestamp without time zone | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| enterper | character varying | YES | YES字段 |
 |
| enterdate | timestamp without time zone | YES | YES字段 |
 |
| point | numeric | YES | YES字段 |
 |
| subcontractprofessional | text | YES | YES字段 |
 |
| legalrepresentative | character varying | YES | ''::character varying |
 |
| technicaltitles | character varying | YES | ''::character varying |
 |
| legaltel | character varying | YES | ''::character varying |
 |
| technicaldirector | character varying | YES | ''::character varying |
 |
| technicaltitles_t | character varying | YES | ''::character varying |
 |
| technicaltel | character varying | YES | ''::character varying |
 |
| setuptime | timestamp without time zone | YES | to_timestamp('2014-02-24'::tex |
 |
| employeesnum | bigint | YES | 0 |
 |
| qualificationcertificate | character varying | YES | ''::character varying |
 |
| businesslicense | character varying | YES | ''::character varying |
 |
| registeredcapital | numeric | YES | 0 |
 |
| pmnumber | bigint | YES | 0 |
 |
| stnumber | bigint | YES | 0 |
 |
| itnumber | bigint | YES | 0 |
 |
| ptnumber | bigint | YES | 0 |
 |
| mnumber | bigint | YES | 0 |
 |
| recommendedunits | character varying | YES | ''::character varying |
 |
| lastfinalistsnumber | character varying | YES | ''::character varying |
 |
| island | character varying | YES | ''::character varying |
 |
| accessoriespath | character varying | YES | ''::character varying |
 |
| enginerringsupplier | character varying | YES | 'No'::character varying |
 |
| internationsupplier | character varying | YES | 'No'::character varying |
 |
| retailsupplier | character varying | YES | 'No'::character varying |
 |
| supplierbigtype | character varying | YES | ''::bpchar |
 |
| suppliersmalltype | character varying | YES | YES字段 |
 |
| ... | ... | ... | ... |

### t_bmsupplierinfohistory

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupplierinfohisto |
 |
| code | character varying | YES | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| password | character varying | YES | YES字段 |
 |
| companyfor | character varying | YES | YES字段 |
 |
| companytype | character varying | YES | YES字段 |
 |
| address | character varying | YES | 联系地址 |
 |
| phonenum | character varying | YES | YES字段 |
 |
| zipcode | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| fax | character varying | YES | 传真号码 |
 |
| weburl | character varying | YES | YES字段 |
 |
| supplyscope | text | YES | YES字段 |
 |
| bank | character varying | YES | YES字段 |
 |
| bankno | character varying | YES | YES字段 |
 |
| einno | character varying | YES | YES字段 |
 |
| qualification | text | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| reviewer | character varying | YES | YES字段 |
 |
| reviewdate | timestamp without time zone | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| enterper | character varying | YES | YES字段 |
 |
| enterdate | timestamp without time zone | YES | YES字段 |
 |
| point | numeric | YES | YES字段 |
 |
| subcontractprofessional | text | YES | YES字段 |
 |
| legalrepresentative | character varying | YES | ''::character varying |
 |
| technicaltitles | character varying | YES | ''::character varying |
 |
| legaltel | character varying | YES | ''::character varying |
 |
| technicaldirector | character varying | YES | ''::character varying |
 |
| technicaltitles_t | character varying | YES | ''::character varying |
 |
| technicaltel | character varying | YES | ''::character varying |
 |
| setuptime | timestamp without time zone | YES | YES字段 |
 |
| employeesnum | bigint | YES | 0 |
 |
| qualificationcertificate | character varying | YES | ''::character varying |
 |
| businesslicense | character varying | YES | ''::character varying |
 |
| registeredcapital | numeric | YES | 0 |
 |
| pmnumber | bigint | YES | 0 |
 |
| stnumber | bigint | YES | 0 |
 |
| itnumber | bigint | YES | 0 |
 |
| ptnumber | bigint | YES | 0 |
 |
| mnumber | bigint | YES | 0 |
 |
| recommendedunits | character varying | YES | ''::character varying |
 |
| lastfinalistsnumber | character varying | YES | ''::character varying |
 |
| island | character varying | YES | ''::character varying |
 |
| accessoriespath | character varying | YES | ''::character varying |
 |

### t_bmsupplierlink

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupplierlink_id_s |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| name | character varying | YES | 名称 |
 |
| gender | character | YES | YES字段 |
 |
| position | character varying | YES | YES字段 |
 |
| mobilenum | character varying | YES | YES字段 |
 |
| officephone | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| code | character varying | YES | 编码，唯一标识 |
 |

### t_bmsupplierreply

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bmsupplierreply_id_ |
 |
| annclafileid | bigint | YES | YES字段 |
 |
| sendcontent | text | YES | YES字段 |
 |
| replydate | timestamp without time zone | YES | YES字段 |
 |
| supplierid | bigint | YES | YES字段 |
 |

### t_bmsuppliersmalltype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| bigtype | character varying | NO | NO字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_bookborrowrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bookborrowrecord_id |
 |
| bookinfoid | bigint | YES | YES字段 |
 |
| barcode | character varying | YES | YES字段 |
 |
| bookname | character varying | YES | YES字段 |
 |
| referenceno | character varying | YES | YES字段 |
 |
| bookclassificationid | bigint | YES | YES字段 |
 |
| bookclassificationname | character varying | YES | YES字段 |
 |
| bookpublishersid | bigint | YES | YES字段 |
 |
| bookpublishersname | character varying | YES | YES字段 |
 |
| bookusenum | bigint | YES | YES字段 |
 |
| version | character varying | YES | 版本号 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| borrowcode | character | YES | YES字段 |
 |
| borrowname | character varying | YES | YES字段 |
 |
| borrowdate | timestamp without time zone | YES | YES字段 |
 |
| backdate | timestamp without time zone | YES | YES字段 |
 |
| readertypeid | character varying | YES | YES字段 |
 |
| readertypename | character varying | YES | YES字段 |
 |
| certificateid | bigint | YES | YES字段 |
 |
| certificatename | character varying | YES | YES字段 |
 |
| certificateno | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| realbackdate | timestamp without time zone | YES | YES字段 |
 |
| bookrent | numeric | YES | 0 |
 |

### t_bookcertificate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bookcertificate_id_ |
 |
| certificatename | character varying | YES | YES字段 |
 |
| sortno | bigint | YES | YES字段 |
 |

### t_bookclassification

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bookclassification_ |
 |
| classificationtype | character varying | YES | YES字段 |
 |
| classificationcode | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| datatype | character varying | YES | YES字段 |
 |

### t_bookinformation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bookinformation_id_ |
 |
| barcode | character varying | YES | YES字段 |
 |
| bookname | character varying | YES | YES字段 |
 |
| referenceno | character varying | YES | YES字段 |
 |
| bookclassificationid | bigint | YES | YES字段 |
 |
| bookclassificationname | character varying | YES | YES字段 |
 |
| location | character varying | YES | YES字段 |
 |
| bookpublishersid | bigint | YES | YES字段 |
 |
| bookpublishersname | character varying | YES | YES字段 |
 |
| author | character varying | YES | YES字段 |
 |
| translator | character varying | YES | YES字段 |
 |
| booknum | bigint | YES | YES字段 |
 |
| bookusenum | bigint | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| publicationdate | timestamp without time zone | YES | YES字段 |
 |
| pagenum | bigint | YES | YES字段 |
 |
| version | character varying | YES | 版本号 |
 |
| usenum | bigint | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| source | character varying | YES | YES字段 |
 |
| donors | character varying | YES | YES字段 |
 |
| introduction | character varying | YES | YES字段 |
 |
| bookimage | character varying | YES | YES字段 |
 |
| createcode | character | YES | YES字段 |
 |
| createname | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| classificationcode | character varying | YES | YES字段 |
 |
| booktype | character varying | YES | YES字段 |
 |

### t_bookpublishers

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bookpublishers_id_s |
 |
| isbnno | character varying | YES | YES字段 |
 |
| publishersname | character varying | YES | YES字段 |
 |
| publishersaddress | character varying | YES | YES字段 |
 |

### t_bookreadertype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_bookreadertype_id_s |
 |
| typename | character varying | YES | YES字段 |
 |
| borrowdays | bigint | YES | 0 |
 |
| borrownum | bigint | YES | 0 |
 |

### t_businessformreandpay

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| formcode | character | NO | NO字段 |
 |
| formname | character varying | YES | ''::character varying |
 |
| receiveorpay | character | YES | 'NONE'::bpchar |
 |
| relatedaccount | character varying | YES | ''::character varying |
 |
| relatedaccountcode | character varying | YES | ''::character varying |
 |

### t_camerainfo

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_camerainfo_id_seq': |
 |
| cameratype | character varying | YES | YES字段 |
 |
| foreignid | character varying | YES | YES字段 |
 |
| cameraname | character varying | YES | YES字段 |
 |
| serverip | character varying | YES | YES字段 |
 |
| camerausername | character varying | YES | YES字段 |
 |
| camerapass | character varying | YES | YES字段 |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| description | text | YES | 详细描述信息 |
 |

### t_cameralist

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_cameralist_id_seq': |
 |
| area | character varying | YES | YES字段 |
 |
| projectdepartment | character varying | YES | YES字段 |
 |
| serverip | character varying | YES | YES字段 |
 |
| serverport | character varying | YES | YES字段 |
 |
| serverchannel | character varying | YES | YES字段 |
 |
| cameraname | character varying | YES | YES字段 |
 |
| camerausername | character varying | YES | YES字段 |
 |
| camerapass | character varying | YES | YES字段 |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| description | text | YES | 详细描述信息 |
 |

### t_cameralog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_cameralog_id_seq':: |
 |
| cameraid | bigint | YES | YES字段 |
 |
| cameraname | character varying | YES | YES字段 |
 |
| serverip | character varying | YES | YES字段 |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| description | text | YES | 详细描述信息 |
 |

### t_carapplyform

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_carapplyform_id_seq |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| departname | character varying | NO | 部门名称 |
 |
| applicantcode | character | NO | 申请人编码 |
 |
| applicantname | character | NO | 申请人姓名 |
 |
| applyreason | character varying | YES | YES字段 |
 |
| departtime | timestamp without time zone | YES | now() |
 |
| backtime | timestamp without time zone | YES | now() |
 |
| attendant | character varying | YES | YES字段 |
 |
| boardingsite | character varying | YES | YES字段 |
 |
| destination | character varying | YES | YES字段 |
 |
| cartype | character varying | NO | NO字段 |
 |
| status | character varying | NO | 状态，记录当前处理阶段 |
 |
| makeusercode | character | YES | YES字段 |
 |
| maketime | timestamp without time zone | YES | now() |
 |

### t_carassignform

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_carassignform_id_se |
 |
| applyformid | bigint | NO | NO字段 |
 |
| carcode | character | NO | NO字段 |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| departname | character varying | NO | 部门名称 |
 |
| applicantcode | character | NO | 申请人编码 |
 |
| applicantname | character | NO | 申请人姓名 |
 |
| attendant | character varying | YES | YES字段 |
 |
| boardingsite | character varying | YES | YES字段 |
 |
| destination | character varying | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |
| mileage | numeric | YES | 0 |
 |
| departtime | timestamp without time zone | YES | now() |
 |
| backtime | timestamp without time zone | YES | now() |
 |
| makeusercode | character | NO | NO字段 |
 |
| maketime | timestamp without time zone | YES | now() |
 |
| parkingcharge | numeric | YES | 0 |
 |
| drivercode | character | YES | ''::bpchar |
 |
| drivername | character | YES | ''::bpchar |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| roadtoll | numeric | YES | 0 |
 |
| realdeparttime | timestamp without time zone | YES | now() |
 |
| realbacktime | timestamp without time zone | YES | now() |
 |
| guardcode | character | YES | ''::bpchar |
 |
| guardname | character | YES | ''::bpchar |
 |
| oilvolume | numeric | YES | 0 |
 |
| oilcharge | numeric | YES | 0 |
 |
| currentmileage | numeric | YES | 0 |
 |

### t_carcheckweek

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| weekcode | character varying | NO | NO字段 |
 |
| weekname | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| createtime | timestamp without time zone | YES | now() |
 |
| customercode | character varying | YES | 客户编号 |
 |
| customername | character varying | YES | 客户名称 |
 |
| ext1 | character varying | YES | YES字段 |
 |
| ext2 | character varying | YES | YES字段 |
 |
| ext3 | character varying | YES | YES字段 |
 |
| ext4 | character varying | YES | YES字段 |
 |
| ext5 | character varying | YES | YES字段 |
 |

### t_carinformation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| carcode | character | NO | NO字段 |
 |
| carname | character | NO | NO字段 |
 |
| carbrand | character varying | NO | NO字段 |
 |
| cartype | character varying | NO | NO字段 |
 |
| carcolor | character | NO | NO字段 |
 |
| dwt | numeric | YES | 0 |
 |
| seatnumber | bigint | YES | 0 |
 |
| fuelconsumption | numeric | YES | 0 |
 |
| initialmileage | numeric | YES | 0 |
 |
| enginecode | character | YES | YES字段 |
 |
| framecode | character | YES | YES字段 |
 |
| vendor | character varying | YES | YES字段 |
 |
| price | numeric | YES | 0 |
 |
| purchasetime | timestamp without time zone | YES | now() |
 |
| belongdepartcode | character | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| belongdepartname | character varying | YES | ''::character varying |
 |

### t_caroiltyperecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_caroiltyperecord_id |
 |
| carno | character varying | YES | YES字段 |
 |
| oiltypeid | character varying | YES | YES字段 |
 |
| oilname | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| oilnum | numeric | YES | YES字段 |
 |
| oilprice | numeric | YES | YES字段 |
 |
| oilmoney | numeric | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |

### t_cartype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_changetype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_coderule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_coderule_id_seq'::r |
 |
| codetype | character varying | NO | NO字段 |
 |
| headchar | character | NO | NO字段 |
 |
| fieldname | character | YES | YES字段 |
 |
| flowidwidth | bigint | YES | YES字段 |
 |
| isstartup | character | YES | YES字段 |
 |

### t_collaboration

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| coid | bigint | NO | nextval('t_collaboration_coid_ |
 |
| collaborationname | character varying | NO | NO字段 |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | NO | NO字段 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |
| comment | text | YES | 备注说明 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| relatedtype | character varying | YES | ''::bpchar |
 |
| relatedid | bigint | YES | 0 |
 |
| identifystring | character varying | YES | ''::character varying |
 |
| relatedcode | character | YES | ''::bpchar |
 |

### t_collaborationbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| coid | bigint | NO | nextval('t_collaborationbackup |
 |
| collaborationname | character varying | NO | NO字段 |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | NO | NO字段 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |
| comment | text | YES | 备注说明 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| identifystring | character varying | YES | YES字段 |
 |
| relatedcode | character | YES | YES字段 |
 |

### t_collaborationlog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| logid | bigint | NO | nextval('t_collaborationlog_lo |
 |
| coid | bigint | NO | NO字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | NO | 用户姓名 |
 |
| logcontent | text | YES | YES字段 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |

### t_collaborationlogbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| logid | bigint | NO | nextval('t_collaborationlogbac |
 |
| coid | bigint | NO | NO字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | NO | 用户姓名 |
 |
| logcontent | text | YES | YES字段 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |

### t_collaborationlogwithcustomerquestioncandidate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| logid | bigint | NO | nextval('t_collaborationlogwit |
 |
| questionid | bigint | NO | NO字段 |
 |
| username | character | NO | 用户姓名 |
 |
| logcontent | text | YES | YES字段 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |

### t_collaborationmember

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| memid | bigint | NO | nextval('t_collaborationmember |
 |
| coid | bigint | NO | NO字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | NO | 用户姓名 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |
| lastlogintime | timestamp without time zone | YES | YES字段 |
 |

### t_collaborationmemberbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| memid | bigint | NO | nextval('t_collaborationmember |
 |
| coid | bigint | NO | NO字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | NO | 用户姓名 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |
| lastlogintime | timestamp without time zone | YES | YES字段 |
 |

### t_commonworkflowrelatedpage

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_commonworkflowrelat |
 |
| formname | character varying | YES | ''::character varying |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| pagename | character varying | YES | 页面名称 |
 |
| langcode | character | YES | 语言代码，如zh-CN/en-US |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_constractbigtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| bigtype | character varying | NO | NO字段 |
 |
| sortnumber | bigint | NO | 排序号，数字越小越靠前 |
 |

### t_constractchangerecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractchangereco |
 |
| constractcode | character varying | YES | ''::character varying |
 |
| changecontent | text | YES | ''::text |
 |
| afterchangeamount | numeric | YES | 0 |
 |
| changetime | timestamp without time zone | YES | now() |
 |
| operatorcode | character | YES | ''::bpchar |
 |
| operatorname | character | YES | ''::bpchar |
 |
| changetype | character varying | YES | ''::bpchar |
 |

### t_constractgoodsdeliveryrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractgoodsdeliv |
 |
| deliveryplanid | bigint | NO | NO字段 |
 |
| goodscode | character | NO | 物品编码 |
 |
| goodsname | character varying | NO | 物品名称 |
 |
| spec | character varying | NO | NO字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 0 |
 |
| price | numeric | YES | 0 |
 |
| amount | numeric | YES | 0 |
 |
| deliverytime | timestamp without time zone | YES | now() |
 |
| deliveryaddress | character varying | YES | YES字段 |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_constractgoodsreceiptrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractgoodsrecei |
 |
| receiptplanid | bigint | NO | NO字段 |
 |
| goodscode | character | NO | 物品编码 |
 |
| goodsname | character varying | NO | 物品名称 |
 |
| spec | character varying | NO | NO字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| number | numeric | YES | 0 |
 |
| unit | character | YES | 计量单位 |
 |
| price | numeric | YES | 0 |
 |
| amount | numeric | YES | 0 |
 |
| receipttime | timestamp without time zone | YES | now() |
 |
| receiptaddress | character varying | YES | YES字段 |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_constractpartc

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| partcid | integer | NO | nextval('t_constractpartc_part |
 |
| constractid | bigint | NO | 关联T_Constract表，标识所属合同 |
 |
| partcname | character varying | YES | YES字段 |
 |
| contactname | character varying | YES | YES字段 |
 |
| contactway | character varying | YES | YES字段 |
 |

### t_constractpayablevisa

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractpayablevis |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| constractpayableid | bigint | YES | 0 |
 |
| visaname | character varying | YES | YES字段 |
 |
| visasignman | character varying | YES | YES字段 |
 |
| visaamount | numeric | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| visasigntime | timestamp without time zone | YES | now() |
 |
| currencytype | character varying | YES | ''::bpchar |
 |
| operatorcode | character | YES | ''::bpchar |
 |
| operatorname | character | YES | ''::bpchar |
 |
| relatedimpact | character varying | YES | ''::character varying |
 |
| relatedresult | character varying | YES | ''::character varying |
 |

### t_constractpayablevisadetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractpayablevis |
 |
| visaid | bigint | YES | YES字段 |
 |
| visadetailname | character varying | YES | YES字段 |
 |
| unitname | character | YES | 单位名称 |
 |
| visanumber | numeric | YES | 0 |
 |
| visaamount | numeric | YES | 0 |
 |
| comment | character varying | YES | 备注说明 |
 |
| visaprice | numeric | YES | 0 |
 |

### t_constractradio

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| radio | character varying | NO | NO字段 |
 |

### t_constractrelatedassetpurchaseorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractrelatedass |
 |
| poid | bigint | NO | NO字段 |
 |
| constractcode | character varying | YES | 合同编号 |
 |

### t_constractrelatedconstract

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractrelatedcon |
 |
| constractcode | character varying | YES | 合同编号 |
 |
| relatedconstractcode | character varying | YES | YES字段 |
 |

### t_constractrelatedentryorderforinner

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractrelatedent |
 |
| amount | numeric | YES | 金额 |
 |
| entrytax | numeric | YES | YES字段 |
 |
| addedvaluetax | numeric | YES | YES字段 |
 |
| constractcode | character varying | YES | 合同编号 |
 |
| currency | character varying | YES | 币种 |
 |
| exchangerate | numeric | YES | 汇率 |
 |

### t_constractrelatedgoodspurchaseorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractrelatedgoo |
 |
| poid | bigint | NO | NO字段 |
 |
| constractcode | character varying | YES | 合同编号 |
 |

### t_constractrelatedgoodssaleorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractrelatedgoo |
 |
| soid | bigint | NO | NO字段 |
 |
| constractcode | character varying | YES | 合同编号 |
 |

### t_constractrelatedproject

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_constractrelatedpro |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| constractcode | character varying | YES | 合同编号 |
 |

### t_constracttype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | NO | 排序号，数字越小越靠前 |
 |
| keyword | character | YES | ''::bpchar |
 |

### t_contactinfor

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_contactinfor_id_seq |
 |
| firstname | character | YES | YES字段 |
 |
| lastname | character | YES | YES字段 |
 |
| gender | character | YES | YES字段 |
 |
| age | bigint | YES | YES字段 |
 |
| officephone | character | YES | YES字段 |
 |
| homephone | character | YES | YES字段 |
 |
| mobilephone | character | YES | YES字段 |
 |
| email1 | character | YES | YES字段 |
 |
| email2 | character | YES | YES字段 |
 |
| website | character | YES | YES字段 |
 |
| msn | character | YES | YES字段 |
 |
| qq | character | YES | YES字段 |
 |
| ysn | character | YES | YES字段 |
 |
| company | character | YES | YES字段 |
 |
| department | character | YES | YES字段 |
 |
| duty | character | YES | YES字段 |
 |
| companyaddress | character varying | YES | YES字段 |
 |
| postcode | character | YES | YES字段 |
 |
| country | character | YES | YES字段 |
 |
| state | character | YES | YES字段 |
 |
| city | character | YES | YES字段 |
 |
| homeaddress | character varying | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| type | character varying | YES | 类型分类 |
 |
| relatedtype | character varying | YES | '其它'::bpchar |
 |
| relatedid | character | YES | 关联业务ID |
 |

### t_contractbasisdocument

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| docid | bigint | NO | nextval('t_document_docid_seq' |
 |
| constractcode | character varying | YES | 合同编号 |
 |
| doctype | character varying | YES | YES字段 |
 |
| docname | character varying | YES | YES字段 |
 |
| address | character varying | YES | 联系地址 |
 |
| uploadmancode | character | YES | YES字段 |
 |
| uploadmanname | character | YES | YES字段 |
 |
| uploadtime | timestamp without time zone | YES | YES字段 |
 |

### t_countryarea

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| citycode | character | NO | NO字段 |
 |
| namename | character | YES | YES字段 |
 |
| citylevel | bigint | YES | YES字段 |
 |

### t_customercontactrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_customercontactreco |
 |
| type | character varying | YES | 类型分类 |
 |
| comment | character varying | YES | 备注说明 |
 |
| contactperson | character | YES | YES字段 |
 |
| gender | character | YES | YES字段 |
 |
| officephone | character | YES | YES字段 |
 |
| homephone | character | YES | YES字段 |
 |
| mobilephone | character | YES | YES字段 |
 |
| email1 | character | YES | YES字段 |
 |
| msn | character | YES | YES字段 |
 |
| qq | character | YES | YES字段 |
 |
| company | character | YES | YES字段 |
 |
| department | character | YES | YES字段 |
 |
| duty | character | YES | YES字段 |
 |
| companyaddress | character varying | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| nextcontacttime | timestamp without time zone | NO | NO字段 |
 |

### t_customeroperationrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_customeroperationre |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| creater | character varying | YES | YES字段 |
 |
| creatername | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| remark | text | YES | 备注说明 |
 |

### t_customerquestioncustomerstage

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| stage | character varying | NO | NO字段 |
 |
| sortnumber | bigint | YES | 0 |
 |

### t_customerquestionhandlerecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_customerquestionhan |
 |
| questionid | bigint | NO | NO字段 |
 |
| handledetail | character varying | NO | NO字段 |
 |
| handlestatus | character varying | NO | NO字段 |
 |
| handleway | character varying | YES | YES字段 |
 |
| handletime | timestamp without time zone | NO | NO字段 |
 |
| usedtime | bigint | NO | 0 |
 |
| timeunit | character | NO | NO字段 |
 |
| customercomment | character varying | NO | NO字段 |
 |
| customeracceptor | character | NO | NO字段 |
 |
| acceptorcontactway | character varying | NO | NO字段 |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| operatorname | character | NO | 操作人姓名 |
 |
| predays | bigint | YES | 0 |
 |
| nextservicetime | timestamp without time zone | YES | now() |
 |
| updoordate | timestamp without time zone | YES | now() |
 |
| tobank | character varying | YES | YES字段 |
 |
| sumapplytime | timestamp without time zone | YES | now() |
 |
| dealsituation | character varying | YES | YES字段 |
 |
| newtime | timestamp without time zone | YES | now() |
 |
| newnum | character varying | YES | YES字段 |
 |
| signing | character varying | YES | YES字段 |
 |
| lending | character varying | YES | YES字段 |
 |
| collectiontime | timestamp without time zone | YES | now() |
 |
| collectionper | character varying | YES | YES字段 |
 |
| rebates | character varying | YES | YES字段 |
 |
| rebatestime | timestamp without time zone | YES | now() |
 |

### t_customerquestionrelatedcandidate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_customerquestionrel |
 |
| questionid | bigint | YES | YES字段 |
 |
| username | character varying | NO | 用户姓名 |
 |

### t_customerquestionstage

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| stage | character varying | NO | NO字段 |
 |
| possibility | bigint | YES | 0 |
 |

### t_customerquestiontype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_customerrelatedgoods

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_customerrelatedgood |
 |
| customercode | character | NO | 客户编号 |
 |
| goodssn | character varying | NO | 物料序列号，唯一标识 |
 |

### t_customerrelatedgoodsinfor

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_customerrelatedgood |
 |
| customercode | character varying | YES | 客户编号 |
 |
| type | character varying | YES | 类型分类 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character varying | YES | 物品名称 |
 |
| spec | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| price | numeric | YES | 单价 |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_customerrelatedquestion

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_customerrelatedques |
 |
| customercode | character | YES | 客户编号 |
 |
| questionid | bigint | YES | YES字段 |
 |

### t_customerrelatedtask

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_customerrelatedtask |
 |
| customercode | character | NO | 客户编号 |
 |
| taskid | bigint | NO | 关联T_ProjectTask表，标识所属任务 |
 |

### t_custommodule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_custommodule_id_seq |
 |
| custommodulename | character varying | NO | NO字段 |
 |
| customtype | character varying | NO | NO字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| temname | character varying | NO | NO字段 |
 |
| identifystring | character varying | NO | NO字段 |
 |

### t_dailyworkunitbonus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dailyworkunitbonus_ |
 |
| everycharprice | numeric | YES | 0 |
 |
| everydocprice | numeric | YES | 0 |
 |
| charupper | bigint | YES | 0 |
 |
| docupper | bigint | YES | 0 |
 |

### t_database_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_database_yyup_id_se |
 |
| name | character varying | YES | 名称 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_databasehardware_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_databasehardware_yy |
 |
| name | character varying | YES | 名称 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_databasesystem_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_databasesystem_yyup |
 |
| name | character varying | YES | 名称 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_dayhournum

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dayhournum_id_seq': |
 |
| hournum | numeric | YES | YES字段 |
 |
| starttime | character varying | YES | '08:30'::character varying |
 |
| endtime | character varying | YES | '18:30'::character varying |
 |
| reststarttime | character varying | YES | '12:00'::character varying |
 |
| restendtime | character varying | YES | '14:00'::character varying |
 |

### t_defectstatus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_defectstatus_id_seq |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| langcode | character | YES | 语言代码，如zh-CN/en-US |
 |
| maketype | character varying | YES | YES字段 |
 |

### t_defecttype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_departassetrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departassetrelatedu |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| usercode | character | YES | ''::bpchar |
 |
| username | character varying | YES | ''::character varying |
 |
| effectdate | timestamp without time zone | YES | now() |
 |

### t_departmentmsgpush

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| msgid | bigint | NO | nextval('t_departmentmsgpush_m |
 |
| message | character varying | YES | ''::character varying |
 |
| departstring | text | YES | ''::text |
 |
| pushtime | timestamp without time zone | YES | YES字段 |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_departmentmsgrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departmentmsgrelate |
 |
| msgid | bigint | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |

### t_departnewsnoticerelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departnewsnoticerel |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| usercode | character | YES | ''::bpchar |
 |
| username | character varying | YES | ''::character varying |
 |
| effectdate | timestamp without time zone | YES | now() |
 |

### t_departposition

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departposition_id_s |
 |
| departcode | character | YES | ''::bpchar |
 |
| position | character varying | YES | ''::character varying |
 |
| sortnumber | bigint | YES | 1 |
 |

### t_departpositionkpitemplate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departpositionkpite |
 |
| departcode | character | YES | ''::bpchar |
 |
| position | character varying | YES | ''::character varying |
 |
| sortnumber | bigint | YES | 0 |
 |
| kpi | character varying | YES | ''::character varying |
 |
| kpitype | character varying | YES | ''::bpchar |
 |
| definition | character varying | YES | ''::character varying |
 |
| kpifunction | character varying | YES | ''::character varying |
 |
| formula | character varying | YES | ''::character varying |
 |
| source | character varying | YES | ''::character varying |
 |
| weight | numeric | YES | 0 |
 |

### t_departrelatedmodule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departrelatedmodule |
 |
| modulename | character | NO | 模块名称 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |
| visible | character | YES | YES字段 |
 |
| moduletype | character varying | YES | 'SYSTEM'::bpchar |
 |
| usertype | character varying | YES | ''::bpchar |
 |

### t_departrelatedproductline

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departrelatedproduc |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| productlinename | character | YES | YES字段 |
 |

### t_departrelatedprojectleader

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departrelatedprojec |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| effectdate | timestamp without time zone | YES | 生效日期 |
 |

### t_departrelatedsuperuser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departrelatedsuperu |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| usercode | character | YES | ''::bpchar |
 |
| username | character varying | YES | ''::character varying |
 |
| effectdate | timestamp without time zone | YES | now() |
 |
| productlinerelated | character | YES | 'NO'::bpchar |
 |

### t_departrelatedwzcheckuser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departrelatedwzchec |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| effectdate | timestamp without time zone | YES | 生效日期 |
 |

### t_departrelatedwzdelegateuser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departrelatedwzdele |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| effectdate | timestamp without time zone | YES | 生效日期 |
 |

### t_departrelatedwzfeeuser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departrelatedwzfeeu |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| effectdate | timestamp without time zone | YES | 生效日期 |
 |

### t_departsuperuserrelatedproductline

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departsuperuserrela |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| usercode | character | NO | 用户编码，登录账号 |
 |
| productlinename | character | YES | YES字段 |
 |

### t_departuserinforrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_departuserinforrela |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| usercode | character | YES | ''::bpchar |
 |
| username | character varying | YES | ''::character varying |
 |
| effectdate | timestamp without time zone | YES | now() |
 |

### t_devicenotificationinfo

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_devicenotificationi |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| devicetype | character varying | YES | YES字段 |
 |
| devicetoken | character | YES | YES字段 |
 |

### t_dingtalkconfig

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | integer | NO | nextval('t_dingtalkconfig_id_s |
 |
| configname | character varying | NO | NO字段 |
 |
| appkey | character varying | NO | NO字段 |
 |
| appsecret | character varying | NO | NO字段 |
 |
| agentid | character varying | YES | YES字段 |
 |
| corpid | character varying | YES | YES字段 |
 |
| robotcode | character varying | YES | YES字段 |
 |
| apptype | integer | NO | 1 |
 |
| isenabled | boolean | NO | true |
 |
| description | character varying | YES | 详细描述信息 |
 |
| createtime | timestamp without time zone | NO | CURRENT_TIMESTAMP |
 |
| updatetime | timestamp without time zone | NO | CURRENT_TIMESTAMP |
 |

### t_dlrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dlrecord_id_seq'::r |
 |
| username | character | YES | 用户姓名 |
 |
| dltime | timestamp without time zone | YES | YES字段 |
 |
| docname | character varying | YES | YES字段 |
 |

### t_docmodulerelated

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_docmodulerelated_id |
 |
| productline | character varying | YES | YES字段 |
 |
| subordinateindustry | character varying | YES | YES字段 |
 |
| moduleids | character varying | YES | YES字段 |
 |
| modulenames | character varying | YES | YES字段 |
 |
| startamount | numeric | YES | 0 |
 |
| endamount | numeric | YES | 0 |
 |
| startpersonday | bigint | YES | 0 |
 |
| endpersonday | bigint | YES | 0 |
 |
| docid | bigint | YES | YES字段 |
 |

### t_docplanrelated_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_docplanrelated_yyup |
 |
| planid | bigint | YES | 关联T_Plan表，标识所属计划 |
 |
| docid | bigint | YES | YES字段 |
 |

### t_docrelateddepartment

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_docrelateddepartmen |
 |
| docid | bigint | YES | 0 |
 |
| departcode | character | YES | ''::bpchar |
 |
| departname | character varying | YES | ''::character varying |
 |

### t_docrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_docrelateduser_id_s |
 |
| docid | bigint | YES | 0 |
 |
| usercode | character | YES | ''::bpchar |
 |
| username | character varying | YES | ''::character varying |
 |

### t_doctamplaterelated

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_doctamplaterelated_ |
 |
| docid | bigint | YES | YES字段 |
 |
| tamplatename | character varying | YES | YES字段 |
 |
| tamplateurl | character varying | YES | YES字段 |
 |

### t_doctoolsrelated

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_doctoolsrelated_id_ |
 |
| docid | bigint | YES | YES字段 |
 |
| toolsname | character varying | YES | YES字段 |
 |
| toolsurl | character varying | YES | YES字段 |
 |

### t_doctoolsrelated_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_doctoolsrelated_yyu |
 |
| toolsid | bigint | YES | YES字段 |
 |
| docid | bigint | YES | YES字段 |
 |

### t_doctype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_doctype_id_seq'::re |
 |
| type | character varying | YES | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| parentid | bigint | YES | 父级记录ID，用于构建层级结构 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| savetype | character varying | YES | YES字段 |
 |

### t_doctypetoolsrelated_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_doctypetoolsrelated |
 |
| toolsid | bigint | YES | YES字段 |
 |
| doctypeid | character varying | YES | YES字段 |
 |
| doctype | character varying | YES | YES字段 |
 |

### t_documentforprojectplantemplate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| docid | bigint | NO | nextval('t_documentforprojectp |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| doctypeid | character varying | YES | YES字段 |
 |
| doctype | character varying | YES | YES字段 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| docname | character varying | YES | YES字段 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| address | character varying | YES | 联系地址 |
 |
| author | character varying | YES | YES字段 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | ''::character varying |
 |
| uploadmancode | character | YES | YES字段 |
 |
| uploadmanname | character | YES | YES字段 |
 |
| uploadtime | timestamp without time zone | YES | YES字段 |
 |
| visible | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| relatedname | character varying | YES | ''::character varying |
 |

### t_dwcustomimport

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwcustomimport_id_s |
 |
| customname | character varying | YES | YES字段 |
 |
| productname | character varying | YES | YES字段 |
 |
| productcode | character varying | YES | YES字段 |
 |
| producttype | character varying | YES | YES字段 |
 |
| saletime | timestamp without time zone | YES | YES字段 |
 |
| salenumber | numeric | YES | YES字段 |
 |
| saleprice | numeric | YES | YES字段 |
 |
| salemoney | numeric | YES | YES字段 |
 |
| productcost | numeric | YES | YES字段 |
 |
| makecost | numeric | YES | YES字段 |
 |
| toncost | numeric | YES | YES字段 |
 |
| pickcost | numeric | YES | YES字段 |
 |
| qualitycost | numeric | YES | YES字段 |
 |
| transportcost | numeric | YES | YES字段 |
 |
| accountcost | numeric | YES | YES字段 |
 |
| servecost | numeric | YES | YES字段 |
 |
| travelcost | numeric | YES | YES字段 |
 |
| applyer | character varying | YES | YES字段 |
 |
| salesmanwages | numeric | YES | YES字段 |
 |
| surplusvalue | numeric | YES | YES字段 |
 |
| yearmonth | character varying | YES | YES字段 |
 |

### t_dwcustomvalue

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwcustomvalue_id_se |
 |
| customname | character varying | YES | YES字段 |
 |
| productname | character varying | YES | YES字段 |
 |
| productcode | character varying | YES | YES字段 |
 |
| producttype | character varying | YES | YES字段 |
 |
| saletime | timestamp without time zone | YES | YES字段 |
 |
| salenumber | numeric | YES | YES字段 |
 |
| saleprice | numeric | YES | YES字段 |
 |
| salemoney | numeric | YES | YES字段 |
 |
| productcost | numeric | YES | YES字段 |
 |
| makecost | numeric | YES | YES字段 |
 |
| toncost | numeric | YES | YES字段 |
 |
| pickcost | numeric | YES | YES字段 |
 |
| qualitycost | numeric | YES | YES字段 |
 |
| transportcost | numeric | YES | YES字段 |
 |
| accountcost | numeric | YES | YES字段 |
 |
| servecost | numeric | YES | YES字段 |
 |
| travelcost | numeric | YES | YES字段 |
 |
| applyer | character varying | YES | YES字段 |
 |
| salesmanwages | numeric | YES | YES字段 |
 |
| surplusvalue | numeric | YES | YES字段 |
 |
| yearmonth | character varying | YES | YES字段 |
 |

### t_dwlinetransport

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwlinetransport_id_ |
 |
| customname | character varying | YES | YES字段 |
 |
| amount | numeric | YES | 金额 |
 |
| cost | numeric | YES | 成本 |
 |
| yearmonth | character varying | YES | YES字段 |
 |

### t_dwmakecost

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwmakecost_id_seq': |
 |
| maketype | character varying | YES | YES字段 |
 |
| cost | numeric | YES | 成本 |
 |
| toncost | numeric | YES | YES字段 |
 |
| yearmonth | character varying | YES | YES字段 |
 |

### t_dwmatch

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwmatch_id_seq'::re |
 |
| matchname | character varying | YES | YES字段 |
 |
| materialprice | numeric | YES | YES字段 |
 |
| matchtype | character varying | YES | YES字段 |
 |

### t_dwmatchhistory

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwmatchhistory_id_s |
 |
| matchname | character varying | YES | YES字段 |
 |
| matchtype | character varying | YES | YES字段 |
 |
| matchid | bigint | YES | YES字段 |
 |
| materialprice | numeric | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_dwmatchhistorytime

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwmatchhistorytime_ |
 |
| historyyear | character varying | YES | YES字段 |
 |
| historymonth | character varying | YES | YES字段 |
 |

### t_dwmatchtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwmatchtype_id_seq' |
 |
| matchtype | character varying | YES | YES字段 |
 |
| matchdesc | character varying | YES | YES字段 |
 |

### t_dwproduct

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwproduct_id_seq':: |
 |
| productname | character varying | YES | YES字段 |
 |
| typeid | character varying | YES | YES字段 |
 |
| productcode | character varying | YES | YES字段 |
 |

### t_dwproducttype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwproducttype_id_se |
 |
| producttype | character varying | YES | YES字段 |
 |
| productdesc | character varying | YES | YES字段 |
 |

### t_dwpromatch

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwpromatch_id_seq': |
 |
| productid | bigint | YES | YES字段 |
 |
| matchid | bigint | YES | YES字段 |
 |
| productprice | numeric | YES | YES字段 |
 |

### t_dwqualitycost

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwqualitycost_id_se |
 |
| customname | character varying | YES | YES字段 |
 |
| paymoney | numeric | YES | YES字段 |
 |
| yearmonth | character varying | YES | YES字段 |
 |
| workshop | character varying | YES | YES字段 |
 |

### t_dwtravelexpenses

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwtravelexpenses_id |
 |
| tianbiaoriqi | timestamp without time zone | YES | YES字段 |
 |
| chuchairenxingming | character varying | YES | YES字段 |
 |
| chuchairiqi | timestamp without time zone | YES | YES字段 |
 |
| guilairiqi | timestamp without time zone | YES | YES字段 |
 |
| suoshubumen | character varying | YES | YES字段 |
 |
| chuchaikehu | character varying | YES | YES字段 |
 |
| zhiliangsunshi | character varying | YES | YES字段 |
 |
| chuchaibeizhu | character varying | YES | YES字段 |
 |
| heji1 | numeric | YES | YES字段 |
 |
| heji2 | numeric | YES | YES字段 |
 |
| zongbaoxiaofeiyong | numeric | YES | YES字段 |
 |
| liuchengzhuangtai | character varying | YES | YES字段 |
 |
| workflowwlname | bigint | NO | NO字段 |
 |

### t_dwtravelexpenseschild1

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_dwtravelexpenseschi |
 |
| leibie1 | character varying | YES | YES字段 |
 |
| mingxi1 | character varying | YES | YES字段 |
 |
| feiyong1 | numeric | YES | YES字段 |
 |
| mainid | bigint | NO | NO字段 |
 |

### t_educationexperience

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_educationexperience |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| starttime | timestamp without time zone | NO | 开始时间 |
 |
| endtime | timestamp without time zone | NO | NO字段 |
 |
| school | character varying | NO | NO字段 |
 |
| major | character varying | NO | 专业 |
 |
| certificate | character varying | NO | NO字段 |
 |

### t_eventlog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| logindex | bigint | NO | nextval('t_eventlog_logindex_s |
 |
| commport | smallint | YES | YES字段 |
 |
| description | character varying | NO | 详细描述信息 |
 |
| happentime | timestamp without time zone | NO | NO字段 |
 |

### t_excelformdata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_excelformdata_id_se |
 |
| formtype | character varying | NO | NO字段 |
 |
| formcode | character varying | NO | NO字段 |
 |
| formname | character varying | NO | NO字段 |
 |
| rowcode | character varying | NO | NO字段 |
 |
| fieldname | character varying | NO | NO字段 |
 |
| fieldvalue | text | NO | NO字段 |
 |
| operatorcode | character varying | NO | 操作人编码 |
 |
| operatorname | character varying | NO | 操作人姓名 |
 |
| operatetime | timestamp without time zone | YES | now() |
 |

### t_expenseapplywl

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_expenseapplywl_id_s |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 0 |
 |
| expensename | character varying | YES | YES字段 |
 |
| purpose | character varying | YES | YES字段 |
 |
| amount | numeric | YES | 金额 |
 |
| paybacktime | timestamp without time zone | YES | YES字段 |
 |
| applicantcode | character | YES | 申请人编码 |
 |
| applicantname | character | YES | 申请人姓名 |
 |
| applytime | timestamp without time zone | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| currencytype | character varying | YES | ''::character varying |
 |
| accountcode | character varying | YES | ''::character varying |
 |
| account | character varying | YES | 会计科目 |
 |
| workflowwlname | character varying | YES | YES字段 |
 |

### t_expenseclaim

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| ecid | bigint | NO | nextval('t_expenseclaim_ecid_s |
 |
| expensename | character varying | YES | YES字段 |
 |
| purpose | character varying | YES | YES字段 |
 |
| amount | numeric | YES | 金额 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |
| applicantcode | character | YES | 申请人编码 |
 |
| applicantname | character | YES | 申请人姓名 |
 |
| applytime | timestamp without time zone | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| workflowwlname | character varying | YES | YES字段 |
 |
| id | bigint | YES | 主键，自增 |
 |

### t_expenseclaimdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_expenseclaimdetail_ |
 |
| ecid | bigint | YES | YES字段 |
 |
| accountcode | character varying | YES | 会计科目编码 |
 |
| account | character varying | YES | 会计科目 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| amount | numeric | YES | 金额 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| registerdate | timestamp without time zone | YES | YES字段 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| relatedexpenseid | bigint | YES | YES字段 |
 |

### t_familymember

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_familymember_id_seq |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| membername | character varying | NO | NO字段 |
 |
| relation | character varying | NO | NO字段 |
 |
| workaddress | character varying | NO | NO字段 |
 |
| duty | character varying | YES | YES字段 |
 |
| postcode | character | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |

### t_festivalsdayset

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_festivalsdayset_id_ |
 |
| festivalsyear | bigint | YES | YES字段 |
 |
| festivalsname | character varying | YES | YES字段 |
 |
| festivalsdate | timestamp without time zone | YES | YES字段 |
 |

### t_festivalsexchangedayset

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_festivalsexchangeda |
 |
| festivalsyear | bigint | YES | YES字段 |
 |
| festivalsname | character varying | YES | YES字段 |
 |
| exchangedate | timestamp without time zone | YES | YES字段 |
 |

### t_festivalstype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_fundingsource

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| fundingsource | character | NO | NO字段 |
 |

### t_gdapplication

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdapplication_id_se |
 |
| lineuser | character varying | YES | YES字段 |
 |
| instructions | character varying | YES | YES字段 |
 |
| thesystem | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdarea

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdarea_id_seq'::reg |
 |
| place | character varying | YES | YES字段 |
 |
| mainarea | character varying | YES | YES字段 |
 |
| area | character varying | YES | YES字段 |
 |
| subcontractor | character varying | YES | YES字段 |
 |
| areadescription | character varying | YES | YES字段 |
 |
| thesystem | character varying | YES | YES字段 |
 |
| unitcode | character varying | YES | YES字段 |
 |
| unitname | character varying | YES | 单位名称 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdfri

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdfri_id_seq'::regc |
 |
| area | character varying | YES | YES字段 |
 |
| codename | character varying | YES | YES字段 |
 |
| fricode | character varying | YES | YES字段 |
 |
| edition | character varying | YES | YES字段 |
 |
| publictime | character varying | YES | YES字段 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| remarks | character varying | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| ismark | bigint | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdhothandler

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdhothandler_id_seq |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| isom_no | character varying | YES | YES字段 |
 |
| joint | character varying | YES | YES字段 |
 |
| thk | character varying | YES | YES字段 |
 |
| fluid | character varying | YES | YES字段 |
 |
| size | character varying | YES | YES字段 |
 |
| hottype | character varying | YES | YES字段 |
 |
| hotroot | character varying | YES | YES字段 |
 |
| cover | character varying | YES | YES字段 |
 |
| coverdate | character varying | YES | YES字段 |
 |
| pwhtreport | character varying | YES | YES字段 |
 |
| pwhtdate | character varying | YES | YES字段 |
 |
| grd | character varying | YES | YES字段 |
 |
| rt | character varying | YES | YES字段 |
 |
| reportno | character varying | YES | YES字段 |
 |
| reportdate | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdisomfri

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdisomfri_id_seq':: |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| isom_no | character varying | YES | YES字段 |
 |
| fri1 | character varying | YES | YES字段 |
 |
| fri2 | character varying | YES | YES字段 |
 |
| fri3 | character varying | YES | YES字段 |
 |
| fri4 | character varying | YES | YES字段 |
 |
| fri5 | character varying | YES | YES字段 |
 |
| fri6 | character varying | YES | YES字段 |
 |
| fri7 | character varying | YES | YES字段 |
 |
| fri8 | character varying | YES | YES字段 |
 |
| fri9 | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdisomjoint

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdisomjoint_id_seq' |
 |
| jointno | character varying | YES | YES字段 |
 |
| rev | character varying | YES | YES字段 |
 |
| size | character varying | YES | YES字段 |
 |
| mold | character varying | YES | YES字段 |
 |
| sf | character varying | YES | YES字段 |
 |
| mediumcode | character varying | YES | YES字段 |
 |
| pipefittings | character varying | YES | YES字段 |
 |
| installationtime | character varying | YES | YES字段 |
 |
| randerwelder1 | character varying | YES | YES字段 |
 |
| randerweldername1 | character varying | YES | YES字段 |
 |
| randerwelder2 | character varying | YES | YES字段 |
 |
| randerweldername2 | character varying | YES | YES字段 |
 |
| randertime | character varying | YES | YES字段 |
 |
| coveringwelder1 | character varying | YES | YES字段 |
 |
| coveringweldername1 | character varying | YES | YES字段 |
 |
| coveringwelder2 | character varying | YES | YES字段 |
 |
| coveringweldername2 | character varying | YES | YES字段 |
 |
| coveringtime | character varying | YES | YES字段 |
 |
| wpsno | character varying | YES | YES字段 |
 |
| pressurepackno | character varying | YES | YES字段 |
 |
| fri1 | character varying | YES | YES字段 |
 |
| fri2 | character varying | YES | YES字段 |
 |
| fri3 | character varying | YES | YES字段 |
 |
| fri4 | character varying | YES | YES字段 |
 |
| fituptime | character varying | YES | YES字段 |
 |
| fitup | character varying | YES | YES字段 |
 |
| visualtime | character varying | YES | YES字段 |
 |
| visual | character varying | YES | YES字段 |
 |
| rttime | character varying | YES | YES字段 |
 |
| rt | character varying | YES | YES字段 |
 |
| pttime | character varying | YES | YES字段 |
 |
| pt | character varying | YES | YES字段 |
 |
| pwhttime | character varying | YES | YES字段 |
 |
| pwht | character varying | YES | YES字段 |
 |
| pmitime | character varying | YES | YES字段 |
 |
| pmi | character varying | YES | YES字段 |
 |
| mttime | character varying | YES | YES字段 |
 |
| mt | character varying | YES | YES字段 |
 |
| historysheet | character varying | YES | YES字段 |
 |
| presstest | character varying | YES | YES字段 |
 |
| rtlotdetailsrt1 | character varying | YES | YES字段 |
 |
| rtlotdetailsrt2 | character varying | YES | YES字段 |
 |
| rtlotdetailsrt3 | character varying | YES | YES字段 |
 |
| rtlotdetailsrt4 | character varying | YES | YES字段 |
 |
| isom_no | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdjointrevision

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdjointrevision_id_ |
 |
| code | character varying | YES | 编码，唯一标识 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdlineweld

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdlineweld_id_seq': |
 |
| pipelinelevel | character varying | YES | YES字段 |
 |
| area | character varying | YES | YES字段 |
 |
| linenumber | character varying | YES | YES字段 |
 |
| ordernumber | character varying | YES | YES字段 |
 |
| linelevel | character varying | YES | YES字段 |
 |
| mediumcode | character varying | YES | YES字段 |
 |
| isom_no | character varying | YES | YES字段 |
 |
| pipelinerule | character varying | YES | YES字段 |
 |
| edition | character varying | YES | YES字段 |
 |
| publictime | character varying | YES | YES字段 |
 |
| pressurepack1 | character varying | YES | YES字段 |
 |
| pressurempa | character varying | YES | YES字段 |
 |
| designtemperature | character varying | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdnotdestroy

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdnotdestroy_id_seq |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| isom_no | character varying | YES | YES字段 |
 |
| weldcode | character varying | YES | YES字段 |
 |
| weldstatus | character varying | YES | YES字段 |
 |
| size | character varying | YES | YES字段 |
 |
| mold | character varying | YES | YES字段 |
 |
| sf | character varying | YES | YES字段 |
 |
| medium | character varying | YES | YES字段 |
 |
| randerwelder1 | character varying | YES | YES字段 |
 |
| randerweldername1 | character varying | YES | YES字段 |
 |
| randerwelder2 | character varying | YES | YES字段 |
 |
| randerweldername2 | character varying | YES | YES字段 |
 |
| randertime | character varying | YES | YES字段 |
 |
| coveringwelder1 | character varying | YES | YES字段 |
 |
| coveringweldername1 | character varying | YES | YES字段 |
 |
| coveringwelder2 | character varying | YES | YES字段 |
 |
| coveringweldername2 | character varying | YES | YES字段 |
 |
| coveringtime | character varying | YES | YES字段 |
 |
| returnwelder | character varying | YES | YES字段 |
 |
| returnweldername | character varying | YES | YES字段 |
 |
| returntime | character varying | YES | YES字段 |
 |
| pressurepackno | character varying | YES | YES字段 |
 |
| fri1 | character varying | YES | YES字段 |
 |
| fri2 | character varying | YES | YES字段 |
 |
| fri3 | character varying | YES | YES字段 |
 |
| fri4 | character varying | YES | YES字段 |
 |
| packagetime | character varying | YES | YES字段 |
 |
| package | character varying | YES | YES字段 |
 |
| outsidetime | character varying | YES | YES字段 |
 |
| outside | character varying | YES | YES字段 |
 |
| rttime | character varying | YES | YES字段 |
 |
| rt | character varying | YES | YES字段 |
 |
| pttime | character varying | YES | YES字段 |
 |
| pt | character varying | YES | YES字段 |
 |
| pwhttime | character varying | YES | YES字段 |
 |
| pwht | character varying | YES | YES字段 |
 |
| pmitime | character varying | YES | YES字段 |
 |
| pmi | character varying | YES | YES字段 |
 |
| mttime | character varying | YES | YES字段 |
 |
| mt | character varying | YES | YES字段 |
 |
| orificetime | character varying | YES | YES字段 |
 |
| orifice | character varying | YES | YES字段 |
 |
| airpresstime | character varying | YES | YES字段 |
 |
| airpress | character varying | YES | YES字段 |
 |
| tieintime | character varying | YES | YES字段 |
 |
| tiein | character varying | YES | YES字段 |
 |
| rtdetail1 | character varying | YES | YES字段 |
 |
| rtdetail2 | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| ... | ... | ... | ... |

### t_gdordercode

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdordercode_id_seq' |
 |
| code | character varying | YES | 编码，唯一标识 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| remark | character varying | YES | 备注说明 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdpipeline

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| pipegrade | character varying | NO | NO字段 |
 |
| hg_grade | character varying | YES | YES字段 |
 |

### t_gdpipingclass

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdpipingclass_id_se |
 |
| levelclass | character varying | YES | YES字段 |
 |
| linelevel | character varying | YES | YES字段 |
 |
| mediumcode | character varying | YES | YES字段 |
 |
| sincenumber | character varying | YES | YES字段 |
 |
| pno | character varying | YES | YES字段 |
 |
| rt | character varying | YES | YES字段 |
 |
| docking | character varying | YES | YES字段 |
 |
| branch | character varying | YES | YES字段 |
 |
| splice | character varying | YES | YES字段 |
 |
| attached | character varying | YES | YES字段 |
 |
| hothandler | character varying | YES | YES字段 |
 |
| pmimaterial | character varying | YES | YES字段 |
 |
| material | character varying | YES | YES字段 |
 |
| weldingmaterial | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdpressure

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| pressurecode | character varying | NO | NO字段 |
 |
| ordernumber | character varying | YES | YES字段 |
 |
| publictime | character varying | YES | YES字段 |
 |
| pressuremedium | character varying | YES | YES字段 |
 |
| pressuretest | character varying | YES | YES字段 |
 |
| mainarea | character varying | YES | YES字段 |
 |
| pointarea | character varying | YES | YES字段 |
 |
| pressureuser | character varying | YES | YES字段 |
 |
| systemcode | character varying | YES | YES字段 |
 |
| medium | character varying | YES | YES字段 |
 |
| pipelinecheck | character varying | YES | YES字段 |
 |
| historyrecord | character varying | YES | YES字段 |
 |
| pressuretime | character varying | YES | YES字段 |
 |
| remarks | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |

### t_gdpressureobject

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdpressureobject_id |
 |
| pressureobject | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdpressuretest

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdpressuretest_id_s |
 |
| testloopno | character varying | YES | YES字段 |
 |
| presstestrec | character varying | YES | YES字段 |
 |
| pressdate | character varying | YES | YES字段 |
 |
| reinstrec | character varying | YES | YES字段 |
 |
| reinstdate | character varying | YES | YES字段 |
 |
| flushingblock | character varying | YES | YES字段 |
 |
| flushingrec | character varying | YES | YES字段 |
 |
| flushingdate | character varying | YES | YES字段 |
 |
| leaktestrec | character varying | YES | YES字段 |
 |
| leakdate | character varying | YES | YES字段 |
 |
| remarks | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdproject

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdproject_id_seq':: |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| projectaddress | character varying | YES | YES字段 |
 |
| createdate | timestamp without time zone | YES | 记录创建时间 |
 |
| remark | character varying | YES | 备注说明 |
 |
| imageurl | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdrtdelegate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdrtdelegate_id_seq |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| isom_no | character varying | YES | YES字段 |
 |
| lotcount | character varying | YES | YES字段 |
 |
| cover | character varying | YES | YES字段 |
 |
| jtno | character varying | YES | YES字段 |
 |
| size | character varying | YES | YES字段 |
 |
| fluid | character varying | YES | YES字段 |
 |
| lotno | character varying | YES | YES字段 |
 |
| sampleno | character varying | YES | YES字段 |
 |
| res | character varying | YES | YES字段 |
 |
| lockstatus | character varying | YES | YES字段 |
 |
| instrndate | character varying | YES | YES字段 |
 |
| instrnno | character varying | YES | YES字段 |
 |
| rtrecord | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdrtnotqualified

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdrtnotqualified_id |
 |
| notqualified | character varying | YES | YES字段 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| weldposition | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdrtresult

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdrtresult_id_seq': |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| isom_no | character varying | YES | YES字段 |
 |
| returnwelder1 | character varying | YES | YES字段 |
 |
| returnwelder2 | character varying | YES | YES字段 |
 |
| rtrecord1 | character varying | YES | YES字段 |
 |
| rtrecord2 | character varying | YES | YES字段 |
 |
| rtinspectiondate1 | character varying | YES | YES字段 |
 |
| rtinspectiondate2 | character varying | YES | YES字段 |
 |
| rf1 | character varying | YES | YES字段 |
 |
| rf2 | character varying | YES | YES字段 |
 |
| rtresult | character varying | YES | YES字段 |
 |
| rtrender | character varying | YES | YES字段 |
 |
| rtcovering | character varying | YES | YES字段 |
 |
| rtfilm | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdrtsample

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdrtsample_id_seq': |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| isom_no | character varying | YES | YES字段 |
 |
| joint | character varying | YES | YES字段 |
 |
| cover | character varying | YES | YES字段 |
 |
| coverdate | character varying | YES | YES字段 |
 |
| rtlotno | character varying | YES | YES字段 |
 |
| rtsampleno | character varying | YES | YES字段 |
 |
| rtinstrno | character varying | YES | YES字段 |
 |
| rtsampleserialno | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdstandardsize

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdstandardsize_id_s |
 |
| size | character varying | YES | YES字段 |
 |
| db | numeric | YES | YES字段 |
 |
| nps | bigint | YES | YES字段 |
 |
| odgb | numeric | YES | YES字段 |
 |
| odansi | numeric | YES | YES字段 |
 |
| bqmaincode | character varying | YES | YES字段 |
 |
| bqsubcode | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdsystem

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdsystem_id_seq'::r |
 |
| thesystem | character varying | YES | YES字段 |
 |
| instructions | character varying | YES | YES字段 |
 |
| mcdate | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdtestmedium

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdtestmedium_id_seq |
 |
| testmedium | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdthickness

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdthickness_id_seq' |
 |
| linelevel | character varying | YES | YES字段 |
 |
| size | character varying | YES | YES字段 |
 |
| rules | character varying | YES | YES字段 |
 |
| thickness | numeric | YES | YES字段 |
 |
| hothandler | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdwelders

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| welders | character varying | NO | NO字段 |
 |
| publictime | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| weldername | character varying | YES | YES字段 |
 |
| requestcode | character varying | YES | YES字段 |
 |
| companyname | character varying | YES | YES字段 |
 |
| qualification | character varying | YES | YES字段 |
 |
| weldposition1 | character varying | YES | YES字段 |
 |
| weldposition2 | character varying | YES | YES字段 |
 |
| remarks | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| createtime | timestamp without time zone | YES | now() |
 |

### t_gdwelderwpsno

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdwelderwpsno_id_se |
 |
| welder_no | character varying | YES | YES字段 |
 |
| wpsno | character varying | YES | YES字段 |
 |
| remarks | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdweldtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_gdweldtype_id_seq': |
 |
| type | character varying | YES | 类型分类 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| factor | numeric | YES | YES字段 |
 |
| code | character varying | YES | 编码，唯一标识 |
 |
| keycode | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_gdwpscode

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| wpsno | character varying | NO | NO字段 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| remarks | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_goodsadjustrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodsadjustrecord_i |
 |
| checkinid | bigint | YES | YES字段 |
 |
| goodsid | bigint | YES | YES字段 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character | YES | 物品名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| spec | character varying | YES | YES字段 |
 |
| ip | character | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| ownercode | character | YES | YES字段 |
 |
| ownername | character | YES | YES字段 |
 |
| buytime | timestamp without time zone | YES | YES字段 |
 |
| purmancode | character | YES | YES字段 |
 |
| purmanname | character | YES | YES字段 |
 |
| applicantcode | character | YES | 申请人编码 |
 |
| applicantname | character | YES | 申请人姓名 |
 |
| relatedpurid | bigint | YES | YES字段 |
 |
| memo | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| number | numeric | YES | YES字段 |
 |
| unitname | character | YES | 单位名称 |
 |
| position | character varying | YES | YES字段 |
 |
| adjustercode | character varying | YES | YES字段 |
 |
| adjustername | character varying | YES | YES字段 |
 |
| adjusttime | timestamp without time zone | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| manufacturer | character varying | YES | YES字段 |
 |
| whposition | character varying | YES | ''::character varying |
 |

### t_goodsborroworderdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodsborroworderdet |
 |
| borrowno | bigint | YES | YES字段 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character | YES | 物品名称 |
 |
| spec | character varying | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| unitname | character | YES | 单位名称 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| returnnumber | numeric | YES | YES字段 |
 |
| amount | numeric | YES | 金额 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |
| sn | character varying | YES | ''::character varying |
 |
| type | character varying | YES | ''::bpchar |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_goodscheckintype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| typename | character varying | NO | NO字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_goodscheckoutnoticeorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| cooid | bigint | NO | nextval('t_goodscheckoutnotice |
 |
| cooname | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| applicantcode | character | YES | 申请人编码 |
 |
| applicantname | character varying | NO | 申请人姓名 |
 |
| applytime | timestamp without time zone | NO | NO字段 |
 |
| finishtime | timestamp without time zone | NO | 完成时间 |
 |
| applyreason | character varying | YES | YES字段 |
 |
| status | character varying | NO | 状态，记录当前处理阶段 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| amount | numeric | YES | 金额 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |

### t_goodscheckoutnoticeorderdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodscheckoutnotice |
 |
| cooid | bigint | NO | NO字段 |
 |
| pdid | bigint | YES | YES字段 |
 |
| pdname | character varying | YES | YES字段 |
 |
| customermodelnumber | character varying | YES | YES字段 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character varying | NO | 物品名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| spec | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| barcode | character varying | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| boxnumber | numeric | YES | YES字段 |
 |
| unit | character | NO | 计量单位 |
 |
| checkoutnumber | numeric | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| amount | numeric | YES | 金额 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |
| finishstatus | character varying | YES | YES字段 |
 |
| deliveryaddress | character varying | YES | YES字段 |
 |
| checkouttime | timestamp without time zone | YES | now() |
 |
| comment | character varying | YES | 备注说明 |
 |
| sourcetype | character varying | YES | YES字段 |
 |
| sourceid | bigint | YES | YES字段 |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_goodsdeliveryorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| doid | bigint | NO | nextval('t_goodsdeliveryorder_ |
 |
| doname | character varying | YES | YES字段 |
 |
| invoicehead | character varying | YES | YES字段 |
 |
| receivername | character | YES | YES字段 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |
| purchasename | character | NO | NO字段 |
 |
| purchasephone | character varying | YES | YES字段 |
 |
| carteam | character | NO | NO字段 |
 |
| driver | character | NO | NO字段 |
 |
| carcode | character | NO | NO字段 |
 |
| deliverytime | timestamp without time zone | NO | NO字段 |
 |
| arrivaltime | timestamp without time zone | NO | NO字段 |
 |
| amount | numeric | YES | 金额 |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| operatorname | character varying | YES | 操作人姓名 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| comment | character varying | YES | 备注说明 |
 |
| status | character varying | NO | 状态，记录当前处理阶段 |
 |
| chukucangku | character varying | YES | ''::character varying |
 |
| songhuodizhi | character varying | YES | ''::character varying |
 |

### t_goodsdeliveryorderdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodsdeliveryorderd |
 |
| doid | bigint | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character varying | YES | 物品名称 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| spec | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| amount | numeric | YES | 金额 |
 |
| sourcetype | character varying | YES | 'Other'::bpchar |
 |
| sourceid | bigint | YES | 0 |
 |
| relatedid | bigint | YES | 0 |
 |
| currencytype | character varying | YES | ''::character varying |
 |
| sn | character varying | YES | ''::character varying |
 |
| realreceivenumber | numeric | YES | 0 |
 |
| chandi | character varying | YES | ''::character varying |
 |
| pihao | character varying | YES | ''::character varying |
 |
| tongsu | numeric | YES | 0 |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_goodsmtrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodsmtrecord_id_se |
 |
| mtmancode | character | YES | YES字段 |
 |
| goodscode | character | YES | 物品编码 |
 |
| type | character varying | YES | 类型分类 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| mttime | timestamp without time zone | YES | YES字段 |
 |
| cost | numeric | YES | 成本 |
 |
| mtmanname | character | YES | YES字段 |
 |
| goodsid | bigint | YES | YES字段 |
 |
| goodsname | character | YES | 物品名称 |
 |

### t_goodsproductionorderdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodsproductionorde |
 |
| pdid | bigint | YES | YES字段 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character | YES | 物品名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| spec | character varying | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| unitname | character | YES | 单位名称 |
 |
| deliverydate | timestamp without time zone | YES | YES字段 |
 |
| packagingsystem | character varying | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |
| checkinnumber | numeric | YES | 0 |
 |
| sourcetype | character varying | YES | 'OTHER'::bpchar |
 |
| sourceid | bigint | YES | 0 |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| bomverid | bigint | YES | 0 |
 |
| defaultprocess | character varying | YES | ''::character varying |
 |
| price | numeric | YES | 0 |
 |
| amount | numeric | YES | 0 |
 |
| brand | character varying | YES | ''::character varying |
 |
| batchnumber | character varying | YES | ''::character varying |
 |
| productdate | timestamp without time zone | YES | now() |
 |
| finisheddate | timestamp without time zone | YES | now() |
 |
| productionequipmentnumber | character varying | YES | ''::character varying |
 |
| materialformnumber | character varying | YES | ''::character varying |
 |

### t_goodssalequotationorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| qoid | bigint | NO | nextval('t_goodssalequotationo |
 |
| qoname | character varying | YES | YES字段 |
 |
| salescode | character | YES | YES字段 |
 |
| salesname | character | NO | NO字段 |
 |
| quotationtime | timestamp without time zone | NO | NO字段 |
 |
| validityperiod | character varying | NO | NO字段 |
 |
| amount | numeric | YES | 金额 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |
| customercode | character | YES | 客户编号 |
 |
| customername | character | YES | 客户名称 |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| operatorname | character varying | YES | 操作人姓名 |
 |
| comment | character varying | YES | 备注说明 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| status | character varying | NO | 状态，记录当前处理阶段 |
 |

### t_goodssalequotationorderdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodssalequotationo |
 |
| qoid | bigint | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character varying | YES | 物品名称 |
 |
| number | numeric | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| discount | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| spec | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| amount | numeric | YES | 0 |
 |
| currencytype | character varying | YES | ''::character varying |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_goodssalerecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodssalerecord_id_ |
 |
| soid | bigint | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character varying | YES | 物品名称 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| spec | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| salereason | character varying | YES | YES字段 |
 |
| checkoutnumber | numeric | YES | 0 |
 |
| deliverynumber | numeric | YES | 0 |
 |
| amount | numeric | YES | 0 |
 |
| currencytype | character varying | YES | ''::character varying |
 |
| noticeoutnumber | numeric | YES | 0 |
 |
| packnumber | numeric | YES | 0 |
 |
| realreceivenumber | numeric | YES | 0 |
 |
| brand | character varying | YES | ''::character varying |
 |
| sourcetype | character varying | YES | ''::bpchar |
 |
| sourceid | bigint | YES | 0 |
 |

### t_goodsscrape

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodsscrape_id_seq' |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character | YES | 物品名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| oldusercode | character | YES | YES字段 |
 |
| oldusername | character | YES | YES字段 |
 |
| scrapereason | character varying | YES | YES字段 |
 |
| scrapetime | timestamp without time zone | YES | YES字段 |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| operatorname | character | YES | 操作人姓名 |
 |
| afterscrapeuse | character varying | YES | YES字段 |
 |
| getamount | numeric | YES | YES字段 |
 |
| goodsid | bigint | YES | YES字段 |
 |
| scrapenumber | numeric | YES | YES字段 |
 |

### t_goodsshipmenttype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| typename | character varying | NO | NO字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_goodsstockcountmethod

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| method | character | NO | NO字段 |
 |

### t_goodsuserrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_goodsuserrecord_id_ |
 |
| goodscode | character | YES | 物品编码 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| type | character varying | YES | 类型分类 |
 |
| beginusetime | timestamp without time zone | NO | NO字段 |
 |
| endusetime | timestamp without time zone | NO | NO字段 |
 |
| number | numeric | YES | YES字段 |
 |
| goodsid | bigint | YES | YES字段 |
 |
| position | character varying | YES | YES字段 |
 |

### t_hseaccidentdescription

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sceneleader | character varying | YES | YES字段 |
 |
| accidentdate | timestamp without time zone | YES | YES字段 |
 |
| accidentaddr | character varying | YES | YES字段 |
 |
| accidenttype | character varying | YES | YES字段 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| deathnum | bigint | YES | 0 |
 |
| seriousinjury | bigint | YES | 0 |
 |
| minorinjury | bigint | YES | 0 |
 |
| accidentafter | text | YES | YES字段 |
 |
| accidentscope | text | YES | YES字段 |
 |
| accidentbecause | text | YES | YES字段 |
 |
| measures | text | YES | YES字段 |
 |
| others | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hseaccidentinvestigation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| accidentdescriptioncode | character varying | YES | YES字段 |
 |
| accidentdescriptionname | character varying | YES | YES字段 |
 |
| happendate | timestamp without time zone | YES | YES字段 |
 |
| accidentaddr | character varying | YES | YES字段 |
 |
| accidenttype | character varying | YES | YES字段 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| currency | character varying | YES | 币种 |
 |
| exchangerate | numeric | YES | 汇率 |
 |
| propertydamage | numeric | YES | 0 |
 |
| deathnum | bigint | YES | 0 |
 |
| seriousinjury | bigint | YES | 0 |
 |
| minorinjury | bigint | YES | 0 |
 |
| influenceharm | text | YES | YES字段 |
 |
| causeresponsibility | text | YES | YES字段 |
 |
| engineeringsolutions | text | YES | YES字段 |
 |
| takemeasures | text | YES | YES字段 |
 |
| lessontext | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsediseaseprevention

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| diseasetype | character varying | YES | YES字段 |
 |
| briefdescription | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hseemergencycompile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| remark | text | YES | 备注说明 |
 |
| createdate | timestamp without time zone | YES | 记录创建时间 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hseemergencyrehearse

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| emergencycompilecode | character varying | YES | YES字段 |
 |
| emergencycompilename | character varying | YES | YES字段 |
 |
| rehearsedate | timestamp without time zone | YES | YES字段 |
 |
| rehearseaddr | character varying | YES | YES字段 |
 |
| header | character varying | YES | YES字段 |
 |
| rehearsequestion | text | YES | YES字段 |
 |
| rehearsefeedback | text | YES | YES字段 |
 |
| participants | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hseenvirfactorsurdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_hseenvirfactorsurde |
 |
| envirfactorsurveycode | character varying | YES | YES字段 |
 |
| envirfactorsurveyname | character varying | YES | YES字段 |
 |
| factorcode | character varying | YES | YES字段 |
 |
| factorname | character varying | YES | YES字段 |
 |
| evaluationresult | text | YES | YES字段 |
 |
| significantdegree | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hseenvirfactorsurvey

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| leader | character varying | YES | YES字段 |
 |
| unitcode | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| enterdate | timestamp without time zone | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| distributedobject | character varying | YES | YES字段 |
 |
| evaluationopinions | text | YES | YES字段 |
 |
| evaluationdate | timestamp without time zone | YES | YES字段 |
 |
| associatedprocess | character varying | YES | YES字段 |
 |
| attachname | character varying | YES | YES字段 |
 |
| attachpath | character varying | YES | YES字段 |
 |
| evaluationper | character varying | YES | YES字段 |
 |
| entercodevalue | character varying | YES | YES字段 |
 |

### t_hseenvironmentalfactors

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| process | character varying | YES | YES字段 |
 |
| activity | character varying | YES | YES字段 |
 |
| tenses | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| factortype | character varying | YES | YES字段 |
 |
| envirimpact | text | YES | YES字段 |
 |
| copestrategy | text | YES | YES字段 |
 |
| lawregulationreq | text | YES | YES字段 |
 |
| termfeaturereq | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hseenvironmentalobjectives

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | character varying | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| enterper | character varying | YES | YES字段 |
 |
| setdate | timestamp without time zone | YES | YES字段 |
 |
| version | character varying | YES | 版本号 |
 |
| versiondate | timestamp without time zone | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| reviewer | character varying | YES | YES字段 |
 |
| reviewdate | timestamp without time zone | YES | YES字段 |
 |
| reviewresult | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsehealthcheck

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| checkpersion | character varying | YES | YES字段 |
 |
| checkarea | character varying | YES | YES字段 |
 |
| checkdate | timestamp without time zone | YES | 审核日期 |
 |
| unitcode | character varying | YES | YES字段 |
 |
| leader | character varying | YES | YES字段 |
 |
| checkresult | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsehealthycheckup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| checkdate | timestamp without time zone | YES | 审核日期 |
 |
| persionname | character varying | YES | YES字段 |
 |
| perattribute | character varying | YES | YES字段 |
 |
| gender | character varying | YES | YES字段 |
 |
| birthday | timestamp without time zone | YES | YES字段 |
 |
| pertype | character varying | YES | YES字段 |
 |
| medicalconclusion | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| enterdate | timestamp without time zone | YES | YES字段 |
 |
| entercodevalue | character varying | YES | YES字段 |
 |

### t_hsemeeting

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| meetingplace | character varying | YES | YES字段 |
 |
| meetingdate | timestamp without time zone | YES | YES字段 |
 |
| hoster | character varying | YES | YES字段 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| starttime | timestamp without time zone | YES | 开始时间 |
 |
| endtime | timestamp without time zone | YES | YES字段 |
 |
| summarytype | character varying | YES | YES字段 |
 |
| summarycontent | text | YES | YES字段 |
 |
| participants | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsepenaltynotice

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| rectificationcode | character varying | YES | YES字段 |
 |
| rectificationname | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| penaltydepartcode | character varying | YES | YES字段 |
 |
| penaltymoney | numeric | YES | YES字段 |
 |
| currency | character varying | YES | 币种 |
 |
| penaltydate | timestamp without time zone | YES | YES字段 |
 |
| penaltyremark | text | YES | YES字段 |
 |
| measures | text | YES | YES字段 |
 |
| auditopinion | text | YES | YES字段 |
 |
| auditdepartcode | character varying | YES | YES字段 |
 |
| auditor | character varying | YES | YES字段 |
 |
| auditdate | timestamp without time zone | YES | YES字段 |
 |
| verificationresults | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hseperequiprecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| companyfor | character varying | YES | YES字段 |
 |
| address | character varying | YES | 联系地址 |
 |
| einno | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| linktel | character varying | YES | YES字段 |
 |
| zipcode | character varying | YES | YES字段 |
 |
| validitystart | timestamp without time zone | YES | YES字段 |
 |
| validityend | timestamp without time zone | YES | YES字段 |
 |
| suppservscope | text | YES | YES字段 |
 |
| bankname | character varying | YES | 开户银行名称 |
 |
| auditstatus | character varying | YES | YES字段 |
 |
| fax | character varying | YES | 传真号码 |
 |
| webaddress | character varying | YES | YES字段 |
 |
| qualifications | text | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hseproductionsummary

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsequalificationrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| perequiprecordcode | character varying | YES | YES字段 |
 |
| perequiprecordname | character varying | YES | YES字段 |
 |
| businessscope | text | YES | YES字段 |
 |
| subcontractwork | text | YES | YES字段 |
 |
| construction | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hserectification

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | YES | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| rectificationnoticeid | character varying | YES | YES字段 |
 |
| rectificationnoticename | character varying | YES | YES字段 |
 |
| unitdepartcode | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| nofactdescribe | text | YES | YES字段 |
 |
| causeanalysis | text | YES | YES字段 |
 |
| correctiveaction | text | YES | YES字段 |
 |
| rectificationopinions | text | YES | YES字段 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| implementationheader | character varying | YES | YES字段 |
 |
| estimatecompletiondate | timestamp without time zone | YES | YES字段 |
 |
| reviewer | character varying | YES | YES字段 |
 |
| reviewdate | timestamp without time zone | YES | YES字段 |
 |
| reviewresult | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hserectificationnotice

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| safeinspectid | character varying | YES | YES字段 |
 |
| safeinspectname | character varying | YES | YES字段 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| inspectiondate | timestamp without time zone | YES | YES字段 |
 |
| qesengineercode | character varying | YES | YES字段 |
 |
| signdate1 | timestamp without time zone | YES | YES字段 |
 |
| reqrecdate | timestamp without time zone | YES | YES字段 |
 |
| projectmanager | character varying | YES | YES字段 |
 |
| signdate2 | timestamp without time zone | YES | YES字段 |
 |
| inspectors | text | YES | YES字段 |
 |
| rectificationopinions | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsesafeinspectionrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| inspectiondate | timestamp without time zone | YES | YES字段 |
 |
| headcode | character varying | YES | YES字段 |
 |
| projectmanager | character varying | YES | YES字段 |
 |
| qesengineer | character varying | YES | YES字段 |
 |
| inspectionteamleader | character varying | YES | YES字段 |
 |
| inspectorscode | text | YES | YES字段 |
 |
| inspectionoverview | text | YES | YES字段 |
 |
| inspectcontentfindings | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsesafemanagementplan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| perequiprecordcode | character varying | YES | YES字段 |
 |
| perequiprecordname | character varying | YES | YES字段 |
 |
| leader | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsetraining

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| hoster | character varying | YES | YES字段 |
 |
| speaker | character varying | YES | YES字段 |
 |
| trainingstart | timestamp without time zone | YES | YES字段 |
 |
| trainingend | timestamp without time zone | YES | YES字段 |
 |
| trainingsite | character varying | YES | YES字段 |
 |
| trainingcontent | text | YES | YES字段 |
 |
| trainingtype | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_hsetrainingplan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| professional | character varying | YES | YES字段 |
 |
| trainingcontent | text | YES | YES字段 |
 |
| trainingdate | timestamp without time zone | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| enterdate | timestamp without time zone | YES | YES字段 |
 |
| entercodevalue | character varying | YES | YES字段 |
 |

### t_impleplan_updatelog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| workid | bigint | YES | YES字段 |
 |
| name | character varying | NO | 名称 |
 |
| start_date | timestamp without time zone | YES | YES字段 |
 |
| end_date | timestamp without time zone | YES | YES字段 |
 |
| resource | character varying | YES | YES字段 |
 |
| budget | double precision | YES | 预算金额 |
 |
| makedate | timestamp without time zone | YES | 记录创建时间 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| parentid | bigint | YES | 父级记录ID，用于构建层级结构 |
 |
| priorid | bigint | YES | 前一记录ID，用于链表结构 |
 |
| type | character varying | YES | 类型分类 |
 |
| verid | bigint | YES | YES字段 |
 |
| defaultschedule | double precision | YES | YES字段 |
 |
| defaultcost | double precision | YES | YES字段 |
 |
| backupid | bigint | YES | 备份记录ID |
 |
| lockstatus | character varying | YES | YES字段 |
 |
| updatemancode | character | YES | YES字段 |
 |
| updatetime | timestamp without time zone | YES | 最后更新时间 |
 |
| fromprojectid | bigint | YES | YES字段 |
 |
| fromprojectplanverid | bigint | YES | YES字段 |
 |
| creatorcode | character | YES | YES字段 |
 |
| percent_done | bigint | YES | YES字段 |
 |
| priority | bigint | YES | 优先级，如Normal/High/Low |
 |
| baseline_start_date | timestamp without time zone | YES | YES字段 |
 |
| baseline_end_date | timestamp without time zone | YES | YES字段 |
 |
| duration | double precision | YES | YES字段 |
 |
| duration_unit | character varying | YES | YES字段 |
 |
| other_field | character varying | YES | YES字段 |
 |
| index | bigint | YES | YES字段 |
 |
| pid | bigint | YES | YES字段 |
 |
| parent_id | bigint | YES | YES字段 |
 |
| fromplanid | bigint | YES | YES字段 |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| operatorname | character | YES | 操作人姓名 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| leader | character | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| baseline_percent_done | bigint | YES | YES字段 |
 |
| taskcolor | character varying | YES | YES字段 |
 |
| leadercode | character | YES | YES字段 |
 |
| workhour | double precision | YES | YES字段 |
 |
| actualhour | double precision | YES | YES字段 |
 |
| expense | double precision | YES | 实际费用 |
 |
| createlogtime | timestamp without time zone | YES | now() |
 |
| requirenumber | double precision | YES | 0 |
 |
| finishednumber | double precision | YES | 0 |
 |
| unitname | character | YES | ''::bpchar |
 |
| price | double precision | YES | 0 |
 |
| ... | ... | ... | ... |

### t_interfaceurl_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_interfaceurl_yyup_i |
 |
| interfacetype | character varying | YES | YES字段 |
 |
| interfaceurl | character varying | YES | YES字段 |
 |

### t_item

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| itemcode | character | NO | 物料编码 |
 |
| itemname | character varying | YES | 物料名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| unit | character | YES | 计量单位 |
 |
| specification | character varying | YES | YES字段 |
 |
| puleadtime | numeric | YES | 0 |
 |
| mfleadtime | numeric | YES | 0 |
 |
| hrcost | numeric | YES | 0 |
 |
| mtcost | numeric | YES | 0 |
 |
| mfcost | numeric | YES | 0 |
 |
| comment | character varying | YES | 备注说明 |
 |
| defaultprocess | character varying | YES | ' '::character varying |
 |
| safetystock | numeric | YES | 0 |
 |
| relatedtype | character varying | YES | 'SYSTEM'::bpchar |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| purchaseprice | numeric | YES | 0 |
 |
| saleprice | numeric | YES | 0 |
 |
| currencytype | character varying | YES | ''::character varying |
 |
| bigtype | character varying | YES | ''::bpchar |
 |
| smalltype | character varying | YES | ''::bpchar |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| photourl | character varying | YES | ''::character varying |
 |
| warrantyperiod | character varying | YES | 0 |
 |
| lossrate | numeric | YES | 0 |
 |
| brand | character varying | YES | ''::character varying |
 |
| registrationnumber | character varying | YES | ''::character varying |
 |
| packingtype | character varying | YES | ''::character varying |
 |

### t_itembom

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itembom_id_seq'::re |
 |
| itemcode | character | YES | 物料编码 |
 |
| parentitemcode | character | YES | YES字段 |
 |
| childitemcode | character | YES | YES字段 |
 |
| number | numeric | YES | 0 |
 |
| unit | character | YES | 计量单位 |
 |
| verid | bigint | YES | 0 |
 |
| childitemverid | bigint | YES | 0 |
 |
| reservednumber | numeric | YES | 0 |
 |
| defaultprocess | character varying | YES | ' '::character varying |
 |
| lossrate | numeric | YES | 0 |
 |
| sortnumber | bigint | YES | 0 |
 |
| belongverid | bigint | YES | 1 |
 |
| belongitemcode | character | YES | ''::bpchar |
 |
| keyword | character varying | YES | ''::character varying |
 |
| parentkeyword | character varying | YES | ''::character varying |
 |
| childitemname | character varying | YES | ''::character varying |
 |
| childitemtype | character varying | YES | ''::bpchar |
 |
| childitemspecification | character varying | YES | ''::character varying |
 |
| childitemmodelnumber | character varying | YES | ''::character varying |
 |
| childitemphotourl | character varying | YES | ''::character varying |
 |
| hrcost | numeric | YES | 0 |
 |
| mtcost | numeric | YES | 0 |
 |
| mfcost | numeric | YES | 0 |
 |
| puleadtime | numeric | YES | 0 |
 |
| mfleadtime | numeric | YES | 0 |
 |
| purchaseprice | numeric | YES | 0 |
 |
| saleprice | numeric | YES | 0 |
 |
| childitembrand | character varying | YES | ''::character varying |
 |

### t_itembompart

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itembompart_id_seq' |
 |
| itemcode | character | YES | 物料编码 |
 |
| parentitemcode | character | YES | YES字段 |
 |
| childitemcode | character | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| verid | bigint | YES | YES字段 |
 |
| childitemverid | bigint | YES | YES字段 |
 |
| reservednumber | numeric | YES | YES字段 |
 |
| defaultprocess | character varying | YES | YES字段 |
 |
| lossrate | numeric | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| childitemname | character varying | YES | ''::character varying |
 |
| childitemtype | character varying | YES | ''::bpchar |
 |
| childitemspecification | character varying | YES | ''::character varying |
 |
| childitemmodelnumber | character varying | YES | ''::character varying |
 |
| childitemphotourl | character varying | YES | ''::character varying |
 |
| hrcost | numeric | YES | 0 |
 |
| mtcost | numeric | YES | 0 |
 |
| mfcost | numeric | YES | 0 |
 |
| puleadtime | numeric | YES | 0 |
 |
| mfleadtime | numeric | YES | 0 |
 |
| childitembrand | character varying | YES | ''::character varying |
 |

### t_itembomversion

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itembomversion_id_s |
 |
| itemcode | character | YES | 物料编码 |
 |
| verid | bigint | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| relatedtype | character varying | YES | 'SYSTEM'::bpchar |
 |
| relatedid | bigint | YES | 关联业务ID |
 |

### t_itemmainplan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| planverid | bigint | NO | nextval('t_itemmainplan_planve |
 |
| planvername | character varying | NO | NO字段 |
 |
| belongdepartcode | character varying | YES | ''::character varying |
 |
| belongdepartname | character varying | YES | ''::character varying |
 |
| status | character varying | YES | ''::bpchar |
 |
| createtime | timestamp without time zone | YES | now() |
 |
| creatorcode | character varying | YES | ''::character varying |
 |
| creatorname | character varying | YES | ''::character varying |
 |
| plantype | character varying | YES | ''::bpchar |
 |

### t_itemmainplandetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itemmainplandetail_ |
 |
| planverid | bigint | NO | NO字段 |
 |
| itemcode | character | YES | ''::bpchar |
 |
| itemname | character varying | YES | ''::character varying |
 |
| specification | character varying | YES | YES字段 |
 |
| bomverid | bigint | YES | 0 |
 |
| plannumber | numeric | YES | 0 |
 |
| finishednumber | numeric | YES | 0 |
 |
| unfinishednumber | numeric | YES | 0 |
 |
| unit | character | YES | 计量单位 |
 |
| planstartdate | timestamp without time zone | YES | now() |
 |
| makedate | timestamp without time zone | YES | now() |
 |
| deliverydate | timestamp without time zone | YES | now() |
 |
| createdate | timestamp without time zone | YES | now() |
 |
| modifydate | timestamp without time zone | YES | now() |
 |
| sourcetype | character varying | YES | ''::bpchar |
 |
| sourcerecordid | bigint | YES | 0 |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| type | character varying | YES | ''::bpchar |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_itemmainplanmrpversion

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itemmainplanmrpvers |
 |
| planverid | bigint | YES | 0 |
 |
| planmrpverid | bigint | YES | 0 |
 |
| type | character varying | YES | 类型分类 |
 |
| createtime | timestamp without time zone | YES | now() |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | YES | YES字段 |
 |
| expendtype | character varying | YES | 'WHOLE'::bpchar |
 |
| onorder | character | YES | 'NO'::bpchar |
 |
| onproduction | character | YES | 'NO'::bpchar |
 |
| online | character | YES | 'NO'::bpchar |
 |
| relatedprojectid | integer | YES | 0 |
 |
| relatedprojectplanverid | integer | YES | 0 |
 |

### t_itemmainplanrelateditemplandata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itemmainplanrelated |
 |
| planverid | bigint | YES | 0 |
 |
| planmrpverid | bigint | YES | 0 |
 |
| itemcode | character | NO | 物料编码 |
 |
| itemname | character varying | YES | 物料名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| specification | character varying | YES | YES字段 |
 |
| number | numeric | YES | 0 |
 |
| unit | character | YES | 计量单位 |
 |
| ordertime | timestamp without time zone | YES | now() |
 |
| requiretime | timestamp without time zone | YES | now() |
 |
| defaultprocess | character varying | YES | ''::character varying |
 |
| lossrate | numeric | YES | 0 |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| sourcetype | character varying | YES | 'Other'::bpchar |
 |
| sourcerecordid | bigint | YES | 0 |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_itemmainplanrelateditemproductplan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itemmainplanrelated |
 |
| planverid | bigint | YES | 0 |
 |
| planmrpverid | bigint | YES | 0 |
 |
| itemcode | character | NO | 物料编码 |
 |
| itemname | character varying | YES | 物料名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| specification | character varying | YES | YES字段 |
 |
| number | numeric | YES | 0 |
 |
| unit | character | YES | 计量单位 |
 |
| ordertime | timestamp without time zone | YES | now() |
 |
| requiretime | timestamp without time zone | YES | now() |
 |
| defaultprocess | character varying | YES | ''::character varying |
 |
| ordernumber | numeric | YES | 0 |
 |
| finishednumber | numeric | YES | 0 |
 |
| unfinishednumber | numeric | YES | 0 |
 |
| requirenumber | numeric | YES | 0 |
 |
| lossrate | numeric | YES | 0 |
 |
| lossnumber | numeric | YES | 0 |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| sourcetype | character varying | YES | 'Other'::bpchar |
 |
| sourcerecordid | bigint | YES | 0 |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_itemmainplanrelateditempurchaseplan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itemmainplanrelated |
 |
| planverid | bigint | YES | 0 |
 |
| planmrpverid | bigint | YES | 0 |
 |
| itemcode | character | NO | 物料编码 |
 |
| itemname | character varying | YES | 物料名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| specification | character varying | YES | YES字段 |
 |
| number | numeric | YES | 0 |
 |
| unit | character | YES | 计量单位 |
 |
| ordertime | timestamp without time zone | YES | now() |
 |
| requiretime | timestamp without time zone | YES | now() |
 |
| defaultprocess | character varying | YES | ''::character varying |
 |
| ordernumber | numeric | YES | 0 |
 |
| finishednumber | numeric | YES | 0 |
 |
| unfinishednumber | numeric | YES | 0 |
 |
| requirenumber | numeric | YES | 0 |
 |
| lossrate | numeric | YES | 0 |
 |
| lossnumber | numeric | YES | 0 |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| sourcetype | character varying | YES | 'Other'::bpchar |
 |
| sourcerecordid | bigint | YES | 0 |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_itemmainplanrelateditemremainingdata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itemmainplanrelated |
 |
| planverid | bigint | YES | 0 |
 |
| planmrpverid | bigint | YES | 0 |
 |
| itemcode | character | NO | 物料编码 |
 |
| itemname | character varying | YES | 物料名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| specification | character varying | YES | YES字段 |
 |
| remainingnumber | numeric | YES | 0 |
 |
| unit | character | YES | 计量单位 |
 |
| requiretime | timestamp without time zone | YES | now() |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_itemrelatedorderbomtoexpenddetaildata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_itemrelatedorderbom |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| itemcode | character | NO | 物料编码 |
 |
| itemname | character varying | YES | 物料名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| specification | character varying | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| ordertime | timestamp without time zone | YES | YES字段 |
 |
| requiretime | timestamp without time zone | YES | YES字段 |
 |
| defaultprocess | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | ''::character varying |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_jnunit

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| unitname | character | NO | 单位名称 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_knowledgedocrelated_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_knowledgedocrelated |
 |
| subordinateindustry | character varying | YES | YES字段 |
 |
| productline | character varying | YES | YES字段 |
 |
| moduleids | text | YES | YES字段 |
 |
| modulenames | text | YES | YES字段 |
 |
| toolsid | bigint | YES | YES字段 |
 |
| issend | character varying | YES | YES字段 |
 |

### t_kpichecktypeweight

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| selfcheckweight | numeric | NO | 0 |
 |
| leadercheckweight | numeric | YES | 0 |
 |
| thirdpartcheckweight | numeric | YES | 0 |
 |
| sqlcheckweight | numeric | YES | 0 |
 |
| hrcheckweight | numeric | YES | 0 |
 |

### t_kpihrreview

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_kpihrreview_id_seq' |
 |
| userkpiid | bigint | YES | 0 |
 |
| hrcode | character | YES | ''::bpchar |
 |
| hrname | character | YES | ''::bpchar |
 |
| comment | character varying | YES | ''::character varying |
 |
| point | numeric | YES | 100 |
 |
| reviewtime | timestamp without time zone | YES | now() |
 |

### t_kpileaderreview

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_kpileaderreview_id_ |
 |
| userkpiid | bigint | YES | 0 |
 |
| leadercode | character | YES | ''::bpchar |
 |
| leadername | character | YES | ''::bpchar |
 |
| comment | character varying | YES | ''::character varying |
 |
| point | numeric | YES | 100 |
 |
| reviewtime | timestamp without time zone | YES | now() |
 |

### t_kpilibrary

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_kpilibrary_id_seq': |
 |
| kpitype | character varying | YES | ''::bpchar |
 |
| kpi | character varying | YES | ''::character varying |
 |
| definition | character varying | YES | ''::character varying |
 |
| kpifunction | character varying | YES | ''::character varying |
 |
| formula | character varying | YES | ''::character varying |
 |
| source | character varying | YES | ''::character varying |
 |
| sqlcode | character varying | YES | ''::character varying |
 |
| unitsqlpoint | numeric | YES | 1 |
 |
| relateddepartment | character varying | YES | ''::character varying |
 |
| relatedduty | character varying | YES | ''::character varying |
 |
| sortnumber | bigint | YES | 0 |
 |

### t_kpithirdpartreview

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_kpithirdpartreview_ |
 |
| userkpiid | bigint | YES | 0 |
 |
| usercode | character | YES | ''::bpchar |
 |
| username | character | YES | ''::bpchar |
 |
| comment | character varying | YES | ''::character varying |
 |
| point | numeric | YES | 100 |
 |
| reviewtime | timestamp without time zone | YES | now() |
 |

### t_kpitype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 0 |
 |

### t_kzllyylsjkgxkainianli

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_kzllyylsjkgxkainian |
 |
| ylspname | character varying | NO | NO字段 |
 |
| ylzwname | character varying | NO | NO字段 |
 |
| ylkainian | character varying | NO | NO字段 |
 |
| ypriqi | timestamp without time zone | YES | now() |
 |

### t_kzllyylsjkjichuli

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_kzllyylsjkjichuli_i |
 |
| ylspname | character varying | NO | NO字段 |
 |
| ylzwname | character varying | NO | NO字段 |
 |
| ylyongtu | character varying | NO | NO字段 |
 |
| ypriqi | timestamp without time zone | YES | now() |
 |

### t_kzllyylsjkxiangjingli

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_kzllyylsjkxiangjing |
 |
| ylspname | character varying | NO | NO字段 |
 |
| xjtype | character varying | NO | NO字段 |
 |
| ypriqi | timestamp without time zone | YES | now() |
 |

### t_kzlxyylxinxiku

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_kzlxyylxinxiku_id_s |
 |
| chcode | character | NO | NO字段 |
 |
| ylcode | character | NO | NO字段 |
 |
| ylspname | character varying | NO | NO字段 |
 |
| scshang | character varying | NO | NO字段 |
 |
| gyshang | character varying | NO | NO字段 |
 |
| bzzwname | character varying | NO | NO字段 |
 |
| inciname | character varying | NO | NO字段 |
 |
| cfbl | character varying | NO | NO字段 |
 |
| msdstdsxgzl | character varying | NO | NO字段 |
 |
| ylgg | numeric | YES | YES字段 |
 |
| ylprice | numeric | YES | YES字段 |
 |
| sffxwz | character varying | NO | NO字段 |
 |
| fxwzsm | character varying | NO | NO字段 |
 |
| fxpkxgzl | character varying | NO | NO字段 |
 |
| beizhu | character varying | NO | NO字段 |
 |

### t_kzlxyylxinxikurelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| usercode | character | NO | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |

### t_languageresourcehome

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| keyname | character varying | YES | 配置键名 |
 |
| keyvalue | character varying | YES | 配置键值 |
 |

### t_languageresourceother

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| keyname | character varying | YES | 配置键名 |
 |
| keyvalue | character varying | YES | 配置键值 |
 |

### t_leaveapplyform

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_leaveapplyform_id_s |
 |
| username | character varying | YES | 用户姓名 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| duty | character varying | YES | YES字段 |
 |
| leavetype | character varying | YES | YES字段 |
 |
| applybecause | text | YES | YES字段 |
 |
| starttime | timestamp without time zone | YES | 开始时间 |
 |
| endtime | timestamp without time zone | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| creator | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| hournum | numeric | YES | 0 |
 |
| daynum | numeric | YES | 0 |
 |

### t_leavetype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_license

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_license_id_seq'::re |
 |
| verificationstring | character varying | NO | NO字段 |
 |
| servername | character varying | YES | YES字段 |
 |

### t_ltcandidateinformation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_ltcandidateinformat |
 |
| username | character | YES | 用户姓名 |
 |
| gender | character | YES | YES字段 |
 |
| age | bigint | YES | YES字段 |
 |
| company | character varying | YES | YES字段 |
 |
| department | character varying | YES | YES字段 |
 |
| currentduty | character | YES | YES字段 |
 |
| mobilephone | character varying | YES | YES字段 |
 |
| photourl | character varying | YES | 照片文件路径 |
 |
| brief | text | YES | YES字段 |
 |
| belongdepartcode | character | YES | YES字段 |
 |
| belongdepartname | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| creatorcode | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_mail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| mailid | bigint | NO | nextval('t_mail_mailid_seq'::r |
 |
| title | character varying | YES | 标题 |
 |
| body | text | YES | YES字段 |
 |
| fromaddress | text | YES | YES字段 |
 |
| toaddress | text | YES | YES字段 |
 |
| ccaddress | text | YES | YES字段 |
 |
| htmlformat | bit | YES | YES字段 |
 |
| senderdate | timestamp without time zone | YES | YES字段 |
 |
| contain | bigint | YES | YES字段 |
 |
| attachmentflag | bit | YES | YES字段 |
 |
| readerflag | bit | YES | YES字段 |
 |
| folderid | bigint | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |

### t_mailattachment

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| attachmentid | bigint | NO | nextval('t_mailattachment_atta |
 |
| name | character varying | YES | 名称 |
 |
| url | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| contain | bigint | YES | YES字段 |
 |
| mailid | bigint | YES | YES字段 |
 |
| identifystring | character varying | YES | YES字段 |
 |

### t_mailfolder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| folderid | bigint | NO | nextval('t_mailfolder_folderid |
 |
| name | character varying | YES | 名称 |
 |
| total | bigint | YES | 合计金额 |
 |
| noreader | bigint | YES | YES字段 |
 |
| contain | bigint | YES | YES字段 |
 |
| createdate | timestamp without time zone | YES | 记录创建时间 |
 |
| flag | bit | YES | YES字段 |
 |
| ownercode | character | YES | YES字段 |
 |
| keyword | character | YES | YES字段 |
 |

### t_mailprofile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| webmailid | bigint | NO | nextval('t_mailprofile_webmail |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| aliasname | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| password | character varying | YES | YES字段 |
 |
| mailserverip | character varying | YES | YES字段 |
 |
| mailserverport | bigint | YES | YES字段 |
 |
| pop3serverip | character varying | YES | YES字段 |
 |
| pop3serverport | bigint | YES | YES字段 |
 |
| enablepop3ssl | character | YES | 'NO'::bpchar |
 |
| pop3sslport | bigint | YES | 995 |
 |
| enablesmtpssl | character | YES | 'NO'::bpchar |
 |
| smtpsslport | bigint | YES | 465 |
 |

### t_mailsigninfo

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_mailsigninfo_id_seq |
 |
| title | character varying | YES | 标题 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| signinfo | text | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_meetingassign

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_meetingassign_id_se |
 |
| meetingapplyid | bigint | YES | YES字段 |
 |
| name | character varying | YES | 名称 |
 |
| type | character varying | YES | 类型分类 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| host | character | YES | YES字段 |
 |
| recorder | character | YES | YES字段 |
 |
| content | character varying | YES | 内容详情 |
 |
| address | character varying | YES | 联系地址 |
 |
| begintime | timestamp without time zone | YES | YES字段 |
 |
| endtime | timestamp without time zone | YES | YES字段 |
 |
| buildercode | character | YES | YES字段 |
 |
| organizer | character varying | YES | YES字段 |
 |
| organizernote | character varying | YES | YES字段 |
 |
| record | character varying | YES | YES字段 |
 |
| maketime | timestamp without time zone | YES | 记录创建时间 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| mainpass | character varying | YES | YES字段 |
 |
| meetpassword | character varying | YES | YES字段 |
 |

### t_meetingsystemurl

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| meetingsystemurl | character varying | YES | YES字段 |
 |
| meetingurl | character varying | YES | YES字段 |
 |
| meetingcount | bigint | YES | YES字段 |
 |

### t_meetingtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_memberagency

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| agencycode | character | YES | YES字段 |
 |
| agencyname | character | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_memberagencywftype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| agencycode | character | YES | YES字段 |
 |
| wftype | character varying | YES | YES字段 |
 |

### t_memberchartstringformainpage

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| usercode | character | NO | 用户编码，登录账号 |
 |
| analystchartstring | text | YES | YES字段 |
 |
| moduleflowchartstring | text | YES | YES字段 |
 |
| flowchartlangcode | character varying | YES | YES字段 |
 |

### t_message

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_message_id_seq'::re |
 |
| fromuser | character varying | YES | YES字段 |
 |
| touser | character varying | YES | YES字段 |
 |
| content | character varying | YES | 内容详情 |
 |
| timestamp | timestamp without time zone | YES | YES字段 |
 |
| mid | bigint | YES | YES字段 |
 |

### t_msgpushlog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_msgpushlog_id_seq': |
 |
| pushtime | timestamp without time zone | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |

### t_mttype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_network_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_network_yyup_id_seq |
 |
| name | character varying | YES | 名称 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_newsrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_newsrelateduser_id_ |
 |
| newsid | bigint | YES | 0 |
 |
| usercode | character | YES | ''::bpchar |
 |
| readtime | timestamp without time zone | YES | now() |
 |

### t_noticerelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_noticerelateduser_i |
 |
| noticeid | bigint | YES | 0 |
 |
| usercode | character | YES | ''::bpchar |
 |
| readtime | timestamp without time zone | YES | now() |
 |

### t_officialdocument

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_officialdocument_id |
 |
| title | character varying | YES | 标题 |
 |
| content | text | YES | 内容详情 |
 |
| publishercode | character | YES | 发布人编码 |
 |
| publishername | character | YES | 发布人姓名 |
 |
| publishtime | timestamp without time zone | YES | 发布时间 |
 |
| relateddepartcode | character | YES | 关联部门编码 |
 |
| relateddepartname | character varying | YES | 关联部门名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| contentdocurl | character | YES | ''::bpchar |
 |

### t_oiltype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_oiltype_id_seq'::re |
 |
| oilname | character varying | YES | YES字段 |
 |

### t_othercoderunmark

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| normalcoderunmark | bigint | YES | 0 |
 |
| updatecolumnvaluecoderunmark | integer | YES | 0 |
 |
| updatemodulenamecoderunmark | integer | YES | 0 |
 |
| importantcoderunmark | integer | YES | 0 |
 |

### t_otherstatus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_otherstatus_id_seq' |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| langcode | character | YES | 语言代码，如zh-CN/en-US |
 |
| maketype | character varying | YES | YES字段 |
 |

### t_overtimeapplyform

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_overtimeapplyform_i |
 |
| username | character varying | YES | 用户姓名 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| duty | character varying | YES | YES字段 |
 |
| overtimetype | character varying | YES | YES字段 |
 |
| applybecause | text | YES | YES字段 |
 |
| starttime | timestamp without time zone | YES | 开始时间 |
 |
| endtime | timestamp without time zone | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| creator | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| hournum | numeric | YES | YES字段 |
 |
| daynum | numeric | YES | YES字段 |
 |
| overtimecheckintime | character varying | YES | ''::character varying |
 |
| overtimecheckouttime | character varying | YES | ''::character varying |
 |

### t_overtimetype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_packingtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_parttimejob

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_parttimejob_id_seq' |
 |
| usercode | character | NO | 用户编码，登录账号 |
 |
| username | character | NO | 用户姓名 |
 |
| departcode | character | NO | 部门编码，关联T_Department表 |
 |
| departname | character varying | NO | 部门名称 |
 |
| duty | character | NO | NO字段 |
 |
| effecttime | timestamp without time zone | YES | now() |
 |

### t_plan_leaderreviewbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| planid | bigint | NO | 关联T_Plan表，标识所属计划 |
 |
| leadercode | character | YES | YES字段 |
 |
| leadername | character | YES | YES字段 |
 |
| reviewtime | timestamp without time zone | YES | YES字段 |
 |
| review | text | YES | YES字段 |
 |
| scoring | numeric | YES | YES字段 |
 |

### t_plan_worklogbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| planid | bigint | NO | 关联T_Plan表，标识所属计划 |
 |
| logdetail | text | YES | YES字段 |
 |
| progress | bigint | YES | 进度百分比 |
 |
| worktime | timestamp without time zone | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| scheduleeventid | bigint | YES | YES字段 |
 |

### t_planbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| planid | bigint | NO | 关联T_Plan表，标识所属计划 |
 |
| plantype | character varying | NO | 计划类型 |
 |
| planname | character varying | YES | 计划名称 |
 |
| plandetail | text | YES | YES字段 |
 |
| starttime | timestamp without time zone | YES | 开始时间 |
 |
| endtime | timestamp without time zone | YES | YES字段 |
 |
| progress | bigint | YES | 进度百分比 |
 |
| scoringbyself | numeric | YES | 员工自评分 |
 |
| scoringbyleader | numeric | YES | 领导评分 |
 |
| parentid | bigint | YES | 父级记录ID，用于构建层级结构 |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| relatedcode | character | YES | YES字段 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| backupplanid | bigint | YES | YES字段 |
 |
| submittime | character | YES | YES字段 |
 |

### t_plancopyrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_plancopyrelateduser |
 |
| planid | bigint | NO | 关联T_Plan表，标识所属计划 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |

### t_planmember

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_planmember_id_seq': |
 |
| planid | bigint | YES | 关联T_Plan表，标识所属计划 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| mainwork | character varying | YES | YES字段 |
 |
| joindate | timestamp without time zone | YES | now() |
 |
| startworkdate | timestamp without time zone | YES | now() |
 |
| endworkdate | timestamp without time zone | YES | now() |
 |
| budget | numeric | YES | 预算金额 |
 |
| isleader | character | YES | 'NO'::bpchar |
 |

### t_planstatus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_planstatus_id_seq': |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| langcode | character | YES | ''::bpchar |
 |
| maketype | character varying | YES | 'DIY'::bpchar |
 |

### t_plantools_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_plantools_yyup_id_s |
 |
| plantoolsname | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_prodocgraphcontrol

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_prodocgraphcontrol_ |
 |
| parentname | character varying | YES | YES字段 |
 |
| classificationname | character varying | YES | YES字段 |
 |
| sortno | bigint | YES | YES字段 |
 |

### t_productlineversion_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_productlineversion_ |
 |
| productline | character varying | YES | YES字段 |
 |
| versionname | character varying | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_productmodule_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_productmodule_yyup_ |
 |
| modulename | character varying | YES | 模块名称 |
 |
| moduleenglishname | character varying | YES | YES字段 |
 |
| moduletype | character varying | YES | YES字段 |
 |
| moduleenglishtype | character varying | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_productmoduletype_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_productmoduletype_y |
 |
| moduletype | character varying | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_productprocess

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| processname | character varying | NO | NO字段 |
 |
| sortnumber | bigint | YES | 0 |
 |

### t_proexpense_jhkc

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_proexpense_jhkc_id_ |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| kesheguanlifeibili | numeric | YES | 0 |
 |
| jianchafeibili | numeric | YES | 0 |
 |
| kesheguanlifei | numeric | YES | 0 |
 |
| jianchafei | numeric | YES | 0 |
 |
| gonglishu | numeric | YES | 0 |
 |
| chefei | numeric | YES | 0 |
 |
| canfei | numeric | YES | 0 |
 |
| shengyufenpeikuan | numeric | YES | 0 |
 |
| chenyuantianshu | numeric | YES | 0 |
 |
| gongchengkuan | numeric | YES | 0 |
 |
| shijirixin | numeric | YES | 0 |
 |
| meigonglifeiyong | numeric | YES | 0 |
 |

### t_profeedback

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_profeedback_id_seq' |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| feedback | character varying | NO | NO字段 |
 |
| fbtime | timestamp without time zone | NO | NO字段 |
 |

### t_prographregistration

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_prographregistratio |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| fileno | character varying | YES | YES字段 |
 |
| filename | character varying | YES | 文件名称 |
 |
| figuredate | timestamp without time zone | YES | YES字段 |
 |
| filenum | bigint | YES | 0 |
 |
| tablenum | bigint | YES | 0 |
 |
| figurenum | bigint | YES | 0 |
 |
| filepath | character varying | YES | YES字段 |
 |
| creator | character varying | YES | YES字段 |
 |
| archiveidentification | bigint | YES | YES字段 |
 |
| doctype | character varying | YES | YES字段 |
 |
| graphno | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |

### t_proissueregistration

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_proissueregistratio |
 |
| documentno | character varying | YES | YES字段 |
 |
| filename | character varying | YES | 文件名称 |
 |
| receivingdepartment | character varying | YES | YES字段 |
 |
| issuingdate | timestamp without time zone | YES | YES字段 |
 |
| filepath | character varying | YES | YES字段 |
 |
| attachments | bigint | YES | 0 |
 |
| recipients | character varying | YES | YES字段 |
 |
| recycling | character varying | YES | YES字段 |
 |
| collectiondate | timestamp without time zone | YES | YES字段 |
 |
| doctype | character varying | YES | YES字段 |
 |

### t_project_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_project_yyup_id_seq |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| contractcode | character varying | YES | YES字段 |
 |
| customerservicecode | character varying | YES | YES字段 |
 |
| customername | character varying | YES | 客户名称 |
 |
| encryptionkey | character varying | YES | YES字段 |
 |
| projectsupervision | character varying | YES | YES字段 |
 |
| projectsize | character varying | YES | YES字段 |
 |
| subordinateindustry | character varying | YES | YES字段 |
 |
| subordinateindustrychild | character varying | YES | YES字段 |
 |
| productline | character varying | YES | YES字段 |
 |
| numbersites | character varying | YES | YES字段 |
 |
| cycle | character varying | YES | YES字段 |
 |
| outsourcinginformation | character varying | YES | YES字段 |
 |
| signbilltime | character varying | YES | YES字段 |
 |
| offerstandard | character varying | YES | YES字段 |
 |
| custommainproducts | character varying | YES | YES字段 |
 |
| progressstatus | character varying | YES | YES字段 |
 |
| issample | character varying | YES | YES字段 |
 |
| isprototype | character varying | YES | YES字段 |
 |
| isstrategy | character varying | YES | YES字段 |
 |
| iskey | character varying | YES | YES字段 |
 |
| salesproperty | character varying | YES | YES字段 |
 |
| moduleids | text | YES | YES字段 |
 |
| modulenames | text | YES | YES字段 |
 |
| databasename | character varying | YES | YES字段 |
 |
| databasesystemname | character varying | YES | YES字段 |
 |
| databasehardwarename | character varying | YES | YES字段 |
 |
| applicationsystemname | character varying | YES | YES字段 |
 |
| applicationhardwarename | character varying | YES | YES字段 |
 |
| networkname | character varying | YES | YES字段 |
 |
| planid | bigint | YES | 关联T_Plan表，标识所属计划 |
 |
| customeraddress | character varying | YES | YES字段 |
 |
| versionname | character varying | YES | YES字段 |
 |
| customerservicepass | character varying | YES | YES字段 |
 |
| temprojectid | bigint | YES | YES字段 |
 |

### t_projectbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| projectid | bigint | NO | nextval('t_projectbackup_proje |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| projectname | character | NO | 项目名称 |
 |
| projectdetail | character varying | NO | NO字段 |
 |
| acceptstandard | character varying | NO | NO字段 |
 |
| begindate | timestamp without time zone | NO | 计划开始日期 |
 |
| enddate | timestamp without time zone | NO | 计划结束日期 |
 |
| pmcode | character | YES | 项目经理编码 |
 |
| pmname | character | YES | 项目经理姓名 |
 |
| makedate | timestamp without time zone | NO | 记录创建时间 |
 |
| status | character varying | NO | 状态，记录当前处理阶段 |
 |
| parentid | bigint | NO | 父级记录ID，用于构建层级结构 |
 |
| budget | numeric | YES | 预算金额 |
 |
| finishpercent | bigint | YES | 完成百分比，0-100 |
 |
| manhour | numeric | YES | 计划工时（小时） |
 |
| mannumber | numeric | YES | YES字段 |
 |
| projecttype | character varying | YES | YES字段 |
 |
| projectamount | numeric | YES | 项目总金额 |
 |
| customerpmcode | character varying | YES | YES字段 |
 |
| customerpmname | character varying | YES | YES字段 |
 |
| statusvalue | character varying | YES | YES字段 |
 |
| projectclass | character | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |
| priority | character | YES | 优先级，如Normal/High/Low |
 |
| dianyadengji | character varying | YES | YES字段 |
 |
| jiakong | character varying | YES | YES字段 |
 |
| dianlan | character varying | YES | YES字段 |
 |
| wutan | character varying | YES | YES字段 |
 |
| danjia1 | numeric | YES | YES字段 |
 |
| danjia2 | numeric | YES | YES字段 |
 |
| projectaddress | character varying | YES | YES字段 |
 |
| customername | character varying | YES | 客户名称 |
 |
| yewulaiyuan | character varying | YES | YES字段 |
 |
| customerprojectcode | character varying | YES | YES字段 |
 |
| pingpai | character varying | YES | YES字段 |
 |
| jiantu | character varying | YES | YES字段 |
 |
| productname | character varying | YES | YES字段 |
 |
| secondprojectname | character varying | YES | YES字段 |
 |

### t_projectcase_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectcase_yyup_id |
 |
| projectid | character varying | YES | 关联T_Project表，标识所属项目 |
 |
| casename | character varying | YES | YES字段 |
 |
| casecode | character varying | YES | YES字段 |
 |
| documentname | character varying | YES | YES字段 |
 |
| documenturl | character varying | YES | YES字段 |
 |
| approvestate | character varying | YES | YES字段 |
 |
| approvedesc | text | YES | YES字段 |
 |
| approvetime | character varying | YES | YES字段 |
 |
| approvecode | character varying | YES | YES字段 |
 |

### t_projectcostincomeanalysisgeneralchart

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectcostincomean |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| yearnumber | bigint | YES | YES字段 |
 |
| monthnumber | bigint | YES | YES字段 |
 |
| currentmonthtotalcost | numeric | YES | YES字段 |
 |
| cumulativeactualtaxcost | numeric | YES | YES字段 |
 |
| cumulativeactualaftertaxcost | numeric | YES | YES字段 |
 |
| accumulationsettlement | numeric | YES | YES字段 |
 |

### t_projectcostmanage

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectcostmanage_i |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| code | character varying | YES | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| quantities | numeric | YES | YES字段 |
 |
| unit | character varying | YES | 计量单位 |
 |
| price | numeric | NO | 单价 |
 |
| total | numeric | YES | 合计金额 |
 |
| remark | text | YES | 备注说明 |
 |
| type | character varying | YES | 类型分类 |
 |
| creater | character varying | YES | YES字段 |
 |
| occurrencedate | timestamp without time zone | YES | now() |
 |

### t_projectcustomer

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectcustomer_id_ |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| customercode | character | YES | 客户编号 |
 |

### t_projectdatabase_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectdatabase_yyu |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| databasecode | character varying | YES | YES字段 |
 |
| databasename | character varying | YES | YES字段 |
 |
| databasetype | character varying | YES | YES字段 |
 |

### t_projectdatalink

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| host | character varying | YES | YES字段 |
 |
| databasename | character varying | YES | YES字段 |
 |
| loginno | character varying | YES | YES字段 |
 |
| password | character varying | YES | YES字段 |
 |

### t_projectdetailedlistofmonthlybonusamount

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectdetailedlist |
 |
| projectid | bigint | YES | 0 |
 |
| yearnumber | bigint | YES | 0 |
 |
| monthnumber | bigint | YES | 0 |
 |
| profit | numeric | YES | 0 |
 |
| clearing | character | YES | '0%'::bpchar |
 |
| returnmoney | numeric | YES | 0 |
 |
| qhse | numeric | YES | 0 |
 |
| progress | numeric | YES | 0 |
 |

### t_projectitembomversion

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectitembomversi |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| verid | bigint | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |

### t_projectlogo_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectlogo_yyup_id |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| logocode | character varying | YES | YES字段 |
 |
| logoname | character varying | YES | YES字段 |
 |
| logotype | character varying | YES | YES字段 |
 |

### t_projectmaterialpaymentapplicant

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| aoid | bigint | NO | nextval('t_projectmaterialpaym |
 |
| aoname | character varying | YES | YES字段 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| parta | character varying | YES | YES字段 |
 |
| partacontactinformation | character varying | YES | YES字段 |
 |
| paymentmethod | character varying | YES | YES字段 |
 |
| attachment | character | NO | NO字段 |
 |
| contractpaycondition | character varying | YES | YES字段 |
 |
| currenttotalpaymentamount | numeric | YES | 0 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |
| aleadytotalinvoice | numeric | YES | 0 |
 |
| shouldtotalinvoice | numeric | YES | 0 |
 |
| companyname | character varying | YES | ''::character varying |
 |
| projectid | bigint | YES | 0 |
 |
| bankname | character varying | YES | ''::character varying |
 |
| bankcode | character varying | YES | ''::character varying |
 |
| receiptvoucher | character varying | YES | ''::character varying |
 |
| usercode | character varying | YES | ''::character varying |
 |
| username | character varying | YES | ''::character varying |
 |
| createtime | timestamp without time zone | YES | now() |
 |
| status | character varying | YES | ''::character varying |
 |

### t_projectmaterialpaymentapplicantdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmaterialpaym |
 |
| aoid | bigint | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| goodscode | character | YES | 物品编码 |
 |
| goodsname | character varying | YES | 物品名称 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| spec | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| manufacture | character varying | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| amount | numeric | YES | 金额 |
 |
| sourcetype | character varying | YES | YES字段 |
 |
| sourceid | bigint | YES | YES字段 |
 |
| accountcode | character varying | YES | ''::character varying |
 |
| accountname | character varying | YES | ''::character varying |
 |
| brand | character varying | YES | ''::character varying |
 |

### t_projectmemberclass

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmemberclass_ |
 |
| gradeid | bigint | YES | YES字段 |
 |
| classname | character varying | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_projectmembergrade

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmembergrade_ |
 |
| gradename | character varying | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |

### t_projectmemberincome_jhkc

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmemberincome |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| membercode | character | YES | ''::bpchar |
 |
| membername | character | YES | ''::bpchar |
 |
| workhour | numeric | YES | 0 |
 |
| memberincome | numeric | YES | 0 |
 |

### t_projectmemberschedule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmemberschedu |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| yearmonth | timestamp without time zone | YES | YES字段 |
 |
| numberused | numeric | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| worktype | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| weeknum | bigint | YES | YES字段 |
 |
| humansubgroups | character varying | YES | YES字段 |
 |

### t_projectmemberschedulebase

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmemberschedu |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| worktype | character varying | YES | YES字段 |
 |
| yearmonth | timestamp without time zone | YES | YES字段 |
 |
| numberall | numeric | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |
| weeknum | bigint | YES | YES字段 |
 |
| humansubgroups | character varying | YES | YES字段 |
 |

### t_projectmemberstudent

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| gender | character | YES | YES字段 |
 |
| age | bigint | YES | YES字段 |
 |
| password | character | YES | YES字段 |
 |
| duty | character | YES | YES字段 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |
| officephone | character varying | YES | YES字段 |
 |
| mobilephone | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| workscope | text | YES | 工作职责范围 |
 |
| joindate | timestamp without time zone | YES | 入职日期 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| creatorcode | character | YES | YES字段 |
 |
| childdepartment | character varying | YES | YES字段 |
 |
| departname | character varying | YES | 部门名称 |
 |
| englishname | character varying | YES | 英文名称 |
 |
| nationality | character varying | YES | 国籍 |
 |
| nativeplace | character varying | YES | 籍贯 |
 |
| hukou | character varying | YES | YES字段 |
 |
| residency | character varying | YES | YES字段 |
 |
| maritalstatus | character varying | YES | YES字段 |
 |
| degree | character varying | YES | 学历 |
 |
| major | character varying | YES | 专业 |
 |
| graduateschool | character varying | YES | 毕业院校 |
 |
| idcard | character varying | YES | 身份证号码 |
 |
| bloodtype | character varying | YES | YES字段 |
 |
| height | bigint | YES | YES字段 |
 |
| language | character varying | YES | YES字段 |
 |
| urgencyperson | character varying | YES | 紧急联系人姓名 |
 |
| urgencycall | character varying | YES | 紧急联系电话 |
 |
| photourl | character varying | YES | 照片文件路径 |
 |
| comment | character varying | YES | 备注说明 |
 |
| introducer | character varying | YES | YES字段 |
 |
| introducerdepartment | character varying | YES | YES字段 |
 |
| introducerrelation | character varying | YES | YES字段 |
 |
| address | character varying | YES | 联系地址 |
 |
| birthday | timestamp without time zone | YES | YES字段 |
 |
| refusercode | character | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| usertype | character varying | YES | YES字段 |
 |
| userrtxcode | character varying | YES | YES字段 |
 |
| signpictureurl | character varying | YES | 签名图片路径 |
 |
| worktype | character varying | YES | YES字段 |
 |
| signpictureurl2 | character varying | YES | YES字段 |
 |
| signpictureurl3 | character varying | YES | YES字段 |
 |
| mdistyle | character varying | YES | YES字段 |
 |
| passwordshal | character varying | YES | YES字段 |
 |
| allowdevice | character | YES | 允许登录设备，ALL/PC/MOBILE |
 |
| jobtitle | character varying | YES | YES字段 |
 |
| ... | ... | ... | ... |

### t_projectmemberstudentattendance

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmemberstuden |
 |
| studentcode | character varying | YES | YES字段 |
 |
| studentname | character varying | YES | YES字段 |
 |
| attendancetime | character varying | YES | YES字段 |
 |
| isstudy | character varying | YES | YES字段 |
 |

### t_projectmemberstudentcare

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmemberstuden |
 |
| studentcode | character varying | YES | YES字段 |
 |
| studentname | character varying | YES | YES字段 |
 |
| checktime | timestamp without time zone | YES | 审核时间 |
 |
| checkcontent | character varying | YES | YES字段 |
 |
| actualage | character varying | YES | YES字段 |
 |
| weightkg | character varying | YES | YES字段 |
 |
| weightevaluation | character varying | YES | YES字段 |
 |
| heightcm | character varying | YES | YES字段 |
 |
| heightevaluation | character varying | YES | YES字段 |
 |
| eyesight | character varying | YES | YES字段 |
 |
| ear | character varying | YES | YES字段 |
 |
| nose | character varying | YES | YES字段 |
 |
| pharynxflat | character varying | YES | YES字段 |
 |
| heart | character varying | YES | YES字段 |
 |
| lung | character varying | YES | YES字段 |
 |
| liverspleen | character varying | YES | YES字段 |
 |
| genitals | character varying | YES | YES字段 |
 |
| hearingscreening | character varying | YES | YES字段 |
 |
| refractivescreening | character varying | YES | YES字段 |
 |
| hemoglobin | character varying | YES | YES字段 |
 |
| turnenzyme | character varying | YES | YES字段 |
 |
| hepatitisantigen | character varying | YES | YES字段 |
 |
| otherremark | character varying | YES | YES字段 |
 |
| physicianguidance | character varying | YES | YES字段 |
 |
| physiciansignature | character varying | YES | YES字段 |
 |

### t_projectmemberstudentcost

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmemberstuden |
 |
| studentcode | character | YES | YES字段 |
 |
| studentname | character | YES | YES字段 |
 |
| costproject | character varying | YES | YES字段 |
 |
| costdemial | numeric | YES | YES字段 |
 |
| collecttime | timestamp without time zone | YES | YES字段 |
 |
| creatusercode | character varying | YES | YES字段 |
 |
| wangfeepersemester | numeric | YES | 0 |
 |
| meals | numeric | YES | 0 |
 |
| activitycost | numeric | YES | 0 |
 |
| custodyafterclass | numeric | YES | 0 |
 |
| replacecosts | numeric | YES | 0 |
 |
| status | character varying | YES | 'UNFINISHED'::bpchar |
 |

### t_projectmemeberincome_jhkc

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmemeberincom |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| membercode | character | YES | ''::bpchar |
 |
| membername | character | YES | ''::bpchar |
 |
| workhour | numeric | YES | 0 |
 |
| memberincome | numeric | YES | 0 |
 |

### t_projectmodulerelated_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectmodulerelate |
 |
| productline | character varying | YES | YES字段 |
 |
| subordinateindustry | character varying | YES | YES字段 |
 |
| moduleids | text | YES | YES字段 |
 |
| modulenames | text | YES | YES字段 |
 |
| startamount | numeric | YES | 0 |
 |
| endamount | numeric | YES | 0 |
 |
| startpersonday | bigint | YES | 0 |
 |
| endpersonday | bigint | YES | 0 |
 |
| planid | bigint | YES | 关联T_Plan表，标识所属计划 |
 |

### t_projectofferstandard_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectofferstandar |
 |
| name | character varying | YES | 名称 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_projectoutsourcinformat_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectoutsourcinfo |
 |
| name | character varying | YES | 名称 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_projectplan_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectplan_yyup_id |
 |
| projectplanname | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_projectplanrelated_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectplanrelated_ |
 |
| planid | bigint | YES | 关联T_Plan表，标识所属计划 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |

### t_projectplanresources

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectplanresource |
 |
| projectrelateditemid | bigint | YES | YES字段 |
 |
| itemcode | character | YES | 物料编码 |
 |
| itemname | character varying | YES | 物料名称 |
 |
| itemtype | character varying | YES | YES字段 |
 |
| specification | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| brand | character varying | YES | YES字段 |
 |
| bomversionid | bigint | YES | YES字段 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| photourl | character varying | YES | 照片文件路径 |
 |

### t_projectprimavera

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectprimavera_id |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| begindate | timestamp without time zone | YES | 计划开始日期 |
 |
| enddate | timestamp without time zone | YES | 计划结束日期 |
 |
| makedate | timestamp without time zone | YES | 记录创建时间 |
 |
| guid | character varying | YES | YES字段 |
 |

### t_projectprimaverabudget

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectprimaverabud |
 |
| projbudgid | bigint | YES | YES字段 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| budgetamount | numeric | YES | YES字段 |
 |
| realamount | numeric | YES | YES字段 |
 |
| totalamount | numeric | YES | YES字段 |
 |
| projguid | character varying | YES | YES字段 |
 |
| p6id | bigint | YES | YES字段 |
 |
| taskid | bigint | YES | 关联T_ProjectTask表，标识所属任务 |
 |

### t_projectprimaveratask

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectprimaveratas |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| taskcode | character varying | YES | 任务编号，如TK202606210001 |
 |
| taskname | character varying | YES | 任务名称 |
 |
| begindate | timestamp without time zone | YES | 计划开始日期 |
 |
| enddate | timestamp without time zone | YES | 计划结束日期 |
 |
| createdate | timestamp without time zone | YES | 记录创建时间 |
 |
| taskguid | character varying | YES | YES字段 |
 |
| projguid | character varying | YES | YES字段 |
 |

### t_projectproduct_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectproduct_yyup |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| modulecode | character varying | YES | 模块编码 |
 |
| modulename | character varying | YES | 模块名称 |
 |
| moduletype | character varying | YES | YES字段 |
 |

### t_projectproductline_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectproductline_ |
 |
| name | character varying | YES | 名称 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_projectprogressstatus_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectprogressstat |
 |
| name | character varying | YES | 名称 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_projectrelateditembom

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectrelateditemb |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| parentguid | character varying | YES | YES字段 |
 |
| childguid | character varying | YES | YES字段 |
 |
| itemcode | character | YES | 物料编码 |
 |
| itemname | character varying | YES | 物料名称 |
 |
| number | numeric | YES | 0 |
 |
| unit | character | YES | 计量单位 |
 |
| verid | bigint | YES | 0 |
 |
| itemtype | character varying | YES | YES字段 |
 |
| specification | character varying | YES | YES字段 |
 |
| puleadtime | numeric | YES | 0 |
 |
| mfleadtime | numeric | YES | 0 |
 |
| hrcost | numeric | YES | 0 |
 |
| mtcost | numeric | YES | 0 |
 |
| mfcost | numeric | YES | 0 |
 |
| comment | character varying | YES | 备注说明 |
 |
| defaultprocess | character varying | YES | YES字段 |
 |
| reservednumber | numeric | YES | 0 |
 |
| modelnumber | character varying | YES | 0 |
 |
| photourl | character varying | YES | ''::character varying |
 |
| aleadypurchased | numeric | YES | 0 |
 |
| aleadycheckin | numeric | YES | 0 |
 |
| aleadyproduction | numeric | YES | 0 |
 |
| aleadycheckout | numeric | YES | 0 |
 |
| sortnumber | bigint | YES | 0 |
 |
| purchaseprice | numeric | YES | 0 |
 |
| saleprice | numeric | YES | 0 |
 |
| brand | character varying | YES | ''::character varying |
 |
| aleadypick | numeric | YES | 0 |
 |
| aleadysale | numeric | YES | 0 |
 |

### t_projectrisk

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectrisk_id_seq' |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| risk | character varying | YES | YES字段 |
 |
| detail | character varying | YES | YES字段 |
 |
| risklevel | character | YES | YES字段 |
 |
| effectdate | timestamp without time zone | YES | 生效日期 |
 |
| finddate | timestamp without time zone | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_projectsalesproperty_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectsalespropert |
 |
| name | character varying | YES | 名称 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_projectstatus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectstatus_id_se |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| reviewcontrol | character | YES | YES字段 |
 |
| projecttype | character varying | YES | YES字段 |
 |
| identitystring | character varying | YES | YES字段 |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| langcode | character | YES | ''::bpchar |
 |
| maketype | character varying | YES | 'DIY'::bpchar |
 |

### t_projectsubordinateindustry_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectsubordinatei |
 |
| name | character varying | YES | 名称 |
 |
| parentid | bigint | YES | 父级记录ID，用于构建层级结构 |
 |
| remark | character varying | YES | 备注说明 |
 |

### t_projectweeklywork

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| workid | bigint | NO | nextval('t_projectweeklywork_w |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| recorddate | timestamp without time zone | NO | NO字段 |
 |

### t_projectweeklyworkdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectweeklyworkde |
 |
| workid | bigint | NO | NO字段 |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | NO | 项目名称 |
 |
| workdate1 | timestamp without time zone | NO | NO字段 |
 |
| manhour1 | numeric | YES | YES字段 |
 |
| confirmmanhour1 | numeric | YES | YES字段 |
 |
| charge1 | numeric | YES | YES字段 |
 |
| confirmcharge1 | numeric | YES | YES字段 |
 |
| dailysummary1 | character varying | YES | YES字段 |
 |
| workdate2 | timestamp without time zone | NO | NO字段 |
 |
| manhour2 | numeric | YES | YES字段 |
 |
| confirmmanhou2 | numeric | YES | YES字段 |
 |
| dailysummary2 | character varying | YES | YES字段 |
 |
| workdate3 | timestamp without time zone | NO | NO字段 |
 |
| manhour3 | numeric | YES | YES字段 |
 |
| confirmmanhou3 | numeric | YES | YES字段 |
 |
| dailysummary3 | character varying | YES | YES字段 |
 |
| workdate4 | timestamp without time zone | NO | NO字段 |
 |
| manhour4 | numeric | YES | YES字段 |
 |
| confirmmanhou4 | numeric | YES | YES字段 |
 |
| dailysummary4 | character varying | YES | YES字段 |
 |
| workdate5 | timestamp without time zone | NO | NO字段 |
 |
| manhour5 | numeric | YES | YES字段 |
 |
| confirmmanhou5 | numeric | YES | YES字段 |
 |
| dailysummary5 | character varying | YES | YES字段 |
 |
| workdate6 | timestamp without time zone | NO | NO字段 |
 |
| manhour6 | numeric | YES | YES字段 |
 |
| confirmmanhou6 | numeric | YES | YES字段 |
 |
| dailysummary6 | character varying | YES | YES字段 |
 |
| workdate7 | timestamp without time zone | NO | NO字段 |
 |
| manhour7 | numeric | YES | YES字段 |
 |
| confirmmanhou7 | numeric | YES | YES字段 |
 |
| dailysummary7 | character varying | YES | YES字段 |
 |

### t_projectworkload_jhkc

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_projectworkload_jhk |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| worktype | character varying | NO | NO字段 |
 |
| gongzuoliang | numeric | YES | 0 |
 |
| danjia | numeric | YES | 0 |
 |

### t_projectwzdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| authorizedprocurement | character varying | YES | YES字段 |
 |
| abudgetfor | numeric | YES | YES字段 |
 |
| sincepurchasebudget | numeric | YES | YES字段 |
 |
| constructionunit | character varying | YES | YES字段 |
 |
| supervisionunit | character varying | YES | YES字段 |
 |
| leader | character varying | YES | YES字段 |
 |
| feemanage | character varying | YES | YES字段 |
 |
| materialperson | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |

### t_proleaderreview

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_proleaderreview_id_ |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| review | character varying | NO | NO字段 |
 |
| reviewtime | timestamp without time zone | NO | NO字段 |
 |

### t_promodule_backup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_promodule_backup_id |
 |
| modulename | character | YES | 模块名称 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| visible | character | YES | YES字段 |
 |
| moduletype | character varying | YES | YES字段 |
 |
| usertype | character varying | YES | ''::bpchar |
 |

### t_promodulelevelforpage

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_promodulelevelforpa |
 |
| modulename | character | YES | 模块名称 |
 |
| modulelabel | character varying | YES | ''::character varying |
 |
| homemodulename | character | YES | YES字段 |
 |
| iconurl | character varying | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| pagename | character varying | YES | 页面名称 |
 |
| usertype | character varying | YES | YES字段 |
 |
| parentmodule | character | YES | YES字段 |
 |
| visible | character | YES | YES字段 |
 |
| langcode | character | YES | 语言代码，如zh-CN/en-US |
 |
| isdeleted | character | YES | YES字段 |
 |
| moduletype | character varying | YES | 'system'::bpchar |
 |

### t_promodulelevelforpageuser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | integer | NO | nextval('t_promodulelevelforpa |
 |
| modulename | character | YES | 模块名称 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| usertype | character varying | YES | YES字段 |
 |
| visible | character | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| everyrowcolumnnumber | integer | YES | 2 |
 |

### t_proplanrelateddoc_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_proplanrelateddoc_y |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| planid | bigint | YES | 关联T_Plan表，标识所属计划 |
 |
| docid | bigint | YES | YES字段 |
 |
| verid | character varying | YES | YES字段 |
 |

### t_proreceiptregistration

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_proreceiptregistrat |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| documentno | character varying | YES | YES字段 |
 |
| filename | character varying | YES | 文件名称 |
 |
| creator | character varying | YES | YES字段 |
 |
| createdate | timestamp without time zone | YES | 记录创建时间 |
 |
| filepath | character varying | YES | YES字段 |
 |
| dispatchdepartment | character varying | YES | YES字段 |
 |
| fileway | character varying | YES | YES字段 |
 |
| destroypeople | character varying | YES | YES字段 |
 |
| destructiondate | timestamp without time zone | YES | YES字段 |
 |
| archiveidentification | bigint | YES | 0 |
 |
| doctype | character varying | YES | YES字段 |
 |

### t_prosendfigureregistration

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_prosendfigureregist |
 |
| fileno | character varying | YES | YES字段 |
 |
| filename | character varying | YES | 文件名称 |
 |
| issuedate | timestamp without time zone | YES | YES字段 |
 |
| recipients | character varying | YES | YES字段 |
 |
| distribution | character varying | YES | YES字段 |
 |
| figureplan | text | YES | YES字段 |
 |
| filenum | bigint | YES | 0 |
 |
| tablenum | bigint | YES | 0 |
 |
| figurenum | bigint | YES | 0 |
 |
| filepath | character varying | YES | YES字段 |
 |
| backper | character varying | YES | YES字段 |
 |
| backtime | timestamp without time zone | YES | YES字段 |
 |
| doctype | character varying | YES | YES字段 |
 |

### t_publicnotice

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| docid | bigint | NO | nextval('t_publicnotice_docid_ |
 |
| doctype | character varying | YES | YES字段 |
 |
| docname | character varying | YES | YES字段 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| address | character varying | YES | 联系地址 |
 |
| author | character | YES | YES字段 |
 |
| uploadmancode | character | YES | YES字段 |
 |
| uploadmanname | character | YES | YES字段 |
 |
| uploadtime | timestamp without time zone | YES | YES字段 |
 |
| relateddepartcode | character varying | YES | 关联部门编码 |
 |
| relateddepartname | character varying | YES | 关联部门名称 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| scope | character | YES | ''::bpchar |
 |

### t_qmengineerreview

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| purchasingcontractcode | character varying | YES | YES字段 |
 |
| purchasingcontractname | character varying | YES | YES字段 |
 |
| reviewcontent | text | YES | YES字段 |
 |
| supplier | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmengineerwarranty

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| brieflydescribe | text | YES | YES字段 |
 |
| notificationdate | timestamp without time zone | YES | YES字段 |
 |
| warrantydate | timestamp without time zone | YES | YES字段 |
 |
| purchasingcontractcode | character varying | YES | YES字段 |
 |
| purchasingcontractname | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmmatequinspection

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| purchasingcontractcode | character varying | YES | YES字段 |
 |
| purchasingcontractname | character varying | YES | YES字段 |
 |
| supplier | character varying | YES | YES字段 |
 |
| transportunit | character varying | YES | YES字段 |
 |
| receivingunit | character varying | YES | YES字段 |
 |
| inspectionresults | text | YES | YES字段 |
 |
| inspectionper | character varying | YES | YES字段 |
 |
| inspectiondate | timestamp without time zone | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmoverallevaluation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| purchasingcontractcode | character varying | YES | YES字段 |
 |
| purchasingcontractname | character varying | YES | YES字段 |
 |
| overallevaluation | text | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmpurchasingcontract

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| companycode | character varying | YES | YES字段 |
 |
| companyname | character varying | YES | YES字段 |
 |
| transportunit | character varying | YES | YES字段 |
 |
| receivingunit | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| isoverall | character varying | YES | YES字段 |
 |
| istechnicaldisclosure | character varying | YES | YES字段 |
 |
| qualityrepstatus | character varying | YES | YES字段 |
 |
| qualityinsstatus | character varying | YES | YES字段 |
 |
| qualitypennotstatus | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| createdate | timestamp without time zone | YES | 记录创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| relatedconstractcode | character varying | YES | ''::character varying |
 |
| relatedconstractname | character varying | YES | ''::character varying |
 |

### t_qmqualitydefectnotice

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| matequinscode | character varying | YES | YES字段 |
 |
| matequinsname | character varying | YES | YES字段 |
 |
| supplier | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| defectdescription | text | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| purchasingcontractcode | character | YES | ''::bpchar |
 |

### t_qmqualitydefectprocess

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| qualitydefectnoticecode | character varying | YES | YES字段 |
 |
| qualitydefectnoticename | character varying | YES | YES字段 |
 |
| dealremark | text | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmqualityinspection

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| examinationcontent | text | YES | YES字段 |
 |
| inspectiondate | timestamp without time zone | YES | YES字段 |
 |
| purchasingcontractcode | character varying | YES | YES字段 |
 |
| purchasingcontractname | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmqualityinspectionsheet

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| purchasingcontractcode | character varying | YES | YES字段 |
 |
| purchasingcontractname | character varying | YES | YES字段 |
 |
| acceptdate | timestamp without time zone | YES | YES字段 |
 |
| supplier | character varying | YES | YES字段 |
 |
| inspectionresults | text | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| dealresults | text | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmqualityrectification

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| headunit | character varying | YES | YES字段 |
 |
| responsibilityunit | character varying | YES | YES字段 |
 |
| rectificationnoticecode | character varying | YES | YES字段 |
 |
| rectificationnoticename | character varying | YES | YES字段 |
 |
| rectificationremark | text | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmqualityrectificationnotice

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| name | character varying | YES | 名称 |
 |
| responsibilityunit | character varying | YES | YES字段 |
 |
| inspectdate | timestamp without time zone | YES | YES字段 |
 |
| inspectionmembers | character varying | YES | YES字段 |
 |
| informcontent | text | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| qualityinspectioncode | character varying | YES | YES字段 |
 |
| qualityinspectionname | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmqualitytechnicaldisclosure

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| clarificationunit | character varying | YES | YES字段 |
 |
| acceptclariunit | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| disclosurecontent | text | YES | YES字段 |
 |
| purchasingcontractcode | character varying | YES | YES字段 |
 |
| purchasingcontractname | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmrewardpunishment

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| penunit | character varying | YES | YES字段 |
 |
| rewardspunishment | text | YES | YES字段 |
 |
| qualityinspectioncode | character varying | YES | YES字段 |
 |
| qualityinspectionname | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_qmsatisfactionsurvey

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| purchasingcontractcode | character varying | YES | YES字段 |
 |
| purchasingcontractname | character varying | YES | YES字段 |
 |
| supplier | character varying | YES | YES字段 |
 |
| satisfactiondegree | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| evaluationdate | timestamp without time zone | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createper | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_rcjprojectadjustpricelist

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectadjustpri |
 |
| adjustid | bigint | NO | NO字段 |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemno | bigint | NO | NO字段 |
 |
| itemtype | bigint | NO | NO字段 |
 |
| itempricedeviceadjust | money | NO | NO字段 |
 |
| itempricemainmaterialadjust | money | NO | NO字段 |
 |
| itempricewageadjust | money | NO | NO字段 |
 |
| itempricematerialadjust | money | NO | NO字段 |
 |
| itempricemachineadjust | money | NO | NO字段 |
 |
| projectbcws | money | NO | NO字段 |
 |
| itemnum | double precision | NO | NO字段 |
 |
| memo | character varying | NO | NO字段 |
 |
| bcwp | double precision | NO | 0 |
 |
| bcrwp | double precision | NO | 0 |
 |
| pbcwp | double precision | NO | 0 |
 |
| itempricedevicebudget | money | YES | YES字段 |
 |
| itempricemainmaterialbudget | money | YES | YES字段 |
 |
| itempricewagebudget | money | YES | YES字段 |
 |
| itempricematerialbudget | money | YES | YES字段 |
 |
| itempricemachinebudget | money | YES | YES字段 |
 |
| itempricepurchasefee | money | YES | YES字段 |
 |
| itempricepurchasefeebudget | money | YES | YES字段 |
 |
| itemcomprehensivefeebudget | money | YES | YES字段 |
 |
| itemtaxesbudget | money | YES | YES字段 |
 |

### t_rcjprojectadjustpricelog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectadjustpri |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemno | bigint | NO | NO字段 |
 |
| itemtype | character varying | NO | NO字段 |
 |
| itempricedeviceadjust | money | NO | NO字段 |
 |
| itempricemainmaterialadjust | money | NO | NO字段 |
 |
| itempricewageadjust | money | NO | NO字段 |
 |
| itempricematerialadjust | money | NO | NO字段 |
 |
| itempricemachineadjust | money | NO | NO字段 |
 |
| projectbcws | money | NO | NO字段 |
 |
| itemnum | double precision | NO | NO字段 |
 |
| memo | character varying | NO | NO字段 |
 |
| adjustbywho | character varying | NO | NO字段 |
 |
| adjustmemo | character varying | YES | YES字段 |
 |
| bcwp | double precision | NO | 0 |
 |
| bcrwp | double precision | NO | 0 |
 |
| pbcwp | double precision | NO | 0 |
 |
| adjusttime | timestamp without time zone | YES | YES字段 |
 |

### t_rcjprojectcostfeeids

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectcostfeeid |
 |
| feetype | smallint | NO | NO字段 |
 |
| title | character varying | NO | 标题 |
 |

### t_rcjprojectcostfees

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectcostfees_ |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| feeid | bigint | NO | NO字段 |
 |
| feesubid | bigint | NO | NO字段 |
 |
| originalcost | money | YES | YES字段 |
 |
| actualcost | money | YES | YES字段 |
 |
| targetcost | money | YES | YES字段 |
 |
| datasource | character varying | YES | YES字段 |
 |
| departno | bigint | YES | YES字段 |
 |

### t_rcjprojectcostfeesubids

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectcostfeesu |
 |
| costfeeid | bigint | NO | NO字段 |
 |
| isfixed | smallint | NO | NO字段 |
 |
| subtitle | character varying | NO | NO字段 |
 |

### t_rcjprojectcostperformancebenchmar

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectcostperfo |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemno | bigint | NO | NO字段 |
 |
| itemtype | bigint | NO | NO字段 |
 |
| itempricedeviceactual | money | NO | 0 |
 |
| itempricematerialactual | money | NO | 0 |
 |
| itempricemainmaterialactual | money | NO | 0 |
 |
| itempricewageactual | money | NO | 0 |
 |
| itempricemachineactual | money | NO | 0 |
 |
| itemcomprehensivefeeactual | money | NO | 0 |
 |
| itemtaxesactual | money | NO | 0 |
 |
| itempricetotalactual | money | NO | 0 |
 |
| projectplancompletebalance | money | NO | 0 |
 |
| projectbcrwp | money | NO | 0 |
 |
| projectai | double precision | NO | 0 |
 |
| projecteav | money | NO | 0 |
 |
| projectpbcwp | money | NO | 0 |
 |
| projectrv | money | NO | 0 |
 |
| projectrvi | double precision | NO | 0 |
 |
| totalwork | double precision | NO | 0 |
 |
| totalconfirmwork | double precision | NO | 0 |
 |
| projectyear | bigint | NO | 0 |
 |
| projectmonth | bigint | NO | 0 |
 |
| bcws | double precision | NO | 0 |
 |
| itemnum | double precision | NO | 0 |
 |
| itempricedevicebudget | money | YES | YES字段 |
 |
| itempricemainmaterialbudget | money | YES | YES字段 |
 |
| itempricewagebudget | money | YES | YES字段 |
 |
| itempricematerialbudget | money | YES | YES字段 |
 |
| itempricemachinebudget | money | YES | YES字段 |
 |
| itempricepurchasefee | money | YES | YES字段 |
 |
| itempricepurchasefeebudget | money | YES | YES字段 |
 |
| itemcomprehensivefeebudget | money | YES | YES字段 |
 |
| itemtaxesbudget | money | YES | YES字段 |
 |

### t_rcjprojectcostperformancelist

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectcostperfo |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemno | bigint | NO | NO字段 |
 |
| itemtype | bigint | NO | NO字段 |
 |
| itemname | character varying | NO | 物料名称 |
 |
| itemcontent | character varying | NO | NO字段 |
 |
| itemunit | character | NO | NO字段 |
 |
| itempricedevice | money | NO | NO字段 |
 |
| itempricemainmaterial | money | NO | NO字段 |
 |
| itempricewage | money | NO | NO字段 |
 |
| itempricematerial | money | NO | NO字段 |
 |
| itempricemachine | money | NO | NO字段 |
 |
| adjustid | bigint | NO | NO字段 |
 |
| itempricechanged | bigint | NO | NO字段 |
 |
| projectsupplierid | character varying | NO | NO字段 |
 |
| ifsplit | bigint | NO | NO字段 |
 |
| begintime | date | YES | YES字段 |
 |
| endtime | date | YES | YES字段 |
 |
| subitem | character varying | YES | YES字段 |
 |

### t_rcjprojectcostpreformancetype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectcostprefo |
 |
| typecode | bigint | NO | NO字段 |
 |
| typename | character varying | NO | NO字段 |
 |

### t_rcjprojectfundstartplan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectfundstart |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| amount | money | NO | 金额 |
 |
| purpose | character varying | NO | NO字段 |
 |
| costfeeid | bigint | NO | NO字段 |
 |
| costfeesubid | bigint | NO | NO字段 |
 |
| classid | bigint | YES | YES字段 |
 |
| budgettime | character varying | YES | YES字段 |
 |
| amountlevel | money | YES | YES字段 |
 |
| isreviewed | smallint | YES | YES字段 |
 |
| actualamount | money | YES | YES字段 |
 |
| operatetime | timestamp without time zone | YES | YES字段 |
 |
| memo | character varying | YES | YES字段 |
 |

### t_rcjprojectfundstartplanapprove

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectfundstart |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| fundplanid | bigint | NO | NO字段 |
 |
| approverer | character varying | NO | NO字段 |
 |
| ifagreed | smallint | NO | NO字段 |
 |
| actualamount | money | YES | YES字段 |
 |
| approvetime | timestamp without time zone | NO | NO字段 |
 |
| memo | character varying | YES | YES字段 |
 |

### t_rcjprojectmonthcostfee

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectmonthcost |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| costfeeid | bigint | NO | NO字段 |
 |
| costfeesubid | bigint | NO | NO字段 |
 |
| workyear | bigint | YES | YES字段 |
 |
| workmonth | bigint | NO | NO字段 |
 |
| feemoney | money | NO | NO字段 |
 |
| inputuser | character varying | NO | NO字段 |
 |
| lasttime | timestamp without time zone | NO | NO字段 |
 |
| memo | character varying | YES | YES字段 |
 |

### t_rcjprojectsetup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectsetup_id_ |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| ismonthplan | smallint | NO | NO字段 |
 |

### t_rcjprojectsummaryperformance

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectsummarype |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| projectyear | bigint | NO | date_part('year'::text, now()) |
 |
| projectmonth | bigint | NO | date_part('month'::text, now() |
 |
| projectstcv | money | NO | 0 |
 |
| projectbcws | money | NO | 0 |
 |
| projectbcwp | money | NO | 0 |
 |
| projectbcrwp | money | NO | 0 |
 |
| projectpbcwp | money | NO | 0 |
 |
| projecteav | money | NO | 0 |
 |
| projectrv | money | NO | 0 |
 |
| projectacwp | money | NO | 0 |
 |
| projectai | double precision | NO | 0 |
 |
| projectbvi | money | NO | 0 |
 |
| projectbv | money | NO | 0 |
 |
| projectrvi | money | NO | NO字段 |
 |
| projectpl | money | NO | 0 |
 |
| projectrp | money | NO | 0 |
 |
| projecttotalspending | money | NO | 0 |
 |
| projecttotalincome | money | NO | 0 |
 |
| projectincomedifference | money | NO | 0 |
 |
| projectcontractreceived | money | NO | 0 |
 |
| projectcpb | double precision | NO | 0 |
 |
| projectcfi | double precision | NO | 0 |
 |
| thismonthfinished | double precision | NO | 0 |
 |
| totalmonthfinished | double precision | NO | 0 |
 |
| projectsv | money | YES | YES字段 |
 |
| projectspi | double precision | YES | YES字段 |
 |

### t_rcjprojecttargetcostfee

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojecttargetcos |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| costfeeid | bigint | NO | NO字段 |
 |
| costfeesubid | bigint | NO | NO字段 |
 |
| costtype | smallint | NO | NO字段 |
 |
| originalcost | money | YES | YES字段 |
 |
| actualcost | money | YES | YES字段 |
 |
| targetcost | money | YES | YES字段 |
 |
| inputuser | character | YES | YES字段 |
 |
| lasttime | timestamp without time zone | YES | YES字段 |
 |

### t_rcjprojecttotalsummaryperformance

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojecttotalsumm |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| projectstcv | money | YES | YES字段 |
 |
| projectbcws | money | YES | YES字段 |
 |
| projectbcwp | money | YES | YES字段 |
 |
| projectbcrwp | money | YES | YES字段 |
 |
| projectpbcwp | money | YES | YES字段 |
 |
| projecteav | money | YES | YES字段 |
 |
| projectrv | money | YES | YES字段 |
 |
| projectacwp | money | YES | YES字段 |
 |
| projectai | double precision | YES | YES字段 |
 |
| projectbvi | money | YES | YES字段 |
 |
| projectbv | money | YES | YES字段 |
 |
| projectrvi | money | YES | YES字段 |
 |
| projectpl | money | YES | YES字段 |
 |
| projectrp | money | YES | YES字段 |
 |
| projecttotalspending | money | YES | YES字段 |
 |
| projecttotalincome | money | YES | YES字段 |
 |
| projectincomedifference | money | YES | YES字段 |
 |
| projectcontractreceived | money | YES | YES字段 |
 |
| projectcpb | double precision | YES | YES字段 |
 |
| projectcfi | double precision | YES | YES字段 |
 |
| projectsv | money | YES | YES字段 |
 |
| projectspi | double precision | YES | YES字段 |
 |

### t_rcjprojectworkconfirm

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectworkconfi |
 |
| workconfirmid | bigint | NO | NO字段 |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemtype | bigint | NO | NO字段 |
 |
| itemno | bigint | NO | NO字段 |
 |
| workyear | bigint | YES | YES字段 |
 |
| workmonth | bigint | NO | NO字段 |
 |
| worknum | double precision | NO | NO字段 |
 |
| itempricedeviceadjust | money | NO | NO字段 |
 |
| itempricemainmaterialadjust | money | NO | NO字段 |
 |
| itempricepurchasefeeadjust | money | YES | YES字段 |
 |
| itempricewageadjust | money | NO | NO字段 |
 |
| itempricematerialadjust | money | NO | NO字段 |
 |
| itempricemachineadjust | money | NO | NO字段 |
 |
| comprehensivepriceadjust | money | NO | NO字段 |
 |
| taxespriceadjust | money | NO | NO字段 |
 |
| itempricedeviceactual | money | NO | NO字段 |
 |
| itempricematerialactual | money | NO | NO字段 |
 |
| itempricemainmaterialactual | money | NO | NO字段 |
 |
| itempricepurchasefeeactual | money | NO | NO字段 |
 |
| itempricewageactual | money | NO | NO字段 |
 |
| itempricemachineactual | money | NO | NO字段 |
 |
| itemcomprehensivefeeactual | money | NO | NO字段 |
 |
| itemtaxesactual | money | NO | NO字段 |
 |
| itempricetotalactual | money | NO | NO字段 |
 |
| projectbcrwp | money | YES | 0 |
 |
| projectpbcwp | money | YES | YES字段 |
 |
| adjustid | bigint | YES | YES字段 |
 |
| curyear | bigint | YES | YES字段 |
 |
| curmonth | bigint | YES | YES字段 |
 |

### t_rcjprojectworkconfirmlog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectworkconfi |
 |
| workconfirmid | bigint | NO | NO字段 |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemtype | bigint | NO | NO字段 |
 |
| itemno | bigint | NO | NO字段 |
 |
| workyear | bigint | YES | YES字段 |
 |
| workmonth | bigint | NO | NO字段 |
 |
| worknum | double precision | NO | NO字段 |
 |
| itempricedeviceadjust | money | NO | NO字段 |
 |
| itempricemainmaterialadjust | money | NO | NO字段 |
 |
| itempricepurchasefeeadjust | money | YES | YES字段 |
 |
| itempricewageadjust | money | NO | NO字段 |
 |
| itempricematerialadjust | money | NO | NO字段 |
 |
| itempricemachineadjust | money | NO | NO字段 |
 |
| comprehensivepriceadjust | money | NO | NO字段 |
 |
| taxespriceadjust | money | NO | NO字段 |
 |
| itempricedeviceactual | money | NO | NO字段 |
 |
| itempricematerialactual | money | NO | NO字段 |
 |
| itempricemainmaterialactual | money | NO | NO字段 |
 |
| itempricepurchasefeeactual | money | NO | NO字段 |
 |
| itempricewageactual | money | NO | NO字段 |
 |
| itempricemachineactual | money | NO | NO字段 |
 |
| itemcomprehensivefeeactual | money | NO | NO字段 |
 |
| itemtaxesactual | money | NO | NO字段 |
 |
| itempricetotalactual | money | NO | NO字段 |
 |
| projectbcrwp | money | YES | YES字段 |
 |
| changedbywho | character varying | NO | NO字段 |
 |
| changedtime | character varying | NO | NO字段 |
 |
| changedmemo | character varying | NO | NO字段 |
 |
| adjustid | bigint | YES | YES字段 |
 |

### t_rcjprojectworkdetails

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectworkdetai |
 |
| workconfirmid | bigint | NO | NO字段 |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemtype | character varying | NO | NO字段 |
 |
| itemno | bigint | NO | NO字段 |
 |
| adjustid | bigint | NO | 0 |
 |
| workyear | bigint | NO | 0 |
 |
| workmonth | bigint | NO | NO字段 |
 |
| worknum | double precision | NO | NO字段 |
 |
| comfirmpercent | double precision | NO | 0 |
 |
| recievepercent | double precision | NO | 0 |
 |
| bcwp | double precision | YES | YES字段 |
 |
| bcrwp | double precision | YES | YES字段 |
 |
| pbcwp | double precision | YES | YES字段 |
 |
| curyear | bigint | YES | YES字段 |
 |
| curmonth | bigint | YES | YES字段 |
 |

### t_rcjprojectworkdetailslog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectworkdetai |
 |
| workconfirmid | bigint | NO | NO字段 |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemtype | bigint | NO | NO字段 |
 |
| itemno | bigint | NO | NO字段 |
 |
| adjustid | bigint | NO | 0 |
 |
| workyear | bigint | NO | 0 |
 |
| workmonth | bigint | NO | NO字段 |
 |
| worknum | double precision | NO | NO字段 |
 |
| changedbywho | character varying | NO | NO字段 |
 |
| changedtime | character varying | NO | NO字段 |
 |
| changedmemo | character varying | NO | NO字段 |
 |
| bcwp | money | YES | YES字段 |
 |

### t_rcjprojectworkmoney

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectworkmoney |
 |
| workconfirmid | bigint | NO | NO字段 |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemtype | bigint | NO | NO字段 |
 |
| itemno | bigint | NO | NO字段 |
 |
| workyear | bigint | YES | YES字段 |
 |
| workmonth | bigint | NO | NO字段 |
 |
| moneynum | double precision | NO | NO字段 |
 |
| approveid | bigint | YES | YES字段 |
 |
| adjustid | bigint | YES | YES字段 |
 |
| curyear | bigint | YES | YES字段 |
 |
| curmonth | bigint | YES | YES字段 |
 |

### t_rcjprojectworkmoneylog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rcjprojectworkmoney |
 |
| workconfirmid | bigint | NO | NO字段 |
 |
| projectid | bigint | NO | 关联T_Project表，标识所属项目 |
 |
| itemtype | bigint | NO | NO字段 |
 |
| itemno | bigint | NO | NO字段 |
 |
| workyear | bigint | YES | YES字段 |
 |
| workmonth | bigint | NO | NO字段 |
 |
| moneynum | double precision | NO | NO字段 |
 |
| changedbywho | character varying | NO | NO字段 |
 |
| changedtime | character varying | NO | NO字段 |
 |
| changedmemo | character varying | NO | NO字段 |
 |
| adjustid | bigint | YES | YES字段 |
 |

### t_recrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| smsindex | bigint | NO | nextval('t_recrecord_smsindex_ |
 |
| sourcenumber | character varying | NO | NO字段 |
 |
| content | character varying | YES | 内容详情 |
 |
| senttime | timestamp without time zone | NO | NO字段 |
 |
| commport | smallint | NO | NO字段 |
 |
| msgtype | character varying | YES | 0 |
 |

### t_registeruser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_registeruser_id_seq |
 |
| username | character | YES | 用户姓名 |
 |
| company | character varying | YES | YES字段 |
 |
| duty | character varying | YES | YES字段 |
 |
| province | character varying | YES | YES字段 |
 |
| phonenumber | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| registertime | timestamp without time zone | YES | YES字段 |
 |
| mark | character varying | YES | YES字段 |
 |
| password | character varying | YES | YES字段 |
 |
| sendnumber | bigint | YES | 0 |
 |
| loginnumber | bigint | YES | 0 |
 |
| lastlogontime | timestamp without time zone | YES | now() |
 |
| randomnumber | bigint | YES | YES字段 |
 |

### t_relatedactorgroup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_relatedactorgroup_i |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | NO | 关联业务ID |
 |
| actorgroupname | character | NO | NO字段 |
 |

### t_relatedbusinessform

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_relatedbusinessform |
 |
| relatedtype | character varying | YES | ''::bpchar |
 |
| relatedid | bigint | YES | 0 |
 |
| temname | character varying | YES | ''::character varying |
 |
| xsnfile | character varying | YES | ''::character varying |
 |
| xmlfile | character varying | YES | ''::character varying |
 |
| wfxmldata | xml | YES | ''::xml |
 |
| operatorcode | character | YES | ''::bpchar |
 |
| operatorname | character | YES | ''::bpchar |
 |
| createtime | timestamp without time zone | YES | now() |
 |
| allowupdate | character | YES | 'YES'::bpchar |
 |

### t_relateddefect

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_relateddefect_id_se |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| defectid | bigint | YES | 关联T_Defectment表，标识所属缺陷 |
 |

### t_relatedschedule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_relatedschedule_id_ |
 |
| planid | bigint | YES | 关联T_Plan表，标识所属计划 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |

### t_relateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_relateduser_id_seq' |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| actor | character | YES | YES字段 |
 |
| joindate | timestamp without time zone | YES | 入职日期 |
 |
| workdetail | character varying | YES | YES字段 |
 |
| unithoursalary | numeric | YES | YES字段 |
 |
| actorgroup | character varying | YES | YES字段 |
 |
| smscount | bigint | YES | 0 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| parentid | bigint | YES | 0 |
 |
| salarymethod | character varying | YES | YES字段 |
 |
| promissionscale | numeric | YES | 0 |
 |
| canupdateplan | character | YES | 'NO'::bpchar |
 |
| leavedate | timestamp without time zone | YES | now() |
 |

### t_relateduserbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_relateduserbackup_i |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| project | character varying | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| actor | character | YES | YES字段 |
 |
| joindate | timestamp without time zone | YES | 入职日期 |
 |
| workdetail | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| actorgroup | character varying | YES | YES字段 |
 |

### t_relatedworkflowtemplate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_relatedworkflowtemp |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | NO | 关联业务ID |
 |
| wftemplatename | character varying | NO | NO字段 |
 |
| identifystring | character varying | YES | YES字段 |
 |
| relatedname | character varying | YES | ''::character varying |
 |

### t_rentproducttype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character | NO | 类型分类 |
 |
| entype | character | YES | YES字段 |
 |
| demourl | character | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| hometypename | character | YES | ''::bpchar |
 |
| langcode | character | YES | ''::bpchar |
 |
| id | integer | NO | nextval('t_rentproducttype_id_ |
 |

### t_rentproductvertype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| hometypename | character | YES | ''::bpchar |
 |
| langcode | character | YES | ''::bpchar |
 |
| id | integer | NO | nextval('t_rentproductvertype_ |
 |

### t_rentsitebasedata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rentsitebasedata_id |
 |
| rentproductname | character varying | YES | YES字段 |
 |
| rentproductversion | character varying | YES | YES字段 |
 |
| siteurl | character varying | YES | YES字段 |
 |
| sitebindinginfo | character | YES | YES字段 |
 |
| sitedirectory | character varying | YES | YES字段 |
 |
| sitetemplatedirectory | character | YES | YES字段 |
 |
| sitevirtualdirectoryphysicalpath | character varying | YES | YES字段 |
 |
| sitedbrestorefile | character varying | YES | YES字段 |
 |
| sitedbsetupdirectory | character varying | YES | YES字段 |
 |
| sitedbloginuserid | character varying | YES | YES字段 |
 |
| isautobuildsite | character varying | YES | YES字段 |
 |
| sitecreatorappname | character varying | YES | ''::character varying |
 |
| iscanuse | character varying | YES | 'YES'::character varying |
 |
| rentproducttype | character varying | YES | ''::character varying |
 |
| outersiteurl | character | YES | ''::bpchar |
 |

### t_rentsiteinfobycustomer

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rentsiteinfobycusto |
 |
| rentuserphonenumber | character varying | YES | YES字段 |
 |
| rentuseremail | character varying | YES | ''::character varying |
 |
| rentusername | character varying | YES | YES字段 |
 |
| rentproductname | character varying | YES | YES字段 |
 |
| rentusercompanyname | character varying | YES | YES字段 |
 |
| rentproductversion | character varying | YES | YES字段 |
 |
| rentusernumber | character varying | YES | YES字段 |
 |
| siteappsystemname | character varying | YES | ''::character varying |
 |
| siteappname | character varying | YES | YES字段 |
 |
| siteappurl | character varying | YES | YES字段 |
 |
| sitename | character varying | YES | YES字段 |
 |
| siteurl | character varying | YES | YES字段 |
 |
| sitebindinginfo | character | YES | YES字段 |
 |
| sitedirectory | character varying | YES | YES字段 |
 |
| sitetemplatedirectory | character | YES | YES字段 |
 |
| sitevirtualdirectoryname | character varying | YES | YES字段 |
 |
| sitevirtualdirectoryphysicalpath | character varying | YES | YES字段 |
 |
| sitedbname | character varying | YES | YES字段 |
 |
| sitedbrestorefile | character varying | YES | YES字段 |
 |
| sitedbsetupdirectory | character varying | YES | YES字段 |
 |
| sitedbloginuserid | character varying | YES | YES字段 |
 |
| sitedbuserloginpassword | character varying | YES | YES字段 |
 |
| sitecreatorname | character varying | YES | YES字段 |
 |
| sitecreatetime | timestamp without time zone | YES | YES字段 |
 |
| sitestatus | character varying | YES | ''::bpchar |
 |
| customerquestionid | bigint | YES | 0 |
 |
| servertype | character varying | YES | ''::character varying |
 |
| buycapacity | numeric | YES | 0 |
 |
| currentcapacity | numeric | YES | 0 |
 |
| isoem | character | YES | 'YES'::bpchar |
 |

### t_reportrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_reportrelateduser_i |
 |
| reportid | bigint | YES | 0 |
 |
| usercode | character | YES | ''::bpchar |
 |
| username | character | YES | ''::bpchar |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_reqstatus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_reqstatus_id_seq':: |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| langcode | character | YES | ''::bpchar |
 |
| maketype | character varying | YES | 'DIY'::bpchar |
 |

### t_reqtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_rtxaccountdata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_rtxaccountdata_id_s |
 |
| rtxcode | character | YES | ''::bpchar |
 |
| usercode | character | YES | ''::bpchar |
 |
| username | character | YES | ''::bpchar |
 |
| departnamestring | character varying | YES | ''::character varying |
 |
| rtxnumber | character | YES | 'null'::bpchar |
 |
| email | character varying | YES | ''::character varying |
 |
| mbphonenumber | character varying | YES | ''::character varying |
 |

### t_rtxconfig

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| serverip | character varying | NO | NO字段 |
 |
| serverport | bigint | YES | 0 |
 |
| website | character varying | YES | ''::character varying |
 |

### t_saletype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_schedule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | character | NO | nextval('t_schedule_id_seq'::r |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| createdate | timestamp without time zone | YES | 记录创建时间 |
 |
| name | character varying | YES | 名称 |
 |
| detail | character varying | YES | YES字段 |
 |
| start | timestamp without time zone | YES | YES字段 |
 |
| end | timestamp without time zone | YES | YES字段 |
 |
| allday | bit | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| realtedid | bigint | YES | 0 |
 |
| relatedtype | character varying | YES | 'other'::bpchar |
 |
| color | character | YES | YES字段 |
 |
| column | character | YES | YES字段 |
 |

### t_scheduleevent_leaderreview

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| reviewid | bigint | NO | nextval('t_scheduleevent_leade |
 |
| scheduleid | bigint | NO | NO字段 |
 |
| leadercode | character | YES | YES字段 |
 |
| leadername | character | YES | YES字段 |
 |
| reviewtime | timestamp without time zone | YES | YES字段 |
 |
| review | text | YES | YES字段 |
 |
| scoring | numeric | YES | YES字段 |
 |

### t_scheduleevent_leaderreviewbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| reviewid | bigint | NO | NO字段 |
 |
| scheduleid | bigint | NO | NO字段 |
 |
| leadercode | character | YES | YES字段 |
 |
| leadername | character | YES | YES字段 |
 |
| reviewtime | timestamp without time zone | YES | YES字段 |
 |
| review | text | YES | YES字段 |
 |
| scoring | numeric | YES | YES字段 |
 |

### t_scheduleeventbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| name | character varying | YES | 名称 |
 |
| eventstart | timestamp without time zone | NO | NO字段 |
 |
| eventend | timestamp without time zone | NO | NO字段 |
 |
| resource | character varying | YES | YES字段 |
 |
| allday | bit | NO | NO字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| eventcontent | text | YES | YES字段 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |

### t_schedulelimiteddays

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| limiteddays | bigint | NO | 0 |
 |
| keystatus | character varying | YES | 'YES'::bpchar |
 |

### t_sendtask

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| taskid | bigint | NO | nextval('t_sendtask_taskid_seq |
 |
| destnumber | character varying | NO | NO字段 |
 |
| content | character varying | YES | 内容详情 |
 |
| signname | character varying | YES | YES字段 |
 |
| sendpriority | smallint | YES | 16 |
 |
| sendtime | timestamp without time zone | YES | now() |
 |
| statusreport | smallint | YES | 0 |
 |
| englishflag | smallint | YES | 0 |
 |
| msgtype | character varying | YES | 0 |
 |
| pushurl | character varying | YES | YES字段 |
 |
| recaction | smallint | YES | 0 |
 |
| validminute | bigint | YES | 0 |
 |
| sendflag | smallint | YES | 0 |
 |
| commport | smallint | YES | 0 |
 |
| splitcount | smallint | YES | 0 |
 |
| batchid | character varying | YES | YES字段 |
 |

### t_sentrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| msgid | bigint | NO | NO字段 |
 |
| splitindex | smallint | YES | 1 |
 |
| desttel | character varying | NO | NO字段 |
 |
| content | character varying | YES | 内容详情 |
 |
| sentstatus | smallint | YES | 12 |
 |
| senttime | timestamp without time zone | NO | NO字段 |
 |
| commport | smallint | NO | NO字段 |
 |
| batchid | character varying | YES | YES字段 |
 |

### t_sitecustomerserviceoperator

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| website | character | NO | NO字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_sitemodulecontent

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_sitemodulecontent_i |
 |
| modulename | character | YES | 模块名称 |
 |
| content | text | YES | 内容详情 |
 |
| publishercode | character | YES | 发布人编码 |
 |
| publishername | character | YES | 发布人姓名 |
 |
| publishtime | timestamp without time zone | YES | 发布时间 |
 |
| langcode | character | YES | 语言代码，如zh-CN/en-US |
 |
| title | character varying | YES | ''::character varying |
 |

### t_smscode

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_smscode_id_seq'::re |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| randomcode | character varying | YES | YES字段 |
 |
| sendtime | timestamp without time zone | YES | 发送时间 |
 |

### t_smsinterface

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_smsinterface_id_seq |
 |
| spname | character varying | YES | YES字段 |
 |
| spinterface | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_smsnetsegment

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_smsnetsegment_id_se |
 |
| beginsegment | character varying | YES | YES字段 |
 |
| endsegment | character varying | YES | YES字段 |
 |

### t_smsrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_smsrelateduser_id_s |
 |
| smsid | bigint | NO | NO字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |

### t_smssenddiy

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_smssenddiy_id_seq': |
 |
| message | character | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| sendtime | timestamp without time zone | YES | now() |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_softdownload

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_softdownload_id_seq |
 |
| softname | character varying | YES | YES字段 |
 |
| versionnumber | character | YES | YES字段 |
 |
| savepath | character varying | YES | YES字段 |
 |
| uploadtime | timestamp without time zone | YES | YES字段 |
 |

### t_statusrelatedwf

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_statusrelatedwf_id_ |
 |
| relatedtype | character varying | NO | 关联业务类型 |
 |
| relatedid | bigint | NO | 关联业务ID |
 |
| status | character varying | NO | 状态，记录当前处理阶段 |
 |
| wlid | bigint | NO | NO字段 |
 |
| createtime | timestamp without time zone | NO | 创建时间 |
 |

### t_supplierassetpaymentapplicant

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| aoid | bigint | NO | nextval('t_supplierassetpaymen |
 |
| aoname | character varying | YES | YES字段 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| parta | character varying | YES | YES字段 |
 |
| partacontactinformation | character varying | YES | YES字段 |
 |
| paymentmethod | character varying | YES | YES字段 |
 |
| attachment | character | NO | NO字段 |
 |
| contractpaycondition | character varying | YES | YES字段 |
 |
| currenttotalpaymentamount | numeric | YES | YES字段 |
 |
| currencytype | character varying | YES | 币种类型，如人民币/美元 |
 |
| aleadytotalinvoice | numeric | YES | YES字段 |
 |
| shouldtotalinvoice | numeric | YES | YES字段 |
 |
| companyname | character varying | YES | YES字段 |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| bankname | character varying | YES | 开户银行名称 |
 |
| bankcode | character varying | YES | YES字段 |
 |
| receiptvoucher | character varying | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_supplierassetpaymentapplicantdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_supplierassetpaymen |
 |
| aoid | bigint | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| assetcode | character | YES | 资产编号 |
 |
| assetname | character varying | YES | 资产名称 |
 |
| number | numeric | YES | YES字段 |
 |
| unit | character | YES | 计量单位 |
 |
| spec | character varying | YES | YES字段 |
 |
| modelnumber | character varying | YES | YES字段 |
 |
| manufacture | character varying | YES | YES字段 |
 |
| price | numeric | YES | 单价 |
 |
| amount | numeric | YES | 金额 |
 |
| sourcetype | character varying | YES | YES字段 |
 |
| sourceid | bigint | YES | YES字段 |
 |
| accountcode | character varying | YES | 会计科目编码 |
 |
| accountname | character varying | YES | 会计科目名称 |
 |

### t_systemanalystchartmanagement

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_systemanalystchartm |
 |
| charttype | character varying | YES | YES字段 |
 |
| chartname | character varying | YES | YES字段 |
 |
| linkurl | character varying | YES | YES字段 |
 |
| sqlcode | text | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_systemanalystchartrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_systemanalystchartr |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| chartname | character varying | YES | YES字段 |
 |
| formtype | character varying | YES | ''::bpchar |
 |
| sortnumber | bigint | YES | 0 |
 |

### t_systemdatamanageforbeginer

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| operationname | character | NO | NO字段 |
 |
| isforbit | character | NO | NO字段 |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| operatorname | character | YES | 操作人姓名 |
 |
| operatetime | timestamp without time zone | YES | now() |
 |
| isbackup | character | YES | 'NO'::bpchar |
 |

### t_systemexchangedbserver

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| dbservername | character | NO | NO字段 |
 |
| dbname | character | YES | YES字段 |
 |
| connectstring | character varying | YES | YES字段 |
 |
| loginstring | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 0 |
 |

### t_systemexchangeorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_systemexchangeorder |
 |
| dbservername | character | NO | NO字段 |
 |
| sqlorderstring | character varying | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_systemexchangerecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_systemexchangerecor |
 |
| dbservername | character | NO | NO字段 |
 |
| sqlorderstring | character varying | YES | YES字段 |
 |
| runtime | timestamp without time zone | YES | now() |
 |
| identifystring | character varying | YES | YES字段 |
 |
| exportdatafile | character varying | YES | YES字段 |
 |

### t_systemmdistyle

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| mdistyle | character varying | NO | NO字段 |
 |
| pagename | character varying | YES | 页面名称 |
 |
| sortnumber | bigint | YES | 0 |
 |
| mobilepagename | character varying | YES | ''::character varying |
 |
| thirdpartpagename | character varying | YES | ''::character varying |
 |
| thirdpartmobilepagename | character varying | YES | ''::character varying |
 |

### t_systemmodulerelatedjscode

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_systemmodulerelated |
 |
| modulename | character varying | NO | 模块名称 |
 |
| jscode | text | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |
| creatorcode | character | NO | NO字段 |
 |
| creatorname | character | NO | NO字段 |
 |
| createtime | timestamp without time zone | YES | now() |
 |

### t_tablenamemapping

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_tablenamemapping_id |
 |
| tablename | character varying | YES | YES字段 |
 |
| description | character varying | YES | 详细描述信息 |
 |

### t_tabletemplatemapping

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_tabletemplatemappin |
 |
| tablename | character varying | YES | YES字段 |
 |
| tablexmlnodename | character varying | YES | YES字段 |
 |
| wftemplatename | character varying | YES | YES字段 |
 |
| xsnfile | character varying | YES | YES字段 |
 |
| wftemplatexmlnodename | character varying | YES | YES字段 |
 |
| identifystring | character varying | YES | YES字段 |
 |

### t_taketopsalarymain

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_taketopsalarymain_i |
 |
| companyname | character varying | YES | YES字段 |
 |
| yearnumber | bigint | YES | YES字段 |
 |
| yuenumber | bigint | YES | YES字段 |
 |
| workflowwlname | character varying | YES | YES字段 |
 |

### t_taketopsalarymaindetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| fid | bigint | NO | nextval('t_taketopsalarymainde |
 |
| xingmingmain | character | YES | YES字段 |
 |
| yuexinmain | numeric | YES | YES字段 |
 |
| yikoushebaomain | numeric | YES | YES字段 |
 |
| qingjiatianshumain | numeric | YES | YES字段 |
 |
| bingjiayiyuandanjuzhengmingmain | character | YES | YES字段 |
 |
| shijiyuexinmain | numeric | YES | YES字段 |
 |
| gerensuodeshuimain | numeric | YES | YES字段 |
 |
| yingfaxinshuimain | numeric | YES | YES字段 |
 |
| beizhumain | character varying | YES | YES字段 |
 |
| mainid | bigint | YES | YES字段 |
 |

### t_taketopsalaryseconddetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| fid | bigint | NO | nextval('t_taketopsalarysecond |
 |
| xingmingsecond | character | YES | YES字段 |
 |
| diaozhengqiangongzi | numeric | YES | YES字段 |
 |
| diaozhenghougongzi | numeric | YES | YES字段 |
 |
| diaozhengriqi | timestamp without time zone | YES | now() |
 |
| yikoushebaosecond | numeric | YES | YES字段 |
 |
| qingjiatianshusecond | numeric | YES | YES字段 |
 |
| bingjiayiyuandanjuzhengmingsecond | character | YES | YES字段 |
 |
| benyueshijigongzuotianshu | numeric | YES | YES字段 |
 |
| shijiyuexinsecond | numeric | YES | YES字段 |
 |
| gerensuodeshuisecond | numeric | YES | YES字段 |
 |
| yingfaxinshuisecond | numeric | YES | YES字段 |
 |
| beizhusecond | character varying | YES | YES字段 |
 |
| mainid | bigint | YES | YES字段 |
 |

### t_taskoperation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| operation | character | NO | 操作内容描述 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_taskrecordtype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_taskstatus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_taskstatus_id_seq': |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| langcode | character | YES | ''::bpchar |
 |
| maketype | character varying | YES | 'DIY'::bpchar |
 |

### t_tasktestcase

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_tasktestcase_id_seq |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| taskid | bigint | YES | 关联T_ProjectTask表，标识所属任务 |
 |
| casename | character varying | YES | YES字段 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| requisite | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_tasktestrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_tasktestrecord_id_s |
 |
| taskid | bigint | YES | 关联T_ProjectTask表，标识所属任务 |
 |
| testcaseid | bigint | YES | YES字段 |
 |
| command | character varying | YES | YES字段 |
 |
| testtime | timestamp without time zone | YES | YES字段 |
 |
| testercode | character | YES | YES字段 |
 |
| testername | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_tasktype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character varying | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_temprecrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| smsindex | bigint | NO | nextval('t_temprecrecord_smsin |
 |
| sourcenumber | character varying | NO | NO字段 |
 |
| content | character varying | YES | 内容详情 |
 |
| senttime | timestamp without time zone | NO | NO字段 |
 |
| commport | smallint | NO | NO字段 |
 |
| msgtype | character varying | YES | 0 |
 |
| subsmsindex | smallint | YES | 0 |
 |
| subsmscount | smallint | YES | 0 |
 |
| smsid | smallint | YES | 0 |
 |

### t_tender_content

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| tendercontent | character varying | NO | NO字段 |
 |

### t_tender_hyyq

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_tender_hyyq_id_seq' |
 |
| tendercode | character varying | YES | YES字段 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| compactcode | character varying | YES | YES字段 |
 |
| biddingagent | character varying | YES | YES字段 |
 |
| biddingagentphone | character varying | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| usercodephone | character varying | YES | YES字段 |
 |
| salescode | character varying | YES | YES字段 |
 |
| salescodephone | character varying | YES | YES字段 |
 |
| tenderbuytime | character varying | YES | YES字段 |
 |
| tenderbuyday | smallint | YES | 0 |
 |
| istender | bigint | YES | 0 |
 |
| margin | numeric | YES | 0 |
 |
| margintime | character varying | YES | YES字段 |
 |
| marginday | bigint | YES | 0 |
 |
| ismargin | bigint | YES | 0 |
 |
| bidopeningdate | character varying | YES | YES字段 |
 |
| bidopeningday | bigint | YES | 0 |
 |
| isbidopening | bigint | YES | 0 |
 |
| winningfeedate | character varying | YES | YES字段 |
 |
| winningfeeday | bigint | YES | 0 |
 |
| iswinningfee | bigint | YES | 0 |
 |
| tendercontent | text | YES | YES字段 |
 |
| remarks | text | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| receivemargin | numeric | YES | 0 |
 |
| receivemargintime | character varying | YES | now() |
 |
| receivemarginday | smallint | YES | 0 |
 |
| isreceivemargin | bigint | YES | 0 |
 |
| creatorcode | character | YES | ''::bpchar |
 |
| creatorname | character | YES | ''::bpchar |
 |
| workcost | numeric | YES | 0 |
 |
| agencycost | numeric | YES | 0 |
 |
| tenderstatus | character varying | YES | ''::character varying |
 |
| pmcode | character varying | YES | 项目经理编码 |
 |
| pmname | character varying | YES | 项目经理姓名 |
 |
| technicaldirectorcode | character varying | YES | YES字段 |
 |
| technicaldirectorname | character varying | YES | YES字段 |
 |
| principalcode | character varying | YES | YES字段 |
 |
| principalname | character varying | YES | YES字段 |
 |
| internalandexternal | character varying | YES | YES字段 |
 |
| biddingprice | numeric | YES | 0 |
 |
| controlprice | numeric | YES | 0 |
 |

### t_tenderexpense

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| expenseid | integer | NO | nextval('t_tenderexpense_expen |
 |
| tenderid | bigint | YES | YES字段 |
 |
| expensename | character varying | YES | YES字段 |
 |
| expenseamount | numeric | YES | YES字段 |
 |
| remarks | text | YES | YES字段 |
 |
| expensedate | character varying | YES | YES字段 |
 |

### t_tenderinvoice_hyyq

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_tenderinvoice_hyyq_ |
 |
| tenderid | bigint | YES | YES字段 |
 |
| invoicenumber | character varying | YES | 发票号码 |
 |
| invoicemoney | numeric | YES | YES字段 |
 |
| remarks | text | YES | YES字段 |
 |
| invoicedate | character varying | YES | 开票日期 |
 |

### t_tenderrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_tenderrelateduser_i |
 |
| tenderid | bigint | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | NO | 用户姓名 |
 |

### t_teststatus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_teststatus_id_seq': |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| langcode | character | YES | ''::bpchar |
 |
| maketype | character varying | YES | 'DIY'::bpchar |
 |

### t_teststudentbrief

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| fid | bigint | NO | nextval('t_teststudentbrief_fi |
 |
| company | character varying | YES | YES字段 |
 |
| dudy | character varying | YES | YES字段 |
 |
| mainid | bigint | YES | YES字段 |
 |

### t_teststudentinformation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_teststudentinformat |
 |
| studentname | character varying | YES | YES字段 |
 |
| studentgender | character varying | YES | YES字段 |
 |
| studentclassname | character varying | YES | YES字段 |
 |
| workflowwlname | character varying | YES | YES字段 |
 |

### t_teststudentscore

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_teststudentscore_id |
 |
| studentname | character varying | YES | YES字段 |
 |
| studentgender | character varying | YES | YES字段 |
 |
| workflowwlname | character varying | YES | YES字段 |
 |

### t_teststudentscoredetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| fid | bigint | NO | nextval('t_teststudentscoredet |
 |
| objectname | character varying | YES | YES字段 |
 |
| mainid | bigint | YES | YES字段 |
 |
| objectscore | numeric | YES | YES字段 |
 |

### t_testwupinglingyongdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| fid | bigint | NO | nextval('t_testwupinglingyongd |
 |
| xuhao | bigint | YES | YES字段 |
 |
| pingming | character varying | YES | YES字段 |
 |
| shuliang | numeric | YES | YES字段 |
 |
| danjia | numeric | YES | YES字段 |
 |
| zongjia | numeric | YES | YES字段 |
 |
| mainid | bigint | YES | YES字段 |
 |

### t_testwupinglingyongmain

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_testwupinglingyongm |
 |
| shengqingbumen | character varying | YES | YES字段 |
 |
| riqi | timestamp without time zone | YES | YES字段 |
 |
| shengqingren | character varying | YES | YES字段 |
 |
| zhuguanbuchuangyijian | character varying | YES | YES字段 |
 |
| fuzongjingliyijian | character varying | YES | YES字段 |
 |
| chuangwufuzongyijian | character varying | YES | YES字段 |
 |
| tuihuiwuping | character varying | YES | YES字段 |
 |
| lingyongjianming | character varying | YES | YES字段 |
 |
| workflowwlname | character varying | YES | YES字段 |
 |

### t_transferproject

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_transferproject_id_ |
 |
| projectid | bigint | YES | 关联T_Project表，标识所属项目 |
 |
| oldpmcode | character | YES | YES字段 |
 |
| oldpmname | character | YES | YES字段 |
 |
| newpmcode | character | YES | YES字段 |
 |
| newpmname | character | YES | YES字段 |
 |
| changetime | timestamp without time zone | YES | YES字段 |
 |
| actor | character | YES | ''::bpchar |
 |

### t_tremployeetraining

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_tremployeetraining_ |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| professionalskilllevel | character varying | YES | YES字段 |
 |
| professionskillnumber | character varying | YES | YES字段 |
 |
| validitytype | character varying | YES | YES字段 |
 |
| releasetime | timestamp without time zone | YES | YES字段 |
 |
| annvalidtime | character varying | YES | YES字段 |
 |
| anncertificateno | character varying | YES | YES字段 |
 |
| englishriew | character varying | YES | YES字段 |
 |
| traininginfo | text | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |
| entertime | timestamp without time zone | YES | 进入系统时间 |
 |

### t_trholderwelder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_trholderwelder_id_s |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| certificateno | character varying | YES | YES字段 |
 |
| welderseal | character varying | YES | YES字段 |
 |
| holderproject | character varying | YES | YES字段 |
 |
| validtime | character varying | YES | YES字段 |
 |
| unit | character varying | YES | 计量单位 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |
| entertime | timestamp without time zone | YES | 进入系统时间 |
 |
| attachpath | character varying | YES | YES字段 |
 |

### t_triggertabletofrom

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_triggertabletofrom_ |
 |
| name | character varying | YES | 名称 |
 |
| maintable | character varying | YES | YES字段 |
 |
| fromtable | character varying | YES | YES字段 |
 |
| mainid | bigint | YES | YES字段 |
 |
| status | bigint | YES | 状态，记录当前处理阶段 |
 |
| createtime | timestamp without time zone | YES | now() |
 |

### t_trpostcertificate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_trpostcertificate_i |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| unit | character varying | YES | 计量单位 |
 |
| job | character varying | YES | YES字段 |
 |
| certificateno | character varying | YES | YES字段 |
 |
| certificateoffice | character varying | YES | YES字段 |
 |
| certificatetime | timestamp without time zone | YES | YES字段 |
 |
| certificatereviewtime | timestamp without time zone | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |
| entertime | timestamp without time zone | YES | 进入系统时间 |
 |

### t_trspecialequipment

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_trspecialequipment_ |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| speequtype | character varying | YES | YES字段 |
 |
| speequproject | character varying | YES | YES字段 |
 |
| speequstarttime | timestamp without time zone | YES | YES字段 |
 |
| speequreviewtime | timestamp without time zone | YES | YES字段 |
 |
| speequnumber | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |
| entertime | timestamp without time zone | YES | 进入系统时间 |
 |

### t_trspecialoperations

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_trspecialoperations |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| speopetype | character varying | YES | YES字段 |
 |
| speopeproject | character varying | YES | YES字段 |
 |
| speopestarttime | timestamp without time zone | YES | YES字段 |
 |
| speopereviewtime | timestamp without time zone | YES | YES字段 |
 |
| speopenumber | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |
| entertime | timestamp without time zone | YES | 进入系统时间 |
 |

### t_trtrainingrecordemp

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_trtrainingrecordemp |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| trainingproject | character varying | YES | YES字段 |
 |
| trainingaccord | character varying | YES | YES字段 |
 |
| trainingunit | character varying | YES | YES字段 |
 |
| trainingaddress | character varying | YES | YES字段 |
 |
| trainingcontent | text | YES | YES字段 |
 |
| trainingtime | timestamp without time zone | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |
| entertime | timestamp without time zone | YES | 进入系统时间 |
 |

### t_tryproductresontype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| type | character | NO | 类型分类 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| hometypename | character | YES | ''::bpchar |
 |
| langcode | character | YES | ''::bpchar |
 |
| id | integer | NO | nextval('t_tryproductresontype |
 |

### t_u8keyapply_yyup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_u8keyapply_yyup_id_ |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| departcode | character varying | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | YES | 部门名称 |
 |
| sex | character varying | YES | YES字段 |
 |
| phone | character varying | YES | 联系电话 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| u8versionid | character varying | YES | YES字段 |
 |
| u8version | character varying | YES | YES字段 |
 |
| applyreason | character varying | YES | YES字段 |
 |
| applytime | timestamp without time zone | YES | now() |
 |
| approvestatus | character varying | YES | YES字段 |
 |
| departapprovetime | character varying | YES | YES字段 |
 |
| departapprovercode | character varying | YES | YES字段 |
 |
| departapprovername | character varying | YES | YES字段 |
 |
| groupapprovercode | character varying | YES | YES字段 |
 |
| groupapprovername | character varying | YES | YES字段 |
 |
| groupapprovetime | character varying | YES | YES字段 |
 |
| assignedaccount | character varying | YES | YES字段 |
 |
| assingedpassword | character varying | YES | YES字段 |
 |
| emailstatus | character varying | YES | YES字段 |
 |

### t_userattendancerecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_userattendancerecor |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| attendancedate | timestamp without time zone | YES | now() |
 |
| mcheckin | timestamp without time zone | YES | now() |
 |
| mcheckout | timestamp without time zone | YES | now() |
 |
| acheckin | timestamp without time zone | YES | now() |
 |
| acheckout | timestamp without time zone | YES | now() |
 |
| ncheckin | timestamp without time zone | YES | now() |
 |
| ncheckout | timestamp without time zone | YES | now() |
 |
| ocheckin | timestamp without time zone | YES | now() |
 |
| ocheckout | timestamp without time zone | YES | now() |
 |
| lateminute | bigint | YES | 0 |
 |
| earlyminute | bigint | YES | 0 |
 |
| mcheckinaddress | character varying | YES | ''::character varying |
 |
| mcheckindistance | numeric | YES | 0 |
 |
| mcheckinlongitude | character varying | YES | ''::character varying |
 |
| mcheckinlatitude | character varying | YES | ''::character varying |
 |
| mcheckoutaddress | character varying | YES | ''::character varying |
 |
| mcheckoutdistance | numeric | YES | 0 |
 |
| mcheckoutlongitude | character varying | YES | ''::character varying |
 |
| mcheckoutlatitude | character varying | YES | ''::character varying |
 |
| acheckinaddress | character varying | YES | ''::character varying |
 |
| acheckindistance | numeric | YES | 0 |
 |
| acheckinlongitude | character varying | YES | ''::character varying |
 |
| acheckinlatitude | character varying | YES | ''::character varying |
 |
| acheckoutaddress | character varying | YES | ''::character varying |
 |
| acheckoutdistance | numeric | YES | 0 |
 |
| acheckoutlongitude | character varying | YES | ''::character varying |
 |
| acheckoutlatitude | character varying | YES | ''::character varying |
 |
| ncheckinaddress | character varying | YES | ''::character varying |
 |
| ncheckindistance | numeric | YES | 0 |
 |
| ncheckinlongitude | character varying | YES | ''::character varying |
 |
| ncheckinlatitude | character varying | YES | ''::character varying |
 |
| ncheckoutaddress | character varying | YES | ''::character varying |
 |
| ncheckoutdistance | numeric | YES | 0 |
 |
| ncheckoutlongitude | character varying | YES | ''::character varying |
 |
| ncheckoutlatitude | character varying | YES | ''::character varying |
 |
| ocheckinaddress | character varying | YES | ''::character varying |
 |
| ocheckindistance | numeric | YES | 0 |
 |
| ocheckinlongitude | character varying | YES | ''::character varying |
 |
| ocheckinlatitude | character varying | YES | ''::character varying |
 |
| ocheckoutaddress | character varying | YES | ''::character varying |
 |
| ocheckoutdistance | numeric | YES | 0 |
 |
| ocheckoutlongitude | character varying | YES | ''::character varying |
 |
| ocheckoutlatitude | character varying | YES | ''::character varying |
 |
| mcheckinismust | character | YES | 'NO'::bpchar |
 |
| mcheckoutismust | character | YES | 'NO'::bpchar |
 |
| acheckinismust | character | YES | 'NO'::bpchar |
 |
| acheckoutismust | character | YES | 'NO'::bpchar |
 |
| ... | ... | ... | ... |

### t_userattendancerule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_userattendancerule_ |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| createdate | timestamp without time zone | YES | now() |
 |
| mcheckinstart | character | YES | YES字段 |
 |
| mcheckinend | character | YES | YES字段 |
 |
| mcheckoutstart | character | YES | YES字段 |
 |
| mcheckoutend | character | YES | YES字段 |
 |
| acheckinstart | character | YES | YES字段 |
 |
| acheckinend | character | YES | YES字段 |
 |
| acheckoutstart | character | YES | YES字段 |
 |
| acheckoutend | character | YES | YES字段 |
 |
| ncheckinstart | character | YES | YES字段 |
 |
| ncheckinend | character | YES | YES字段 |
 |
| ncheckoutstart | character | YES | YES字段 |
 |
| ncheckoutend | character | YES | YES字段 |
 |
| ocheckinstart | character | YES | YES字段 |
 |
| ocheckinend | character | YES | YES字段 |
 |
| ocheckoutstart | character | YES | YES字段 |
 |
| ocheckoutend | character | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| mcheckinismust | character | YES | 'NO'::bpchar |
 |
| mcheckoutismust | character | YES | 'NO'::bpchar |
 |
| acheckinismust | character | YES | 'NO'::bpchar |
 |
| acheckoutismust | character | YES | 'NO'::bpchar |
 |
| ncheckinismust | character | YES | 'NO'::bpchar |
 |
| ncheckoutismust | character | YES | 'NO'::bpchar |
 |
| ocheckinismust | character | YES | 'NO'::bpchar |
 |
| ocheckoutismust | character | YES | 'NO'::bpchar |
 |
| largestdistance | numeric | YES | 0 |
 |
| leadercode | character | YES | ''::bpchar |
 |
| leadername | character | YES | ''::bpchar |
 |
| officelongitude | character | YES | ''::bpchar |
 |
| officelatitude | character | YES | ''::bpchar |
 |
| address | character | YES | ''::bpchar |
 |

### t_userdepartmentstring

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| usercode | character | NO | 用户编码，登录账号 |
 |
| underdepartmentstring | text | YES | YES字段 |
 |
| parentdepartmentstring | text | YES | YES字段 |
 |

### t_userduty

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| duty | character | NO | NO字段 |
 |
| keyword | character varying | YES | 'STAFF'::character varying |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |

### t_userinfo

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_userinfo_id_seq'::r |
 |
| username | character varying | NO | 用户姓名 |
 |
| gender | character | YES | YES字段 |
 |
| pwd | character varying | YES | YES字段 |
 |
| role | character varying | YES | YES字段 |
 |
| loginnum | character varying | YES | 累计登录次数 |
 |
| entertime | timestamp without time zone | YES | 进入系统时间 |
 |
| logintime | timestamp without time zone | YES | 登录时间 |
 |
| loginouttime | timestamp without time zone | YES | 登出时间 |
 |
| attr | character varying | YES | YES字段 |
 |

### t_userloginmanage

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_userloginmanage_id_ |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | YES | 用户姓名 |
 |
| ip | character varying | YES | YES字段 |
 |
| message | character varying | YES | YES字段 |
 |
| isforbidlogin | character varying | YES | YES字段 |
 |
| operatorcode | character | YES | 操作人编码 |
 |
| operatetime | timestamp without time zone | YES | now() |
 |
| status | character varying | YES | ''::bpchar |
 |
| isallmember | character | YES | 'NO'::bpchar |
 |

### t_userloginmanagemsgrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_userloginmanagemsgr |
 |
| loginid | bigint | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |

### t_usernotindepartmodule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_usernotindepartmodu |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | NO | 用户姓名 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |

### t_useroperatelog

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_useroperatelog_id_s |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| operatecontent | character varying | YES | YES字段 |
 |
| operatetime | timestamp without time zone | YES | YES字段 |
 |
| userip | character varying | YES | YES字段 |
 |

### t_userpositionbygps

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_userpositionbygps_i |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| longitude | character | YES | GPS经度坐标 |
 |
| latitude | character | YES | GPS纬度坐标 |
 |
| address | character varying | YES | ''::character varying |
 |
| createtime | timestamp without time zone | YES | now() |
 |
| macaddress | character varying | YES | ''::character varying |
 |
| shifttype | character varying | YES | ''::character varying |
 |
| distance | numeric | YES | 0 |
 |
| deviceid | character varying | YES | ''::character varying |
 |
| leadercode | character | YES | ''::bpchar |
 |
| leadername | character | YES | ''::bpchar |
 |

### t_userschedulerule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_userschedulerule_id |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |
| createdate | date | YES | 记录创建时间 |
 |
| scheduleid | bigint | YES | YES字段 |
 |
| schedulename | character | YES | YES字段 |
 |

### t_usertransactionrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_usertransactionreco |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| transtype | character varying | YES | YES字段 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| effectdate | timestamp without time zone | YES | now() |
 |

### t_vendorrelateduser

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_vendorrelateduser_i |
 |
| vendorcode | character | NO | 供应商编号 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | NO | 用户姓名 |
 |

### t_visitregistration_student

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_visitregistration_s |
 |
| visitstarttime | timestamp without time zone | YES | YES字段 |
 |
| visitname | character varying | YES | YES字段 |
 |
| visitsex | character varying | YES | YES字段 |
 |
| visitcardtype | character varying | YES | YES字段 |
 |
| visitcardname | character varying | YES | YES字段 |
 |
| visitcardurl | character varying | YES | YES字段 |
 |
| visitreason | character varying | YES | YES字段 |
 |
| receiver | character varying | YES | YES字段 |
 |
| receivername | character varying | YES | YES字段 |
 |
| visitendtime | character varying | YES | YES字段 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |

### t_webservice

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_webservice_id_seq': |
 |
| webservicename | character varying | NO | NO字段 |
 |
| webserviceuri | character varying | NO | NO字段 |
 |
| methodname | character varying | YES | ''::character varying |
 |
| argarray | character varying | YES | ''::character varying |
 |
| comment | character varying | YES | ''::character varying |
 |
| creatorcode | character | NO | NO字段 |
 |
| creatorname | character | NO | NO字段 |
 |
| createtime | timestamp without time zone | YES | now() |
 |

### t_website

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_website_id_seq'::re |
 |
| sitename | character varying | YES | ''::character varying |
 |
| siteaddress | character varying | YES | ''::character varying |
 |
| usercode | character | NO | 用户编码，登录账号 |
 |
| sortnumber | bigint | YES | 0 |
 |

### t_weixinaccesstoken

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_weixinaccesstoken_i |
 |
| accesstoken | character varying | YES | YES字段 |
 |
| expiretime | timestamp without time zone | NO | NO字段 |
 |
| ticket | character varying | YES | ''::character varying |
 |
| ticketexpiretime | timestamp without time zone | YES | now() |
 |

### t_weixinqystand

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| corpid | character varying | NO | NO字段 |
 |
| corpsecret | character varying | YES | YES字段 |
 |
| agentid | character varying | YES | YES字段 |
 |
| status | character varying | YES | 'NO'::bpchar |
 |

### t_weixinstand

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| weixinno | character varying | NO | NO字段 |
 |
| password | character varying | YES | YES字段 |
 |
| tokenvalue | character varying | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_wfsteprelatedwf

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wfsteprelatedwf_id_ |
 |
| wfid | bigint | YES | 0 |
 |
| wfstepid | bigint | YES | YES字段 |
 |
| wfchildid | bigint | YES | 0 |
 |

### t_wftemplaterelatedjscode

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wftemplaterelatedjs |
 |
| temname | character varying | NO | NO字段 |
 |
| jscode | text | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |
| creatorcode | character | NO | NO字段 |
 |
| creatorname | character | NO | NO字段 |
 |
| createtime | timestamp without time zone | YES | now() |
 |

### t_wftemplatesteprelatedjscode

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wftemplatesteprelat |
 |
| temname | character varying | NO | NO字段 |
 |
| stepsortnumber | bigint | NO | NO字段 |
 |
| stepname | character varying | NO | 步骤名称 |
 |
| jscode | text | YES | YES字段 |
 |
| comment | character varying | YES | 备注说明 |
 |
| creatorcode | character | NO | NO字段 |
 |
| creatorname | character | NO | NO字段 |
 |
| createtime | timestamp without time zone | YES | now() |
 |

### t_wftemplatesteprelatedwebservice

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wftemplatesteprelat |
 |
| temname | character varying | NO | NO字段 |
 |
| stepsortnumber | bigint | NO | NO字段 |
 |
| stepname | character varying | NO | 步骤名称 |
 |
| webservicename | character varying | NO | NO字段 |
 |
| methodname | character varying | YES | ''::character varying |
 |
| comment | character varying | YES | ''::character varying |
 |

### t_wftemplatexmlnodeglobalvariable

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wftemplatexmlnodegl |
 |
| temname | character varying | YES | YES字段 |
 |
| xmlnode | character varying | YES | YES字段 |
 |
| globalvariable | character varying | YES | YES字段 |
 |

### t_wftsteprelatedtem

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wftsteprelatedtem_i |
 |
| relatedwftemname | character varying | YES | ''::character varying |
 |
| relatedstepid | bigint | YES | YES字段 |
 |
| requisite | character | YES | ''::bpchar |
 |
| belongstepsortnumber | bigint | YES | 0 |
 |
| belongismustpassed | character | YES | ''::bpchar |
 |

### t_wlstatus

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wlstatus_id_seq'::r |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| homename | character varying | YES | 显示名称（多语言） |
 |
| langcode | character | YES | ''::bpchar |
 |
| maketype | character varying | YES | 'DIY'::bpchar |
 |

### t_wltstepcondition

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| conid | bigint | NO | nextval('t_wltstepcondition_co |
 |
| stepid | bigint | YES | 工作流步骤ID |
 |
| xmlnodename | character varying | YES | YES字段 |
 |
| condetail | character varying | YES | YES字段 |
 |
| nextsortnumber | bigint | YES | YES字段 |
 |
| guid | character varying | YES | ''::character varying |
 |
| temname | character varying | YES | ''::character varying |
 |

### t_wltstepconditionexpression

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wltstepconditionexp |
 |
| conid | bigint | NO | NO字段 |
 |
| expression | character varying | NO | NO字段 |
 |
| logicaloperator | character | NO | NO字段 |
 |

### t_workexperience

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workexperience_id_s |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| starttime | timestamp without time zone | NO | 开始时间 |
 |
| endtime | timestamp without time zone | NO | NO字段 |
 |
| company | character varying | NO | NO字段 |
 |
| duty | character varying | NO | NO字段 |
 |
| salary | numeric | NO | 0 |
 |
| resignreason | character varying | YES | YES字段 |
 |
| renterence | character varying | YES | YES字段 |
 |
| renterencecall | character varying | YES | YES字段 |
 |

### t_workflowbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| wlid | bigint | NO | NO字段 |
 |
| wlname | character varying | YES | YES字段 |
 |
| wltype | character varying | YES | YES字段 |
 |
| relatedtype | character varying | YES | 关联业务类型 |
 |
| relatedid | bigint | YES | 关联业务ID |
 |
| xmlfile | character varying | YES | YES字段 |
 |
| xsnfile | character varying | YES | YES字段 |
 |
| temname | character varying | YES | YES字段 |
 |
| creatorcode | character | YES | YES字段 |
 |
| creatorname | character | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| description | character varying | YES | 详细描述信息 |
 |
| receivesms | character | YES | YES字段 |
 |
| receiveemail | character | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| diynextstep | character | YES | YES字段 |
 |
| wfxmldata | xml | YES | YES字段 |
 |
| fieldlist | character varying | YES | YES字段 |
 |
| editfieldlist | character varying | YES | YES字段 |
 |
| relatedcode | character | YES | YES字段 |
 |
| cannotnullfieldlist | character varying | YES | YES字段 |
 |
| maintableid | bigint | YES | YES字段 |
 |
| isplanmainworkflow | character | YES | YES字段 |
 |
| expense | numeric | YES | 实际费用 |
 |
| manhour | numeric | YES | 0 |
 |
| businesstype | character varying | YES | 'OTHER'::bpchar |
 |
| businesscode | character | YES | '0'::bpchar |
 |

### t_workflowformdata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workflowformdata_id |
 |
| wlid | bigint | NO | NO字段 |
 |
| templatename | character varying | NO | 模板名称 |
 |
| fieldname | character varying | NO | NO字段 |
 |
| parentxpath | character varying | NO | NO字段 |
 |
| fieldxpath | character varying | NO | NO字段 |
 |
| fieldvalue | text | NO | NO字段 |
 |
| fieldattributes | character varying | NO | NO字段 |
 |

### t_workflowpage

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workflowpage_id_seq |
 |
| wfname | character varying | NO | NO字段 |
 |
| pagename | character varying | NO | 页面名称 |
 |
| wftype | character varying | NO | NO字段 |
 |
| sortnumber | bigint | YES | 0 |
 |
| homename | character varying | YES | ''::character varying |
 |
| langcode | character | YES | ''::bpchar |
 |

### t_workflowrelatedmodule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workflowrelatedmodu |
 |
| workflowid | bigint | YES | 关联工作流实例 |
 |
| relatedmodulename | character varying | YES | YES字段 |
 |
| relatedid | character varying | YES | 关联业务ID |
 |
| workflowstepid | bigint | YES | 0 |
 |
| workflowstepdetailid | bigint | YES | 0 |
 |

### t_workflowstepbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| stepid | bigint | NO | 工作流步骤ID |
 |
| wlid | bigint | YES | YES字段 |
 |
| sortnumber | bigint | YES | 排序号，数字越小越靠前 |
 |
| stepname | character varying | YES | 步骤名称 |
 |
| limitedoperator | bigint | YES | YES字段 |
 |
| limitedtime | bigint | YES | YES字段 |
 |
| departrelated | character | YES | YES字段 |
 |
| activetime | timestamp without time zone | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |

### t_workflowstepbusinessmember

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workflowstepbusines |
 |
| stepid | bigint | YES | 工作流步骤ID |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | NO | 用户姓名 |
 |
| creatorcode | character varying | YES | ''::character varying |
 |

### t_workflowstepbusinessmemberbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| stepid | bigint | YES | 工作流步骤ID |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | NO | 用户姓名 |
 |
| creatorcode | character varying | YES | YES字段 |
 |

### t_workflowstepdetailbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | 主键，自增 |
 |
| stepid | bigint | NO | 工作流步骤ID |
 |
| wlid | bigint | YES | YES字段 |
 |
| operatorcode | character varying | YES | 操作人编码 |
 |
| operatorname | character | YES | 操作人姓名 |
 |
| operation | character varying | YES | 操作内容描述 |
 |
| operatorcommand | character varying | YES | YES字段 |
 |
| checkingtime | timestamp without time zone | YES | YES字段 |
 |
| status | character varying | YES | 状态，记录当前处理阶段 |
 |
| workdetail | character varying | YES | YES字段 |
 |
| actor | character varying | YES | YES字段 |
 |
| finishedtime | bigint | YES | YES字段 |
 |
| requisite | character | YES | YES字段 |
 |
| fieldlist | text | YES | YES字段 |
 |
| editfieldlist | text | YES | YES字段 |
 |
| isoperator | character | YES | YES字段 |
 |
| signpicturefield | character varying | YES | YES字段 |
 |
| allowfulledit | character | YES | YES字段 |
 |
| cannotnullfieldlist | character varying | YES | YES字段 |
 |
| ismust | character | YES | YES字段 |
 |
| maintablecanedit | character | YES | 'YES'::bpchar |
 |
| maintablecandelete | character | YES | 'YES'::bpchar |
 |
| detailtablecanedit | character | YES | 'YES'::bpchar |
 |
| detailtablecandelete | character | YES | 'YES'::bpchar |
 |
| manhour | numeric | YES | 0 |
 |
| expense | numeric | YES | 0 |
 |
| creatorcode | character | YES | ''::bpchar |
 |
| creatorname | character | YES | ''::bpchar |
 |
| xmlfile | character varying | YES | ''::character varying |
 |
| detailxmlfile | character varying | YES | ''::character varying |
 |

### t_workflowstepoperation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| operationid | bigint | NO | nextval('t_workflowstepoperati |
 |
| stepid | bigint | NO | 工作流步骤ID |
 |
| tstepid | bigint | NO | NO字段 |
 |
| toperationid | bigint | NO | NO字段 |
 |
| xmlnode | character varying | YES | YES字段 |
 |
| nodename | character varying | YES | YES字段 |
 |
| operationvalue | character varying | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |

### t_workflowstepoperationbackup

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| operationid | bigint | NO | NO字段 |
 |
| stepid | bigint | NO | 工作流步骤ID |
 |
| tstepid | bigint | NO | NO字段 |
 |
| toperationid | bigint | NO | NO字段 |
 |
| xmlnode | character varying | YES | YES字段 |
 |
| nodename | character varying | YES | YES字段 |
 |
| operationvalue | character varying | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character | YES | 用户姓名 |
 |

### t_workflowtemplatebusinessdepartment

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workflowtemplatebus |
 |
| temname | character varying | YES | YES字段 |
 |
| departcode | character | YES | 部门编码，关联T_Department表 |
 |
| departname | character varying | NO | 部门名称 |
 |

### t_workflowtemplatebusinessmember

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workflowtemplatebus |
 |
| temname | character varying | YES | YES字段 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | NO | 用户姓名 |
 |

### t_workflowtemplatestepbusinessmember

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workflowtemplateste |
 |
| temname | character varying | YES | YES字段 |
 |
| stepid | bigint | YES | 0 |
 |
| usercode | character | YES | 用户编码，登录账号 |
 |
| username | character varying | NO | 用户姓名 |
 |
| stepsortnumber | bigint | YES | 0 |
 |
| agreenotice | character | YES | 'YES'::bpchar |
 |
| refusenotice | character | YES | 'YES'::bpchar |
 |
| cancelnotice | character | YES | 'YES'::bpchar |
 |
| checkingnotice | character | YES | 'YES'::bpchar |
 |
| reviewnotice | character | YES | 'YES'::bpchar |
 |
| signingnotice | character | YES | 'YES'::bpchar |
 |
| agreebacknotice | character | YES | 'YES'::bpchar |
 |

### t_workflowtstepoperation

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| operationid | bigint | NO | nextval('t_workflowtstepoperat |
 |
| stepid | bigint | NO | 工作流步骤ID |
 |
| xmlnode | character varying | NO | NO字段 |
 |
| nodename | character varying | NO | NO字段 |
 |
| comment | character varying | YES | 备注说明 |
 |

### t_workflowtstepoperationvalue

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| valueid | bigint | NO | nextval('t_workflowtstepoperat |
 |
| operationid | bigint | NO | NO字段 |
 |
| operationvalue | character varying | YES | YES字段 |
 |

### t_workflowtsteprelatedmodule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_workflowtsteprelate |
 |
| stepguid | character varying | YES | YES字段 |
 |
| temname | character varying | YES | YES字段 |
 |
| modulename | character varying | YES | 模块名称 |
 |
| pagename | character varying | YES | 页面名称 |
 |
| maintablecanadd | character | YES | 'YES'::bpchar |
 |
| detailtablecanadd | character | YES | 'YES'::bpchar |
 |
| maintablecanedit | character | YES | 'YES'::bpchar |
 |
| maintablecandelete | character | YES | 'YES'::bpchar |
 |
| detailtablecanedit | character | YES | 'YES'::bpchar |
 |
| detailtablecandelete | character | YES | 'YES'::bpchar |
 |
| moduletype | character varying | YES | ''::bpchar |
 |

### t_workingdayrule

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| weekendfirstday | bigint | NO | 6 |
 |
| weekendsareworkdays | character varying | YES | 'false'::character varying |
 |
| weekendsecondday | bigint | YES | 0 |
 |

### t_worktype

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| typename | character varying | NO | NO字段 |
 |
| sortno | bigint | YES | YES字段 |
 |

### t_wpqmalldata

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmalldata_id_seq' |
 |
| code | character varying | YES | 编码，唯一标识 |
 |
| description | text | YES | 详细描述信息 |
 |
| type | character varying | YES | 类型分类 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmcontactlist

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmcontactlist_id_ |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| contactclient | character varying | YES | YES字段 |
 |
| commissioneddate | timestamp without time zone | YES | YES字段 |
 |
| groupform | character varying | YES | YES字段 |
 |
| visualinspection | text | YES | YES字段 |
 |
| mechanicalperreq | text | YES | YES字段 |
 |
| mechanizationdegree | text | YES | YES字段 |
 |
| executionstandard | text | YES | YES字段 |
 |
| otherperreq | text | YES | YES字段 |
 |
| contactnote | text | YES | YES字段 |
 |
| contactpersontel | character varying | YES | YES字段 |
 |
| tasksendunit | character varying | YES | YES字段 |
 |
| taskreceiveunit | character varying | YES | YES字段 |
 |
| sendperson | character varying | YES | YES字段 |
 |
| receiveperson | character varying | YES | YES字段 |
 |
| contactdate | timestamp without time zone | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmcover

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmcover_id_seq':: |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| coverremark | text | YES | YES字段 |
 |
| coverdate | timestamp without time zone | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmheattreatprocard

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmheattreatprocar |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| heattrefurnmodel | character varying | YES | YES字段 |
 |
| boilingtemp | character varying | YES | YES字段 |
 |
| heatingspeed | character varying | YES | YES字段 |
 |
| coolingspeed | character varying | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmheattreatreport

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmheattreatreport |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| heattreattime | timestamp without time zone | YES | YES字段 |
 |
| boilingtemp | character varying | YES | YES字段 |
 |
| heatingspeed | character varying | YES | YES字段 |
 |
| coolingspeed | character varying | YES | YES字段 |
 |
| coolingmethod | text | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| timecurvepath | character varying | YES | YES字段 |
 |
| heattreatreporter | character varying | YES | YES字段 |
 |
| heattreatrepoperation | character varying | YES | YES字段 |
 |
| heattreatreportreviewer | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmmechanicalproorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmmechanicalproor |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| maccomspenumber | character varying | YES | YES字段 |
 |
| machiningproject | character varying | YES | YES字段 |
 |
| machiningdrawpath | character varying | YES | YES字段 |
 |
| machanicalproinstro | text | YES | YES字段 |
 |
| procommdate | timestamp without time zone | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmphysicalchemical

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmphysicalchemica |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| physicalchetensilesample | character varying | YES | YES字段 |
 |
| coldbendspecimen | character varying | YES | YES字段 |
 |
| dvalue | character varying | YES | YES字段 |
 |
| value_1 | character varying | YES | YES字段 |
 |
| lateralbending | character varying | YES | YES字段 |
 |
| normaltemshock | numeric | YES | YES字段 |
 |
| normaltemweldzoneshock | numeric | YES | YES字段 |
 |
| normaltemheatzoneshock | numeric | YES | YES字段 |
 |
| normaltemmetaareashock | numeric | YES | YES字段 |
 |
| lowtemperature | character varying | YES | YES字段 |
 |
| lowtempimpact | numeric | YES | YES字段 |
 |
| lowtempweldimpact | numeric | YES | YES字段 |
 |
| lowtempwarmimpact | numeric | YES | YES字段 |
 |
| lowtempmetaimpact | numeric | YES | YES字段 |
 |
| intercorrosionspecimen | character varying | YES | YES字段 |
 |
| intcorrspestandard | text | YES | YES字段 |
 |
| macrometallospecimen | character varying | YES | YES字段 |
 |
| macmetspestandard | text | YES | YES字段 |
 |
| groovesample | character varying | YES | YES字段 |
 |
| groovesamplestandard | text | YES | YES字段 |
 |
| filletmeasure | character varying | YES | YES字段 |
 |
| filletmeasurestandard | text | YES | YES字段 |
 |
| contentreq | text | YES | YES字段 |
 |
| contentstandard | text | YES | YES字段 |
 |
| remark | text | YES | 备注说明 |
 |
| clienttime | timestamp without time zone | YES | YES字段 |
 |
| chemicalclient | character varying | YES | YES字段 |
 |
| chemicalreviewer | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmpqr1

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmpqr1_id_seq'::r |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| weldjointother | character varying | YES | YES字段 |
 |
| metalother | character varying | YES | YES字段 |
 |
| weldmetalthick | character varying | YES | YES字段 |
 |
| fillermetalother | character varying | YES | YES字段 |
 |
| weldingcurrent | character varying | YES | YES字段 |
 |
| arcvoltage | character varying | YES | YES字段 |
 |
| eleccharaother | text | YES | YES字段 |
 |
| weldingspeed | character varying | YES | YES字段 |
 |
| securitymeasureother | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmpwps1

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmpwps1_id_seq':: |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| entityname | character varying | YES | YES字段 |
 |
| pwps1datetime | timestamp without time zone | YES | YES字段 |
 |
| mechanizationdegree | text | YES | YES字段 |
 |
| weldedjointother | text | YES | YES字段 |
 |
| weldedjointdiagram | character varying | YES | YES字段 |
 |
| pwpscategory | character varying | YES | YES字段 |
 |
| pwpsandcategory | character varying | YES | YES字段 |
 |
| pwpsstandardno | character varying | YES | YES字段 |
 |
| pwpsandstandardno | character varying | YES | YES字段 |
 |
| buttweldmatethicknessrange | character varying | YES | YES字段 |
 |
| filletweldmatethicknessrange | character varying | YES | YES字段 |
 |
| buttweldotherinfo | character varying | YES | YES字段 |
 |
| filletweld | character varying | YES | YES字段 |
 |
| pwpsmetalother | text | YES | YES字段 |
 |
| electstandard | character varying | YES | YES字段 |
 |
| wirestandard | character varying | YES | YES字段 |
 |
| fluxstandard | character varying | YES | YES字段 |
 |
| electinspection | character varying | YES | YES字段 |
 |
| wireinspection | character varying | YES | YES字段 |
 |
| fluxinspection | character varying | YES | YES字段 |
 |
| buttweldmetathickrange | character varying | YES | YES字段 |
 |
| filletweldmetathickrange | character varying | YES | YES字段 |
 |
| c | character varying | YES | YES字段 |
 |
| mn | character varying | YES | YES字段 |
 |
| si | character varying | YES | YES字段 |
 |
| s | character varying | YES | YES字段 |
 |
| p | character varying | YES | YES字段 |
 |
| cr | character varying | YES | YES字段 |
 |
| ni | character varying | YES | YES字段 |
 |
| mo | character varying | YES | YES字段 |
 |
| cu | character varying | YES | YES字段 |
 |
| ti | character varying | YES | YES字段 |
 |
| nb | character varying | YES | YES字段 |
 |
| pwpsdescr | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmquaassessnotice

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmquaassessnotice |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| notesender | character varying | YES | YES字段 |
 |
| notereviewer | character varying | YES | YES字段 |
 |
| noterecipient | character varying | YES | YES字段 |
 |
| notesenttime | timestamp without time zone | YES | YES字段 |
 |
| conclusion | text | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmrttable

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmrttable_id_seq' |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| nondestructtestcategory | character varying | YES | YES字段 |
 |
| inspectionproportion | character varying | YES | YES字段 |
 |
| qualifiedlevel | character varying | YES | YES字段 |
 |
| rtevaluationcriteria | text | YES | YES字段 |
 |
| numberspecimens | character varying | YES | YES字段 |
 |
| rtcommissioneddate | timestamp without time zone | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmsamplemechproorder

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmsamplemechproor |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| tensiletestspecimen | character varying | YES | YES字段 |
 |
| surfacebending | character varying | YES | YES字段 |
 |
| curvedback | character varying | YES | YES字段 |
 |
| curvedside | character varying | YES | YES字段 |
 |
| weldzoneimpact | character varying | YES | YES字段 |
 |
| heataffectedzone | character varying | YES | YES字段 |
 |
| metalareaimpact | character varying | YES | YES字段 |
 |
| intercorrosionspecimen | character varying | YES | YES字段 |
 |
| macrometallospecimen | character varying | YES | YES字段 |
 |
| machiningdate | timestamp without time zone | YES | YES字段 |
 |
| machininginstruction | text | YES | YES字段 |
 |
| commissioneddate | timestamp without time zone | YES | YES字段 |
 |
| machiningprincipal | character varying | YES | YES字段 |
 |
| machiningreviewer | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmstocklist

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmstocklist_id_se |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| stockclient | character varying | YES | YES字段 |
 |
| stockunit | character varying | YES | YES字段 |
 |
| specimenspecification | character varying | YES | YES字段 |
 |
| specimennumber | character varying | YES | YES字段 |
 |
| specimenpreparationnote | text | YES | YES字段 |
 |
| weldmaterialquantity | character varying | YES | YES字段 |
 |
| stockentrustdate | timestamp without time zone | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmweldaddproreport

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmweldaddprorepor |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| verticalweldingdirection | character varying | YES | YES字段 |
 |
| spanwidth | character varying | YES | YES字段 |
 |
| filletweldthick | character varying | YES | YES字段 |
 |
| weldingcurrent | character varying | YES | YES字段 |
 |
| metalliner | character varying | YES | YES字段 |
 |
| metallinershapesize | character varying | YES | YES字段 |
 |
| connectingway | character varying | YES | YES字段 |
 |
| cleaningmethod | character varying | YES | YES字段 |
 |
| afterhot | character varying | YES | YES字段 |
 |
| appinspectionresult | text | YES | YES字段 |
 |
| appinsrepnumber | character varying | YES | YES字段 |
 |
| peninsrepnumber | character varying | YES | YES字段 |
 |
| peninsjointnumber | text | YES | YES字段 |
 |
| metainsrepnumber | character varying | YES | YES字段 |
 |
| metafacenumber_cif | text | YES | YES字段 |
 |
| metafacenumber_fwt | text | YES | YES字段 |
 |
| metafacenumber_pen | text | YES | YES字段 |
 |
| conclusion | text | YES | YES字段 |
 |
| evaluationresult | text | YES | YES字段 |
 |
| weldername | character varying | YES | YES字段 |
 |
| weldercode | character varying | YES | YES字段 |
 |
| weldingdate | timestamp without time zone | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmweldingrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmweldingrecord_i |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| materialno | character varying | YES | YES字段 |
 |
| materialspecification | character varying | YES | YES字段 |
 |
| categorygroups | character varying | YES | YES字段 |
 |
| wiretypebrandspe | character varying | YES | YES字段 |
 |
| electypebrandspe | character varying | YES | YES字段 |
 |
| fluxtypebrandspe | character varying | YES | YES字段 |
 |
| weldmaterialcategory | character varying | YES | YES字段 |
 |
| weldingposition | character varying | YES | YES字段 |
 |
| weldingdirection | character varying | YES | YES字段 |
 |
| preheatingtemperature | character varying | YES | YES字段 |
 |
| layertemperature | character varying | YES | YES字段 |
 |
| heatingmode | text | YES | YES字段 |
 |
| tempmeasuremethod | text | YES | YES字段 |
 |
| warmuptime | character varying | YES | YES字段 |
 |
| weldingcurrent | character varying | YES | YES字段 |
 |
| weldingvoltage | character varying | YES | YES字段 |
 |
| weldingspeed | character varying | YES | YES字段 |
 |
| lineenergy | character varying | YES | YES字段 |
 |
| afterhottemp | character varying | YES | YES字段 |
 |
| afterhottime | character varying | YES | YES字段 |
 |
| environmenttemperature | character varying | YES | YES字段 |
 |
| relativehumidity | character varying | YES | YES字段 |
 |
| cleanbefwelding | character varying | YES | YES字段 |
 |
| layerclean | character varying | YES | YES字段 |
 |
| tunelectype | character varying | YES | YES字段 |
 |
| nozzlediameter | character varying | YES | YES字段 |
 |
| tunelecdiameter | character varying | YES | YES字段 |
 |
| backclearrootmethod | text | YES | YES字段 |
 |
| wirespeed | character varying | YES | YES字段 |
 |
| protectivegas | character varying | YES | YES字段 |
 |
| progasmixratio | character varying | YES | YES字段 |
 |
| shieldinggasflowrate | character varying | YES | YES字段 |
 |
| tailprotectivegas | character varying | YES | YES字段 |
 |
| tailprotectivegasmixratio | character varying | YES | YES字段 |
 |
| tailgasflowrate | character varying | YES | YES字段 |
 |
| backprotectivegas | character varying | YES | YES字段 |
 |
| backprotectivegasmixratio | character varying | YES | YES字段 |
 |
| backgasflowrate | character varying | YES | YES字段 |
 |
| currenttype | character varying | YES | YES字段 |
 |
| conductivemouthartifacts | character varying | YES | YES字段 |
 |
| groovediagrampath | character varying | YES | YES字段 |
 |
| weldingformdiagram | text | YES | YES字段 |
 |
| weldingmethod | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmweldprocedurespe

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmweldproceduresp |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| weldingtype | character varying | YES | YES字段 |
 |
| weldedjointdiagram | character varying | YES | YES字段 |
 |
| weldingprocess | character varying | YES | YES字段 |
 |
| figurenumber | character varying | YES | YES字段 |
 |
| jointnumber | character varying | YES | YES字段 |
 |
| holderweldproject | character varying | YES | YES字段 |
 |
| weldmetalthickness | character varying | YES | YES字段 |
 |
| weldingposition | character varying | YES | YES字段 |
 |
| weldingtechnology | text | YES | YES字段 |
 |
| preheatingtemperature | character varying | YES | YES字段 |
 |
| layertemperature | character varying | YES | YES字段 |
 |
| afterweldingclass | character varying | YES | YES字段 |
 |
| afterhot | character varying | YES | YES字段 |
 |
| tunelecdiameter | character varying | YES | YES字段 |
 |
| nozzlediameter | character varying | YES | YES字段 |
 |
| pulsefrequency | character varying | YES | YES字段 |
 |
| pulsewidth | character varying | YES | YES字段 |
 |
| gascomposition | character varying | YES | YES字段 |
 |
| gasflowfront | character varying | YES | YES字段 |
 |
| gasflowreverse | character varying | YES | YES字段 |
 |
| layer | character varying | YES | YES字段 |
 |
| polarity | character varying | YES | YES字段 |
 |
| weldingcurrent | character varying | YES | YES字段 |
 |
| arcvoltage | character varying | YES | YES字段 |
 |
| weldingspeed | character varying | YES | YES字段 |
 |
| lineenergy | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmweldproqua

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | character varying | NO | 编码，唯一标识 |
 |
| applicablecategories | character varying | YES | YES字段 |
 |
| materialno | character varying | YES | YES字段 |
 |
| materialspecification | character varying | YES | YES字段 |
 |
| weldmentthickness | character varying | YES | YES字段 |
 |
| baseclass | character varying | YES | YES字段 |
 |
| groupform | character varying | YES | YES字段 |
 |
| weldingmethod | character varying | YES | YES字段 |
 |
| weldingposition | character varying | YES | YES字段 |
 |
| preheatingtemperature | character varying | YES | YES字段 |
 |
| layertemperature | character varying | YES | YES字段 |
 |
| afterhot | character varying | YES | YES字段 |
 |
| afterweldingclass | character varying | YES | YES字段 |
 |
| afterweldingtem | character varying | YES | YES字段 |
 |
| afterweldingpretime | character varying | YES | YES字段 |
 |
| wiretypebrandspe | character varying | YES | YES字段 |
 |
| electypebrandspe | character varying | YES | YES字段 |
 |
| fluxtypebrandspe | character varying | YES | YES字段 |
 |
| weldmaterialcategory | character varying | YES | YES字段 |
 |
| weldingcurrent | character varying | YES | YES字段 |
 |
| weldingvoltage | character varying | YES | YES字段 |
 |
| weldingspeed | character varying | YES | YES字段 |
 |
| lineenergy | character varying | YES | YES字段 |
 |
| protectivegas | character varying | YES | YES字段 |
 |
| progasmixratio | character varying | YES | YES字段 |
 |
| shieldinggasflowrate | character varying | YES | YES字段 |
 |
| evaluationproject | text | YES | YES字段 |
 |
| mechanicalperreq | text | YES | YES字段 |
 |
| otherperreq | text | YES | YES字段 |
 |
| grooveform | character varying | YES | YES字段 |
 |
| nondestructivetestreq | text | YES | YES字段 |
 |
| afterhottemp | character varying | YES | YES字段 |
 |
| afterhottime | character varying | YES | YES字段 |
 |
| swingtype | character varying | YES | YES字段 |
 |
| oscillationparameters | character varying | YES | YES字段 |
 |
| coolingmethod | text | YES | YES字段 |
 |
| heatingmode | text | YES | YES字段 |
 |
| warmuptime | character varying | YES | YES字段 |
 |
| tempmeasuremethod | text | YES | YES字段 |
 |
| tailprotectivegas | character varying | YES | YES字段 |
 |
| tailprotectivegasmixratio | character varying | YES | YES字段 |
 |
| tailgasflowrate | character varying | YES | YES字段 |
 |
| backprotectivegas | character varying | YES | YES字段 |
 |
| backprotectivegasmixratio | character varying | YES | YES字段 |
 |
| backgasflowrate | character varying | YES | YES字段 |
 |
| nozzlediameter | character varying | YES | YES字段 |
 |
| tunelectype | character varying | YES | YES字段 |
 |
| tunelecdiameter | character varying | YES | YES字段 |
 |
| wirespeed | character varying | YES | YES字段 |
 |
| weldingarctype | character varying | YES | YES字段 |
 |
| ... | ... | ... | ... |

### t_wpqmweldtasklist

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmweldtasklist_id |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| uptime | timestamp without time zone | YES | YES字段 |
 |
| grooveform | character varying | YES | YES字段 |
 |
| backclearrootmethod | text | YES | YES字段 |
 |
| weldtechnicalmeasures | text | YES | YES字段 |
 |
| weldtaskcommissiontime | timestamp without time zone | YES | YES字段 |
 |
| taskprincipal | character varying | YES | YES字段 |
 |
| reviewertask | character varying | YES | YES字段 |
 |
| entercode | character varying | YES | YES字段 |
 |

### t_wpqmworkreviewcommit

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wpqmworkreviewcommi |
 |
| weldprocode | character varying | YES | YES字段 |
 |
| evaluationpurposes | text | YES | YES字段 |
 |
| specificationthickness | character varying | YES | YES字段 |
 |
| specificationdiameter | character varying | YES | YES字段 |
 |
| specificationpad | character varying | YES | YES字段 |
 |
| detailweldsizepath | character varying | YES | YES字段 |
 |
| value_1 | character varying | YES | YES字段 |
 |
| value_2 | character varying | YES | YES字段 |
 |
| value_3 | character varying | YES | YES字段 |
 |
| value_4 | character varying | YES | YES字段 |
 |
| value_5 | character varying | YES | YES字段 |
 |
| value_6 | character varying | YES | YES字段 |
 |
| value_7 | character varying | YES | YES字段 |
 |
| specificationother | text | YES | YES字段 |
 |
| rtinsproportion | character varying | YES | YES字段 |
 |
| rtqualifiedlevel | character varying | YES | YES字段 |
 |
| rtevaluationcriteria | text | YES | YES字段 |
 |
| mtinsproportion | character varying | YES | YES字段 |
 |
| mtqualifiedlevel | character varying | YES | YES字段 |
 |
| mtevaluationcriteria | text | YES | YES字段 |
 |
| ptinsproportion | character varying | YES | YES字段 |
 |
| ptqualifiedlevel | character varying | YES | YES字段 |
 |
| ptevaluationcriteria | text | YES | YES字段 |
 |
| utinsproportion | character varying | YES | YES字段 |
 |
| utqualifiedlevel | character varying | YES | YES字段 |
 |
| utevaluationcriteria | text | YES | YES字段 |
 |
| specificationotherreq | text | YES | YES字段 |
 |
| mechanicalperreqrm | text | YES | YES字段 |
 |
| mechanicalperreqrel | text | YES | YES字段 |
 |
| mechanicalperbend | character varying | YES | YES字段 |
 |
| mechanicalperback | character varying | YES | YES字段 |
 |
| mechanicalperscol | character varying | YES | YES字段 |
 |
| shocktemperature | character varying | YES | YES字段 |
 |
| impactweldzone | character varying | YES | YES字段 |
 |
| impactheatzone | character varying | YES | YES字段 |
 |
| impactmetalarea | character varying | YES | YES字段 |
 |
| hardnesshrb | character varying | YES | YES字段 |
 |
| hardnesshrc | character varying | YES | YES字段 |
 |
| hardnesshv | character varying | YES | YES字段 |
 |
| fracture | character varying | YES | YES字段 |
 |
| flattening | character varying | YES | YES字段 |
 |
| hambreak | character varying | YES | YES字段 |
 |
| chemicalcomp_c | character varying | YES | YES字段 |
 |
| chemicalcomp_mn | character varying | YES | YES字段 |
 |
| chemicalcomp_si | character varying | YES | YES字段 |
 |
| chemicalcomp_s | character varying | YES | YES字段 |
 |
| chemicalcomp_p | character varying | YES | YES字段 |
 |
| chemicalcomp_cr | character varying | YES | YES字段 |
 |
| chemicalcomp_ni | character varying | YES | YES字段 |
 |
| ... | ... | ... | ... |

### t_wzadvance

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| advancecode | character varying | NO | NO字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| advancename | character varying | YES | YES字段 |
 |
| advancemoney | numeric | YES | YES字段 |
 |
| advancetime | timestamp without time zone | YES | YES字段 |
 |
| marker | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzadvancedetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzadvancedetail_id_ |
 |
| advancecode | character varying | YES | YES字段 |
 |
| contractcode | character varying | YES | YES字段 |
 |
| contractname | character varying | YES | YES字段 |
 |
| contractmoney | numeric | YES | YES字段 |
 |
| effecttime | timestamp without time zone | YES | YES字段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| suppliername | character varying | YES | YES字段 |
 |
| paymoney | numeric | YES | YES字段 |
 |
| useway | character varying | YES | YES字段 |
 |
| payprogress | character varying | YES | YES字段 |
 |

### t_wzcard

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| cardcode | character varying | NO | NO字段 |
 |
| cardname | character varying | YES | YES字段 |
 |
| cardtime | timestamp without time zone | YES | YES字段 |
 |
| rownumber | bigint | YES | YES字段 |
 |
| detailmoney | numeric | YES | YES字段 |
 |
| cardmoney | numeric | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| cardmarker | character varying | YES | YES字段 |
 |

### t_wzcardimport

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzcardimport_id_seq |
 |
| nocode | character varying | YES | YES字段 |
 |
| objectname | character varying | YES | YES字段 |
 |
| outnumber | numeric | YES | YES字段 |
 |
| outprice | numeric | YES | YES字段 |
 |
| outmoney | numeric | YES | YES字段 |
 |
| planmoney | numeric | YES | YES字段 |
 |
| importstatus | character varying | YES | YES字段 |
 |
| cardcode | character varying | YES | YES字段 |
 |
| pickingcode | character varying | YES | YES字段 |
 |
| materialperson | character varying | YES | YES字段 |
 |
| turncode | character varying | YES | YES字段 |
 |

### t_wzcollect

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| collectcode | character varying | NO | NO字段 |
 |
| compactdetailid | bigint | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| plandetailid | bigint | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| tickettime | timestamp without time zone | YES | YES字段 |
 |
| collectmethod | character varying | YES | YES字段 |
 |
| collectnumber | numeric | YES | YES字段 |
 |
| actualnumber | numeric | YES | YES字段 |
 |
| actualprice | numeric | YES | YES字段 |
 |
| actualmoney | numeric | YES | YES字段 |
 |
| ratio | numeric | YES | YES字段 |
 |
| ratiomoney | numeric | YES | YES字段 |
 |
| freight | numeric | YES | YES字段 |
 |
| otherobject | numeric | YES | YES字段 |
 |
| convertnumber | numeric | YES | YES字段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| ticketnumber | character varying | YES | YES字段 |
 |
| checkcode | character varying | YES | YES字段 |
 |
| checker | character varying | YES | YES字段 |
 |
| checktime | character varying | YES | 审核时间 |
 |
| safekeeper | character varying | YES | YES字段 |
 |
| collecttime | character varying | YES | YES字段 |
 |
| contacter | character varying | YES | YES字段 |
 |
| requestcode | character varying | YES | YES字段 |
 |
| financeapprove | character varying | YES | YES字段 |
 |
| payprocess | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| compactcode | character varying | YES | YES字段 |
 |

### t_wzcompact

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| compactcode | character varying | NO | NO字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| needcode | character varying | YES | YES字段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| compactname | character varying | YES | YES字段 |
 |
| compacttext | character varying | YES | YES字段 |
 |
| compacttexturl | character varying | YES | YES字段 |
 |
| rownumber | bigint | YES | YES字段 |
 |
| compactmoney | numeric | YES | YES字段 |
 |
| collectmoney | numeric | YES | YES字段 |
 |
| requestmoney | numeric | YES | YES字段 |
 |
| notrequestmoney | numeric | YES | YES字段 |
 |
| marktime | timestamp without time zone | YES | YES字段 |
 |
| singtime | character varying | YES | YES字段 |
 |
| purchaseengineer | character varying | YES | YES字段 |
 |
| controlmoney | character varying | YES | YES字段 |
 |
| verifytime | character varying | YES | YES字段 |
 |
| juridicalperson | character varying | YES | YES字段 |
 |
| approvetime | character varying | YES | YES字段 |
 |
| delegateagent | character varying | YES | YES字段 |
 |
| effecttime | character varying | YES | YES字段 |
 |
| compacter | character varying | YES | YES字段 |
 |
| receivetime | character varying | YES | YES字段 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| safekeep | character varying | YES | YES字段 |
 |
| checker | character varying | YES | YES字段 |
 |
| checkismark | bigint | YES | YES字段 |
 |
| canceltime | character varying | YES | YES字段 |
 |
| beforepaymoney | numeric | YES | YES字段 |
 |
| beforepaybalance | numeric | YES | YES字段 |
 |
| payismark | bigint | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| relatedconstractcode | character varying | YES | ''::character varying |
 |

### t_wzcompactcheck

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzcompactcheck_id_s |
 |
| compactcode | character varying | NO | NO字段 |
 |
| plancode | character varying | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| suppliername | character varying | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| objectname | character varying | YES | YES字段 |
 |
| model | character varying | YES | YES字段 |
 |
| criterion | character varying | YES | YES字段 |
 |
| grade | character varying | YES | YES字段 |
 |
| unit | bigint | YES | 计量单位 |
 |
| compactnumber | numeric | YES | YES字段 |
 |
| arrivalgoodsname | character varying | YES | YES字段 |
 |
| arrivalgoodsmodel | character varying | YES | YES字段 |
 |
| arrivalgoodsnumber | numeric | YES | YES字段 |
 |
| factory | character varying | YES | YES字段 |
 |
| batchno | character varying | YES | YES字段 |
 |
| executionstandard | character varying | YES | YES字段 |
 |
| deliverystatus | character varying | YES | YES字段 |
 |
| checkcode | character varying | YES | YES字段 |
 |
| checker | character varying | YES | YES字段 |
 |
| checkerdate | character varying | YES | YES字段 |
 |
| checkdocument | character varying | YES | YES字段 |
 |
| checkdocumenturl | character varying | YES | YES字段 |
 |
| reinspectionrecord | character varying | YES | YES字段 |
 |
| reinspectionrecordurl | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| compactdetailid | bigint | YES | YES字段 |
 |

### t_wzcompactdetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzcompactdetail_id_ |
 |
| compactcode | character varying | YES | YES字段 |
 |
| plandetailid | bigint | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| standardcode | character varying | YES | YES字段 |
 |
| factory | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| compactnumber | numeric | YES | YES字段 |
 |
| compactprice | numeric | YES | YES字段 |
 |
| compactmoney | numeric | YES | YES字段 |
 |
| checkcode | character varying | YES | YES字段 |
 |
| collectnumber | numeric | YES | YES字段 |
 |
| collectmoney | numeric | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |
| isprint | bigint | YES | YES字段 |
 |
| purchasedetailid | bigint | YES | YES字段 |
 |
| objectname | character varying | YES | YES字段 |
 |
| model | character varying | YES | YES字段 |
 |
| grade | character varying | YES | YES字段 |
 |
| criterion | character varying | YES | YES字段 |
 |
| unit | bigint | YES | 计量单位 |
 |
| ischeck | bigint | YES | YES字段 |
 |

### t_wzdivide

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| dividecode | character varying | NO | NO字段 |
 |
| dividetype | character varying | YES | YES字段 |
 |
| dlcode | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzexpert

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzexpert_id_seq'::r |
 |
| expertcode | character varying | YES | YES字段 |
 |
| name | character varying | YES | 名称 |
 |
| workunit | character varying | YES | YES字段 |
 |
| job | character varying | YES | YES字段 |
 |
| jobtitle | character varying | YES | YES字段 |
 |
| phone | character varying | YES | 联系电话 |
 |
| experttype | character varying | YES | YES字段 |
 |
| workingpoint | bigint | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createcode | character varying | YES | YES字段 |
 |
| type | character varying | YES | 类型分类 |
 |
| engagedcategory | text | YES | YES字段 |
 |
| laborexpertise | text | YES | YES字段 |
 |
| procurementcategory | character varying | YES | YES字段 |
 |
| notlaborexpertise | text | YES | YES字段 |
 |
| actionoutstanding | text | YES | YES字段 |
 |
| goodperformance | text | YES | YES字段 |
 |
| successfulcasepro | text | YES | YES字段 |
 |
| literatureworks | text | YES | YES字段 |
 |
| patentinvention | text | YES | YES字段 |
 |
| scientificachieve | text | YES | YES字段 |
 |
| managementinnovation | text | YES | YES字段 |
 |
| badtrackrecord | text | YES | YES字段 |
 |
| experttype2 | character varying | YES | YES字段 |
 |

### t_wzexpertdatabase

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| expertcode | character varying | NO | NO字段 |
 |
| expertnumber | character varying | YES | YES字段 |
 |
| name | character varying | YES | 名称 |
 |
| usercode | character varying | YES | 用户编码，登录账号 |
 |
| job | character varying | YES | YES字段 |
 |
| jobtitle | character varying | YES | YES字段 |
 |
| phone | character varying | YES | 联系电话 |
 |
| experttype | character varying | YES | YES字段 |
 |
| experttypechina | character varying | YES | YES字段 |
 |
| workingpoint | bigint | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |
| createcode | character varying | YES | YES字段 |
 |

### t_wzgetunit

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| unitcode | character varying | NO | NO字段 |
 |
| unitname | character varying | YES | 单位名称 |
 |
| leader | character varying | YES | YES字段 |
 |
| delegateagent | character varying | YES | YES字段 |
 |
| feemanage | character varying | YES | YES字段 |
 |
| materialperson | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzmaterialdl

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| dlcode | character varying | NO | NO字段 |
 |
| dlname | character varying | YES | YES字段 |
 |
| dldesc | character varying | YES | YES字段 |
 |

### t_wzmaterialxl

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| xlcode | character varying | NO | NO字段 |
 |
| dlcode | character varying | YES | YES字段 |
 |
| zlcode | character varying | YES | YES字段 |
 |
| xlname | character varying | YES | YES字段 |
 |
| xldesc | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |
| createprogress | character varying | YES | YES字段 |
 |
| creater | character varying | YES | YES字段 |
 |
| createtitle | bigint | YES | YES字段 |
 |

### t_wzmaterialzl

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| zlcode | character varying | NO | NO字段 |
 |
| dlcode | character varying | YES | YES字段 |
 |
| zlname | character varying | YES | YES字段 |
 |
| zldesc | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |
| createprogress | character varying | YES | YES字段 |
 |
| creater | character varying | YES | YES字段 |
 |
| createtitle | bigint | YES | YES字段 |
 |

### t_wzneedobject

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzneedobject_id_seq |
 |
| needcode | character varying | YES | YES字段 |
 |
| vendee | character varying | YES | YES字段 |
 |
| persondelegate | character varying | YES | YES字段 |
 |
| openingbank | character varying | YES | YES字段 |
 |
| accountnumber | character varying | YES | YES字段 |
 |
| ratenumber | character varying | YES | YES字段 |
 |
| unitaddress | character varying | YES | YES字段 |
 |
| zipcode | character varying | YES | YES字段 |
 |
| accountphone | character varying | YES | YES字段 |
 |
| interneturl | character varying | YES | YES字段 |
 |
| purchaseengineer | character varying | YES | YES字段 |
 |
| fax | character varying | YES | 传真号码 |
 |
| contactphone | character varying | YES | YES字段 |
 |
| mobile | character varying | YES | 手机号码 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| qq | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzobject

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| objectcode | character varying | NO | NO字段 |
 |
| dlcode | character varying | YES | YES字段 |
 |
| zlcode | character varying | YES | YES字段 |
 |
| xlcode | character varying | YES | YES字段 |
 |
| creater | character varying | YES | YES字段 |
 |
| objectname | character varying | YES | YES字段 |
 |
| model | character varying | YES | YES字段 |
 |
| grade | character varying | YES | YES字段 |
 |
| criterion | character varying | YES | YES字段 |
 |
| unit | bigint | YES | 计量单位 |
 |
| convertunit | bigint | YES | YES字段 |
 |
| convertratio | numeric | YES | YES字段 |
 |
| referdesc | character varying | YES | YES字段 |
 |
| referstandard | character varying | YES | YES字段 |
 |
| market | numeric | YES | YES字段 |
 |
| collecttime | timestamp without time zone | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzobjectrefer

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| objectcode | character varying | YES | YES字段 |
 |
| xlcode | character varying | YES | YES字段 |
 |
| objectname | character varying | YES | YES字段 |
 |
| model | character varying | YES | YES字段 |
 |
| criterion | character varying | YES | YES字段 |
 |
| grade | character varying | YES | YES字段 |
 |
| unit | bigint | YES | 计量单位 |
 |
| convertunit | bigint | YES | YES字段 |
 |
| convertratio | numeric | YES | YES字段 |
 |
| referdesc | character varying | YES | YES字段 |
 |
| referstandard | character varying | YES | YES字段 |
 |

### t_wzobjectreplace

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzobjectreplace_id_ |
 |
| oldobjectcode | character varying | YES | YES字段 |
 |
| newobjectcode | character varying | YES | YES字段 |
 |

### t_wzpay

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| payid | character varying | NO | NO字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| payname | character varying | YES | YES字段 |
 |
| paytotal | numeric | YES | YES字段 |
 |
| rownumber | bigint | YES | YES字段 |
 |
| paytime | timestamp without time zone | YES | YES字段 |
 |
| marker | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzpayapprove

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpayapprove_id_seq |
 |
| advancecode | character varying | YES | YES字段 |
 |
| payid | character varying | YES | YES字段 |
 |
| payname | character varying | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| planmoney | numeric | YES | YES字段 |
 |
| marker | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| confirmmoney | numeric | YES | YES字段 |
 |
| paytime | timestamp without time zone | YES | YES字段 |
 |
| approver | character varying | YES | YES字段 |
 |

### t_wzpaydetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpaydetail_id_seq' |
 |
| payid | character varying | YES | YES字段 |
 |
| requestcode | character varying | YES | YES字段 |
 |
| canceltime | timestamp without time zone | YES | YES字段 |
 |
| compactcode | character varying | YES | YES字段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| supplier | character varying | YES | YES字段 |
 |
| planmoney | numeric | YES | YES字段 |
 |
| borrower | character varying | YES | YES字段 |
 |
| useway | character varying | YES | YES字段 |
 |
| payprocess | character varying | YES | YES字段 |
 |

### t_wzpickingplan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| plancode | character varying | NO | NO字段 |
 |
| sincenumber | character varying | YES | YES字段 |
 |
| planname | character varying | YES | 计划名称 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| pickingunit | character varying | YES | YES字段 |
 |
| unitcode | character varying | YES | YES字段 |
 |
| supplymethod | character varying | YES | YES字段 |
 |
| detailcount | bigint | YES | YES字段 |
 |
| plancost | numeric | YES | YES字段 |
 |
| planmarker | character varying | YES | YES字段 |
 |
| markertime | timestamp without time zone | YES | YES字段 |
 |
| committime | character varying | YES | YES字段 |
 |
| feemanage | character varying | YES | YES字段 |
 |
| approvetime | character varying | YES | YES字段 |
 |
| purchaseengineer | character varying | YES | YES字段 |
 |
| signtime | character varying | YES | YES字段 |
 |
| returnreason | character varying | YES | YES字段 |
 |
| canceltime | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzpickingplandetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpickingplandetail |
 |
| plancode | character varying | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| plannumber | numeric | YES | YES字段 |
 |
| convertnumber | numeric | YES | YES字段 |
 |
| plancost | numeric | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| receivednumber | numeric | YES | YES字段 |
 |
| shortnumber | numeric | YES | YES字段 |
 |
| shortconver | numeric | YES | YES字段 |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| contractcode | character varying | YES | YES字段 |
 |
| turncode | character varying | YES | YES字段 |
 |
| storesign | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| oldcode | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzproject

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| projectcode | character varying | NO | 项目编号，如PJ202606210001 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| projectmanager | character varying | YES | YES字段 |
 |
| starttime | timestamp without time zone | YES | 开始时间 |
 |
| endtime | timestamp without time zone | YES | YES字段 |
 |
| powerpurchase | character varying | YES | YES字段 |
 |
| forcost | numeric | YES | YES字段 |
 |
| selfcost | numeric | YES | YES字段 |
 |
| buildunit | character varying | YES | YES字段 |
 |
| supervisorunit | character varying | YES | YES字段 |
 |
| projectdesc | character varying | YES | YES字段 |
 |
| marktime | timestamp without time zone | YES | YES字段 |
 |
| marker | character varying | YES | YES字段 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| delegateagent | character varying | YES | YES字段 |
 |
| purchasemanager | character varying | YES | YES字段 |
 |
| purchaseengineer | character varying | YES | YES字段 |
 |
| contracter | character varying | YES | YES字段 |
 |
| checker | character varying | YES | YES字段 |
 |
| safekeep | character varying | YES | YES字段 |
 |
| supplementeditor | character varying | YES | YES字段 |
 |
| thebudget | numeric | YES | YES字段 |
 |
| contractmoney | numeric | YES | YES字段 |
 |
| acceptmoney | numeric | YES | YES字段 |
 |
| projecttax | numeric | YES | YES字段 |
 |
| thefreight | numeric | YES | YES字段 |
 |
| sendmoney | numeric | YES | YES字段 |
 |
| finishingrate | numeric | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| relatedcode | character varying | YES | YES字段 |
 |
| isstatus | character varying | YES | YES字段 |
 |
| leader | character varying | YES | YES字段 |
 |
| feemanage | character varying | YES | YES字段 |
 |
| unittype | character varying | YES | YES字段 |
 |
| shenjianlu | numeric | YES | 0 |
 |
| shenjiane | numeric | YES | 0 |
 |
| taxrate | numeric | YES | 0 |
 |
| taxamount | numeric | YES | 0 |
 |
| baoguanzonge | numeric | YES | 0 |
 |
| projectattribute | character varying | YES | ''::character varying |
 |
| projectnature | character varying | YES | ''::character varying |
 |
| relatedprojectid | bigint | YES | 0 |
 |

### t_wzprojectattribute

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzprojectattribute_ |
 |
| attributecode | character varying | NO | NO字段 |
 |
| attributedesc | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |

### t_wzprojectnature

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzprojectnature_id_ |
 |
| naturecode | character varying | NO | NO字段 |
 |
| naturedesc | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | 0 |
 |

### t_wzpurchase

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| purchasecode | character varying | NO | NO字段 |
 |
| purchasename | character varying | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| marktime | timestamp without time zone | YES | YES字段 |
 |
| purchaseengineer | character varying | YES | YES字段 |
 |
| purchasemanager | character varying | YES | YES字段 |
 |
| decision | character varying | YES | YES字段 |
 |
| tendercompetent | character varying | YES | YES字段 |
 |
| upleader | character varying | YES | YES字段 |
 |
| purchasemethod | character varying | YES | YES字段 |
 |
| purchasedocument | character varying | YES | YES字段 |
 |
| purchasedocumenturl | character varying | YES | YES字段 |
 |
| assessmentdocument | character varying | YES | YES字段 |
 |
| assessmentdocumenturl | character varying | YES | YES字段 |
 |
| rownumber | bigint | YES | YES字段 |
 |
| planmoney | numeric | YES | YES字段 |
 |
| totalmoney | numeric | YES | YES字段 |
 |
| disciplinarysupervision | character varying | YES | YES字段 |
 |
| controlmoney | character varying | YES | YES字段 |
 |
| purchasestarttime | character varying | YES | YES字段 |
 |
| purchaseendtime | character varying | YES | YES字段 |
 |
| decisiontime | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| suppliercode1 | character varying | YES | YES字段 |
 |
| suppliercode2 | character varying | YES | YES字段 |
 |
| suppliercode3 | character varying | YES | YES字段 |
 |
| suppliercode4 | character varying | YES | YES字段 |
 |
| suppliercode5 | character varying | YES | YES字段 |
 |
| suppliercode6 | character varying | YES | YES字段 |
 |
| expertcode1 | character varying | YES | YES字段 |
 |
| expertcode2 | character varying | YES | YES字段 |
 |
| expertcode3 | character varying | YES | YES字段 |
 |
| expertcode4 | character varying | YES | YES字段 |
 |
| expertcode5 | character varying | YES | YES字段 |
 |
| expertcode6 | character varying | YES | YES字段 |
 |
| tenderdocument1 | character varying | YES | YES字段 |
 |
| tenderdocumenturl1 | character varying | YES | YES字段 |
 |
| tenderdocument2 | character varying | YES | YES字段 |
 |
| tenderdocumenturl2 | character varying | YES | YES字段 |
 |
| tenderdocument3 | character varying | YES | YES字段 |
 |
| tenderdocumenturl3 | character varying | YES | YES字段 |
 |
| tenderdocument4 | character varying | YES | YES字段 |
 |
| tenderdocumenturl4 | character varying | YES | YES字段 |
 |
| tenderdocument5 | character varying | YES | YES字段 |
 |
| tenderdocumenturl5 | character varying | YES | YES字段 |
 |
| tenderdocument6 | character varying | YES | YES字段 |
 |
| tenderdocumenturl6 | character varying | YES | YES字段 |
 |

### t_wzpurchasedecision

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpurchasedecision_ |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| suppliercode1 | character varying | YES | YES字段 |
 |
| suppliercode2 | character varying | YES | YES字段 |
 |
| suppliercode3 | character varying | YES | YES字段 |
 |
| decision | character varying | YES | YES字段 |
 |
| decisiontime | timestamp without time zone | YES | now() |
 |
| decisiondesc | character varying | YES | YES字段 |
 |

### t_wzpurchasedetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpurchasedetail_id |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| plandetailid | bigint | YES | YES字段 |
 |
| serialnumber | character varying | YES | YES字段 |
 |
| tenders | character varying | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| majortype | character varying | YES | YES字段 |
 |
| purchasenumber | numeric | YES | YES字段 |
 |
| convertnumber | numeric | YES | YES字段 |
 |
| planmoney | numeric | YES | YES字段 |
 |
| factory | character varying | YES | YES字段 |
 |
| standardcode | character varying | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| applymoney | numeric | YES | YES字段 |
 |
| totalmoney | numeric | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| isprint | bigint | YES | YES字段 |
 |

### t_wzpurchasedocument

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpurchasedocument_ |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| documentname | character varying | YES | YES字段 |
 |
| documenturl | character varying | YES | YES字段 |
 |

### t_wzpurchaseexpert

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpurchaseexpert_id |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| expertcode | character varying | YES | YES字段 |
 |
| expertname | character varying | YES | YES字段 |
 |

### t_wzpurchaseofferrecord

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpurchaseofferreco |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| plandetailid | bigint | YES | YES字段 |
 |
| purchasedetailid | bigint | YES | YES字段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| tenders | character varying | YES | YES字段 |
 |
| serialnumber | character varying | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| objectname | character varying | YES | YES字段 |
 |
| model | character varying | YES | YES字段 |
 |
| criterion | character varying | YES | YES字段 |
 |
| grade | character varying | YES | YES字段 |
 |
| unit | bigint | YES | 计量单位 |
 |
| purchasenumber | numeric | YES | YES字段 |
 |
| applymoney | numeric | YES | YES字段 |
 |
| totalmoney | numeric | YES | YES字段 |
 |
| replacecode | character varying | YES | YES字段 |
 |
| scalingresult | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |

### t_wzpurchasesupplier

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzpurchasesupplier_ |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| suppliername | character varying | YES | YES字段 |
 |
| documentname | character varying | YES | YES字段 |
 |
| documenturl | character varying | YES | YES字段 |
 |
| isconfirm | character varying | YES | YES字段 |
 |

### t_wzreduce

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| reducecode | character varying | NO | NO字段 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| plantime | timestamp without time zone | YES | YES字段 |
 |
| planmoney | numeric | YES | YES字段 |
 |
| excutetime | character varying | YES | YES字段 |
 |
| detailnumber | bigint | YES | YES字段 |
 |
| storetotalmoney | numeric | YES | YES字段 |
 |
| storedownmoney | numeric | YES | YES字段 |
 |
| cleanmoney | numeric | YES | YES字段 |
 |
| totalnumber | bigint | YES | YES字段 |
 |
| totalstore | numeric | YES | YES字段 |
 |
| totalratio | numeric | YES | YES字段 |
 |
| totaldownmoney | numeric | YES | YES字段 |
 |
| totalcleanmoney | numeric | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| process | character varying | YES | YES字段 |
 |
| mainleader | character varying | YES | YES字段 |
 |
| marker | character varying | YES | YES字段 |
 |

### t_wzrequest

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| requestcode | character varying | NO | NO字段 |
 |
| compactcode | character varying | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| useway | character varying | YES | YES字段 |
 |
| actualmoney | numeric | YES | YES字段 |
 |
| ratiomoney | numeric | YES | YES字段 |
 |
| freight | numeric | YES | YES字段 |
 |
| otherobject | numeric | YES | YES字段 |
 |
| borrowmoney | numeric | YES | YES字段 |
 |
| rownumber | bigint | YES | YES字段 |
 |
| borrower | character varying | YES | YES字段 |
 |
| requesttime | timestamp without time zone | YES | YES字段 |
 |
| approver | character varying | YES | YES字段 |
 |
| canceltime | character varying | YES | YES字段 |
 |
| beforepaymoney | numeric | YES | YES字段 |
 |
| paymoney | numeric | YES | YES字段 |
 |
| arrearage | numeric | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ispay | bigint | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |
| isfinisth | bigint | YES | YES字段 |
 |

### t_wzsend

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| sendcode | character varying | NO | NO字段 |
 |
| plandetaiid | bigint | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| tickettime | timestamp without time zone | YES | YES字段 |
 |
| sendmethod | character varying | YES | YES字段 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| plannumber | numeric | YES | YES字段 |
 |
| actualnumber | numeric | YES | YES字段 |
 |
| planprice | numeric | YES | YES字段 |
 |
| planmoney | numeric | YES | YES字段 |
 |
| saleprice | numeric | YES | YES字段 |
 |
| salemoney | numeric | YES | YES字段 |
 |
| managerate | numeric | YES | YES字段 |
 |
| managemoney | numeric | YES | YES字段 |
 |
| totalmoney | numeric | YES | YES字段 |
 |
| downmoney | numeric | YES | YES字段 |
 |
| cleanmoney | numeric | YES | YES字段 |
 |
| reducecode | character varying | YES | YES字段 |
 |
| wearycode | character varying | YES | YES字段 |
 |
| goodscode | character varying | YES | 物品编码 |
 |
| checkcode | character varying | YES | YES字段 |
 |
| checktime | character varying | YES | 审核时间 |
 |
| checker | character varying | YES | YES字段 |
 |
| sendtime | character varying | YES | 发送时间 |
 |
| safekeeper | character varying | YES | YES字段 |
 |
| purchaseengineer | character varying | YES | YES字段 |
 |
| unitcode | character varying | YES | YES字段 |
 |
| pickingunit | character varying | YES | YES字段 |
 |
| upleader | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| carcode | character | YES | ''::bpchar |
 |
| comment | character varying | YES | ''::character varying |
 |

### t_wzspan

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzspan_id_seq'::reg |
 |
| unitname | character varying | YES | 单位名称 |
 |

### t_wzstate

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzstate_id_seq'::re |
 |
| cyear | character varying | YES | YES字段 |
 |
| cmonth | character varying | YES | YES字段 |
 |
| cpath | character varying | YES | YES字段 |
 |
| pass | character varying | YES | YES字段 |
 |

### t_wzstock

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzstock_id_seq'::re |
 |
| stockcode | character varying | YES | YES字段 |
 |
| stockdesc | character varying | YES | YES字段 |
 |
| safekeep | character varying | YES | YES字段 |
 |
| checker | character varying | YES | YES字段 |
 |
| ismark | bigint | YES | YES字段 |
 |
| iscancel | bigint | YES | YES字段 |
 |

### t_wzstore

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzstore_id_seq'::re |
 |
| stockcode | character varying | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| checkcode | character varying | YES | YES字段 |
 |
| yeartime | timestamp without time zone | YES | YES字段 |
 |
| yearnumber | numeric | YES | YES字段 |
 |
| yearprice | numeric | YES | YES字段 |
 |
| yearmoney | numeric | YES | YES字段 |
 |
| innumber | numeric | YES | YES字段 |
 |
| inmoney | numeric | YES | YES字段 |
 |
| endintime | timestamp without time zone | YES | YES字段 |
 |
| outnumber | numeric | YES | YES字段 |
 |
| outprice | numeric | YES | YES字段 |
 |
| endouttime | timestamp without time zone | YES | YES字段 |
 |
| storenumber | numeric | YES | YES字段 |
 |
| storeprice | numeric | YES | YES字段 |
 |
| storemoney | numeric | YES | YES字段 |
 |
| downratio | numeric | YES | YES字段 |
 |
| downmoney | numeric | YES | YES字段 |
 |
| cleanmoney | numeric | YES | YES字段 |
 |
| downcode | character varying | YES | YES字段 |
 |
| downdesc | bigint | YES | YES字段 |
 |
| wearycode | character varying | YES | YES字段 |
 |
| wearydesc | bigint | YES | YES字段 |
 |
| goodscode | character varying | YES | 物品编码 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzsupplier

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzsupplier_id_seq': |
 |
| suppliercode | character varying | NO | NO字段 |
 |
| suppliernumber | character varying | YES | YES字段 |
 |
| suppliername | character varying | YES | YES字段 |
 |
| openingbank | character varying | YES | YES字段 |
 |
| accountnumber | character varying | YES | YES字段 |
 |
| ratenumber | character varying | YES | YES字段 |
 |
| unitaddress | character varying | YES | YES字段 |
 |
| zipcode | character varying | YES | YES字段 |
 |
| unitphone | character varying | YES | YES字段 |
 |
| persondelegate | character varying | YES | YES字段 |
 |
| delegateagent | character varying | YES | YES字段 |
 |
| contactphone | character varying | YES | YES字段 |
 |
| mobile | character varying | YES | 手机号码 |
 |
| qq | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| mainsupplier | character varying | YES | YES字段 |
 |
| indocumenturl | character varying | YES | YES字段 |
 |
| indocument | character varying | YES | YES字段 |
 |
| intime | timestamp without time zone | YES | YES字段 |
 |
| pushunit | character varying | YES | YES字段 |
 |
| grade | character varying | YES | YES字段 |
 |
| auditor | character varying | YES | YES字段 |
 |
| approvetime | character varying | YES | YES字段 |
 |
| reviewdate | character varying | YES | YES字段 |
 |
| reviewdocument | character varying | YES | YES字段 |
 |
| reviewdocumenturl | character varying | YES | YES字段 |
 |
| reviewresult | character varying | YES | YES字段 |
 |
| qualityengineer | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| pushperson | character varying | YES | YES字段 |
 |
| approvaldocument | character varying | YES | YES字段 |
 |
| approvaldocumenturl | character varying | YES | YES字段 |
 |
| competentmaterials | character varying | YES | YES字段 |
 |
| contractwhose | character varying | YES | YES字段 |
 |
| competentleadership | character varying | YES | YES字段 |
 |
| competentmaterialsdocument | character varying | YES | YES字段 |
 |
| competentmaterialsdocumenturl | character varying | YES | YES字段 |
 |
| contractwhosedocument | character varying | YES | YES字段 |
 |
| contractwhosedocumenturl | character varying | YES | YES字段 |
 |
| competentleadershipdocument | character varying | YES | YES字段 |
 |
| competentleadershipdocumenturl | character varying | YES | YES字段 |
 |

### t_wzsupplierapplycomment

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzsupplierapplycomm |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| expertcode | character varying | YES | YES字段 |
 |
| suppliercode1 | character varying | YES | YES字段 |
 |
| suppliercode2 | character varying | YES | YES字段 |
 |
| suppliercode3 | character varying | YES | YES字段 |
 |
| signname | character varying | YES | YES字段 |
 |
| suggest | character varying | YES | YES字段 |
 |
| signtime | timestamp without time zone | YES | YES字段 |
 |

### t_wzsupplierapplydetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzsupplierapplydeta |
 |
| purchasecode | character varying | YES | YES字段 |
 |
| plancode | character varying | YES | YES字段 |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| purchasedetailid | bigint | YES | YES字段 |
 |
| applymoney | numeric | YES | YES字段 |
 |

### t_wzsupplierinfo

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzsupplierinfo_id_s |
 |
| suppliercode | character varying | YES | YES字段 |
 |
| supplierpass | character varying | YES | YES字段 |
 |
| suppliername | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | now() |
 |

### t_wzsupplierregister

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzsupplierregister_ |
 |
| suppliernumber | character varying | YES | YES字段 |
 |
| suppliername | character varying | YES | YES字段 |
 |
| openingbank | character varying | YES | YES字段 |
 |
| accountnumber | character varying | YES | YES字段 |
 |
| ratenumber | character varying | YES | YES字段 |
 |
| unitaddress | character varying | YES | YES字段 |
 |
| zipcode | character varying | YES | YES字段 |
 |
| unitphone | character varying | YES | YES字段 |
 |
| persondelegate | character varying | YES | YES字段 |
 |
| delegateagent | character varying | YES | YES字段 |
 |
| contactphone | character varying | YES | YES字段 |
 |
| mobile | character varying | YES | 手机号码 |
 |
| qq | character varying | YES | YES字段 |
 |
| email | character varying | YES | 电子邮箱 |
 |
| indocumenturl | character varying | YES | YES字段 |
 |
| indocument | character varying | YES | YES字段 |
 |
| intime | timestamp without time zone | YES | YES字段 |
 |
| pushunit | character varying | YES | YES字段 |
 |
| grade | character varying | YES | YES字段 |
 |
| auditor | character varying | YES | YES字段 |
 |
| approvetime | character varying | YES | YES字段 |
 |
| reviewdate | character varying | YES | YES字段 |
 |
| reviewdocument | character varying | YES | YES字段 |
 |
| reviewdocumenturl | character varying | YES | YES字段 |
 |
| reviewresult | character varying | YES | YES字段 |
 |
| qualityengineer | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| pushperson | character varying | YES | YES字段 |
 |

### t_wzsuppliertemplatefile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzsuppliertemplatef |
 |
| templatefilename | character varying | NO | NO字段 |
 |
| templatefileurl | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |

### t_wzsupplierworkflow

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzsupplierworkflow_ |
 |
| templatecontent | character varying | YES | YES字段 |
 |
| createtime | timestamp without time zone | YES | 创建时间 |
 |

### t_wztemplatefile

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wztemplatefile_id_s |
 |
| templatetype | character varying | YES | YES字段 |
 |
| templatename | character varying | YES | 模板名称 |
 |
| templateurl | character varying | YES | YES字段 |
 |

### t_wzturn

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzturn_id_seq'::reg |
 |
| turncode | character varying | NO | NO字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| projectname | character varying | YES | 项目名称 |
 |
| unitcode | character varying | YES | YES字段 |
 |
| pickingunit | character varying | YES | YES字段 |
 |
| turntime | timestamp without time zone | YES | YES字段 |
 |
| purchaseengineer | character varying | YES | YES字段 |
 |
| singtime | character varying | YES | YES字段 |
 |
| materialperson | character varying | YES | YES字段 |
 |
| finishtime | character varying | YES | 完成时间 |
 |
| checkperson | character varying | YES | YES字段 |
 |
| rownumber | bigint | YES | YES字段 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |

### t_wzturndetail

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_wzturndetail_id_seq |
 |
| turncode | character varying | YES | YES字段 |
 |
| projectcode | character varying | YES | 项目编号，如PJ202606210001 |
 |
| pickingunit | character varying | YES | YES字段 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| pickingcode | character varying | YES | YES字段 |
 |
| pickingmethod | character varying | YES | YES字段 |
 |
| nocode | character varying | YES | YES字段 |
 |
| plancode | character varying | YES | YES字段 |
 |
| objectcode | character varying | YES | YES字段 |
 |
| ticketnumber | numeric | YES | YES字段 |
 |
| actualnumber | numeric | YES | YES字段 |
 |
| ticketprice | numeric | YES | YES字段 |
 |
| ticketmoney | numeric | YES | YES字段 |
 |
| tickettime | timestamp without time zone | YES | YES字段 |
 |
| pickingtime | timestamp without time zone | YES | YES字段 |
 |
| materialperson | character varying | YES | YES字段 |
 |
| progress | character varying | YES | 进度百分比 |
 |
| ismark | bigint | YES | YES字段 |
 |
| cardcode | character varying | YES | YES字段 |
 |
| planprice | numeric | YES | YES字段 |
 |
| planmoney | numeric | YES | YES字段 |
 |
| cardperson | character varying | YES | YES字段 |
 |
| cardismark | bigint | YES | YES字段 |
 |

### t_wzweary

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| wearycode | character varying | NO | NO字段 |
 |
| storeroom | character varying | YES | YES字段 |
 |
| plantime | timestamp without time zone | YES | YES字段 |
 |
| wearytotalmoney | numeric | YES | YES字段 |
 |
| rownumber | bigint | YES | YES字段 |
 |
| wearybalance | numeric | YES | YES字段 |
 |
| overnumber | bigint | YES | YES字段 |
 |
| remark | character varying | YES | 备注说明 |
 |
| process | character varying | YES | YES字段 |
 |
| mainleader | character varying | YES | YES字段 |
 |
| marker | character varying | YES | YES字段 |
 |
| totalyear | bigint | YES | YES字段 |
 |

### t_xmlnamespace

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('t_xmlnamespace_id_seq |
 |
| wltemname | character varying | YES | YES字段 |
 |
| xmlnamespacename | character varying | YES | YES字段 |
 |
| xmlnamespacevalue | character varying | YES | YES字段 |
 |

### task

| 字段名 | 类型 | 可空 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | bigint | NO | nextval('task_id_seq'::regclas |
 |
| end_date | timestamp without time zone | YES | YES字段 |
 |
| percent_done | bigint | NO | NO字段 |
 |
| name | character varying | NO | 名称 |
 |
| priority | bigint | NO | 优先级，如Normal/High/Low |
 |
| baseline_start_date | timestamp without time zone | YES | YES字段 |
 |
| baseline_end_date | timestamp without time zone | YES | YES字段 |
 |
| parent_id | bigint | YES | YES字段 |
 |
| duration | double precision | YES | YES字段 |
 |
| duration_unit | character varying | YES | YES字段 |
 |
| other_field | character varying | YES | YES字段 |
 |
| pid | bigint | YES | YES字段 |
 |
| start_date | timestamp without time zone | YES | YES字段 |
 |
| index | bigint | YES | YES字段 |
 |
---

## 附录B：内部/系统/配置表

---

## 附录C：DW/WPQM子表

### T_Dwtravelexpenseschild1（DW差旅费用子表1）

> 表名: t_dwtravelexpenseschild1 | 行数: 0

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| id | bigint | 记录ID | 主键，自增 |
| leibie1 | varchar(200) | 类别1 | 类别1字段 |
| mingxi1 | varchar(200) | 明细1 | 明细1字段 |
| feiyong1 | numeric | 费用1 | 费用1字段 |
| mainid | bigint | 主表ID | 主表ID字段 |

### T_Dwtravelexpenseschild2（DW差旅费用子表2）

> 表名: t_dwtravelexpenseschild2 | 行数: 0

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| id | bigint | 记录ID | 主键，自增 |
| leibie2 | varchar(200) | 类别2 | 类别2字段 |
| mingxi2 | varchar(200) | 明细2 | 明细2字段 |
| feiyong2 | numeric | 费用2 | 费用2字段 |
| mainid | bigint | 主表ID | 主表ID字段 |

### T_Wpqmpqr1（WPQM PQR1表）

> 表名: t_wpqmpqr1 | 行数: 1

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| id | bigint | 记录ID | 主键，自增 |
| weldprocode | varchar(50) | 焊接工艺代码 | 焊接工艺代码字段 |
| weldjointother | varchar(100) | 焊接接头其他 | 焊接接头其他字段 |
| metalother | varchar(100) | 金属其他 | 金属其他字段 |
| weldmetalthick | varchar(50) | 焊缝金属厚度 | 焊缝金属厚度字段 |
| fillermetalother | varchar(250) | 填充金属其他 | 填充金属其他字段 |
| weldingcurrent | varchar(50) | 焊接电流 | 焊接电流字段 |
| arcvoltage | varchar(50) | 电弧电压 | 电弧电压字段 |
| eleccharaother | text | 电学特性其他 | 电学特性其他字段 |
| weldingspeed | varchar(50) | 焊接速度 | 焊接速度字段 |
| securitymeasureother | text | 安全措施其他 | 安全措施其他字段 |
| entercode | varchar(50) | 录入编码 | 录入编码字段 |

### T_Wpqmpqr2（WPQM PQR2表）

> 表名: t_wpqmpqr2 | 行数: 1

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| id | bigint | 记录ID | 主键，自增 |
| weldprocode | varchar(50) | 焊接工艺代码 | 焊接工艺代码字段 |
| appinsconclusion | text | 附加检测结论 | 附加检测结论字段 |
| appinsevaresults | text | 附加检测评估结果 | 附加检测评估结果字段 |
| tensiletestreportno | varchar(50) | 拉伸试验报告号 | 拉伸试验报告号字段 |
| tenspewidth | varchar(50) | 拉伸试样宽度 | 拉伸试样宽度字段 |
| tenspethickness | varchar(50) | 拉伸试样厚度 | 拉伸试样厚度字段 |
| tenspearea | varchar(50) | 拉伸试样面积 | 拉伸试样面积字段 |
| tenspebreload | varchar(50) | 拉伸试样断裂载荷 | 拉伸试样断裂载荷字段 |
| tenspeshestrength | varchar(50) | 拉伸试样强度 | 拉伸试样强度字段 |
| tenspepartchara | text | 拉伸试样部件特性 | 拉伸试样部件特性字段 |
| bendtestreportno | varchar(50) | 弯曲试验报告号 | 弯曲试验报告号字段 |
| bendspetype | varchar(200) | 弯曲试样类型 | 弯曲试样类型字段 |
| bendspethickness | varchar(50) | 弯曲试样厚度 | 弯曲试样厚度字段 |
| bendspediameter | varchar(50) | 弯曲试样直径 | 弯曲试样直径字段 |
| bendspeangle | varchar(50) | 弯曲试样角度 | 弯曲试样角度字段 |
| bendsperesults | text | 弯曲试样结果 | 弯曲试样结果字段 |
| impacttestreportno | varchar(50) | 冲击试验报告号 | 冲击试验报告号字段 |
| impactsampsize | varchar(50) | 冲击试样尺寸 | 冲击试样尺寸字段 |
| impactsamptype | varchar(200) | 冲击试样类型 | 冲击试样类型字段 |
| impactsampposition | varchar(50) | 冲击试样位置 | 冲击试样位置字段 |
| impactsamptemperature | varchar(50) | 冲击试样温度 | 冲击试样温度字段 |
| impactsampfunction | varchar(50) | 冲击试样功能 | 冲击试样功能字段 |
| impactsampexpamount | varchar(50) | 冲击试样试验数量 | 冲击试样试验数量字段 |
| impactsampremark | text | 冲击试样备注 | 冲击试样备注字段 |
| othertestname | varchar(100) | 其他试验名称 | 其他试验名称字段 |
| othertestreportno | varchar(50) | 其他试验报告号 | 其他试验报告号字段 |
| othertestsize | varchar(50) | 其他试验尺寸 | 其他试验尺寸字段 |
| otherexpremark | text | 其他表达备注 | 其他表达备注字段 |
| entercode | varchar(50) | 录入编码 | 录入编码字段 |

### T_Wpqmpqr3（WPQM PQR3表）

> 表名: t_wpqmpqr3 | 行数: 1

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| id | bigint | 记录ID | 主键，自增 |
| weldprocode | varchar(50) | 焊接工艺代码 | 焊接工艺代码字段 |
| metallographicroot | varchar(150) | 金相根部 | 金相根部字段 |
| metallographicweld | varchar(150) | 金相焊缝 | 金相焊缝字段 |
| metallographiczone | varchar(150) | 金相区域 | 金相区域字段 |
| inssecipoor | varchar(50) | 检测区I缺陷 | 检测区I缺陷字段 |
| insseciipoor | varchar(50) | 检测区II缺陷 | 检测区II缺陷字段 |
| insseciiipoor | varchar(50) | 检测区III缺陷 | 检测区III缺陷字段 |
| inssecivpoor | varchar(50) | 检测区IV缺陷 | 检测区IV缺陷字段 |
| inssecvpoor | varchar(50) | 检测区V缺陷 | 检测区V缺陷字段 |
| rtinsresult | text | 射线检测结果 | 射线检测结果字段 |
| rtrepnumber | varchar(50) | 射线检测报告号 | 射线检测报告号字段 |
| mtinsresult | text | 磁粉检测结果 | 磁粉检测结果字段 |
| mtrepnumber | varchar(50) | 磁粉检测报告号 | 磁粉检测报告号字段 |
| utinsresult | text | 超声波检测结果 | 超声波检测结果字段 |
| utrepnumber | varchar(50) | 超声波检测报告号 | 超声波检测报告号字段 |
| ptinsresult | text | 渗透检测结果 | 渗透检测结果字段 |
| ptrepnumber | varchar(50) | 渗透检测报告号 | 渗透检测报告号字段 |
| checomtestrepnumber | varchar(50) | 化学成分试验报告号 | 化学成分试验报告号字段 |
| checomp_c | varchar(50) | 化学成分C | 化学成分C字段 |
| checomp_si | varchar(50) | 化学成分Si | 化学成分Si字段 |
| checomp_mn | varchar(50) | 化学成分Mn | 化学成分Mn字段 |
| checomp_p | varchar(50) | 化学成分P | 化学成分P字段 |
| checomp_s | varchar(50) | 化学成分S | 化学成分S字段 |
| checomp_cr | varchar(50) | 化学成分Cr | 化学成分Cr字段 |
| checomp_ni | varchar(50) | 化学成分Ni | 化学成分Ni字段 |
| checomp_mo | varchar(50) | 化学成分Mo | 化学成分Mo字段 |
| checomp_cu | varchar(50) | 化学成分Cu | 化学成分Cu字段 |
| checomp_ti | varchar(50) | 化学成分Ti | 化学成分Ti字段 |
| checomp_nb | varchar(50) | 化学成分Nb | 化学成分Nb字段 |
| surfacedistance | varchar(50) | 表面距离 | 表面距离字段 |
| additionalins | text | 附加检测 | 附加检测字段 |
| conclusion | text | 结论 | 结论字段 |
| evaluationresult | text | 评估结果 | 评估结果字段 |
| weldname | varchar(50) | 焊接名称 | 焊接名称字段 |
| weldcode | varchar(50) | 焊接代码 | 焊接代码字段 |
| updatetime | timestamp without time zone | 更新时间 | 最后更新时间 |
| entercode | varchar(50) | 录入编码 | 录入编码字段 |

### T_Wpqmpwps1（WPQM WPS1表）

> 表名: t_wpqmpwps1 | 行数: 1

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| id | bigint | 记录ID | 主键，自增 |
| weldprocode | varchar(50) | 焊接工艺代码 | 焊接工艺代码字段 |
| entityname | varchar(150) | 实体名称 | 实体名称字段 |
| pwps1datetime | timestamp without time zone | 预焊接工艺规程日期时间 | 预焊接工艺规程日期时间字段 |
| mechanizationdegree | text | 机械化程度 | 机械化程度字段 |
| weldedjointother | text | 焊接接头其他 | 焊接接头其他字段 |
| weldedjointdiagram | varchar(250) | 焊接接头示意图 | 焊接接头示意图字段 |
| pwpscategory | varchar(50) | 预焊接工艺规程类别 | 预焊接工艺规程类别字段 |
| pwpsandcategory | varchar(100) | 预焊接工艺规程及类别 | 预焊接工艺规程及类别字段 |
| pwpsstandardno | varchar(50) | 预焊接工艺规程标准号 | 预焊接工艺规程标准号字段 |
| pwpsandstandardno | varchar(100) | 预焊接工艺规程及标准号 | 预焊接工艺规程及标准号字段 |
| buttweldmatethicknessrange | varchar(50) | 对接焊缝母材厚度范围 | 对接焊缝母材厚度范围字段 |
| filletweldmatethicknessrange | varchar(50) | 角焊缝母材厚度范围 | 角焊缝母材厚度范围字段 |
| buttweldotherinfo | varchar(50) | 对接焊缝其他信息 | 对接焊缝其他信息字段 |
| filletweld | varchar(100) | 角焊缝 | 角焊缝字段 |
| pwpsmetalother | text | 预焊接工艺规程金属其他 | 预焊接工艺规程金属其他字段 |
| electstandard | varchar(150) | 电学标准 | 电学标准字段 |
| wirestandard | varchar(150) | 焊丝标准 | 焊丝标准字段 |
| fluxstandard | varchar(150) | 焊剂标准 | 焊剂标准字段 |
| electinspection | varchar(50) | 电学检验 | 电学检验字段 |
| wireinspection | varchar(50) | 焊丝检验 | 焊丝检验字段 |
| fluxinspection | varchar(50) | 焊剂检验 | 焊剂检验字段 |
| buttweldmetathickrange | varchar(50) | 对接焊缝金属厚度范围 | 对接焊缝金属厚度范围字段 |
| filletweldmetathickrange | varchar(50) | 角焊缝金属厚度范围 | 角焊缝金属厚度范围字段 |
| c | varchar(50) | 碳C | 碳C字段 |
| mn | varchar(50) | 锰Mn | 锰Mn字段 |
| si | varchar(50) | 硅Si | 硅Si字段 |
| s | varchar(50) | 硫S | 硫S字段 |
| p | varchar(50) | 磷P | 磷P字段 |
| cr | varchar(50) | 铬Cr | 铬Cr字段 |
| ni | varchar(50) | 镍Ni | 镍Ni字段 |
| mo | varchar(50) | 钼Mo | 钼Mo字段 |
| cu | varchar(50) | 铜Cu | 铜Cu字段 |
| ti | varchar(50) | 钛Ti | 钛Ti字段 |
| nb | varchar(50) | 铌Nb | 铌Nb字段 |
| pwpsdescr | text | 预焊接工艺规程描述 | 预焊接工艺规程描述字段 |
| entercode | varchar(50) | 录入编码 | 录入编码字段 |

### T_Wpqmpwps2（WPQM WPS2表）

> 表名: t_wpqmpwps2 | 行数: 1

| 字段名 | 类型 | 中文含义 | 业务说明 |
|--------|------|----------|----------|
| id | bigint | 记录ID | 主键，自增 |
| weldprocode | varchar(50) | 焊接工艺代码 | 焊接工艺代码字段 |
| filletweldposition | varchar(150) | 角焊缝位置 | 角焊缝位置字段 |
| verticalweldingdirection | varchar(150) | 焊接方向 | 焊接方向字段 |
| currenttype | varchar(200) | 电流类型 | 电流类型字段 |
| polarity | varchar(50) | 极性 | 极性字段 |
| weldcurrentrange | varchar(50) | 焊接电流范围 | 焊接电流范围字段 |
| arcvoltage | varchar(50) | 电弧电压 | 电弧电压字段 |
| weldingspeed | varchar(50) | 焊接速度 | 焊接速度字段 |
| beadweldinglayer | varchar(50) | 焊道层数 | 焊道层数字段 |
| currenttypechara | varchar(200) | 电流类型特性 | 电流类型特性字段 |
| weldingcurrent | varchar(50) | 焊接电流 | 焊接电流字段 |
| lineenergy | varchar(50) | 线能量 | 线能量字段 |
| swingtype | varchar(200) | 摆动类型 | 摆动类型字段 |
| oscillationparameters | varchar(50) | 摆动参数 | 摆动参数字段 |
| passweldingtype | varchar(200) | 焊接类型 | 焊接类型字段 |
| wireweldingtype | varchar(200) | 焊丝焊接类型 | 焊丝焊接类型字段 |
| conductivemouthwork | varchar(50) | 导电嘴工作 | 导电嘴工作字段 |
| hammer | varchar(50) | 锤击 | 锤击字段 |
| entercode | varchar(50) | 录入编码 | 录入编码字段 |
