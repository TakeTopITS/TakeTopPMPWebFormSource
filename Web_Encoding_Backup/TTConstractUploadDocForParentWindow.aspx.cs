using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTConstractUploadDocForParentWindow : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void BtnUP_Click(object sender, EventArgs e)
    {
        //上传附件
        if (AttachFile.HasFile)
        {
            string strFileName1, strExtendName, strAttachName;
            string strUserCode = Session["UserCode"].ToString();

            strFileName1 = this.AttachFile.FileName;//获取上传文件的文件名,包括后缀
            strExtendName = System.IO.Path.GetExtension(strFileName1);//获取扩展名

            DateTime dtUploadNow = DateTime.Now; //获取系统时间

            string strFileName2 = System.IO.Path.GetFileName(strFileName1);
            string strExtName = Path.GetExtension(strFileName2);

            if(strExtName.ToLower().IndexOf("doc")<0)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" +LanguageHandle.GetWord("ZZShiBaiZhiNengShangChuanwordW")+"')", true);
                return;
            }

            //string strFileName3 = Path.GetFileNameWithoutExtension(strFileName2) + DateTime.Now.ToString("yyyyMMddHHMMssff") + strExtendName;
            string strFileName3 = "CONTRACT" + DateTime.Now.ToString("yyyyMMddHHMMssff") + strExtendName;

            string strDocSavePath = Server.MapPath("Doc") + "\\" + DateTime.Now.ToString("yyyyMM") + "\\" + strUserCode + "\\Doc\\";

            FileInfo fi = new FileInfo(strDocSavePath + strFileName3);

            if (fi.Exists)
            {

            }
            else
            {
                try
                {
                    AttachFile.MoveTo(strDocSavePath + strFileName3, Brettle.Web.NeatUpload.MoveToOptions.Overwrite);
                    strAttachName = Path.GetFileNameWithoutExtension(strFileName2);

                    string strURL = "Doc\\" + DateTime.Now.ToString("yyyyMM") + "\\" + strUserCode + "\\Doc\\" + strFileName3;
                    strURL = strURL.Replace("\\", "TAKETOP888888");


                    ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop11", "SetDocURL('" + strURL + "','true');", true);
                }
                catch
                {
                }
            }
        }
        else
        {
        }

    }

}