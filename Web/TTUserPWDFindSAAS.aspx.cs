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
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;

using TakeTopSecurity;
using TakeTopCore;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

public partial class TTUserPWDFindSAAS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strType = Request.QueryString["type"];

        if (Page.IsPostBack == false)
        {
            //检查注是否为SAAS版本
            string strServerName = System.Configuration.ConfigurationManager.AppSettings["ServerName"];
            TakeTopLicense license = new TakeTopLicense();
            string strSystemVersionType = license.GetVerType(strServerName); ;
            if (strSystemVersionType != "SAAS")
            {
                Response.Redirect("TTDisplayErrors.aspx");
            }

            if (strType == "WXGZH" | !ShareClass.IsMobileDeviceCheckAgent())
            {
                BT_BackLoginPage.Visible = false;
            }
            else
            {
                BT_BackLoginPage.Visible = true;
            }
        }
    }

    protected void BT_GetCheckCode_Click(object sender, EventArgs e)
    {
        string strSendUserCode = TB_UserCode.Text.Trim();

        string strCheckCode = GetCheckCode();

        Session[strSendUserCode + "CheckCode"] = strCheckCode;

        Msg msg = new Msg();
        try
        {
            new System.Threading.Thread(delegate ()
            {
                try
                {
                    //try
                    //{
                    //    msg.SendPhoneMSMBySP(strMobilePhone, LanguageHandle.GetWord("XiangMuBaoYanZhengMa") + TB_Password.Text.Trim(), "ADMIN");
                    //}
                    //catch
                    //{
                    //}

                    try
                    {
                        msg.SendMail(strSendUserCode, LanguageHandle.GetWord("XiangMuBaoYanZhengMa"), strCheckCode, "ADMIN");
                    }
                    catch
                    {
                    }

                    try
                    {
                        //发送消息到微信用户，用于公众号
                        string strOpenID = TakeTopCore.WXHelper.GetUserWeXinOpenIDByUserCode(strSendUserCode);
                        if (strOpenID != "")
                        {
                            msg.SendWeChatGZMsg(strOpenID, LanguageHandle.GetWord("XiangMuBaoYanZhengMa") + strCheckCode);
                        }
                    }
                    catch
                    {
                    }
                }
                catch
                {
                }

            }).Start();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZNHYZMYFSDWXGZHTDGLBQDKNDWXCK") + "')", true);

        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZFSSBQJCNYMYGZWXGCHTDGLB") + "')", true);
        }
    }

    protected void BT_UpdatePWD_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strCheckCode1, strCheckCode2;
        string strUserCode, strPassword,strConfirmPassword;

        strUserCode = TB_UserCode.Text.Trim().ToUpper();

        if (strUserCode == "")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("DaiMaBuNengWeiKong") + "')", true);
            return;
        }


        strCheckCode1 = TB_CheckCode.Text.Trim();
        strCheckCode2 = Session[strUserCode + "CheckCode"].ToString();
        if (strCheckCode1 != strCheckCode2 | strCheckCode1 == "")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZNZMCWQJC") + "')", true);
            return;
        }

        //Regex mobileReg = new Regex("[0-9]{11,11}");
        //if (!mobileReg.IsMatch(strUserCode))
        //{
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSJHMBZQQJC") + "')", true);
        //    return;
        //}

        strHQL = "Select * From T_ProjectMember Where UserCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
        if (ds.Tables[0].Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZCSJHBCZQJC") + "')", true);
            return;
        }

        strPassword = TB_Password.Text.Trim();
        #region 判断输入的密码是否是字母与数字的结合，且长度要大于或等于8位 2013-09-03 By LiuJianping
        if (!ShareClass.IsPassword(strPassword))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGGSBMMCDBXDYHDY8WBXBHSZJZMJC") + "')", true);
            TB_Password.Focus();
            return;
        }
        #endregion

        strConfirmPassword = TB_ConfirmPassword.Text.Trim();
        if (strConfirmPassword != strPassword)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGMMHQRMMBYZQJC") + "')", true);
            return;
        }

        try
        {
            strHQL = "Update T_ProjectMember SET Password = '" + ShareClass.EncryptPassword(TB_Password.Text.Trim(), "MD5") + "' Where UserCode = '" + strUserCode + "'";
            ShareClass.RunSqlCommand(strHQL);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZMMGGCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZMMGGSBQJC") + "')", true);
        }
    }


    protected string GetCheckCode()
    {
        string chkCode = string.Empty;
        //颜色列表，用于验证码、噪线、噪点 
        Color[] color = { Color.Black, Color.Red, Color.Blue, Color.Green, Color.Orange, Color.Brown, Color.Brown, Color.DarkBlue };
        //字体列表，用于验证码 
        string[] font = { "Times New Roman", "MS Mincho", "Book Antiqua", "Gungsuh", "PMingLiU", "Impact" };
        //验证码的字符集，去掉了一些容易混淆的字符 
        char[] character = { '2', '3', '4', '5', '6', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'R', 'S', 'T', 'W', 'X', 'Y' };
        Random rnd = new Random();
        //生成验证码字符串 
        for (int i = 0; i < 6; i++)
        {
            chkCode += character[rnd.Next(character.Length)];
        }

        return chkCode;
    }



}
