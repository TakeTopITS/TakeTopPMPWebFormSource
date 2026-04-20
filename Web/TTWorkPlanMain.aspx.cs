using System;

public partial class TTWorkPlanMain : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strProjectID, strProjectName, strUserCode;

        // 检查 Session 是否为 null，防止第一次访问时出错
        if (Session["UserCode"] == null)
        {
            Response.Redirect("Default.aspx");
            return;
        }

        strUserCode = Session["UserCode"].ToString();

        strProjectID = Request.QueryString["ProjectID"];
        if (string.IsNullOrEmpty(strProjectID))
        {
            Response.Redirect("Default.aspx");
            return;
        }

        strProjectName = ShareClass.GetProjectName(strProjectID);

        Session["ProjectIDForGantt"] = strProjectID;
        Session["VerIDForGantt"] = null;

        try
        {
            if (Session["WeekendFirstDay"] == null)
            {
                //取得周末开始日
                Session["WeekendFirstDay"] = ShareClass.GetWeekendFirstDay();
            }

            if (Session["WeekendSecondDay"] == null)
            {
                //取得周末结束日
                Session["WeekendSecondDay"] = ShareClass.GetWeekendSecondDay();
            }

            if (Session["WeekendsAreWorkdays"] == null)
            {
                //取得周末是否工作日
                Session["WeekendsAreWorkdays"] = ShareClass.GetWeekendsAreWorkdays();
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

}
