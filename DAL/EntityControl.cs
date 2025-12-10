using NHibernate;

using Npgsql;//using System.Data.SqlClient;

using System;
using System.Collections;
using System.Configuration;
using System.IO;
using System.Security;
using System.Web;

namespace ProjectMgt.DAL
{
    public class EntityControl
    {
        private static EntityControl entity;

        private string _AssemblyName;

        private static readonly object padlock = new object();

        public static EntityControl CreateEntityControl(string AssemblyName)
        {
            if (entity == null)
            {
                lock (padlock)
                {
                    if (entity == null)
                    {
                        entity = new EntityControl();

                        entity._AssemblyName = AssemblyName;
                    }
                }
            }

            return entity;
        }

        public void AddEntity(Object entity)
        {
            ISession session = SessionFactory.OpenSession(_AssemblyName);

            ITransaction transaction = session.BeginTransaction();

            try
            {
                session.Save(entity);

                transaction.Commit();


                //---保存用户操作日志到日志表----
                InsertUserOperateLog("Add Record " + entity.ToString());



            }
            catch (Exception ex)
            {
                transaction.Rollback();

                throw ex;
            }
            finally
            {
                session.Close();
            }
        }

        public void UpdateEntity(Object entity, Object key)
        {
            ISession session = SessionFactory.OpenSession(_AssemblyName);

            ITransaction transaction = session.BeginTransaction();

            try
            {
                session.Update(entity, key);


                transaction.Commit();

                //---保存用户操作日志到日志表----
                InsertUserOperateLog("Update Record " + entity.ToString() + "," + " The Key is " + key.ToString());
            }
            catch (Exception ex)
            {
                transaction.Rollback();

                throw ex;
            }
            finally
            {
                session.Close();
            }
        }

        public void DeleteEntity(object entity)
        {
            ISession session = SessionFactory.OpenSession(_AssemblyName);

            ITransaction transaction = session.BeginTransaction();

            try
            {
                session.Delete(entity);

                transaction.Commit();

                //---保存用户操作日志到日志表----
                InsertUserOperateLog("Delete Record " + entity.ToString());
            }
            catch (Exception ex)
            {
                transaction.Rollback();

                throw ex;
            }
            finally
            {
                session.Close();
            }
        }


        public IList GetEntities(string strHQL)
        {
            IList lst;
            ISession session = SessionFactory.OpenSession(_AssemblyName);

            try
            {
                // 多层防护
                string safeHQL = ApplyHQLSecurity(strHQL);

                lst = session.CreateQuery(safeHQL).List();
            }
            catch (NHibernate.Hql.Ast.ANTLR.QuerySyntaxException ex)
            {
                // 如果转义导致语法错误，记录并抛出安全异常
                WriteLogFile("Error page: " + "\n" + ex.Message.ToString() + "\n" + ex.StackTrace + ",\n HQL syntax security validation failed" + ex.Message.ToString() + ",Sql: \n" + strHQL);
                throw new SecurityException("HQL syntax security validation failed", ex);

            }
            finally
            {
                session.Close();
            }

            InsertUserOperateLog(strHQL);
            return lst;
        }

        // 综合安全处理
        private string ApplyHQLSecurity(string hql)
        {
            if (string.IsNullOrEmpty(hql))
                return hql;

            // 1. 基础验证
            if (hql.Length > 10000) // 防止超长查询
            {
                WriteLogFile("ErrorMsg =" + "HQL Statement Is Too Long,Hql:" + hql);
                throw new SecurityException("HQL Statement Is Too Long");
            }

            // 2. 危险操作检测
            ValidateDangerousOperations(hql);

            // 3. 字符串转义
            string safeHql = EscapeStringLiterals(hql);

            // 4. 注释清理
            safeHql = RemoveSqlComments(safeHql);

            return safeHql;
        }

        // 转义字符串常量
        private string EscapeStringLiterals(string hql)
        {
            return System.Text.RegularExpressions.Regex.Replace(hql,
                @"'([^']*)'",
                match =>
                {
                    string innerValue = match.Groups[1].Value;
                    // 多层转义防护
                    string escaped = innerValue
                        .Replace("'", "''")  // 转义单引号
                        .Replace(";", "")    // 移除分号
                        .Replace("--", "")   // 移除SQL注释
                        .Replace("/*", "")   // 移除多行注释开始
                        .Replace("*/", "");  // 移除多行注释结束
                    return $"'{escaped}'";
                });
        }

        // 移除SQL注释
        private string RemoveSqlComments(string hql)
        {
            string noComments = System.Text.RegularExpressions.Regex.Replace(hql, @"--.*$", "",
                System.Text.RegularExpressions.RegexOptions.Multiline);
            noComments = System.Text.RegularExpressions.Regex.Replace(noComments, @"/\*.*?\*/", "",
                System.Text.RegularExpressions.RegexOptions.Singleline);
            return noComments;
        }

        // 验证危险操作
        private void ValidateDangerousOperations(string hql)
        {
            string upperHql = hql.ToUpper();

            var dangerousKeywords = new[]
            {
        "DROP ", "DELETE ", "UPDATE ", "INSERT ", "EXEC ", "EXECUTE ",
        "TRUNCATE ", "CREATE ", "ALTER ", "SHUTDOWN ", "GRANT ", "REVOKE ",
        "XP_", "SP_", "DBCC ", "BULK ", "CHECKPOINT ", "BACKUP ", "RESTORE "
    };

            foreach (var keyword in dangerousKeywords)
            {
                if (upperHql.Contains(keyword))
                {
                    WriteLogFile("Dangerous Operation Detected:" + keyword.Trim());
                    throw new SecurityException($"Dangerous Operation Detected: {keyword.Trim()}");
                }
            }
        }

        #region ---自加代码-----------------------------------------------------------

        //保存用户操作日志到日志表
        public void InsertUserOperateLog(string strHQL)
        {
            string strSQL, strHQL1, strHQL2;
            string strUserCode, strUserName, strUserIP;

            try
            {
                if (System.Configuration.ConfigurationManager.AppSettings["SaveOperateLog"] == "YES")
                {
                    try
                    {
                        if (strHQL.IndexOf("BySystem") == -1 & strHQL.IndexOf("LicenseVerification") == -1)
                        {
                            if (HttpContext.Current.Session["UserCode"] != null & HttpContext.Current.Session["UserName"] != null)
                            {
                                strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();
                                strUserName = HttpContext.Current.Session["UserName"].ToString().Trim();

                                strUserIP = HttpContext.Current.Request.UserHostAddress.Trim();

                                strHQL1 = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
                                strHQL1 = strHQL1.Replace(" ", "").ToUpper();
                                strHQL2 = strHQL.Replace(" ", "").ToUpper();

                                if (strHQL1 != strHQL2)
                                {
                                    strHQL = strHQL.Replace("'", "''");

                                    new System.Threading.Thread(delegate ()
                                    {
                                        try
                                        {
                                            strSQL = "Insert into T_UserOperateLog(UserCode,UserName,UserIP,OperateContent,OperateTime) ";
                                            strSQL += " Values(" + "'" + strUserCode + "'" + "," + "'" + strUserName + "'" + "," + "'" + strUserIP + "'" + "," + "'" + strHQL + "'" + ",now())";

                                            RunSqlCommand(strSQL);
                                        }
                                        catch
                                        {
                                        }
                                    }).Start();

                                }
                            }
                        }
                    }
                    catch
                    {
                    }
                }
            }
            catch
            {

            }
        }

        //运行SQL语句
        public static void RunSqlCommand(string strCmdText)
        {
            using (NpgsqlConnection myConnection = new NpgsqlConnection(
                   ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString))
            {

                ///创建Command
                NpgsqlCommand myCommand = new NpgsqlCommand(strCmdText, myConnection);
                myCommand.CommandTimeout = 600;

                ///打开链接
                myConnection.Open();

                myCommand.ExecuteNonQuery();

                myConnection.Close();

                if (myCommand != null)
                {
                    myCommand.Dispose();
                }
            }
        }

        #endregion ---自加代码-----------------------------------------------------------


        public static void WriteLogFile(string input)
        {
            /**/
            ///指定日志文件的目录
            ///

            //string strLogDirectory = HttpContext.Current.Server.MapPath(HttpContext.Current.Server.MapPath("Doc") + "\\Log");
            //ShareClass.CreateDirectory(strLogDirectory);

            string fname;


            fname = HttpContext.Current.Server.MapPath("Doc") + "\\Log\\LogFile.txt";
            /**/
            ///定义文件信息对象

            FileInfo finfo = new FileInfo(fname);
            if (!finfo.Exists)
            {
                CreateDirectory(HttpContext.Current.Server.MapPath("Doc") + "\\Log");

                FileStream fs;
                fs = File.Create(fname);
                fs.Close();
                finfo = new FileInfo(fname);
            }

            try
            {
                /**/
                ///判断文件是否存在以及是否大于2K
                if (finfo.Length > 1024 * 1024 * 10)
                {
                    /**/
                    ///文件超过10MB则重命名
                    File.Move(fname, HttpContext.Current.Server.MapPath("Doc") + "\\Log\\" + "BackupLogFile" + DateTime.Now.ToString("yyyyMMddHHMMssff") + ".txt");

                    /**/
                    ///删除该文件
                    //finfo.Delete();
                }
            }
            catch
            {
            }
            //finfo.AppendText();
            /**/
            ///创建只写文件流

            using (FileStream fs = finfo.OpenWrite())
            {
                /**/
                ///根据上面创建的文件流创建写数据流
                StreamWriter w = new StreamWriter(fs);

                /**/
                ///设置写数据流的起始位置为文件流的末尾
                w.BaseStream.Seek(0, SeekOrigin.End);

                /**/
                ///写入“Log Entry : ”
                w.Write("\n\rLog Entry : ");

                /**/
                ///写入当前系统时间并换行
                w.Write("{0} {1} \n\r", DateTime.Now.ToLongTimeString(),
                    DateTime.Now.ToLongDateString());

                /**/
                ///写入日志内容并换行
                w.Write(input + "\n\r");

                /**/
                ///写入------------------------------------“并换行
                w.Write("\n\r------------------------------------\n\r");

                /**/
                ///清空缓冲区内容，并把缓冲区内容写入基础流
                w.Flush();

                /**/
                ///关闭写数据流
                w.Close();
            }
        }

        public static int CreateDirectory(string strDirectory)
        {
            DirectoryInfo NewDirInfo;

            if (!Directory.Exists(strDirectory))
            {
                try
                {
                    Directory.CreateDirectory(strDirectory);
                    NewDirInfo = new DirectoryInfo(strDirectory);
                    NewDirInfo.Attributes = FileAttributes.Normal;
                    return 1;
                }
                catch
                {
                    return 2;
                }
            }
            else
            {
                return 3;
            }
        }
    }
}