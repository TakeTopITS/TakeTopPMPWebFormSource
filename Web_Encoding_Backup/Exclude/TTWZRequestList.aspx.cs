using System; using System.Resources;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using ProjectMgt.BLL;
using ProjectMgt.Model;
using System.Collections;
using System.Data;
using System.Text;
using System.Drawing;

public partial class TTWZRequestList : System.Web.UI.Page
{
    string strUserCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"] == null ? "" : Session["UserCode"].ToString().Trim();

        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", strUserCode);  //Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", "期初数据导入", strUserCode);
        if (blVisible == false)
        {
            Response.Redirect("TTDisplayErrors.aspx");
            return;
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (!IsPostBack)
        {
            DataRequestBinder();

            DataCompactBander();

            DG_Collect.DataSource = "";
            DG_Collect.DataBind();
        }
    }

    private void DataRequestBinder()
    {
        DG_Request.CurrentPageIndex = 0;

        string strRequestHQL = string.Format(@"select r.*,a.UserName as ApproverName,m.UserName as BorrowerName,s.SupplierName from T_WZRequest r
                            left join T_ProjectMember m on r.Borrower = m.UserCode
                            left join T_ProjectMember a on r.Approver = a.UserCode
                            left join T_WZSupplier s on r.SupplierCode = s.SupplierCode 
                            where r.Borrower ='{0}' 
                            and r.Progress in ('录入','请款','审核','报销') 
                            order by r.RequestTime desc", strUserCode);
        DataTable dtRequest = ShareClass.GetDataSetFromSql(strRequestHQL, "Request").Tables[0];

        DG_Request.DataSource = dtRequest;
        DG_Request.DataBind();

        LB_RequestSql.Text = strRequestHQL;
    }

    private void DataCollectBinder(string strCompactCode)
    {
        string strCollectHQL = string.Format(@"select c.*,m.UserName as CheckerName,
                    a.UserName as SafekeeperName,
                    b.UserName as ContacterName,
                    d.UserName as FinanceApproveName,
                    s.SupplierName,
                    o.ObjectName
                    from T_WZCollect c
                    left join T_ProjectMember m on c.Checker = m.UserCode
                    left join T_ProjectMember a on c.Safekeeper = a.UserCode
                    left join T_ProjectMember b on c.Contacter = b.UserCode
                    left join T_ProjectMember d on c.FinanceApprove = d.UserCode
                    left join T_WZSupplier s on c.SupplierCode = s.SupplierCode 
                    left join T_WZObject o on c.ObjectCode = o.ObjectCode
                    where c.CompactCode ='{0}' 
                    and c.IsMark = -1", strCompactCode);
        DataTable dtCollect = ShareClass.GetDataSetFromSql(strCollectHQL, "Collect").Tables[0];

        DG_Collect.DataSource = dtCollect;
        DG_Collect.DataBind();
    }

    private void DataCollectByRequestCodeBinder(string strRequestCode)
    {
        string strCollectHQL = string.Format(@"select c.*,m.UserName as CheckerName,
                    a.UserName as SafekeeperName,
                    b.UserName as ContacterName,
                    d.UserName as FinanceApproveName,
                    s.SupplierName,
                    o.ObjectName
                    from T_WZCollect c
                    left join T_ProjectMember m on c.Checker = m.UserCode
                    left join T_ProjectMember a on c.Safekeeper = a.UserCode
                    left join T_ProjectMember b on c.Contacter = b.UserCode
                    left join T_ProjectMember d on c.FinanceApprove = d.UserCode
                    left join T_WZSupplier s on c.SupplierCode = s.SupplierCode 
                    left join T_WZObject o on c.ObjectCode = o.ObjectCode
                    where c.RequestCode ='{0}'", strRequestCode);
        DataTable dtCollect = ShareClass.GetDataSetFromSql(strCollectHQL, "Collect").Tables[0];

        DG_Collect.DataSource = dtCollect;
        DG_Collect.DataBind();
    }

    protected void DG_Request_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Pager)
        {
            string cmdName = e.CommandName;
            if (cmdName == "click")
            {
                //操作
                for (int i = 0; i < DG_Request.Items.Count; i++)
                {
                    DG_Request.Items[i].ForeColor = Color.Black;
                }

                e.Item.ForeColor = Color.Red;

                string cmdArges = e.CommandArgument.ToString();
                string[] arrOperate = cmdArges.Split('|');

                string strEditRequestCode = arrOperate[0];
                string strProgress = arrOperate[1];

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusChange('" + strProgress + "');", true);

                HF_NewRequestCode.Value = strEditRequestCode;
                HF_NewProgress.Value = strProgress;
            }
            else if (cmdName == "del")
            {
                string cmdArges = e.CommandArgument.ToString();
                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                string strWZRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + cmdArges + "'";
                IList listRequest = wZRequestBLL.GetAllWZRequests(strWZRequestHQL);
                if (listRequest != null && listRequest.Count == 1)
                {
                    WZRequest wZRequest = (WZRequest)listRequest[0];
                    if (wZRequest.Progress != "录入" || wZRequest.IsMark != 0)
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBWLRYJSYBJBW0BYXSC+"')", true);
                        return;
                    }

                    wZRequestBLL.DeleteWZRequest(wZRequest);

                    //重新加载列表
                    DataRequestBinder();
                }

            }
            else if (cmdName == "edit")
            {
                for (int i = 0; i < DG_Request.Items.Count; i++)
                {
                    DG_Request.Items[i].ForeColor = Color.Black;
                }

                e.Item.ForeColor = Color.Red;

                string cmdArges = e.CommandArgument.ToString();
                string strRequestHQL = string.Format(@"select r.*,p.UserName as ApproverName,s.SupplierName from T_WZRequest r
                                    left join T_ProjectMember p on r.Approver = p.UserCode
                                    left join T_WZSupplier s on r.SupplierCode = s.SupplierCode
                                    where r.RequestCode = '{0}'", cmdArges);
                DataTable dtRequest = ShareClass.GetDataSetFromSql(strRequestHQL, "Request").Tables[0];
                if (dtRequest != null && dtRequest.Rows.Count == 1)
                {
                    DataRow drRequest = dtRequest.Rows[0];

                    if (ShareClass.ObjectToString(drRequest["IsMark"]) != "0")
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZSYBJBW0BYXBJ+"')", true);
                        return;
                    }

                    TXT_RequestCode.Text = ShareClass.ObjectToString(drRequest["RequestCode"]);
                    string strCompactCode = ShareClass.ObjectToString(drRequest["CompactCode"]);
                    DDL_Compact.SelectedValue = strCompactCode;
                    TXT_ProjectCode.Text = ShareClass.ObjectToString(drRequest["ProjectCode"]);
                    TXT_SupplierName.Text = ShareClass.ObjectToString(drRequest["SupplierName"]);
                    HF_SupplierCode.Value = ShareClass.ObjectToString(drRequest["SupplierCode"]);
                    DDL_UseWay.SelectedValue = ShareClass.ObjectToString(drRequest["UseWay"]);
                    HF_Approver.Value = ShareClass.ObjectToString(drRequest["Approver"]);
                    TXT_Approver.Text = ShareClass.ObjectToString(drRequest["ApproverName"]);

                    //加载收料单列表
                    DataCollectBinder(strCompactCode);
                }
                #region 注释
                //string cmdArges = e.CommandArgument.ToString();
                //WZRequestBLL wZRequestBLL = new WZRequestBLL();
                //string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + cmdArges + "'";
                //IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
                //if (listRequest != null && listRequest.Count == 1)
                //{
                //    WZRequest wZRequest = (WZRequest)listRequest[0];

                //    if (wZRequest.IsMark != 0)
                //    {
                //        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZSYBJBW0BYXBJ+"')", true);
                //        return;
                //    }

                //    TXT_RequestCode.Text = wZRequest.RequestCode;
                //    DDL_Compact.SelectedValue = wZRequest.CompactCode;
                //    TXT_ProjectCode.Text = wZRequest.ProjectCode;
                //    TXT_SupplierCode.Text = wZRequest.SupplierCode;
                //    DDL_UseWay.SelectedValue = wZRequest.UseWay;
                //    TXT_Approver.Text = wZRequest.Approver;

                //    //加载收料单列表
                //    DataCollectBinder(wZRequest.CompactCode);
                //}
                #endregion
            }
            else if (cmdName == "collect")
            {
                //收料单
                for (int i = 0; i < DG_Request.Items.Count; i++)
                {
                    DG_Request.Items[i].ForeColor = Color.Black;
                }

                e.Item.ForeColor = Color.Red;

                string cmdArges = e.CommandArgument.ToString();
                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + cmdArges + "'";
                IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
                if (listRequest != null && listRequest.Count == 1)
                {
                    WZRequest wZRequest = (WZRequest)listRequest[0];

                    HF_RequestCode.Value = wZRequest.RequestCode;

                    //加载收料单列表
                    DataCollectByRequestCodeBinder(wZRequest.RequestCode);
                }
            }
            else if (cmdName == "request")
            {
                //请款
                string cmdArges = e.CommandArgument.ToString();
                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + cmdArges + "'";
                IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
                if (listRequest != null && listRequest.Count == 1)
                {
                    WZRequest wZRequest = (WZRequest)listRequest[0];

                    if (wZRequest.Progress != "录入")
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBSLRZTBNK+"')", true);
                        return;
                    }

                    wZRequest.Progress = "请款";
                    wZRequest.RequestTime = DateTime.Now;

                    wZRequestBLL.UpdateWZRequest(wZRequest, wZRequest.RequestCode);

                    //加载请款单列表
                    DataRequestBinder();

                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZKCG+"')", true);
                }
            }
            else if (cmdName == "notRequest")
            {
                string cmdArges = e.CommandArgument.ToString();
                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + cmdArges + "'";
                IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
                if (listRequest != null && listRequest.Count == 1)
                {
                    WZRequest wZRequest = (WZRequest)listRequest[0];

                    if (wZRequest.Progress != "请款")
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBSKZTBNTH+"')", true);
                        return;
                    }

                    wZRequest.Progress = "录入";

                    wZRequestBLL.UpdateWZRequest(wZRequest, wZRequest.RequestCode);

                    //加载请款单列表
                    DataRequestBinder();

                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZTHCG+"')", true);
                }
            }
            else if (cmdName == "print")
            {
                //打印
                string cmdArges = e.CommandArgument.ToString();

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "PrintRequestPage('" + cmdArges + "')", true);
                return;
            }
        }
    }



    protected void BT_Save_Click(object sender, EventArgs e)
    {
        try
        {
            string strRequestCode = TXT_RequestCode.Text;
            if (!string.IsNullOrEmpty(strRequestCode))
            {
                //修改
                string strCompactCode = DDL_Compact.SelectedValue;
                string strProjectCode = TXT_ProjectCode.Text;
                string strSupplierCode = HF_SupplierCode.Value; //TXT_SupplierCode.Text;
                string strUseWay = DDL_UseWay.SelectedValue;
                string strApprover = HF_Approver.Value; //TXT_Approver.Text;

                if (string.IsNullOrEmpty(strCompactCode))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('合同编码不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }
                if (string.IsNullOrEmpty(strUseWay))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('用途不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }
                if (string.IsNullOrEmpty(strApprover))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('财务审核不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }

                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + strRequestCode + "'";
                IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
                if (listRequest != null && listRequest.Count == 1)
                {
                    WZRequest wZRequest = (WZRequest)listRequest[0];

                    if (wZRequest.Progress != "录入")
                    {
                        string strNewProgress = HF_NewProgress.Value;
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('进度不是录入状态，不能修改！');ControlStatusChange('" + strNewProgress + "');", true);
                        return;
                    }

                    wZRequest.CompactCode = strCompactCode;
                    wZRequest.ProjectCode = strProjectCode;
                    wZRequest.SupplierCode = strSupplierCode;
                    wZRequest.UseWay = strUseWay;
                    wZRequest.Approver = strApprover;

                    wZRequestBLL.UpdateWZRequest(wZRequest, wZRequest.RequestCode);

                    //重新加载
                    DataRequestBinder();
                }
            }
            else
            {
                //增加
                string strCompactCode = DDL_Compact.SelectedValue;
                string strProjectCode = TXT_ProjectCode.Text;
                string strSupplierCode = HF_SupplierCode.Value; //TXT_SupplierCode.Text;
                string strUseWay = DDL_UseWay.SelectedValue;
                string strApprover = HF_Approver.Value; //TXT_Approver.Text;

                if (string.IsNullOrEmpty(strCompactCode))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('合同编码不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }
                if (string.IsNullOrEmpty(strUseWay))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('用途不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }
                if (string.IsNullOrEmpty(strApprover))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('财务审核不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }

                WZRequest wZRequest = new WZRequest();
                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                //生成请款单编号
                wZRequest.RequestCode = CreateNewRequestCode();
                wZRequest.CompactCode = strCompactCode;
                wZRequest.ProjectCode = strProjectCode;
                wZRequest.SupplierCode = strSupplierCode;
                wZRequest.UseWay = strUseWay;
                wZRequest.RequestTime = DateTime.Now;
                wZRequest.Approver = strApprover;
                wZRequest.Borrower = strUserCode;
                //wZRequest.CancelTime = DateTime.Now;
                wZRequest.Progress = "录入";

                wZRequestBLL.AddWZRequest(wZRequest);

                //重新加载
                DataRequestBinder();
            }

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
        }
        catch (Exception ex) { }
    }


    protected void BT_Create_Click(object sender, EventArgs e)
    {
        try
        {

            //增加
            string strCompactCode = DDL_Compact.SelectedValue;
            string strProjectCode = TXT_ProjectCode.Text;
            string strSupplierCode = HF_SupplierCode.Value; //TXT_SupplierCode.Text;
            string strUseWay = DDL_UseWay.SelectedValue;
            string strApprover = HF_Approver.Value; //TXT_Approver.Text;

            if (string.IsNullOrEmpty(strCompactCode))
            {
                string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('合同编码不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                return;
            }
            if (string.IsNullOrEmpty(strUseWay))
            {
                string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('用途不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                return;
            }
            if (string.IsNullOrEmpty(strApprover))
            {
                string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('财务审核不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                return;
            }

            WZRequest wZRequest = new WZRequest();
            WZRequestBLL wZRequestBLL = new WZRequestBLL();
            //生成请款单编号
            wZRequest.RequestCode = CreateNewRequestCode();
            wZRequest.CompactCode = strCompactCode;
            wZRequest.ProjectCode = strProjectCode;
            wZRequest.SupplierCode = strSupplierCode;
            wZRequest.UseWay = strUseWay;
            wZRequest.RequestTime = DateTime.Now;
            wZRequest.Approver = strApprover;
            wZRequest.Borrower = strUserCode;
            //wZRequest.CancelTime = DateTime.Now;
            wZRequest.Progress = "录入";

            wZRequestBLL.AddWZRequest(wZRequest);

            //重新加载
            DataRequestBinder();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('新建成功！');ControlStatusCloseChange();", true);
        }
        catch (Exception ex) { }
    }


    protected void BT_Edit_Click(object sender, EventArgs e)
    {
        try
        {
            string strRequestCode = TXT_RequestCode.Text;
            if (!string.IsNullOrEmpty(strRequestCode))
            {
                //修改
                string strCompactCode = DDL_Compact.SelectedValue;
                string strProjectCode = TXT_ProjectCode.Text;
                string strSupplierCode = HF_SupplierCode.Value; //TXT_SupplierCode.Text;
                string strUseWay = DDL_UseWay.SelectedValue;
                string strApprover = HF_Approver.Value; //TXT_Approver.Text;

                if (string.IsNullOrEmpty(strCompactCode))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('合同编码不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }
                if (string.IsNullOrEmpty(strUseWay))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('用途不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }
                if (string.IsNullOrEmpty(strApprover))
                {
                    string strNewProgress = HF_NewProgress.Value;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('财务审核不能为空，请补充！');ControlStatusChange('" + strNewProgress + "');", true);
                    return;
                }

                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + strRequestCode + "'";
                IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
                if (listRequest != null && listRequest.Count == 1)
                {
                    WZRequest wZRequest = (WZRequest)listRequest[0];

                    if (wZRequest.Progress != "录入")
                    {
                        string strNewProgress = HF_NewProgress.Value;
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('进度不是录入状态，不能修改！');ControlStatusChange('" + strNewProgress + "');", true);
                        return;
                    }

                    wZRequest.CompactCode = strCompactCode;
                    wZRequest.ProjectCode = strProjectCode;
                    wZRequest.SupplierCode = strSupplierCode;
                    wZRequest.UseWay = strUseWay;
                    wZRequest.Approver = strApprover;

                    wZRequestBLL.UpdateWZRequest(wZRequest, wZRequest.RequestCode);

                    //重新加载
                    DataRequestBinder();

                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('修改成功！');ControlStatusCloseChange();", true);
                }
            }
            else
            {
                //增加
                string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('请先选择要修改的请款单列表！');ControlStatusChange('" + strNewProgress + "');", true);
                return;

            }
        }
        catch (Exception ex) { }
    }


    protected void BT_Reset_Click(object sender, EventArgs e)
    {
        for (int i = 0; i < DG_Request.Items.Count; i++)
        {
            DG_Request.Items[i].ForeColor = Color.Black;
        }

        TXT_RequestCode.Text = "";
        DDL_Compact.SelectedValue = "";
        TXT_ProjectCode.Text = "";
        TXT_SupplierName.Text = "";
        HF_SupplierCode.Value = "";
        DDL_UseWay.SelectedValue = "";
        TXT_Approver.Text = "";

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }

    protected void BT_MoreAdd_Click(object sender, EventArgs e)
    {
        string strRequestCode = TXT_RequestCode.Text;
        if (!string.IsNullOrEmpty(strRequestCode))
        {
            string strCollectCodes = Request.Form["cb_Collect_Code"];
            if (!string.IsNullOrEmpty(strCollectCodes))
            {
                string[] arrCollectCode = strCollectCodes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                string strRequestHQL = string.Format("from WZRequest as wZRequest where RequestCode ='{0}'", strRequestCode);
                IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
                if (listRequest != null && listRequest.Count > 0)
                {
                    WZRequest wZRequest = (WZRequest)listRequest[0];

                    WZCollectBLL wZCollectBLL = new WZCollectBLL();
                    for (int i = 0; i < arrCollectCode.Length; i++)
                    {
                        string strCollectCode = arrCollectCode[i];
                        if (!string.IsNullOrEmpty(strCollectCode))
                        {

                            //收料单〈请款单号〉＝请款单〈请款单号〉，      收料单〈报销进度〉＝“录入”
                            string strCollectHQL = string.Format("from WZCollect as wZCollect where CollectCode ='{0}'", strCollectCode);
                            IList listCollect = wZCollectBLL.GetAllWZCollects(strCollectHQL);
                            if (listCollect != null && listCollect.Count > 0)
                            {
                                WZCollect wZCollect = (WZCollect)listCollect[0];

                                wZCollect.RequestCode = strRequestCode;
                                wZCollect.PayProcess = "录入";

                                wZCollectBLL.UpdateWZCollect(wZCollect, wZCollect.CollectCode);
                            }
                        }
                    }
                    //把汇总数据填充到请款单
                    decimal decimalTotalActualMoney = 0;
                    decimal decimalTotalRatioMoney = 0;
                    decimal decimalTotalFreight = 0;
                    decimal decimalTotalOtherObject = 0;
                    int intTotalRowNumber = 0;
                    string strTotalCollectHQL = string.Format(@"select sum(ActualMoney) as ActualMoney,
                                    sum(RatioMoney) as RatioMoney,sum(Freight) as Freight,
                                    sum(OtherObject) as OtherObject,count(RequestCode) as RowNumber
                                    from T_WZCollect
                                    where RequestCode = '{0}'", wZRequest.RequestCode);
                    DataTable dtTotalCollect = ShareClass.GetDataSetFromSql(strTotalCollectHQL, "TotalCollect").Tables[0];
                    if (dtTotalCollect != null && dtTotalCollect.Rows.Count > 0)
                    {
                        decimal.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["ActualMoney"]), out decimalTotalActualMoney);
                        decimal.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["RatioMoney"]), out decimalTotalRatioMoney);
                        decimal.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["Freight"]), out decimalTotalFreight);
                        decimal.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["OtherObject"]), out decimalTotalOtherObject);
                        int.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["RowNumber"]), out intTotalRowNumber);
                    }

                    wZRequest.ActualMoney = decimalTotalActualMoney;
                    wZRequest.RatioMoney = decimalTotalRatioMoney;
                    wZRequest.Freight = decimalTotalFreight;
                    wZRequest.OtherObject = decimalTotalOtherObject;
                    wZRequest.BorrowMoney = decimalTotalActualMoney + decimalTotalRatioMoney + decimalTotalFreight + decimalTotalOtherObject;
                    wZRequest.Arrearage = wZRequest.BorrowMoney;
                    wZRequest.RowNumber = intTotalRowNumber;
                    wZRequest.IsMark = -1;

                    wZRequestBLL.UpdateWZRequest(wZRequest, wZRequest.RequestCode);

                    //重新加载
                    DataRequestBinder();
                    //加载收料单列表
                    DataCollectBinder(wZRequest.CompactCode);
                }
            }
        }
        else
        {
            string strNewProgress = HF_NewProgress.Value;
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('请先选择请款单！');ControlStatusChange('" + strNewProgress + "');", true);
            return;
        }
    }


    protected void BT_MoreDel_Click(object sender, EventArgs e)
    {
        string strRequestCode = HF_RequestCode.Value;
        if (!string.IsNullOrEmpty(strRequestCode))
        {
            string strCollectCodes = Request.Form["cb_Collect_Code"];
            if (!string.IsNullOrEmpty(strCollectCodes))
            {
                string[] arrCollectCode = strCollectCodes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                WZRequestBLL wZRequestBLL = new WZRequestBLL();
                string strRequestHQL = string.Format("from WZRequest as wZRequest where RequestCode ='{0}'", strRequestCode);
                IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
                if (listRequest != null && listRequest.Count > 0)
                {
                    WZRequest wZRequest = (WZRequest)listRequest[0];

                    WZCollectBLL wZCollectBLL = new WZCollectBLL();
                    for (int i = 0; i < arrCollectCode.Length; i++)
                    {
                        string strCollectCode = arrCollectCode[i];
                        if (!string.IsNullOrEmpty(strCollectCode))
                        {

                            //收料单〈请款单号〉＝请款单〈请款单号〉，      收料单〈报销进度〉＝“录入”
                            string strCollectHQL = string.Format("from WZCollect as wZCollect where CollectCode ='{0}'", strCollectCode);
                            IList listCollect = wZCollectBLL.GetAllWZCollects(strCollectHQL);
                            if (listCollect != null && listCollect.Count > 0)
                            {
                                WZCollect wZCollect = (WZCollect)listCollect[0];

                                wZCollect.RequestCode = "-";
                                wZCollect.PayProcess = "-";

                                wZCollectBLL.UpdateWZCollect(wZCollect, wZCollect.CollectCode);
                            }
                        }
                    }
                    //把汇总数据填充到请款单
                    decimal decimalTotalActualMoney = 0;
                    decimal decimalTotalRatioMoney = 0;
                    decimal decimalTotalFreight = 0;
                    decimal decimalTotalOtherObject = 0;
                    int intTotalRowNumber = 0;
                    string strTotalCollectHQL = string.Format(@"select sum(ActualMoney) as ActualMoney,
                                    sum(RatioMoney) as RatioMoney,sum(Freight) as Freight,
                                    sum(OtherObject) as OtherObject,count(RequestCode) as RowNumber
                                    from T_WZCollect
                                    where RequestCode = '{0}'", wZRequest.RequestCode);
                    DataTable dtTotalCollect = ShareClass.GetDataSetFromSql(strTotalCollectHQL, "TotalCollect").Tables[0];
                    if (dtTotalCollect != null && dtTotalCollect.Rows.Count > 0)
                    {
                        decimal.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["ActualMoney"]), out decimalTotalActualMoney);
                        decimal.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["RatioMoney"]), out decimalTotalRatioMoney);
                        decimal.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["Freight"]), out decimalTotalFreight);
                        decimal.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["OtherObject"]), out decimalTotalOtherObject);
                        int.TryParse(ShareClass.ObjectToString(dtTotalCollect.Rows[0]["RowNumber"]), out intTotalRowNumber);
                    }

                    wZRequest.ActualMoney = decimalTotalActualMoney;
                    wZRequest.RatioMoney = decimalTotalRatioMoney;
                    wZRequest.Freight = decimalTotalFreight;
                    wZRequest.OtherObject = decimalTotalOtherObject;
                    wZRequest.BorrowMoney = decimalTotalActualMoney + decimalTotalRatioMoney + decimalTotalFreight + decimalTotalOtherObject;
                    wZRequest.Arrearage = wZRequest.BorrowMoney;
                    wZRequest.RowNumber = intTotalRowNumber;
                    if (intTotalRowNumber == 0)
                    {
                        wZRequest.IsMark = 0;
                    }

                    wZRequestBLL.UpdateWZRequest(wZRequest, wZRequest.RequestCode);

                    //重新加载
                    DataRequestBinder();
                    //加载收料单列表
                    DataCollectByRequestCodeBinder(wZRequest.RequestCode);
                }
            }
        }
        else
        {
            string strNewProgress = HF_NewProgress.Value;
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('请先选择请款单中的收料按钮！');ControlStatusChange('" + strNewProgress + "');", true);
            return;
        }
    }


    protected void BT_Print_Click(object sender, EventArgs e)
    {
        string strRequestCodes = Request.Form["cb_Request_Code"];
        if (!string.IsNullOrEmpty(strRequestCodes))
        {
            string strUrl = "TTWZRequestPrintPage.aspx?requestCode=" + strRequestCodes;
            string strOtherUrl = "TTWZRequestDetailPrintPage.aspx?requestCode=" + strRequestCodes;

            string strNewProgress = HF_NewProgress.Value;

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click1", "AlertProjectPage('" + strUrl + "');AlertProjectPage('" + strOtherUrl + "');", true);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click2", "ControlStatusChange('" + strNewProgress + "');", true);

        }
        else
        {
            string strNewProgress = HF_NewProgress.Value;
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('请先选择请款单！');ControlStatusChange('" + strNewProgress + "');", true);
            return;
        }
    }

    protected void DDL_Compact_SelectedIndexChanged(object sender, EventArgs e)
    {
        string strCompactCode = DDL_Compact.SelectedValue;
        if (!string.IsNullOrEmpty(strCompactCode))
        {
            string strWZCompactHQL = string.Format(@"select c.*,s.SupplierName
                        from T_WZCompact c
                        left join T_WZSupplier s on c.SupplierCode = s.SupplierCode 
                        where c.CompactCode = '{0}'", strCompactCode);
            DataTable dtCompact = ShareClass.GetDataSetFromSql(strWZCompactHQL, "Compact").Tables[0];
            if (dtCompact != null && dtCompact.Rows.Count > 0)
            {
                DataRow drCompact = dtCompact.Rows[0];

                TXT_ProjectCode.Text = ShareClass.ObjectToString(drCompact["ProjectCode"]);
                TXT_SupplierName.Text = ShareClass.ObjectToString(drCompact["SupplierName"]);
                HF_SupplierCode.Value = ShareClass.ObjectToString(drCompact["SupplierCode"]);
            }
            else
            {
                TXT_ProjectCode.Text = "";
                TXT_SupplierName.Text = "";
                HF_SupplierCode.Value = "";
            }
        }
        else
        {
            TXT_ProjectCode.Text = "";
            TXT_SupplierName.Text = "";
            HF_SupplierCode.Value = "";
        }

        string strNewProgress = HF_NewProgress.Value;
    }


    private void DataCompactBander()
    {
        WZCompactBLL wZCompactBLL = new WZCompactBLL();
        string strWZCompactHQL = string.Format("from WZCompact as wZCompact where Compacter = '{0}' and Progress = '材检' and CollectMoney > 0 order by MarkTime desc", strUserCode);
        IList listCompact = wZCompactBLL.GetAllWZCompacts(strWZCompactHQL);

        DDL_Compact.DataSource = listCompact;
        DDL_Compact.DataBind();

        DDL_Compact.Items.Insert(0, new ListItem("", ""));
    }



    protected void DG_Request_PageIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        DG_Request.CurrentPageIndex = e.NewPageIndex;
        string strHQL = LB_RequestSql.Text.Trim();
        DataTable dtRequest = ShareClass.GetDataSetFromSql(strHQL, "Request").Tables[0];

        DG_Request.DataSource = dtRequest;
        DG_Request.DataBind();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
    }


    /// <summary>
    ///  生成请款单编号
    /// </summary>
    private string CreateNewRequestCode()
    {
        string strNewRequestCode = string.Empty;
        try
        {
            lock (this)
            {
                bool isExist = true;
                string strRequestCodeHQL = string.Format("select count(1) as RowNumber from T_WZRequest where to_char( RequestTime, 'yyyy-mm-dd') like '{0}%'", DateTime.Now.ToString("yyyy-MM"));
                DataTable dtRequestCode = ShareClass.GetDataSetFromSql(strRequestCodeHQL, "RequestCode").Tables[0];
                int intRequestCodeNumber = int.Parse(dtRequestCode.Rows[0]["RowNumber"].ToString());
                intRequestCodeNumber = intRequestCodeNumber + 1;
                string strYear = DateTime.Now.Year.ToString();
                string strMonth = DateTime.Now.Month.ToString();
                do
                {
                    StringBuilder sbRequestCode = new StringBuilder();
                    for (int j = 3 - intRequestCodeNumber.ToString().Length; j > 0; j--)
                    {
                        sbRequestCode.Append("0");
                    }
                    if (strMonth.Length == 1)
                    {
                        strMonth = "0" + strMonth;
                    }
                    strNewRequestCode = strYear + "" + strMonth + "-" + sbRequestCode.ToString() + intRequestCodeNumber.ToString();

                    //验证新的合同编号是否存在
                    string strCheckNewRequestCodeHQL = "select count(1) as RowNumber from T_WZRequest where RequestCode = '" + strNewRequestCode + "'";
                    DataTable dtCheckNewRequestCode = ShareClass.GetDataSetFromSql(strCheckNewRequestCodeHQL, "CheckNewRequestCode").Tables[0];
                    int intCheckNewRequestCode = int.Parse(dtCheckNewRequestCode.Rows[0]["RowNumber"].ToString());
                    if (intCheckNewRequestCode == 0)
                    {
                        isExist = false;
                    }
                    else
                    {
                        intRequestCodeNumber++;
                    }
                } while (isExist);
            }
        }
        catch (Exception ex) { }
        return strNewRequestCode;
    }

    protected void BT_NewEdit_Click(object sender, EventArgs e)
    {
        //编辑
        string strEditRequestCode = HF_NewRequestCode.Value;
        if (string.IsNullOrEmpty(strEditRequestCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDKLB+"')", true);
            return;
        }

        WZRequestBLL wZRequestBLL = new WZRequestBLL();
        string strWZRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + strEditRequestCode + "'";
        IList listRequest = wZRequestBLL.GetAllWZRequests(strWZRequestHQL);
        if (listRequest != null && listRequest.Count == 1)
        {
            WZRequest wZRequest = (WZRequest)listRequest[0];
            if (wZRequest.Progress != "录入" || wZRequest.IsMark != 0)
            {
                string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBWLRYJSYBJBW0BYXSC+"');ControlStatusChange('" + strNewProgress + "');", true);
                return;
            }

            wZRequestBLL.DeleteWZRequest(wZRequest);

            //重新加载列表
            DataRequestBinder();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
        }
    }


    protected void BT_NewDelete_Click(object sender, EventArgs e)
    {
        //删除
        string strEditRequestCode = HF_NewRequestCode.Value;
        if (string.IsNullOrEmpty(strEditRequestCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDKLB+"')", true);
            return;
        }

        WZRequestBLL wZRequestBLL = new WZRequestBLL();
        string strWZRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + strEditRequestCode + "'";
        IList listRequest = wZRequestBLL.GetAllWZRequests(strWZRequestHQL);
        if (listRequest != null && listRequest.Count == 1)
        {
            WZRequest wZRequest = (WZRequest)listRequest[0];
            if (wZRequest.Progress != "录入" || wZRequest.IsMark != 0)
            {
                string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBWLRYJSYBJBW0BYXSC+"');ControlStatusChange('" + strNewProgress + "');", true);
                return;
            }

            wZRequestBLL.DeleteWZRequest(wZRequest);

            //重新加载列表
            DataRequestBinder();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
        }
    }



    protected void BT_NewCollect_Click(object sender, EventArgs e)
    {
        //收料单
        string strEditRequestCode = HF_NewRequestCode.Value;
        if (string.IsNullOrEmpty(strEditRequestCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDKLB+"')", true);
            return;
        }

        WZRequestBLL wZRequestBLL = new WZRequestBLL();
        string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + strEditRequestCode + "'";
        IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
        if (listRequest != null && listRequest.Count == 1)
        {
            WZRequest wZRequest = (WZRequest)listRequest[0];

            HF_RequestCode.Value = wZRequest.RequestCode;

            //加载收料单列表
            DataCollectByRequestCodeBinder(wZRequest.RequestCode);
        }

        string strNewProgress = HF_NewProgress.Value;
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusChange('" + strNewProgress + "');", true);
    }



    protected void BT_NewRequest_Click(object sender, EventArgs e)
    {
        //请款
        string strEditRequestCode = HF_NewRequestCode.Value;
        if (string.IsNullOrEmpty(strEditRequestCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDKLB+"')", true);
            return;
        }

        WZRequestBLL wZRequestBLL = new WZRequestBLL();
        string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + strEditRequestCode + "'";
        IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
        if (listRequest != null && listRequest.Count == 1)
        {
            WZRequest wZRequest = (WZRequest)listRequest[0];

            if (wZRequest.Progress != "录入")
            {
                string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBSLRZTBNK+"');ControlStatusChange('" + strNewProgress + "');", true);
                return;
            }

            wZRequest.Progress = "请款";
            wZRequest.RequestTime = DateTime.Now;

            wZRequestBLL.UpdateWZRequest(wZRequest, wZRequest.RequestCode);

            //加载请款单列表
            DataRequestBinder();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZKCG+"');ControlStatusCloseChange();", true);
        }
    }


    protected void BT_NewReturn_Click(object sender, EventArgs e)
    {
        //退回
        string strEditRequestCode = HF_NewRequestCode.Value;
        if (string.IsNullOrEmpty(strEditRequestCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDKLB+"')", true);
            return;
        }

        WZRequestBLL wZRequestBLL = new WZRequestBLL();
        string strRequestHQL = "from WZRequest as wZRequest where RequestCode = '" + strEditRequestCode + "'";
        IList listRequest = wZRequestBLL.GetAllWZRequests(strRequestHQL);
        if (listRequest != null && listRequest.Count == 1)
        {
            WZRequest wZRequest = (WZRequest)listRequest[0];

            if (wZRequest.Progress != "请款")
            {
                string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZJDBSKZTBNTH+"');ControlStatusChange('" + strNewProgress + "');", true);
                return;
            }

            wZRequest.Progress = "录入";

            wZRequestBLL.UpdateWZRequest(wZRequest, wZRequest.RequestCode);

            //加载请款单列表
            DataRequestBinder();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZTHCG+"');ControlStatusCloseChange();", true);
        }
    }



    protected void BT_NewPrint_Click(object sender, EventArgs e)
    {
        //打印
        string strEditRequestCode = HF_NewRequestCode.Value;
        if (string.IsNullOrEmpty(strEditRequestCode))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXDJYCZDKLB+"')", true);
            return;
        }

        string strNewProgress = HF_NewProgress.Value;
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "PrintRequestPage('" + strEditRequestCode + "');ControlStatusChange('" + strNewProgress + "');", true);
        return;
    }
}