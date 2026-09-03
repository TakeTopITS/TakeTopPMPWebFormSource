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
/// ShareClass partial - Workflow
/// </summary>
public static partial class ShareClass
{
    
    #region 工作流相关操作函数

    //设置缺省的文件类型
    public static void SetDefaultDocType(string strDocType, Label LB_DocTypeID, TextBox TB_DocType)
    {
        string strHQL;
        string strDocTypeID, strDocTypeName;

        strDocType = "%" + strDocType + "%";

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        strHQL = string.Format(@"from DocType as docType where docType.Type Like '{0}'", strDocType);
        IList lst = docTypeBLL.GetAllDocTypes(strHQL);

        if (lst.Count > 0)
        {
            DocType docType = (DocType)lst[0];
            strDocTypeName = docType.Type.Trim();
            strDocTypeID = docType.ID.ToString();

            LB_DocTypeID.Text = strDocTypeID;
            TB_DocType.Text = strDocTypeName;
        }
    }

    //设置缺省的工作流模板树
    public static void SetDefaultWorkflowTemplate(string strDocType, DropDownList DL_TemName)
    {
        string strHQL;

        strDocType = "%" + strDocType + "%";

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        strHQL = string.Format(@"from WorkFlowTemplate as workFlowTemplate where workFlowTemplate.TemName Like '{0}'", strDocType);
        IList lst = docTypeBLL.GetAllDocTypes(strHQL);

        DL_TemName.DataSource = lst;
        DL_TemName.DataBind();
    }

    //设置对象相关缺省的工作流模板
    public static void SetDefaultWorkflowTemplateByRelateName(string strRelatedType, string strRelatedID, string strRelateName, DropDownList DL_WorkFlowTemName)
    {
        string strHQL;

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        strHQL = string.Format(@"select * from T_WorkFlowTemplate  where (TemName in (Select wftemplatename From T_RelatedWorkflowTemplate Where RelatedType = '{0}' and RelatedID = {1})
                                 Or (Type = 'DocumentReview' and Authority = 'All' )) and Visible = 'YES' Order By SortNumber
                                ", strRelatedType, strRelatedID);
        DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTemplate");

        DL_WorkFlowTemName.DataSource = ds1;
        DL_WorkFlowTemName.DataBind();

        strHQL = string.Format(@"select * from T_WorkFlowTemplate  where (TemName in (Select wftemplatename From T_RelatedWorkflowTemplate Where RelatedType = '{0}' and RelatedID = {1}  and '{2}' like '%'|| wftemplatename ||'%' )
                              Or (Type = 'DocumentReview' and Authority = 'All' ))
                              and Visible = 'YES'", strRelatedType, strRelatedID, strRelateName);
        DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTemplate");

        if (ds2.Tables[0].Rows.Count > 0)
        {
            DL_WorkFlowTemName.SelectedValue = ds2.Tables[0].Rows[0]["TemName"].ToString().Trim();

        }

    }

    //根据文档有无工作流情况隐藏删除按钮
    public static void HideDataGridDeleteButtonForDocUploadPage(DataGrid dataGrid1)
    {
        string strHQL;

        string strDocID, strDocName;
        Document document;

        try
        {
            for (int i = 0; i < dataGrid1.Items.Count; i++)
            {
                strDocID = dataGrid1.Items[i].Cells[0].Text;

                document = ShareClass.GetDocumentByDocID(strDocID);
                strDocName = document.DocName.Trim();

                strHQL = string.Format(@"Select * From T_Document Where RelatedType ='Workflow' and DocName ='{0}'", strDocName);
                DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Document");

                if (ds.Tables[0].Rows.Count > 0)
                {
                    ((LinkButton)dataGrid1.Items[i].FindControl("LBT_Delete")).Visible = false;
                }
                else
                {
                    ((LinkButton)dataGrid1.Items[i].FindControl("LBT_Delete")).Visible = true;
                }
            }
        }
        catch
        {
        }
    }

    //取得文档相关工作流数量
    public static int GetRelatedWorkflowCountForDoc(string strRelatedType, string strRelatedID, string strRelatedName)
    {
        string strHQL;

        strHQL = string.Format(@"Select * From T_WorkFlow A Where RelatedType ='{0}' and (RelatedID = {1}
	        or WLID in (Select RelatedID From T_Document Where DocID ={1} and RelatedName ='{2}'))", strRelatedType, strRelatedID, strRelatedName);

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");

        return ds.Tables[0].Rows.Count;
    }

    //取得文档
    public static Document GetDocumentByDocID(string strDocID)
    {
        string strHQL;
        IList lst;

        strHQL = "from Document as document where document.DocID = " + strDocID;
        DocumentBLL documentBLL = new DocumentBLL();
        lst = documentBLL.GetAllDocuments(strHQL);

        Document document = (Document)lst[0];

        return document;
    }


    //取得工作流模板是否是自动激活状态
    public static string GetWorkflowTemplateIsAutoActiveStatus(string strTemName)
    {
        string strHQL;

        strHQL = string.Format(@"Select AutoActive From T_WorkflowTemplate Where TemName = '{0}'", strTemName);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkflowTemplate");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "NO";
        }
    }


    //自动附加其它已选择的要评审的工作流文件
    public static void AddMoreWLSelectedDocumentForUploadDocPage(DataGrid dataGrid1, int intRelatedID, string strExcludeID)
    {
        string strDocID;

        try
        {

            for (int i = 0; i < dataGrid1.Items.Count; i++)
            {
                if (((CheckBox)(dataGrid1.Items[i].FindControl("CB_Select"))).Checked == true)
                {
                    strDocID = dataGrid1.Items[i].Cells[0].Text.Trim();

                    if (strDocID != strExcludeID)
                    {
                        AddWLDocumentForUploadDocPage(strDocID, intRelatedID);
                    }
                }
            }
        }
        catch
        {
        }
    }

    //自动附加要评审的工作流文件
    public static void AddWLDocumentForUploadDocPage(string strFromDocID, int intRelatedID)
    {
        string strHQL;
        IList lst;

        strHQL = "from Document as document where document.DocID = " + strFromDocID;
        DocumentBLL documentBLL = new DocumentBLL();
        lst = documentBLL.GetAllDocuments(strHQL);
        Document document = (Document)lst[0];

        document.RelatedType = "Workflow";
        document.RelatedID = intRelatedID;
        document.RelatedName = strFromDocID;
        document.UploadTime = DateTime.Now;
        document.Status = LanguageHandle.GetWord("YiPingSheng").ToString().Trim();

        try
        {
            documentBLL.AddDocument(document);

            strHQL = string.Format(@"Update T_Document Set Status = '{0}' Where DocID = {1}", LanguageHandle.GetWord("YiPingSheng").ToString().Trim(), strFromDocID);
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
        }
    }

    //更改文档关联类型和ID
    public static void UpdateDocumentRelatedTypeAndRelatedID(string strDocID, string strRelatedType, int intRelatedID)
    {
        string strHQL;
        IList lst;

        strHQL = "from Document as document where document.DocID = " + strDocID;
        DocumentBLL documentBLL = new DocumentBLL();
        lst = documentBLL.GetAllDocuments(strHQL);
        Document document = (Document)lst[0];

        document.RelatedType = strRelatedType;
        document.RelatedID = intRelatedID;
        document.RelatedName = strDocID;

        try
        {
            documentBLL.UpdateDocument(document, int.Parse(strDocID));
        }
        catch
        {
        }
    }

    //取得关联工作流的状态
    public static string GetRelatedWorkflowStatus(string strRelatedType, string strRelatedID)
    {
        string strHQL;

        strHQL = string.Format(@"Select * From T_WorkFlow Where RelatedType ='{0}' and RelatedID ={1}", strRelatedType, strRelatedID);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return GetStatusHomeNameByWorkflowStatus(ds.Tables[0].Rows[0]["Status"].ToString().Trim());
        }
        else
        {
            return LanguageHandle.GetWord("NoReviewed").ToString().Trim();
        }
    }

    //取得关联工作流的状态
    public static string GetRelatedWorkflowStatusForDocUploadPage(string strDocName, string strDocID1)
    {
        string strHQL;

        strHQL = string.Format(@"Select * From T_Document Where RelatedType ='Workflow' and DocName ='{0}' and DocID ={1}", strDocName, strDocID1);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Document");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return LanguageHandle.GetWord("YiPingSheng").ToString().Trim();
        }
        else
        {
            return LanguageHandle.GetWord("NoReviewed").ToString().Trim();
        }
    }

    //取得前步审批人
    public static string GetPriorStepLastestOperator(string strWLID, string strStepID, string strStepDetailID)
    {
        string strHQL1, strHQL2, strHQL3;
        DataSet ds1, ds2, ds3;

        string strPriorStepDetailID, strPriorStepID, strPriorOperatorName;

        strHQL1 = "Select max(ID) From T_WorkFlowStepDetail Where WLID = " + strWLID + " and StepID <> " + strStepID + " and ID <> " + strStepDetailID + " and ID < " + strStepDetailID + " and char_length(rtrim(Operation)) > 0";
        ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_WorkflowStepDetail");
        if (ds1.Tables[0].Rows.Count > 0)
        {
            strPriorStepDetailID = ds1.Tables[0].Rows[0][0].ToString().Trim();

            if (strPriorStepDetailID != "")
            {
                strHQL2 = "Select StepID From T_WorkFlowStepDetail Where WLID = " + strWLID + " and ID = " + strPriorStepDetailID;
                ds2 = ShareClass.GetDataSetFromSql(strHQL2, "T_WorkflowStep");
                if (ds2.Tables[0].Rows.Count > 0)
                {
                    strPriorStepID = ds2.Tables[0].Rows[0][0].ToString().Trim();

                    if (strPriorStepID != "")
                    {
                        //strHQL3 = "select stuff((select ','+ rtrim(A.OperatorName) from T_WorkFlowStepDetail A  Where A.WLID =" + strWLID + " and A.StepID = " + strPriorStepID + " and char_length(rtrim(Operation)) > 0 FOR xml PATH('')), 1, 1, '') as OperatorName";

                        strHQL3 = string.Format(@"select 
                            array_to_string
                                    (
                                    ARRAY(
                                            SELECT  rtrim(A.OperatorName)
                                            FROM    T_WorkFlowStepDetail A
                                            WHERE   A.WLID = B.WLID AND A.STEPID = B.STEPID
                            ),
                                    ', '
                                    ) AS group_concat
                            FROM   T_WorkFlowStepDetail B
                            WHERE B.WLID = {0} AND B.STEPID = {1}", strWLID, strPriorStepID);

                        ds3 = ShareClass.GetDataSetFromSql(strHQL3, "T_WorkflowStep");
                        if (ds3.Tables[0].Rows.Count > 0)
                        {
                            strPriorOperatorName = ds3.Tables[0].Rows[0][0].ToString().Trim();
                            return strPriorOperatorName;
                        }
                        else
                        {
                            return "";
                        }
                    }
                    else
                    {
                        return "";
                    }
                }
                else
                {
                    return "";
                }
            }
            else
            {
                return "";
            }
        }
        else
        {
            return "";
        }
    }

    //取得下一步审批人
    public static string GetNextStepLastestOperator(string strWLID, string strStepID, string strStepDetailID)
    {
        string strHQL1, strHQL2, strHQL3;
        DataSet ds1, ds2, ds3;

        string strNextStepDetailID, strNextStepID, strNextOperatorName;

        strHQL1 = "Select min(ID) From T_WorkFlowStepDetail Where WLID = " + strWLID + " and StepID <> " + strStepID + " and ID <> " + strStepDetailID + " and ID > " + strStepDetailID;
        ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_WorkflowStepDetail");
        if (ds1.Tables[0].Rows.Count > 0)
        {
            strNextStepDetailID = ds1.Tables[0].Rows[0][0].ToString().Trim();

            if (strNextStepDetailID != "")
            {
                strHQL2 = "Select StepID From T_WorkFlowStepDetail Where WLID = " + strWLID + " and ID = " + strNextStepDetailID;
                ds2 = ShareClass.GetDataSetFromSql(strHQL2, "T_WorkflowStep");
                if (ds2.Tables[0].Rows.Count > 0)
                {
                    strNextStepID = ds2.Tables[0].Rows[0][0].ToString().Trim();

                    if (strNextStepID != "")
                    {
                        //strHQL3 = "select stuff((select ','+ rtrim(A.OperatorName) from T_WorkFlowStepDetail A  Where A.WLID =" + strWLID + " and A.StepID = " + strNextStepID + " FOR xml PATH('')), 1, 1, '') as OperatorName";

                        strHQL3 = string.Format(@"select 
                            array_to_string
                                    (
                                    ARRAY(
                                            SELECT  rtrim(A.OperatorName)
                                            FROM    T_WorkFlowStepDetail A
                                            WHERE   A.WLID = B.WLID AND A.STEPID = B.STEPID
                            ),
                                    ', '
                                    ) AS group_concat
                            FROM   T_WorkFlowStepDetail B
                            WHERE B.WLID = {0} AND B.STEPID = {1}", strWLID, strNextStepID);

                        ds3 = ShareClass.GetDataSetFromSql(strHQL3, "T_WorkflowStep");
                        if (ds3.Tables[0].Rows.Count > 0)
                        {
                            strNextOperatorName = ds3.Tables[0].Rows[0][0].ToString().Trim();
                            return strNextOperatorName;
                        }
                        else
                        {
                            return "";
                        }
                    }
                    else
                    {
                        return "";
                    }
                }
                else
                {
                    return "";
                }
            }
            else
            {
                return "";
            }
        }
        else
        {
            return "";
        }
    }


    //取得最新一步审批人
    public static string GetLastestStepLastestOperator(string strWLID)
    {
        string strHQL1;
        DataSet ds1;

        int i = 0;

        string strLastestOperatorName, strLastestOperatorNameList = "";


        strHQL1 = "Select distinct OperatorCode,OperatorName From T_WorkFlowStepDetail Where IsOperator = 'YES' and StepID in (Select Max(StepID) From T_WorkFlowStep Where WLID = " + strWLID + ")";
        ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_WorkflowStepDetail");
        if (ds1.Tables[0].Rows.Count > 0)
        {
            for (i = 0; i < ds1.Tables[0].Rows.Count; i++)
            {
                if (i <= 6)
                {
                    strLastestOperatorName = "<a href='TTUserInforSimple.aspx?UserCode=" + ds1.Tables[0].Rows[i]["OperatorCode"].ToString().Trim() + "'>" + ds1.Tables[0].Rows[i]["OperatorName"].ToString().Trim() + "</a>,";
                    strLastestOperatorNameList += strLastestOperatorName;
                }

            }

            if (i >= 6)
            {
                strLastestOperatorNameList += "...";
            }

            return Regex.Replace(strLastestOperatorNameList, ",(?=[^,]*$)", "");
        }
        else
        {
            return "";
        }
    }


    //取得业务表单关联的流程ID
    public static string GetBusinessRelatedWorkFlowID(string strWLType, string strRelatedType, string strRelatedID)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlow as workFlow where workFlow.WLType = " + "'" + strWLType + "'" + " and workFlow.RelatedType=" + "'" + strRelatedType + "'" + " and workFlow.RelatedID = " + strRelatedID + " Order by workFlow.WLID DESC";
        WorkFlowBLL workFlowBLL = new WorkFlowBLL();
        lst = workFlowBLL.GetAllWorkFlows(strHQL);

        if (lst.Count > 0)
        {
            WorkFlow workFlow = (WorkFlow)lst[0];
            return workFlow.WLID.ToString();
        }
        else
        {
            return null;
        }
    }

    //取得业务表单关联的流程步骤模板是否可以全表编辑
    public static string GetWorkflowTemplateStepFullAllowEditValue(string strWLType, string strRelatedType, string strRelatedID, string strStepSortNumber)
    {
        string strTemName, strAllowFullEdit;
        DataSet ds, ds1, ds2;

        string strHQL;

        strHQL = "Select TemName from T_WorkFlow where WLType = " + "'" + strWLType + "'" + " and RelatedType=" + "'" + strRelatedType + "'" + " and RelatedID = " + strRelatedID + " Order by WLID DESC";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select TemName from T_WorkFlowBackup where WLType = " + "'" + strWLType + "'" + " and RelatedType = " + "'" + strRelatedType + "'" + " and RelatedID = " + strRelatedID + " Order by WLID DESC";
            ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowBackup");
            if (ds1.Tables[0].Rows.Count > 0)
            {
                strTemName = ds1.Tables[0].Rows[0][0].ToString().Trim();
            }
            else
            {
                return "YES";
            }
        }
        else
        {
            strTemName = ds.Tables[0].Rows[0][0].ToString().Trim();
        }

        strHQL = "Select AllowFullEdit From T_WorkFlowTStepOperator Where AllowFullEdit = 'YES' and StepID In (Select StepID From T_WorkFlowTStep Where SortNumber = " + strStepSortNumber + " and TemName = '" + strTemName + "')";
        ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTStepOperator");
        if (ds2.Tables[0].Rows.Count > 0)
        {
            strAllowFullEdit = ds2.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            strAllowFullEdit = "NO";
        }

        return strAllowFullEdit;
    }

    //取得工作流名称
    public static string GetWorkFlowName(string strWLID)
    {
        string strHQL;

        strHQL = "Select * From T_WorkFlow where WLID = " + strWLID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select * from T_WorkFlowBackup where WLID = " + strWLID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowBackup");
        }

        return ds.Tables[0].Rows[0]["WLName"].ToString().Trim();
    }

    //取得工作流类型
    public static string GetWorkFlowType(string strWLID)
    {
        string strHQL;
        DataSet ds;

        strHQL = "Select * from T_WorkFlow where WLID = " + strWLID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select * from T_WorkFlowBackup where WLID = " + strWLID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowBackup");
        }

        return ds.Tables[0].Rows[0]["WLType"].ToString().Trim();
    }

    //取得工作流关联类型
    public static string GetWorkFlowRelatedType(string strWLID)
    {
        string strHQL;
        DataSet ds;

        strHQL = "Select * from T_WorkFlow where WLID = " + strWLID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select * from T_WorkFlowBackup where WLID = " + strWLID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowBackup");
        }

        return ds.Tables[0].Rows[0]["RelatedType"].ToString().Trim();
    }

    //取得工作流关联ID
    public static string GetWorkFlowRelatedID(string strWLID)
    {
        string strHQL;
        DataSet ds;

        strHQL = "Select * from T_WorkFlow where WLID = " + strWLID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select * from T_WorkFlowBackup where WLID = " + strWLID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowBackup");
        }

        return ds.Tables[0].Rows[0]["RelatedID"].ToString().Trim();
    }

    //取得工作流当前步骤模板是否允许加签
    public static string GetWorkflowTemplateStepAllowCurrentStepAddApprover(string strStepID)
    {
        string strHQL;

        strHQL = "Select AllowCurrentStepAddApprover From T_WorkFlowTStep Where StepID = " + strStepID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTStep");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    //取得工作流下一步骤模板是否允许加签
    public static string GetWorkflowTemplateStepAllowNextStepAddApprover(string strStepID)
    {
        string strHQL;

        strHQL = "Select AllowNextStepAddApprover From T_WorkFlowTStep Where StepID = " + strStepID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTStep");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    //取得此流程的上级流程ID
    public static string GetParentWorklowID(string strWLID)
    {
        string strHQL;

        strHQL = "Select WFID From T_WFStepRelatedWF Where WFChildID = " + strWLID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WFStepRelatedWF");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "0";
        }
    }

    //取得此流程的上级流程步骤ID
    public static string GetParentWorklowStepID(string strWLID)
    {
        string strHQL;

        strHQL = "Select WFStepID From T_WFStepRelatedWF Where WFChildID = " + strWLID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WFStepRelatedWF");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "0";
        }
    }

    //依步骤ID，取得此流程的下级流程ID
    public static string GetChildWorklowIDByStepID(string strWLID, string strStepID)
    {
        string strHQL;

        strHQL = "Select WFChildID From T_WFStepRelatedWF Where WFID = " + strWLID + " and WFStepID = " + strStepID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WFStepRelatedWF");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "0";
        }
    }

    //BusinessForm,装载关联信息
    public static void LoadBusinessForm(string strRelatedType, string strRelatedID, string strTemName, System.Web.UI.HtmlControls.HtmlIframe IFrame_RelatedInformation)
    {
        string strURL;
        string strIdentifyString;

        strIdentifyString = ShareClass.GetWLTemplateIdentifyString(strTemName);

        if (strRelatedID == "")
        {
            strRelatedID = "0";
        }

        strURL = "TTRelatedDIYBusinessForm.aspx?RelatedType=" + strRelatedType + "&RelatedID=" + strRelatedID + "&IdentifyString=" + strIdentifyString;
        IFrame_RelatedInformation.Attributes.Add("src", strURL);
    }

    //BusinessForm,依类型和ID取得流程模板名称
    public static string getBusinessFormTemName(string strRelatedType, string strRelatedID)
    {
        string strHQL;

        DataSet ds = null;

        strHQL = "Select TemName From T_RelatedBusinessForm Where RelatedType = '" + strRelatedType + "' and  RelatedID = " + strRelatedID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedBusinessForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0]["TemName"].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    //取得工作流类型的本地化名称
    public static string GetWorkflowTypeHomeName(string strWLType)
    {
        string strHQL;
        IList lst;

        strHQL = string.Format(@"Select HomeName From T_WLType Where Type = '{0}' and LangCode ='{1}'", strWLType, HttpContext.Current.Session["LangCode"].ToString().Trim());
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WLType");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return strWLType;
        }
    }

    //BusinessForm,列出业务表单类型
    public static void LoadWorkflowType(DropDownList DL_WLType, string strLangCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from WLType as wlType ";
        strHQL += " Where wlType.LangCode =" + "'" + strLangCode + "'";
        strHQL += " and wlType.Type in (Select workFlowTemplate.Type From WorkFlowTemplate as workFlowTemplate)";
        strHQL += " order by wlType.SortNumber ASC";
        WLTypeBLL wlTypeBLL = new WLTypeBLL();
        lst = wlTypeBLL.GetAllWLTypes(strHQL);
        DL_WLType.DataSource = lst;
        DL_WLType.DataBind();
        DL_WLType.Items.Insert(0, new ListItem("--Select--", "0"));
    }

    //BusinessForm,取业务表单模板名称
    public static string GetWorkTemplateType(string strTemName)
    {
        IList lst;
        string strHQL, strTemType;

        WorkFlowTemplateBLL workFlowTemplateBLL = new WorkFlowTemplateBLL();
        strHQL = "from WorkFlowTemplate as workFlowTemplate where workFlowTemplate.TemName =" + "'" + strTemName + "'";
        lst = workFlowTemplateBLL.GetAllWorkFlowTemplates(strHQL);

        WorkFlowTemplate workFlowTemplate = (WorkFlowTemplate)lst[0];

        try
        {
            strTemType = workFlowTemplate.Type.Trim();
        }
        catch
        {
            strTemType = "";
        }

        return strTemType;
    }

    //更改工作流关联的数据文件
    //strCmdText = "select * from T_AssetPurchaseOrder where POID = " + strPOID;
    public static void UpdateWokflowRelatedXMLFile(string strTableType, string strWLID, string strWLStepDetailID, string strCmdText)
    {
        string strXMLFileName, strXMLFile, strXMLFile1;
        string strWLType;

        string strHQL;

        XMLProcess xmlProcess = new XMLProcess();

        strWLType = ShareClass.GetWorkFlowType(strWLID);

        strXMLFileName = strWLType + DateTime.Now.ToString("yyyyMMddHHMMssff") + ".xml";
        strXMLFile = "Doc\\" + "XML" + "\\" + strXMLFileName;

        strXMLFile1 = HttpContext.Current.Server.MapPath(strXMLFile);
        xmlProcess.DbToXML(strCmdText, "T_BusinessFormDataTable", strXMLFile1);

        if (strTableType == "MainTable")
        {
            strHQL = "Update T_WorkFlow Set XMLFile = '" + strXMLFile + "' Where WLID = " + strWLID;
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Update T_WorkFlowStepDetail Set XMLFile = '" + strXMLFile + "' Where ID = " + strWLStepDetailID;
            ShareClass.RunSqlCommand(strHQL);
        }
        else
        {
            strHQL = "Update T_WorkFlowStepDetail Set DetailXMLFile = '" + strXMLFile + "' Where ID = " + strWLStepDetailID;
            ShareClass.RunSqlCommand(strHQL);
        }
    }

    //BusinessForm，关联相应的业务表单模板
    public static void SaveRelatedBusinessForm(string strRelatedType, string strRelatedID, string strTemName, string strAllowUpdate, string strUserCode)
    {
        string strHQL;
        string strXSNFile, strOldTemName, strOldXSNFile;

        if (strTemName != "")
        {
            strXSNFile = ShareClass.GetWorkFlowTemplateXSNFile(strTemName);

            strHQL = "Select * From T_RelatedBusinessForm Where RelatedType = '" + strRelatedType + "' and RelatedID =" + strRelatedID;
            strHQL += " and TemName = '" + strTemName + "' and XSNFile = '" + strXSNFile + "'";
            DataSet ds = GetDataSetFromSql(strHQL, "T_RelatedBusinessForm");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strOldTemName = ds.Tables[0].Rows[0]["TemName"].ToString().Trim();
                strOldXSNFile = ds.Tables[0].Rows[0]["XSNFile"].ToString().Trim();

                if (strTemName != strOldTemName || strXSNFile != strOldXSNFile)
                {
                    strHQL = "Delete From T_RelatedBusinessForm Where RelatedType = '" + strRelatedType + "' and RelatedID =" + strRelatedID;
                    strHQL += " and TemName = '" + strTemName + "' and XSNFile = '" + strXSNFile + "'";
                    ShareClass.RunSqlCommand(strHQL);

                    strHQL = "Insert Into T_RelatedBusinessForm(RelatedType,RelatedID,TemName,XSNFile,XMLFile,AllowUpdate,OperatorCode,OperatorName,CreateTime)";
                    strHQL += " Values('" + strRelatedType + "'," + strRelatedID + ",'" + strTemName + "','" + strXSNFile + "','','" + strAllowUpdate + "','" + strUserCode + "','" + ShareClass.GetUserName(strUserCode) + "',now())";
                    ShareClass.RunSqlCommand(strHQL);
                }
            }
            else
            {
                strHQL = "Insert Into T_RelatedBusinessForm(RelatedType,RelatedID,TemName,XSNFile,XMLFile,AllowUpdate,OperatorCode,OperatorName,CreateTime)";
                strHQL += " Values('" + strRelatedType + "'," + strRelatedID + ",'" + strTemName + "','" + strXSNFile + "','','" + strAllowUpdate + "','" + strUserCode + "','" + ShareClass.GetUserName(strUserCode) + "',now())";
                ShareClass.RunSqlCommand(strHQL);
            }
        }
    }

    //BusinessForm,取得业务表单模板名称
    public static string getRelatedBusinessFormTemName(string strRelatedType, string strRelatedID)
    {
        string strHQL;

        strHQL = "Select * From T_RelatedBusinessForm Where RelatedType ='" + strRelatedType + "' and RelatedID =" + strRelatedID;
        strHQL += " Order By CreateTime DESC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedBusinessForm");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0]["TemName"].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    //BusinessForm,处理关联的业务表单数据
    public static void InsertOrUpdateTaskAssignRecordWFXMLData(string strRelatedType, string strRelatedID, string strAssignType, string strAssignID, string strUserCode)
    {
        string strHQL;
        int i;
        string strTemName, strXSNFile, strXMLFile, strWFXMLData;

        strHQL = "Select * From T_RelatedBusinessForm Where RelatedType = '" + strRelatedType + "' and RelatedID =" + strRelatedID;
        strHQL += " Order By CreateTime ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedBusinessForm");
        for (i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strTemName = ds.Tables[0].Rows[i]["TemName"].ToString().Trim();
            strXSNFile = ds.Tables[0].Rows[i]["XSNFile"].ToString().Trim();
            strXMLFile = ds.Tables[0].Rows[i]["XMLFile"].ToString().Trim();
            strWFXMLData = ds.Tables[0].Rows[i]["WFXMlData"].ToString();

            strHQL = "Insert Into T_RelatedBusinessForm(RelatedType,RelatedID,TemName,XSNFile,XMLFile,OperatorCode,OperatorName,CreateTime)";
            strHQL += " Values('" + strAssignType + "'," + strAssignID + ",'" + strTemName + "','" + strXSNFile + "','" + strXMLFile + "','" + strUserCode + "','" + ShareClass.GetUserName(strUserCode) + "',now())";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Update T_RelatedBusinessForm Set WFXMLData = '" + strWFXMLData + "'";
            strHQL += " Where RelatedType='" + strAssignType + "' and  RelatedID = " + strAssignID;
            strHQL += " and TemName ='" + strTemName + "' and XSNFile = '" + strXSNFile + "'";
            ShareClass.RunSqlCommand(strHQL);
        }
    }

    //列出流程关联模组
    public static void LoadWorkFlowTStepRelatedModule(Repeater RP_RelatedModule, string strWorkflowID, string strWorkflowStepID, string strWorkflowStepDetailID, string strStepGUID, string strLangCode, string strUserCode)
    {
        string strHQL;

        strHQL = string.Format(@"Select distinct B.HomeModuleName,A.PageName,A.ModuleName,A.ModuleType,3750 as WorkflowID,5819 as WorkflowStepID,6877 as WorkflowStepDetailID 
            ,MainTableCanAdd,DetailTableCanAdd,MainTableCanEdit,MainTableCanDelete,DetailTableCanEdit,DetailTableCanDelete 
            From T_WorkFlowTStepRelatedModule A,T_ProModuleLevel B  Where StepGUID = '{0}' 
            and A.ModuleName = B.ModuleName and B.LangCode = '{1}' And A.ModuleName in (Select ModuleName From T_ProModule 
            Where Visible = 'YES' and IsDeleted = 'NO' and UserCode = '{2}')
              and B.ID in (Select min(B.ID) From T_WorkFlowTStepRelatedModule A,T_ProModuleLevel B  Where StepGUID = '{0}' 
            and A.ModuleName = B.ModuleName and B.LangCode = '{1}' And A.ModuleName in (Select ModuleName From T_ProModule 
            Where Visible = 'YES' and IsDeleted = 'NO' and UserCode = '{2}')
               Group By B.ModuleName,B.PageName)", strStepGUID, strLangCode, strUserCode);

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTStepRelatedModule");

        RP_RelatedModule.DataSource = ds;
        RP_RelatedModule.DataBind();
    }

    //如流程相关模组，初始化
    public static void InitialWorkflowRelatedModule(string strRelatedWorkflowID, string strRelatedWorkflowStepID, Button BT_CreateMain, LinkButton BT_NewMain, Button BT_CreateDetail, LinkButton BT_NewDetail, string strMainTableCanAdd, string strDetailTableCanAdd, string strMainTableCanEdit, string strDetailTableCanEdit)
    {
        //WorkFlow,如果是由工作流启动的业务，那么隐藏模糊查询功能
        if (strRelatedWorkflowID != null)
        {
            if (strMainTableCanAdd == "YES")
            {
                BT_CreateMain.Visible = true;
            }
            else
            {
                BT_CreateMain.Visible = false;
            }

            if (strDetailTableCanAdd == "YES")
            {
                BT_CreateDetail.Visible = true;
            }
            else
            {
                BT_CreateDetail.Visible = false;
            }

            if (strMainTableCanEdit == "YES")
            {
                BT_NewMain.Visible = true;
            }
            else
            {
                BT_NewMain.Visible = false;
            }

            if (strDetailTableCanEdit == "YES")
            {
                BT_NewDetail.Visible = true;
            }
            else
            {
                BT_NewDetail.Visible = false;
            }
        }
    }

    //如流程相关模组，主表初始化
    public static void MainTableChangeWorkflowRelatedModule(string strCurrentUserCode, string strRelatedBusinessType, string strRelatedBusinessID, string strRelatedBusinessCreatorCode, string strRelatedWorkflowID, string strRelatedWorkflowStepID, string strRelatedWorkflowStepDetailID, Button BT_CreateMain, LinkButton BT_NewMain, Button BT_CreateDetail, LinkButton BT_NewDetail, string strMainTableCanEdit)
    {
        //WorkFlow,如果此单和工作流相关，那么依工作流状态决定能否保存单据数据
        string strWFStatus, strStepStatus;

        //不从流程启动时，判断有没有相关的流程记录
        if (strRelatedWorkflowID == null)
        {
            WorkFlowRelatedModule workFlowRelatedModule = ShareClass.getModuleToRelatedWorkflow(strRelatedBusinessType, strRelatedBusinessID);
            if (workFlowRelatedModule != null)
            {
                strRelatedWorkflowID = workFlowRelatedModule.WorkflowID.ToString();
                strRelatedWorkflowStepID = workFlowRelatedModule.WorkflowStepID.ToString();
                strRelatedWorkflowStepDetailID = workFlowRelatedModule.WorkflowStepDetailID.ToString();
            }
        }

        if (strRelatedWorkflowID != null)
        {
            strWFStatus = ShareClass.GetWorkFlowStatus(strRelatedWorkflowID);
            strStepStatus = ShareClass.GetWorkFlowStepStatus(strRelatedWorkflowStepID);
            if ((strStepStatus == "InProgress" | strStepStatus == "New") & (strWFStatus != "Passed" & strWFStatus != "CaseClosed"))
            {
                if (strWFStatus == "InProgress" & strRelatedWorkflowStepID == "0")
                {
                    BT_NewMain.Visible = false;
                }
            }
            else
            {
                BT_NewMain.Visible = false;
            }

            if (strMainTableCanEdit == "NO")
            {
                BT_NewMain.Visible = false;
            }
        }
    }

    //如流程相关模组，主表删除
    public static bool MainTableDeleteWorkflowRelatedModule(string strCurrentUserCode, string strRelatedBusinessCreatorCode, string strRelatedWorkflowID, string strRelatedWorkflowStepID, string strRelatedWorkflowStepDetailID, string strMainTableCanDelete)
    {
        //Workflow,如果存在关联工作流，那么要执行下面的代码
        string strWFStatus, strStepStatus;

        if (strRelatedWorkflowID != null)
        {
            strWFStatus = ShareClass.GetWorkFlowStatus(strRelatedWorkflowID);
            strStepStatus = ShareClass.GetWorkFlowStepStatus(strRelatedWorkflowStepID);
            if (!((strStepStatus == "InProgress" | strStepStatus == "New") & (strWFStatus != "Passed" & strWFStatus != "CaseClosed")))
            {
                return false;
            }

            if (strMainTableCanDelete == "NO")
            {
                return false;
            }

            return true;
        }

        return true;
    }

    //如流程相关模组，明细表初始化
    public static void DetailTableChangeWorkflowRelatedModule(string strCurrentUserCode, string strRelatedBusinessType, string strRelatedBusinessID, string strRelatedWorkflowID, string strRelatedWorkflowStepID, string strRelatedWorkflowStepDetailID, Button BT_CreateMain, LinkButton BT_NewMain, Button BT_CreateDetail, LinkButton BT_NewDetail, string strDetailTableCanAdd, string strDetailTableCanEdit)
    {
        //WorkFlow,如果此单和工作流相关，那么依工作流状态决定能否保存单据数据
        string strWFStatus, strStepStatus;

        //不从流程启动时，判断有没有相关的流程记录
        if (strRelatedWorkflowID == null)
        {
            WorkFlowRelatedModule workFlowRelatedModule = ShareClass.getModuleToRelatedWorkflow(strRelatedBusinessType, strRelatedBusinessID);
            if (workFlowRelatedModule != null)
            {
                strRelatedWorkflowID = workFlowRelatedModule.WorkflowID.ToString();
                strRelatedWorkflowStepID = workFlowRelatedModule.WorkflowStepID.ToString();
                strRelatedWorkflowStepDetailID = workFlowRelatedModule.WorkflowStepDetailID.ToString();
            }
        }

        if (strRelatedWorkflowID != null)
        {
            strWFStatus = ShareClass.GetWorkFlowStatus(strRelatedWorkflowID);
            strStepStatus = ShareClass.GetWorkFlowStepStatus(strRelatedWorkflowStepID);
            if ((strStepStatus == "InProgress" | strStepStatus == "New") & (strWFStatus != "Passed" & strWFStatus != "CaseClosed"))
            {
                if (strWFStatus == "InProgress" & strRelatedWorkflowStepID == "0")
                {
                    BT_NewDetail.Visible = false;
                }
                //else
                //{
                //    WorkFlowRelatedModule workFlowRelatedModule = ShareClass.getModuleToRelatedWorkflow(strRelatedBusinessType, strRelatedBusinessID);
                //    if (strRelatedWorkflowStepDetailID != workFlowRelatedModule.WorkflowStepDetailID.ToString())
                //    {
                //        BT_NewDetail.Visible = false;
                //    }
                //}
            }
            else
            {
                BT_NewDetail.Visible = false;
            }

            if (strDetailTableCanEdit == "NO")
            {
                BT_NewDetail.Visible = false;
            }
        }
    }

    //如流程相关模组，明细表删除
    public static bool DetailTableDeleteWorkflowRelatedModule(string strCurrentUserCode, string strRelatedBusinessCreatorCode, string strRelatedWorkflowID, string strRelatedWorkflowStepID, string strRelatedWorkflowStepDetailID, string strDetailTableCanDelete)
    {
        string strWFStatus, strStepStatus;
        if (strRelatedWorkflowID != null)
        {
            strWFStatus = ShareClass.GetWorkFlowStatus(strRelatedWorkflowID);
            strStepStatus = ShareClass.GetWorkFlowStepStatus(strRelatedWorkflowStepID);
            if (!((strStepStatus == "InProgress" | strStepStatus == "New") & (strWFStatus != "Passed" & strWFStatus != "CaseClosed")))
            {
                return false;
            }
            else
            {
                if (strDetailTableCanDelete == "NO")
                {
                    return false;
                }
            }

            if (strDetailTableCanDelete == "NO")
            {
                return false;
            }

            return true;
        }

        return true;
    }

    //取得流程操作明细表
    public static WorkFlowStepDetail GetWorkFlowStepDetail(string strWorkflowStepDetailID)
    {
        string strHQL;
        IList lst;

        strHQL = "From WorkFlowStepDetail as workFlowStepDetail Where workFlowStepDetail.ID = " + strWorkflowStepDetailID;
        WorkFlowStepDetailBLL workFlowStepDetailBLL = new WorkFlowStepDetailBLL();
        lst = workFlowStepDetailBLL.GetAllWorkFlowStepDetails(strHQL);

        if (lst.Count > 0)
        {
            return (WorkFlowStepDetail)lst[0];
        }
        else
        {
            return null;
        }
    }

    //取得流程模板步骤
    public static WorkFlowTStep GetWorkFlowTStep(string strTemName, int intSortNumber)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlowTStep as workFlowTStep where workFlowTStep.TemName = " + "'" + strTemName + "'" + " and workFlowTStep.SortNumber = " + intSortNumber.ToString();
        WorkFlowTStepBLL workFlowTStepBLL = new WorkFlowTStepBLL();
        lst = workFlowTStepBLL.GetAllWorkFlowTSteps(strHQL);

        WorkFlowTStep workFlowTStep = (WorkFlowTStep)lst[0];

        return workFlowTStep;
    }

    //取得流程步骤
    public static WorkFlowStep GetWorkFlowStep(string strStepID)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlowStep as workFlowStep where workFlowStep.StepID = " + strStepID;
        WorkFlowStepBLL workFlowStepBLL = new WorkFlowStepBLL();
        lst = workFlowStepBLL.GetAllWorkFlowSteps(strHQL);
        WorkFlowStep workFlowStep = (WorkFlowStep)lst[0];

        return workFlowStep;
    }

    public static string GetWorkflowTemNameByWLID(string strWLID)
    {
        string strHQL;
        DataSet ds;

        strHQL = "Select * from T_WorkFlow where WLID = " + strWLID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select * from T_WorkFlowBackup where WLID = " + strWLID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowBackup");
        }

        return ds.Tables[0].Rows[0]["TemName"].ToString().Trim();
    }

    public static string GetWorkFlowStatus(string strWLID)
    {
        string strHQL;
        DataSet ds;

        strHQL = "Select * from T_WorkFlow where WLID = " + strWLID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select * from T_WorkFlowBackup where WLID = " + strWLID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowBackup");
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0]["Status"].ToString().Trim();
        }
        else
        {
            return "New";
        }
    }

    public static string GetWorkFlowStepStatus(string strStepID)
    {
        string strHQL;
        DataSet ds;

        strHQL = "Select * from T_WorkFlowStep where StepID = " + strStepID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStep");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select * from T_WorkFlowStepBackup where StepID = " + strStepID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStepBackup");
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0]["Status"].ToString().Trim();
        }
        else
        {
            return "New";
        }
    }

    //添加模组关联流程记录
    public static void AddModuleToRelatedWorkflow(string strWorkflowID, string strWorkflowStepID, string strWorkflowStepDetailID, string strRelatedModuleName, string strRelatedID)
    {
        if (strWorkflowID != null)
        {
            WorkFlowRelatedModuleBLL workFlowRelatedModuleBLL = new WorkFlowRelatedModuleBLL();
            WorkFlowRelatedModule workFlowRelatedModule = new WorkFlowRelatedModule();

            workFlowRelatedModule.WorkflowID = int.Parse(strWorkflowID);
            workFlowRelatedModule.WorkflowStepID = int.Parse(strWorkflowStepID);
            workFlowRelatedModule.WorkflowStepDetailID = int.Parse(strWorkflowStepDetailID);
            workFlowRelatedModule.RelatedModuleName = strRelatedModuleName;
            workFlowRelatedModule.RelatedID = strRelatedID;

            try
            {
                workFlowRelatedModuleBLL.AddWorkFlowRelatedModule(workFlowRelatedModule);
            }
            catch
            {
            }
        }
    }

    //删除模组关联流程记录
    public static void DeleteModuleToRelatedWorkflow(string strWorkflowID, string strWorkflowStepID, string strWorkflowStepDetailID, string strRelatedModuleName, string strRelatedID)
    {
        if (strWorkflowID != null)
        {
            string strHQL;

            strHQL = "Delete From T_WorkFlowRelatedModule Where RelatedModuleName = '" + strRelatedModuleName + "' and RelatedID = '" + strRelatedID + "'";
            strHQL += " and WorkflowID = " + strWorkflowID + " and WorkflowStepID = " + strWorkflowStepID + " and WorkflowStepDetailID = " + strWorkflowStepDetailID;

            try
            {
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }
    }

    //取得模组相关流程记录
    public static WorkFlowRelatedModule getModuleToRelatedWorkflow(string strRelatedModuleName, string strRelatedID)
    {
        string strHQL;
        IList lst;

        strHQL = "From WorkFlowRelatedModule as workFlowRelatedModule Where workFlowRelatedModule.RelatedModuleName = '" + strRelatedModuleName + "' and workFlowRelatedModule.RelatedID = '" + strRelatedID + "'";
        WorkFlowRelatedModuleBLL workFlowRelatedModuleBLL = new WorkFlowRelatedModuleBLL();
        lst = workFlowRelatedModuleBLL.GetAllWorkFlowRelatedModules(strHQL);

        if (lst.Count > 0)
        {
            return (WorkFlowRelatedModule)lst[0];
        }
        else
        {
            return null;
        }
    }

    //取得是否自动激活工作流
    public static string GetWorkflowTemplateAutoActive(string strTemName)
    {
        string strHQL;

        strHQL = "Select AutoActive From T_WorkFlowTemplate Where TemName = '" + strTemName + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTemplate");

        return ds.Tables[0].Rows[0][0].ToString().Trim();
    }

    //取得工作流关联的MainTableID
    public static int GetWorkflowMainTableID(string strWFID)
    {
        string strHQL;

        strHQL = "Select MainTableID From T_WorkFlow Where WLID = " + strWFID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Workflow");

        try
        {
            return int.Parse(ds.Tables[0].Rows[0][0].ToString().Trim());
        }
        catch
        {
            return 0;
        }
    }

    //取得工作流XML文件
    public static string GetWorkflowXMLFile(string strWFID)
    {
        string strHQL;

        strHQL = "Select XMLFile From T_WorkFlow Where WLID = " + strWFID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Workflow");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select XMLFile From T_WorkFlow Where WLID = " + strWFID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowBackup");
        }

        try
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        catch
        {
            return "";
        }
    }

    //取得工作流模板设计类型
    public static string GetWLTemplateDesignType(string strTemName)
    {
        string strHQL;
        IList lst;

        WorkFlowTemplateBLL workFlowTemplateBLL = new WorkFlowTemplateBLL();
        strHQL = "from WorkFlowTemplate as workFlowTemplate where workFlowTemplate.TemName = " + "'" + strTemName + "'";
        lst = workFlowTemplateBLL.GetAllWorkFlowTemplates(strHQL);

        WorkFlowTemplate workFlowTemplate = (WorkFlowTemplate)lst[0];

        return workFlowTemplate.DesignType.Trim();
    }

    //取得工作流模板串
    public static string GetWLTemplateIdentifyString(string strTemName)
    {
        string strHQL;
        IList lst;

        WorkFlowTemplateBLL workFlowTemplateBLL = new WorkFlowTemplateBLL();
        strHQL = "from WorkFlowTemplate as workFlowTemplate where workFlowTemplate.TemName = " + "'" + strTemName + "'";
        lst = workFlowTemplateBLL.GetAllWorkFlowTemplates(strHQL);

        if (lst.Count > 0)
        {
            WorkFlowTemplate workFlowTemplate = (WorkFlowTemplate)lst[0];

            return workFlowTemplate.IdentifyString.Trim();
        }
        else
        {
            return "";
        }
    }

    //取得工作流模板名
    public static string GetWLTemplateNameByIdentifyString(string strIdentifyString)
    {
        string strHQL;
        IList lst;

        WorkFlowTemplateBLL workFlowTemplateBLL = new WorkFlowTemplateBLL();
        strHQL = "from WorkFlowTemplate as workFlowTemplate where workFlowTemplate.IdentifyString = " + "'" + strIdentifyString + "'";
        lst = workFlowTemplateBLL.GetAllWorkFlowTemplates(strHQL);

        if (lst.Count > 0)
        {
            WorkFlowTemplate workFlowTemplate = (WorkFlowTemplate)lst[0];

            return workFlowTemplate.TemName.Trim();
        }
        else
        {
            return "";
        }
    }

    public static int GetRelatedWorkFlowNumber(string strWLType, string strRelatedType, string strRelatedID)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlow as workFlow where workFlow.WLType = " + "'" + strWLType + "'" + " and workFlow.RelatedType = " + "'" + strRelatedType + "'" + " and workFlow.RelatedID = " + strRelatedID;
        WorkFlowBLL workFlowBLL = new WorkFlowBLL();
        lst = workFlowBLL.GetAllWorkFlows(strHQL);

        return lst.Count;
    }

    public static void LoadRelatedWL(string strWLType, string strRelatedType, int intRelatedID, DataGrid dataGrid)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlow as workFlow where workFlow.WLType = " + "'" + strWLType + "'" + " and workFlow.RelatedType=" + "'" + strRelatedType + "'" + " and workFlow.RelatedID = " + intRelatedID.ToString() + " Order by workFlow.WLID DESC";
        WorkFlowBLL workFlowBLL = new WorkFlowBLL();
        lst = workFlowBLL.GetAllWorkFlows(strHQL);

        dataGrid.DataSource = lst;
        dataGrid.DataBind();
    }

    public static string GetWorkFlowLastestXMLFile(string strTemName)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlow as workFlow where workFlow.TemName = '" + strTemName + "'";
        strHQL += " Order By workFlow.WLID DESC";
        WorkFlowBLL workFlowBLL = new WorkFlowBLL();
        lst = workFlowBLL.GetAllWorkFlows(strHQL);

        if (lst.Count > 0)
        {
            WorkFlow workFlow = (WorkFlow)lst[0];
            return workFlow.XMLFile.Trim();
        }
        else
        {
            return "";
        }
    }

    public static string GetWorkFlowTemplateXSNFile(string strTemName)
    {
        string strHQL;
        IList lst;

        WorkFlowTemplateBLL workFlowTemplateBLL = new WorkFlowTemplateBLL();
        strHQL = "from WorkFlowTemplate as workFlowTemplate where workFlowTemplate.TemName = " + "'" + strTemName + "'";
        lst = workFlowTemplateBLL.GetAllWorkFlowTemplates(strHQL);

        if (lst.Count > 0)
        {
            WorkFlowTemplate workFlowTemplate = (WorkFlowTemplate)lst[0];

            if (workFlowTemplate.XSNFile != "")
            {
                return workFlowTemplate.XSNFile.Trim();
            }
            else
            {
                return "";
            }
        }
        else
        {
            return "";
        }
    }

    public static void LoadWFTemplate(string strUserCode, string strWFType, DropDownList DL_TemName)
    {
        string strHQL;
        string strDepartCode;

        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        string strParentDepartString = TakeTopCore.CoreShareClass.InitialParentDepartmentStringByAuthority(strUserCode);
        string strUnderDepartString = TakeTopCore.CoreShareClass.InitialUnderDepartmentStringByAuthority(strUserCode);

        strHQL = "Select TemName From T_WorkFlowTemplate Where Type = " + "'" + strWFType + "'" + " and Authority = 'All'";
        //strHQL += " and (BelongDepartCode in (select ParentDepartCode from F_GetParentDepartCode(" + "'" + strDepartCode + "'" + "))";
        strHQL += " and (BelongDepartCode in " + strParentDepartString;
        strHQL += " Or BelongDepartCode in " + strUnderDepartString;
        strHQL += " Or TemName in (Select TemName From T_WorkFlowTemplateBusinessMember Where UserCode = '" + strUserCode + "')";
        strHQL += " Or TemName in (Select TemName From T_WorkFlowTemplateBusinessDepartment Where DepartCode in " + strParentDepartString + "))";
        strHQL += " Order by SortNumber ASC";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTemplate");

        DL_TemName.DataSource = ds;
        DL_TemName.DataBind();
    }

    public static void DisplayRelatedWFStepDump(string strTemName, string strWLID, string strWFStatus, Repeater Repeater1)
    {
        string strHQL;
        int intSortNumber;
        string strWFStepStatus, strStepName;
        DataSet ds;

        strHQL = "Select A.SortNumber,COALESCE(c.Status,'InProgress') as Status,A.StepName From T_WorkFlowTStep A";
        strHQL += " Left Join T_WorkFlow B On A.TemName = B.TemName ";
        strHQL += " Left Join T_WorkFlowStep C On  A.SortNumber = C.SortNumber and B.WLID = C.WLID  ";
        strHQL += " Where A.TemName = '" + strTemName + "' and B.WLID = " + strWLID;
        strHQL += " and A.SortNumber > 0 ";
        strHQL += " Order By A.SortNumber ASC";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTStep");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select A.SortNumber,COALESCE(c.Status,'InProgress') as Status,A.StepName From T_WorkFlowTStep A";
            strHQL += " Left Join T_WorkFlowBackup B On A.TemName = B.TemName ";
            strHQL += " Left Join T_WorkFlowStepBackup C On  A.SortNumber = C.SortNumber and B.WLID = C.WLID  ";
            strHQL += " Where A.TemName = '" + strTemName + "' and B.WLID = " + strWLID;
            strHQL += " and A.SortNumber > 0 ";
            strHQL += " Order By A.SortNumber ASC";
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowTStep");
        }

        Repeater1.DataSource = ds;
        Repeater1.DataBind();

        if (ds.Tables[0].Rows.Count > 0)
        {
            try
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    intSortNumber = int.Parse(ds.Tables[0].Rows[i][0].ToString());
                    strWFStepStatus = ds.Tables[0].Rows[i][1].ToString().Trim();
                    strStepName = ds.Tables[0].Rows[i][2].ToString().Trim();

                    if (strWFStepStatus == "Passed")
                    {
                        ((ImageButton)Repeater1.Items[i].FindControl("IBT_WFStep")).ImageUrl = "Images/GreenDump.png";
                    }
                    else
                    {
                        ((ImageButton)Repeater1.Items[i].FindControl("IBT_WFStep")).ImageUrl = "Images/RedDump.png";
                    }
                    //}

                    ((ImageButton)Repeater1.Items[i].FindControl("IBT_WFStep")).ToolTip = intSortNumber.ToString() + " " + strStepName;
                }
            }
            catch
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    ((ImageButton)Repeater1.Items[i].FindControl("IBT_WFStep")).ImageUrl = "Images/RedDump.png";

                    intSortNumber = int.Parse(ds.Tables[0].Rows[i][0].ToString());
                    strWFStepStatus = ds.Tables[0].Rows[i][1].ToString().Trim();
                    strStepName = ds.Tables[0].Rows[i][2].ToString().Trim();

                    ((ImageButton)Repeater1.Items[i].FindControl("IBT_WFStep")).ToolTip = intSortNumber.ToString() + " " + strStepName;
                }
            }
        }
    }

    public static WorkFlowStep GetWorkFlowMaxApprovedStep(string strWLID)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlowStep as workFlowStep where workFlowStep.WLID = " + strWLID;
        strHQL += " Order By workFlowStep.StepID DESC";

        WorkFlowStepBLL workFlowStepBLL = new WorkFlowStepBLL();
        lst = workFlowStepBLL.GetAllWorkFlowSteps(strHQL);

        WorkFlowStep workFlowStep = new WorkFlowStep();

        if (lst.Count > 0)
        {
            workFlowStep = (WorkFlowStep)lst[0];

            return workFlowStep;
        }
        else
        {
            return workFlowStep;
        }
    }

    //取得流程步序号
    public static int GetWorkFlowCurrentStepSortNumber(string strStepID)
    {
        string strHQL;
        DataSet ds;

        strHQL = "Select * from T_WorkFlowStep where StepID = " + strStepID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStep");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select * from T_WorkFlowStepBackup where StepID = " + strStepID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStepBackup");
        }

        int intSortNumber = int.Parse(ds.Tables[0].Rows[0]["SortNumber"].ToString().Trim());

        return intSortNumber;
    }

    //更改流程相关对象状态
    public static bool UpdateRelatedBusinessStatus(string strWFType, string strRelatedID, string strOperation)
    {
        string strHQL;

        try
        {
            if (strOperation == "Agree")
            {
                if (strWFType == "CustomerServiceReview")
                {
                    strHQL = "Update T_CustomerQuestion Set Status = 'Completed' Where ID = " + strRelatedID;
                    ShareClass.RunSqlCommand(strHQL);
                }

                if (strWFType == "VehicleRequest")
                {
                    strHQL = "Update T_CarApplyForm Set Status = 'Passed' Where ID  = " + strRelatedID;
                    ShareClass.RunSqlCommand(strHQL);
                }
            }

            if (strOperation == "Cancel")
            {
                if (strWFType == "CustomerServiceReview")
                {
                    strHQL = "Update T_CustomerQuestion Set Status = 'InProgress' Where ID = " + strRelatedID;
                    ShareClass.RunSqlCommand(strHQL);
                }

                if (strWFType == "VehicleRequest")
                {
                    strHQL = "Update T_CarApplyForm Set Status = 'InProgress' Where ID  = " + strRelatedID;
                    ShareClass.RunSqlCommand(strHQL);
                }
            }

            return true;
        }
        catch
        {
            return false;
        }
    }

    public static string GetWFDefinition(string strTemName)
    {
        IList lst;
        string strHQL, strWFDefinition;

        WorkFlowTemplateBLL workFlowTemplateBLL = new WorkFlowTemplateBLL();
        strHQL = "from WorkFlowTemplate as workFlowTemplate where workFlowTemplate.TemName =" + "'" + strTemName + "'";
        lst = workFlowTemplateBLL.GetAllWorkFlowTemplates(strHQL);

        WorkFlowTemplate workFlowTemplate = (WorkFlowTemplate)lst[0];

        try
        {
            strWFDefinition = workFlowTemplate.WFDefinition.Trim();
        }
        catch
        {
            strWFDefinition = "";
        }

        return strWFDefinition;
    }

    #endregion 工作流相关操作函数

}
