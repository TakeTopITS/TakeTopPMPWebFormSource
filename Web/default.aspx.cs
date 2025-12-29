
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;

using ProjectMgt.BLL;
using ProjectMgt.Model;

using TakeTopSecurity;

public partial class _default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strDevelopStatus = "NO";
        if (strDevelopStatus == "YES")
        {
            // 开发模式代码...
        }
        else
        {
            string strVerificationCode, strSMSVerification, strIsOEMVersion, strProductType, strLangCode;
            string strUserHostAddress = Request.UserHostAddress;

            this.Title = System.Configuration.ConfigurationManager.AppSettings["SystemName"] + " " + ShareClass.SystemVersionID + "---" + System.Configuration.ConfigurationManager.AppSettings["Slogon"];
            LB_SystemName.Text = System.Configuration.ConfigurationManager.AppSettings["SystemName"];

            string strTargetLagCode;
            strTargetLagCode = Request.QueryString["TargetLangCode"];
            Session["TargetLangCode"] = strTargetLagCode;
            if (Session["TargetLangCode"] == null)
            {
                Session["LangCode"] = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            }
            else
            {
                Session["LangCode"] = Session["TargetLangCode"];
            }

            if (Page.IsPostBack != true)
            {
                //if (ShareClass.SystemDBer == "")
                //{
                //    ClientScript.RegisterStartupScript(this.GetType(), "1", "<script>displayBTLogin('NONE');</script>");
                //    ClientScript.RegisterStartupScript(this.GetType(), "2", "<script>displayLBMessage('BLOCK');</script>");

                //    //等待15000毫秒
                //    System.Threading.Thread.Sleep(15000);

                //    ClientScript.RegisterStartupScript(this.GetType(), "3", "<script>location.reload();</script>");
                //}

                HL_UserID.Visible = true;
                HL_UserID.NavigateUrl = System.Configuration.ConfigurationManager.AppSettings["WebSiteValue"];
                HL_UserID.Text = System.Configuration.ConfigurationManager.AppSettings["WebSite"];
                LB_Slogon.Text = System.Configuration.ConfigurationManager.AppSettings["Slogon"];

                strVerificationCode = System.Configuration.ConfigurationManager.AppSettings["VerificationCode"].Trim().ToUpper();
                if (strVerificationCode == "NO")
                {
                    pCheckCode.Visible = false;
                    LB_Verification.Visible = false;
                    TB_CheckCode.Visible = false;
                    TB_CheckCode.Text = "*********";
                    IM_CheckCode.Visible = false;
                }
                else
                {
                    strSMSVerification = System.Configuration.ConfigurationManager.AppSettings["SMSVerification"].Trim().ToUpper();
                    if (strSMSVerification == "YES")
                    {
                        IB_GetSMS.Visible = true;
                        IM_CheckCode.Visible = false;
                    }
                    else
                    {
                        if (ShareClass.IsMobileDeviceCheckAgent())
                        {
                            TB_CheckCode.Visible = false;
                            TB_CheckCode.Text = "********";
                        }
                        else
                        {
                            // 动态设置验证码图片URL，确保每次都是新请求
                            IM_CheckCode.ImageUrl = "TTCheckCode.aspx?t=" + DateTime.Now.Ticks;
                        }
                    }
                }

                LB_Copyright.Text = "<a href=TTVersionRegister.aspx>Copyright TakeTopITS Group</a> 2006-2036 " + "<a href=https://www.taketopits.com>www.taketopits.com</a>";

                try
                {
                    strLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
                    strProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];

                    if (strProductType == "SAAS" && strLangCode == "zh-CN")
                    {
                        Response.Redirect("Logo/indexSAAS_CN.html");
                    }
                    if (strProductType == "SAAS" && strLangCode.IndexOf("zh-CN") < 0)
                    {
                        Response.Redirect("Logo/indexSAAS_EN.html");
                    }

                    if (strProductType == "SERVERSAAS" && strLangCode == "zh-CN")
                    {
                        Response.Redirect("Logo/indexXMB_CN.html");
                    }
                    if (strProductType == "SERVERSAAS" && strLangCode.IndexOf("zh-CN") < 0)
                    {
                        Response.Redirect("Logo/indexXMB_EN.html");
                    }

                    strIsOEMVersion = System.Configuration.ConfigurationManager.AppSettings["IsOEMVersion"];
                    if (strIsOEMVersion == "YES")
                    {
                        LB_Copyright.Visible = true;
                        LB_Copyright.Text = "<a href=TTVersionRegister.aspx>Copyright 2006-2036 all rights is reserved to the copyright owner</a>";
                    }
                    else
                    {
                        LB_Copyright.Visible = true;
                    }

                    if (ShareClass.IsMobileDeviceCheckAgent())
                    {
                        Response.Redirect("~/DefaultMobile.aspx", false);
                    }
                }
                catch
                {
                }

                try
                {
                    ShareClass.LoadLanguageForDropList(ddlLangSwitcher);

                    if (Request.Cookies["LangCode"] != null)
                    {
                        ddlLangSwitcher.SelectedValue = Request.Cookies["LangCode"].Value;
                    }

                    if (Session["LangCode"] != null)
                    {
                        ddlLangSwitcher.SelectedValue = Session["LangCode"].ToString();
                    }

                    InitializeCulture();
                }
                catch (Exception err)
                {
                    Session["LangCode"] = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
                    LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                }


                try
                {
                    //运行更新字段值代码
                    DatabaseUpdateHandle.RunUpdateColumnValueCode();

                    //运行模组名称英文化代码
                    DatabaseUpdateHandle.RunUpdateModuleNameCode();
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                }
            }
        }
    }

    protected void LB_Login_Click(object sender, EventArgs e)
    {
        string strUserCode, strUserName, strPassword;
        string strUserType, strMDIStyle, strMDIPageName, strMDIMobilePageName, strThirdPartPageNme, strThirdPartMobilePageName;
        string strVerificationCode, strSMSVerification;
        string strUserHostAddress, strAllowDevice;

        string strHQL;

        strUserHostAddress = Request.UserHostAddress;
        strUserCode = TB_UserCode.Text.Trim().ToUpper();
        strPassword = TB_Password.Text.Trim();
        if (strUserCode == "" | strPassword == "")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZYHMHMMDBNWKJC").ToString().Trim() + "');</script>");
            return;
        }

        if (ShareClass.SqlFilter(strUserCode) | ShareClass.SqlFilter(strPassword))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZZHHYFFZHDLSB").ToString().Trim() + "');</script>");
            return;
        }

        strSMSVerification = System.Configuration.ConfigurationManager.AppSettings["SMSVerification"].Trim().ToUpper();
        strVerificationCode = System.Configuration.ConfigurationManager.AppSettings["VerificationCode"].Trim().ToUpper();
        if (strVerificationCode == "YES")
        {
            if (!ShareClass.IsMobileDeviceCheckAgent())
            {
                if (Session["CheckCode"] == null)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZNDLSZYBJYCOOKIESNBXSZLYXSYCOOKIESXHCNSYBXT").ToString().Trim() + "');</script>");
                    TB_CheckCode.Text = "";
                    return;
                }

                if (String.Compare(Session["CheckCode"].ToString(), TB_CheckCode.Text, true) != 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZYZMCWSRZDYZM").ToString().Trim() + "');</script>");
                    TB_CheckCode.Text = "";
                    Session["CheckCode"] = null; // 校验后立即失效
                    return;
                }
                Session["CheckCode"] = null; // 校验后立即失效
            }
        }



        // 登录验证逻辑保持不变...
        try
        {
            strPassword = ShareClass.EncryptPassword(strPassword, "MD5");
            strHQL = "Select * from T_ProjectMember where UserCode = " + "'" + strUserCode + "'" + " and Password = " + "'" + strPassword + "'" + " and " + " rtrim(ltrim(Status)) not in ( 'Stop','Resign')";
            strHQL += " And UserCode in (Select UserCode From T_SystemActiveUser Where WebUser = 'YES')";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
            if (ds.Tables[0].Rows.Count > 0)
            {
                // 登录成功逻辑...
                strUserName = ds.Tables[0].Rows[0]["UserName"].ToString().Trim();
                strUserType = ds.Tables[0].Rows[0]["UserType"].ToString().Trim();
                strAllowDevice = ds.Tables[0].Rows[0]["AllowDevice"].ToString().Trim();

                strMDIStyle = ds.Tables[0].Rows[0]["MDIStyle"].ToString().Trim();
                DataSet dsMDIStyle = ShareClass.GetSystemMDIStyle(strMDIStyle);
                if (dsMDIStyle != null)
                {
                    strMDIPageName = dsMDIStyle.Tables[0].Rows[0]["PageName"].ToString().Trim();
                    strMDIMobilePageName = dsMDIStyle.Tables[0].Rows[0]["MobilePageName"].ToString().Trim();
                    strThirdPartPageNme = dsMDIStyle.Tables[0].Rows[0]["ThirdPartPageName"].ToString().Trim();
                    strThirdPartMobilePageName = dsMDIStyle.Tables[0].Rows[0]["ThirdPartMobilePageName"].ToString().Trim();
                }
                else
                {
                    strMDIPageName = "TakeTopLRExMDI.html";
                    strMDIMobilePageName = "TakeTopLRExMDI.html";
                    strThirdPartPageNme = "TakeTopCSMDI.html";
                    strThirdPartMobilePageName = "TakeTopCSMDI.html";
                }

                Session["UserCode"] = strUserCode;
                Session["UserName"] = strUserName;
                Session["UserType"] = strUserType;
                Session["IsMobileDevice"] = "NO";
                Session["SystemType"] = "WEB";

                try
                {
                    Session["LeftBarExtend"] = ds.Tables[0].Rows[0]["LeftBarExtend"].ToString().Trim();
                }
                catch
                {
                    Session["LeftBarExtend"] = "NO";
                }

                Session["CssDirectory"] = ds.Tables[0].Rows[0]["CssDirectory"].ToString().Trim();
                Session["CssDirectoryChangeNumber"] = ds.Tables[0].Rows[0]["CssDirectoryChangeNumber"].ToString().Trim();

                try
                {
                    try
                    {
                        Session["LangCode"] = ds.Tables[0].Rows[0]["LangCode"].ToString().Trim();
                    }
                    catch
                    {
                    }

                    if (Session["LangCode"] == null)
                    {
                        try
                        {
                            Session["LangCode"] = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
                        }
                        catch
                        {
                            Session["LangCode"] = "zh-CN";
                        }
                    }

                    Session["SkinFlag"] = ds.Tables[0].Rows[0]["CssDirectory"].ToString().Trim() + Session["LangCode"].ToString();

                    InitializeCulture();
                }
                catch
                {
                }

                // 其他会话设置逻辑...
                try
                {
                    Session["MustInFrame"] = System.Configuration.ConfigurationManager.AppSettings["MustInFrame"];
                }
                catch
                {
                }
                if (Session["MustInFrame"] == null)
                {
                    Session["MustInFrame"] = "YES";
                }

                try
                {
                    Session["AutoSaveWFOperator"] = System.Configuration.ConfigurationManager.AppSettings["AutoSaveWFOperator"];
                }
                catch
                {
                }
                if (Session["AutoSaveWFOperator"] == null)
                {
                    Session["AutoSaveWFOperator"] = "YES";
                }

                //---判断用户能用来登录的设备类型----------------------
                if (strAllowDevice != "ALL")
                {
                    if (ShareClass.IsMobileDeviceCheckAgent())
                    {
                        if (strAllowDevice == "PC")
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGNBNYYDSBDLPTJC").ToString().Trim() + "');</script>");
                            return;
                        }
                    }
                    else
                    {
                        if (strAllowDevice == "MOBILE")
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGNZNYYDSBDLPTJC").ToString().Trim() + "');</script>");
                            return;
                        }
                    }
                }

                //检查注册码是否合法
                string strServerName = System.Configuration.ConfigurationManager.AppSettings["ServerName"];
                try
                {
                    TakeTopLicense license = new TakeTopLicense();

                    Session["SystemVersionType"] = license.GetVerType(strServerName);
                    Session["ForbitModule"] = license.GetForbitModuleString(strServerName);
                }
                catch
                {
                    Session["SystemVersionType"] = "GROUP";
                    Session["ForbitModule"] = "NONE";
                }

                Session["SystemVersionType"] = "GROUP";
                Session["ForbitModule"] = "NONE";
                if (System.Configuration.ConfigurationManager.AppSettings["ProductType"].IndexOf("SAAS") > -1)
                {
                    Session["SystemVersionType"] = "SAAS";
                }

                try
                {
                    if (Session["CssDirectoryChangeNumber"].ToString() != "2" & Session["CssDirectoryChangeNumber"].ToString() != "0")
                    {
                        //设置缓存更改标志
                        ShareClass.SetPageCacheMark("2");
                    }

                    //插入登录日志
                    ShareClass.InsertUserLogonLog(strUserCode, strUserName, "WEB");
                }
                catch
                {
                }

                //运行一些特殊的代码
                ShareClass.RunSpecificalCodeForLogin();

                //预加载模组流程图数据集
                ShareClass.PreLoadModuleFlowChartDataSet();

                if (strUserType != "OUTER")
                {
                    Session["IsMobileDevice"] = "NO";
                    Response.Redirect(strMDIPageName, false);
                }
                else
                {
                    Session["IsMobileDevice"] = "NO";
                    Response.Redirect(strThirdPartPageNme, false);
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGYHDMHMMCWHYBZZSY").ToString().Trim() + "');</script>");
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    protected void LB_WeChatQRCode_Click(object sender, EventArgs e)
    {
        //logoImg.Src = "Logo/TakeTopXMB.png";
    }

    protected string GetModulePageName(string strModuleName)
    {
        string strHQL;

        strHQL = "select PageName from T_ProModuleLevel  where ModuleName = " + "'" + strModuleName + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    protected void LB_Register_Click(object sender, EventArgs e)
    {
        Response.Redirect("TTDisplayErrors.aspx");
    }

    protected void IB_GetSMS_Click(object sender, ImageClickEventArgs e)
    {
        string strUserCode, strPassword, strSMSCode, strMsg;
        int intCount;

        strUserCode = TB_UserCode.Text.Trim();
        strPassword = TB_Password.Text.Trim();

        strPassword = ShareClass.EncryptPassword(strPassword, "MD5");

        intCount = GetUserCount(strUserCode, strPassword);

        Msg msg = new Msg();

        if (intCount > 0)
        {
            strSMSCode = msg.CreateRandomCode(5);

            strMsg = LanguageHandle.GetWord("DuanXinYanZhengMa") + ":" + strSMSCode + "," + LanguageHandle.GetWord("DangTianYouXiao");

            if (msg.SendMSM("Message", strUserCode, strMsg, strUserCode))
            {
                InsertOrUpdateSMSCode(strUserCode, strSMSCode);

                ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZDXYZMYFSCS").ToString().Trim() + "');</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGDXYZMFSSBJCDXJKHWLLJ").ToString().Trim() + "');</script>");
            }
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGYHDMHMMCWBNDDXMJC").ToString().Trim() + "');</script>");
        }
    }

    protected void ddlLangSwitcher_SelectedIndexChanged(object sender, EventArgs e)
    {
        string selectedValue = ddlLangSwitcher.SelectedValue;

        if (!string.IsNullOrEmpty(selectedValue))
        {
            // 只在 Session 中设置，不在这里调用 InitializeCulture()
            Session["LangCode"] = selectedValue;
        
            // 重定向到带参数的页面
            // 新页面加载时会处理 URL 参数并调用自己的 InitializeCulture()
            Response.Redirect("Default.aspx?TargetLangCode=" + selectedValue, false);
        }
    }

    protected override void InitializeCulture()
    {
        base.InitializeCulture();

        string strLangCode;

        // 优先使用 URL 参数
        string targetLang = Request.QueryString["TargetLangCode"];
        if (!string.IsNullOrEmpty(targetLang))
        {
            strLangCode = targetLang;
            Session["LangCode"] = strLangCode;
        }
        else if (Session["LangCode"] != null)
        {
            strLangCode = Session["LangCode"].ToString();
        }
        else
        {
            strLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            Session["LangCode"] = strLangCode;
        }

        // 设置 Cookie
        if (Response.Cookies["LangCode"] == null)
        {
            Response.Cookies.Add(new HttpCookie("LangCode", strLangCode));
        }
        else
        {
            Response.Cookies["LangCode"].Value = strLangCode;
        }

        // 应用文化设置
        System.Threading.Thread.CurrentThread.CurrentCulture =
            System.Globalization.CultureInfo.CreateSpecificCulture(strLangCode);
        System.Threading.Thread.CurrentThread.CurrentUICulture =
            new System.Globalization.CultureInfo(strLangCode);
    }

    protected void InsertOrUpdateSMSCode(string strUserCode, string strSMSCode)
    {
        string strHQL;
        IList lst;

        int intID;

        strHQL = "From SMSCode as smsCode Where smsCode.UserCode = " + "'" + strUserCode + "'" + " and to_char(smsCode.SendTime,'yyyymmdd') = " + "'" + DateTime.Now.ToString("yyyyMMdd") + "'";
        SMSCodeBLL smsCodeBLL = new SMSCodeBLL();
        lst = smsCodeBLL.GetAllSMSCodes(strHQL);

        SMSCode smsCode = new SMSCode();

        if (lst.Count > 0)
        {
            smsCode = (SMSCode)lst[0];

            intID = smsCode.ID;
            smsCode.UserCode = strUserCode;
            smsCode.RandomCode = strSMSCode;
            smsCode.SendTime = DateTime.Now;

            try
            {
                smsCodeBLL.UpdateSMSCode(smsCode, intID);
            }
            catch
            {
            }
        }
        else
        {
            smsCode.UserCode = strUserCode;
            smsCode.RandomCode = strSMSCode;
            smsCode.SendTime = DateTime.Now;

            try
            {
                smsCodeBLL.AddSMSCode(smsCode);
            }
            catch
            {
            }
        }
    }

    protected int GetUserCount(string strUserCode, string strPassword)
    {
        string strHQL;

        strHQL = " from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'" + " and projectMember.Password = " + "'" + strPassword + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        return lst.Count;
    }

    protected int GetNetSegmentCount(string strHostIPaddress)
    {
        string strHQL;
        IList lst;

        string strIPAddress, strBeginIPAddress, strEndIPAddress;
        string strNewIPAddress;

        if (strHostIPaddress.IndexOf(".") >= 0)
        {
            strNewIPAddress = strHostIPaddress.Substring(0, strHostIPaddress.LastIndexOf("."));

            strIPAddress = strNewIPAddress + "%";
            strBeginIPAddress = strNewIPAddress + ".0";
            strEndIPAddress = strNewIPAddress + ".255";

            strHQL = "From SMSNetSegment as smsNetSegment where smsNetSegment.BeginSegment >=" + "'" + strBeginIPAddress + "'" + " and smsNetSegment.EndSegment <= " + "'" + strEndIPAddress + "'";
            strHQL += " and smsNetSegment.BeginSegment Like " + "'" + strIPAddress + "'" + " and smsNetSegment.EndSegment Like " + "'" + strIPAddress + "'";
            SMSNetSegmentBLL smsNetSegmentBLL = new SMSNetSegmentBLL();
            lst = smsNetSegmentBLL.GetAllSMSNetSegments(strHQL);

            if (lst.Count > 0)
            {
                return lst.Count;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
}