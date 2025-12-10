using System;
using System.Resources;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Text;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Drawing;

using DayPilot.Utils;
using DayPilot.Web.Ui.Events;
using DayPilot.Web.Ui.Events.Calendar;
using DayPilot.Web.Ui.Events.Bubble;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

using AjaxControlToolkit;

public partial class TTMySchedule : System.Web.UI.Page
{
    private DataTable table;
    string strUserCode, strUserName;

    protected void Page_Load(object sender, EventArgs e)
    {
        #region Data loading initialization

        strUserCode = HttpContext.Current.Session["UserCode"].ToString();
        strUserName = HttpContext.Current.Session["UserName"].ToString();

        System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(Session["LangCode"].ToString());
        System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(Session["LangCode"].ToString());

        if (Session["AllFeatures"] == null)
        {
            Session["AllFeatures"] = DataGeneratorCalendar.GetData();
        }
        table = (DataTable)Session["AllFeatures"];
        DayPilotCalendar1.DataSource = Session["AllFeatures"];
        DayPilotNavigator1.DataSource = Session["AllFeatures"];

        #endregion

        if (!IsPostBack)
        {
            DataBind();
            DayPilotCalendar1.UpdateWithMessage("Welcome!");
        }
    }

    // 辅助方法：将DateTime格式化为PostgreSQL兼容的字符串
    private string FormatDateTimeForPostgreSQL(DateTime dateTime)
    {
        return dateTime.ToString("yyyy-MM-dd HH:mm:ss");
    }

    protected void DayPilotCalendar1_EventMove(object sender, EventMoveEventArgs e)
    {
        #region Simulation of database update

        DataRow dr = table.Rows.Find(e.Id);
        if (dr != null)
        {
            dr["start"] = e.NewStart;
            dr["end"] = e.NewEnd;
            table.AcceptChanges();

            // 使用格式化的日期字符串
            string startStr = FormatDateTimeForPostgreSQL(e.NewStart);
            string endStr = FormatDateTimeForPostgreSQL(e.NewEnd);

            string strHQL = string.Format(
                @"Update t_schedule Set start = cast('{0}' as timestamp without time zone),""end"" = cast('{1}' as timestamp without time zone) Where id = '{2}'",
                startStr, endStr, e.Id);
            ShareClass.RunSqlCommand(strHQL);
        }

        #endregion

        DayPilotCalendar1.DataBind();
        DayPilotCalendar1.UpdateWithMessage("Event moved.");
        DayPilotCalendar1.Update();
    }

    protected void DayPilotCalendar1_EventMenuClick(object sender, EventMenuClickEventArgs e)
    {
        if (e.Command == "Delete")
        {
            #region Simulation of database update
            DataRow dr = table.Rows.Find(e.Id);

            if (dr != null)
            {
                table.Rows.Remove(dr);
                table.AcceptChanges();

                string strHQL;
                strHQL = string.Format(@"Delete From t_schedule where id = '{0}'", e.Id);
                ShareClass.RunSqlCommand(strHQL);
            }
            #endregion

            DayPilotCalendar1.DataBind();
            DayPilotCalendar1.Update();
        }
    }

    protected void DayPilotCalendar1_TimeRangeSelected(object sender, TimeRangeSelectedEventArgs e)
    {
        #region Simulation of database update

        DataRow dr = table.NewRow();
        dr["start"] = e.Start;
        dr["end"] = e.End;
        dr["id"] = Guid.NewGuid().ToString();
        dr["name"] = "New event";

        table.Rows.Add(dr);
        table.AcceptChanges();

        // 使用格式化的日期字符串
        string startStr = FormatDateTimeForPostgreSQL(e.Start);
        string endStr = FormatDateTimeForPostgreSQL(e.End);

        string strHQL = string.Format(
            @"Insert Into t_schedule(id,start,""end"",""name"",""column"",usercode,username,allday,color) values ('{0}',cast('{1}' as timestamp without time zone),cast('{2}' as timestamp without time zone),'{3}','{4}','{5}','{6}','{7}','{8}')",
            dr["id"], startStr, endStr, dr["name"], "", strUserCode, strUserName, '0', "green");
        ShareClass.RunSqlCommand(strHQL);
        #endregion

        DayPilotCalendar1.DataBind();
        DayPilotCalendar1.UpdateWithMessage("New event created.");
    }

    protected void DayPilotCalendar1_EventResize(object sender, EventResizeEventArgs e)
    {
        #region Simulation of database update

        DataRow dr = table.Rows.Find(e.Id);
        if (dr != null)
        {
            dr["start"] = e.NewStart;
            dr["end"] = e.NewEnd;
            table.AcceptChanges();

            // 使用格式化的日期字符串
            string startStr = FormatDateTimeForPostgreSQL(e.NewStart);
            string endStr = FormatDateTimeForPostgreSQL(e.NewEnd);

            string strHQL = string.Format(
                @"Update t_schedule Set start = cast('{0}' as timestamp without time zone),""end"" = cast('{1}' as timestamp without time zone) Where id = '{2}'",
                startStr, endStr, e.Id);
            ShareClass.RunSqlCommand(strHQL);
        }

        #endregion

        DayPilotCalendar1.DataBind();
        DayPilotCalendar1.UpdateWithMessage("Event resized");
    }

    protected void DayPilotCalendar1_EventClick(object sender, EventClickEventArgs e)
    {
        #region Simulation of database update

        DataRow dr = table.Rows.Find(e.Id);
        if (dr != null)
        {
            dr["name"] = "Event clicked at " + DateTime.Now;
            table.AcceptChanges();
        }

        #endregion

        DayPilotCalendar1.DataBind();
        DayPilotCalendar1.Update();
    }

    protected void DayPilotCalendar1_EventEdit(object sender, EventEditEventArgs e)
    {
        #region Simulation of database update

        DataRow dr = table.Rows.Find(e.Id);
        if (dr != null)
        {
            dr["name"] = e.NewText;
            table.AcceptChanges();

            string strHQL = string.Format(@"Update t_schedule Set name = '{0}' Where id = '{1}'", dr["name"], e.Id);
            ShareClass.RunSqlCommand(strHQL);
        }

        #endregion

        DayPilotCalendar1.DataBind();
        DayPilotCalendar1.UpdateWithMessage("Event text changed.");
    }

    protected void DayPilotCalendar1_EventDelete(object sender, EventDeleteEventArgs e)
    {
        #region Simulation of database update

        DataRow dr = table.Rows.Find(e.Id);
        if (dr != null)
        {
            table.Rows.Remove(dr);
            table.AcceptChanges();

            string strHQL;
            strHQL = string.Format(@"Delete From t_schedule where id = '{0}'", e.Id);
            ShareClass.RunSqlCommand(strHQL);
        }

        #endregion

        DayPilotCalendar1.DataBind();
        DayPilotCalendar1.UpdateWithMessage("Event deleted.");
    }

    protected void DayPilotCalendar1_EventSelect(object sender, DayPilotEventArgs e)
    {
        DayPilotCalendar1.Update();
    }

    protected void DayPilotCalendar1_BeforeHeaderRender(object sender, BeforeHeaderRenderEventArgs e)
    {
    }

    protected void DayPilotCalendar1_BeforeEventRender(object sender, BeforeEventRenderEventArgs e)
    {
        e.BubbleHtml = e.Start.ToString();

        string strID, strColor;

        string strHQL;
        strHQL = string.Format(@"Select id,color from t_schedule Where UserCode = '{0}'", strUserCode);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "t_schedule");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strID = ds.Tables[0].Rows[i]["id"].ToString().Trim();

            try
            {
                strColor = ds.Tables[0].Rows[i]["color"].ToString().Trim();
            }
            catch
            {
                strColor = "green";
            }

            if (e.Id == strID)
            {
                e.BorderColor = "#1AAFE0";
                e.BackgroundColor = strColor;

                if (strColor != "white" && strColor != "gold")
                {
                    e.FontColor = "white";
                }
                else
                {
                    e.FontColor = "black";
                }
            }
        }
    }

    protected void DayPilotBubble1_RenderContent(object sender, RenderEventArgs e)
    {
        if (e is RenderEventBubbleEventArgs)
        {
            RenderEventBubbleEventArgs re = e as RenderEventBubbleEventArgs;

            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("<b>{0}</b><br />", re.Text);
            sb.AppendFormat("Start: {0}<br />", re.Start);
            sb.AppendFormat("End: {0}<br />", re.End);

            re.InnerHTML = sb.ToString();
        }
        else if (e is RenderTimeBubbleEventArgs)
        {
            RenderTimeBubbleEventArgs re = e as RenderTimeBubbleEventArgs;
            e.InnerHTML = "<b>Time header details</b><br />From:" + re.Start + "<br />To: " + re.End;
        }
        else if (e is RenderCellBubbleEventArgs)
        {
            RenderCellBubbleEventArgs re = e as RenderCellBubbleEventArgs;
            e.InnerHTML = "<b>Cell details</b><br />Column:" + re.ResourceId + "<br />From:" + re.Start + "<br />To: " + re.End;
        }
    }

    protected void DayPilotCalendar1_TimeRangeDoubleClick(object sender, TimeRangeDoubleClickEventArgs e)
    {
        #region Simulation of database update
        DataRow dr = table.NewRow();
        dr["start"] = e.Start;
        dr["end"] = e.End;
        dr["id"] = Guid.NewGuid().ToString();
        dr["name"] = "New event";

        table.Rows.Add(dr);
        table.AcceptChanges();

        // 使用格式化的日期字符串
        string startStr = FormatDateTimeForPostgreSQL(e.Start);
        string endStr = FormatDateTimeForPostgreSQL(e.End);

        string strHQL = string.Format(
            @"Insert Into t_schedule(id,start,""end"",""name"",""column"",usercode,username,allday,color) values ('{0}',cast('{1}' as timestamp without time zone),cast('{2}' as timestamp without time zone),'{3}','{4}','{5}','{6}','{7}','{8}')",
            dr["id"], startStr, endStr, dr["name"], "", strUserCode, strUserName, '0', "green");
        ShareClass.RunSqlCommand(strHQL);
        #endregion

        DayPilotCalendar1.DataBind();
        DayPilotCalendar1.UpdateWithMessage("New event created.");
    }

    protected void DayPilotCalendar1_TimeRangeMenuClick(object sender, TimeRangeMenuClickEventArgs e)
    {
        if (e.Command == "Insert")
        {
            #region Simulation of database update

            DataRow dr = table.NewRow();
            dr["start"] = e.Start;
            dr["end"] = e.End;
            dr["id"] = Guid.NewGuid().ToString();
            dr["name"] = "New event";

            table.Rows.Add(dr);
            table.AcceptChanges();

            // 使用格式化的日期字符串
            string startStr = FormatDateTimeForPostgreSQL(e.Start);
            string endStr = FormatDateTimeForPostgreSQL(e.End);

            string strHQL = string.Format(
                @"Insert Into t_schedule(id,start,""end"",""name"",""column"",usercode,username,allday,color) values ('{0}',cast('{1}' as timestamp without time zone),cast('{2}' as timestamp without time zone),'{3}','{4}','{5}','{6}','{7}','{8}')",
                dr["id"], startStr, endStr, dr["name"], "", strUserCode, strUserName, '0', "green");
            ShareClass.RunSqlCommand(strHQL);
            #endregion

            DayPilotCalendar1.DataBind();
            DayPilotCalendar1.Update();
        }
    }

    protected void DayPilotCalendar1_Command(object sender, CommandEventArgs e)
    {
        switch (e.Command)
        {
            case "navigate":
                DateTime start = (DateTime)e.Data["start"];
                DateTime end = (DateTime)e.Data["end"];
                DateTime day = (DateTime)e.Data["day"]; // clicked day

                DayPilotCalendar1.StartDate = start;
                DayPilotCalendar1.DataBind();
                DayPilotCalendar1.UpdateWithMessage("Date changed. You clicked: " + day);
                break;
            case "refresh":
                DayPilotCalendar1.DataBind();
                DayPilotCalendar1.UpdateWithMessage("Refreshed.");
                break;
            case "paste":
                DateTime pasteHere = (DateTime)e.Data["start"];
                string id = (string)e.Data["id"];

                DataRow dr = table.Rows.Find(id);
                if (dr != null)
                {
                    TimeSpan duration = ((DateTime)dr["end"]) - ((DateTime)dr["start"]);

                    DataRow drNew = table.NewRow();
                    drNew["start"] = pasteHere;
                    drNew["end"] = pasteHere + duration;
                    drNew["id"] = Guid.NewGuid().ToString();
                    drNew["name"] = "Copy of " + dr["name"];

                    table.Rows.Add(drNew);
                    table.AcceptChanges();

                    // 使用格式化的日期字符串
                    string startStr = FormatDateTimeForPostgreSQL(pasteHere);
                    string endStr = FormatDateTimeForPostgreSQL(pasteHere + duration);

                    string strHQL = string.Format(
                        @"Insert Into t_schedule(id, start, ""end"", ""name"", ""column"", usercode, username, allday, color) 
                    values ('{0}', cast('{1}' as timestamp), cast('{2}' as timestamp), '{3}', '{4}', '{5}', '{6}', '{7}', '{8}')",
                        drNew["id"],
                        startStr,  // 使用格式化的日期
                        endStr,    // 使用格式化的日期
                        drNew["name"]?.ToString()?.Replace("'", "''") ?? "",
                        "",
                        strUserCode?.Replace("'", "''") ?? "",
                        strUserName?.Replace("'", "''") ?? "",
                        '0',
                        "green"
                    );
                    ShareClass.RunSqlCommand(strHQL);
                }
                DayPilotCalendar1.DataBind();
                DayPilotCalendar1.UpdateWithMessage("Event copied.");
                break;
            case "test":
                DayPilotCalendar1.CellDuration = 60;
                DayPilotCalendar1.DataBind();
                DayPilotCalendar1.UpdateWithMessage("Updated");
                break;
        }
    }

    protected void DayPilotNavigator1_VisibleRangeChanged(object sender, EventArgs e)
    {
        DayPilotNavigator1.DataBind();
    }

    protected void DayPilotCalendar1_BeforeCellRender(object sender, BeforeCellRenderEventArgs e)
    {
        if (e.End.Minute > 0)
        {
            e.CssClass = "intrahour";
        }
    }

    protected void DayPilotCalendar1_HeaderClick(object sender, HeaderClickEventArgs e)
    {
    }

    protected void DayPilotNavigator1_TimeRangeSelected(object sender, TimeRangeSelectedEventArgs e)
    {
    }

    protected void DayPilotCalendar1_BeforeTimeHeaderRender(DayPilot.Web.Ui.Events.Calendar.BeforeTimeHeaderRenderEventArgs ea)
    {
    }

    protected void DayPilotNavigator1_BeforeCellRender(object sender, DayPilot.Web.Ui.Events.Navigator.BeforeCellRenderEventArgs e)
    {
    }

    protected void DayPilotCalendar1_OnEventDoubleClick(object sender, EventClickEventArgs e)
    {
        DayPilotCalendar1.UpdateWithMessage("Doubleclick");
    }
}