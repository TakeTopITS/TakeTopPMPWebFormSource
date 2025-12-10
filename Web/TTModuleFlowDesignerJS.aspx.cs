using System;
using System.Resources;
using System.Drawing;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using System.Text;
using System.IO;
using System.Web.Mail;

using System.Data.SqlClient;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

using TakeTopWF;


public partial class TTModuleFlowDesignerJS : System.Web.UI.Page
{
    string strIdentifyString, strType;

    protected void Page_Load(object sender, EventArgs e)
    {
        string strHQL, strModuleName, strWFDefinition, strNewWFDefinition, strModuleType, strUserType, strIsDIYFlow;

        string strUserCode = Session["UserCode"].ToString();

        strType = Request.QueryString["type"].ToString().Trim();
        strIdentifyString = Request.QueryString["IdentifyString"].Trim();

        if (strType == "SystemModule")
        {
            strHQL = "Select ModuleName, ModuleDefinition,ModuleType,UserType,DIYFlow From T_ProModuleLevel Where ID = " + strIdentifyString;
        }
        else
        {
            strHQL = "Select ModuleName, ModuleDefinition,ModuleType,UserType,DIYFlow From T_ProModule Where ID = " + strIdentifyString;
        }
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");
        if (ds.Tables[0].Rows.Count == 0)
        {
            return;
        }

        strModuleName = ds.Tables[0].Rows[0]["ModuleName"].ToString().Trim();
        strWFDefinition = ds.Tables[0].Rows[0]["ModuleDefinition"].ToString().Trim();
        strUserType = ds.Tables[0].Rows[0]["UserType"].ToString().Trim();
        strModuleType = ds.Tables[0].Rows[0]["ModuleType"].ToString().Trim();
        strIsDIYFlow = ds.Tables[0].Rows[0]["DiyFlow"].ToString().Trim();

        if (Page.IsPostBack == false)
        {
            DL_IsDIYFlow.SelectedValue = strIsDIYFlow;

            if (strType == "UserModule" && strWFDefinition == "")
            {
                strWFDefinition = getSystemModuleDefinition(strModuleName, strUserType, strModuleType);

                strNewWFDefinition = WFMFFlowDefinitionHandle.updateModuleFlowDefinitionToHomeLanguage(strWFDefinition);

                UpdateUserModuleDefinition(strIdentifyString, strNewWFDefinition);

                //更新点击模组显示导航页面属性
                strHQL = string.Format(@"Update T_ProModule Set DIYFlow='{0}' Where ID = {1}", strIsDIYFlow, strIdentifyString);
                ShareClass.RunSqlCommand(strHQL);
            }

            TB_WFIdentifyString.Text = strIdentifyString;
            if (strWFDefinition == "")
            {
                strNewWFDefinition = "{states:{rect2:{type:'start',text:{text:'开始'}, attr:{ x:209, y:72, width:50, height:50}, props:{guid:{value:'4af6bc4b-7ed9-0b0b-e3a0-91c9d8fd92d1'},text:{value:'开始'}}}},paths:{},props:{props:{name:{value:'新建流程'},key:{value:''},desc:{value:''}}}}";
            }
            else
            {
                strNewWFDefinition = WFMFFlowDefinitionHandle.updateModuleFlowDefinitionToHomeLanguage(strWFDefinition);
            }

            TB_WFXML.Text = strNewWFDefinition;
            TB_WFName.Text = strModuleName;

            BT_SaveWFDefinition.Enabled = true;
        }
    }

    protected void BT_SaveWFDefinition_Click(object sender, EventArgs e)
    {
        string strHQL;
        IList lst;

        string strID, strWFXML;

        strID = TB_WFIdentifyString.Text;

        strWFXML = TB_WFXML.Text.Trim();
        try
        {
            if (strType == "SystemModule")
            {
                ProModuleLevelBLL proModuleLevelBLL = new ProModuleLevelBLL();
                strHQL = "from ProModuleLevel as proModuleLevel where proModuleLevel.ID = " + strID;
                lst = proModuleLevelBLL.GetAllProModuleLevels(strHQL);
                ProModuleLevel proModuleLevel = (ProModuleLevel)lst[0];
                proModuleLevel.ModuleDefinition = strWFXML;
                proModuleLevelBLL.UpdateProModuleLevel(proModuleLevel, int.Parse(strID));

                strHQL = string.Format(@"Update T_ProModuleLevel Set DIYFlow='{0}' Where ID = {1}", DL_IsDIYFlow.SelectedValue, strID);
                ShareClass.RunSqlCommand(strHQL);
            }
            else
            {
                ProModuleBLL proModuleBLL = new ProModuleBLL();
                strHQL = "from ProModule as proModule where proModule.ID = " + strID;
                lst = proModuleBLL.GetAllProModules(strHQL);
                ProModule proModule = (ProModule)lst[0];
                proModule.ModuleDefinition = strWFXML;
                proModuleBLL.UpdateProModule(proModule, int.Parse(strID));

                strHQL = string.Format(@"Update T_ProModule Set DIYFlow='{0}' Where ID = {1}", DL_IsDIYFlow.SelectedValue, strID);
                ShareClass.RunSqlCommand(strHQL);
            }

            ClientScript.RegisterStartupScript(this.GetType(), "1", "<script>if(confirm('" + Resources.lang.BCCGYGBDQYMM + "')) { top.frames[0].frames[2].parent.frames[\"leftMiddleFrame\"].ReloadPage(); top.frames[0].frames[2].parent.frames[\"rightTabFrame\"].reloadPage(); }</script>");


            //预加载模组流程图数据集
            ShareClass.PreLoadModuleFlowChartDataSet();;


            LoadModuleDEfinition();
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);

            ClientScript.RegisterStartupScript(this.GetType(), "3", "<script>showAlertAtMouse('" + Resources.lang.ZZBCSB + "');</script>");
        }
    }

    protected void UpdateUserModuleDefinition(string strUserModuleID, string strModuleDefinition)
    {
        string strHQL;

        ProModuleBLL proModuleBLL = new ProModuleBLL();
        strHQL = string.Format(@"From ProModule as proModule Where proModule.ID = {0}", strUserModuleID);
        IList lst = proModuleBLL.GetAllProModules(strHQL);
        ProModule proModule = (ProModule)lst[0];
        proModule.ModuleDefinition = strModuleDefinition;
        proModuleBLL.UpdateProModule(proModule, int.Parse(strUserModuleID));
    }


    //取得当前模组名称
    protected string getSystemModuleDefinition(string strModuleName, string strUserType, string strModuleType)
    {
        string strHQL;

        strHQL = string.Format(@"Select ModuleDefinition From T_ProModuleLevel Where  ModuleName ='{0}' and UserType = '{1}' and ModuleType ='{2}' and CHAR_LENGTH(ModuleDefinition) > 0", strModuleName, strUserType, strModuleType);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    protected void LoadModuleDEfinition()
    {
        string strHQL, strModuleName, strWFDefinition, strNewWFDefinition, strModuleType, strUserType, strIsDIYFlow;

        string strUserCode = Session["UserCode"].ToString();

        strType = Request.QueryString["type"].ToString().Trim();
        strIdentifyString = Request.QueryString["IdentifyString"].Trim();

        if (strType == "SystemModule")
        {
            strHQL = "Select ModuleName, ModuleDefinition,ModuleType,UserType,DIYFlow From T_ProModuleLevel Where ID = " + strIdentifyString;
        }
        else
        {
            strHQL = "Select ModuleName, ModuleDefinition,ModuleType,UserType,DIYFlow From T_ProModule Where ID = " + strIdentifyString;
        }
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");
        if (ds.Tables[0].Rows.Count == 0)
        {
            return;
        }

        strModuleName = ds.Tables[0].Rows[0]["ModuleName"].ToString().Trim();
        strWFDefinition = ds.Tables[0].Rows[0]["ModuleDefinition"].ToString().Trim();
        strUserType = ds.Tables[0].Rows[0]["UserType"].ToString().Trim();
        strModuleType = ds.Tables[0].Rows[0]["ModuleType"].ToString().Trim();
        strIsDIYFlow = ds.Tables[0].Rows[0]["DiyFlow"].ToString().Trim();

        DL_IsDIYFlow.SelectedValue = strIsDIYFlow;

        if (strType == "UserModule" && strWFDefinition == "")
        {
            strWFDefinition = getSystemModuleDefinition(strModuleName, strUserType, strModuleType);

            strNewWFDefinition = WFMFFlowDefinitionHandle.updateModuleFlowDefinitionToHomeLanguage(strWFDefinition);

            UpdateUserModuleDefinition(strIdentifyString, strNewWFDefinition);

            //更新点击模组显示导航页面属性
            strHQL = string.Format(@"Update T_ProModule Set DIYFlow='{0}' Where ID = {1}", strIsDIYFlow, strIdentifyString);
            ShareClass.RunSqlCommand(strHQL);
        }

        TB_WFIdentifyString.Text = strIdentifyString;
        if (strWFDefinition == "")
        {
            strNewWFDefinition = "{states:{rect2:{type:'start',text:{text:'开始'}, attr:{ x:209, y:72, width:50, height:50}, props:{guid:{value:'4af6bc4b-7ed9-0b0b-e3a0-91c9d8fd92d1'},text:{value:'开始'}}}},paths:{},props:{props:{name:{value:'新建流程'},key:{value:''},desc:{value:''}}}}";
        }
        else
        {
            strNewWFDefinition = WFMFFlowDefinitionHandle.updateModuleFlowDefinitionToHomeLanguage(strWFDefinition);
        }

        TB_WFXML.Text = strNewWFDefinition;
        TB_WFName.Text = strModuleName;

        BT_SaveWFDefinition.Enabled = true;
    }
}
