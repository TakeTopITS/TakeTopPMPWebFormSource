using System;
using System.Resources;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using ProjectMgt.BLL;
using ProjectMgt.Model;
using System.Collections;
using System.Data;
using System.Text;
using System.Drawing;

public partial class TTWZSendCheck : System.Web.UI.Page
{
    string strUserCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"] == null ? "" : Session["UserCode"].ToString().Trim();

        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", strUserCode);  //Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", "期初数据导入", strUserCode);
        if (blVisible == false)
        {
            Response.Redirect("TTDisplayErrors.aspx");
            return;
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true); if (!IsPostBack)
        {

            DataSendBinder();

        }
    }

    private void DataSendBinder()
    {
        string strSendHQL = string.Format(@"select s.*,d.PlanCode,o.ObjectName,
                    b.UserName as UpLeaderName,
                    c.UserName as CheckerName,
                    f.UserName as SafekeeperName,
                    p.UserName as PurchaseEngineerName
                    from T_WZSend s
                    left join T_WZPickingPlanDetail d on s.PlanDetaiID = d.ID
                    left join T_WZObject o on s.ObjectCode = o.ObjectCode
                    left join T_ProjectMember b on s.UpLeader = b.UserCode
                    left join T_ProjectMember c on s.Checker = c.UserCode
                    left join T_ProjectMember f on s.Safekeeper = f.UserCode
                    left join T_ProjectMember p on s.PurchaseEngineer = p.UserCode
                    where s.Checker ='{0}' 
                    and s.Progress in ('材检','开票') 
                    order by s.TicketTime desc", strUserCode);
        DataTable dtSend = ShareClass.GetDataSetFromSql(strSendHQL, "Send").Tables[0];

        DG_Send.DataSource = dtSend;
        DG_Send.DataBind();

        LB_SendSql.Text = strSendHQL;
    }

    protected void DG_Send_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Pager)
        {
            string cmdName = e.CommandName;
            if (cmdName == "ticket")
            {
                //开票
                string cmdArges = e.CommandArgument.ToString();
                WZSendBLL wZSendBLL = new WZSendBLL();
                string strSendHQL = "from WZSend as wZSend where SendCode = '" + cmdArges + "'";
                IList listSend = wZSendBLL.GetAllWZSends(strSendHQL);
                if (listSend != null && listSend.Count == 1)
                {
                    WZSend wZSend = (WZSend)listSend[0];
                    if (wZSend.Progress == "材检")
                    {
                        string strCheckCode = wZSend.CheckCode;

                        //开票
                        wZSend.Progress = "开票";
                        wZSend.CheckTime = DateTime.Now.ToString();

                        wZSendBLL.UpdateWZSend(wZSend, wZSend.SendCode);

                        //重新加载收料单列表
                        DataSendBinder();

                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZKPCG + "')", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + Resources.lang.ZZJDBWCJBNKP + "')", true);
                        return;
                    }
                }
            }
        }
    }


    protected void DG_Send_PageIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        DG_Send.CurrentPageIndex = e.NewPageIndex;

        string strHQL = LB_SendSql.Text.Trim();
        DataTable dtSend = ShareClass.GetDataSetFromSql(strHQL, "Send").Tables[0];

        DG_Send.DataSource = dtSend;
        DG_Send.DataBind();
    }


}