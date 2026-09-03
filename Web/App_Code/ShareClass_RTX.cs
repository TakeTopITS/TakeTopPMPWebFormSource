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
/// ShareClass partial - RTX
/// </summary>
public static partial class ShareClass
{
    
    #region RTX操作方法

    //添加用户给RTX,简单方法
    public static bool AddRTXUser(string strUser, string strDepart)
    {
        string strHQL;
        IList lst;

        string strServerIP;
        string strServerPort;
        string strWebSite;

        RTXSAPILib.RTXSAPIRootObj RootObj;  //声明一个根对象

        strHQL = "From RTXConfig as rtxConfig";
        RTXConfigBLL rtxConfigBLL = new RTXConfigBLL();
        lst = rtxConfigBLL.GetAllRTXConfigs(strHQL);

        RTXConfig rtxConfig = new RTXConfig();

        for (int i = 0; i < lst.Count; i++)
        {
            rtxConfig = (RTXConfig)lst[i];

            strServerIP = rtxConfig.ServerIP.Trim();
            strServerPort = rtxConfig.ServerPort.ToString();
            strWebSite = rtxConfig.WebSite.Trim();

            if (strServerIP == "" | strServerPort == "")
            {
                return false;
            }

            RootObj = new RTXSAPIRootObj();     //创建根对象
            RootObj.ServerIP = strServerIP; //设置服务器IP
            RootObj.ServerPort = Convert.ToInt16(strServerPort); //设置服务器端口

            //发送信息
            try
            {
                RootObj.UserManager.AddUser(strUser, 0);
                RootObj.DeptManager.AddUserToDept(strUser, null, strDepart, false);

                return true;
            }
            catch
            {
                return false;
            }
        }

        return true;
    }

    //删除用户RTX，简单方法
    public static bool DeleteRTXUser(string strUser)
    {
        string strHQL;
        IList lst;

        string strServerIP;
        string strServerPort;
        string strWebSite;

        RTXSAPILib.RTXSAPIRootObj RootObj;  //声明一个根对象

        strHQL = "From RTXConfig as rtxConfig";
        RTXConfigBLL rtxConfigBLL = new RTXConfigBLL();
        lst = rtxConfigBLL.GetAllRTXConfigs(strHQL);

        RTXConfig rtxConfig = new RTXConfig();

        for (int i = 0; i < lst.Count; i++)
        {
            rtxConfig = (RTXConfig)lst[i];

            strServerIP = rtxConfig.ServerIP.Trim();
            strServerPort = rtxConfig.ServerPort.ToString();
            strWebSite = rtxConfig.WebSite.Trim();

            if (strServerIP == "" | strServerPort == "")
            {
                return false;
            }

            RootObj = new RTXSAPIRootObj();     //创建根对象
            RootObj.ServerIP = strServerIP; //设置服务器IP
            RootObj.ServerPort = Convert.ToInt16(strServerPort); //设置服务器端口

            //发送信息
            try
            {
                RootObj.UserManager.DeleteUser(strUser);
                return true;
            }
            catch
            {
                return false;
            }
        }

        return true;
    }

    //添加部门给RTX,简单方法
    public static bool AddRTXDepartment(string strDepart, string strParentDepart)
    {
        string strHQL;
        IList lst;

        string strServerIP;
        string strServerPort;
        string strWebSite;

        RTXSAPILib.RTXSAPIRootObj RootObj;  //声明一个根对象

        strHQL = "From RTXConfig as rtxConfig";
        RTXConfigBLL rtxConfigBLL = new RTXConfigBLL();
        lst = rtxConfigBLL.GetAllRTXConfigs(strHQL);

        RTXConfig rtxConfig = new RTXConfig();

        for (int i = 0; i < lst.Count; i++)
        {
            rtxConfig = (RTXConfig)lst[i];

            strServerIP = rtxConfig.ServerIP.Trim();
            strServerPort = rtxConfig.ServerPort.ToString();
            strWebSite = rtxConfig.WebSite.Trim();

            if (strServerIP == "" | strServerPort == "")
            {
                return false;
            }

            RootObj = new RTXSAPIRootObj();     //创建根对象
            RootObj.ServerIP = strServerIP; //设置服务器IP
            RootObj.ServerPort = Convert.ToInt16(strServerPort); //设置服务器端口

            //发送信息
            try
            {
                RootObj.DeptManager.AddDept(strDepart, strParentDepart);

                return true;
            }
            catch
            {
                return false;
            }
        }

        return true;
    }

    //删除RTX部门，简单方法
    public static bool DeleteRTXDepartment(string strDepart)
    {
        string strHQL;
        IList lst;

        string strServerIP;
        string strServerPort;
        string strWebSite;

        RTXSAPILib.RTXSAPIRootObj RootObj;  //声明一个根对象

        strHQL = "From RTXConfig as rtxConfig";
        RTXConfigBLL rtxConfigBLL = new RTXConfigBLL();
        lst = rtxConfigBLL.GetAllRTXConfigs(strHQL);

        RTXConfig rtxConfig = new RTXConfig();

        for (int i = 0; i < lst.Count; i++)
        {
            rtxConfig = (RTXConfig)lst[i];

            strServerIP = rtxConfig.ServerIP.Trim();
            strServerPort = rtxConfig.ServerPort.ToString();
            strWebSite = rtxConfig.WebSite.Trim();

            if (strServerIP == "" | strServerPort == "")
            {
                return false;
            }

            RootObj = new RTXSAPIRootObj();     //创建根对象
            RootObj.ServerIP = strServerIP; //设置服务器IP
            RootObj.ServerPort = Convert.ToInt16(strServerPort); //设置服务器端口

            //发送信息
            try
            {
                RootObj.DeptManager.DelDept(strDepart, true);
                return true;
            }
            catch
            {
                return false;
            }
        }

        return true;
    }

    public static bool RTXADDDEPT(int Pdeptid, string Deptid, string name, string info)//添加部门
    {
        //作用:添加部门
        //参数说明:Pdeptid:所属部门()上级部门的ID
        //deptid:增加的该部门的ID
        //name:该增加部门的名称
        //info:该增加部门的相关信息

        try
        {
            RTXObjectClass RTXObj = new RTXObjectClass();
            RTXCollectionClass RTXParams = new RTXCollectionClass();
            RTXObj.Name = "USERMANAGER";
            RTXParams.Add("PDEPTID", Pdeptid);
            RTXParams.Add("DEPTID", Deptid);
            RTXParams.Add("NAME", name);
            RTXParams.Add("INFO", info);
            Object iStatus = new Object();
            iStatus = RTXObj.Call2(RTXServerApi.enumCommand_.PRO_ADDDEPT, RTXParams);

            return true;
        }
        catch
        {
            return false;
        }
    }

    public static bool RTXDelDEPT(string dpmtid, string delall)//删除部门
    {
        //作用:删除部门
        //参数说明:
        //dpmtid:要删除部门的ID号
        //delall:删除部门的下属部门的选择(0为不删除,为删除)
        try
        {
            RTXObjectClass RTXObj = new RTXObjectClass();
            RTXCollectionClass RTXParams = new RTXCollectionClass();
            RTXObj.Name = "USERMANAGER";
            RTXParams.Add("DEPTID", dpmtid);
            RTXParams.Add("COMPLETEDELBS", delall);
            Object iStatus = new Object();
            iStatus = RTXObj.Call2(RTXServerApi.enumCommand_.PRO_DELDEPT, RTXParams);

            return true;
        }
        catch
        {
            return false;
        }
    }

    public static bool RTXADDUSER(string Dpmid, string Nick, string pwd, string name, string rtxnumber, string mobile)//添加用户
    {
        //作用:添加用户
        //参数说明:
        //Dpmid:用户所属于的ID号
        //Nick:用户的登陆名
        //pwd:用户的登陆密码
        //name:用户名
        //rtxnumber:用户的RTX号码
        //mobile:用户的手机号码
        try
        {
            RTXObjectClass RTXObj = new RTXObjectClass();
            RTXCollectionClass RTXParams = new RTXCollectionClass();
            RTXObj.Name = "USERMANAGER";
            RTXParams.Add("DEPTID", Dpmid);
            RTXParams.Add("NICK", Nick);
            RTXParams.Add("PWD", pwd);
            RTXParams.Add("NAME", name);
            RTXParams.Add("UIN", rtxnumber);
            RTXParams.Add("MOBILE", mobile);
            Object iStatus = new Object();
            iStatus = RTXObj.Call2(RTXServerApi.enumCommand_.PRO_ADDUSER, RTXParams);

            return true;
        }
        catch
        {
            return false;
        }
    }

    public static bool RTXDelUSR(string unick)//删除用户
    {
        //作用:删除用户
        //参数说明:unick:用户的登陆名或用户的RTX号码都可
        try
        {
            RTXObjectClass RTXObj = new RTXObjectClass();
            RTXCollectionClass RTXParams = new RTXCollectionClass();
            RTXObj.Name = "USERMANAGER";
            RTXParams.Add("USERNAME", unick);
            Object iStatus = new Object();
            iStatus = RTXObj.Call2(RTXServerApi.enumCommand_.PRO_DELUSER, RTXParams);
            return true;
        }
        catch
        {
            return false;
        }
    }

    #endregion RTX操作方法

    #region 邮件操作方法

    //发送信息和邮件
    public static void SendInstantMessage(string strSubject, string strMsg, string strSentUserCode, string strReciverUserCode)
    {
        Msg msg = new Msg();
        try
        {
            msg.SendMSM(strSubject, strReciverUserCode, strMsg, strSentUserCode);
        }
        catch
        {
        }

        //try
        //{
        //    msg.SendMail(strReciverUserCode, strSubject, strMsg, strSentUserCode);
        //}
        //catch
        //{
        //}
    }

    //接收邮件方法
    public static void ReceiveMail(string POP3Server, string strUserCode, string strLoginName, string strPassword, int intPort, string strDocSavePath)
    {
        string file1, file2;
        Stream decodedDataStream;
        IMail imail = new Mail();
        int nMailID;
        int n = 0;
        int intMailContain = 0;
        int intMailAttachmentContain = 0;

        Folder folder = new Folder();

        POP3_Client _POP3Client = new POP3_Client();
        Mail_Message mime;

        //POP3_ClientMessage message;
        try
        {
            _POP3Client.Connect(POP3Server, intPort);
            _POP3Client.Authenticate(strLoginName, strPassword, true);

            var q = (from POP3_ClientMessage x in _POP3Client.Messages select x).OrderBy(x => -x.SequenceNumber);
            foreach (POP3_ClientMessage message in q)//倒序对于新邮件比较快
            {
                try
                {
                    mime = Mail_Message.ParseFromByte(message.HeaderToByte());
                }
                catch
                {
                    continue;
                }

                try
                {
                    ///保存收取邮件的附件
                    mime = Mail_Message.ParseFromByte(message.MessageToByte());

                    if (mime.BodyHtmlText != null)
                    {
                        intMailContain = mime.BodyHtmlText.Length;

                        nMailID = imail.SaveAsMail(mime.Subject, mime.BodyHtmlText, mime.From.ToString(), mime.To.ToString(), mime.Cc == null ? "" : mime.Cc.ToString(), 1,
                        intMailContain, mime.Attachments.Length > 0 ? 1 : 0, 0, folder.GetFolderID("New", strUserCode), strUserCode);
                    }
                    else
                    {
                        if (mime.BodyText != null)
                        {
                            intMailContain = mime.BodyText.Length;

                            nMailID = imail.SaveAsMail(mime.Subject, mime.BodyText, mime.From.ToString().Trim(), mime.To.ToString(), mime.Cc == null ? "" : mime.Cc.ToString(), 1,
                            intMailContain, mime.Attachments.Length > 0 ? 1 : 0, 0, folder.GetFolderID("New", strUserCode), strUserCode);
                        }
                        else
                        {
                            intMailContain = 0;

                            nMailID = imail.SaveAsMail(mime.Subject, "--Null--", mime.From.ToString().Trim(), mime.To.ToString(), mime.Cc == null ? "" : mime.Cc.ToString(), 1,
                            intMailContain, mime.Attachments.Length > 0 ? 1 : 0, 0, folder.GetFolderID("New", strUserCode), strUserCode);
                        }
                    }

                    //收取邮件
                    if (nMailID > 0)
                    {
                        for (n = 0; n < mime.Attachments.Length; n++)
                        {
                            ///添加单个附件
                            ///
                            try
                            {
                                //下面是接收附件的方法
                                decodedDataStream = ((MIME_b_SinglepartBase)mime.Attachments[n].Body).GetDataStream();
                                file1 = mime.Attachments[n].ContentType.Param_Name;

                                file1 = Path.GetFileNameWithoutExtension(file1) + DateTime.Now.ToString("MMss") + n.ToString() + Path.GetExtension(file1);

                                file2 = strDocSavePath + "\\" + strUserCode + "\\MailAttachments\\" + file1;
                                using (FileStream fs = File.Create(file2))
                                {
                                    LumiSoft.Net.Net_Utils.StreamCopy(decodedDataStream, fs, 4000);
                                    intMailAttachmentContain = int.Parse(fs.Length.ToString());
                                }

                                ///保存收取邮件的附件
                                imail.SaveAsMailAttachment(
                                    file1,
                                    "Doc\\" + DateTime.Now.ToString("yyyyMM") + "\\" + strUserCode + "\\MailAttachments\\" + file1,
                                    mime.Attachments[n].ContentType.Name,
                                    intMailAttachmentContain,
                                    nMailID);
                            }
                            catch
                            {
                            }
                        }
                    }

                    //删除已收取的邮件
                    message.MarkForDeletion();
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                }

                _POP3Client.Disconnect();
                _POP3Client.Dispose();
                _POP3Client = null;
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //发送邮件方法（无附件，内部成员间相互发送）
    public static bool SendMail(string strUserCode, string strSubject, string strBody, string strSendUserCode)
    {
        int nContain = 0;
        string strHQL;
        IList lst;

        string strTo;
        int nMailID;

        Folder folder = new Folder();

        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        if (lst.Count == 0)
            return false;

        ProjectMember projectMember = (ProjectMember)lst[0];

        if (projectMember.EMail == null)
            return false;

        strTo = projectMember.EMail.Trim();

        if (strTo == "")
            return false;

        strHQL = "from MailProfile as mailProfile where mailProfile.UserCode = " + "'" + strSendUserCode + "'";
        MailProfileBLL mailProfileBLL = new MailProfileBLL();
        lst = mailProfileBLL.GetAllMailProfiles(strHQL);

        if (lst.Count == 0)
            return false;

        MailProfile mailProfile = (MailProfile)lst[0];

        if (mailProfile.Email == null)
            return false;

        ///添加发件人地址
        string strFrom = mailProfile.Email.Trim();

        if (strFrom == "")
            return false;

        MailMessage mailMsg = new MailMessage();

        mailMsg.From = new MailAddress(strFrom, mailProfile.UserName.Trim());
        mailMsg.To.Add(strTo);
        nContain += strTo.Length;

        mailMsg.CC.Add(strTo);
        nContain += strTo.Length;

        ///添加邮件主题
        mailMsg.Subject = strSubject;
        nContain += strSubject.Length;

        ///添加邮件内容
        mailMsg.Body = strBody;
        mailMsg.BodyEncoding = Encoding.UTF8;
        mailMsg.IsBodyHtml = true;

        nContain += strBody.Length;

        //nContain += 100;

        try
        {
            //mailMsg.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", "1");
            ////用户名
            //mailMsg.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendusername", mailProfile.AliasName.Trim());
            ////密码
            //mailMsg.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendpassword", mailProfile.Password.Trim());

            IMail mail = new Mail();
            SmtpClient smtpClient = new SmtpClient(mailProfile.SmtpServerIP, mailProfile.SmtpServerPort);
            smtpClient.UseDefaultCredentials = false;
            smtpClient.Credentials = new NetworkCredential(mailProfile.AliasName.Trim(), mailProfile.Password.Trim());
          
            smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;

            try
            {
                //发送邮件
                smtpClient.Send(mailMsg);

                nMailID = mail.SaveAsMail(mailMsg.Subject, mailMsg.Body, strFrom,
                    strTo, strTo, 1,
                    nContain, mailMsg.Attachments.Count > 0 ? 1 : 0, 1, folder.GetFolderID("Send", strUserCode), strSendUserCode);

                return true;
            }
            catch
            {
                nMailID = mail.SaveAsMail(mailMsg.Subject, mailMsg.Body, strFrom,
                    strTo, strTo, 1,
                    nContain, mailMsg.Attachments.Count > 0 ? 1 : 0, 1, folder.GetFolderID("Waiting", strUserCode), strSendUserCode);

                return false;
            }
        }
        catch
        {
            return false;
        }
    }

    #endregion 邮件操作方法

}
