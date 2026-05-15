using ProjectMgt.BLL;
using ProjectMgt.Model;
using System; using System.Resources;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTWZObjectBigEdit : System.Web.UI.Page
{
    string strUserCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"] != null ? Session["UserCode"].ToString() : "";

         if (!IsPostBack)
        {
            DataTemplateFileBinder();
        }
    }


    protected void btnImport_Click(object sender, EventArgs e)
    {
        string strObjectBigDocument = fileExcel.PostedFile.FileName;   //获取上传文件的文件名,包括后缀
        if (!string.IsNullOrEmpty(strObjectBigDocument))
        {
            string strExtendName = System.IO.Path.GetExtension(strObjectBigDocument);//获取扩展名

            DateTime dtUploadNow = DateTime.Now; //获取系统时间
            string strFileName2 = System.IO.Path.GetFileName(strObjectBigDocument);
            string strExtName = Path.GetExtension(strFileName2);

            string strFileName3 = Path.GetFileNameWithoutExtension(strFileName2) + DateTime.Now.ToString("yyyyMMddHHMMssff") + strExtendName;

            string strDocSavePath = Server.MapPath("Doc") + "\\" + DateTime.Now.ToString("yyyyMM") + "\\" + strUserCode + "\\Doc\\";


            FileInfo fi = new FileInfo(strDocSavePath + strFileName3);

            if (fi.Exists)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('"+Resources.lang.ZZCZTMWJSCSBGMHZSC+"');</script>");
            }

            if (Directory.Exists(strDocSavePath) == false)
            {
                //如果不存在就创建file文件夹{
                Directory.CreateDirectory(strDocSavePath);
            }

            string strAllUrl = strDocSavePath + strFileName3;
            fileExcel.SaveAs(strAllUrl);

            DataTable dtExcel = null;
            string resultMsg = string.Empty;
            try
            {
                dtExcel = ExcelUtils.ReadExcel(strAllUrl, "Sheet1").Tables[0];
                bool isSuccess = ValidateData(dtExcel, ref resultMsg);
                if (isSuccess)
                {
                    Import(dtExcel, ref resultMsg);
                }

                lblMsg.Text = string.Format("<span style='color:red' >{0}</span>", resultMsg);
            }
            catch (Exception ex)
            {
                lblMsg.Text = string.Format("<span style='color:red' >导入时出现以下错误: {0}!</span>", ex.Message);
            }
        }
    }


    /// <summary>
    /// 验证数据合法性.
    /// </summary>
    /// <param name="dtExcel"></param>
    /// <param name="resultMsg"></param>
    /// <returns></returns>
    private bool ValidateData(DataTable dtExcel, ref string resultMsg)
    {
        int lineNumber = 1;
        foreach (DataRow row in dtExcel.Rows)
        {
            lineNumber++;
            try
            {
                string strDLCode = ShareClass.ObjectToString(row["大类代码"]);
                string strDLName = ShareClass.ObjectToString(row["大类名称"]);
                string strDLDesc = ShareClass.ObjectToString(row["大类说明"]);
                if (string.IsNullOrEmpty(strDLCode))
                {
                    resultMsg += string.Format("第{0}行，大类代码不能为空<br/>", lineNumber);
                    continue;
                }
                if (!ShareClass.CheckStringRight(strDLCode))
                {
                    resultMsg += string.Format("第{0}行，大类代码不能包含非法字符<br/>", lineNumber);
                    continue;
                }
                if (strDLCode.Length != 2)
                {
                    resultMsg += string.Format("第{0}行，大类代码只能为2个字符<br/>", lineNumber);
                    continue;
                }
                if (string.IsNullOrEmpty(strDLName))
                {
                    resultMsg += string.Format("第{0}行，大类名称不能为空<br/>", lineNumber);
                    continue;
                }
                if (!ShareClass.CheckStringRight(strDLName))
                {
                    resultMsg += string.Format("第{0}行，大类名称不能包含非法字符<br/>", lineNumber);
                    continue;
                }
                if (strDLCode.Length > 22)
                {
                    resultMsg += string.Format("第{0}行，大类名称不能超过22个字符<br/>", lineNumber);
                    continue;
                }
                if (strDLDesc.Length > 30)
                {
                    resultMsg += string.Format("第{0}行，大类说明不能超过22个字符<br/>", lineNumber);
                    continue;
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = string.Format("<span style='color:red' >导入时出现以下错误: {0}!</span>", ex.Message);
            }

        }
        if (!string.IsNullOrEmpty(resultMsg)) return false;
        return true;
    }


    private bool Import(DataTable dtExcel, ref string resultMsg)
    {
        //先清空大类表
        string strDeleteMaterialDLHQL = "truncate table T_WZMaterialDL";
        ShareClass.RunSqlCommand(strDeleteMaterialDLHQL);

        WZMaterialDLBLL wZMaterialDLBLL = new WZMaterialDLBLL();

        int successCount = 0;
        int lineNumber = 0;

        foreach (DataRow row in dtExcel.Rows)
        {
            string strDLCode = string.Empty;
            string strDLName = string.Empty;
            string strDLDesc = string.Empty;
            lineNumber++;
            strDLCode = ShareClass.ObjectToString(row["大类代码"]);
            strDLName = ShareClass.ObjectToString(row["大类名称"]);
            strDLDesc = ShareClass.ObjectToString(row["大类说明"]);

            WZMaterialDL wZMaterialDL = new WZMaterialDL();
            wZMaterialDL.DLCode = strDLCode;
            wZMaterialDL.DLName = strDLName;
            wZMaterialDL.DLDesc = strDLDesc;

            wZMaterialDLBLL.AddWZMaterialDL(wZMaterialDL);

            successCount++;
        }

        if (successCount > 0)
        {
            if (successCount == dtExcel.Rows.Count)
            {
                resultMsg += string.Format("<br/>已成功导入 {0} 条数据", successCount);
            }
            else
            {
                resultMsg += string.Format("<br/>已成功导入 {0} 条数据， 共有 {1} 条数据验证失败", successCount, dtExcel.Rows.Count - successCount);
            }

            return true;
        }
        else
        {
            resultMsg += string.Format("<br/>未导入数据， 共有 {0} 条数据验证失败", dtExcel.Rows.Count - successCount);
        }

        return false;
    }

    protected void lbTemplate_Click(object sender, EventArgs e)
    {
        // 下载项目对应相应模板.
        try
        {
            string templatePath = Server.MapPath("Doc/Templates/大类代码.xls");


            FileUtils.Download(templatePath, string.Format("{0}.xls", "大类代码"), Response, false);
        }
        catch (Exception ex)
        { }
    }


    protected void BT_Template_Click(object sender, EventArgs e)
    {
        try
        {
            string strTemplateDocument = FUP_Template.PostedFile.FileName;   //获取上传文件的文件名,包括后缀
            if (!string.IsNullOrEmpty(strTemplateDocument))
            {
                string strExtendName = System.IO.Path.GetExtension(strTemplateDocument);//获取扩展名

                DateTime dtUploadNow = DateTime.Now; //获取系统时间
                string strFileName2 = System.IO.Path.GetFileName(strTemplateDocument);
                string strExtName = Path.GetExtension(strFileName2);

                string strFileName3 = Path.GetFileNameWithoutExtension(strFileName2) + DateTime.Now.ToString("yyyyMMddHHMMssff") + strExtendName;

                string strDocSavePath = Server.MapPath("Doc") + "\\" + DateTime.Now.ToString("yyyyMM") + "\\" + strUserCode + "\\Doc\\";


                FileInfo fi = new FileInfo(strDocSavePath + strFileName3);

                if (fi.Exists)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('"+Resources.lang.ZZCZTMWJSCSBGMHZSC+"');</script>");
                }

                if (Directory.Exists(strDocSavePath) == false)
                {
                    //如果不存在就创建file文件夹{
                    Directory.CreateDirectory(strDocSavePath);
                }

                FUP_Template.SaveAs(strDocSavePath + strFileName3);


                string strUrl = "Doc\\" + DateTime.Now.ToString("yyyyMM") + "\\" + strUserCode + "\\Doc\\" + strFileName3;
                string strName = Path.GetFileNameWithoutExtension(strFileName2);
                LT_Template.Text = "<a href=\"" + strUrl + "\" class=\"notTab\" target=\"_blank\">" + strName + "</a>";

                string strCheckTemplateFileHQL = string.Format("select * from T_WZTemplateFile where TemplateType = '大类'");
                DataTable dtCheckTemplateFile = ShareClass.GetDataSetFromSql(strCheckTemplateFileHQL, "TemplateFile").Tables[0];
                if (dtCheckTemplateFile != null && dtCheckTemplateFile.Rows.Count > 0)
                {
                    //已经存在，替换
                    string strID = ShareClass.ObjectToString(dtCheckTemplateFile.Rows[0]["ID"]);

                    string strUpdateTemplateFileSQL = string.Format(@"update T_WZTemplateFile
                                    set TemplateName = '{0}',
                                    TemplateUrl = '{1}'
                                    where ID = {2}", strName,strUrl, strID);
                    ShareClass.RunSqlCommand(strUpdateTemplateFileSQL);
                }
                else {
                    //不存在，添加
                    string strInsertTemplateFileSQL = string.Format(@"insert into T_WZTemplateFile(TemplateType,TemplateName,TemplateUrl)
                                    values('{0}', '{1}','{2}')", "大类", strName, strUrl);
                    ShareClass.RunSqlCommand(strInsertTemplateFileSQL);
                }

                Response.Write("<script>showAlertAtMouse('上传成功！');</script>");
                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZSCBJWJCG+"')", true);
            }
            else
            {
                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZZYSCDWJ+"')", true);
                Response.Write("<script>showAlertAtMouse('"+Resources.lang.ZZZYSCDWJ+"');</script>");
                return;
            }
        }
        catch (Exception ex) { }
    }



    private void DataTemplateFileBinder()
    {
        string strTemplateFileHQL = string.Format("select * from T_WZTemplateFile where TemplateType = '大类'");
        DataTable dtTemplateFile = ShareClass.GetDataSetFromSql(strTemplateFileHQL, "TemplateFile").Tables[0];

        if (dtTemplateFile != null && dtTemplateFile.Rows.Count > 0)
        {
            string strTemplateName = ShareClass.ObjectToString(dtTemplateFile.Rows[0]["TemplateName"]);
            string strTemplateUrl = ShareClass.ObjectToString(dtTemplateFile.Rows[0]["TemplateUrl"]);

            LT_Template.Text = "<a href=\"" + strTemplateUrl + "\" class=\"notTab\" target=\"_blank\">" + strTemplateName + "</a>"; ;
        }
    }
}