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
/// ShareClass partial - HR
/// </summary>
public static partial class ShareClass
{
    
    #region 员工档案操作

    /// <summary>
    /// 判断输入的密码是否是字母与数字的结合 By LiuJianping 2013-09-03
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public static bool IsPassword(string str)
    {
        //字母，数字，非字母字符(例如 !、$、#、%) ^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])|(?=.*[A-Z])(?=.*[a-z])(?=.*[^A-Za-z0-9])|(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])|(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])).{8,}
        System.Text.RegularExpressions.Regex reg
            = new System.Text.RegularExpressions.Regex("^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])|(?=.*[A-Z])(?=.*[0-9])|(?=.*[a-z])(?=.*[0-9])).{8,}");
        return reg.IsMatch(str);
    }

    //密码加密函数
    public static string EncryptPassword(string strPassword, string strFormat)
    {
        string strNewPassword;

        if (strFormat == "SHA1")
        {
            strNewPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(strPassword, "SHA1");
        }
        else
        {
            strNewPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(strPassword, "MD5");

        }

        return strNewPassword;
    }

    /// <summary>
    ///  散列加密
    /// </summary>
    public static string EncryptPasswordShal(string strPlaintext)
    {
        byte[] srcBuffer = System.Text.Encoding.UTF8.GetBytes(strPlaintext);

        System.Security.Cryptography.HashAlgorithm hash = System.Security.Cryptography.HashAlgorithm.Create("SHA1"); //将参数换成“MD5”，则执行 MD5 加密。不区分大小写。
        byte[] destBuffer = hash.ComputeHash(srcBuffer);

        string strHashedText = BitConverter.ToString(destBuffer).Replace("-", "");
        return strHashedText.ToLower();
    }

    //判断用户是否还在存在人事档案
    public static bool CheckUserIsExist(string strUserCode)
    {
        string strHQL;

        strHQL = "Select * From T_ProjectMember Where UserCode = '" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //判断用户是否还在存在人事档案
    public static bool CheckUserIsExistByUserCodeAndName(string strUserCode, string strUserName)
    {
        string strHQL;

        strHQL = string.Format(@"Select * From T_ProjectMember Where UserCode = '{0}' and UserName ='{1}'", strUserCode, strUserName);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public static string DepartmentStringByAuthoritySuperUserForGroup(string strParentCode, string strUserCode)
    {
        string strHQL;

        DataSet ds1, ds2;

        string strDepartCode, strDepartName;
        string strDepartString = "";

        strHQL = "Select DepartCode,DepartName From T_Department Where ParentCode = " + "'" + strParentCode + "'";
        strHQL += " and ((Authority = 'All')";
        strHQL += " or ((Authority = 'Part') ";
        strHQL += " and (DepartCode in (select DepartCode from T_DepartmentUser where UserCode =" + "'" + strUserCode + "'" + "))))";
        strHQL += " Order By DepartCode ASC";

        ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_Department");

        for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
        {
            strDepartCode = ds1.Tables[0].Rows[i][0].ToString();
            strDepartName = ds1.Tables[0].Rows[i][1].ToString();

            if (strDepartString.IndexOf("'" + strDepartCode + "'" + ",") < 0)
            {
                strDepartString += "'" + strDepartCode + "'" + ",";

                strHQL = "Select DepartCode,DepartName From T_Department Where ParentCode = " + "'" + strDepartCode + "'";
                ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_Department");

                if (ds2.Tables[0].Rows.Count > 0)
                {
                    strDepartString += DepartmentStringByAuthoritySuperUserForGroup(strDepartCode, strUserCode);
                }
            }
        }

        return strDepartString;
    }

    public static bool VerifyUserCode(string strUserCode, String strDepartString)
    {
        string strHQL;
        IList lst;

        strHQL = " from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        strHQL += " and projectMember.DepartCode in " + strDepartString;
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        if (lst.Count == 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public static bool VerifyUserName(string strUserName, string strDepartString)
    {
        string strHQL;
        IList lst;

        strHQL = " from ProjectMember as projectMember where projectMember.UserName = " + "'" + strUserName + "'";
        strHQL += " and projectMember.DepartCode in " + strDepartString;
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        if (lst.Count == 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public static decimal UpdateKPICheckDetailTotalPoint(string strKPICheckID)
    {
        string strHQL1, strHQL2, strHQL3, strHQL4;
        string strID;
        decimal deSelfCheckWeight = 0, deLeaderCheckWeight = 0, deThirdPartCheckWeight = 0, deSqlCheckWeight = 0, deHRCheckWeight = 0;
        decimal deDetailTotalPoint = 0, deTotalPoint = 0, deWeight = 0;
        DataSet ds;

        strHQL1 = "Select SelfCheckWeight,LeaderCheckWeight,ThirdPartCheckWeight,SqlCheckWeight,HRCheckWeight From T_KPICheckTypeWeight";
        ds = ShareClass.GetDataSetFromSql(strHQL1, "T_KPICheckTypeWeight");

        if (ds.Tables[0].Rows.Count > 0)
        {
            deSelfCheckWeight = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            deLeaderCheckWeight = decimal.Parse(ds.Tables[0].Rows[0][1].ToString());
            deThirdPartCheckWeight = decimal.Parse(ds.Tables[0].Rows[0][2].ToString());
            deSqlCheckWeight = decimal.Parse(ds.Tables[0].Rows[0][3].ToString());
            deHRCheckWeight = decimal.Parse(ds.Tables[0].Rows[0][4].ToString());
        }

        strHQL2 = "Select ID,(SelfPoint*" + deSelfCheckWeight.ToString() + "+LeaderPoint*" + deLeaderCheckWeight.ToString() + "+ThirdPartPoint*" + deThirdPartCheckWeight + "+SqlPoint*" + deSqlCheckWeight + "+HRPoint*" + deHRCheckWeight + ") as TotalDetailPoint,Weight From T_UserKPICheckDetail Where KPICheckID = " + strKPICheckID;
        ds = ShareClass.GetDataSetFromSql(strHQL2, "T_UserKPICheck");
        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strID = ds.Tables[0].Rows[i][0].ToString().Trim();
            deDetailTotalPoint = decimal.Parse(ds.Tables[0].Rows[i][1].ToString());
            deWeight = decimal.Parse(ds.Tables[0].Rows[i][2].ToString());

            strHQL3 = "Update T_UserKPICheckDetail Set Point = " + deDetailTotalPoint.ToString() + " Where ID = " + strID;
            ShareClass.RunSqlCommand(strHQL3);

            deTotalPoint += deDetailTotalPoint * deWeight;
        }

        strHQL4 = " Update T_UserKPICheck Set TotalPoint = " + deTotalPoint.ToString() + " Where KPICheckID = " + strKPICheckID;
        ShareClass.RunSqlCommand(strHQL4);

        return deTotalPoint;
    }

    //取得此员工当年的此类型的请假天数
    public static string GetTotalLeaveDayNumberInCurrentYear(string strLeaveType, string strApplicantCode, string strLeaveTime)
    {
        string strHQL;

        strHQL = "Select COALESCE(sum(DayNum),0) From T_LeaveApplyForm Where SUBSTRING(to_char(StartTime, 'yyyymmdd'), 1, 4) = '" + strLeaveTime.Substring(0, 4) + "'";
        strHQL += " And LeaveType = '" + strLeaveType + "'";
        strHQL += " And Creator = '" + strApplicantCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_LeaveApplyForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得此员工当月的此类型的请假天数
    public static string GetTotalLeaveDayNumberInCurrentMonth(string strLeaveType, string strApplicantCode, string strLeaveTime)
    {
        string strHQL;

        strHQL = "Select COALESCE(sum(DayNum),0) From T_LeaveApplyForm Where SUBSTRING (to_char( StartTime, 'yyyymmdd'), 1, 6)= '" + strLeaveTime.Substring(0, 6) + "'";
        strHQL += " And LeaveType = '" + strLeaveType + "'";
        strHQL += " And Creator = '" + strApplicantCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_LeaveApplyForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得此员工当年的所有类型的请假天数
    public static string GetTotalAllLeaveDayNumberInCurrentYear(string strLeaveType, string strApplicantCode, string strLeaveTime)
    {
        string strHQL;

        strHQL = "Select COALESCE(sum(DayNum),0) From T_LeaveApplyForm Where SUBSTRING(to_char( StartTime, 'yyyymmdd'), 1, 4) = '" + strLeaveTime.Substring(0, 4) + "'";
        strHQL += " And Creator = '" + strApplicantCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_LeaveApplyForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得此员工当月的所有类型的请假天数
    public static string GetTotalAllLeaveDayNumberInCurrentMonth(string strLeaveType, string strApplicantCode, string strLeaveTime)
    {
        string strHQL;

        strHQL = "Select COALESCE(sum(DayNum),0) From T_LeaveApplyForm Where SUBSTRING (to_char( StartTime, 'yyyymmdd'), 1, 6)= '" + strLeaveTime.Substring(0, 6) + "'";
        strHQL += " And Creator = '" + strApplicantCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_LeaveApplyForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得此员工当年的此类型的请假天数
    public static string GetTotalOvertimeDayNumberInCurrentYear(string strOvertimeType, string strApplicantCode, string strOvertimeTime)
    {
        string strHQL;

        strHQL = "Select COALESCE(sum(DayNum),0) From T_OvertimeApplyForm Where SUBSTRING(to_char( StartTime, 'yyyymmdd'), 1, 4) = '" + strOvertimeTime.Substring(0, 4) + "'";
        strHQL += " And OvertimeType = '" + strOvertimeType + "'";
        strHQL += " And Creator = '" + strApplicantCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_OvertimeApplyForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得此员工当月的此类型的请假天数
    public static string GetTotalOvertimeDayNumberInCurrentMonth(string strOvertimeType, string strApplicantCode, string strOvertimeTime)
    {
        string strHQL;

        strHQL = "Select COALESCE(sum(DayNum),0) From T_OvertimeApplyForm Where SUBSTRING (to_char( StartTime, 'yyyymmdd'), 1, 6)= '" + strOvertimeTime.Substring(0, 6) + "'";
        strHQL += " And OvertimeType = '" + strOvertimeType + "'";
        strHQL += " And Creator = '" + strApplicantCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_OvertimeApplyForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得此员工当年的所有类型的请假天数
    public static string GetTotalAllOvertimeDayNumberInCurrentYear(string strOvertimeType, string strApplicantCode, string strOvertimeTime)
    {
        string strHQL;

        strHQL = "Select COALESCE(sum(DayNum),0) From T_OvertimeApplyForm Where SUBSTRING(to_char( StartTime, 'yyyymmdd'), 1, 4) = '" + strOvertimeTime.Substring(0, 4) + "'";
        strHQL += " And Creator = '" + strApplicantCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_OvertimeApplyForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得此员工当月的所有类型的请假天数
    public static string GetTotalAllOvertimeDayNumberInCurrentMonth(string strOvertimeType, string strApplicantCode, string strOvertimeTime)
    {
        string strHQL;

        strHQL = "Select COALESCE(sum(DayNum),0) From T_OvertimeApplyForm Where SUBSTRING (to_char( StartTime, 'yyyymmdd'), 1, 6)= '" + strOvertimeTime.Substring(0, 6) + "'";
        strHQL += " And Creator = '" + strApplicantCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_OvertimeApplyForm");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //计算KPI的系统评分
    public static decimal CalculateSystemPoint(string strKPICheckID)
    {
        string strHQL1, strHQL2;
        IList lst1, lst2;

        string strSql1, strKPIUserCode, strStatus;

        string strKPICheckStartDate, strKPICheckEndDate;
        decimal deSystemPoint, deUnitSqlPoint;
        int intID;

        strHQL1 = "From UserKPICheck as userKPICheck Where KPICheckID = " + strKPICheckID;
        UserKPICheckBLL userKPICheckBLL = new UserKPICheckBLL();
        lst1 = userKPICheckBLL.GetAllUserKPIChecks(strHQL1);

        UserKPICheck userKPICheck = (UserKPICheck)lst1[0];

        strStatus = userKPICheck.Status.Trim();

        if (strStatus == "Closed")
        {
            return userKPICheck.TotalSqlPoint;
        }

        strKPICheckStartDate = userKPICheck.StartTime.ToString("yyyyMMdd");
        strKPICheckEndDate = userKPICheck.EndTime.ToString("yyyyMMdd");
        strKPIUserCode = userKPICheck.UserCode.Trim();


        strHQL2 = "From UserKPICheckDetail as userKPICheckDetail Where userKPICheckDetail.KPICheckID = " + strKPICheckID;
        UserKPICheckDetailBLL userKPICheckDetailBLL = new UserKPICheckDetailBLL();
        lst2 = userKPICheckDetailBLL.GetAllUserKPICheckDetails(strHQL2);

        UserKPICheckDetail userKPICheckDetail = new UserKPICheckDetail();

        DataSet ds = new DataSet();

        for (int i = 0; i < lst2.Count; i++)
        {
            userKPICheckDetail = (UserKPICheckDetail)lst2[i];

            deUnitSqlPoint = userKPICheckDetail.UnitSqlPoint;
            strSql1 = userKPICheckDetail.SqlCode.Trim();
            strSql1 = strSql1.Replace("[TAKETOPKPISTARTTIME]", strKPICheckStartDate).Replace("[TAKETOPKPIENDTIME]", strKPICheckEndDate).Replace("[TAKETOPKPIUSERCODE]", strKPIUserCode);

            try
            {
                ds = ShareClass.GetDataSetFromSql(strSql1, "T_SystemPoint");

                deSystemPoint = decimal.Parse(ds.Tables[0].Rows[0][0].ToString()) * deUnitSqlPoint;
            }
            catch
            {
                deSystemPoint = 0;
            }

            intID = userKPICheckDetail.ID;

            userKPICheckDetail.SqlPoint = 100 + deSystemPoint;

            try
            {
                userKPICheckDetailBLL.UpdateUserKPICheckDetail(userKPICheckDetail, intID);
            }
            catch
            {
            }
        }

        if (lst2.Count > 0)
        {
            return UpdateSystemKPICheckPoint(strKPICheckID);
        }
        else
        {
            return 100;
        }
    }

    public static decimal UpdateSystemKPICheckPoint(string strKPICheckID)
    {
        string strHQL;
        string strTotalSqlPoint;

        DataSet ds;

        strHQL = "Select Sum(SqlPoint * Weight) From T_UserKPICheckDetail Where KPICheckID = " + strKPICheckID;
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_UserKPICheckDetail");
        strTotalSqlPoint = ds.Tables[0].Rows[0][0].ToString();

        if (strTotalSqlPoint == "")
        {
            strTotalSqlPoint = "0";
        }

        strHQL = "Update T_UserKPICheck Set TotalSqlPoint = " + strTotalSqlPoint + " where KPICheckID = " + strKPICheckID;
        ShareClass.RunSqlCommand(strHQL);

        return decimal.Parse(strTotalSqlPoint);
    }

    #endregion 员工档案操作

}
