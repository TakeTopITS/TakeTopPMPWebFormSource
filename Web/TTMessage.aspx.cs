using System; using System.Resources;
using System.Drawing;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

using System.Security.Cryptography;
using System.Security.Permissions;
using System.Data.SqlClient;

using System.ComponentModel;
using System.Web.SessionState;
using System.Drawing.Imaging;
using System.Timers;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

public partial class TTMessage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode = Session["UserCode"].ToString();

        GetUNHandledWorkCount(strUserCode);
    }

    protected void GetUNHandledWorkCount(string strUserCode)
    {
        // 缓存检查：避免每次加载 8 条全表查询（仅需计数无需全量数据）
        string cacheKey = "TTMsg_Counts_" + strUserCode;
        object cached = HttpRuntime.Cache.Get(cacheKey);
        if (cached != null)
        {
            string[] counts = ((string)cached).Split('|');
            if (counts.Length >= 6)
            {
                HL_Collaboration.Text = counts[0] + LanguageHandle.GetWord("Tiao");
                HL_Collaboration.NavigateUrl = "TTCollaborationManage.aspx";
                HL_HeadLine.Text = counts[1] + LanguageHandle.GetWord("Tiao");
                HL_HeadLine.NavigateUrl = "TTHeadLine.aspx";
                HL_UnCheckWL.Text = counts[2] + LanguageHandle.GetWord("Tiao");
                HL_UnCheckWL.NavigateUrl = "TTWLManage.aspx";
                HL_UNReadEMail.Text = counts[3] + LanguageHandle.GetWord("Tiao");
                HL_UNReadEMail.NavigateUrl = "TTMailIndex.aspx";
                HL_UNAttendMeeting.Text = counts[4] + LanguageHandle.GetWord("Tiao");
                HL_UNHandledRisk.Text = counts[5] + LanguageHandle.GetWord("Tiao");
                return;
            }
        }

        string strHQL;
        string[] cachedCounts = new string[6];

        // 改用 COUNT 查询替代加载全部实体
        DataSet dsCount;
        strHQL = "Select COUNT(*) From T_Collaboration where ltrim(rtrim(Status)) <> 'Closed' and CoID in ";
        strHQL += "( select collaborationLog.CoID from T_CollaborationLog collaborationLog,T_CollaborationMember collaborationMember where collaborationLog.CoID = collaborationMember.CoID ";
        strHQL += " and collaborationLog.CreateTime > collaborationMember.LastLoginTime and rtrim(ltrim(collaborationLog.UserCode)) <> '" + strUserCode + "' and rtrim(ltrim(collaborationMember.UserCode))= '" + strUserCode + "')";
        dsCount = ShareClass.GetDataSetFromSql(strHQL, "Count");
        cachedCounts[0] = dsCount.Tables[0].Rows[0][0].ToString();
        HL_Collaboration.Text = cachedCounts[0] + LanguageHandle.GetWord("Tiao");
        HL_Collaboration.NavigateUrl = "TTCollaborationManage.aspx";

        strHQL = "Select COUNT(*) From T_HeadLine";
        dsCount = ShareClass.GetDataSetFromSql(strHQL, "Count");
        cachedCounts[1] = dsCount.Tables[0].Rows[0][0].ToString();
        HL_HeadLine.Text = cachedCounts[1] + LanguageHandle.GetWord("Tiao");
        HL_HeadLine.NavigateUrl = "TTHeadLine.aspx";

        strHQL = "Select COUNT(*) From T_WorkFlowStepDetail where Status in ('InProgress','Reviewing','Signing','ReReview') ";
        strHQL += " and OperatorCode = '" + strUserCode + "'";
        strHQL += " and WLID in (Select WLID from T_WorkFlow where Status not in ('Updating','Closed','CaseClosed'))";
        dsCount = ShareClass.GetDataSetFromSql(strHQL, "Count");
        cachedCounts[2] = dsCount.Tables[0].Rows[0][0].ToString();
        HL_UnCheckWL.Text = cachedCounts[2] + LanguageHandle.GetWord("Tiao");
        HL_UnCheckWL.NavigateUrl = "TTWLManage.aspx";

        strHQL = "Select COUNT(*) From T_Mails where ReaderFlag = 0 and UserCode = '" + strUserCode + "'";
        dsCount = ShareClass.GetDataSetFromSql(strHQL, "Count");
        cachedCounts[3] = dsCount.Tables[0].Rows[0][0].ToString();
        HL_UNReadEMail.Text = cachedCounts[3] + LanguageHandle.GetWord("Tiao");
        HL_UNReadEMail.NavigateUrl = "TTMailIndex.aspx";

        strHQL = "Select COUNT(*) From T_Meeting where ID in ( select MeetingID from T_MeetingAttendant where UserCode = '" + strUserCode + "') and EndTime > now()";
        dsCount = ShareClass.GetDataSetFromSql(strHQL, "Count");
        cachedCounts[4] = dsCount.Tables[0].Rows[0][0].ToString();
        HL_UNAttendMeeting.Text = cachedCounts[4] + LanguageHandle.GetWord("Tiao");

        strHQL = "Select COUNT(*) From T_ProjectRisk where Status not in ('Resolved','Occurred') and ProjectID in (select ProjectID from T_Project where PMCode = '" + strUserCode + "')";
        dsCount = ShareClass.GetDataSetFromSql(strHQL, "Count");
        cachedCounts[5] = dsCount.Tables[0].Rows[0][0].ToString();
        HL_UNHandledRisk.Text = cachedCounts[5] + LanguageHandle.GetWord("Tiao");

        // 写入缓存（3分钟滑动过期）
        HttpRuntime.Cache.Insert(cacheKey, string.Join("|", cachedCounts), null,
            System.Web.Caching.Cache.NoAbsoluteExpiration, TimeSpan.FromMinutes(3));
    }
}
