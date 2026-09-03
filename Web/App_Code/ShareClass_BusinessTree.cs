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
/// ShareClass partial - BusinessTree
/// </summary>
public static partial class ShareClass
{
    
    #region 定义各种业务树

    //定义合同树
    public static void InitialConstractTree(TreeView ConstractTreeView)
    {
        string strHQL;
        IList lst;

        string strConstractID, strConstractCode, strConstractName;

        //添加根节点
        ConstractTreeView.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("WoDeHeTong").ToString().Trim() + "</B>";
        node1.Target = "";
        node1.Expanded = true;
        ConstractTreeView.Nodes.Add(node1);

        Constract constract = new Constract();

        strHQL = "from Constract as constract where ";
        strHQL += " constract.ParentCode = ''";
        strHQL += " and constract.Status not in ('Archived','Deleted') ";
        strHQL += " order by constract.SignDate DESC,constract.ConstractCode DESC";

        ConstractBLL constractBLL = new ConstractBLL();
        lst = constractBLL.GetAllConstracts(strHQL);


        for (int i = 0; i < lst.Count; i++)
        {
            constract = (Constract)lst[i];

            strConstractID = constract.ConstractID.ToString();
            strConstractCode = constract.ConstractCode.Trim();
            strConstractName = constract.ConstractName.Trim();

            node3 = new TreeNode();

            node3.Text = strConstractID + " " + strConstractCode + " " + strConstractName;
            node3.Target = strConstractCode;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            ConstractTreeShow(strConstractCode, node3);
            ConstractTreeView.DataBind();
        }
    }

    public static void ConstractTreeShow(string strParentCode, TreeNode treeNode)
    {
        string strHQL;
        IList lst1, lst2;

        string strConstractID, strConstractCode, strConstractName;

        ConstractBLL constractBLL = new ConstractBLL();
        Constract constract = new Constract();

        strHQL = "from Constract as constract where ";
        strHQL += " constract.ParentCode = " + "'" + strParentCode + "'";
        strHQL += " and constract.Status not in ('Archived','Deleted') ";
        strHQL += " order by constract.SignDate DESC,constract.ConstractCode DESC";

        lst1 = constractBLL.GetAllConstracts(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            constract = (Constract)lst1[i];

            strConstractID = constract.ConstractID.ToString();
            strConstractCode = constract.ConstractCode.Trim();
            strConstractName = constract.ConstractName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strConstractCode;
            node.Text = strConstractID + " " + strConstractCode + " " + strConstractName;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;


            strHQL = "from Constract as constract where ";
            strHQL += " constract.ParentCode = " + "'" + strConstractCode + "'";
            strHQL += " and constract.Status not in ('Archived','Deleted') ";
            strHQL += " order by constract.SignDate DESC,constract.ConstractCode DESC";
            lst2 = constractBLL.GetAllConstracts(strHQL);

            if (lst2.Count > 0)
            {
                ConstractTreeShow(strConstractCode, node);
            }
        }
    }

    //取得合同名称
    public static string GetConstractName(string strConstractCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From Constract as constract Where constract.ConstractCode = " + "'" + strConstractCode + "'";
        ConstractBLL constractBLL = new ConstractBLL();

        try
        {
            lst = constractBLL.GetAllConstracts(strHQL);
            Constract constract = (Constract)lst[0];
            return constract.ConstractName.Trim();
        }
        catch
        {
            return "";
        }
    }

    //取得合同ID号
    public static int GetConstractID(string strConstractCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From Constract as constract Where constract.ConstractCode = " + "'" + strConstractCode + "'";
        ConstractBLL constractBLL = new ConstractBLL();

        try
        {
            lst = constractBLL.GetAllConstracts(strHQL);
            Constract constract = (Constract)lst[0];
            return constract.ConstractID;
        }
        catch
        {
            return 0;
        }
    }


    //定义所有文档类型树
    public static void InitialAllDocTypeTree(TreeView TreeView3)
    {
        string strHQL, strDocTypeID, strDocType;
        IList lst;

        //添加根节点
        TreeView3.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<Strong>" + LanguageHandle.GetWord("WenDangLeiXing").ToString().Trim() + "</Strong>"; ;
        node1.Target = "0";
        node1.Expanded = true;
        TreeView3.Nodes.Add(node1);

        strHQL = "from DocType as docType  where ";
        strHQL += " docType.ParentID not in (select docType.ID from DocType as docType)";
        strHQL += " order by docType.SortNumber ASC";

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        DocType docType = new DocType();

        lst = docTypeBLL.GetAllDocTypes(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            docType = (DocType)lst[i];

            strDocTypeID = docType.ID.ToString();

            strDocType = docType.Type.Trim();

            node3 = new TreeNode();

            node3.Text = (i + 1).ToString() + "." + strDocType;
            node3.Target = strDocTypeID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            AllDocTypeTreeShow(strDocTypeID, node3);
            TreeView3.DataBind();
        }
    }

    public static void AllDocTypeTreeShow(string strParentID, TreeNode treeNode)
    {
        string strHQL, strDocTypeID, strDocType;
        IList lst1, lst2;

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        DocType docType = new DocType();

        strHQL = "from DocType as docType  where ";
        strHQL += " docType.ParentID = " + strParentID;
        //strHQL += " order by docType.ParentID DESC";
        strHQL += " order by docType.SortNumber ASC";
        lst1 = docTypeBLL.GetAllDocTypes(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            docType = (DocType)lst1[i];
            strDocTypeID = docType.ID.ToString();
            strDocType = docType.Type.Trim();

            TreeNode node = new TreeNode();
            node.Target = strDocTypeID;
            node.Text = (i + 1).ToString() + "." + strDocType;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from DocType as docType where docType.ParentID = " + strDocTypeID + " Order by docType.ID DESC";
            lst2 = docTypeBLL.GetAllDocTypes(strHQL);

            if (lst2.Count > 0)
            {
                AllDocTypeTreeShow(strDocTypeID, node);
            }
        }
    }

    public static void InitialAllUserDocTypeTree(TreeView TreeView3, string strUserCode)
    {
        string strHQL, strDocTypeID, strDocType, strDepartCode;
        IList lst;

        //添加根节点
        TreeView3.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<Strong>" + LanguageHandle.GetWord("WenDangLeiXing").ToString().Trim() + "</Strong>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView3.Nodes.Add(node1);

        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = "from DocType as docType  where ((docType.SaveType = 'Company') or (docType.SaveType = 'Group') or (docType.SaveType = 'All') ";
        strHQL += " or (docType.UserCode = " + "'" + strUserCode + "'" + ")";
        strHQL += " or (docType.SaveType = 'Department' and docType.UserCode in (Select projectMember.UserCode from ProjectMember as projectMember where projectMember.DepartCode = " + "'" + strDepartCode + "'" + "))";
        strHQL += " or (docType.SaveType not in ('All','Group','Company','Individual','Department') and docType.SaveType in (select actorGroupDetail.GroupName from ActorGroupDetail as actorGroupDetail where actorGroupDetail.UserCode = " + "'" + strUserCode + "'" + ")))";
        strHQL += " and docType.ParentID not in (select docType.ID from DocType as docType)";
        strHQL += " order by docType.SortNumber ASC";

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        DocType docType = new DocType();

        lst = docTypeBLL.GetAllDocTypes(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            docType = (DocType)lst[i];

            strDocTypeID = docType.ID.ToString();

            strDocType = docType.Type.Trim();

            node3 = new TreeNode();

            node3.Text = (i + 1).ToString() + "." + strDocType;
            node3.Target = strDocTypeID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            AllUserDocTypeTreeShow(strDocTypeID, node3, strUserCode, strDepartCode);

            TreeView3.DataBind();
        }
    }

    public static void AllUserDocTypeTreeShow(string strParentID, TreeNode treeNode, string strUserCode, string strDepartCode)
    {
        string strHQL, strDocTypeID, strDocType;
        IList lst1, lst2;

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        DocType docType = new DocType();

        strHQL = "from DocType as docType  where ((docType.SaveType = 'Company') or (docType.SaveType = 'Group')  or (docType.SaveType = 'All') ";
        strHQL += " or (docType.UserCode = " + "'" + strUserCode + "'" + ")";
        strHQL += " or (docType.SaveType = 'Department' and docType.UserCode in (Select projectMember.UserCode from ProjectMember as projectMember where projectMember.DepartCode = " + "'" + strDepartCode + "'" + "))";
        strHQL += " or (docType.SaveType not in ('All','Group','Company','Individual','Department') and docType.SaveType in (select actorGroupDetail.GroupName from ActorGroupDetail as actorGroupDetail where actorGroupDetail.UserCode = " + "'" + strUserCode + "'" + ")))";
        strHQL += " and docType.ParentID = " + strParentID;
        strHQL += " order by docType.SortNumber ASC";

        lst1 = docTypeBLL.GetAllDocTypes(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            docType = (DocType)lst1[i];
            strDocTypeID = docType.ID.ToString();
            strDocType = docType.Type.Trim();

            TreeNode node = new TreeNode();
            node.Target = strDocTypeID;
            node.Text = (i + 1).ToString() + "." + strDocType;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from DocType as docType where docType.ParentID = " + strDocTypeID + " Order by docType.ID DESC";
            lst2 = docTypeBLL.GetAllDocTypes(strHQL);

            if (lst2.Count > 0)
            {
                AllUserDocTypeTreeShow(strDocTypeID, node, strUserCode, strDepartCode);
            }
        }
    }

    public static void InitialUserDocTypeTree(TreeView TreeView3, string strUserCode)
    {
        string strHQL, strDocTypeID, strDocType, strDepartCode;
        IList lst;

        //添加根节点
        TreeView3.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<Strong>" + LanguageHandle.GetWord("WenDangLeiXing").ToString().Trim() + "</Strong>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView3.Nodes.Add(node1);

        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        if (strUserCode == "ADMIN")
        {
            strHQL = string.Format(@"from DocType as docType where ((docType.SaveType = 'Company') or (docType.SaveType = 'Group') or (docType.SaveType = 'All')
                 or (docType.UserCode = '{0}')
                 or (docType.SaveType = 'Department' and docType.UserCode in (Select projectMember.UserCode from ProjectMember as projectMember where projectMember.DepartCode = '{1}'))
                 or (docType.SaveType not in ('All','Group','Company','Individual','Department') and docType.SaveType in (select actorGroupDetail.GroupName from ActorGroupDetail as actorGroupDetail where actorGroupDetail.UserCode = '{0}')))
                 and docType.ParentID not in (select docType.ID from DocType as docType)
                 order by docType.SortNumber ASC", strUserCode, strDepartCode);
        }
        else
        {
            strHQL = string.Format(@"from DocType as docType where ((docType.SaveType = 'Company') or (docType.SaveType = 'Group') or (docType.SaveType = 'All')
                 or (docType.UserCode = '{0}')
                 or (docType.SaveType = 'Department' and docType.UserCode in (Select projectMember.UserCode from ProjectMember as projectMember where projectMember.DepartCode = '{1}'))
                 or (docType.SaveType not in ('All','Group','Company','Individual','Department') and docType.SaveType in (select actorGroupDetail.GroupName from ActorGroupDetail as actorGroupDetail where actorGroupDetail.UserCode = '{0}')))
                 and docType.ParentID not in (select docType.ID from DocType as docType)
                 and docType.Type not in ('任务库','知识库')
                 order by docType.SortNumber ASC", strUserCode, strDepartCode);
        }

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        DocType docType = new DocType();

        lst = docTypeBLL.GetAllDocTypes(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            docType = (DocType)lst[i];

            strDocTypeID = docType.ID.ToString();

            strDocType = docType.Type.Trim();

            node3 = new TreeNode();

            node3.Text = (i + 1).ToString() + "." + strDocType;
            node3.Target = strDocTypeID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            UserDocTypeTreeShow(strDocTypeID, node3, strUserCode, strDepartCode);

            TreeView3.DataBind();
        }
    }

    public static void UserDocTypeTreeShow(string strParentID, TreeNode treeNode, string strUserCode, string strDepartCode)
    {
        string strHQL, strDocTypeID, strDocType;
        IList lst1, lst2;

        DocTypeBLL docTypeBLL = new DocTypeBLL();
        DocType docType = new DocType();

        if (strUserCode == "ADMIN")
        {
            strHQL = "from DocType as docType  where ((docType.SaveType = 'Company') or (docType.SaveType = 'Group')  or (docType.SaveType = 'All')";
            strHQL += " or (docType.UserCode = " + "'" + strUserCode + "'" + ")";
            strHQL += " or (docType.SaveType = 'Department' and docType.UserCode in (Select projectMember.UserCode from ProjectMember as projectMember where projectMember.DepartCode = " + "'" + strDepartCode + "'" + "))";
            strHQL += " or (docType.SaveType not in ('All','Group','Company','Individual','Department') and docType.SaveType in (select actorGroupDetail.GroupName from ActorGroupDetail as actorGroupDetail where actorGroupDetail.UserCode = " + "'" + strUserCode + "'" + ")))";
            strHQL += " and docType.ParentID = " + strParentID;
            strHQL += " order by docType.SortNumber ASC";
        }
        else
        {
            strHQL = "from DocType as docType  where ((docType.SaveType = 'Company') or (docType.SaveType = 'Group')  or (docType.SaveType = 'All') ";
            strHQL += " or (docType.UserCode = " + "'" + strUserCode + "'" + ")";
            strHQL += " or (docType.SaveType = 'Department' and docType.UserCode in (Select projectMember.UserCode from ProjectMember as projectMember where projectMember.DepartCode = " + "'" + strDepartCode + "'" + "))";
            strHQL += " or (docType.SaveType not in ('All','Group','Company','Individual','Department') and docType.SaveType in (select actorGroupDetail.GroupName from ActorGroupDetail as actorGroupDetail where actorGroupDetail.UserCode = " + "'" + strUserCode + "'" + ")))";
            strHQL += " and docType.ParentID = " + strParentID;
            //strHQL += " and docType.Type not in ('任务库','知识库')";  
            strHQL += " order by docType.SortNumber ASC";
        }
        lst1 = docTypeBLL.GetAllDocTypes(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            docType = (DocType)lst1[i];
            strDocTypeID = docType.ID.ToString();
            strDocType = docType.Type.Trim();

            TreeNode node = new TreeNode();
            node.Target = strDocTypeID;
            node.Text = (i + 1).ToString() + "." + strDocType;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from DocType as docType where docType.ParentID = " + strDocTypeID + " Order by docType.ID DESC";
            lst2 = docTypeBLL.GetAllDocTypes(strHQL);

            if (lst2.Count > 0)
            {
                UserDocTypeTreeShow(strDocTypeID, node, strUserCode, strDepartCode);
            }
        }
    }

    //依相关类型定义文档类型树
    public static void InitialDocTypeTree(TreeView TreeView1, string strUserCode, string strRelatedType, string strRelatedID, string strRelatedName)
    {
        string strHQL;
        IList lst;

        string strDocTypeID, strTotalDocType = "", strDocType, strDepartCode;

        int j = 1;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        if (strRelatedType == "KnowledgeMgt")
        {
            node1.Text = LanguageHandle.GetWord("WSCDSYWD").ToString().Trim();
        }
        else
        {
            node1.Text = strRelatedType + ":" + strRelatedID + " " + strRelatedName + " " + LanguageHandle.GetWord("WenDangLieBiao").ToString().Trim();
        }
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = string.Format(
                 "from DocTypeFilter as docTypeFilter where docTypeFilter.RelatedType = '{0}' and docTypeFilter.RelatedID = {1}",
                 strRelatedType,
                 strRelatedID
             );
        if (strRelatedType == "Project")
        {
            strHQL = string.Format(@"from DocTypeFilter as docTypeFilter where docTypeFilter.DocType in (
                    Select distinct document.DocType from Document as document where (
                        (
                            (document.RelatedType = 'Project' and document.RelatedID = {0})
                            and (
                                (document.UploadManCode = '{1}' and document.DepartCode = '{2}')
                                or (document.Visible in ('Department','Entire'))
                            )
                        )
                        or (
                            (
                                (document.RelatedType = 'Requirement' and document.RelatedID in (select relatedDefect.DefectID from RelatedDefect as relatedDefect where relatedDefect.ProjectID = {0}))
                                or (document.RelatedType = 'Risk' and document.RelatedID in (select projectRisk.ID from ProjectRisk as projectRisk where projectRisk.ProjectID = {0}))
                                or (document.RelatedType = 'Task' and document.RelatedID in (select projectTask.TaskID from ProjectTask as projectTask where projectTask.ProjectID = {0}))
                                or (document.RelatedType = 'Plan' and document.RelatedID in (select workPlan.ID from WorkPlan as workPlan where workPlan.ProjectID = {0}))
                                or (document.RelatedType = 'Meeting' and document.RelatedID in (select meeting.ID from Meeting as meeting where meeting.RelatedType='Project' and meeting.RelatedID = {0}))
                            )
                            and (
                                (document.Visible in ('Meetin','Department') and document.DepartCode = '{2}')
                                or (document.Visible = 'Entire')
                            )
                        )
                    )
                    and rtrim(ltrim(document.Status)) <> 'Deleted'
                )", strRelatedID, strUserCode, strDepartCode);
        }

        if (strRelatedType == "ProjectType")
        {
            strHQL = string.Format(@"from DocTypeFilter as docTypeFilter where docTypeFilter.DocType in (
                    Select distinct document.DocType from Document as document 
                    where document.RelatedName = '{0}' 
                    and document.Status <> 'Deleted' )",
                      strRelatedName);
        }

        if (strRelatedType == "KnowledgeMgt")
        {
            strHQL = string.Format(
                  @"from DocTypeFilter as docTypeFilter where docTypeFilter.DocType in (
                    Select distinct document.DocType from Document as document 
                    where document.UploadManCode = '{0}' 
                    and document.DepartCode = '{1}'
                    and document.Status <> 'Deleted'
                )",
                  strUserCode,
                  strDepartCode);
        }

        DocTypeFilterBLL docTypeFilterBLL = new DocTypeFilterBLL();
        DocTypeFilter docTypeFilter = new DocTypeFilter();

        lst = docTypeFilterBLL.GetAllDocTypeFilters(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            docTypeFilter = (DocTypeFilter)lst[i];

            strDocTypeID = docTypeFilter.DocTypeID.ToString();

            strDocType = docTypeFilter.DocType.Trim();

            if (strTotalDocType.IndexOf(strDocType) <= -1)
            {
                strTotalDocType += strDocType + ",";

                node3 = new TreeNode();

                node3.Text = j.ToString() + "." + strDocType;
                node3.Target = strDocTypeID;
                node3.Expanded = true;

                j++;

                node1.ChildNodes.Add(node3);

                TreeView1.DataBind();
            }
        }
    }

    //取得文件类型列表
    public static IList GetDocTypeList(string strUserCode)
    {
        string strHQL, strDepartCode;
        IList lst;

        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        if (strUserCode == "ADMIN")
        {
            strHQL = "from DocType as docType  where ((docType.SaveType = 'Company') or (docType.SaveType = 'Group') or (docType.SaveType = 'All')";
            strHQL += " or (docType.UserCode = " + "'" + strUserCode + "'" + ")";
            strHQL += " or (docType.SaveType = 'Department' and docType.UserCode in (Select projectMember.UserCode from ProjectMember as projectMember where projectMember.DepartCode = " + "'" + strDepartCode + "'" + "))";
            strHQL += " or (docType.SaveType not in ('All','Group','Company','Individual','Department') and docType.SaveType in (select actorGroupDetail.GroupName from ActorGroupDetail as actorGroupDetail where actorGroupDetail.UserCode = " + "'" + strUserCode + "'" + ")))";
            strHQL += " and docType.ParentID not in (select docType.ID from DocType as docType)";
            strHQL += " order by docType.SortNumber ASC";
        }
        else
        {
            strHQL = "from DocType as docType  where ((docType.SaveType = 'Company') or (docType.SaveType = 'Group')  or (docType.SaveType = 'All')";
            strHQL += " or (docType.UserCode = " + "'" + strUserCode + "'" + ")";
            strHQL += " or (docType.SaveType = 'Department' and docType.UserCode in (Select projectMember.UserCode from ProjectMember as projectMember where projectMember.DepartCode = " + "'" + strDepartCode + "'" + "))";
            strHQL += " or (docType.SaveType not in ('All','Group','Company','Individual','Department') and docType.SaveType in (select actorGroupDetail.GroupName from ActorGroupDetail as actorGroupDetail where actorGroupDetail.UserCode = " + "'" + strUserCode + "'" + ")))";
            strHQL += " and docType.ParentID not in (select docType.ID from DocType as docType)";
            //strHQL += " and docType.Type not in ('Task','KnowledgeMgt')";  
            strHQL += " order by docType.SortNumber ASC";
        }
        DocTypeBLL docTypeBLL = new DocTypeBLL();
        lst = docTypeBLL.GetAllDocTypes(strHQL);

        return lst;
    }

    //取得文档类型的上级类型
    public static string getDocParentTypeByID(string strTypeID)
    {
        string strHQL;
        string strParentTypeID;

        try
        {
            strHQL = "Select ParentID From T_DocType Where ID = " + strTypeID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_DocType");

            strParentTypeID = ds.Tables[0].Rows[0][0].ToString().Trim();

            strHQL = "Select Type From T_DocType Where ID = " + strParentTypeID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_DocType");

            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        catch
        {
            return "";
        }
    }

    /// <summary>
    /// 定义竣工资料显示的项目树结构 By LiuJianping 2013-09-13
    /// </summary>
    /// <param name="TreeView1"></param>
    /// <param name="strUserCode"></param>
    public static void InitialInvolvedProjectComTree(TreeView TreeView1, string strUserCode)
    {
        string strHQL, strProjectID, strProject;
        string strProjectIDString = "";
        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<A href=TTCompletionDataManage.aspx?TargetID=Project_0 Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        node1.Target = "Project" + "_" + "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "Select distinct ProjectID,ProjectName from V_ProRelatedUser Where UserCode = '" + strUserCode + "' Order by ProjectID DESC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "V_ProRelatedUser");
        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds.Tables[0].Rows[i]["ProjectID"].ToString().Trim();
            strProject = ds.Tables[0].Rows[i]["ProjectName"].ToString().Trim();

            if (strProjectIDString.IndexOf(strProjectID + ",") >= 0)
            {
                continue;
            }
            else
            {
                strProjectIDString += strProjectID + ",";
            }

            node3 = new TreeNode();
            node3.Text = "<A href=TTCompletionDataManage.aspx?TargetID=Project_" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);

            TreeView1.DataBind();
        }
    }

    /// <summary>
    /// 根据检索条件获取预算费用  2013-11-15  By LiuJianping
    /// </summary>
    /// <param name="dg">DataGrid控件</param>
    /// <param name="strDepartCode">部门编码-非空</param>
    /// <param name="strAccountName">会计科目-可空</param>
    /// <param name="strYearNum">年份-非空 为空的话，用0代表</param>
    /// <param name="strMonthNum">月份-非空，0代表空</param>
    /// <param name="strType">费用类型 基础、操作两种，基础即为预算费用设置的标准额度；操作即为实际预算费用记录的申请额度</param>
    public static void GetBMBaseDataList(ref DataGrid dg, string strDepartCode, string strAccountName, int strYearNum, int strMonthNum, string strType)
    {
        string strHQL = "From BDBaseData as bDBaseData where bDBaseData.DepartCode = '" + strDepartCode + "' and bDBaseData.AccountName='" + strAccountName + "' and " +
                "bDBaseData.MonthNum = '" + strMonthNum.ToString() + "' and bDBaseData.Type='" + strType + "' ";
        if (strYearNum != 0)
        {
            strHQL += "and bDBaseData.YearNum='" + strYearNum.ToString() + "' ";
        }

        BDBaseDataBLL bMBaseDataBLL = new BDBaseDataBLL();
        IList lst = bMBaseDataBLL.GetAllBDBaseDatas(strHQL);

        dg.DataSource = lst;
        dg.DataBind();
    }

    //全局项目树，还有删除线的
    public static void InitialPrjectTreeWithDeleteLine(TreeView TreeView1)
    {
        string strHQL;
        IList lst;

        string strProjectID, strProject;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node2 = new TreeNode();

        node1.Text = "<B>1." + LanguageHandle.GetWord("ZongXiangMu").ToString().Trim() + " </B>";
        node1.Target = "1";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where ";
        strHQL += " project.ParentID = 1 Or project.ParentID = 0";
        strHQL += " And project.ProjectID <> 1";
        strHQL += " order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();
        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString();
            if (project.ProjectClass.Trim() == "模板项目")
            {
                strProject = "[<font size='2'  color='#FF0000'>" + LanguageHandle.GetWord("MoBan").ToString().Trim() + "</font>]" + project.ProjectName.Trim();
            }
            else
            {
                strProject = project.ProjectName.Trim();
            }

            node2 = new TreeNode();

            if (project.Status.Trim() == "Deleted")
            {
                node2.Text = "<strike><font size='2'  color='#FF0000'>" + strProjectID + "." + strProject + "</font></strike>";
            }
            else
            {
                node2.Text = strProjectID + "." + strProject;
            }
            node2.Target = strProjectID;
            node2.Expanded = false;

            node1.ChildNodes.Add(node2);
            TreeShowWithDeleteLine(strProjectID, node2);
            TreeView1.DataBind();
        }
    }

    public static void TreeShowWithDeleteLine(string strParentID, TreeNode treeNode)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            if (project.ProjectClass.Trim() == "模板项目")
            {
                strProject = "[<font size='2'  color='#FF0000'>" + LanguageHandle.GetWord("MoBan").ToString().Trim() + "</font>]" + project.ProjectName.Trim();
            }
            else
            {
                strProject = project.ProjectName.Trim();
            }

            TreeNode node = new TreeNode();
            node.Target = strProjectID;

            if (project.Status.Trim() == "Deleted")
            {
                node.Text = "<strike><font size='2'  color='#FF0000'>" + strProjectID + "." + strProject + "</font></strike>";
            }
            else
            {
                node.Text = strProjectID + "." + strProject;
            }

            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID + " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                TreeShowWithDeleteLine(strProjectID, node);
            }
        }
    }

    //定义所有项目树
    public static void InitialAllProjectTree(TreeView TreeView1, string strDepartString)
    {
        string strHQL;
        IList lst;

        string strProjectID, strProject;
        String strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Project_0 Target=Right><B> " + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B></a>";
        node1.Target = "Project" + "_" + "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where ";
        strHQL += " project.ParentID = 1";
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
        strHQL += " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            node3 = new TreeNode();
            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            AllProjectTreeShow(strProjectID, node3, strDepartString);

            TreeView1.DataBind();
        }
    }

    public static void AllProjectTreeShow(string strParentID, TreeNode treeNode, string strDepartString)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID;
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
        strHQL += " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + "." + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID;
            strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
            strHQL += " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                AllProjectTreeShow(strProjectID, node, strDepartString);
            }
        }
    }

    //定义所有项目树 FOR YYUP
    public static void InitialAllProjectTree_YYUP(TreeView TreeView1, string strDepartString)
    {
        string strHQL;
        IList lst;

        string strProjectID, strProject, strProductLineRelated;
        String strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();

        strProductLineRelated = ShareClass.GetDepartSuperUserRelatedProductLineFromUserCode(strUserCode);

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Project_0 Target=Right><B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B></a>";
        node1.Target = "Project" + "_" + "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where ";
        strHQL += "  project.ParentID = 1 ";
        strHQL += "  and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";

        if (strProductLineRelated == "YES")
        {
            strHQL += " and project.ProjectID in (Select project_YYUP.ProjectID From Project_YYUP as project_YYUP Where project_YYUP.ProductLine in ";
            strHQL += " (Select departSuperUserRelatedProductLine.ProductLineName From DepartSuperUserRelatedProductLine as departSuperUserRelatedProductLine Where departSuperUserRelatedProductLine.UserCode = " + "'" + strUserCode + "'" + "))";
        }

        strHQL += "  and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            node3 = new TreeNode();
            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            AllProjectTreeShow_YYUP(strProjectID, node3, strDepartString);

            TreeView1.DataBind();
        }
    }

    public static void AllProjectTreeShow_YYUP(string strParentID, TreeNode treeNode, string strDepartString)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID;
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
        strHQL += " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + "." + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID;
            strHQL += "  and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
            strHQL += " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                AllProjectTreeShow_YYUP(strProjectID, node, strDepartString);
            }
        }
    }

    //定义直接成员的项目树
    public static void InitialMembersProjectTree(TreeView TreeView1, string strUserCode)
    {
        string strHQL;
        IList lst;

        string strProjectID, strProject, strProductLineRelated, strOperatorDepartCode;

        strProductLineRelated = ShareClass.GetDepartRelatedProductLineFromUserCode(strUserCode);
        strOperatorDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("WDZJCYDXMHTMDZXM").ToString().Trim() + " </B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where project.UserCode = " + "'" + strUserCode + "'" + " and project.PMCode in (select memberLevel.UnderCode from MemberLevel as memberLevel where memberLevel.ProjectVisible = 'YES' and memberLevel.UserCode = " + "'" + strUserCode + "'" + ") ";
        strHQL += " and project.Status not in ('Deleted','Archived') ";
        strHQL += " order by project.ProjectID DESC";

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            node3 = new TreeNode();

            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            MembersProjectTreeShow(strProjectID, node3);
            TreeView1.DataBind();
        }
    }

    public static void MembersProjectTreeShow(string strParentID, TreeNode treeNode)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + ". " + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID + " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                MembersProjectTreeShow(strProjectID, node);
            }
        }
    }

    //定义直接成员的项目树 FOR YYUP
    public static void InitialMembersProjectTree_YYUP(TreeView TreeView1, string strUserCode)
    {
        string strHQL;
        IList lst;

        string strProjectID, strProject, strProductLineRelated, strOperatorDepartCode;

        strProductLineRelated = ShareClass.GetDepartRelatedProductLineFromUserCode(strUserCode);
        strOperatorDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("WDZJCYDXMHTMDZXM").ToString().Trim() + " </B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where project.UserCode = " + "'" + strUserCode + "'" + " and project.PMCode in (select memberLevel.UnderCode from MemberLevel as memberLevel where memberLevel.ProjectVisible = 'YES' and memberLevel.UserCode = " + "'" + strUserCode + "'" + ") ";

        if (strProductLineRelated == "YES")
        {
            strHQL += " and project.ProjectID in (Select project_YYUP.ProjectID From Project_YYUP as project_YYUP Where project_YYUP.ProductLine in ";
            strHQL += " (Select departRelatedProductLine.ProductLineName From DepartRelatedProductLine as departRelatedProductLine Where departRelatedProductLine.DepartCode = " + "'" + strOperatorDepartCode + "'" + "))";
        }

        strHQL += " and project.Status not in ('Deleted','Archived') ";
        strHQL += " order by project.ProjectID DESC";

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            node3 = new TreeNode();

            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            MembersProjectTreeShow_YYUP(strProjectID, node3);
            TreeView1.DataBind();
        }
    }

    public static void MembersProjectTreeShow_YYUP(string strParentID, TreeNode treeNode)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + ". " + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID + " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                MembersProjectTreeShow_YYUP(strProjectID, node);
            }
        }
    }

    //定义我的的项目树
    public static void InitialMyProjectTree(TreeView TreeView1, string strUserCode)
    {
        string strHQL, strProjectID, strProject;
        IList lst;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("WDXMHTMDZXM").ToString().Trim() + " </B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where project.PMCode = " + "'" + strUserCode + "'";
        strHQL += " and project.ParentID not in (select project.ProjectID from Project as project where project.PMCode = " + "'" + strUserCode + "'" + ")";
        strHQL += "  and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            node3 = new TreeNode();

            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            MyProjectTreeShow(strProjectID, node3);
            TreeView1.DataBind();
        }
    }

    public static void MyProjectTreeShow(string strParentID, TreeNode treeNode)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + ". " + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID + " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                MyProjectTreeShow(strProjectID, node);
            }
        }
    }

    //定义所有项目文档树
    public static string InitialAllProjectDocTree(TreeView TreeView1, string strUserCode, string strQueryCount, string strOperationType, string strMinProjectID, string strMaxProjectID)
    {
        string strHQL;

        string strProjectID, strProject;

        string strDepartString;
        if (HttpContext.Current.Session["DepartString"] == null)
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
            HttpContext.Current.Session["DepartString"] = strDepartString;
        }
        else
        {
            strDepartString = HttpContext.Current.Session["DepartString"].ToString();
        }

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();
        TreeNode node4 = new TreeNode();

        node1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Project_0 Target=Right><B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        node1.Target = "Project" + "_" + "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        if (strOperationType == "All")
        {
            strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";

            strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
            strHQL += " Order By ProjectID DESC limit " + strQueryCount;
        }
        else
        {
            if (strOperationType == "Piror")
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";

                strHQL += " And ProjectID > " + strMaxProjectID;
                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID ASC limit " + strQueryCount;
            }
            else
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";
                strHQL += " And ProjectID < " + strMinProjectID;

                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID DESC limit " + strQueryCount;
            }
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds.Tables[0].Rows[i][0].ToString().Trim();
            strProject = ds.Tables[0].Rows[i][1].ToString().Trim();

            node3 = new TreeNode();
            node3.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Project_" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            //AllProjectDocTreeShowIncludeAll(strUserCode, strProjectID, node3);

            if (getChildProjectNumber(strProjectID, strDepartString) > 0)
            {
                node4 = new TreeNode();
                node4.Text = LanguageHandle.GetWord("ChildProjectTree");
                node4.Target = strProjectID + "_ChildrenProject";
                node4.Expanded = false;
                node3.ChildNodes.Add(node4);
                AllProjectDocTreeShowIncludeChild(strProjectID, node4, strDepartString);
            }

            TreeView1.DataBind();
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            if (strOperationType == "All" | strOperationType == "Next")
            {
                strMaxProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMinProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }
            else
            {
                strMinProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMaxProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }

            return strMinProjectID + "-" + strMaxProjectID;
        }
        else
        {
            return "";
        }
    }

    //检查项目是否包含子项目
    public static int getChildProjectNumber(string strParentProjectID, string strDepartString)
    {
        string strHQL;

        strHQL = "Select * From T_Project Where ParentID = " + strParentProjectID;
        strHQL += " and Status not in ('Deleted','Archived') and ProjectID <> 1";
        strHQL += " and PMCode in (Select UserCode From T_ProjectMember Where DepartCode in " + strDepartString + ")";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows.Count;
        }
        else
        {
            return 0;
        }
    }

    public static void AllProjectDocTreeShowIncludeChild(string strParentID, TreeNode treeNode, string strDepartString)
    {
        string strHQL;
        IList lst1, lst2;

        string strProjectID, strProject;
        String strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();

        TreeNode node4 = new TreeNode();

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived')";
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";

        strHQL += " order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Project_" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            if (getChildProjectNumber(strProjectID, strDepartString) > 0)
            {
                node4 = new TreeNode();
                node4.Text = LanguageHandle.GetWord("ChildProjectTree");
                node4.Target = strProjectID + "_ChildrenProject";
                node4.Expanded = false;
                node.ChildNodes.Add(node4);
                AllProjectDocTreeShowIncludeChild(strProjectID, node4, strDepartString);
            }
        }
    }

    //定义所有项目（翻页查询）
    public static string InitialAllProjectTreeForPageFind(TreeView TreeView1, string strUserCode, string strQueryCount, string strOperationType, string strMinProjectID, string strMaxProjectID)
    {
        string strHQL;
        string strProjectID, strProject;

        string strDepartString;
        if (HttpContext.Current.Session["DepartString"] == null)
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
            HttpContext.Current.Session["DepartString"] = strDepartString;
        }
        else
        {
            strDepartString = HttpContext.Current.Session["DepartString"].ToString();
        }

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();
        TreeNode node4 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B>";
        node1.Target = "1";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        if (strOperationType == "All")
        {
            strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";

            strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
            strHQL += " Order By ProjectID DESC limit " + strQueryCount;
        }
        else
        {
            if (strOperationType == "Piror")
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";

                strHQL += " And ProjectID > " + strMaxProjectID;
                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID ASC limit " + strQueryCount;
            }
            else
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";
                strHQL += " And ProjectID < " + strMinProjectID;

                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID DESC limit " + strQueryCount;
            }
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds.Tables[0].Rows[i][0].ToString().Trim();
            strProject = ds.Tables[0].Rows[i][1].ToString().Trim();

            node3 = new TreeNode();
            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;

            node1.ChildNodes.Add(node3);
            node3.Expanded = false;

            AllProjectTreeShowForPageFind(strProjectID, node3, strDepartString);

            TreeView1.DataBind();
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            if (strOperationType == "All" | strOperationType == "Next")
            {
                strMaxProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMinProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }
            else
            {
                strMinProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMaxProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }

            return strMinProjectID + "-" + strMaxProjectID;
        }
        else
        {
            return "";
        }
    }

    public static void AllProjectTreeShowForPageFind(string strParentID, TreeNode treeNode, string strDepartString)
    {
        string strHQL;
        IList lst1;

        string strProjectID, strProject;
        String strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();

        TreeNode node4 = new TreeNode();

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived')";
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";

        strHQL += " order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + "." + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            AllProjectTreeShowForPageFind(strProjectID, node, strDepartString);
        }
    }

    //定义所有项目（翻页查询） For YYUP
    public static string InitialAllProjectTreeForPageFind_YYUP(TreeView TreeView1, string strUserCode, string strQueryCount, string strOperationType, string strMinProjectID, string strMaxProjectID)
    {
        string strHQL;
        string strDepartString;
        if (HttpContext.Current.Session["DepartString"] == null)
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
            HttpContext.Current.Session["DepartString"] = strDepartString;
        }
        else
        {
            strDepartString = HttpContext.Current.Session["DepartString"].ToString();
        }

        string strProjectID, strProject, strProductLineRelated;

        strProductLineRelated = ShareClass.GetDepartSuperUserRelatedProductLineFromUserCode(strUserCode);


        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();
        TreeNode node4 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B>";
        node1.Target = "1";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        if (strOperationType == "All")
        {
            strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";

            if (strProductLineRelated == "YES")
            {
                strHQL += " and ProjectID in (Select ProjectID From T_Project_YYUP  Where ProductLine in ";
                strHQL += " (Select ProductLineName From T_DepartSuperUserRelatedProductLine Where UserCode = " + "'" + strUserCode + "'" + "))";
            }

            strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
            strHQL += " Order By ProjectID DESC limit " + strQueryCount;
        }
        else
        {
            if (strOperationType == "Piror")
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";

                if (strProductLineRelated == "YES")
                {
                    strHQL += " and ProjectID in (Select ProjectID From T_Project_YYUP Where ProductLine in ";
                    strHQL += " (Select ProductLineName From T_DepartSuperUserRelatedProductLine  Where UserCode = " + "'" + strUserCode + "'" + "))";
                }

                strHQL += " And ProjectID > " + strMaxProjectID;
                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID ASC limit " + strQueryCount;
            }
            else
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";
                strHQL += " And ProjectID < " + strMinProjectID;

                if (strProductLineRelated == "YES")
                {
                    strHQL += " and ProjectID in (Select ProjectID From T_Project_YYUP Where ProductLine in ";
                    strHQL += " (Select ProductLineName From T_DepartSuperUserRelatedProductLine Where UserCode = " + "'" + strUserCode + "'" + "))";
                }

                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID DESC limit " + strQueryCount;
            }
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds.Tables[0].Rows[i][0].ToString().Trim();
            strProject = ds.Tables[0].Rows[i][1].ToString().Trim();

            node3 = new TreeNode();
            node3.Text = strProjectID + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            AllProjectTreeShowForPageFind_YYUP(strProjectID, node3, strDepartString);

            TreeView1.DataBind();
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            if (strOperationType == "All" | strOperationType == "Next")
            {
                strMaxProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMinProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }
            else
            {
                strMinProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMaxProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }

            return strMinProjectID + "-" + strMaxProjectID;
        }
        else
        {
            return "";
        }
    }

    public static void AllProjectTreeShowForPageFind_YYUP(string strParentID, TreeNode treeNode, string strDepartString)
    {
        string strHQL;
        IList lst1;

        string strProjectID, strProject;
        String strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived')";
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";

        strHQL += " order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + "." + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            AllProjectTreeShowForPageFind_YYUP(strProjectID, node, strDepartString);
        }
    }

    //定义所有项目文档树 FOR YYUP
    public static string InitialAllProjectDocTree_YYUP(TreeView TreeView1, string strUserCode, string strQueryCount, string strOperationType, string strMinProjectID, string strMaxProjectID)
    {
        string strHQL;
        string strProjectID, strProject, strProductLineRelated;
        string strDepartString;
        if (HttpContext.Current.Session["DepartString"] == null)
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
            HttpContext.Current.Session["DepartString"] = strDepartString;
        }
        else
        {
            strDepartString = HttpContext.Current.Session["DepartString"].ToString();
        }

        strProductLineRelated = ShareClass.GetDepartSuperUserRelatedProductLineFromUserCode(strUserCode);

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();
        TreeNode node4 = new TreeNode();

        node1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Project_0 Target=Right><B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        node1.Target = "Project" + "_" + "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        if (strOperationType == "All")
        {
            strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";

            if (strProductLineRelated == "YES")
            {
                strHQL += " and project.ProjectID in (Select project_YYUP.ProjectID From Project_YYUP as project_YYUP Where project_YYUP.ProductLine in ";
                strHQL += " (Select departSuperUserRelatedProductLine.ProductLineName From DepartSuperUserRelatedProductLine as departSuperUserRelatedProductLine Where departSuperUserRelatedProductLine.UserCode = " + "'" + strUserCode + "'" + "))";
            }

            strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
            strHQL += " Order By ProjectID DESC limit " + strQueryCount;
        }
        else
        {
            if (strOperationType == "Piror")
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";

                if (strProductLineRelated == "YES")
                {
                    strHQL += " and project.ProjectID in (Select project_YYUP.ProjectID From Project_YYUP as project_YYUP Where project_YYUP.ProductLine in ";
                    strHQL += " (Select departSuperUserRelatedProductLine.ProductLineName From DepartSuperUserRelatedProductLine as departSuperUserRelatedProductLine Where departSuperUserRelatedProductLine.UserCode = " + "'" + strUserCode + "'" + "))";
                }

                strHQL += " And ProjectID > " + strMaxProjectID;
                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID ASC limit " + strQueryCount;
            }
            else
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where  DepartCode in " + strDepartString + ")";
                strHQL += " And ProjectID < " + strMinProjectID;

                if (strProductLineRelated == "YES")
                {
                    strHQL += " and project.ProjectID in (Select project_YYUP.ProjectID From Project_YYUP as project_YYUP Where project_YYUP.ProductLine in ";
                    strHQL += " (Select departSuperUserRelatedProductLine.ProductLineName From DepartSuperUserRelatedProductLine as departSuperUserRelatedProductLine Where departSuperUserRelatedProductLine.UserCode = " + "'" + strUserCode + "'" + "))";
                }

                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID DESC limit " + strQueryCount;
            }
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds.Tables[0].Rows[i][0].ToString().Trim();
            strProject = ds.Tables[0].Rows[i][1].ToString().Trim();

            node3 = new TreeNode();
            node3.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Project_" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            //AllProjectDocTreeShowIncludeAll(strUserCode, strProjectID, node3);

            if (getChildProjectNumber(strProjectID, strDepartString) > 0)
            {
                node4 = new TreeNode();
                node4.Text = LanguageHandle.GetWord("ChildProjectTree");
                node4.Target = strProjectID + "_ChildrenProject";
                node4.Expanded = false;
                node3.ChildNodes.Add(node4);
                AllProjectDocTreeShowIncludeChild_YYUP(strProjectID, node4, strDepartString);
            }

            TreeView1.DataBind();
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            if (strOperationType == "All" | strOperationType == "Next")
            {
                strMaxProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMinProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }
            else
            {
                strMinProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMaxProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }

            return strMinProjectID + "-" + strMaxProjectID;
        }
        else
        {
            return "";
        }
    }

    public static void AllProjectDocTreeShowIncludeChild_YYUP(string strParentID, TreeNode treeNode, string strDepartString)
    {
        string strHQL;
        IList lst1, lst2;

        string strProjectID, strProject;
        String strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();

        TreeNode node4 = new TreeNode();

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived')";
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";

        strHQL += " order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Project_" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            if (getChildProjectNumber(strProjectID, strDepartString) > 0)
            {
                node4 = new TreeNode();
                node4.Text = LanguageHandle.GetWord("ChildProjectTree");
                node4.Target = strProjectID + "_ChildrenProject";
                node4.Expanded = false;
                node.ChildNodes.Add(node4);
                AllProjectDocTreeShowIncludeChild_YYUP(strProjectID, node4, strDepartString);
            }
        }
    }

    //项目文档（包含任务，流程，需求，风险等所有项目相关的文档）
    public static void AllProjectDocTreeShowIncludeAll(string strUserCode, string strProjectID, TreeNode treeNode)
    {
        string strHQL;
        IList lst;
        string strTaskID, strTaskName, strDefectID, strDefectName, strWLID, strWLName, strRiskID, strRiskName;
        int i;

        TreeNode node = new TreeNode();
        TreeNode treeNode1 = new TreeNode();

        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=ProjectPlan_0&ProjectID=" + strProjectID + " Target=Right>计划</a>";
        treeNode1.Target = "ProjectPlan" + "_" + "0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        TakeTopPlan.InitialProjectPlanTreeOnTreeNode(treeNode1, strProjectID, GetProjectPlanVersion(strProjectID, "InUse").ToString());

        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=ProjectTask_0&ProjectID=" + strProjectID + " Target=Right>任务</a>";
        treeNode1.Target = "ProjectTask_0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        strHQL = "from ProjectTask as projectTask where projectTask.ProjectID = " + strProjectID;
        strHQL += " and projectTask.TaskID in (Select document.RelatedID from Document as document where document.RelatedType = 'Task' and document.Status <> 'Deleted')";
        strHQL += " Order by projectTask.TaskID DESC";
        ProjectTaskBLL projectTaskBLL = new ProjectTaskBLL();
        lst = projectTaskBLL.GetAllProjectTasks(strHQL);
        ProjectTask projectTask = new ProjectTask();
        for (i = 0; i < lst.Count; i++)
        {
            projectTask = (ProjectTask)lst[i];
            strTaskID = projectTask.TaskID.ToString();
            strTaskName = projectTask.Task.Trim();

            node = new TreeNode();
            node.Target = "ProjectTask_" + strTaskID;
            node.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=ProjectTask_" + strTaskID + " Target=Right>" + strTaskID + ". " + strTaskName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }

        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Defect_0&ProjectID=" + strProjectID + " Target=Right>需求</a>";
        treeNode1.Target = "Defect_0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        strHQL = "from Defectment as defectment where defectment.DefectID in (select relatedDefect.DefectID from RelatedDefect as relatedDefect where relatedDefect.ProjectID = " + strProjectID + ")";
        strHQL += " and defectment.DefectID in (Select document.RelatedID from Document as document where document.RelatedType = 'Requirement' and document.Status <> 'Deleted')";
        strHQL += " Order by defectment.DefectID DESC";
        DefectmentBLL defectmentBLL = new DefectmentBLL();
        lst = defectmentBLL.GetAllDefectments(strHQL);
        Defectment defectment = new Defectment();
        for (i = 0; i < lst.Count; i++)
        {
            defectment = (Defectment)lst[i];
            strDefectID = defectment.DefectID.ToString();
            strDefectName = defectment.DefectName.Trim();

            node = new TreeNode();
            node.Target = "Defect" + "_" + strDefectID;
            node.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Defect_" + strDefectID + " Target=Right>" + strDefectID + ". " + strDefectName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }
        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=WorkFlow_0&ProjectID=" + strProjectID + " Target=Right>工作流</a>";
        treeNode1.Target = "WorkFlow_0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);

        strHQL = "from WorkFlow as workFlow where";
        strHQL += " ((workFlow.RelatedType = 'Project' and workFlow.RelatedID = " + strProjectID + ")";
        strHQL += " or (workFlow.RelatedType = 'Task' and workFlow.RelatedID in (select projectTask.TaskID from ProjectTask as projectTask where projectTask.ProjectID = " + strProjectID + "))";
        strHQL += " or (workFlow.RelatedType = '风险' and workFlow.RelatedID in (select projectRisk.ID from ProjectRisk as projectRisk where projectRisk.ProjectID = " + strProjectID + "))";
        strHQL += " or (workFlow.RelatedType = 'Requirement' and workFlow.RelatedID in (select relatedDefect from RelatedDefect as relatedDefect where relatedDefect.ProjectID = " + strProjectID + ")))";
        strHQL += " and workFlow.WLID in (Select document.RelatedID from Document as document where document.RelatedType = 'Workflow' and document.Status <> 'Deleted')";
        strHQL += " Order by workFlow.WLID DESC";
        WorkFlowBLL workFlowBLL = new WorkFlowBLL();
        lst = workFlowBLL.GetAllWorkFlows(strHQL);
        WorkFlow workFlow = new WorkFlow();
        for (i = 0; i < lst.Count; i++)
        {
            workFlow = (WorkFlow)lst[i];
            strWLID = workFlow.WLID.ToString();
            strWLName = workFlow.WLName.Trim();

            node = new TreeNode();
            node.Target = "WorkFlow" + "_" + strWLID;
            node.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=WorkFlow_" + strWLID + " Target=Right>" + strWLID + ". " + strWLName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }

        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Risk_0&ProjectID=" + strProjectID + " Target=Right>风险</a>";
        treeNode1.Target = "Risk_0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        strHQL = "From ProjectRisk as projectRisk where projectRisk.ProjectID = " + strProjectID;
        strHQL += " and projectRisk.ID in (Select document.RelatedID from Document as document where document.RelatedType = '风险' and document.Status <> 'Deleted')";
        strHQL += " Order by projectRisk.ID DESC";
        ProjectRiskBLL projectRiskBLL = new ProjectRiskBLL();
        lst = projectRiskBLL.GetAllProjectRisks(strHQL);
        ProjectRisk projectRisk = new ProjectRisk();
        for (i = 0; i < lst.Count; i++)
        {
            projectRisk = (ProjectRisk)lst[i];
            strRiskID = projectRisk.ID.ToString();
            strRiskName = projectRisk.Risk.Trim();

            node = new TreeNode();
            node.Target = "Risk" + "_" + strRiskID;
            node.Text = "<A href=TTAllProjectDocuments.aspx?TargetID=Risk_" + strRiskID + " Target=Right>" + strRiskID + ". " + strRiskName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }
    }

    //定义所有项目的项目树(关联页面链接）
    public static string InitialAllProjectRelatedPageTree(TreeView TreeView1, string strUserCode, string strRelatedType, string strQueryCount, string strOperationType, string strMinProjectID, string strMaxProjectID)
    {
        string strHQL;
        string strProjectID, strProject;
        string strDepartString;
        if (HttpContext.Current.Session["DepartString"] == null)
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
            HttpContext.Current.Session["DepartString"] = strDepartString;
        }
        else
        {
            strDepartString = HttpContext.Current.Session["DepartString"].ToString();
        }

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        if (strRelatedType == "Defect")
        {
            node1.Text = "<A href=TTProjectDefectmentManage.aspx?ProjectID=0" + " Target=Right>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }
        if (strRelatedType == "ProjectTask")
        {
            node1.Text = "<A href=TTAllProjectTask.aspx?ProjectID=0" + " Target=Right>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }
        if (strRelatedType == "ProjectDoc")
        {
            node1.Text = "<A href=TTProjectDocManage.aspx?Project_0" + " Target=Right>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }
        if (strRelatedType == "WorkFlow")
        {
            node1.Text = "<A href=TTProjectWorkFlowManage.aspx?ProjectID=0" + " Target=Right>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }

        if (strRelatedType == "ProjectRisk")
        {
            node1.Text = "<A href=TTProjectRiskManage.aspx?ProjectID=0" + " Target=Right>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }

        if (strRelatedType == "ProjectBonus")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B>";
        }

        if (strRelatedType == "ProjectExpense")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B>";
        }

        if (strRelatedType == "ProjectIncomeAndExpense")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B>";
        }

        if (strRelatedType == "InAndOut")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B>";
        }

        if (strRelatedType == "MakeBudget" | strRelatedType == "MakeBudgetAll")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("XiangMuYuSuan").ToString().Trim() + "</B>";
        }

        if (strRelatedType == "MakeItemBudget")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("XiangMuWuZiYuSuan").ToString().Trim() + "</B>";
        }

        if (strRelatedType == "BudgetReport")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + "</B>";
        }

        if (strRelatedType == "MaterialExpenseApply")
        {
            node1.Text = "<B>项目物资费用申请</B>";
        }

        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        if (strOperationType == "All")
        {
            strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode In " + strDepartString + ")";

            strHQL += " And Status not in ('Deleted','Archived') and ProjectID <> 1";
            strHQL += " Order By ProjectID DESC limit " + strQueryCount;
        }
        else
        {
            if (strOperationType == "Piror")
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode In " + strDepartString + ")";
                strHQL += " And ProjectID > " + strMaxProjectID;

                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID ASC limit " + strQueryCount;
            }
            else
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode In " + strDepartString + ")";
                strHQL += " And ProjectID < " + strMinProjectID;

                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID DESC limit " + strQueryCount + "";
            }
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds.Tables[0].Rows[i][0].ToString().Trim();
            strProject = ds.Tables[0].Rows[i][1].ToString().Trim();

            node3 = new TreeNode();

            if (strRelatedType == "ProjectDefect")
            {
                node3.Text = "<A href=TTAllProjectDefectment.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectTask")
            {
                node3.Text = "<A href=TTAllProjectTask.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectWorkFlow")
            {
                node3.Text = "<A href=TTAllProjectWorkFlow.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectRisk")
            {
                node3.Text = "<A href=TTAllProjectRisk.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectBonus")
            {
                node3.Text = "<A href=TTConfirmDailyWorkBonus.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectExpense")
            {
                node3.Text = "<A href=TTConfirmProjectExpenseForFIN.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectIncomeAndExpense")
            {
                node3.Text = "<A href=TTProjectIncomeAndExpenseReportForFIN.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "InAndOut")
            {
                node3.Text = "<A href=TTProjectIncomeExpense.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "MakeBudget")
            {
                node3.Text = "<A href=TTMakeProjectBudget.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "MakeBudgetAll")
            {
                node3.Text = "<A href=TTMakeProjectBudgetForAll.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "MakeItemBudget")
            {
                node3.Text = "<A href=TTProjectRelatedItem.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "BudgetReport")
            {
                node3.Text = "<A href=TTProjectBudgetReport.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "MaterialExpenseApply")
            {
                node3.Text = "<A href=TTProjectMaterialPaymentApplicant.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);

            AllProjectTreeRelatedPageShow(strUserCode, strRelatedType, strProjectID, node3, strDepartString);
            TreeView1.DataBind();
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            if (strOperationType == "All" | strOperationType == "Next")
            {
                strMaxProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMinProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }
            else
            {
                strMinProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMaxProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }

            return strMinProjectID + "-" + strMaxProjectID;
        }
        else
        {
            return "";
        }
    }

    public static void AllProjectTreeRelatedPageShow(string strUserCode, string strRelatedType, string strParentID, TreeNode treeNode, string strDepartString)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived') ";
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
        strHQL += " order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;

            if (strRelatedType == "Defect")
            {
                node.Text = "<A href=TTProjectDefectmentManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectTask")
            {
                node.Text = "<A href=TTProjectTaskManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "WorkFlow")
            {
                node.Text = "<A href=TTProjectWorkFlowManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectRisk")
            {
                node.Text = "<A href=TTAllProjectRisk.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectBonus")
            {
                node.Text = "<A href=TTConfirmDailyWorkBonus.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectExpense")
            {
                node.Text = "<A href=TTConfirmProjectExpenseForFIN.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectIncomeAndExpense")
            {
                node.Text = "<A href=TTProjectIncomeAndExpenseReportForFIN.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "InAndOut")
            {
                node.Text = "<A href=TTProjectIncomeExpense.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "MakeBudget")
            {
                node.Text = "<A href=TTMakeProjectBudget.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "MakeBudgetAll")
            {
                node.Text = "<A href=TTMakeProjectBudgetForAll.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "MakeItemBudget")
            {
                node.Text = "<A href=TTProjectRelatedItem.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "BudgetReport")
            {
                node.Text = "<A href=TTProjectBudgetReport.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "MaterialExpenseApply")
            {
                node.Text = "<A href=TTProjectMaterialPaymentApplicant.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID;
            strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
            strHQL += " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                AllProjectTreeRelatedPageShow(strUserCode, strRelatedType, strProjectID, node, strDepartString);
            }
        }
    }

    //定义所有项目的项目树(关联页面链接）--FOR YYUP
    public static string InitialAllProjectRelatedPageTree_YYUP(TreeView TreeView1, string strUserCode, string strRelatedType, string strQueryCount, string strOperationType, string strMinProjectID, string strMaxProjectID)
    {
        string strHQL;

        string strProjectID, strProject, strProductLineRelated;

        strProductLineRelated = ShareClass.GetDepartSuperUserRelatedProductLineFromUserCode(strUserCode);

        string strDepartString;
        if (HttpContext.Current.Session["DepartString"] == null)
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
            HttpContext.Current.Session["DepartString"] = strDepartString;
        }
        else
        {
            strDepartString = HttpContext.Current.Session["DepartString"].ToString();
        }

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        if (strRelatedType == "Defect")
        {
            node1.Text = "<A href=TTProjectDefectmentManage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }
        if (strRelatedType == "ProjectTask")
        {
            node1.Text = "<A href=TTAllProjectTask.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }
        if (strRelatedType == "ProjectDoc")
        {
            node1.Text = "<A href=TTProjectDocManage.aspx?Project_0" + " Target=Right><B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }
        if (strRelatedType == "WorkFlow")
        {
            node1.Text = "<A href=TTProjectWorkFlowManage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }

        if (strRelatedType == "ProjectRisk")
        {
            node1.Text = "<A href=TTProjectRiskManage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B></a>";
        }

        if (strRelatedType == "ProjectBonus")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B>";
        }

        if (strRelatedType == "ProjectExpense")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B>";
        }

        if (strRelatedType == "ProjectIncomeAndExpense")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B>";
        }

        if (strRelatedType == "InAndOut")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B>";
        }

        if (strRelatedType == "Budget")
        {
            node1.Text = "<B>" + LanguageHandle.GetWord("SYXMHTMDZXM").ToString().Trim() + " </B>";
        }

        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        if (strOperationType == "All")
        {
            strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode In " + strDepartString + ")";

            if (strProductLineRelated == "YES")
            {
                strHQL += " and project.ProjectID in (Select project_YYUP.ProjectID From Project_YYUP as project_YYUP Where project_YYUP.ProductLine in ";
                strHQL += " (Select departSuperUserRelatedProductLine.ProductLineName From DepartSuperUserRelatedProductLine as departSuperUserRelatedProductLine Where departSuperUserRelatedProductLine.UserCode = " + "'" + strUserCode + "'" + "))";
            }

            strHQL += " And Status not in ('Deleted','Archived') and ProjectID <> 1";
            strHQL += " Order By ProjectID DESC limit " + strQueryCount;
        }
        else
        {
            if (strOperationType == "Piror")
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode In " + strDepartString + ")";
                strHQL += " And ProjectID > " + strMaxProjectID;

                if (strProductLineRelated == "YES")
                {
                    strHQL += " and project.ProjectID in (Select project_YYUP.ProjectID From Project_YYUP as project_YYUP Where project_YYUP.ProductLine in ";
                    strHQL += " (Select departSuperUserRelatedProductLine.ProductLineName From DepartSuperUserRelatedProductLine as departSuperUserRelatedProductLine Where departSuperUserRelatedProductLine.UserCode = " + "'" + strUserCode + "'" + "))";
                }

                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID ASC limit " + strQueryCount;
            }
            else
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode In " + strDepartString + ")";
                strHQL += " And ProjectID < " + strMinProjectID;

                if (strProductLineRelated == "YES")
                {
                    strHQL += " and project.ProjectID in (Select project_YYUP.ProjectID From Project_YYUP as project_YYUP Where project_YYUP.ProductLine in ";
                    strHQL += " (Select departSuperUserRelatedProductLine.ProductLineName From DepartSuperUserRelatedProductLine as departSuperUserRelatedProductLine Where departSuperUserRelatedProductLine.UserCode = " + "'" + strUserCode + "'" + "))";
                }

                strHQL += " And Status Not in ('Deleted','Archived') and ProjectID <> 1";
                strHQL += " Order By ProjectID DESC limit " + strQueryCount;
            }
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds.Tables[0].Rows[i][0].ToString().Trim();
            strProject = ds.Tables[0].Rows[i][1].ToString().Trim();

            node3 = new TreeNode();

            if (strRelatedType == "ProjectDefect")
            {
                node3.Text = "<A href=TTAllProjectDefectment.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectTask")
            {
                node3.Text = "<A href=TTAllProjectTask.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectWorkFlow")
            {
                node3.Text = "<A href=TTAllProjectWorkFlow.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectRisk")
            {
                node3.Text = "<A href=TTAllProjectRisk.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectBonus")
            {
                node3.Text = "<A href=TTConfirmDailyWorkBonus.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectExpense")
            {
                node3.Text = "<A href=TTConfirmProjectExpenseForFIN.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectIncomeAndExpense")
            {
                node3.Text = "<A href=TTProjectIncomeAndExpenseReportForFIN.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "InAndOut")
            {
                node3.Text = "<A href=TTProjectIncomeExpense.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "Budget")
            {
                node3.Text = "<A href=TTProjectBudgetReport.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);

            AllProjectTreeRelatedPageShow_YYUP(strUserCode, strRelatedType, strProjectID, node3, strDepartString);
            TreeView1.DataBind();
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            if (strOperationType == "All" | strOperationType == "Next")
            {
                strMaxProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMinProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }
            else
            {
                strMinProjectID = ds.Tables[0].Rows[0][0].ToString();
                strMaxProjectID = ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1][0].ToString();
            }

            return strMinProjectID + "-" + strMaxProjectID;
        }
        else
        {
            return "";
        }
    }

    public static void AllProjectTreeRelatedPageShow_YYUP(string strUserCode, string strRelatedType, string strParentID, TreeNode treeNode, string strDepartString)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived') ";
        strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
        strHQL += " order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;

            if (strRelatedType == "Defect")
            {
                node.Text = "<A href=TTProjectDefectmentManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectTask")
            {
                node.Text = "<A href=TTProjectTaskManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "WorkFlow")
            {
                node.Text = "<A href=TTProjectWorkFlowManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectRisk")
            {
                node.Text = "<A href=TTAllProjectRisk.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectBonus")
            {
                node.Text = "<A href=TTConfirmDailyWorkBonus.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectExpense")
            {
                node.Text = "<A href=TTConfirmProjectExpenseForFIN.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectIncomeAndExpense")
            {
                node.Text = "<A href=TTProjectIncomeAndExpenseReportForFIN.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "InAndOut")
            {
                node.Text = "<A href=TTProjectIncomeExpense.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID;
            strHQL += " and project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
            strHQL += " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                AllProjectTreeRelatedPageShow_YYUP(strUserCode, strRelatedType, strProjectID, node, strDepartString);
            }
        }
    }

    //取得最大项目ID号
    public static int GetMaxProjectIDForAllProjectList(int intProjectID, int intProjectCount, string strDepartString)
    {
        string strHQL;

        strHQL = "Select Max(ProjectID) From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode In " + strDepartString + ")";
        strHQL += " And ProjectID <= " + intProjectID.ToString();
        strHQL += " And Status not in ('Deleted','Archived') and ProjectID <> 1";
        strHQL += " Order By ProjectID DESC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return int.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 0;
        }
    }

    //取得最小项目ID号
    public static int GetMinProjectIDForAllProjectList(string strDepartString, int intProjectCount)
    {
        string strHQL;

        strHQL = "Select Min(ProjectID) From T_Project Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode In " + strDepartString + ")";
        strHQL += " And Status not in ('Deleted','Archived') and Project.ID <> 1 Order By ProjectID DESC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return int.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 0;
        }
    }

    //定义参与项目文档树
    public static void InitialInvolvedProjectDocTree(TreeView TreeView1, string strUserCode)
    {
        string strHQL, strProjectID, strProject;
        IList lst;
        string strProjectIDString = "";

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<A href=TTProjectDocManage.aspx?TargetID=Project_0 Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        node1.Target = "Project" + "_" + "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.UserCode = " + "'" + strUserCode + "'" + " Order by proRelatedUser.ProjectID DESC";
        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        ProRelatedUser proRelatedUser = new ProRelatedUser();
        lst = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);
        for (int i = 0; i < lst.Count; i++)
        {
            proRelatedUser = (ProRelatedUser)lst[i];

            strProjectID = proRelatedUser.ProjectID.ToString(); ;
            strProject = proRelatedUser.ProjectName.Trim();

            if (strProjectIDString.IndexOf(strProjectID + ",") >= 0)
            {
                continue;
            }
            else
            {
                strProjectIDString += strProjectID + ",";
            }

            node3 = new TreeNode();
            node3.Text = "<A href=TTProjectDocManage.aspx?TargetID=Project_" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            //InvolvedProjectDocTreeShowIncludeAll(strUserCode, strProjectID, node3);
            TreeView1.DataBind();
        }
    }

    //项目文档（包含任务，需求，计划，风险等项目相关的文档）
    public static void InvolvedProjectDocTreeShowIncludeAll(string strUserCode, string strProjectID, TreeNode treeNode)
    {
        string strHQL;
        IList lst;
        string strTaskID, strTaskName, strReqID, strReqName, strDefectID, strDefectName, strWLID, strWLName, strRiskID, strRiskName;
        int i;

        TreeNode node = new TreeNode();
        TreeNode treeNode1 = new TreeNode();

        //生成计划节点
        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTProjectDocManage.aspx?TargetID=ProjectPlan_0&ProjectID=" + strProjectID + " Target=Right>计划</a>";
        treeNode1.Target = "ProjectPlan" + "_" + "0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        TakeTopPlan.InitialProjectPlanTreeOnTreeNode(treeNode1, strProjectID, GetProjectPlanVersion(strProjectID, "InUse").ToString());

        //生成任务节点
        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTProjectDocManage.aspx?TargetID=ProjectTask_0&ProjectID=" + strProjectID + " Target=Right>任务</a>";
        treeNode1.Target = "ProjectTask_0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        strHQL = "from ProjectTask as projectTask where projectTask.ProjectID = " + strProjectID + " and projectTask.PlanID = 0 ";
        strHQL += " and projectTask.TaskID in (Select document.RelatedID from Document as document where document.RelatedType = 'Task' and document.Status <> 'Deleted')";
        strHQL += " Order by projectTask.TaskID DESC";
        ProjectTaskBLL projectTaskBLL = new ProjectTaskBLL();
        lst = projectTaskBLL.GetAllProjectTasks(strHQL);
        ProjectTask projectTask = new ProjectTask();
        for (i = 0; i < lst.Count; i++)
        {
            projectTask = (ProjectTask)lst[i];
            strTaskID = projectTask.TaskID.ToString();
            strTaskName = projectTask.Task.Trim();

            node = new TreeNode();
            node.Target = "ProjectTask_" + strTaskID;
            node.Text = "<A href=TTProjectDocManage.aspx?TargetID=ProjectTask_" + strTaskID + " Target=Right>" + strTaskID + ". " + strTaskName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }

        //生成需求节点
        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTProjectDocManage.aspx?TargetID=Req_0&ProjectID=" + strProjectID + " Target=Right>需求</a>";
        treeNode1.Target = "Defect_0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        strHQL = "from Requirement as requirement where requirement.ReqID in (select relatedReq.ReqID from RelatedReq as relatedReq where relatedReq.ProjectID = " + strProjectID + ")";
        strHQL += " and requirement.ReqID in (Select document.RelatedID from Document as document where document.RelatedType = 'Requirement' and document.Status <> 'Deleted')";
        strHQL += " Order by requirement.ReqID DESC";
        RequirementBLL requirementBLL = new RequirementBLL();
        lst = requirementBLL.GetAllRequirements(strHQL);
        Requirement requirement = new Requirement();
        for (i = 0; i < lst.Count; i++)
        {
            requirement = (Requirement)lst[i];
            strReqID = requirement.ReqID.ToString();
            strReqName = requirement.ReqName.Trim();

            node = new TreeNode();
            node.Target = "Req" + "_" + strReqID;
            node.Text = "<A href=TTProjectDocManage.aspx?TargetID=Req_" + strReqID + " Target=Right>" + strReqID + ". " + strReqName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }

        //生成缺陷节点
        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTProjectDocManage.aspx?TargetID=Defect_0&ProjectID=" + strProjectID + " Target=Right>缺陷</a>";
        treeNode1.Target = "Defect_0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        strHQL = "from Defectment as defectment where defectment.DefectID in (select relatedDefect.DefectID from RelatedDefect as relatedDefect where relatedDefect.ProjectID = " + strProjectID + ")";
        strHQL += " and defectment.DefectID in (Select document.RelatedID from Document as document where document.RelatedType = 'Defect' and document.Status <> 'Deleted')";
        strHQL += " Order by defectment.DefectID DESC";
        DefectmentBLL defectmentBLL = new DefectmentBLL();
        lst = defectmentBLL.GetAllDefectments(strHQL);
        Defectment defectment = new Defectment();
        for (i = 0; i < lst.Count; i++)
        {
            defectment = (Defectment)lst[i];
            strDefectID = defectment.DefectID.ToString();
            strDefectName = defectment.DefectName.Trim();

            node = new TreeNode();
            node.Target = "Defect" + "_" + strDefectID;
            node.Text = "<A href=TTProjectDocManage.aspx?TargetID=Defect_" + strDefectID + " Target=Right>" + strDefectID + ". " + strDefectName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }

        //生成工作流节点
        strHQL = "from WorkFlow as workFlow where";
        strHQL += " ((workFlow.RelatedType = 'Project' and workFlow.RelatedID = " + strProjectID + ")";
        strHQL += " or (workFlow.RelatedType = 'Task' and workFlow.RelatedID in (select projectTask.TaskID from ProjectTask as projectTask where projectTask.ProjectID = " + strProjectID + "))";
        strHQL += " or (workFlow.RelatedType = '风险' and workFlow.RelatedID in (select projectRisk.ID from ProjectRisk as projectRisk where projectRisk.ProjectID = " + strProjectID + "))";
        strHQL += " or (workFlow.RelatedType = 'Requirement' and workFlow.RelatedID in (select relatedDefect from RelatedDefect as relatedDefect where relatedDefect.ProjectID = " + strProjectID + ")))";
        strHQL += " and workFlow.WLID in (Select document.RelatedID from Document as document where document.RelatedType = 'Workflow' and document.Status <> 'Deleted')";
        strHQL += " Order by workFlow.WLID DESC";
        WorkFlowBLL workFlowBLL = new WorkFlowBLL();
        lst = workFlowBLL.GetAllWorkFlows(strHQL);
        WorkFlow workFlow = new WorkFlow();
        for (i = 0; i < lst.Count; i++)
        {
            workFlow = (WorkFlow)lst[i];
            strWLID = workFlow.WLID.ToString();
            strWLName = workFlow.WLName.Trim();

            node = new TreeNode();
            node.Target = "WorkFlow" + "_" + strWLID;
            node.Text = "<A href=TTProjectDocManage.aspx?TargetID=WorkFlow_" + strWLID + " Target=Right>" + strWLID + ". " + strWLName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }

        //生成风险节点
        treeNode1 = new TreeNode();
        treeNode1.Text = "<A href=TTProjectDocManage.aspx?TargetID=Risk_0&ProjectID=" + strProjectID + " Target=Right>风险</a>";
        treeNode1.Target = "Risk_0";
        treeNode1.Expanded = false;
        treeNode.ChildNodes.Add(treeNode1);
        strHQL = "From ProjectRisk as projectRisk where projectRisk.ProjectID = " + strProjectID; ;
        strHQL += " and projectRisk.ID in (Select document.RelatedID from Document as document where document.RelatedType = '风险' and document.Status <> 'Deleted')";
        strHQL += " Order by projectRisk.ID DESC";
        ProjectRiskBLL projectRiskBLL = new ProjectRiskBLL();
        lst = projectRiskBLL.GetAllProjectRisks(strHQL);
        ProjectRisk projectRisk = new ProjectRisk();
        for (i = 0; i < lst.Count; i++)
        {
            projectRisk = (ProjectRisk)lst[i];
            strRiskID = projectRisk.ID.ToString();
            strRiskName = projectRisk.Risk.Trim();

            node = new TreeNode();
            node.Target = "Risk" + "_" + strRiskID;
            node.Text = "<A href=TTProjectDocManage.aspx?TargetID=Risk_" + strRiskID + " Target=Right>" + strRiskID + ". " + strRiskName + "</a>";
            treeNode1.ChildNodes.Add(node);
            node.Expanded = false;
        }
    }

    //定义参与项目的项目树(关联页面链接）
    public static void InitialInvolvedProjectRelatedPageTree(TreeView TreeView1, string strUserCode, string strRelatedType)
    {
        string strHQL, strProjectID, strProject;
        IList lst;

        string strProjectIDString = "";

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        if (strRelatedType == "Req")
        {
            node1.Text = "<A href=TTProjectReqHandlePage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }

        if (strRelatedType == "Defect")
        {
            node1.Text = "<A href=TTProjectDefectmentHandlePage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }

        if (strRelatedType == "ProjectTask")
        {
            node1.Text = "<A href=TTProjectTaskHandlePage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }

        if (strRelatedType == "ProjectTask_JYX")
        {
            node1.Text = "<A href=TTProjectTaskHandlePage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }

        if (strRelatedType == "ProjectDoc")
        {
            node1.Text = "<A href=TTProjectDocManage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }
        if (strRelatedType == "WorkFlow")
        {
            node1.Text = "<A href=TTProjectWorkFlowManage.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }
        if (strRelatedType == "InAndOut")
        {
            node1.Text = "<A href=TTProjectIncomeExpense.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }
        if (strRelatedType == "ProjectCost")
        {
            node1.Text = "<A href=TTRCJProjectTotalCostFee.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }
        if (strRelatedType == "ProjectCostCheck")
        {
            node1.Text = "<A href=TTRCJProjectFundStartPlanApproval.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }
        if (strRelatedType == "ProjectIncomeAndExpense")
        {
            node1.Text = "<A href=TTRCJProjectCost.aspx?ProjectID=0" + " Target=Right><B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B></a>";
        }

        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID not in (Select proRelatedUser1.ProjectID From ProRelatedUser as proRelatedUser1 Where  proRelatedUser1.UserCode = " + "'" + strUserCode + "'" + " ) and proRelatedUser.UserCode = " + "'" + strUserCode + "'" + "  Order by proRelatedUser.ProjectID DESC";
        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        ProRelatedUser proRelatedUser = new ProRelatedUser();

        lst = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            proRelatedUser = (ProRelatedUser)lst[i];

            strProjectID = proRelatedUser.ProjectID.ToString();
            strProject = proRelatedUser.ProjectName.Trim();

            if (strProjectIDString.IndexOf(strProjectID + ",") >= 0)
            {
                continue;
            }
            else
            {
                strProjectIDString += strProjectID + ",";
            }

            node3 = new TreeNode();

            if (strRelatedType == "Req")
            {
                node3.Text = "<A href=TTProjectReqHandlePage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "Defect")
            {
                node3.Text = "<A href=TTProjectDefectmentHandlePage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectTask")
            {
                node3.Text = "<A href=TTProjectTaskHandlePage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectTask_JYX")
            {
                node3.Text = "<A href=TTProjectTaskHandlePage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "WorkFlow")
            {
                node3.Text = "<A href=TTProjectWorkFlowManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "InAndOut")
            {
                node3.Text = "<A href=TTProjectIncomeExpense.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectCost")
            {
                node3.Text = "<A href=TTRCJProjectTotalCostFee.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }
            if (strRelatedType == "ProjectCostCheck")
            {
                node3.Text = "<A href=TTRCJProjectFundStartPlanApproval.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectIncomeAndExpense")
            {
                node3.Text = "<A href=TTRCJProjectCost.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            node3.Target = strProjectID;
            node3.Expanded = true;

            node1.ChildNodes.Add(node3);
            InvolvedProjectTreeRelatedPageShow(strUserCode, strRelatedType, strProjectID, node3, strProjectIDString);
            TreeView1.DataBind();
        }
    }

    public static void InvolvedProjectTreeRelatedPageShow(string strUserCode, string strRelatedType, string strParentID, TreeNode treeNode, string strProjectIDString)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        ProRelatedUser proRelatedUser = new ProRelatedUser();

        strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID = " + strParentID + " and proRelatedUser.UserCode = " + "'" + strUserCode + "'" + "  Order by proRelatedUser.ProjectID DESC";
        lst1 = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            proRelatedUser = (ProRelatedUser)lst1[i];
            strProjectID = proRelatedUser.ProjectID.ToString();
            strProject = proRelatedUser.ProjectName.Trim();

            if (strProjectIDString.IndexOf(strProjectID + ",") >= 0)
            {
                continue;
            }
            else
            {
                strProjectIDString += strProjectID + ",";
            }

            TreeNode node = new TreeNode();
            node.Target = strProjectID;

            if (strRelatedType == "Req")
            {
                node.Text = "<A href=TTProjectRequirementManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "Defect")
            {
                node.Text = "<A href=TTProjectDefectmentManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectTask")
            {
                node.Text = "<A href=TTProjectTaskManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectTask_JYX")
            {
                node.Text = "<A href=TTProjectTaskManage_JYX.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "WorkFlow")
            {
                node.Text = "<A href=TTProjectWorkFlowManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "InAndOut")
            {
                node.Text = "<A href=TTProjectIncomeExpense.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectCost")
            {
                node.Text = "<A href=TTRCJProjectTotalCostFee.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }
            if (strRelatedType == "ProjectCostCheck")
            {
                node.Text = "<A href=TTRCJProjectFundStartPlanApproval.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            if (strRelatedType == "ProjectIncomeAndExpense")
            {
                node.Text = "<A href=TTRCJProjectCost.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            }

            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID = " + strProjectID + "  Order by proRelatedUser.ProjectID DESC";
            lst2 = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

            if (lst2.Count > 0)
            {
                InvolvedProjectTreeRelatedPageShow(strUserCode, strRelatedType, strProjectID, node, strProjectIDString);
            }
        }
    }



    //定义参与项目的项目树
    public static void InitialInvolvedProjectTree(TreeView TreeView1, string strUserCode)
    {
        string strHQL, strProjectID, strProject;
        IList lst;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID not in (Select proRelatedUser1.ProjectID From ProRelatedUser as proRelatedUser1 Where  proRelatedUser1.UserCode = " + "'" + strUserCode + "'" + " ) and proRelatedUser.UserCode = " + "'" + strUserCode + "'" + " Order by proRelatedUser.ProjectID DESC";

        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        ProRelatedUser proRelatedUser = new ProRelatedUser();

        lst = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            proRelatedUser = (ProRelatedUser)lst[i];

            strProjectID = proRelatedUser.ProjectID.ToString(); ;
            strProject = proRelatedUser.ProjectName.Trim();

            node3 = new TreeNode();

            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            InvolvedProjectTreeShow(strUserCode, strProjectID, node3);
            TreeView1.DataBind();
        }
    }

    public static void InvolvedProjectTreeShow(string strUserCode, string strParentID, TreeNode treeNode)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        ProRelatedUser proRelatedUser = new ProRelatedUser();

        strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID = " + strParentID + " and proRelatedUser.UserCode = " + "'" + strUserCode + "'" + " order by proRelatedUser.ProjectID DESC";
        lst1 = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            proRelatedUser = (ProRelatedUser)lst1[i];
            strProjectID = proRelatedUser.ProjectID.ToString();
            strProject = proRelatedUser.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + ". " + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID = " + strProjectID + " Order by proRelatedUser.ProjectID DESC";
            lst2 = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

            if (lst2.Count > 0)
            {
                InvolvedProjectTreeShow(strUserCode, strProjectID, node);
            }
        }
    }

    //定义我主导的和我参与项目的项目树
    public static void InitialMyUnderTakeAndInvolvedProjectTree(TreeView TreeView1, string strUserCode)
    {
        string strHQL, strProjectID, strProject;
        IList lst;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("WCYDXMHTMDZXM").ToString().Trim() + "</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID not in (Select proRelatedUser1.ProjectID From ProRelatedUser as proRelatedUser1 Where  proRelatedUser1.UserCode = " + "'" + strUserCode + "'" + " ) and proRelatedUser.UserCode = " + "'" + strUserCode + "'" + " Order by proRelatedUser.ProjectID DESC";

        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        ProRelatedUser proRelatedUser = new ProRelatedUser();

        lst = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            proRelatedUser = (ProRelatedUser)lst[i];

            strProjectID = proRelatedUser.ProjectID.ToString(); ;
            strProject = proRelatedUser.ProjectName.Trim();

            node3 = new TreeNode();

            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            MyUnderTakeAndInvolvedProjectTreeShow(strUserCode, strProjectID, node3);
            TreeView1.DataBind();
        }
    }

    public static void MyUnderTakeAndInvolvedProjectTreeShow(string strUserCode, string strParentID, TreeNode treeNode)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        ProRelatedUser proRelatedUser = new ProRelatedUser();

        strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID = " + strParentID + " and proRelatedUser.UserCode = " + "'" + strUserCode + "'" + " order by proRelatedUser.ProjectID DESC";
        lst1 = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            proRelatedUser = (ProRelatedUser)lst1[i];
            strProjectID = proRelatedUser.ProjectID.ToString();
            strProject = proRelatedUser.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + ". " + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.ParentID = " + strProjectID + " Order by proRelatedUser.ProjectID DESC";
            lst2 = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

            if (lst2.Count > 0)
            {
                MyUnderTakeAndInvolvedProjectTreeShow(strUserCode, strProjectID, node);
            }
        }
    }

    //定义项目树（根据权限）
    public static void InitialPrjectTreeByAuthority(TreeView TreeView1, string strUserCode)
    {
        string strHQL, strProjectID, strProjectName;
        //string strUserCode;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>1." + LanguageHandle.GetWord("ZongXiangMu").ToString().Trim() + "</B>";
        node1.Target = "1";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = string.Format(@"Select * from T_Project as project where project.ParentID  = 1 
          and (project.PMCode = '{1}' Or project.UserCode ='{1}' or ProjectID in (Select ProjectID From T_RelatedUser Where UserCode = '{1}'))
          and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC", strUserCode, strUserCode);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds.Tables[0].Rows[i]["ProjectID"].ToString().Trim();
            strProjectName = ds.Tables[0].Rows[i]["ProjectName"].ToString().Trim();

            node3 = new TreeNode();

            node3.Text = strProjectID + "." + strProjectName;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            ProjectTreeShowByAuthority(strProjectID, node3, strUserCode);
            TreeView1.DataBind();
        }
    }

    public static void ProjectTreeShowByAuthority(string strParentID, TreeNode treeNode, string strUserCode)
    {
        string strHQL, strProjectID, strProjectName;

        strHQL = string.Format(@"Select * from T_Project as project where project.ParentID ={0} 
                  and (project.PMCode = '{1}' Or project.UserCode ='{1}' or ProjectID in (Select ProjectID From T_RelatedUser Where UserCode = '{1}'))
                  and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC", strParentID, strUserCode);
        DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
        for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
        {
            strProjectID = ds1.Tables[0].Rows[i]["ProjectID"].ToString().Trim();
            strProjectName = ds1.Tables[0].Rows[i]["ProjectName"].ToString().Trim();


            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + ". " + strProjectName;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = string.Format(@"Select * from T_Project as project where project.ParentID ={0} 
                    and (project.PMCode = '{1}' Or project.UserCode ='{1}' or ProjectID in (Select ProjectID From T_RelatedUser Where UserCode = '{1}'))
                    and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC", strProjectID, strUserCode);
            DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
            if (ds2.Tables[0].Rows.Count > 0)
            {
                ProjectTreeShowByAuthority(strProjectID, node, strUserCode);
            }
        }
    }

    //定义自己建立的项目的项目树
    public static void InitialMyCreateProjectTree(TreeView TreeView1, string strUserCode)
    {
        string strHQL, strProjectID, strProject;
        IList lst;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("WJLDXM").ToString().Trim() + "</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where project.UserCode = " + "'" + strUserCode + "'";
        strHQL += " and project.ParentID not in (select project.ProjectID from Project as project where project.UserCode = " + "'" + strUserCode + "'" + ")";
        strHQL += "  and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            node3 = new TreeNode();

            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            MyCreateProjectTreeShow(strUserCode, strProjectID, node3);
            TreeView1.DataBind();
        }
    }

    public static void MyCreateProjectTreeShow(string strUserCode, string strParentID, TreeNode treeNode)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.UserCode = " + "'" + strUserCode + "'" + " and project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + ". " + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where  project.UserCode = " + "'" + strUserCode + "'" + " and project.ParentID = " + strProjectID + " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                MyCreateProjectTreeShow(strUserCode, strProjectID, node);
            }
        }
    }

    //我负责的项目的项目树(用于项目风险管理）
    public static void InitialMyTakeOverProjectTree(TreeView TreeView1, string strUserCode)
    {
        string strHQL, strProjectID, strProject;
        IList lst;
        string strProjectIDString = "";

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<A href=TTProjectRiskManage.aspx?ProjectID=0 Target=Right>" + "<B>" + LanguageHandle.GetWord("WFZDXM").ToString().Trim() + "</B>" + "</a>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where project.PMCode = " + "'" + strUserCode + "'";
        strHQL += " and project.ParentID not in (select project.ProjectID from Project as project where project.PMCode = " + "'" + strUserCode + "'";
        strHQL += " and project.ProjectID in (select projectRisk.ProjectID from ProjectRisk as projectRisk))";
        strHQL += " and project.ProjectID in (select projectRisk.ProjectID from ProjectRisk as projectRisk) ";
        strHQL += " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            if (strProjectIDString.IndexOf(strProjectID + ",") >= 0)
            {
                continue;
            }
            else
            {
                strProjectIDString += strProjectID + ",";
            }

            node3 = new TreeNode();

            node3.Text = "<A href=TTProjectRiskManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            MyTakeoverProjectTreeShow(strUserCode, strProjectID, node3, strProjectIDString);
            TreeView1.DataBind();
        }
    }

    public static void MyTakeoverProjectTreeShow(string strPMCode, string strParentID, TreeNode treeNode, string strProjectIDString)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID;
        strHQL += "  and project.PMCode = " + "'" + strPMCode + "'";
        strHQL += " and project.ProjectID in (select projectRisk.ProjectID from ProjectRisk as projectRisk) ";
        strHQL += " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            if (strProjectIDString.IndexOf(strProjectID + ",") >= 0)
            {
                continue;
            }
            else
            {
                strProjectIDString += strProjectID + ",";
            }

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = "<A href=TTProjectRiskManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID + " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                MyTakeoverProjectTreeShow(strPMCode, strProjectID, node, strProjectIDString);
            }
        }
    }

    //我负责的项目的项目树(用于项目风险管理）
    public static void InitialAllProjectTree(TreeView TreeView1, string strUserCode, string strDepartString)
    {
        string strHQL, strProjectID, strProject;
        IList lst;
        string strProjectIDString = "";

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<A href=TTProjectRiskManage.aspx?ProjectID=0 Target=Right>" + "<B>" + LanguageHandle.GetWord("WFZDXM").ToString().Trim() + "</B>" + "</a>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where project.PMCode = " + "'" + strUserCode + "'";
        strHQL += " and project.ParentID not in (select project.ProjectID from Project as project where project.PMCode = " + "'" + strUserCode + "'";
        strHQL += " and project.ProjectID in (select projectRisk.ProjectID from ProjectRisk as projectRisk))";
        strHQL += " and project.ProjectID in (select projectRisk.ProjectID from ProjectRisk as projectRisk) ";
        strHQL += " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            if (strProjectIDString.IndexOf(strProjectID + ",") >= 0)
            {
                continue;
            }
            else
            {
                strProjectIDString += strProjectID + ",";
            }

            node3 = new TreeNode();

            node3.Text = "<A href=TTProjectRiskManage.aspx?ProjectID=" + strProjectID + " Target=Right>" + strProjectID + "." + strProject + "</a>";
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            MyTakeoverProjectTreeShow(strUserCode, strProjectID, node3, strProjectIDString);
            TreeView1.DataBind();
        }
    }

    //维护项目日志
    public static void UpdateDailyWork(string strUserCode, string strProjectID, string strRelatedType, string strRelatedID, string strRelatedName, string strWorkDetail)
    {
        string strHQL;
        IList lst;
        int intID;
        decimal deBonus;
        string strProjectType, strPMCode, strImpactByDetail;

        try
        {
            Project project = ShareClass.GetProject(strProjectID);
            strProjectType = project.ProjectType.Trim();
            strPMCode = project.PMCode.Trim();

            strImpactByDetail = ShareClass.GetProjectTypeImpactByDetail(strProjectID);

            strWorkDetail = " [" + strRelatedType + ":" + strRelatedID + "." + strRelatedName + "]WorkLog:" + strWorkDetail + " ";

            strHQL = "from DailyWork as dailyWork where dailyWork.UserCode = " + "'" + strUserCode + "'" + " and dailyWork.ProjectID = " + strProjectID + " and to_char(dailyWork.WorkDate,'yyyymmdd') = to_char(now(),'yyyymmdd')";
            DailyWorkBLL dailyWorkBLL = new DailyWorkBLL();
            lst = dailyWorkBLL.GetAllDailyWorks(strHQL);

            DailyWork dailyWork = new DailyWork();

            if (lst.Count == 0)
            {
                if (strUserCode == strPMCode)
                {
                    dailyWork.Type = "Dominant";
                }
                else
                {
                    dailyWork.Type = "Participate";
                }

                dailyWork.Charge = decimal.Parse(ShareClass.getCurrentDateTotalExpenseByOneOperator(strProjectID, strUserCode, DateTime.Now.ToString("yyyyMMdd")));
                dailyWork.ManHour = decimal.Parse(ShareClass.getCurrentDateTotalManHourByOneOperator(strProjectID, strUserCode, DateTime.Now.ToString("yyyyMMdd")));
                dailyWork.ConfirmManHour = dailyWork.ManHour;

                //更改负责的工作进度
                if (strImpactByDetail == "YES")
                {
                    dailyWork.FinishPercent = decimal.Parse(ShareClass.getCurrentDateTotalProgressForMember(strProjectID, strUserCode));
                }
                else
                {
                    dailyWork.FinishPercent = 0;
                }

                dailyWork.UserCode = strUserCode;
                dailyWork.UserName = GetUserName(strUserCode);
                dailyWork.WorkDate = DateTime.Now;
                dailyWork.ProjectID = int.Parse(strProjectID);
                dailyWork.ProjectName = ShareClass.GetProjectName(strProjectID);
                dailyWork.DailySummary = strWorkDetail;

                dailyWork.RecordTime = DateTime.Now;
                dailyWork.Address = "";
                dailyWork.Achievement = "";

                deBonus = ShareClass.GetDailyWorkLogLength(dailyWork.DailySummary) * ShareClass.GetEveryCharPrice() + ShareClass.GetDailyUploadDocNumber(strUserCode, strProjectID) * ShareClass.GetEveryDocPrice();

                dailyWork.Bonus = deBonus;
                dailyWork.ConfirmBonus = deBonus;
                dailyWork.Authority = "NO";

                try
                {
                    dailyWorkBLL.AddDailyWork(dailyWork);
                }
                catch
                {
                }
            }
            else
            {
                dailyWork = (DailyWork)lst[0];
                intID = dailyWork.WorkID;
                dailyWork.DailySummary += "<BR/>" + strWorkDetail;

                if (strUserCode == strPMCode)
                {
                    dailyWork.Type = "Dominant";
                }
                else
                {
                    dailyWork.Type = "参与";
                }

                dailyWork.Charge = decimal.Parse(ShareClass.getCurrentDateTotalExpenseByOneOperator(strProjectID, strUserCode, DateTime.Now.ToString("yyyyMMdd")));
                dailyWork.ManHour = decimal.Parse(ShareClass.getCurrentDateTotalManHourByOneOperator(strProjectID, strUserCode, DateTime.Now.ToString("yyyyMMdd")));
                dailyWork.ConfirmManHour = dailyWork.ManHour;

                //更改负责的工作进度
                if (strImpactByDetail == "YES")
                {
                    dailyWork.FinishPercent = decimal.Parse(ShareClass.getCurrentDateTotalProgressForMember(strProjectID, strUserCode));
                }

                deBonus = ShareClass.GetDailyWorkLogLength(dailyWork.DailySummary) * ShareClass.GetEveryCharPrice() + ShareClass.GetDailyUploadDocNumber(strUserCode, strProjectID) * ShareClass.GetEveryDocPrice();
                dailyWork.Bonus = deBonus;
                dailyWork.ConfirmBonus = deBonus;

                dailyWork.Authority = "NO";

                try
                {
                    dailyWorkBLL.UpdateDailyWork(dailyWork, intID);
                }
                catch
                {
                }
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //维护项目经理项目日志
    public static void UpdateDailyWorkForPM(string strProjectID, string strRelatedType, string strRelatedID, string strWorkDetail)
    {
        string strHQL;
        IList lst;
        int intID;
        decimal deBonus;
        string strProjectType, strPMCode, strImpactByDetail;

        try
        {
            Project project = ShareClass.GetProject(strProjectID);
            strProjectType = project.ProjectType.Trim();
            strPMCode = project.PMCode.Trim();

            strImpactByDetail = ShareClass.GetProjectTypeImpactByDetail(strProjectID);

            strWorkDetail = " [" + strRelatedType + ":" + strRelatedID + "]WorkLog:" + strWorkDetail + " ";

            strHQL = "from DailyWork as dailyWork where dailyWork.UserCode = " + "'" + strPMCode + "'" + " and dailyWork.ProjectID = " + strProjectID + " and to_char(dailyWork.WorkDate,'yyyymmdd') = to_char(now(),'yyyymmdd')";
            DailyWorkBLL dailyWorkBLL = new DailyWorkBLL();
            lst = dailyWorkBLL.GetAllDailyWorks(strHQL);

            DailyWork dailyWork = new DailyWork();

            if (lst.Count == 0)
            {
                dailyWork.Type = "Dominant";

                dailyWork.Charge = decimal.Parse(ShareClass.getCurrentDateTotalExpenseByOneOperator(strProjectID, strPMCode, DateTime.Now.ToString("yyyyMMdd")));
                dailyWork.ManHour = decimal.Parse(ShareClass.getCurrentDateTotalManHourByOneOperator(strProjectID, strPMCode, DateTime.Now.ToString("yyyyMMdd")));
                dailyWork.ConfirmManHour = dailyWork.ManHour;

                //更改负责的工作进度
                if (strImpactByDetail == "YES")
                {
                    dailyWork.FinishPercent = decimal.Parse(ShareClass.getCurrentDateTotalProgressForPM(strProjectID));
                }
                else
                {
                    dailyWork.FinishPercent = 0;
                }

                dailyWork.UserCode = strPMCode;
                dailyWork.UserName = GetUserName(strPMCode);
                dailyWork.WorkDate = DateTime.Now;
                dailyWork.ProjectID = int.Parse(strProjectID);
                dailyWork.ProjectName = ShareClass.GetProjectName(strProjectID);
                dailyWork.DailySummary = strWorkDetail;

                dailyWork.RecordTime = DateTime.Now;
                dailyWork.Address = "";
                dailyWork.Achievement = "";

                deBonus = ShareClass.GetDailyWorkLogLength(dailyWork.DailySummary) * ShareClass.GetEveryCharPrice() + ShareClass.GetDailyUploadDocNumber(strPMCode, strProjectID) * ShareClass.GetEveryDocPrice();

                dailyWork.Bonus = deBonus;
                dailyWork.ConfirmBonus = deBonus;
                dailyWork.Authority = "NO";

                try
                {
                    dailyWorkBLL.AddDailyWork(dailyWork);

                    //更改负责的项目总进度
                    if (strImpactByDetail == "YES")
                    {
                        UpdateProjectCompleteDegree(strProjectID, dailyWork.FinishPercent);
                    }
                }
                catch
                {
                }
            }
            else
            {
                dailyWork = (DailyWork)lst[0];
                intID = dailyWork.WorkID;
                //dailyWork.DailySummary += "<BR/>" + strWorkDetail;

                dailyWork.Type = "Dominant";

                dailyWork.Charge = decimal.Parse(ShareClass.getCurrentDateTotalExpenseByOneOperator(strProjectID, strPMCode, DateTime.Now.ToString("yyyyMMdd")));
                dailyWork.ManHour = decimal.Parse(ShareClass.getCurrentDateTotalManHourByOneOperator(strProjectID, strPMCode, DateTime.Now.ToString("yyyyMMdd")));
                dailyWork.ConfirmManHour = dailyWork.ManHour;

                //更改负责的工作进度
                if (strImpactByDetail == "YES")
                {
                    dailyWork.FinishPercent = decimal.Parse(ShareClass.getCurrentDateTotalProgressForPM(strProjectID));
                }

                deBonus = ShareClass.GetDailyWorkLogLength(dailyWork.DailySummary) * ShareClass.GetEveryCharPrice() + ShareClass.GetDailyUploadDocNumber(strPMCode, strProjectID) * ShareClass.GetEveryDocPrice();
                dailyWork.Bonus = deBonus;
                dailyWork.ConfirmBonus = deBonus;

                dailyWork.Authority = "NO";

                try
                {
                    dailyWorkBLL.UpdateDailyWork(dailyWork, intID);

                    //更改负责的项目总进度
                    if (strImpactByDetail == "YES")
                    {
                        UpdateProjectCompleteDegree(strProjectID, dailyWork.FinishPercent);
                    }
                }
                catch
                {
                }
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    public static void UpdateProjectCompleteDegree(string strProjectID, decimal deFinishPercent)
    {
        string strHQL;
        IList lst;

        strHQL = "from Project as project where project = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        lst = projectBLL.GetAllProjects(strHQL);
        Project project = (Project)lst[0];
        project.FinishPercent = deFinishPercent;

        try
        {
            projectBLL.UpdateProject(project, int.Parse(strProjectID));
        }
        catch
        {
        }
    }

    //定义依部门职称员工KPI考核树
    public static void InitialKPICheckTreeByDepartPosition(TreeView TreeView1, String strDepartCode, string strPosition)
    {
        string strHQL1, strHQL2;
        IList lst1, lst2;

        string strDepartName;
        string strUserCode, strUserName;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node2 = new TreeNode();
        TreeNode node3 = new TreeNode();

        strDepartName = ShareClass.GetDepartName(strDepartCode);
        node1.Text = "<B>" + strDepartCode + " " + strDepartName + " KPI</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        if (strPosition == "")
        {
            strHQL1 = "From ProjectMember as projectMember Where projectMember.DepartCode = " + "'" + strDepartCode + "'";
            strHQL1 += " Order By projectMember.SortNumber ASC";
        }
        else
        {
            strHQL1 = "From ProjectMember as projectMember Where projectMember.DepartCode = " + "'" + strDepartCode + "'";
            strHQL1 += " And projectMember.JobTitle = " + "'" + strPosition + "'";
            strHQL1 += " Order By projectMember.SortNumber ASC";
        }
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        lst1 = projectMemberBLL.GetAllProjectMembers(strHQL1);

        for (int i = 0; i < lst1.Count; i++)
        {
            ProjectMember projectMember = (ProjectMember)lst1[i];

            strUserCode = projectMember.UserCode.Trim();
            strUserName = projectMember.UserName.Trim();

            node2 = new TreeNode();
            node2.Text = strUserName + "[" + projectMember.JobTitle + "]";
            node2.Target = strUserCode;
            node2.Expanded = false;

            node1.ChildNodes.Add(node2);

            strHQL2 = "from UserKPICheck as userKPICheck where userKPICheck.UserCode = " + "'" + strUserCode + "'";
            strHQL2 += " Order By userKPICheck.StartTime DESC";
            UserKPICheckBLL userKPICheckBLL = new UserKPICheckBLL();
            lst2 = userKPICheckBLL.GetAllUserKPIChecks(strHQL2);

            UserKPICheck userKPICheck = new UserKPICheck();

            for (int j = 0; j < lst2.Count; j++)
            {
                userKPICheck = (UserKPICheck)lst2[j];

                node3 = new TreeNode();
                node3.Text = userKPICheck.KPICheckName.Trim();
                node3.Target = userKPICheck.KPICheckID.ToString();
                node3.Expanded = false;

                node2.ChildNodes.Add(node3);
            }
        }

        TreeView1.DataBind();
    }

    //定义员工KPI考核树
    public static void InitialKPICheckTreeByUserCode(TreeView TreeView1, String strUserCode)
    {
        string strHQL1;
        IList lst1;

        string strUserName;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node2 = new TreeNode();
        TreeNode node3 = new TreeNode();

        strUserName = ShareClass.GetUserName(strUserCode);

        node1.Text = "<B>" + strUserName + " KPI</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL1 = "from UserKPICheck as userKPICheck where userKPICheck.UserCode = " + "'" + strUserCode + "'";
        strHQL1 += " Order By userKPICheck.StartTime DESC";
        UserKPICheckBLL userKPICheckBLL = new UserKPICheckBLL();
        lst1 = userKPICheckBLL.GetAllUserKPIChecks(strHQL1);

        UserKPICheck userKPICheck = new UserKPICheck();

        for (int i = 0; i < lst1.Count; i++)
        {
            userKPICheck = (UserKPICheck)lst1[i];

            node2 = new TreeNode();
            node2.Text = userKPICheck.KPICheckName.Trim();
            node2.Target = userKPICheck.KPICheckID.ToString();
            node2.Expanded = false;

            node1.ChildNodes.Add(node2);
        }

        TreeView1.DataBind();
    }

    //定义员工KPI考核树
    public static void InitialKPICheckTreeByDepartCode(TreeView TreeView1, String strDepartCode, string strDepartString)
    {
        string strHQL1;
        IList lst1;

        string strDepartName;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node2 = new TreeNode();
        TreeNode node3 = new TreeNode();

        strDepartName = ShareClass.GetDepartName(strDepartCode);

        node1.Text = "<B>" + strDepartName + " KPI</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL1 = "from UserKPICheck as userKPICheck where userKPICheck.UserCode in ( Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
        strHQL1 += " Order By userKPICheck.StartTime DESC";
        UserKPICheckBLL userKPICheckBLL = new UserKPICheckBLL();
        lst1 = userKPICheckBLL.GetAllUserKPIChecks(strHQL1);

        UserKPICheck userKPICheck = new UserKPICheck();

        for (int i = 0; i < lst1.Count; i++)
        {
            userKPICheck = (UserKPICheck)lst1[i];

            node2 = new TreeNode();
            node2.Text = userKPICheck.KPICheckName.Trim();
            node2.Target = userKPICheck.KPICheckID.ToString();
            node2.Expanded = false;

            node1.ChildNodes.Add(node2);
        }

        TreeView1.DataBind();
    }

    //定义项目成员树
    public static void InitialProjectMemberTree(TreeView TreeView, string strProjectID)
    {
        string strHQL;
        IList lst;

        int i, j;

        DataSet ds;

        string strActor, strUserCode, strUserName, strID, strPMCode, strPMName, strUserType;

        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        ProRelatedUser proRelatedUser = new ProRelatedUser();
        RelatedUser relatedUser = new RelatedUser();

        //添加根节点
        TreeView.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node2 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("XMTD").ToString().Trim() + "</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView.Nodes.Add(node1);

        strHQL = "from Project as project where project.ProjectID = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        lst = projectBLL.GetAllProjects(strHQL);
        Project project = (Project)lst[0];
        strPMCode = project.PMCode.Trim();
        strPMName = project.PMName.Trim();

        node2 = new TreeNode();
        node2.Text = "[" + LanguageHandle.GetWord("XiangMuJingLi").ToString().Trim() + "]";
        node2.Target = LanguageHandle.GetWord("XiangMuJingLi").ToString().Trim();
        node2.Expanded = true;
        node1.ChildNodes.Add(node2);

        strHQL = "from RelatedUser as relatedUser where relatedUser.ProjectID = " + strProjectID + " and relatedUser.UserCode = " + "'" + strPMCode + "'";
        RelatedUserBLL relatedUserBLL = new RelatedUserBLL();
        lst = relatedUserBLL.GetAllRelatedUsers(strHQL);
        if (lst.Count > 0)
        {
            relatedUser = (RelatedUser)lst[0];
            strID = relatedUser.ID.ToString();
            node3 = new TreeNode();
            node3.Text = "<B>" + strPMCode + " " + strPMName + "</B>";
            node3.Target = strID;
            node2.ChildNodes.Add(node3);
        }

        strHQL = "select distinct Actor from T_RelatedUser where ProjectID = " + strProjectID + " and UserCode <> " + "'" + strPMCode + "'";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");
        for (i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strActor = ds.Tables[0].Rows[i][0].ToString().Trim();

            node2 = new TreeNode();

            node2.Text = "[" + strActor + "]";
            node2.Target = strActor;
            node2.Expanded = true;

            strHQL = "from ProRelatedUser as proRelatedUser Where proRelatedUser.ProjectID = " + "'" + strProjectID + "'" + "   and proRelatedUser.Actor = " + "'" + strActor + "'";
            proRelatedUserBLL = new ProRelatedUserBLL();
            lst = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

            for (j = 0; j < lst.Count; j++)
            {
                proRelatedUser = (ProRelatedUser)lst[j];
                strUserCode = proRelatedUser.UserCode.Trim();
                strUserName = proRelatedUser.UserName.Trim();
                strUserType = ShareClass.GetUserType(strUserCode);

                //if (strUserType == "")
                //{
                strID = proRelatedUser.ID.ToString();

                node3 = new TreeNode();

                if (strUserType == "OUTER")
                {
                    node3.Text = "<font color='red'>" + strUserCode + " " + strUserName + "</font>";
                }
                else
                {
                    node3.Text = strUserCode + " " + strUserName;
                }
                node3.Target = strID;
                node2.ChildNodes.Add(node3);
                //}
            }

            node1.ChildNodes.Add(node2);
        }

        node1.Expand();
        TreeView.DataBind();
    }

    //定义项目委员管理的项目树（根据项目委员会）
    public static void InitialPrjectTreeByAuthorityProjectLeader(TreeView TreeView1, string strUserCode, string strDepartString)
    {
        string strHQL, strProjectID, strProject;
        IList lst;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>1." + LanguageHandle.GetWord("ZongXiangMu").ToString().Trim() + "</B>";
        node1.Target = "1";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Project as project where (project.PMCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + ")";
        strHQL += " Or project.UserCode in (Select projectMember.UserCode From ProjectMember as projectMember Where projectMember.DepartCode in " + strDepartString + "))";
        strHQL += " and project.ParentID  = 1";
        strHQL += " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        lst = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            project = (Project)lst[i];

            strProjectID = project.ProjectID.ToString(); ;
            strProject = project.ProjectName.Trim();

            node3 = new TreeNode();

            node3.Text = strProjectID + "." + strProject;
            node3.Target = strProjectID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            ProjectTreeShowByAuthorityProjectLeader(strProjectID, node3);
            TreeView1.DataBind();
        }
    }

    public static void ProjectTreeShowByAuthorityProjectLeader(string strParentID, TreeNode treeNode)
    {
        string strHQL, strProjectID, strProject;
        IList lst1, lst2;

        ProjectBLL projectBLL = new ProjectBLL();
        Project project = new Project();

        strHQL = "from Project as project where project.ParentID = " + strParentID + " and project.Status not in ('Deleted','Archived') order by project.ProjectID DESC";
        lst1 = projectBLL.GetAllProjects(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            project = (Project)lst1[i];
            strProjectID = project.ProjectID.ToString();
            strProject = project.ProjectName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strProjectID;
            node.Text = strProjectID + ". " + strProject;
            treeNode.ChildNodes.Add(node);
            node.Expanded = false;

            strHQL = "from Project as project where project.ParentID = " + strProjectID + " Order by project.ProjectID DESC";
            lst2 = projectBLL.GetAllProjects(strHQL);

            if (lst2.Count > 0)
            {
                ProjectTreeShowByAuthorityProjectLeader(strProjectID, node);
            }
        }
    }

    //定义人个计划树
    public static void InitialPlanTreeByUserCode(TreeView TreeView1, String strUserCode, string strRelatedType)
    {
        string strHQL;
        IList lst;

        string strUserName;

        strUserName = ShareClass.GetUserName(strUserCode);

        string strPlanID, strPlanName, strBackupPlanID;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + strUserName + " " + LanguageHandle.GetWord("Plan").ToString().Trim() + "</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Plan as plan where  plan.UserCode = " + "'" + strUserCode + "'";
        strHQL += " and plan.ParentID not in (Select plan.BackupPlanID From Plan as plan Where plan.UserCode = " + "'" + strUserCode + "'" + ")";
        strHQL += " and plan.Status not in ('Deleted','Archived') ";
        if (strRelatedType != "OTHER")
        {
            strHQL += " and plan.RelatedType = " + "'" + strRelatedType + "'";
        }
        strHQL += " Order By plan.StartTime DESC,plan.EndTime ASC";
        PlanBLL planBLL = new PlanBLL();
        Plan plan = new Plan();

        lst = planBLL.GetAllPlans(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            plan = (Plan)lst[i];

            strPlanID = plan.PlanID.ToString(); ;
            strPlanName = plan.PlanName.Trim();
            strBackupPlanID = plan.BackupPlanID.ToString();

            node3 = new TreeNode();

            node3.Text = strPlanName;
            node3.Target = strPlanID;
            node3.Expanded = false;

            node1.ChildNodes.Add(node3);
            PlanTreeShowByUserCode(strUserCode, strBackupPlanID, node3, strRelatedType);
            TreeView1.DataBind();
        }
    }

    //定义人个计划树
    public static void InitialPlanTreeByUserCode(TreeView TreeView1, String strUserCode, String strRelatedType, String strRelatedID, String strRelatedCode)
    {
        string strHQL;
        IList lst;

        string strPlanID, strBackupPlanID, strPlanName;
        string strUserName;

        strUserName = ShareClass.GetUserName(strUserCode);

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        if (strRelatedType != "OTHER")
        {
            node1.Text = "<B>" + strUserName + ":" + " " + LanguageHandle.GetWord("Plan").ToString().Trim() + "</B>";
        }
        else
        {
            node1.Text = "<B>" + strUserName + " " + LanguageHandle.GetWord("Plan").ToString().Trim() + "</B>";
        }
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from Plan as plan where plan.UserCode = " + "'" + strUserCode + "'";
        strHQL += " and ((plan.ParentID not in (Select plan1.BackupPlanID From Plan as plan1 Where plan1.UserCode = " + "'" + strUserCode + "'" + "))";
        strHQL += " or (plan.ParentID = 0))";
        //strHQL += " and plan.ParentID = 0";
        strHQL += " and plan.Status not in ('Deleted','Archived') ";

        if (strRelatedType != "OTHER")
        {
            strHQL += " and plan.RelatedType = " + "'" + strRelatedType + "'";
        }

        if (strRelatedID != "0")
        {
            strHQL += " and plan.RelatedID = " + strRelatedID;
        }

        if (!string.IsNullOrEmpty(strRelatedCode))
        {
            strHQL += " and plan.RelatedCode  = '" + strRelatedCode + "'";
        }

        strHQL += " Order By plan.StartTime DESC,plan.EndTime ASC";
        PlanBLL planBLL = new PlanBLL();
        Plan plan = new Plan();

        lst = planBLL.GetAllPlans(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            plan = (Plan)lst[i];

            strPlanID = plan.PlanID.ToString();
            strPlanName = plan.PlanName.Trim();

            strBackupPlanID = plan.BackupPlanID.ToString();

            node3 = new TreeNode();

            node3.Text = strPlanName;
            node3.Target = strPlanID;
            node3.Expanded = true;

            node1.ChildNodes.Add(node3);
            PlanTreeShowByUserCode(strUserCode, strBackupPlanID, node3, strRelatedType);
            TreeView1.DataBind();
        }
    }

    public static void PlanTreeShowByUserCode(string strUserCode, string strParentID, TreeNode treeNode, string strRelatedType)
    {
        string strHQL, strPlanID, strBackupPlanID, strPlanName;
        IList lst1, lst2;

        PlanBLL planBLL = new PlanBLL();
        Plan plan = new Plan();

        strHQL = "from Plan as plan where UserCode = " + "'" + strUserCode + "'" + " and plan.ParentID = " + strParentID;
        if (strRelatedType != "OTHER")
        {
            strHQL += " and plan.RelatedType = " + "'" + strRelatedType + "'";
        }
        strHQL += " Order By plan.StartTime DESC,plan.EndTime ASC";
        lst1 = planBLL.GetAllPlans(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            plan = (Plan)lst1[i];

            strPlanID = plan.PlanID.ToString();
            strBackupPlanID = plan.BackupPlanID.ToString();

            strPlanName = plan.PlanName.Trim();

            TreeNode node = new TreeNode();
            node.Target = strPlanID;
            node.Text = strPlanName;
            treeNode.ChildNodes.Add(node);
            node.Expanded = true;

            strHQL = "from Plan as plan where UserCode = " + "'" + strUserCode + "'" + " and plan.ParentID = " + strParentID;
            strHQL += " Order By plan.StartTime DESC,plan.EndTime ASC";
            lst2 = planBLL.GetAllPlans(strHQL);

            if (lst2.Count > 0)
            {
                PlanTreeShowByUserCode(strUserCode, strBackupPlanID, node, strRelatedType);
            }
        }
    }

    //定义KPI库树
    public static void InitialKPITree(TreeView TreeView1)
    {
        string strHQL;
        IList lst;

        string strKPIType;

        //添加根节点
        TreeView1.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node2 = new TreeNode();

        node1.Text = "<B>" + "KPI " + LanguageHandle.GetWord("MuBanKu").ToString().Trim() + "</B>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "from KPIType as kpiType ";
        strHQL += " Order By kpiType.SortNumber ASC";
        KPITypeBLL kpiTypeBLL = new KPITypeBLL();
        KPIType kpiType = new KPIType();

        lst = kpiTypeBLL.GetAllKPITypes(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            kpiType = (KPIType)lst[i];

            strKPIType = kpiType.Type;

            node2 = new TreeNode();

            node2.Text = strKPIType;
            node2.Target = strKPIType;
            node2.Expanded = false;

            node1.ChildNodes.Add(node2);
            KPITreeShow(strKPIType, node2);
            TreeView1.DataBind();
        }
    }

    public static void KPITreeShow(string strKPIType, TreeNode treeNode)
    {
        string strHQL;
        IList lst1;

        string strKPIID, strKPI;
        int intSortNumber;

        KPILibraryBLL kpiLibraryBLL = new KPILibraryBLL();
        KPILibrary kpiLibrary = new KPILibrary();

        strHQL = "from KPILibrary as kpiLibrary where kpiLibrary.KPIType = " + "'" + strKPIType + "'" + " Order By kpiLibrary.ID ASC";
        lst1 = kpiLibraryBLL.GetAllKPILibrarys(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            kpiLibrary = (KPILibrary)lst1[i];

            strKPIID = kpiLibrary.ID.ToString();
            strKPI = kpiLibrary.KPI.Trim();
            intSortNumber = kpiLibrary.SortNumber;

            TreeNode node = new TreeNode();
            node.Target = strKPIID;
            node.Text = intSortNumber.ToString() + ". " + strKPI;
            treeNode.ChildNodes.Add(node);
            node.Expanded = true;
        }
    }

    #endregion 定义各种业务树

}
