using ProjectMgt.BLL;
using ProjectMgt.Model;
using System;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using TakeTopSecurity;
using TakeTopCore;

public partial class DefaultWeiXin : System.Web.UI.Page
{
    //private string strToken;//��΢�Ź����˺ź�̨��Token���ñ���һ�£����ִ�Сд��

    protected void Page_Load(object sender, EventArgs e)
    {
        //��������Ʒ(jack.erp@gmail.com)
        //̩���ض����ţ�TakeTop Software��2006��2026\
        string strVerificationCode, strSMSVerification, strIsOEMVersion;
        string strUserHostAddress = Request.UserHostAddress;

        this.Title = System.Configuration.ConfigurationManager.AppSettings["SystemName"];

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
            // 数据库升级：页面加载时执行，与其他登录页面保持一致，确保用哪个页面登录都会升级
            try
            {
                DatabaseUpdateHandle.RunUpdateColumnValueCode();
                DatabaseUpdateHandle.RunUpdateModuleNameCode();
            }
            catch (Exception ex)
            {
                LogClass.WriteLogFile("DefaultWeiXin upgrade error: " + ex.Message + "\n" + ex.StackTrace);
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
            catch (Exception ex)
            {
                Session["LangCode"] = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            }

            strVerificationCode = System.Configuration.ConfigurationManager.AppSettings["VerificationCode"].Trim().ToUpper();
            if (strVerificationCode == "NO")
            {
                trCheckCode.Visible = false;
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
                }
            }

            trCheckCode.Visible = false;

            strIsOEMVersion = System.Configuration.ConfigurationManager.AppSettings["IsOEMVersion"];
            LB_Copyright.Text = "Copyright TakeTopITS Group 2006-2036";

            if (strIsOEMVersion == "NO")
            {
                LB_Copyright.Visible = true;
            }
            else
            {
                LB_Copyright.Visible = true;
                LB_Copyright.Text = "Copyright 2006-2036";
            }
        }
    }

    protected void LB_Login_Click(object sender, EventArgs e)
    {
        string strUserCode, strUserName, strPassword, strMobilePhone;
        string strUserType;
        string strUserHostAddress, strAllowDevice;
        string strHQL;

        strUserHostAddress = Request.UserHostAddress;

        strUserCode = TB_UserCode.Text.Trim().ToUpper();
        strPassword = TB_Password.Text.Trim();

        if (strUserCode == "" | strPassword == "")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZYHMHMMDBNWKJC") + "');</script>");
            return;
        }

        if (ShareClass.SqlFilter(strUserCode) | ShareClass.SqlFilter(strPassword))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZZHHYFFZHDLSB") + "');</script>");
            return;
        }

        try
        {
            strPassword = ShareClass.EncryptPassword(strPassword, "MD5");
            strHQL = "Select * from T_ProjectMember where UserCode = " + "'" + strUserCode + "'" + " and Password = " + "'" + strPassword + "'" + " And rtrim(ltrim(Status)) not in ( 'Stop','Resign')";
            strHQL += " And UserCode in (Select UserCode From T_SystemActiveUser Where AppUser = 'YES')";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strUserName = ds.Tables[0].Rows[0]["UserName"].ToString().Trim();
                strUserType = ds.Tables[0].Rows[0]["UserType"].ToString().Trim();
                strAllowDevice = ds.Tables[0].Rows[0]["AllowDevice"].ToString().Trim();
                strMobilePhone = ds.Tables[0].Rows[0]["MobilePhone"].ToString().Trim();

                Session["UserCode"] = strUserCode;
                Session["UserName"] = strUserName;
                Session["UserType"] = strUserType;
                Session["IsMobileDevice"] = "YES";
                Session["SystemType"] = "APP";

                //Session["CssDirectory"] = ds.Tables[0].Rows[0]["CssDirectory"].ToString().Trim();
                Session["CssDirectory"] = "CssBlue";

                Session["CssDirectoryChangeNumber"] = ds.Tables[0].Rows[0]["CssDirectoryChangeNumber"].ToString().Trim();
                try
                {
                    Session["LeftBarExtend"] = ds.Tables[0].Rows[0]["LeftBarExtend"].ToString().Trim();
                }
                catch
                {
                    Session["LeftBarExtend"] = "NO";
                }
                try
                {
                    //��ʼ����������
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

                //YESʱҳ������ڿ���ڴ򿪣�����ر�
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

                //�Ƿ��Զ���������������ѡ����һ����������ѡ��Ա
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

                //���ע�����Ƿ�Ϸ�
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
                if (System.Configuration.ConfigurationManager.AppSettings["ProductType"].IndexOf("SAAS") > -1)
                {
                    Session["SystemVersionType"] = "SAAS";
                }


                //�����û�΢�Ź��ں�OpenID��ͬ����΢�Ź���ƽ̨
                string strWeiXinCode;
                strWeiXinCode = Request.QueryString["code"];
                if (CheckAndSetWXOpenID(strWeiXinCode, strUserCode) == false)
                {
                    LB_ErrorMsg.Visible = true;
                    LB_ErrorMsg.Text = LanguageHandle.GetWord("ZZDLSBNDWXIDYPLYZHSY") + "��" + LB_ErrorMsg.Text + "��" + LanguageHandle.GetWord("ZZSYQLXXTGLY");
                    return;
                }

                try
                {
                    //�����û�Ŀ¼
                    ShareClass.MakeUserDirectory(strUserCode);

                    //���������û���ʼ��ģ��
                    ShareClass.InitialUserModules("SAMPLE", strUserCode);

                    //�����¼��־
                    ShareClass.InsertUserLogonLog(strUserCode, strUserName, "APP");
                }
                catch
                {
                }

                Response.Redirect("TakeTopAPPMain.aspx", false);
                return;
            }
            else
            {
                LB_ErrorMsg.Visible = true;
                LB_ErrorMsg.Text = LanguageHandle.GetWord("ZZSBYYKNRX1YHDMHMMCW2BSAPPYHHYBZZSY");

                ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBYYKNRX1YHDMHMMCW2BSAPPYHHYBZZSY") + "');</script>");
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            //Response.Redirect("TTDisplayErrors.aspx");
        }
    }

    public bool CheckAndSetWXOpenID(string strWeiXinCode, string strUserCode)
    {
        try
        {
            string strHQL;

            //��һ����΢�Ź��ںŵ�¼ʱ�����û���΢��OpenIDд����Ա������
            string strUserWXOpenID;

            if (!string.IsNullOrEmpty(strWeiXinCode))
            {
                strUserWXOpenID = TakeTopCore.WXHelper.GetGZHOpenID(strWeiXinCode);

                if (strUserWXOpenID == null)
                {
                    strUserWXOpenID = "";
                }

                //if (strUserWXOpenID != "")
                //{
                //    strHQL = "Select UserCode || UserName From T_ProjectMember Where trim(WeChatOpenID) = '" + strUserWXOpenID + "' and trim(UserCode) <> '" + strUserCode + "'";
                //    DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
                //    if (ds.Tables[0].Rows.Count > 0)
                //    {
                //        LB_ErrorMsg.Text = ds.Tables[0].Rows[0][0].ToString();
                //        return false;
                //    }

                strHQL = "Update T_ProjectMember Set WeChatOpenID = '" + strUserWXOpenID + "' Where UserCode = '" + strUserCode + "'";
                ShareClass.RunSqlCommand(strHQL);

                return true;

                //}
                //else
                //{
                //    return true;
                //}
            }
            else
            {
                return true;
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            return false;
        }
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

            strMsg =  LanguageHandle.GetWord("DuanXinYanZhengMa") + ":" + strSMSCode + "," + LanguageHandle.GetWord("DangTianYouXiao");

            if (msg.SendMSM("Message", strUserCode, strMsg, strUserCode))
            {
                InsertOrUpdateSMSCode(strUserCode, strSMSCode);

                ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZDXYZMYFSCS") + "');</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGDXYZMFSSBJCDXJKHWLLJ") + "');</script>");
            }
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGYHDMHMMCWBNDDXMJC") + "');</script>");
        }
    }

    protected void ddlLangSwitcher_SelectedIndexChanged(object sender, EventArgs e)
    {
        string selectedValue = ddlLangSwitcher.SelectedValue;

        if (!string.IsNullOrEmpty(selectedValue))
        {
            // ֻ�� Session �����ã������������ InitializeCulture()
            Session["LangCode"] = selectedValue;

            // �ض��򵽴�������ҳ��
            // ��ҳ�����ʱ�ᴦ�� URL �����������Լ��� InitializeCulture()
            Response.Redirect("DefaultWeiXin.aspx?TargetLangCode=" + selectedValue, false);
        }
    }

    protected override void InitializeCulture()
    {
        base.InitializeCulture();

        string strLangCode;

        // ����ʹ�� URL ����
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

        // ���� Cookie
        if (Response.Cookies["LangCode"] == null)
        {
            Response.Cookies.Add(new HttpCookie("LangCode", strLangCode));
        }
        else
        {
            Response.Cookies["LangCode"].Value = strLangCode;
        }

        // Ӧ���Ļ�����
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

    protected int CheckUserWeChatOpenID(string strUserWXOpenID)
    {
        string strHQL;

        try
        {
            strHQL = "Select * From T_ProjectMember Where WeChatOpenID = " + "'" + strUserWXOpenID + "'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");

            return ds.Tables[0].Rows.Count;
        }
        catch
        {
            return 0;
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

    private void WriteContent(string str)
    {
        Response.Output.Write(str);
    }
}
