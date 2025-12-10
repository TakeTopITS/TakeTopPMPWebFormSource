using System;
using System.Collections;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.IO;
using System.Web.UI;

using System.Xml;

using ProjectMgt.BLL;
using ProjectMgt.Model;

using TakeTopCore;

using TakeTopSecurity;
using System.Web;
using com.sun.source.tree;
using Npgsql;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public partial class TakeTopUpgradeDatabase : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack != true)
        {
            //try
            //{
            //    //补齐系统启动所需要的数据表缺的字段
            //    string strHQL;

            //    strHQL = "Alter Table T_SystemActiveUser Add WebUser char(10) Default 'NO'";
            //    ShareClass.RunSqlCommand(strHQL);
            //    strHQL = "Update T_SystemActiveUser Set WebUser = 'YES'";
            //    ShareClass.RunSqlCommand(strHQL);
            //}
            //catch (Exception err)
            //{
            //    //LogClass.WriteLogFile(err.Message.ToString());
            //}
        }
    }

    protected void IMB_Logo_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (ShareClass.SystemDBer == "")
            {
                ShareClass.SystemDBer = "DBer";

                //如果存在升级语句，那么升级数据库
                TakeTopCore.CoreShareClass.UpgradeDataBase();
                LogClass.WriteLogFile("Upgrade database successfully!");
            }
        }
        catch
        {
            try
            {
                TakeTopCore.CoreShareClass.UpgradeDataBase();
                LogClass.WriteLogFile("Upgrade database successfully again!");
            }
            catch (Exception err2)
            {
                LogClass.WriteLogFile(err2.Message.ToString());
            }
        }
    }

}

