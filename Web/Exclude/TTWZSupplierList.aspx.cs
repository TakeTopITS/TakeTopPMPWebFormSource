using ProjectMgt.BLL;
using ProjectMgt.Model;
using System;
using System.Resources;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTWZSupplierList : System.Web.UI.Page
{
    string strUserCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"] != null ? Session["UserCode"].ToString() : "";

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true); if (!IsPostBack)
        {
            DataBinder();

            DataTemplateFileBinder();

            BindSupplierWorkFlowData();
        }
    }

    private void DataBinder()
    {
        string strSupplierHQL = string.Format(@"select s.*,m.UserName as AuditorName,p.UserName as QualityEngineerName,
                                                u.UserName as PushPersonName
                                                from T_WZSupplier s
                                                left join T_ProjectMember m on s.Auditor = m.UserCode 
                                                left join T_ProjectMember p on s.QualityEngineer = p.UserCode 
                                                left join T_ProjectMember u on s.PushPerson = u.UserCode
                                                where s.SupplierCode = '{0}'", strUserCode);

        DataTable dtSupplier = ShareClass.GetDataSetFromSql(strSupplierHQL, "Supplier").Tables[0];

        DG_List.DataSource = dtSupplier;
        DG_List.DataBind();
    }


    protected void DG_List_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Pager)
        {
            string cmdName = e.CommandName;
            if (cmdName == "click")
            {
                for (int i = 0; i < DG_List.Items.Count; i++)
                {
                    DG_List.Items[i].ForeColor = Color.Black;
                }

                e.Item.ForeColor = Color.Red;

                string cmdArges = e.CommandArgument.ToString();
                string[] arrOperate = cmdArges.Split('|');

                string strEditID = arrOperate[0];
                string strProgress = arrOperate[1];

                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusChange('" + strProgress + "');", true);
                ControlStatusChange(strProgress);

                HF_NewID.Value = strEditID;
                HF_NewProgress.Value = strProgress;
            }
            else if (cmdName == "submit")
            {
                string cmdArges = e.CommandArgument.ToString();
                WZSupplierBLL wZSupplierBLL = new WZSupplierBLL();
                string strSupplierSql = "from WZSupplier as wZSupplier where id = " + cmdArges;
                IList supplierList = wZSupplierBLL.GetAllWZSuppliers(strSupplierSql);
                if (supplierList != null && supplierList.Count == 1)
                {
                    WZSupplier wZSupplier = (WZSupplier)supplierList[0];

                    wZSupplier.Progress = "提交";

                    wZSupplierBLL.UpdateWZSupplier(wZSupplier, wZSupplier.ID);

                    //重新加载列表
                    DataBinder();

                    ControlStatusCloseChange();

                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZTJCG + "')", true);
                }

            }
            else if (cmdName == "submitReturn")
            {
                string cmdArges = e.CommandArgument.ToString();
                WZSupplierBLL wZSupplierBLL = new WZSupplierBLL();
                string strSupplierSql = "from WZSupplier as wZSupplier where id = " + cmdArges;
                IList supplierList = wZSupplierBLL.GetAllWZSuppliers(strSupplierSql);
                if (supplierList != null && supplierList.Count == 1)
                {
                    WZSupplier wZSupplier = (WZSupplier)supplierList[0];

                    wZSupplier.Progress = "申请";

                    wZSupplierBLL.UpdateWZSupplier(wZSupplier, wZSupplier.ID);

                    //重新加载列表
                    DataBinder();

                    ControlStatusCloseChange();

                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZTJTHCG + "')", true);
                }

            }
        }
    }

    protected void BT_NewAdd_Click(object sender, EventArgs e)
    {
        //新增
        //判断当前登录用户＝<采购工程师>，提示“已有记录，不能新增”
        string strCheckSupplierSql = string.Format(@"select * from T_WZSupplier
                    where SupplierCode = '{0}'", strUserCode);
        DataTable dtCheckSupplier = ShareClass.GetDataSetFromSql(strCheckSupplierSql, "Supplier").Tables[0];
        if (dtCheckSupplier != null && dtCheckSupplier.Rows.Count > 0)
        {
            if (!string.IsNullOrEmpty(HF_NewID.Value))
            {
                //string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('已有记录，不能新增！');", true);
                return;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('已有记录，不能新增！');", true);
                return;
            }
        }
        else
        {
            if (!string.IsNullOrEmpty(HF_NewID.Value))
            {
                //string strNewProgress = HF_NewProgress.Value;
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "AlertSupplierPage('TTWZSupplierEdit.aspx?id=');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "AlertSupplierPage('TTWZSupplierEdit.aspx?id=');", true);
            }
        }
    }

    protected void BT_NewEdit_Click(object sender, EventArgs e)
    {
        //编辑
        string strEditID = HF_NewID.Value;
        if (string.IsNullOrEmpty(strEditID))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZXDJYCZDGYSLB + "')", true);
            return;
        }

        //string strNewProgress = HF_NewProgress.Value;
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "AlertSupplierPage('TTWZSupplierEdit.aspx?id=" + strEditID + "');", true);
    }


    protected void BT_Submit_Click(object sender, EventArgs e)
    {
        //提交
        string strEditID = HF_NewID.Value;
        if (string.IsNullOrEmpty(strEditID))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZXDJYCZDGYSLB + "')", true);
            return;
        }

        string strNewProgress = HF_NewProgress.Value;
        WZSupplierBLL wZSupplierBLL = new WZSupplierBLL();
        string strSupplierSql = "from WZSupplier as wZSupplier where id = " + strEditID;
        IList supplierList = wZSupplierBLL.GetAllWZSuppliers(strSupplierSql);
        if (supplierList != null && supplierList.Count == 1)
        {
            WZSupplier wZSupplier = (WZSupplier)supplierList[0];

            wZSupplier.Progress = "提交";

            wZSupplierBLL.UpdateWZSupplier(wZSupplier, wZSupplier.ID);

            //重新加载列表
            DataBinder();

            ControlStatusCloseChange();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZTJCG + "');", true);
        }
        else
        {
            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusChange('" + strNewProgress + "');", true);
        }
    }



    protected void BT_SubmitReturn_Click(object sender, EventArgs e)
    {
        //提交退回
        string strEditID = HF_NewID.Value;
        if (string.IsNullOrEmpty(strEditID))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZXDJYCZDGYSLB + "')", true);
            return;
        }

        string strNewProgress = HF_NewProgress.Value;
        WZSupplierBLL wZSupplierBLL = new WZSupplierBLL();
        string strSupplierSql = "from WZSupplier as wZSupplier where id = " + strEditID;
        IList supplierList = wZSupplierBLL.GetAllWZSuppliers(strSupplierSql);
        if (supplierList != null && supplierList.Count == 1)
        {
            WZSupplier wZSupplier = (WZSupplier)supplierList[0];

            wZSupplier.Progress = "申请";

            wZSupplierBLL.UpdateWZSupplier(wZSupplier, wZSupplier.ID);

            //重新加载列表
            DataBinder();

            ControlStatusCloseChange();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZTJTHCG + "');", true);
        }
        else
        {
            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusChange('" + strNewProgress + "');", true);
        }
    }

    protected void BT_NewDelete_Click(object sender, EventArgs e)
    {
        //删除
        string strEditID = HF_NewID.Value;
        if (string.IsNullOrEmpty(strEditID))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZXDJYCZDGYSLB + "')", true);
            return;
        }

        string strNewProgress = HF_NewProgress.Value;

        WZNeedObjectBLL wZNeedObjectBLL = new WZNeedObjectBLL();
        string strNeedObjectSql = "from WZNeedObject as wZNeedObject where ID = " + strEditID;
        IList needObjectList = wZNeedObjectBLL.GetAllWZNeedObjects(strNeedObjectSql);
        if (needObjectList != null && needObjectList.Count == 1)
        {
            WZNeedObject wZNeedObject = (WZNeedObject)needObjectList[0];
            if (wZNeedObject.IsMark != 0)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('使用标记不为0，不允许删除！');", true);
                return;
            }

            wZNeedObjectBLL.DeleteWZNeedObject(wZNeedObject);

            //重新加载列表
            DataBinder();

            ControlStatusCloseChange();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('删除成功！');", true);
        }
        else
        {
            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusChange('" + strNewProgress + "');", true);
        }
    }




    protected void BT_NewBrowse_Click(object sender, EventArgs e)
    {
        //浏览
        string strEditID = HF_NewID.Value;
        if (string.IsNullOrEmpty(strEditID))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZXDJYCZDGYSLB + "')", true);
            return;
        }

        //string strProgress = HF_NewProgress.Value;
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "AlertSupplierPage('TTWZSupplierBrowse.aspx?id=" + strEditID + "');", true);
    }


    //加载列表
    protected void BT_RelaceLoad_Click(object sender, EventArgs e)
    {
        DataBinder();

        //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "ControlStatusCloseChange();", true);
        ControlStatusCloseChange();
    }


    private void DataTemplateFileBinder()
    {
        string strSupplierTemplateHQL = @"select * from T_WZSupplierTemplateFile";
        DataTable dtSupplierTemplate = ShareClass.GetDataSetFromSql(strSupplierTemplateHQL, "SupplierTemplate").Tables[0];

        DG_SupplierTemplateFile.DataSource = dtSupplierTemplate;
        DG_SupplierTemplateFile.DataBind();
    }


    private void BindSupplierWorkFlowData()
    {
        string strWZSupplierWorkFlowSql = @"select * from T_WZSupplierWorkFlow";
        DataTable dtWZSupplierWorkFlow = ShareClass.GetDataSetFromSql(strWZSupplierWorkFlowSql, "SupplierWorkFlow").Tables[0];
        if (dtWZSupplierWorkFlow != null && dtWZSupplierWorkFlow.Rows.Count > 0)
        {
            DataRow drSupplierWorkFlow = dtWZSupplierWorkFlow.Rows[0];

            string strTemplateContent = ShareClass.ObjectToString(drSupplierWorkFlow["TemplateContent"]);

            LB_ShowDesc.Text = strTemplateContent;
        }
    }






    private void ControlStatusChange(string objProgress)
    {


        BT_NewBrowse.Enabled = true;

        if (objProgress == "申请")
        {
            BT_NewEdit.Enabled = true;
            BT_Submit.Enabled = true;
            BT_SubmitReturn.Enabled = false;
            BT_NewDelete.Enabled = true;

        }
        else if (objProgress == "提交")
        {
            BT_NewEdit.Enabled = false;
            BT_Submit.Enabled = false;
            BT_SubmitReturn.Enabled = true;
            BT_NewDelete.Enabled = false;

        }
        else
        {
            BT_NewEdit.Enabled = false;
            BT_Submit.Enabled = false;
            BT_SubmitReturn.Enabled = false;
            BT_NewDelete.Enabled = false;

        }
    }



    private void ControlStatusCloseChange()
    {

        BT_NewEdit.Enabled = false;
        BT_Submit.Enabled = false;
        BT_SubmitReturn.Enabled = false;
        BT_NewDelete.Enabled = false;
        BT_NewBrowse.Enabled = false;

    }











}