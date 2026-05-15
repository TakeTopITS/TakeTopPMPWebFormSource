using ProjectMgt.BLL;
using ProjectMgt.Model;
using System; using System.Resources;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTGDProjectEdit : System.Web.UI.Page
{
    string strUserCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"] == null ? "" : Session["UserCode"].ToString().Trim();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true); if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                string id = Request.QueryString["id"].ToString();
                HF_ID.Value = id;
                int intID = 0;
                int.TryParse(id, out intID);

                BindData(intID);
            }
        }
    }


    protected void btnOK_Click(object sender, EventArgs e)
    {
        try
        {
            string strProjectCode = TXT_ProjectCode.Text.Trim();
            string strProjectName = TXT_ProjectName.Text.Trim();
            string strProjectAddress = TXT_ProjectAddress.Text.Trim();

            if (string.IsNullOrEmpty(strProjectCode))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXMHBNWKBC+"')", true);
                return;
            }
            if (!ShareClass.CheckStringRight(strProjectCode))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXMHBNWFFZF+"')", true);
                return;
            }
            if (string.IsNullOrEmpty(strProjectName))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXMMCBNWKBC+"')", true);
                return;
            }
            if (!ShareClass.CheckStringRight(strProjectName))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZXMMCBNWFFZF+"')", true);
                return;
            }
            if (!ShareClass.CheckStringRight(strProjectAddress))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+Resources.lang.ZZDDBNWFFZF+"')", true);
                return;
            }

            GDProjectBLL gDProjectBLL = new GDProjectBLL();
            
            if (!string.IsNullOrEmpty(HF_ID.Value))
            {
                //ÐÞ¸Ä
                int intID = 0;
                int.TryParse(HF_ID.Value, out intID);

                string strSelectGDProjectHQL = "from GDProject as gDProject where id = " + intID;
                IList listGDProject = gDProjectBLL.GetAllGDProjects(strSelectGDProjectHQL);
                if (listGDProject != null && listGDProject.Count > 0)
                {
                    GDProject gDProject = (GDProject)listGDProject[0];

                    gDProject.ProjectCode = strProjectCode;
                    gDProject.ProjectName = strProjectName;
                    gDProject.ProjectAddress = strProjectAddress;

                    gDProjectBLL.UpdateGDProject(gDProject, intID);
                }
            }
            else
            {
                GDProject gDProject = new GDProject();

                gDProject.ProjectCode = strProjectCode;
                gDProject.ProjectName = strProjectName;
                gDProject.ProjectAddress = strProjectAddress;
                gDProject.CreateDate = DateTime.Now;

                gDProject.IsMark = 0;
                gDProject.UserCode = strUserCode;

                //Ôö¼Ó
                gDProjectBLL.AddGDProject(gDProject);
            }

            Response.Redirect("TTGDProjectList.aspx");
        }
        catch (Exception ex)
        { }
    }


    private void BindData(int id)
    {
        GDProjectBLL gDProjectBLL = new GDProjectBLL();
        string strGDProjectSql = "from GDProject as gDProject where id = " + id;
        IList listGDProject = gDProjectBLL.GetAllGDProjects(strGDProjectSql);
        if (listGDProject != null && listGDProject.Count > 0)
        {
            GDProject gDProject = (GDProject)listGDProject[0];

            TXT_ProjectCode.Text = gDProject.ProjectCode;
            TXT_ProjectName.Text = gDProject.ProjectName;
            TXT_ProjectAddress.Text = gDProject.ProjectAddress;
        }
    }
}