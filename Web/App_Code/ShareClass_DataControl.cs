using LumiSoft.Net.Mail;
using LumiSoft.Net.MIME;
using LumiSoft.Net.POP3.Client;

using Microsoft.CSharp;

using MSXML2;

using net.sf.mpxj.primavera.schema;

using Npgsql;

using ProjectMgt.BLL;
using ProjectMgt.Model;

using RTXSAPILib;

using RTXServerApi;

using System;
using System.Activities.DurableInstancing;
using System.Activities.Statements;
using System.CodeDom;
using System.CodeDom.Compiler;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
//using NPOI.SS.Formula.Functions;
//using Microsoft.Office.Interop.MSProject;
//using AjaxControlToolkit.HTMLEditor.ToolbarButton;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.Caching;
using System.Web.Security;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

using TakeTopCore;

using TakeTopGantt;

using TakeTopWF;

using ZXing;
using ZXing.QrCode;

/// <summary>
/// ShareClass partial - DataControl
/// </summary>
public static partial class ShareClass
{
    
    #region DataSet,DataGrid,DropDownList 操作函数

    /// <summary>
    /// 将DataSet序列化为XML字符串
    /// </summary>
    /// <param name="ds">要序列化的DataSet</param>
    /// <returns>序列化后的XML字符串</returns>
    public static string SerializeDataSetToString(DataSet ds)
    {
        if (ds == null)
        {
            LogClass.WriteLogFile("序列化失败：DataSet为空");
            return string.Empty;
        }

        try
        {
            using (StringWriter sw = new StringWriter())
            {
                ds.WriteXml(sw, XmlWriteMode.IgnoreSchema);
                string xmlString = sw.ToString();

                // 记录前100个字符用于调试
                string preview = xmlString.Length > 100 ? xmlString.Substring(0, 100) + "..." : xmlString;
                //LogClass.WriteLogFile($"序列化成功，长度={xmlString.Length}，预览={preview}");

                return xmlString;
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("DataSet序列化失败: " + ex.Message.ToString());
            return string.Empty;
        }
    }

    /// <summary>
    /// 从字符串反序列化为DataSet
    /// </summary>
    /// <param name="xmlString">XML字符串</param>
    /// <returns>反序列化后的DataSet</returns>
    public static  DataSet DeserializeStringToDataSet(string xmlString)
    {
        if (string.IsNullOrEmpty(xmlString))
        {
            //LogClass.WriteLogFile("反序列化失败：XML字符串为空");
            return null;
        }

        try
        {
            // 记录前100个字符用于调试
            string preview = xmlString.Length > 100 ? xmlString.Substring(0, 100) + "..." : xmlString;
            //LogClass.WriteLogFile($"开始反序列化，长度={xmlString.Length}，预览={preview}");

            DataSet ds = new DataSet();
            using (StringReader sr = new StringReader(xmlString))
            {
                ds.ReadXml(sr);
            }

            //LogClass.WriteLogFile($"反序列化成功，表数量={ds.Tables.Count}");
            if (ds.Tables.Count > 0)
            {
                //LogClass.WriteLogFile($"第一个表行数={ds.Tables[0].Rows.Count}");
            }

            return ds;
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("字符串反序列化为DataSet失败: " + ex.Message.ToString());
            return null;
        }
    }

    //绑定项目关联角色组
    public static void LoadProjectActorGroupForDropDownList(DropDownList DL_Visible, string strProjectID)
    {
        string strHQL;
        string strLangCode, strUserCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();
        strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();

        string strDepartString;
        string strSystemVersionType = HttpContext.Current.Session["SystemVersionType"].ToString();

        if (strSystemVersionType != "GROUP" & strSystemVersionType != "ENTERPRISE")
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialAllDepartmentString();
        }
        else
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthorityProjectLeader(strUserCode);
        }

        string strProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];
        if (strSystemVersionType == "SAAS" || strProductType.IndexOf("SAAS") > -1)
        {
            strHQL = "Select distinct GroupName,HomeName from T_ActorGroup where (GroupName = 'Individual' or GroupName = 'Entire')";
            strHQL += " and LangCode = " + "'" + strLangCode + "'";
        }
        else
        {
            strHQL = "Select distinct GroupName,HomeName from T_ActorGroup where (GroupName = 'Individual' or GroupName = 'Entire' ";
            strHQL += " Or GroupName in (select ActorGroupName from T_RelatedActorGroup where RelatedType = 'Project' and RelatedID = " + strProjectID + ")";
            strHQL += " Or BelongDepartCode in " + strDepartString;
            strHQL += " Or MakeUserCode = " + "'" + strUserCode + "')";
            strHQL += " and LangCode = " + "'" + strLangCode + "'";
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ActorGroup");
        DL_Visible.DataSource = ds;
        DL_Visible.DataBind();
    }

    //绑定角色组，全体适用
    public static void LoadActorGroupDropDownList(DropDownList DL_Visible, string strUserCode)
    {
        string strHQL;

        string strDepartString, strDepartCode, strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strDepartString = TakeTopCore.CoreShareClass.InitialUnderDepartmentStringByAuthority(strUserCode);
        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = "Select rtrim(GroupName) as GroupName ,rtrim(HomeName) as HomeName from T_ActorGroup where GroupName <> 'Entire' and Type = 'All' ";
        strHQL += " and (BelongDepartCode in (select ParentDepartCode from F_GetParentDepartCode(" + "'" + strDepartCode + "'" + "))";
        strHQL += " Or BelongDepartCode in " + strDepartString + ")";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";
        strHQL += " Order by SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ActorGroup");
        DL_Visible.DataSource = ds;
        DL_Visible.DataBind();
    }

    //绑定角色组，全体适用
    public static void LoadWorkflowActorGroupDropDownList(DropDownList DL_Visible, string strUserCode)
    {
        string strHQL;

        string strDepartString, strDepartCode, strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strDepartString = TakeTopCore.CoreShareClass.InitialUnderDepartmentStringByAuthority(strUserCode);
        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = "Select rtrim(GroupName) as GroupName ,rtrim(HomeName) as HomeName from T_ActorGroup where Type = 'All' ";
        strHQL += " and (BelongDepartCode in (select ParentDepartCode from F_GetParentDepartCode(" + "'" + strDepartCode + "'" + "))";
        strHQL += " Or BelongDepartCode in " + strDepartString + ")";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";
        strHQL += " Order by SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ActorGroup");
        DL_Visible.DataSource = ds;
        DL_Visible.DataBind();
    }

    //绑定银行
    public static void LoadBankForDropDownList(DropDownList DL_Bank)
    {
        string strHQL;
        IList lst;

        strHQL = "From Bank as bank Order By bank.SortNumber ASC";
        BankBLL bankBLL = new BankBLL();
        lst = bankBLL.GetAllBanks(strHQL);

        DL_Bank.DataSource = lst;
        DL_Bank.DataBind();

        DL_Bank.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //绑定币别
    public static void LoadCurrencyForDropDownList(DropDownList DL_Currency)
    {
        string strHQL;
        IList lst;

        strHQL = "From CurrencyType as currencyType Order By currencyType.SortNo ASC";
        CurrencyTypeBLL currencyTypeBLL = new CurrencyTypeBLL();
        lst = currencyTypeBLL.GetAllCurrencyTypes(strHQL);
        DL_Currency.DataSource = lst;
        DL_Currency.DataBind();

        DL_Currency.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //绑定收付款方式
    public static void LoadReceivePayWayForDropDownList(DropDownList DL_ReAndPayType)
    {
        string strHQL;

        strHQL = "Select rtrim(ltrim(Type)) as Type,SortNumber From T_ReceivePayWay Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ReceivePayWay");

        DL_ReAndPayType.DataSource = ds;
        DL_ReAndPayType.DataBind();

        //DL_ReAndPayType.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //依权限列出客户
    public static void LoadCustomer(DropDownList DL_Customer, string strUserCode)
    {
        string strHQL;
        IList lst;

        string strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthorityAsset(strUserCode);

        strHQL = "from Customer as customer ";
        strHQL += " Where (customer.CreatorCode = " + "'" + strUserCode + "'" + ")";
        strHQL += " or (customer.CustomerCode in (Select customerRelatedUser.CustomerCode from CustomerRelatedUser as customerRelatedUser where customerRelatedUser.UserCode = " + "'" + strUserCode + "'" + "))";
        strHQL += " Or customer.CreatorCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode In  " + strDepartString + ")";
        strHQL += " Order by customer.CustomerName ASC";

        CustomerBLL customerBLL = new CustomerBLL();
        lst = customerBLL.GetAllCustomers(strHQL);

        DL_Customer.DataSource = lst;
        DL_Customer.DataBind();

        DL_Customer.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //依权限列出供应商和承包商
    public static void LoadVendorList(DropDownList DL_VendorList, string strUserCode)
    {
        string strHQL;

        string strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthorityAsset(strUserCode);

        strHQL = "Select VendorCode,VendorName from T_Vendor where CreatorCode = " + "'" + strUserCode + "'";
        strHQL += " or VendorCode in (Select VendorCode from T_VendorRelatedUser where UserCode = " + "'" + strUserCode + "'" + ")";
        strHQL += " Or CreatorCode in (Select UserCode From T_ProjectMember Where DepartCode In  " + strDepartString + ")";
        strHQL += " UNION ";
        strHQL += " Select Code as VendorCode,Name as VendorName From T_BMSupplierInfo where EnterPer = " + "'" + strUserCode + "'";
        strHQL += " or Code in (Select VendorCode from T_VendorRelatedUser where UserCode = " + "'" + strUserCode + "'" + ")";
        strHQL += " Or EnterPer in (Select UserCode From T_ProjectMember Where DepartCode In  " + strDepartString + ")";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Vendor");
        DL_VendorList.DataSource = ds;
        DL_VendorList.DataBind();

        DL_VendorList.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //绑定DataGrid
    public static void DataGridBindingDataSet(string strHQL, DataGrid dataGrid)
    {
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_TakeTopTable");

        dataGrid.DataSource = ds;
        dataGrid.DataBind();
    }

    //绑定DataList
    public static void DataGridBindingDataSet(string strHQL, DataList dataList)
    {
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_TakeTopTable");

        dataList.DataSource = ds;
        dataList.DataBind();
    }

    //基于部门列表员工到DATAGRID
    public static int LoadUserByDepartCodeForDataGrid(string strDepartCode, DataGrid dataGrid)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectMember as projectMember where projectMember.DepartCode= " + "'" + strDepartCode + "'" + " Order By projectMember.SortNumber ASC";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        dataGrid.DataSource = lst;
        dataGrid.DataBind();

        return lst.Count;
    }

    //基于部门列表员工KIP到DATAGRID
    public static int LoadUserKPIByDepartCodeForDataGrid(string strDepartString, DataGrid dataGrid)
    {
        string strHQL;

        strHQL = "Select * From V_UserKPIList Where DepartCode in " + strDepartString;
        strHQL += " Order By StartTime DESC,TotalPoint DESC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "V_UserKPIList");

        dataGrid.DataSource = ds;
        dataGrid.DataBind();

        return ds.Tables[0].Rows.Count;
    }

    //基于部门列表员工到DATAGRID
    public static int LoadUserByDepartStringForDataGrid(string strDepartString, DataGrid dataGrid)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectMember as projectMember where projectMember.DepartCode in " + strDepartString + " Order By projectMember.SortNumber ASC";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        dataGrid.DataSource = lst;
        dataGrid.DataBind();

        return lst.Count;
    }

    public static void LoadUnderUserByDutyAndAuthorityAsset(string strDutyKeyWord, string strUserCode, DropDownList DL_Duty)
    {
        string strHQL;
        string strDepartCode, strDepartString;

        strDepartCode = GetDepartCodeFromUserCode(strUserCode);
        strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthorityAsset(strUserCode);

        strHQL = " Select Distinct UserCode,UserName From T_ProjectMember Where (Duty in (Select Duty From T_UserDuty Where KeyWord =" + "'" + strDutyKeyWord + "'" + ")";
        strHQL += " or UserCode in (Select UserCode From T_PartTimeJob Where Duty in (Select Duty From T_UserDuty Where KeyWord =" + "'" + strDutyKeyWord + "'" + ")))";
        strHQL += " and DepartCode in " + strDepartString;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CarInformation");

        DL_Duty.DataSource = ds;
        DL_Duty.DataBind();

        DL_Duty.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //基于项目成员列表到DATAGRID
    public static void LoadProjectMemberByProjectIDForDataGrid(string strProjectID, DataGrid dataGrid)
    {
        string strHQL;
        IList lst;

        strHQL = "from RelatedUser as relatedUser Where relatedUser.ProjectID = " + strProjectID;
        RelatedUserBLL relatedUserBLL = new RelatedUserBLL();
        lst = relatedUserBLL.GetAllRelatedUsers(strHQL);

        dataGrid.DataSource = lst;
        dataGrid.DataBind();
    }

    //基于直接成员列表到DATAGRID
    public static void LoadMemberByUserCodeForDataGrid(string strUserCode, string strAuthorityType, DataGrid dataGrid)
    {
        string strHQL;
        string strSystemVersionType, strProductType;

        strSystemVersionType = HttpContext.Current.Session["SystemVersionType"].ToString();
        strProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];
        if (strProductType == "LOCALSAAS" | strProductType == "SERVERSAAS")
        {
            strHQL = string.Format(@"Select Distinct UserCode,UserName,SortNumber From (Select UserCode,UserName, 1 as SortNumber From T_RelatedUser Where ProjectID in (Select ProjectID From T_Project Where PMCode = '{0}')
                     Union Select UserCode,UserName,2 as SortNumber From T_ProjectMember Where UserCode Not In ( Select UserCode From T_RelatedUser Where ProjectID in (Select ProjectID From T_Project Where PMCode = '{0}'))) C 
                     ", strUserCode);
        }
        else
        {
            strHQL = "Select Distinct A.UnderCode as UserCode,B.UserName From T_MemberLevel A,T_ProjectMember B Where A.UnderCode = B.UserCode  and A.UserCode = " + "'" + strUserCode + "'";
            if (strAuthorityType == "Project")
            {
                strHQL += " and A.ProjectVisible = 'YES'";
            }

            if (strAuthorityType == "Plan")
            {
                strHQL += " and A.PlanVisible = 'YES'";
            }

            if (strAuthorityType == "KPI")
            {
                strHQL += " and A.KPIVisible = 'YES'";
            }

            if (strAuthorityType == "Workload")
            {
                strHQL += " and A.WorkloadVisible = 'YES'";
            }

            if (strAuthorityType == "Schedule")
            {
                strHQL += " and A.ScheduleVisible = 'YES'";
            }

            if (strAuthorityType == "Workflow")
            {
                strHQL += " and A.WorkflowVisible = 'YES'";
            }

            if (strAuthorityType == "CustomerService")
            {
                strHQL += " and A.CustomerServiceVisible = 'YES'";
            }

            if (strAuthorityType == "Contract")
            {
                strHQL += " and A.ConstractVisible = 'YES'";
            }

            if (strAuthorityType == "Position")
            {
                strHQL += " and A.PositionVisible = 'YES'";
            }

        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_MemberLevel");
        dataGrid.DataSource = ds;
        dataGrid.DataBind();
    }

    //基于直接成员列表到DropDownList
    public static void LoadMemberByUserCodeForDropDownList(string strUserCode, DropDownList dropDownList)
    {
        string strHQL;

        string strSystemVersionType = HttpContext.Current.Session["SystemVersionType"].ToString();
        if (strSystemVersionType != "GROUP" & strSystemVersionType != "ENTERPRISE" & strSystemVersionType != "SAAS")
        {
            strHQL = "Select Distinct A.UserCode,A.UserName From T_ProjectMember A ";
        }
        else
        {
            strHQL = "Select Distinct A.UnderCode as UserCode,B.UserName From T_MemberLevel A,T_ProjectMember B Where A.UnderCode = B.UserCode  and A.UserCode = " + "'" + strUserCode + "'";
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_MemberLevel");

        dropDownList.DataSource = ds;
        dropDownList.DataBind();

        dropDownList.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //单位列表到DropDownList
    public static void LoadUnitForDropDownList(DropDownList DL_Unit)
    {
        string strHQL;
        IList lst;

        strHQL = "from JNUnit as jnUnit order by jnUnit.SortNumber ASC";
        JNUnitBLL jnUnitBLL = new JNUnitBLL();
        lst = jnUnitBLL.GetAllJNUnits(strHQL);
        DL_Unit.DataSource = lst;
        DL_Unit.DataBind();

        DL_Unit.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //基于直接成员列表到DropDownList
    public static void LoadPMByUserCodeForDropDownList(string strUserCode, string strDepartString, DropDownList dropDownList)
    {
        string strHQL;

        string strSystemVersionType = HttpContext.Current.Session["SystemVersionType"].ToString();
        if (strSystemVersionType == "GROUP" | strSystemVersionType == "ENTERPRISE")
        {
            strHQL = "Select Distinct UserCode,UserName From T_ProjectMember Where (UserCode in (Select UnderCode From T_MemberLevel Where Usercode = " + "'" + strUserCode + "'" + ")";
            strHQL += " Or UserCode in (Select UserCode From T_ProjectMember Where DepartCode in " + strDepartString + "))";
            strHQL += "  And Status = 'Employed'";
        }
        else
        {
            strHQL = "Select Distinct UserCode,UserName From T_ProjectMember ";
        }


        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_MemberLevel");

        dropDownList.DataSource = ds;
        dropDownList.DataBind();
    }

    //标记被选取的DATAGRID行为红色
    public static void ColorDataGridSelectRow(DataGrid dataGrid, DataGridCommandEventArgs e)
    {
        for (int i = 0; i < dataGrid.Items.Count; i++)
        {
            dataGrid.Items[i].ForeColor = Color.Black;
        }

        e.Item.ForeColor = Color.Red;
    }

    #endregion DataSet,DataGrid,DropDownList 操作函数

}
