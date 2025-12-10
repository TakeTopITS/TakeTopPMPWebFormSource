using System; using System.Resources;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using ProjectMgt.BLL;
using ProjectMgt.Model;
using System.Data;
using System.Drawing;
using System.Collections;

public partial class TTWZProjectCancelList : System.Web.UI.Page
{
    public string strUserCode
    {
        get;
        set;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"] == null ? "" : Session["UserCode"].ToString().Trim();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true); if (!IsPostBack)
        {
            DataBinder("", "", "");
        }
    }

    private void DataBinder(string strProjectCode, string strProjectName, string strProgress)
    {
        DG_List.CurrentPageIndex = 0;

        string strWZProjectHQL = string.Format(@"select p.*,
                    pp.UserName as ProjectManagerName,
                    pd.UserName as DelegateAgentName,
                    pm.UserName as PurchaseManagerName,
                    pe.UserName as PurchaseEngineerName,
                    pc.UserName as ContracterName,
                    pk.UserName as CheckerName,
                    ps.UserName as SafekeepName,
                    pa.UserName as MarkerName,
                    pu.UserName as SupplementEditorName
                    from T_WZProject p
                    left join T_ProjectMember pp on p.ProjectManager = pp.UserCode
                    left join T_ProjectMember pd on p.DelegateAgent = pd.UserCode
                    left join T_ProjectMember pm on p.PurchaseManager = pm.UserCode
                    left join T_ProjectMember pe on p.PurchaseEngineer = pe.UserCode
                    left join T_ProjectMember pc on p.Contracter = pc.UserCode
                    left join T_ProjectMember pk on p.Checker = pk.UserCode
                    left join T_ProjectMember ps on p.Safekeep = ps.UserCode
                    left join T_ProjectMember pa on p.Marker = pa.UserCode
                    left join T_ProjectMember pu on p.SupplementEditor = pu.UserCode
                    where (p.Progress in ('开工' ,'核销') or p.IsStatus = '关闭')
                    and p.PurchaseEngineer = '{0}'", strUserCode);
        //        string strWZProjectHQL = string.Format(@"select p.*,
        //                    pp.UserName as ProjectManagerName,
        //                    pd.UserName as DelegateAgentName,
        //                    pf.UserName as FeeManageName,
        //                    pm.UserName as PurchaseManagerName,
        //                    pe.UserName as PurchaseEngineerName,
        //                    pc.UserName as ContracterName,
        //                    pk.UserName as CheckerName,
        //                    ps.UserName as SafekeepName
        //                    from T_WZProject p
        //                    left join T_ProjectMember pp on p.ProjectManager = pp.UserCode
        //                    left join T_ProjectMember pd on p.DelegateAgent = pd.UserCode
        //                    left join T_ProjectMember pf on p.FeeManage = pf.UserCode
        //                    left join T_ProjectMember pm on p.PurchaseManager = pm.UserCode
        //                    left join T_ProjectMember pe on p.PurchaseEngineer = pe.UserCode
        //                    left join T_ProjectMember pc on p.Contracter = pc.UserCode
        //                    left join T_ProjectMember pk on p.Checker = pk.UserCode
        //                    left join T_ProjectMember ps on p.Safekeep = ps.UserCode
        //                    where p.Progress = '立项'
        //                    and (COALESCE(SupplementEditor, '') = '' or SupplementEditor = '{0}')", strUserCode);
        if (!string.IsNullOrEmpty(strProjectCode))
        {
            strWZProjectHQL += " and p.ProjectCode = '" + strProjectCode + "'";
        }
        if (!string.IsNullOrEmpty(strProjectName))
        {
            strWZProjectHQL += " and p.ProjectName like '%" + strProjectName + "%'";
        }
        if (!string.IsNullOrEmpty(strProgress))
        {
            strWZProjectHQL += " and p.Progress = '" + strProgress + "'";
        }
        strWZProjectHQL += " order by p.MarkTime desc";
        DataTable dtProject = ShareClass.GetDataSetFromSql(strWZProjectHQL, "Project").Tables[0];

        DG_List.DataSource = dtProject;
        DG_List.DataBind();


        LB_ProjectSql.Text = strWZProjectHQL;

        LB_RecordCount.Text = dtProject.Rows.Count.ToString();
    }


    protected void DG_List_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Pager)
        {
            for (int i = 0; i < DG_List.Items.Count; i++)
            {
                DG_List.Items[i].ForeColor = Color.Black;
            }

            e.Item.ForeColor = Color.Red;

            string cmdName = e.CommandName;

            if (cmdName == "click")
            {
                //操作
                string cmdArges = e.CommandArgument.ToString();
                string[] arrOperate = cmdArges.Split('|');

                string strEditProjectCode = arrOperate[0];
                string strProgress = arrOperate[1];

                string strImportSQL = string.Format(@"select pj.ProjectCode,pj.ProjectName,
                    pd.PlanCode,pd.ObjectCode,pd.PlanNumber,pd.ShortNumber,pd.Progress as PlanDetailProgress,
                    po.ObjectName,po.Model,po.Criterion,po.Grade,
                    ps.UnitName
                    from T_WZPickingPlanDetail pd
                    left join T_WZObject po on pd.ObjectCode = po.ObjectCode
                    left join T_WZSpan ps on po.Unit = ps.ID
                    left join T_WZPickingPlan pp on pd.PlanCode = pp.PlanCode
                    left join T_WZProject pj on pp.ProjectCode = pj.ProjectCode
                    where pj.ProjectCode = '{0}'
                    and pj.Progress = '开工'
                    and pj.PurchaseEngineer = '{1}'
                    and pp.Progress = '签收'
                    and pd.ShortNumber > 0", strEditProjectCode, strUserCode);
                DataTable dtImport = ShareClass.GetDataSetFromSql(strImportSQL, "Import").Tables[0];

                string strGapValue = string.Empty;
                if (dtImport != null && dtImport.Rows.Count > 0)
                {
                    strGapValue = "有";
                }
                else {
                    strGapValue = "无";
                }

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusChange('" + strProgress + "','" + strGapValue + "');", true);

                HF_ProjectCode.Value = strEditProjectCode;
                HF_Progress.Value = strProgress;
                HF_GapValue.Value = strGapValue;
            }
            else if (cmdName == "start")
            {
                //开工
                string cmdArges = e.CommandArgument.ToString();
                WZProjectBLL wZProjectBLL = new WZProjectBLL();
                string strProjectSql = "from WZProject as wZProject where ProjectCode = '" + cmdArges + "'";
                IList projectList = wZProjectBLL.GetAllWZProjects(strProjectSql);
                if (projectList != null && projectList.Count == 1)
                {
                    WZProject wZProject = (WZProject)projectList[0];
                    if (wZProject.Progress == "立项")
                    {
                        if (string.IsNullOrEmpty(wZProject.StoreRoom) && string.IsNullOrEmpty(wZProject.PurchaseManager) &&
                            string.IsNullOrEmpty(wZProject.PurchaseEngineer) && string.IsNullOrEmpty(wZProject.Contracter) &&
                            string.IsNullOrEmpty(wZProject.Checker) && string.IsNullOrEmpty(wZProject.Safekeep))
                        {
                            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZKGZXWCLXLMDJCZL+"')", true);
                            return;
                        }

                        wZProject.Progress = "开工";
                        wZProjectBLL.UpdateWZProject(wZProject, cmdArges);

                        //重新加载列表
                        string strProjectCode = TXT_ProjectCode.Text.Trim();
                        string strProjectName = TXT_ProjectName.Text.Trim();
                        string strProgress = DDL_Progress.SelectedValue;

                        DataBinder(strProjectCode, strProjectName, strProgress);

                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZKGCG+"')", true);
                    }
                }
            }
            else if (cmdName == "startReturn")
            {
                //开工退回
                string cmdArges = e.CommandArgument.ToString();
                WZProjectBLL wZProjectBLL = new WZProjectBLL();
                string strProjectSql = "from WZProject as wZProject where ProjectCode = '" + cmdArges + "'";
                IList projectList = wZProjectBLL.GetAllWZProjects(strProjectSql);
                if (projectList != null && projectList.Count == 1)
                {
                    WZProject wZProject = (WZProject)projectList[0];
                    if (wZProject.Progress == "开工")
                    {
                        wZProject.Progress = "立项";
                        wZProjectBLL.UpdateWZProject(wZProject, cmdArges);

                        //重新加载列表
                        string strProjectCode = TXT_ProjectCode.Text.Trim();
                        string strProjectName = TXT_ProjectName.Text.Trim();
                        string strProgress = DDL_Progress.SelectedValue;

                        DataBinder(strProjectCode, strProjectName, strProgress);

                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZKGTHCG+"')", true);
                    }
                }
            }
            else if (cmdName == "browse")
            {
                //浏览
                string cmdArges = e.CommandArgument.ToString();
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "AlertProjectPage('TTWZProjectBrowse.aspx?strProjectCode=" + cmdArges + "');", true);
                return;
            }
        }
    }


    protected void DG_List_PageIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        DG_List.CurrentPageIndex = e.NewPageIndex;
        string strHQL = LB_ProjectSql.Text.Trim(); ;
        DataTable dtProject = ShareClass.GetDataSetFromSql(strHQL, "Project").Tables[0];

        DG_List.DataSource = dtProject;
        DG_List.DataBind();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }



    protected void btnSeach_Click(object sender, EventArgs e)
    {
        //根据相关条件查询立项工程
        string strProjectCode = TXT_ProjectCode.Text.Trim();
        string strProjectName = TXT_ProjectName.Text.Trim();
        string strProgress = DDL_Progress.SelectedValue;

        DataBinder(strProjectCode, strProjectName, strProgress);

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }

    /// <summary>
    /// 项目编码排序
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void BT_SortProjectCode_Click(object sender, EventArgs e)
    {
        DG_List.CurrentPageIndex = 0;

        string strProjectCode = TXT_ProjectCode.Text.Trim();
        string strProjectName = TXT_ProjectName.Text.Trim();
        string strProgress = DDL_Progress.SelectedValue;

        string strWZProjectHQL = string.Format(@"select p.*,
                    pp.UserName as ProjectManagerName,
                    pd.UserName as DelegateAgentName,
                    pm.UserName as PurchaseManagerName,
                    pe.UserName as PurchaseEngineerName,
                    pc.UserName as ContracterName,
                    pk.UserName as CheckerName,
                    ps.UserName as SafekeepName,
                    pa.UserName as MarkerName,
                    pu.UserName as SupplementEditorName
                    from T_WZProject p
                    left join T_ProjectMember pp on p.ProjectManager = pp.UserCode
                    left join T_ProjectMember pd on p.DelegateAgent = pd.UserCode
                    left join T_ProjectMember pm on p.PurchaseManager = pm.UserCode
                    left join T_ProjectMember pe on p.PurchaseEngineer = pe.UserCode
                    left join T_ProjectMember pc on p.Contracter = pc.UserCode
                    left join T_ProjectMember pk on p.Checker = pk.UserCode
                    left join T_ProjectMember ps on p.Safekeep = ps.UserCode
                    left join T_ProjectMember pa on p.Marker = pa.UserCode
                    left join T_ProjectMember pu on p.SupplementEditor = pu.UserCode
                    where (p.Progress in ('开工' ,'核销') or p.IsStatus = '关闭')
                    and p.PurchaseEngineer = '{0}'", strUserCode);

        if (!string.IsNullOrEmpty(strProjectCode))
        {
            strWZProjectHQL += " and p.ProjectCode = '" + strProjectCode + "'";
        }
        if (!string.IsNullOrEmpty(strProjectName))
        {
            strWZProjectHQL += " and p.ProjectName like '%" + strProjectName + "%'";
        }
        if (!string.IsNullOrEmpty(strProgress))
        {
            strWZProjectHQL += " and p.Progress = '" + strProgress + "'";
        }
        if (!string.IsNullOrEmpty(HF_SortProjectCode.Value))
        {
            strWZProjectHQL += " order by p.ProjectCode desc";

            HF_SortProjectCode.Value = "";
        }
        else
        {
            strWZProjectHQL += " order by p.ProjectCode asc";

            HF_SortProjectCode.Value = "asc";
        }
        DataTable dtProject = ShareClass.GetDataSetFromSql(strWZProjectHQL, "Project").Tables[0];

        DG_List.DataSource = dtProject;
        DG_List.DataBind();

        LB_ProjectSql.Text = strWZProjectHQL;

        //LB_ProjectSql.Text = strWZProjectHQL;
        LB_RecordCount.Text = dtProject.Rows.Count.ToString();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }

    /// <summary>
    ///  项目名称排序
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void BT_SortProjectName_Click(object sender, EventArgs e)
    {
        DG_List.CurrentPageIndex = 0;

        string strProjectCode = TXT_ProjectCode.Text.Trim();
        string strProjectName = TXT_ProjectName.Text.Trim();
        string strProgress = DDL_Progress.SelectedValue;

        string strWZProjectHQL = string.Format(@"select p.*,
                    pp.UserName as ProjectManagerName,
                    pd.UserName as DelegateAgentName,
                    pm.UserName as PurchaseManagerName,
                    pe.UserName as PurchaseEngineerName,
                    pc.UserName as ContracterName,
                    pk.UserName as CheckerName,
                    ps.UserName as SafekeepName,
                    pa.UserName as MarkerName,
                    pu.UserName as SupplementEditorName
                    from T_WZProject p
                    left join T_ProjectMember pp on p.ProjectManager = pp.UserCode
                    left join T_ProjectMember pd on p.DelegateAgent = pd.UserCode
                    left join T_ProjectMember pm on p.PurchaseManager = pm.UserCode
                    left join T_ProjectMember pe on p.PurchaseEngineer = pe.UserCode
                    left join T_ProjectMember pc on p.Contracter = pc.UserCode
                    left join T_ProjectMember pk on p.Checker = pk.UserCode
                    left join T_ProjectMember ps on p.Safekeep = ps.UserCode
                    left join T_ProjectMember pa on p.Marker = pa.UserCode
                    left join T_ProjectMember pu on p.SupplementEditor = pu.UserCode
                    where (p.Progress in ('开工' ,'核销') or p.IsStatus = '关闭')
                    and p.PurchaseEngineer = '{0}'", strUserCode);

        if (!string.IsNullOrEmpty(strProjectCode))
        {
            strWZProjectHQL += " and p.ProjectCode = '" + strProjectCode + "'";
        }
        if (!string.IsNullOrEmpty(strProjectName))
        {
            strWZProjectHQL += " and p.ProjectName like '%" + strProjectName + "%'";
        }
        if (!string.IsNullOrEmpty(strProgress))
        {
            strWZProjectHQL += " and p.Progress = '" + strProgress + "'";
        }
        if (!string.IsNullOrEmpty(HF_SortProjectName.Value))
        {
            strWZProjectHQL += " order by p.ProjectName desc";

            HF_SortProjectName.Value = "";
        }
        else
        {
            strWZProjectHQL += " order by p.ProjectName asc";

            HF_SortProjectName.Value = "asc";
        }
        DataTable dtProject = ShareClass.GetDataSetFromSql(strWZProjectHQL, "Project").Tables[0];

        DG_List.DataSource = dtProject;
        DG_List.DataBind();

        LB_ProjectSql.Text = strWZProjectHQL;

        LB_RecordCount.Text = dtProject.Rows.Count.ToString();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }

    /// <summary>
    ///  开工日期排序                按“采购工程师＋开工日期＋项目名称”排序
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void BT_SortStartTime_Click(object sender, EventArgs e)
    {
        DG_List.CurrentPageIndex = 0;

        string strProjectCode = TXT_ProjectCode.Text.Trim();
        string strProjectName = TXT_ProjectName.Text.Trim();
        string strProgress = DDL_Progress.SelectedValue;

        string strWZProjectHQL = string.Format(@"select p.*,
                    pp.UserName as ProjectManagerName,
                    pd.UserName as DelegateAgentName,
                    pm.UserName as PurchaseManagerName,
                    pe.UserName as PurchaseEngineerName,
                    pc.UserName as ContracterName,
                    pk.UserName as CheckerName,
                    ps.UserName as SafekeepName,
                    pa.UserName as MarkerName,
                    pu.UserName as SupplementEditorName
                    from T_WZProject p
                    left join T_ProjectMember pp on p.ProjectManager = pp.UserCode
                    left join T_ProjectMember pd on p.DelegateAgent = pd.UserCode
                    left join T_ProjectMember pm on p.PurchaseManager = pm.UserCode
                    left join T_ProjectMember pe on p.PurchaseEngineer = pe.UserCode
                    left join T_ProjectMember pc on p.Contracter = pc.UserCode
                    left join T_ProjectMember pk on p.Checker = pk.UserCode
                    left join T_ProjectMember ps on p.Safekeep = ps.UserCode
                    left join T_ProjectMember pa on p.Marker = pa.UserCode
                    left join T_ProjectMember pu on p.SupplementEditor = pu.UserCode
                    where (p.Progress in ('开工' ,'核销') or p.IsStatus = '关闭')
                    and p.PurchaseEngineer = '{0}'", strUserCode);

        if (!string.IsNullOrEmpty(strProjectCode))
        {
            strWZProjectHQL += " and p.ProjectCode = '" + strProjectCode + "'";
        }
        if (!string.IsNullOrEmpty(strProjectName))
        {
            strWZProjectHQL += " and p.ProjectName like '%" + strProjectName + "%'";
        }
        if (!string.IsNullOrEmpty(strProgress))
        {
            strWZProjectHQL += " and p.Progress = '" + strProgress + "'";
        }
        if (!string.IsNullOrEmpty(HF_SortStartTime.Value))
        {
            strWZProjectHQL += " order by p.PurchaseEngineer desc,p.StartTime desc,p.ProjectName desc";

            HF_SortStartTime.Value = "";
        }
        else
        {
            strWZProjectHQL += " order by p.PurchaseEngineer asc,p.StartTime asc,p.ProjectName asc";

            HF_SortStartTime.Value = "asc";
        }
        DataTable dtProject = ShareClass.GetDataSetFromSql(strWZProjectHQL, "Project").Tables[0];

        DG_List.DataSource = dtProject;
        DG_List.DataBind();

        LB_ProjectSql.Text = strWZProjectHQL;

        LB_RecordCount.Text = dtProject.Rows.Count.ToString();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }


    /// <summary>
    ///  重新加载列表
    /// </summary>
    protected void BT_RelaceLoad_Click(object sender, EventArgs e)
    {
        DataBinder("", "", "");

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }



    protected void BT_RepeatMark_Click(object sender, EventArgs e)
    {
        //在本界面列表处选择〈进度〉＝“开工”												
        //点击“标记”按钮，对所有开工项目逐条重做使用标记												
        //检查领料计划表单中是否有〈项目编码〉＝工程项目〈项目编码〉的记录												
        //有，则写记录:工程项目〈使用标记〉＝“-1”，然后继续做下一条												
        //无，则写记录:工程项目〈使用标记〉＝“0”，然后继续做下一条												
        //循环检查，直到工程项目表单最后一条记录后结束												
        WZProjectBLL wZProjectBLL = new WZProjectBLL();
        string strProjectHQL = "from WZProject as wZProject where Progress = '开工'";
        IList listProject = wZProjectBLL.GetAllWZProjects(strProjectHQL);
        if (listProject != null && listProject.Count > 0)
        {
            for (int i = 0; i < listProject.Count; i++)
            {
                WZProject wZProject = (WZProject)listProject[i];

                string strPlanHQL = "select * from T_WZPickingPlan where ProjectCode = '" + wZProject.ProjectCode + "'";
                DataTable dtPlan = ShareClass.GetDataSetFromSql(strPlanHQL, "Plan").Tables[0];
                if (dtPlan != null && dtPlan.Rows.Count > 0)
                {
                    wZProject.IsMark = -1;
                }
                else
                {
                    wZProject.IsMark = 0;
                }

                wZProjectBLL.UpdateWZProject(wZProject, wZProject.ProjectCode);
            }

            string strProjectCode = TXT_ProjectCode.Text.Trim();
            string strProjectName = TXT_ProjectName.Text.Trim();
            string strProgress = DDL_Progress.SelectedValue;

            DataBinder(strProjectCode, strProjectName, strProgress);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('重做使用标记完成！');ControlStatusCloseChange();", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZZSMYJDZKGDXMSHYKGXMSZZZSYBJ+"')", true);
            return;
        }
    }


    protected void BT_ProjectTotal_Click(object sender, EventArgs e)
    {
        //2. 点击“统计”按钮进行统计并写入												
        // 统计写入条件:〈项目编码〉相等												
        //〈甲领预算〉＝∑移交明细〈预算金额〉，范围:移交明细〈凭证标记〉＝“-1”												
        //〈合同金额〉＝∑合同〈合同金额〉，范围:合同〈进度〉＝“生效”												
        //〈实购金额〉＝∑收料单〈实购金额〉，范围:收料单〈结算标记〉＝“-1”												
        //〈税金〉＝∑收料单〈税金〉，范围:收料单〈结算标记〉＝“-1”												
        //〈运杂费〉＝∑收料单（〈运费〉＋〈其它〉），范围::收料单〈结算标记〉＝“-1”												
        //〈发料金额〉＝∑发料单〈计划金额〉，范围::发料单〈结算标记〉＝“-1”												
        //〈采购进度％〉＝（〈甲领预算〉＋〈实购金额〉＋〈税金〉＋〈运杂费〉）÷（〈甲供预算〉＋〈自购概算〉）×100％												
        WZProjectBLL wZProjectBLL = new WZProjectBLL();
        string strProjectHQL = "from WZProject as wZProject";
        IList listProject = wZProjectBLL.GetAllWZProjects(strProjectHQL);
        if (listProject != null && listProject.Count > 0)
        {
            for (int i = 0; i < listProject.Count; i++)
            {
                WZProject wZProject = (WZProject)listProject[i];
                string strProjectCode = wZProject.ProjectCode;
                decimal decimalForAndSelf = wZProject.ForCost + wZProject.SelfCost;//〈甲供预算〉＋〈自购概算〉

                //甲领预算
                string strTurnDetailHQL = string.Format(@"select 
                            COALESCE(SUM(PlanMoney),0) as TotalPlanMoney 
                            from T_WZTurnDetail
                            where CardIsMark = -1
                            and ProjectCode = '{0}'", strProjectCode);
                DataTable dtTurnDetail = ShareClass.GetDataSetFromSql(strTurnDetailHQL, "TurnDetail").Tables[0];
                decimal decimalTheBudget = 0;
                decimal.TryParse(ShareClass.ObjectToString(dtTurnDetail.Rows[0]["TotalPlanMoney"]), out decimalTheBudget);
                //合同金额
                string strCompactHQL = string.Format(@"select 
                            COALESCE(SUM(CompactMoney),0) as TotalCompactMoney 
                            from T_WZCompact
                            where Progress = '生效'
                            and ProjectCode = '{0}'", strProjectCode);
                DataTable dtCompact = ShareClass.GetDataSetFromSql(strCompactHQL, "Compact").Tables[0];
                decimal decimalContractMoney = 0;
                decimal.TryParse(ShareClass.ObjectToString(dtCompact.Rows[0]["TotalCompactMoney"]), out decimalContractMoney);
                //实购金额，税金，运杂费
                string strCollectHQL = string.Format(@"select 
                            COALESCE(SUM(ActualMoney),0) as TotalActualMoney, 
                            COALESCE(SUM(RatioMoney),0) as TotalRatioMoney,
                            COALESCE(SUM(Freight),0) as TotalFreight,
                            COALESCE(SUM(OtherObject),0) as TotalOtherObject
                            from T_WZCollect
                            where IsMark = -1
                            and ProjectCode = '{0}'", strProjectCode);
                DataTable dtCollect = ShareClass.GetDataSetFromSql(strCollectHQL, "Collect").Tables[0];
                decimal decimalAcceptMoney = 0;
                decimal.TryParse(ShareClass.ObjectToString(dtCollect.Rows[0]["TotalActualMoney"]), out decimalAcceptMoney);
                decimal decimalProjectTax = 0;
                decimal.TryParse(ShareClass.ObjectToString(dtCollect.Rows[0]["TotalRatioMoney"]), out decimalProjectTax);
                decimal decimalFreight = 0;
                decimal.TryParse(ShareClass.ObjectToString(dtCollect.Rows[0]["TotalFreight"]), out decimalFreight);
                decimal decimalOtherObject = 0;
                decimal.TryParse(ShareClass.ObjectToString(dtCollect.Rows[0]["TotalOtherObject"]), out decimalOtherObject);
                decimal decimalTheFreight = decimalFreight + decimalOtherObject;
                //发料金额
                string strSendHQL = string.Format(@"select 
                            COALESCE(SUM(PlanMoney),0) as TotalPlanMoney
                            from T_WZSend
                            where IsMark = -1
                            and ProjectCode = '{0}'", strProjectCode);
                DataTable dtSend = ShareClass.GetDataSetFromSql(strSendHQL, "Send").Tables[0];
                decimal decimalSendMoney = 0;
                decimal.TryParse(ShareClass.ObjectToString(dtSend.Rows[0]["TotalPlanMoney"]), out decimalSendMoney);
                //〈采购进度％〉＝（〈甲领预算〉＋〈实购金额〉＋〈税金〉＋〈运杂费〉）÷（〈甲供预算〉＋〈自购概算〉）×100％
                decimal decimalFinishingRate = 0;
                if (decimalForAndSelf != 0)
                {
                    decimalFinishingRate = ((decimalTheBudget + decimalAcceptMoney + decimalProjectTax + decimalTheFreight) / decimalForAndSelf) * 100;
                }

                wZProject.TheBudget = decimalTheBudget;
                wZProject.ContractMoney = decimalContractMoney;
                wZProject.AcceptMoney = decimalAcceptMoney;
                wZProject.ProjectTax = decimalProjectTax;
                wZProject.TheFreight = decimalTheFreight;
                wZProject.SendMoney = decimalSendMoney;
                wZProject.FinishingRate = decimalFinishingRate;

                wZProjectBLL.UpdateWZProject(wZProject, wZProject.ProjectCode);
            }

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('项目统计完成！');ControlStatusCloseChange();", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZZSMYXMSHYXMSZZXMTJ+"')", true);
            return;
        }
    }


    protected void DDL_Progress_SelectedIndexChanged(object sender, EventArgs e)
    {
        //根据相关条件查询立项工程
        string strProjectCode = TXT_ProjectCode.Text.Trim();
        string strProjectName = TXT_ProjectName.Text.Trim();
        string strProgress = DDL_Progress.SelectedValue;

        DataBinder(strProjectCode, strProjectName, strProgress);

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }





    protected void BT_Cancel_Click(object sender, EventArgs e)
    {
        string strStockCode = HF_StockCode.Value;
        CancelStock(strStockCode);
    }

    //核销库存
    private void CancelStock(string strStockCode)
    {
        WZStockBLL wZStockBLL = new WZStockBLL();
        string strWZStockHQL = "from WZStock as wZStock where StockCode = '" + strStockCode + "'";
        IList lstWZStock = wZStockBLL.GetAllWZStocks(strWZStockHQL);
        if (lstWZStock != null && lstWZStock.Count > 0)
        {
            WZStock wZStock = (WZStock)lstWZStock[0];
            if (!wZStock.StockCode.Contains("自营"))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('库别不是自营N库，不允许核销！');ControlStatusCloseChange();", true);
                return;
            }
            else
            {
                wZStock.IsCancel = -1;

                wZStockBLL.UpdateWZStock(wZStock, wZStock.ID);

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('核销库别成功！');ControlStatusCloseChange();", true);
            }
        }
    }


    protected void BT_NewProjectCancel_Click(object sender, EventArgs e)
    {
        //项目核销
        string strEditProjectCode = HF_ProjectCode.Value;
        if (string.IsNullOrEmpty(strEditProjectCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDXM+"')", true);
            return;
        }

        WZProjectBLL wZProjectBLL = new WZProjectBLL();
        string strProjectSql = "from WZProject as wZProject where ProjectCode = '" + strEditProjectCode + "'";
        IList projectList = wZProjectBLL.GetAllWZProjects(strProjectSql);
        if (projectList != null && projectList.Count == 1)
        {
            WZProject wZProject = (WZProject)projectList[0];
            if (wZProject.Progress == "开工")
            {
                //操作员=采购工程师
                if (strUserCode == wZProject.PurchaseEngineer.Trim())
                {
                    //TODO
                    //先查询领料计划，《进度》为核销，如果领料计划还有其它状态，给出提示
                    string strPlanHQL = "select * from T_WZPickingPlan where ProjectCode = '" + wZProject.ProjectCode + "' and Progress != '核销'";
                    DataTable dtPlan = ShareClass.GetDataSetFromSql(strPlanHQL, "Plan").Tables[0];
                    if (dtPlan != null && dtPlan.Rows.Count > 0)
                    {
                        string strPlanCodes = string.Empty;
                        foreach (DataRow drPlan in dtPlan.Rows)
                        {
                            strPlanCodes += ShareClass.ObjectToString(drPlan["PlanCode"]) + "<br />";
                        }
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZDXMBMHYLLJHWHXXHXLLJHSTRPLANCODES+"')", true);
                        return;
                    }
                    //再查询收、发料单，《结算标记》= -1，如不符给出料单号提示
                    //收，发料单
                    string strCollectSendHQL = string.Format(@"select 
                            CollectCode as SingleCode,1 as Ty
                            from T_WZCollect
                            where IsMark = -1
                            and ProjectCode = '{0}'
                            union all
                            select 
                            SendCode as SingleCode,2 as Ty
                            from T_WZSend
                            where IsMark = -1
                            and ProjectCode = '{0}'", wZProject.ProjectCode);
                    DataTable dtSingle = ShareClass.GetDataSetFromSql(strCollectSendHQL, "CollectSend").Tables[0];
                    if (dtSingle != null && dtSingle.Rows.Count > 0)
                    {
                        string strMessage = string.Empty;
                        foreach (DataRow drSingle in dtSingle.Rows)
                        {
                            if (ShareClass.ObjectToString(drSingle["Ty"]) == "1")
                            {
                                strMessage += "收料单号:" + ShareClass.ObjectToString(drSingle["SingleCode"]) + "未结算！<br />";
                            }
                            else
                            {
                                strMessage += "发料单号:" + ShareClass.ObjectToString(drSingle["SingleCode"]) + "未结算！<br />";
                            }
                        }
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + strMessage + "');", true);
                        return;
                    }

                    wZProject.Progress = "核销";
                    wZProjectBLL.UpdateWZProject(wZProject, strEditProjectCode);

                    //重新加载列表
                    string strProjectCode = TXT_ProjectCode.Text.Trim();
                    string strProjectName = TXT_ProjectName.Text.Trim();
                    string strProgress = DDL_Progress.SelectedValue;

                    DataBinder(strProjectCode, strProjectName, strProgress);


                    // 库别核销，《库别》为自营N库，是否一并核销
                    if (!wZProject.StoreRoom.Contains("自营"))
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('核销成功！');ControlStatusCloseChange();", true);
                    }
                    else
                    {
                        HF_StockCode.Value = wZProject.StoreRoom;
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "AlertStock()", true);
                    }
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBWKGSBYXHX+"')", true);
                return;
            }
        }
    }



    protected void BT_NewCancelReturn_Click(object sender, EventArgs e)
    {
        //核销退回
        string strEditProjectCode = HF_ProjectCode.Value;
        if (string.IsNullOrEmpty(strEditProjectCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDXM+"')", true);
            return;
        }

        WZProjectBLL wZProjectBLL = new WZProjectBLL();
        string strProjectSql = "from WZProject as wZProject where ProjectCode = '" + strEditProjectCode + "'";
        IList projectList = wZProjectBLL.GetAllWZProjects(strProjectSql);
        if (projectList != null && projectList.Count == 1)
        {
            WZProject wZProject = (WZProject)projectList[0];
            if (wZProject.Progress == "核销")
            {
                //操作员=采购工程师
                if (strUserCode == wZProject.PurchaseEngineer)
                {
                    wZProject.Progress = "开工";
                    wZProjectBLL.UpdateWZProject(wZProject, strEditProjectCode);

                    //库别《核销标记》为0，库别为自营N库时
                    if (wZProject.StoreRoom.Contains("自营"))
                    {
                        string strUpdateStockCodeHQL = "update T_WZStock set IsCancel = 0 where StockCode = '" + wZProject.StoreRoom + "'";
                        ShareClass.RunSqlCommand(strUpdateStockCodeHQL);
                    }

                    //重新加载列表
                    string strProjectCode = TXT_ProjectCode.Text.Trim();
                    string strProjectName = TXT_ProjectName.Text.Trim();
                    string strProgress = DDL_Progress.SelectedValue;

                    DataBinder(strProjectCode, strProjectName, strProgress);

                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('核销退回成功！');ControlStatusCloseChange();", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBWHXSBYXHXTH+"')", true);
                return;
            }
        }
    }



    protected void BT_NewBrowse_Click(object sender, EventArgs e)
    {
        //浏览
        string strEditProjectCode = HF_ProjectCode.Value;
        if (string.IsNullOrEmpty(strEditProjectCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDXM+"')", true);
            return;
        }

        string strProgress= HF_Progress.Value;
        string strGapValue= HF_GapValue.Value;

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "AlertProjectPage('TTWZProjectBrowse.aspx?strProjectCode=" + strEditProjectCode + "');ControlStatusChange('" + strProgress + "','" + strGapValue + "');", true);

    }




    protected void BT_NewGapImport_Click(object sender, EventArgs e)
    {
        //缺口导出
        string strEditProjectCode = HF_ProjectCode.Value;
        if (string.IsNullOrEmpty(strEditProjectCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDXM+"')", true);
            return;
        }


        string strImportSQL = string.Format(@"select pj.ProjectCode,pj.ProjectName,
                    pd.PlanCode,pd.ObjectCode,pd.PlanNumber,pd.ShortNumber,pd.Progress as PlanDetailProgress,
                    po.ObjectName,po.Model,po.Criterion,po.Grade,
                    ps.UnitName
                    from T_WZPickingPlanDetail pd
                    left join T_WZObject po on pd.ObjectCode = po.ObjectCode
                    left join T_WZSpan ps on po.Unit = ps.ID
                    left join T_WZPickingPlan pp on pd.PlanCode = pp.PlanCode
                    left join T_WZProject pj on pp.ProjectCode = pj.ProjectCode
                    where pj.ProjectCode = '{0}'
                    and pj.Progress = '开工'
                    and pj.PurchaseEngineer = '{1}'
                    and pp.Progress = '签收'
                    and pd.ShortNumber > 0", strEditProjectCode, strUserCode);
        DataTable dtImport = ShareClass.GetDataSetFromSql(strImportSQL, "Import").Tables[0];


        Export3Excel(dtImport, strEditProjectCode + "缺口报表");

    }




    public void Export3Excel(DataTable dtData, string strFileName)
    {
        DataGrid dgControl = new DataGrid();
        dgControl.DataSource = dtData;
        dgControl.DataBind();


        Response.Clear();
        Response.Buffer = true;
        Response.AppendHeader("Content-Disposition", "attachment;filename=" + strFileName);
        Response.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312");
        Response.ContentType = "application/shlnd.ms-excel";
        Response.Charset = "GB2312";
        EnableViewState = false;
        System.Globalization.CultureInfo mycitrad = new System.Globalization.CultureInfo("ZH-CN", true);
        System.IO.StringWriter ostrwrite = new System.IO.StringWriter(mycitrad);
        System.Web.UI.HtmlTextWriter ohtmt = new HtmlTextWriter(ostrwrite);
        dgControl.RenderControl(ohtmt);
        Response.Clear();
        Response.Write("<meta http-equiv=\"content-type\" content=\"application/ms-excel; charset=gb2312\"/>" + ostrwrite.ToString());
        Response.End();

    }
}