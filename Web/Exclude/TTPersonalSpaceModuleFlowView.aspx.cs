using Npgsql;

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTPersonalSpaceModuleFlowView : System.Web.UI.Page
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
        string moduleFlowStringFromDb = GetModuleFlowStringFromDatabase(Session["UserCode"].ToString());

        if (string.IsNullOrEmpty(moduleFlowStringFromDb))
        {
            litIframeModuleFlowHTML.Visible = false;

            DataSet dsModuleFlow = ShareClass.GetSystemModuleFlowDataSet("OperateNavigation", Session["UserCode"].ToString(), Session["UserType"].ToString(), Session["LangCode"].ToString());

            LogClass.WriteLogFile("DataSet行数: " + (dsModuleFlow.Tables.Count > 0 ? dsModuleFlow.Tables[0].Rows.Count.ToString() : "0"));

            // 绑定Repeater
            RP_iframeModuleFlow.DataSource = dsModuleFlow;
            RP_iframeModuleFlow.DataBind();

            // 调用函数，将DataSet序列化并存入数据库的moduleflowchartstring字段
            SaveModuleFlowStringToDatabase(Session["UserCode"].ToString(), dsModuleFlow);
        }
        else
        {
            DataSet dsModuleFlow = DeserializeStringToDataSet(moduleFlowStringFromDb);

            if (dsModuleFlow != null)
            {
                // 绑定Repeater
                RP_iframeModuleFlow.DataSource = dsModuleFlow;
                RP_iframeModuleFlow.DataBind();
            }
            else
            {
                LogClass.WriteLogFile("反序列化失败，重新生成数据");
                // 反序列化失败，重新生成
                litIframeModuleFlowHTML.Visible = false;
                DataSet dsNew = ShareClass.GetSystemModuleFlowDataSet("OperateNavigation", Session["UserCode"].ToString(), Session["UserType"].ToString(), Session["LangCode"].ToString());
                RP_iframeModuleFlow.DataSource = dsNew;
                RP_iframeModuleFlow.DataBind();
                SaveModuleFlowStringToDatabase(Session["UserCode"].ToString(), dsNew);
            }
        }
    }

    /// <summary>
    /// 将DataSet序列化为字符串并保存到数据库表t_memberchartstringformainpage的moduleflowchartstring字段
    /// </summary>
    /// <param name="strUserCode">用户代码</param>
    /// <param name="ds">要序列化的DataSet</param>
    private void SaveModuleFlowStringToDatabase(string strUserCode, DataSet ds)
    {
        try
        {
            // 将DataSet序列化为字符串
            string serializedDataSet = SerializeDataSetToString(ds);

            // 记录序列化后的长度，用于调试
            LogClass.WriteLogFile($"序列化后字符串长度: {serializedDataSet.Length}");

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

                    LogClass.WriteLogFile($"检查记录结果: UserCode={strUserCode}, 记录数={count}");

                    if (count == 0)
                    {
                        // 记录不存在，插入新记录（注意：这里analystchartstring字段传入空字符串）
                        string insertSql = @"INSERT INTO public.t_memberchartstringformainpage 
                                            (usercode, analystchartstring, moduleflowchartstring) 
                                            VALUES (@usercode, @analystchartstring, @moduleflowchartstring)";

                        using (var insertCmd = new NpgsqlCommand(insertSql, conn))
                        {
                            insertCmd.Parameters.AddWithValue("@usercode", strUserCode);
                            insertCmd.Parameters.AddWithValue("@analystchartstring", "");
                            insertCmd.Parameters.AddWithValue("@moduleflowchartstring", NpgsqlTypes.NpgsqlDbType.Text, serializedDataSet);

                            int rowsAffected = insertCmd.ExecuteNonQuery();
                            LogClass.WriteLogFile($"ModuleFlow插入记录成功，影响行数: {rowsAffected}");
                        }
                    }
                    else
                    {
                        // 记录存在，更新moduleflowchartstring字段
                        string updateSql = @"UPDATE public.t_memberchartstringformainpage 
                                            SET moduleflowchartstring = @moduleflowchartstring
                                            WHERE usercode = @usercode";

                        using (var updateCmd = new NpgsqlCommand(updateSql, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@moduleflowchartstring", NpgsqlTypes.NpgsqlDbType.Text, serializedDataSet);
                            updateCmd.Parameters.AddWithValue("@usercode", strUserCode);

                            int rowsAffected = updateCmd.ExecuteNonQuery();
                            LogClass.WriteLogFile($"ModuleFlow更新记录成功，影响行数: {rowsAffected}");
                        }
                    }
                }
            }

            LogClass.WriteLogFile("ModuleFlow数据保存成功，UserCode: " + strUserCode);
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("SaveModuleFlowStringToDatabase错误: " + ex.Message.ToString());
            if (ex.InnerException != null)
            {
                LogClass.WriteLogFile("内部错误: " + ex.InnerException.Message.ToString());
            }
        }
    }

    /// <summary>
    /// 从数据库获取moduleflowchartstring字段的值
    /// </summary>
    /// <param name="strUserCode">用户代码</param>
    /// <returns>moduleflowchartstring字段的值</returns>
    private string GetModuleFlowStringFromDatabase(string strUserCode)
    {
        try
        {
            using (var conn = new NpgsqlConnection(connectionString))
            {
                conn.Open();

                // 使用参数化查询
                string selectSql = @"SELECT moduleflowchartstring FROM public.t_memberchartstringformainpage 
                                    WHERE usercode = @usercode";

                using (var cmd = new NpgsqlCommand(selectSql, conn))
                {
                    cmd.Parameters.AddWithValue("@usercode", strUserCode);

                    var result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        string resultString = result.ToString();
                        LogClass.WriteLogFile($"从数据库读取成功，UserCode={strUserCode}, 数据长度={resultString.Length}");

                        // 检查是否有乱码（简单检查：是否包含有效的XML标签）
                        if (resultString.Contains("<NewDataSet>") && resultString.Contains("</NewDataSet>"))
                        {
                            LogClass.WriteLogFile("数据格式验证通过，包含有效的XML标记");
                        }
                        else
                        {
                            LogClass.WriteLogFile("警告：数据可能不完整或格式不正确");
                        }

                        return resultString;
                    }
                    else
                    {
                        LogClass.WriteLogFile($"数据库中没有找到UserCode={strUserCode}的记录");
                        return string.Empty;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("GetModuleFlowStringFromDatabase错误: " + ex.Message.ToString());
            if (ex.InnerException != null)
            {
                LogClass.WriteLogFile("内部错误: " + ex.InnerException.Message.ToString());
            }
            return string.Empty;
        }
    }

    /// <summary>
    /// 将DataSet序列化为XML字符串
    /// </summary>
    /// <param name="ds">要序列化的DataSet</param>
    /// <returns>序列化后的XML字符串</returns>
    private string SerializeDataSetToString(DataSet ds)
    {
        if (ds == null)
        {
            LogClass.WriteLogFile("序列化失败：DataSet为空");
            return string.Empty;
        }

        try
        {
            using (StringWriter sw = new StringWriter())
            {
                ds.WriteXml(sw, XmlWriteMode.IgnoreSchema);
                string xmlString = sw.ToString();

                // 记录前100个字符用于调试
                string preview = xmlString.Length > 100 ? xmlString.Substring(0, 100) + "..." : xmlString;
                LogClass.WriteLogFile($"序列化成功，长度={xmlString.Length}，预览={preview}");

                return xmlString;
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("DataSet序列化失败: " + ex.Message.ToString());
            return string.Empty;
        }
    }

    /// <summary>
    /// 从字符串反序列化为DataSet
    /// </summary>
    /// <param name="xmlString">XML字符串</param>
    /// <returns>反序列化后的DataSet</returns>
    private DataSet DeserializeStringToDataSet(string xmlString)
    {
        if (string.IsNullOrEmpty(xmlString))
        {
            LogClass.WriteLogFile("反序列化失败：XML字符串为空");
            return null;
        }

        try
        {
            // 记录前100个字符用于调试
            string preview = xmlString.Length > 100 ? xmlString.Substring(0, 100) + "..." : xmlString;
            LogClass.WriteLogFile($"开始反序列化，长度={xmlString.Length}，预览={preview}");

            DataSet ds = new DataSet();
            using (StringReader sr = new StringReader(xmlString))
            {
                ds.ReadXml(sr);
            }

            LogClass.WriteLogFile($"反序列化成功，表数量={ds.Tables.Count}");
            if (ds.Tables.Count > 0)
            {
                LogClass.WriteLogFile($"第一个表行数={ds.Tables[0].Rows.Count}");
            }

            return ds;
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("字符串反序列化为DataSet失败: " + ex.Message.ToString());
            return null;
        }
    }
}