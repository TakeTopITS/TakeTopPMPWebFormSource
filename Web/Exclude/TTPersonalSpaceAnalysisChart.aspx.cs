using Npgsql;

using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTPersonalSpaceAnalysisChart : System.Web.UI.Page
{
    // 从Web.config获取PostgreSQL连接字符串
    private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            AsyncWork();
        }
    }

    private void AsyncWork()
    {
        string chartStringFromDb = GetChartStringFromDatabase(Session["UserCode"].ToString());
        if (string.IsNullOrEmpty(chartStringFromDb))
        {
            litSystemAnalystChartHTML.Visible = false;

            DataSet ds = ShareClass.GetSytemChartDataSet(Session["UserCode"].ToString(), "PersonalSpacePage");

            //LogClass.WriteLogFile("DataSet行数: " + (ds.Tables.Count > 0 ? ds.Tables[0].Rows.Count.ToString() : "0"));

            // 绑定第一个Repeater
            RP_ChartList.DataSource = ds;
            RP_ChartList.DataBind();

            // 调用函数，将DataSet序列化并存入数据库
            SaveChartStringToDatabase(Session["UserCode"].ToString(), ds);
        }
        else
        {
            DataSet ds = ShareClass.DeserializeStringToDataSet(chartStringFromDb);
            if (ds != null)
            {
                // 绑定第一个Repeater
                RP_ChartList.DataSource = ds;
                RP_ChartList.DataBind();
            }
            else
            {
                //LogClass.WriteLogFile("反序列化失败，重新生成数据");
                // 反序列化失败，重新生成
                litSystemAnalystChartHTML.Visible = false;
                DataSet dsNew = ShareClass.GetSytemChartDataSet(Session["UserCode"].ToString(), "PersonalSpacePage");
                RP_ChartList.DataSource = dsNew;
                RP_ChartList.DataBind();
                SaveChartStringToDatabase(Session["UserCode"].ToString(), dsNew);
            }
        }
    }

    /// <summary>
    /// 将DataSet序列化为字符串并保存到数据库表t_memberchartstringformainpage的analystchartstring字段
    /// </summary>
    /// <param name="strUserCode">用户代码</param>
    /// <param name="ds">要序列化的DataSet</param>
    private void SaveChartStringToDatabase(string strUserCode, DataSet ds)
    {
        try
        {
            // 将DataSet序列化为字符串
            string serializedDataSet = ShareClass.SerializeDataSetToString(ds);

            //// 记录序列化后的长度，用于调试
            //LogClass.WriteLogFile($"序列化后字符串长度: {serializedDataSet.Length}");

            using (var conn = new NpgsqlConnection(connectionString))
            {
                conn.Open();

                // 检查记录是否存在
                string checkSql = @"SELECT COUNT(*) FROM public.t_memberchartstringformainpage 
                                   WHERE usercode = @usercode";

                using (var cmd = new NpgsqlCommand(checkSql, conn))
                {
                    cmd.Parameters.AddWithValue("@usercode", strUserCode);
                    int count = Convert.ToInt32(cmd.ExecuteScalar());

                    //LogClass.WriteLogFile($"检查记录结果: UserCode={strUserCode}, 记录数={count}");

                    if (count == 0)
                    {
                        // 记录不存在，插入新记录
                        string insertSql = @"INSERT INTO public.t_memberchartstringformainpage 
                                            (usercode, analystchartstring, moduleflowchartstring) 
                                            VALUES (@usercode, @analystchartstring, @moduleflowchartstring)";

                        using (var insertCmd = new NpgsqlCommand(insertSql, conn))
                        {
                            insertCmd.Parameters.AddWithValue("@usercode", strUserCode);
                            insertCmd.Parameters.AddWithValue("@analystchartstring", NpgsqlTypes.NpgsqlDbType.Text, serializedDataSet);
                            insertCmd.Parameters.AddWithValue("@moduleflowchartstring", "");

                            int rowsAffected = insertCmd.ExecuteNonQuery();
                            //LogClass.WriteLogFile($"插入记录成功，影响行数: {rowsAffected}");
                        }
                    }
                    else
                    {
                        // 记录存在，更新AnalystChartString字段
                        string updateSql = @"UPDATE public.t_memberchartstringformainpage 
                                            SET analystchartstring = @analystchartstring
                                            WHERE usercode = @usercode";

                        using (var updateCmd = new NpgsqlCommand(updateSql, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@analystchartstring", NpgsqlTypes.NpgsqlDbType.Text, serializedDataSet);
                            updateCmd.Parameters.AddWithValue("@usercode", strUserCode);

                            int rowsAffected = updateCmd.ExecuteNonQuery();
                            //LogClass.WriteLogFile($"AnalystChart更新记录成功，影响行数: {rowsAffected}");
                        }
                    }
                }
            }

            //LogClass.WriteLogFile("AnalystChart数据保存成功，UserCode: " + strUserCode);
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("SaveChartStringToDatabase错误: " + ex.Message.ToString());
            if (ex.InnerException != null)
            {
                LogClass.WriteLogFile("内部错误: " + ex.InnerException.Message.ToString());
            }
        }
    }

    /// <summary>
    /// 从数据库获取analystchartstring字段的值
    /// </summary>
    /// <param name="strUserCode">用户代码</param>
    /// <returns>analystchartstring字段的值</returns>
    private string GetChartStringFromDatabase(string strUserCode)
    {
        try
        {
            using (var conn = new NpgsqlConnection(connectionString))
            {
                conn.Open();

                // 使用参数化查询
                string selectSql = @"SELECT analystchartstring FROM public.t_memberchartstringformainpage 
                                    WHERE usercode = @usercode";

                using (var cmd = new NpgsqlCommand(selectSql, conn))
                {
                    cmd.Parameters.AddWithValue("@usercode", strUserCode);

                    var result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        string resultString = result.ToString();
                        //LogClass.WriteLogFile($"从数据库读取成功，UserCode={strUserCode}, 数据长度={resultString.Length}");

                        // 检查是否有乱码（简单检查：是否包含有效的XML标签）
                        if (resultString.Contains("<NewDataSet>") && resultString.Contains("</NewDataSet>"))
                        {
                            //LogClass.WriteLogFile("数据格式验证通过，包含有效的XML标记");
                        }
                        else
                        {
                            LogClass.WriteLogFile("警告：数据可能不完整或格式不正确");
                        }

                        return resultString;
                    }
                    else
                    {
                        //LogClass.WriteLogFile($"数据库中没有找到UserCode={strUserCode}的记录");
                        return string.Empty;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("GetChartStringFromDatabase错误: " + ex.Message.ToString());
            if (ex.InnerException != null)
            {
                LogClass.WriteLogFile("内部错误: " + ex.InnerException.Message.ToString());
            }
            return string.Empty;
        }
    }
}